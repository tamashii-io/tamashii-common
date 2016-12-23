module Codeme
  module Type
    # System Action
    POWEROFF = 000
    REBOOT = 001

    # Authorization Action
    AUTH_TOKEN = 010
    AUTH_RESPONSE = 017

    # Card Reader Action
    RFID_NUMBER = 030
    RFID_DATA = 031
    RFID_RESPONSE_JSON = 036
    RFID_RESPONSE_STRING = 047

    # Buzzer Action
    BUZZER_SOUND = 040
  end
end
