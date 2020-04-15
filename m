Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2951A91BD
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 06:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725294AbgDOEIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 00:08:39 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:47687
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbgDOEIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 00:08:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gN+Ev2M5cb4flqFRPXSgzB2La30hh8WFUY2kpEOJeNs5gz/bU7xxOXb3zxEwq1j0P73Nsu4yb72R9oO3sYlkDTz9XOIsc1s1PK9/Fqj8qpbj/NlDjxrDKa/+3EDH6EaPnAusN/QC1n0BTahm1wcgqInTF7tgq3lfS0yC5Um/B0DMzjanCpPnwDBpDnZZydD9gxjPT61WU9zDdGqx81rRN0FKMnn55EggIbKX/VpcKUket8I2G9QTJ3SvioMGq9rTwLjB0c9oLg28mvDP/qg4dIDpxyuL/zTuJNTOkl44mJyA02hyOINwPgOFzr5O/2nlp1bjK2Uq/WgbdIXjnGsLOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zz7si4em/Ii+TCWv0dm3vxvzQmZ2yoO2zZ0Plg6HDTw=;
 b=fm/MrUTgnjcfsT27EuyQX7Ro6JGzFtchnIVRkHKokhmdx54GofAipX+deMaETSYzqc+Nex9mcMax0Vm6/Y4oSa4nN2TjMjZwfxu9QMLUjymjSYO6H27AFiMps9jFcbbQT6OD5iKbcCzIO6WIbnKZPMRe5S87wxmkNSuCePgJg85leaaFnKsGTPOeArFG2c2lwuRQ2Vb7zojwba81QfTYwcbV4brcBqR4Lpfwo2lpoC2ZPhu/nmtIWnZ9+/NkXkw6HaGlGkZP4CgrVKhkENyzgBgP/0YMf+whMzyCSmoqRmenCiBLWcxdkol/LAwXdWveTSNujR7VP9sx8WA41/BH3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zz7si4em/Ii+TCWv0dm3vxvzQmZ2yoO2zZ0Plg6HDTw=;
 b=RnPXxbejsVh7PZmewhVG48+POU9lIu121kRi2UpKYxrHt1zMroUukltD+/syTKqQLPRhEjOau7bnH/Vq+l3BbUqtmvpmJSNZdmjCwW1LBbLenCQ3vUv7lRbGF6Tahp9THjwf8vR0sTVWzZyPiy+2umUMwx8SK5IZGM9x+ZzqboM=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7PR04MB7016.eurprd04.prod.outlook.com (2603:10a6:20b:11e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 15 Apr
 2020 04:08:30 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b%5]) with mapi id 15.20.2900.028; Wed, 15 Apr 2020
 04:08:30 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
CC:     "Daniel Walker (danielwa)" <danielwa@cisco.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Shyam More (shymore)" <shymore@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>
Subject: RE: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Topic: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Index: AQHWB532KYmmzOSk9kuuDMNOQaxK86hjtsqggACt1YCACYEGgIAA3RmAgACjZICAAMfzoIAAeZsAgAj+ZcA=
Date:   Wed, 15 Apr 2020 04:08:30 +0000
Message-ID: <AM7PR04MB6885B1163ACCF96D094607D9F8DB0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200331205007.GZ823@zorba>
 <AM7PR04MB6885CDDD1ECEEAE7111C6201F8C90@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200401152635.GA823@zorba> <20200407163443.GK823@zorba>
 <AM7PR04MB6885EBF5DA973DA083EF0E6BF8C00@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200408153037.GA27944@zorba>
 <AM7PR04MB6885C60315AC6D59093CC439F8C10@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <CAPDyKFo2zjh7UTcinOeiCxx86FJOQzhm=tQEdpTByiOTN=kaNA@mail.gmail.com>
