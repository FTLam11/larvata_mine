require "larvata_mine/issue_decorator"

module LarvataMine
  class MaintenanceDecorator < IssueDecorator
    def project_id
      "s-maintenance"
    end

    def tracker_id
      4
    end

    def status_id
      1
    end

    def subject
      "[#{maintenance_number} - #{property_name} #{unit_number}]"
    end

    def description
      main_description << child_descriptions
    end

    def assigned_to_id
      1
    end

    def custom_fields
      [
        {
          id: 1,
          name: "maintenance_number",
          value: maintenance_number,
        },
        {
          id: 2,
          name: "maintenance_typing",
          value: maintenance.typing_i18n,
        },
        {
          id: 3,
          name: "property_name",
          value: property_name,
        },
        {
          id: 4,
          name: "unit_number",
          value: unit_number,
        },
        {
          id: 5,
          name: "customer_name",
          value: customer_name,
        },
      ]
    end

    def as_json(*)
      {
        project_id: project_id,
        tracker_id: tracker_id,
        status_id: 1,
        subject: subject,
        description: description,
        assigned_to_id: assigned_to_id,
        custom_fields: custom_fields,
      }
    end

    private

    def main_description
      <<~TEXT
        【修繕案件資訊】
        * 修繕案件單號：#{maintenance_number}
        * 房屋編號：#{unit_number}
        * 案件類別：#{typing_i18n}
        * 建案名稱：#{property_name}
        * 顧客姓名：#{customer_name}
        * 聯絡電話：#{contact_number}
        * 方便時段：#{contact_time_text}
      TEXT
    end

    def child_descriptions
      "【報修項目】" <<
      maintenance_items.map.with_index do |item, idx|
        <<~TEXT
          * 報修項目#{idx}
          # 位置：#{item.location_name}
          # # 類別：#{item.maintenance_name}
          # #
          # 描述：#{item.content}
        TEXT
      end.join("\n")
    end

    def property_name
      property.name
    end

    def unit_number
      unit.unit_number
    end

    def customer_name
      user.name
    end
  end
end