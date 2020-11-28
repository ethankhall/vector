package metadata

components: sinks: azure_monitor_logs: {
	title:       "Azure Monitor Logs"
	description: """
		[Azure Monitor](\(urls.azure_monitor)) is a service in Azure that provides performance and
		availability monitoring for applications and services in Azure, other cloud environments,
		or on-premises. Azure Monitor collects data from multiple sources into a common data
		platform where it can be analyzed for trends and anomalies.
		"""

	classes: {
		commonly_used: false
		delivery:      "at_least_once"
		development:   "beta"
		egress_method: "batch"
		service_providers: ["Azure"]
	}

	features: {
		buffer: enabled:      true
		healthcheck: enabled: true
		send: {
			batch: {
				enabled:      true
				common:       false
				max_bytes:    30000000
				max_events:   null
				timeout_secs: 1
			}
			compression: enabled: false
			encoding: {
				enabled: true
				codec: enabled: false
			}
			request: enabled: false
			tls: {
				enabled:                true
				can_enable:             true
				can_verify_certificate: true
				can_verify_hostname:    true
				enabled_default:        true
			}
			to: {
				service: services.azure_monitor_logs

				interface: {
					socket: {
						api: {
							title: "Azure Monitor logs API"
							url:   urls.azure_monitor_logs_endpoints
						}
						direction: "outgoing"
						protocols: ["http"]
						ssl: "required"
					}
				}
			}
		}
	}

	support: {
		targets: {
			"aarch64-unknown-linux-gnu":  true
			"aarch64-unknown-linux-musl": true
			"x86_64-apple-darwin":        true
			"x86_64-pc-windows-msv":      true
			"x86_64-unknown-linux-gnu":   true
			"x86_64-unknown-linux-musl":  true
		}

		requirements: []
		warnings: []
		notices: []
	}

	configuration: {
		azure_resource_id: {
			common:      true
			description: """
				[Resource ID](\(urls.azure_monitor_resource_id)) of the Azure resource the data is
				associated with.
				"""
			required:    false
			warnings: []
			type: string: {
				default: null
				examples: [
					"/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/otherResourceGroup/providers/Microsoft.Storage/storageAccounts/examplestorage",
					"/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/examplegroup/providers/Microsoft.SQL/servers/serverName/databases/databaseName",
				]
			}
		}
		customer_id: {
			description: """
				The [unique identifier](\(urls.azure_monitor_unique_id)) for the Log Analytics workspace.
				"""
			required:    true
			warnings: []
			type: string: {
				examples: [
					"5ce893d9-2c32-4b6c-91a9-b0887c2de2d6",
					"97ce69d9-b4be-4241-8dbd-d265edcf06c4",
				]
			}
		}
		host: {
			common:      true
			description: """
				[Alternative host](\(urls.azure_monitor_alternative_host)) for dedicated Azure regions.
				"""
			required:    false
			warnings: []
			type: string: {
				default: "ods.opinsights.azure.com"
				examples: ["ods.opinsights.azure.us", "ods.opinsights.azure.cn"]
			}
		}
		log_type: {
			description: """
				The [record type of the data that is being
				submitted](\(urls.azure_monitor_resource_id)). The type name can only contain
				letters, numbers, and underscore (`_`) and may not exceed 100 characters.
				"""
			required:    true
			warnings: []
			type: string: {
				examples: ["MyTableName", "MyRecordType"]
			}
		}
		shared_key: {
			description: """
				The [primary or the secondary key](\(urls.azure_monitor_authorization)) for the Log
				Analytics workspace.
				"""
			required:    true
			warnings: []
			type: string: {
				examples: [
					"${AZURE_MONITOR_SHARED_KEY_ENV_VAR}",
					"SERsIYhgMVlJB6uPsq49gCxNiruf6v0vhMYE+lfzbSGcXjdViZdV/e5pEMTYtw9f8SkVLf4LFlLCc2KxtRZfCA==",
				]
			}
		}
	}

	input: {
		logs:    true
		metrics: null
	}
}
