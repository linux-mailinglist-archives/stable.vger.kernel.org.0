Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998472EA31
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 03:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfE3BXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 21:23:01 -0400
Received: from mail-eopbgr40046.outbound.protection.outlook.com ([40.107.4.46]:3844
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbfE3BXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 21:23:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXNqwIC2b9bEE9RPSsmlQy1hX2NkCqvOJCJuqqYnoIo=;
 b=hV1VOhHUicDnjAD3zz6nOCjIJfDi4gJVxSey8lgU8wWZ72Iirx7/hGMgs2aQLw3NSNQ6Ne/mBOXzLmRmprTZ0PP0ObsiFBfUPABMBAaHVzPWKJk0qHk4BgmAPijLMowpIZ/Ec2lF7EDdwdZwochisqotxLKTjr7I3Q/I68LksWo=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB4145.eurprd04.prod.outlook.com (52.134.90.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Thu, 30 May 2019 01:22:58 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378%6]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 01:22:58 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Stephen Boyd <sboyd@kernel.org>, Shawn Guo <shawnguo@kernel.org>
CC:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
 audio_pll2_out
Thread-Topic: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
 audio_pll2_out
Thread-Index: AQHVED6JGbhPMl1ASUycBcbN9uhZiqZ4tK8AgAoZTgCAAB1qcA==
Date:   Thu, 30 May 2019 01:22:57 +0000
Message-ID: <AM0PR04MB4481A7FF28A9AB9A1584423888180@AM0PR04MB4481.eurprd04.prod.outlook.com>
References: <20190522014832.29485-1-peng.fan@nxp.com>
 <20190523132235.GZ9261@dragon> <20190529233547.B7F6F2435D@mail.kernel.org>
In-Reply-To: <20190529233547.B7F6F2435D@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48fbac38-aaff-4ac7-8dff-08d6e49d597d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4145;
x-ms-traffictypediagnostic: AM0PR04MB4145:
x-microsoft-antispam-prvs: <AM0PR04MB4145EA9A552E94996523BB2C88180@AM0PR04MB4145.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(33656002)(7416002)(86362001)(25786009)(74316002)(316002)(6436002)(44832011)(52536014)(68736007)(305945005)(7736002)(73956011)(76176011)(76116006)(64756008)(66556008)(9686003)(66446008)(81156014)(66946007)(55016002)(110136005)(54906003)(66476007)(99286004)(71200400001)(14454004)(2906002)(3846002)(7696005)(66066001)(256004)(5660300002)(229853002)(486006)(6116002)(6246003)(8676002)(446003)(8936002)(53936002)(71190400001)(6506007)(186003)(4326008)(11346002)(478600001)(4744005)(102836004)(81166006)(26005)(476003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4145;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 94ycI5JvLjVuYqo9FeQ4xsNJ+VxOKEozwWIKa9DZyr68UbGkuMklDHtDDdoO8gX022ux6A3wBM/9/1Yd8MrWKsDTh9eMgatSctfP93B0KU8eq2fw2BUsLUC3MYE7so56uu7o0O8eJ3KvqYo0q0daYja3GmyqXWSlxXD04/eoWNUulCP1p4DbvtJf/D205MT9VGmoxTH7vvrLM3YmDUguRc/WAaXp7/vwx8AwJCh2qnx4fDWqVLrnoevAVpxp4Z+EpS/YTZyW2wlw0xSPDQ3ktUq5/woKPKSgmDem/SLt3sLp2w0OI73lMvzB/90NGeEW02BGpIFSmnILgevwAAyl+GMRqDiCo2LJiUv2fyMsMVkoXZ0v/uVPpCBaHHBrmha+fNYZfKhY3bUS2tjdqoDrmHGB9ZdOV9FOg5nSqrNUYqU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48fbac38-aaff-4ac7-8dff-08d6e49d597d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 01:22:58.0223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: peng.fan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4145
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBjbGs6IGlteDogaW14OG1tOiBj
b3JyZWN0IGF1ZGlvX3BsbDJfY2xrIHRvDQo+IGF1ZGlvX3BsbDJfb3V0DQo+IA0KPiBRdW90aW5n
IFNoYXduIEd1byAoMjAxOS0wNS0yMyAwNjoyMjozNikNCj4gPiBPbiBXZWQsIE1heSAyMiwgMjAx
OSBhdCAwMTozNDo0NkFNICswMDAwLCBQZW5nIEZhbiB3cm90ZToNCj4gPiA+IFRoZXJlIGlzIG5v
IGF1ZGlvX3BsbDJfY2xrIHJlZ2lzdGVyZWQsIGl0IHNob3VsZCBiZSBhdWRpb19wbGwyX291dC4N
Cj4gPiA+DQo+ID4gPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+ID4gPiBGaXhlczog
YmE1NjI1YzNlMjcgKCJjbGs6IGlteDogQWRkIGNsb2NrIGRyaXZlciBzdXBwb3J0IGZvciBpbXg4
bW0iKQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogUGVuZyBGYW4gPHBlbmcuZmFuQG54cC5jb20+DQo+
ID4NCj4gPiBTdGVwaGVuLA0KPiA+DQo+ID4gSSBsZWF2ZSB0aGlzIHRvIHlvdSwgc2luY2UgaXQn
cyBhIGZpeC4NCj4gPg0KPiANCj4gSXMgaXQgYSBjcml0aWNhbCBmaXg/IE9yIGlzIGl0IGFuIGFu
bm95YW5jZSB0aGF0IGNhbiB3YWl0IGluIC1uZXh0IHVudGlsIHRoZSBuZXh0DQo+IG1lcmdlIHdp
bmRvdz8NCg0KSSBkaWQgbm90IHJ1biBpbnRvIGlzc3VlIHdpdGhvdXQgdGhpcyBmaXggY3VycmVu
dGx5LCBzbyBpdCBzaG91bGQgYmUgZmluZSB0byB3YWl0DQppbiAtbmV4dCB1bnRpbCB0aGUgbmV4
dCBtZXJnZSB3aW5kb3cuDQoNClRoYW5rcywNClBlbmcuDQoNCg==
