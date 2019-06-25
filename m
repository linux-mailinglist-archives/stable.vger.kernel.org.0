Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E72524EC
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 09:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfFYHg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 03:36:26 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:47431
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728479AbfFYHgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 03:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4DcdAOGNN7uG3+UMf3bl2aJlWJpwomW5pbN/zyghW4=;
 b=VobJkH2PNcEVCo2DmeT8aIu4wrEyc1MTX2+YlXJKqZFLHCS6xaQtlnwZbSNXYAmVZj94XTBcDeLyCa00h9lqtWrv5N2gFQNMNL8WbR4tJlX+mbz8cCwmfO4e4dT0maviXO+fSb0mM3pese+gKcQZGabGgoJf55X/stGv3ZigR2s=
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com (20.179.235.81) by
 VE1PR04MB6735.eurprd04.prod.outlook.com (20.179.235.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.15; Tue, 25 Jun 2019 07:36:21 +0000
Received: from VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::a4a8:729f:e664:fa8]) by VE1PR04MB6638.eurprd04.prod.outlook.com
 ([fe80::a4a8:729f:e664:fa8%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 07:36:21 +0000
From:   Robin Gong <yibin.gong@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vinod <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        stable <stable@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: RE: [PATCH v2] dmaengine: imx-sdma: remove BD_INTR for channel0
Thread-Topic: [PATCH v2] dmaengine: imx-sdma: remove BD_INTR for channel0
Thread-Index: AQHVKApc81sAbbdr7Ea/8sLlqDZMC6aqx+MAgAEzZ6A=
Date:   Tue, 25 Jun 2019 07:36:21 +0000
Message-ID: <VE1PR04MB6638D58DED0D7092D8FCE93589E30@VE1PR04MB6638.eurprd04.prod.outlook.com>
References: <20190621082306.34415-1-yibin.gong@nxp.com>
 <CAOMZO5B+uXF=1WTPsA-9LrmtTF0Q0s7Fipwtd1nkWSgr3ec25w@mail.gmail.com>
In-Reply-To: <CAOMZO5B+uXF=1WTPsA-9LrmtTF0Q0s7Fipwtd1nkWSgr3ec25w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yibin.gong@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cf33472-d150-42ef-6335-08d6f93fd1d9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VE1PR04MB6735;
x-ms-traffictypediagnostic: VE1PR04MB6735:
x-microsoft-antispam-prvs: <VE1PR04MB67350A8361B91D481F800D2689E30@VE1PR04MB6735.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(376002)(396003)(39860400002)(189003)(13464003)(43544003)(199004)(76176011)(316002)(76116006)(25786009)(55016002)(66476007)(186003)(6246003)(11346002)(52536014)(81166006)(53936002)(476003)(74316002)(26005)(9686003)(446003)(81156014)(8676002)(305945005)(1411001)(86362001)(7736002)(2906002)(66556008)(102836004)(66446008)(7416002)(66946007)(256004)(71190400001)(4326008)(99286004)(53546011)(7696005)(8936002)(14454004)(6506007)(14444005)(33656002)(71200400001)(3846002)(66066001)(478600001)(486006)(68736007)(6916009)(229853002)(6116002)(5660300002)(64756008)(54906003)(6436002)(73956011);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6735;H:VE1PR04MB6638.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5UpBcw9vu5PYa3c3fqp6qT5IpUOeDJRuKGmnd60Q2qQZL1eDeRmmQsMVNX+YEFlIpgidMP/7BjCSRag6ts94k6hMWUQvwCa0kazsQmlb1dXpXi7V/4fpxmjafSu5dSZu/uCwd2vVWOglQS26xeVarmA8202fbhhF2VpXZswUALwPaM02WetgFsn88djI3Q8xP+6usvpZC5b7il08QpxS/lOqhqSsO+HGvxcJOE8jv+kk0yb/Cc1m80B3HgJHZ/eE8shbIHkFbJ3HU3Ey2sxXcNNMYrxZQE2SeYBW6YrFTYmAbkZp36fcydxJqJoxPtK9uNkTaE9XvHpxMeTQDzL5hIuUHzUOjyaB2dxgBFXlYjFRb3BqF5mIgvXAoeZPP1JbioB02ONvA6c7RQ0rmvTDBhk7D93pUxEd5whuilcb1ec=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf33472-d150-42ef-6335-08d6f93fd1d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 07:36:21.7135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yibin.gong@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6735
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGYWJpbyBFc3RldmFtIDxmZXN0
ZXZhbUBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMTnlubQ25pyIMjTml6UgMjA6NTUNCj4gDQo+IEhp
IFJvYmluLA0KPiANCj4gT24gRnJpLCBKdW4gMjEsIDIwMTkgYXQgNToyMSBBTSA8eWliaW4uZ29u
Z0BueHAuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IFJvYmluIEdvbmcgPHlpYmluLmdvbmdA
bnhwLmNvbT4NCj4gPg0KPiA+IEl0IGlzIHBvc3NpYmxlIGZvciBhbiBpcnEgdHJpZ2dlcmVkIGJ5
IGNoYW5uZWwwIHRvIGJlIHJlY2VpdmVkIGxhdGVyDQo+ID4gYWZ0ZXIgY2xrcyBhcmUgZGlzYWJs
ZWQgb25jZSBmaXJtd2FyZSBsb2FkZWQgZHVyaW5nIHNkbWEgcHJvYmUuIElmDQo+ID4gdGhhdCBo
YXBwZW5zIHRoZW4gY2xlYXJpbmcgdGhlbSBieSB3cml0aW5nIHRvIFNETUFfSF9JTlRSIHdvbid0
IHdvcmsNCj4gPiBhbmQgdGhlIGtlcm5lbCB3aWxsIGhhbmcgcHJvY2Vzc2luZyBpbmZpbml0ZSBp
bnRlcnJ1cHRzLiBBY3R1YWxseSwNCj4gPiBkb24ndCBuZWVkIGludGVycnVwdCB0cmlnZ2VyZWQg
b24gY2hhbm5lbDAgc2luY2UgaXQncyBwb2xsbGluZw0KPiA+IFNETUFfSF9TVEFUU1RPUCB0byBr
bm93IGNoYW5uZWwwIGRvbmUgcmF0aGVyIHRoYW4gaW50ZXJydXB0IGluIGN1cnJlbnQNCj4gPiBj
b2RlLCBqdXN0IGNsZWFyIEJEX0lOVFIgdG8gZGlzYWJsZSBjaGFubmVsMCBpbnRlcnJ1cHQgdG8g
YXZvaWQgdGhlDQo+ID4gYWJvdmUgY2FzZS4NCj4gPiBUaGlzIGlzc3VlIHdhcyBicm91Z2h0IGJ5
IGNvbW1pdCAxZDA2OWJmYTNjNzggKCJkbWFlbmdpbmU6IGlteC1zZG1hOg0KPiA+IGFjayBjaGFu
bmVsIDAgSVJRIGluIHRoZSBpbnRlcnJ1cHQgaGFuZGxlciIpIHdoaWNoIGRpZG4ndCB0YWtlIGNh
cmUNCj4gPiB0aGUgYWJvdmUgY2FzZS4NCj4gPg0KPiA+IEZpeGVzOiAxZDA2OWJmYTNjNzggKCJk
bWFlbmdpbmU6IGlteC1zZG1hOiBhY2sgY2hhbm5lbCAwIElSUSBpbiB0aGUNCj4gPiBpbnRlcnJ1
cHQgaGFuZGxlciIpDQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIzUuMCsNCj4gDQo+
IFRoaXMgNS4wIG5vdGF0aW9uIGRvZXMgbm90IGxvb2sgY29ycmVjdCwgYXMgMWQwNjliZmEzYzc4
IHdhcyBpbnRyb2R1Y2VkIGluDQo+IDQuMTAuDQpZZXMsIGFsdGhvdWdoIFN2ZW4gb25seSBtZXQg
dGhpcyBpc3N1ZSBhZnRlciB2NC4xOSwgdGhpcyBwb3RlbnRpYWwgaXNzdWUgc2hvdWxkIGJlIHRo
ZXJlLg0KQnV0IDFkMDY5YmZhM2M3OCBzZWVtcyBtZXJnZWQgZnJvbSB2NC43IGluc3RlYWQ/DQo=
