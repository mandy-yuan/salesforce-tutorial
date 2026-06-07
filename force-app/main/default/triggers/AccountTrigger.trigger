trigger AccountTrigger on Account (
    before insert,
    before update,
    after insert
) {
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.beforeInsert(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.afterInsert(Trigger.new);
    }
}
