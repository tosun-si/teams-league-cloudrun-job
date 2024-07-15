import dataclasses
import json
import os
import pathlib
from datetime import datetime
from typing import Dict, List

from google.cloud import bigquery
from google.cloud import storage
from toolz.curried import pipe, map

from team_league.job.domain.team_stats import TeamStats
from team_league.job.domain.team_stats_raw import TeamStatsRaw

current_iso_datetime = datetime.now().isoformat()

TEAM_SLOGANS = {
    "PSG": "Paris is magic",
    "Real": "Hala Madrid",
    "Chelsea": "Go Blues",
    "Juventus": "The old lady",
    "Barcelona": "The Macia",
    "Manchester City": "The Sky Blues",
    "Bayern": "The german ogre",
    "Liverpool": "You will never walk alone"
}


def add_ingestion_date_to_team_stats(team_stats_domain: Dict) -> Dict:
    team_stats_domain.update({'ingestionDate': current_iso_datetime})

    return team_stats_domain


def deserialize(team_stats_raw_as_dict: Dict) -> TeamStatsRaw:
    from dacite import from_dict
    return from_dict(
        data_class=TeamStatsRaw,
        data=team_stats_raw_as_dict
    )


def ingest_team_stats_data_to_bigquery() -> None:
    project_id = os.environ.get('PROJECT_ID', 'PROJECT_ID env var is not set.')
    output_dataset = os.environ.get('OUTPUT_DATASET', 'OUTPUT_DATASET env var is not set.')
    output_table = os.environ.get('OUTPUT_TABLE', 'OUTPUT_TABLE env var is not set.')
    input_bucket = os.environ.get('INPUT_BUCKET', 'INPUT_BUCKET env var is not set.')
    input_object = os.environ.get('INPUT_OBJECT', 'INPUT_OBJECT env var is not set.')

    table_id = f'{project_id}.{output_dataset}.{output_table}'

    bigquery_client = bigquery.Client(project=project_id)
    storage_client = storage.Client(project=project_id)

    bucket = storage_client.get_bucket(input_bucket)
    blob = bucket.get_blob(input_object)
    team_stats_raw_list_as_bytes = blob.download_as_bytes()

    team_stats_domains: List[Dict] = list(pipe(
        team_stats_raw_list_as_bytes.strip().split(b'\n'),
        map(lambda team_stats_bytes: json.loads(team_stats_bytes.decode('utf-8'))),
        map(deserialize),
        map(TeamStats.compute_team_stats),
        map(lambda team_stats: team_stats.add_slogan_to_stats(TEAM_SLOGANS)),
        map(dataclasses.asdict),
        map(add_ingestion_date_to_team_stats)
    ))

    current_directory = pathlib.Path(__file__).parent
    schema_path = str(current_directory / "schema/team_stats.json")

    schema = bigquery_client.schema_from_json(schema_path)

    job_config = bigquery.LoadJobConfig(
        create_disposition=bigquery.CreateDisposition.CREATE_NEVER,
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
        schema=schema,
        source_format=bigquery.SourceFormat.NEWLINE_DELIMITED_JSON
    )

    load_job = bigquery_client.load_table_from_json(
        json_rows=team_stats_domains,
        destination=table_id,
        job_config=job_config
    )

    load_job.result()

    print("#######The GCS Raw file was correctly loaded to the BigQuery table#######")


if __name__ == '__main__':
    ingest_team_stats_data_to_bigquery()
