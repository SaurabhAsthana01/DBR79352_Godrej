const cds = require("@sap/cds");
const SequenceHelper = require("./lib/SequenceHelper");

module.exports = cds.service.impl(async (service) => {
	const db = await cds.connect.to("db");
	const { TBL } = service.entities;

	service.before("CREATE", TBL, async (context) => {
		const SEQ_EVENT_ID = new SequenceHelper({
			db: db,
			sequence: "SEQ_EVENT_ID",
			table: "BULL_MASTER",
			field: "ID"
		});

		context.data.ID = await SEQ_EVENT_ID.getNextNumber();
	});
    service.before("CREATE", TBL, async (context) => {
    const SEQ_EVENT_ID = new SequenceHelper({
        db: db,
        sequence: "SEQ_EVENT_ID",
        table: "FARMER_MASTER",
        field: "ID"
        });

    context.data.ID = await SEQ_EVENT_ID.getNextNumber();
    });

    service.before("CREATE", TBL, async (context) => {
    const SEQ_EVENT_ID = new SequenceHelper({
        db: db,
        sequence: "SEQ_EVENT_ID",
        table: "COW_MASTER",
        field: "ID"
    });

    context.data.ID = await SEQ_EVENT_ID.getNextNumber();
    });
    service.before("CREATE", TBL, async (context) => {
    const SEQ_EVENT_ID = new SequenceHelper({
        db: db,
        sequence: "SEQ_EVENT_ID",
        table: "USER_MASTER",
        field: "ID"
    });

    context.data.ID = await SEQ_EVENT_ID.getNextNumber();
    });
    service.before("CREATE", TBL, async (context) => {
    const SEQ_EVENT_ID = new SequenceHelper({
        db: db,
        sequence: "SEQ_EVENT_ID",
        table: "EMBRYO_MASTER",
        field: "ID"
    });
    context.data.ID = await SEQ_EVENT_ID.getNextNumber();
    });
    service.before("CREATE", TBL, async (context) => {
    const SEQ_EVENT_ID = new SequenceHelper({
         db: db,
         sequence: "SEQ_EVENT_ID",
         table: "PROTOCOL_SYNCHRONIZATION",
         field: "ID"
        });
        context.data.ID = await SEQ_EVENT_ID.getNextNumber();
    });
});
