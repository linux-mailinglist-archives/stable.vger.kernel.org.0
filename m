Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF5C10697F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKVKE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:04:58 -0500
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:18563
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726417AbfKVKE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:04:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQDht7dRWtYC/Rq6o6cEZZrUBioR+Rb5fgEzyw+lEELNJ5AUKxUsM9B0Jn3pE2Zi2plKFQb+u0E7j9Gv3H4tB42XwWX31rnko/pE/m1CBGPsiKm1K50weSCSi0ra1mXN7UuuvqGgu0rXg3GTYFVmIHG26XMLVYrCwmdBMZypFmudwhWVd4EFGSvHHXfCtbD4BwhOZ+BJosTes4AUh0TwalunDXdkZQvbwPsRFdEh31KP4qY5p/8jnrp3AeOS8vN+NxHGZ0PjCUng2SqbAWcBL8X5IiWJln08TRPuojVk3IL4HCrKeTYDKlYGpqsonQ7rhIO1/+t494yfgkFd6hpHWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nasq4Kzwbp+1Bz7M3ImYiiVEpr7ppoY09uVt22CM3HI=;
 b=inO15Zbqf1gwR9mR0fG1r3T/fy+lqvnn/tUFtHDxWu80bzUFj1vHfdvVkgBtk9YsS2KNh2ScFzPkacW5u2VHYCPUk0CGj1Qf3UqwybNth2UJ1gRioLI6AwSNlnPToFJg5Vpqcs2c3zJ5ykXLODcfgMoW+O1qdQGlEeTsA1G9lAcXnTaNIkwHYoyHPgBRjwbhy8AoK1wMOdNZY7XKgyKOH6UPI+NJvgsFGeVGKFYQ2P8bYL44M4Jlol8q47k84TdR8vsoCXmECMyQknnkFrW1VpXrLQrDbnZPUMZuQX3D932CszvIIPSrBMJDFQzTtJrZ1kwOWMiPLEDJAo4edjRTSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nasq4Kzwbp+1Bz7M3ImYiiVEpr7ppoY09uVt22CM3HI=;
 b=PiBwbXUNH929Hs6RqkvhdDQBN/Eve2Quzmr4W/J7yZ8Gi5eMxBwP5AsuNjJWu10baGDptd8llNYIf5jjWBqP5iDVRjAbhtS5K4RVVtXPk8ub8vYL+OqxLD9TuWp6EvuP1us3jfcwqd8SMqGWqlUPdfUUMijXYv9Zdye7djuyMNA=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB4594.eurprd04.prod.outlook.com (52.135.149.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Fri, 22 Nov 2019 10:04:53 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::f16d:a26a:840:f97c]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::f16d:a26a:840:f97c%4]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 10:04:53 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        Abel Vesa <abel.vesa@nxp.com>,
        Aisheng Dong <aisheng.dong@nxp.com>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Alice Guo <alice.guo@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH V2] clk: imx: clk-imx7ulp: Add missing sentinel of
 ulp_div_table
Thread-Topic: [PATCH V2] clk: imx: clk-imx7ulp: Add missing sentinel of
 ulp_div_table
Thread-Index: AQHVoRxJ5RRsuDSV80CDoqBvpvLXvA==
Date:   Fri, 22 Nov 2019 10:04:53 +0000
Message-ID: <1574416982-3467-1-git-send-email-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK2PR02CA0201.apcprd02.prod.outlook.com
 (2603:1096:201:20::13) To AM0PR04MB4481.eurprd04.prod.outlook.com
 (2603:10a6:208:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8573dbcd-70a8-40c0-e920-08d76f336b76
x-ms-traffictypediagnostic: AM0PR04MB4594:|AM0PR04MB4594:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB459471BE5692C620F63D374F88490@AM0PR04MB4594.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(199004)(189003)(81166006)(6636002)(256004)(14444005)(2501003)(52116002)(4326008)(305945005)(5660300002)(110136005)(2906002)(71200400001)(81156014)(86362001)(66946007)(44832011)(478600001)(102836004)(3846002)(66446008)(71190400001)(6116002)(2616005)(14454004)(26005)(8676002)(386003)(6506007)(8936002)(50226002)(186003)(54906003)(2201001)(316002)(66066001)(25786009)(64756008)(66476007)(6436002)(66556008)(7736002)(4744005)(6512007)(36756003)(6486002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4594;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0WemzPL8aN9nSrZ/N6O7KabnSk75+w8tfys0FmDF7xq05VqsqU1tiK3zqsOsBMji03xNi/7psbqERd3f6C4YdLFHZ0UqSPRHQtCY1Nhou3BUrjc386atgzB5IcsaMn17WDsAqoBXq9/cOxzLH9PGRiwlFFSWjLuDobMJ5UNSb20qC4YcpX9pUKaOAe4sf0Lvu/lLVrByjy2cRIlic/Aa2HyEvGg97Z2w4r1lKwYybNpTXwmJk8ZZK5qgoZN6IcQ0d7TPOlJpMAzE+5vGlPzqa20I0RPM7LxRjnnsUg6NGw7VziHvTOyxKHdSRSWauI0xlegSCn5WQsXi65QLadsVr9WfVEG9pt7AUW83d5/BP7Qz+F2MHv7lUTxGuVk+RE1LQFT1g1fd4ovH2kbwBnJUFgwQHQ7kYxss7JgUJohamOMJI/gdToga4dt5OkSiIXii
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8573dbcd-70a8-40c0-e920-08d76f336b76
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 10:04:53.6702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mwALuZk3u1VELHZEj/rJLcBeY1KCL6mEoEhroi534XX6mZBegc5aYe9MLQ4J0yaXklIfOG6rX3BY6JnWmBbN2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4594
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

There should be a sentinel of ulp_div_table, otherwise _get_table_div
may access data out of the array.

Fixes: b1260067ac3d ("clk: imx: add imx7ulp clk driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---

V2:
 cc stable mail list

 drivers/clk/imx/clk-imx7ulp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx7ulp.c b/drivers/clk/imx/clk-imx7ulp.c
index 3fdf3d494f0a..281191b55b3a 100644
--- a/drivers/clk/imx/clk-imx7ulp.c
+++ b/drivers/clk/imx/clk-imx7ulp.c
@@ -40,6 +40,7 @@ static const struct clk_div_table ulp_div_table[] =3D {
 	{ .val =3D 5, .div =3D 16, },
 	{ .val =3D 6, .div =3D 32, },
 	{ .val =3D 7, .div =3D 64, },
+	{ /* sentinel */ },
 };
=20
 static const int pcc2_uart_clk_ids[] __initconst =3D {
--=20
2.16.4