In-Reply-To: <CAPDyKFo2zjh7UTcinOeiCxx86FJOQzhm=tQEdpTByiOTN=kaNA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ce364b5-0673-4445-9186-08d7e0f2a803
x-ms-traffictypediagnostic: AM7PR04MB7016:
x-microsoft-antispam-prvs: <AM7PR04MB70168A6CB751F2CD7AE4FF99F8DB0@AM7PR04MB7016.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0374433C81
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(2906002)(6506007)(478600001)(26005)(71200400001)(86362001)(53546011)(7696005)(33656002)(186003)(6916009)(4326008)(54906003)(9686003)(8936002)(8676002)(52536014)(81156014)(76116006)(66556008)(66476007)(316002)(64756008)(5660300002)(66946007)(55016002)(66446008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZnG+J/xIk5RdvLUf6vA8Q5Y2ux3tIJB7zENP7G0MLJR1Aee0QaSlBfnRVCgBZ63vketRF+Hac9ynLbQRtwjSF1UMDjmoput/XvFvANWvd4pIzA9T6eR06JjPpo312O9QGBeA4Vddu+t4DSu2s4kYO7bDdYKhwcLy9DUAzJIVTqpUewbxLxZuhfENVzQQiChZ3hEojRfBiV0K51OmLThYSCE6gkZqz6D/3gozfNMSgbEYCidfsEpwOzjjPaMQp7N6jop+KLM1KUyxfG+0Ryava5DWqswuN0ZnHJMrArhE3dHL6dikCtEYOwnDpm99XfowaLYr9rC969qILkp96HjwSXl/QjVOOvSzKBFkwHZ72vsqPk1q40ikd8A0k7Ml2Q/3Ci4/M0k/3yhgFtTW8/sr9ugGNKI1f7DnCsg4qygHtqhHwAN5hSpQRj9+FPzxUVUQ
x-ms-exchange-antispam-messagedata: cbyrJMTvsYhDTpo0IuEh23iz1NYqRdXr3zMINTYYRD8ofRW8x9fHUMiJZhsO5JQS5WOaRxKXWyushGAKclw0imfF9Z5P1RhAj+QnrxH6F9XcCkw07Gx/w+eGa06DL3Ln3iCPNB0plvFs4YVxWXIyRA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce364b5-0673-4445-9186-08d7e0f2a803
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2020 04:08:30.0832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iu0L4Q4odQw6u4K5iq+w/weowMCdlITpn872hqGBwmzJfLs52Ktjiz1jAppyax286Klm5ilmjeK8osr+lpTrIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7016
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBVbGYgSGFuc3NvbiA8dWxmLmhh
bnNzb25AbGluYXJvLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIEFwcmlsIDksIDIwMjAgNjo0MiBQ
TQ0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBEYW5pZWwgV2Fsa2Vy
IChkYW5pZWx3YSkgPGRhbmllbHdhQGNpc2NvLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7
DQo+IFNoeWFtIE1vcmUgKHNoeW1vcmUpIDxzaHltb3JlQGNpc2NvLmNvbT47IHhlLWxpbnV4LWV4
dGVybmFsKG1haWxlciBsaXN0KQ0KPiA8eGUtbGludXgtZXh0ZXJuYWxAY2lzY28uY29tPg0KPiBT
dWJqZWN0OiBSZTogbW1jOiBzZGhjaS1vZi1lc2RoYzogZml4IFAyMDIwIGVycmF0YSBoYW5kbGlu
Zw0KPiANCj4gT24gVGh1LCA5IEFwciAyMDIwIGF0IDA1OjQyLCBZLmIuIEx1IDx5YW5nYm8ubHVA
bnhwLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBUaGFua3MgRGFuaWVsIGZvciBwb2ludGluZyBvdXQg
aXQuDQo+ID4NCj4gPiBIaSBVZmZlLA0KPiA+DQo+ID4gQXMgRGFuaWVsIHJlcG9ydGVkLCBiZWxv
dyBjb21taXQgaW50cm9kdWNlZCBpc3N1ZSBvbiBQMjAyMCBwbGF0Zm9ybS4NCj4gPiBmZTBhY2Fi
IG1tYzogc2RoY2ktb2YtZXNkaGM6IGZpeCBQMjAyMCBlcnJhdGEgaGFuZGxpbmcNCj4gPg0KPiA+
IEFuZCB0aGUgZml4LXVwIGZvciB0aGUgaXNzdWUgaXMsDQo+ID4gMmFhM2Q4MiBtbWM6IHNkaGNp
LW9mLWVzZGhjOiBmaXggZXNkaGNfcmVzZXQoKSBmb3IgZGlmZmVyZW50IGNvbnRyb2xsZXINCj4g
dmVyc2lvbnMNCj4gPg0KPiA+IEl0IHNlZW1lZCBmZTBhY2FiIHdhcyBhcHBsaWVkIHRvIGxpbnV4
LXN0YWJsZSBmb3IgNS41LCA1LjQsIDQuMTksIDQuMTQsIDQuOSwNCj4gYW5kIDQuNCwgd2l0aG91
dCB0aGUgZml4LXVwIDJhYTNkODIuDQo+ID4gSSB0cmllZCB0byBjaGVycnktcGljayB0aGUgZml4
LXVwIHRvIGFsbCB0aGVzZSBzdGFibGUgYnJhbmNoZXMsIGJ1dCBnb3QgbWFueQ0KPiBjb25mbGlj
dHMgZXhjZXB0IDUuNSBhbmQgNS40Lg0KPiA+DQo+ID4gTWF5IEkgaGF2ZSB5b3VyIHN1Z2dlc3Rp
b24gZnJvbSBzYWZlIHBlcnNwZWN0aXZlIHNob3VsZCBJIHJld29yayB0aGUgZml4LXVwDQo+IGZv
ciB0aGVzZSBicmFuY2hlcywgb3IgcmVxdWVzdCB0byBqdXN0IHJldmVydCBmZTBhY2FiLg0KPiA+
IFRoZSBwYXRjaCBmZTBhY2FiIGlzIGp1c3QgZm9yIGVycmF0YSBoYW5kbGluZyB3aGlsZSB0aGUg
ZXJyYXRhIGFyZSBoYXJkIHRvDQo+IHRyaWdnZXIuIEl0IGlzIG5vdCBzdHJvbmdseSByZXF1aXJl
ZC4NCj4gDQo+IEl0IHNvdW5kcyB0byBtZSwgbGlrZSBhIHJldmVydCBtYXkgYmUgdGhlIGJlc3Qg
b3B0aW9uLCBhdCBsZWFzdCBmb3INCj4gNC4xOSBhbmQgYmFja3dhcmRzLg0KPiANCj4gUGVyaGFw
cyBmcm9tIDUuNCBhbmQgb253YXJkcywgeW91IGNhbiBzZW5kIHRoZSBuZWVkZWQgYWRkaXRpb25h
bA0KPiBwYXRjaGVzIGFzIHBsYWluIGJhY2twb3J0cyB0byBzdGFibGUsIGFzIHRoZXkgc2hvdWxk
IGJlIGVhc3kgdG8gYXBwbHksDQo+IHJpZ2h0IT8NCg0KVGhhbmtzIGEgbG90IGZvciB5b3VyIHN1
Z2dlc3Rpb24sIFVmZmUuDQpTZW50IG91dCB0aGUgZml4LXVwIHRvIGtlcm5lbCA1LjUuIGFuZCA1
LjQuIEFuZCByZXF1ZXN0ZWQgaGVscCB0byByZXZlcnQgdGhlIGlzc3VlIHBhdGNoIG9uIG90aGVy
IGtlcm5lbCB2ZXJzaW9ucy4NCg0KPiANCj4gWy4uLl0NCj4gDQo+IEtpbmQgcmVnYXJkcw0KPiBV
ZmZlDQo=
