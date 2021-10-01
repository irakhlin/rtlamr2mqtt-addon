#!/usr/bin/env bashio

CONFIG="/data/rtlamr2mqtt.yaml"

bashio::log.info "Creating rtlamr2mqtt configuration..."

bashio::log.info "Writing General config"
for general in $(bashio::config 'general|keys'); do
  SLEEP_FOR=$(bashio::config "general[${general}].sleep_for")
  MODE=$(bashio::config "general[${general}].mode")
  DEBUG=$(bashio::config "general[${general}].debug")
  
  {
      echo "general:"
      echo "  sleep_for: ${SLEEP_FOR}"
      echo "  mode: ${MODE}"
      echo "  debug: ${DEBUG}"
  } > "${CONFIG}"
done

bashio::log.info "Writing MQTT config"
for mqtt in $(bashio::config 'mqtts|keys'); do
  MQTT_HOST=$(bashio::config "mqtts[${mqtt}].host")
  MQTT_PORT=$(bashio::config "mqtts[${mqtt}].port")
  MQTT_USER=$(bashio::config "mqtts[${mqtt}].user")
  MQTT_PASSWORD=$(bashio::config "mqtts[${mqtt}].password")
  MQTT_DISCOVERY=$(bashio::config "mqtts[${mqtt}].ha_autodiscovery")
  MQTT_TOPIC=$(bashio::config "mqtts[${mqtt}].ha_autodiscovery_topic")
  {
      echo "mqtt:"
      echo "  host: ${MQTT_HOST}"
      echo "  port: ${MQTT_PORT}"
      echo "  user: ${MQTT_USER}"
      echo "  password: ${MQTT_PASSWORD}"
      echo "  ha_autodiscovery: ${MQTT_DISCOVERY}"
      echo "  ha_autodiscovery_topic: ${MQTT_TOPIC}"
  } >> "${CONFIG}"
done

for rtl in $(bashio::config 'rtls|keys'); do
  RTL_TCP=$(bashio::config "rtls[${rtl}].rtltcp")
  RTL_AMR=$(bashio::config "rtls[${rtl}].rtlamr")
  {
      echo "rtl:"
      echo "  rtltcp: \"${RTL_TCP}\""
      echo "  rtlamr: \"${RTL_AMR}\""
  } >> "${CONFIG}"
done

for meter in $(bashio::config 'meters|keys'); do
  METER_ID=$(bashio::config "meters[${meter}].host")
  METER_PROTOCOL=$(bashio::config "meters[${meter}].port")
  METER_NAME=$(bashio::config "meters[${meter}].user")
  METER_FORMAT=$(bashio::config "meters[${meter}].password")
  METER_UNIT=$(bashio::config "meters[${meter}].ha_autodiscovery")
  METER_ICON=$(bashio::config "meters[${meter}].ha_autodiscovery_topic")
  {
      echo "meters:"
      echo "  - id: ${METER_ID}"
      echo "    protocol: ${METER_PROTOCOL}"
      echo "    name: ${METER_NAME}"
      echo "    format: \"${METER_FORMAT}\""
      echo "    unit_of_measurement: ${METER_UNIT}"
      echo "    icon: ${METER_ICON}"
  } >> "${CONFIG}"
done
    
bashio::log.info "Starting rtlamr2mqtt server..."
exec /usr/bin/rtlamr2mqtt.py /data/rtlamr2mqtt.yaml