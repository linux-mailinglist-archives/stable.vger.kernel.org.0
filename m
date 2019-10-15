Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CACD816E
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 23:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfJOVCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 17:02:25 -0400
Received: from mail-eopbgr60107.outbound.protection.outlook.com ([40.107.6.107]:12550
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726706AbfJOVCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 17:02:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfPEsoJPzUMPoe67bau2GSv9xPTVk+8Ygg65BoBUTFBBGLK25/rib+JXGR3jl8UtfkCMO9G7ygPmbxObYBg9N4L7kb4rzpzTARCHfo/VKwAEOBl3DK60RQHIc63MwjCMeZeNu7SWhNMPZ+C/X+2osxtwyxwE5Q7J9H4u6dPbbSZRweYiveXFoEiL8JmDTWNfR5/SxxezJfeJqGIcHoXGUU+W0ExZKuyHgt8ZaEQZhCvjYG/xY/2FCaPBdLnebvGhMTl5tGF7rNL5lzJe/ggtyEBLNotoM2N8SdVfFgkMSMS/5PTe/M8DDBST9XkzFVfGit3/PGUilxALfFTcqNfjpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuOE1YnOpLE4Kh/aZZj1zNYRsZ0J2LU6PJDPzSoump8=;
 b=WKtgGKJ+aq+E1VAWNpPpw8i8sGkyZTyNvMrn/fKX9Fi/K3/7JgQYZGUT5pHCbubvuL4wRfufgpd9+bAK8XQ3EPPgeWo3gD1RC8hgwaD34TINU3xZia9D4zqosMnQrcM0SqpfEhnYvgSi7SsQxelWI/kw0o3QMavcE9vXxRXvRGJv5beewfHXpsDBW5TgK2SrK7g9wbMCx3p3NzgtexxoahDuETkt1Ub/3KShSkQN9VjN5djs7LnsZQsIMxNYMhYmnnkDbslx/RpUPNEBcsGtGv/8BbHt76GlS6bfMWQBBgbu4eCnFgvSI+Qq80GNgHFPnC7r4Jhm72XoI3Lv5XFulQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom-usa.com; dmarc=pass action=none
 header.from=silicom-usa.com; dkim=pass header.d=silicom-usa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuOE1YnOpLE4Kh/aZZj1zNYRsZ0J2LU6PJDPzSoump8=;
 b=IWYe8901ifKR+lhsgQQ4Beknjz3Op3mFiv8z9H2sFhkUlesyk4ympmhvwc2NTXwMt6GUEkehTxUtMqvXW4yVWGifDh+KGDixN+z/ON5sDpqNeahlwEqh25cFWBvu5WRpELRKqyteP83advooLnY3TJ2ksj6R8n3KnsRE1FVRe9c=
Received: from AM0PR0402MB3890.eurprd04.prod.outlook.com (52.133.33.145) by
 AM0PR0402MB3683.eurprd04.prod.outlook.com (52.133.38.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Tue, 15 Oct 2019 21:02:19 +0000
Received: from AM0PR0402MB3890.eurprd04.prod.outlook.com
 ([fe80::e963:2c7e:7b5:d7e9]) by AM0PR0402MB3890.eurprd04.prod.outlook.com
 ([fe80::e963:2c7e:7b5:d7e9%5]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 21:02:19 +0000
From:   Stephen Douthit <stephend@silicom-usa.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     Andreas Friedrich <afrie@gmx.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata/ahci: Fix PCS quirk application
Thread-Topic: [PATCH] libata/ahci: Fix PCS quirk application
Thread-Index: AQHVg5RX9XFRRVjLgki73dKWf8/MPqdcMHyA
Date:   Tue, 15 Oct 2019 21:02:19 +0000
Message-ID: <e4544252-d2d7-e464-94d6-4df7cda0e248@silicom-usa.com>
References: <157116925749.1211205.12806062056189943042.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <157116925749.1211205.12806062056189943042.stgit@dwillia2-desk3.amr.corp.intel.com>
Reply-To: Stephen Douthit <stephend@silicom-usa.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN8PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:408:94::30) To AM0PR0402MB3890.eurprd04.prod.outlook.com
 (2603:10a6:208:3::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=stephend@silicom-usa.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [96.82.2.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 612e4909-324f-4509-479e-08d751b2f786
x-ms-traffictypediagnostic: AM0PR0402MB3683:
x-microsoft-antispam-prvs: <AM0PR0402MB3683F73125D6100C9563533A94930@AM0PR0402MB3683.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(39850400004)(376002)(396003)(189003)(199004)(7736002)(81156014)(8676002)(2906002)(305945005)(43066004)(5660300002)(229853002)(25786009)(6246003)(54906003)(6436002)(3450700001)(478600001)(81166006)(8936002)(110136005)(486006)(31686004)(6486002)(99286004)(14454004)(256004)(26005)(36756003)(71190400001)(186003)(476003)(71200400001)(2616005)(446003)(11346002)(4326008)(53546011)(6512007)(2501003)(3846002)(6116002)(52116002)(66066001)(66446008)(64756008)(31696002)(66556008)(66476007)(66946007)(316002)(86362001)(102836004)(386003)(76176011)(6506007)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR0402MB3683;H:AM0PR0402MB3890.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silicom-usa.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AuNDMnaRNnRGQCfdPQXjMNUetuDHe9t/z5+G6NLCojZrxHuH5k/MlHkvJ6EMynblgJHy/hxT8ULFZF2UBCa5Y/TaV/fME2Ms9TGJwCWbJEHk7VuhxB36Re+tTv8qLtGs8kGtmDaRuc8Ru+fKOyPRRf3NrJPOGmebXqW14RBvPdZLupcjurrCfd/NyWw767x5kzfbJmv3j140PvZRJqE7ZR5POAFc48jyMJs1mH1Z2f4Iiq8qgYtOQPFfrFBFK0xo7/D00Jg9iXjkU7RIDZjDi/kZLpSG4+fbW79xZ/eAmX5vqWymPQpaiybrzNzHQWZekzS80P//fhu0ZH9cA9/3XDDsTTkkQ1qAL6gQR2VOkVJ5O8HCbqyClk0WMN0NaPZm8arC+kvQuLwPNfgtEV92ynDygzbnrpX/02kiU6wnOvQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7055B7C5385407489F39231F4B193504@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silicom-usa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 612e4909-324f-4509-479e-08d751b2f786
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 21:02:19.6274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kVczx/rkeBXA9wmQkIrMXlpw/SZbSNPHiLQb1xEIpazX9Gkc001Xvjh5bKzGxsUOM90tuH03jauwRSZKXUM3afpt1leTA/JkD7bheMxizVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3683
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTAvMTUvMTkgMzo1NCBQTSwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiBDb21taXQgYzMxMmVm
MTc2Mzk5ICJsaWJhdGEvYWhjaTogRHJvcCBQQ1MgcXVpcmsgZm9yIERlbnZlcnRvbiBhbmQNCj4g
YmV5b25kIiBnb3QgdGhlIHBvbGFyaXR5IHdyb25nIG9uIHRoZSBjaGVjayBmb3Igd2hpY2ggYm9h
cmQtaWRzIHNob3VsZA0KPiBoYXZlIHRoZSBxdWlyayBhcHBsaWVkLiBUaGUgYm9hcmQgdHlwZSBi
b2FyZF9haGNpX3BjczcgaXMgZGVmaW5lZCBhdCB0aGUNCj4gZW5kIG9mIHRoZSBsaXN0IHN1Y2gg
dGhhdCAicGNzNyIgYm9hcmRzIGNhbiBiZSBzcGVjaWFsIGNhc2VkIGluIHRoZQ0KPiBmdXR1cmUg
aWYgdGhleSBuZWVkIHRoZSBxdWlyay4gQWxsIHByaW9yIEludGVsIGJvYXJkIGlkcyAiPA0KPiBi
b2FyZF9haGNpX3BjczciIHNob3VsZCBwcm9jZWVkIHdpdGggYXBwbHlpbmcgdGhlIHF1aXJrLg0K
PiANCj4gUmVwb3J0ZWQtYnk6IEFuZHJlYXMgRnJpZWRyaWNoIDxhZnJpZUBnbXgubmV0Pg0KPiBS
ZXBvcnRlZC1ieTogU3RlcGhlbiBEb3V0aGl0IDxzdGVwaGVuZEBzaWxpY29tLXVzYS5jb20+DQo+
IEZpeGVzOiBjMzEyZWYxNzYzOTkgKCJsaWJhdGEvYWhjaTogRHJvcCBQQ1MgcXVpcmsgZm9yIERl
bnZlcnRvbiBhbmQgYmV5b25kIikNCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBT
aWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4g
LS0tDQo+ICAgZHJpdmVycy9hdGEvYWhjaS5jIHwgICAgNCArKystDQo+ICAgMSBmaWxlIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvYXRhL2FoY2kuYyBiL2RyaXZlcnMvYXRhL2FoY2kuYw0KPiBpbmRleCBkZDkyZmFmMTk3
ZDUuLjA1YzJiMzJkY2M0ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9hdGEvYWhjaS5jDQo+ICsr
KyBiL2RyaXZlcnMvYXRhL2FoY2kuYw0KPiBAQCAtMTYwMCw3ICsxNjAwLDkgQEAgc3RhdGljIHZv
aWQgYWhjaV9pbnRlbF9wY3NfcXVpcmsoc3RydWN0IHBjaV9kZXYgKnBkZXYsIHN0cnVjdCBhaGNp
X2hvc3RfcHJpdiAqaHANCj4gICAJICovDQo+ICAgCWlmICghaWQgfHwgaWQtPnZlbmRvciAhPSBQ
Q0lfVkVORE9SX0lEX0lOVEVMKQ0KPiAgIAkJcmV0dXJuOw0KDQpVbmxlc3MgSSdtIG1pc3Npbmcg
c29tZXRoaW5nIHRoaXMgd2lsbCBzaG9ydC1jaXJjdWl0IGlmIHRoZXJlIGFyZSBhbnkNCm9sZGVy
IEludGVsIGNvbnRyb2xsZXJzIG5vdCBleHBsaWNpdGx5IGxpc3RlZCB3aXRoIGEgUENJX1ZERVZJ
Q0UgZW50cnkNCmluIGFoY2lfcGNpX3RibC4gIFRob3NlIHdpbGwgbWF0Y2ggb246DQoNCgkvKiBH
ZW5lcmljLCBQQ0kgY2xhc3MgY29kZSBmb3IgQUhDSSAqLw0KCXsgUENJX0FOWV9JRCwgUENJX0FO
WV9JRCwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwNCgkgIFBDSV9DTEFTU19TVE9SQUdFX1NBVEFf
QUhDSSwgMHhmZmZmZmYsIGJvYXJkX2FoY2kgfSwNCg0KYW5kIGlkLT52ZW5kb3Igd2lsbCBiZSBQ
Q0lfQU5ZX0lEIHNvIHdlIGJhaWwgYmVmb3JlIGFwcGx5aW5nIHRoZSBxdWlyay4NCmJlY2F1c2Uu
Li4uDQoNCnN0YXRpYyBpbmxpbmUgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKg0KcGNpX21h
dGNoX29uZV9kZXZpY2UoY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmlkLCBjb25zdCBzdHJ1
Y3QgcGNpX2RldiAqZGV2KQ0Kew0KCWlmICgoaWQtPnZlbmRvciA9PSBQQ0lfQU5ZX0lEIHx8IGlk
LT52ZW5kb3IgPT0gZGV2LT52ZW5kb3IpICYmDQoJICAgIChpZC0+ZGV2aWNlID09IFBDSV9BTllf
SUQgfHwgaWQtPmRldmljZSA9PSBkZXYtPmRldmljZSkgJiYNCgkgICAgKGlkLT5zdWJ2ZW5kb3Ig
PT0gUENJX0FOWV9JRCB8fCBpZC0+c3VidmVuZG9yID09IGRldi0+c3Vic3lzdGVtX3ZlbmRvcikg
JiYNCgkgICAgKGlkLT5zdWJkZXZpY2UgPT0gUENJX0FOWV9JRCB8fCBpZC0+c3ViZGV2aWNlID09
IGRldi0+c3Vic3lzdGVtX2RldmljZSkgJiYNCgkgICAgISgoaWQtPmNsYXNzIF4gZGV2LT5jbGFz
cykgJiBpZC0+Y2xhc3NfbWFzaykpDQoJCXJldHVybiBpZDsNCglyZXR1cm4gTlVMTDsNCn0NCg0K
Y29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKnBjaV9tYXRjaF9pZChjb25zdCBzdHJ1Y3QgcGNp
X2RldmljZV9pZCAqaWRzLA0KCQkJCQkgc3RydWN0IHBjaV9kZXYgKmRldikNCnsNCglpZiAoaWRz
KSB7DQoJCXdoaWxlIChpZHMtPnZlbmRvciB8fCBpZHMtPnN1YnZlbmRvciB8fCBpZHMtPmNsYXNz
X21hc2spIHsNCgkJCWlmIChwY2lfbWF0Y2hfb25lX2RldmljZShpZHMsIGRldikpDQoJCQkJcmV0
dXJuIGlkczsNCgkJCWlkcysrOw0KCQl9DQoJfQ0KCXJldHVybiBOVUxMOw0KfQ0KDQpTbyB3ZSBz
aG91bGQgY2hlY2sgcGRldi0+dmVuZG9yIGluc3RlYWQuDQoNCi1TdGV2ZQ0KDQo+IC0JaWYgKCgo
ZW51bSBib2FyZF9pZHMpIGlkLT5kcml2ZXJfZGF0YSkgPCBib2FyZF9haGNpX3BjczcpDQo+ICsN
Cj4gKwkvKiBTa2lwIGFwcGx5aW5nIHRoZSBxdWlyayBvbiBEZW52ZXJ0b24gYW5kIGJleW9uZCAq
Lw0KPiArCWlmICgoKGVudW0gYm9hcmRfaWRzKSBpZC0+ZHJpdmVyX2RhdGEpID49IGJvYXJkX2Fo
Y2lfcGNzNykNCj4gICAJCXJldHVybjsNCj4gICANCj4gICAJLyoNCj4gDQoNCg==
