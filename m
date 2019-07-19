Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687DB6E165
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 09:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfGSHJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 03:09:43 -0400
Received: from mail-eopbgr150121.outbound.protection.outlook.com ([40.107.15.121]:5246
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725616AbfGSHJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 03:09:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mg612R3MQP57d6pffH6GyYEGcwaQIkmgoN4thkgaHzrUxl/h/V8sBtt8YpMFg3/VPOgxbW8DSmeNymj6C8+DMsqpKjiPpT/B39wwC4jKbGz4sAuHz18imsaIWKgDhzM7j6fmDoXDyrC9SHkmldPaj6z924wJQyqDRKS0L3sdU45VFNt6+vIntNLp5ZjjO57Ekwfh/8MZTf1xHceHromdSUQlkXv5jaugYIzmuiesCD4pjG1oPCu8VSd7ZgZEYRRt8o+hVd+PwshQMopwUDECjJx4eGWT8JOECt1n4p6wLTMwsFSWJclfHKhW0W6CEXfVQoCyQBXsxNZnpjznBdT4Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1guX6cjXsAxBOVvZlpwtEU7aGBqJzBE0QewJhfogPo=;
 b=b1p48O/PndkJmcTjfxJez+f/eqzToUcz1ed29f1iP8JTi/Yjl2yjX5zMZrFxcO2xxKAG+P5hW7jHZ1BvHgUw8CUM44io+3CMtGhpjnHQZ6/Riw6jBL2P9HZCPGBJ/DfF2i1kIk22YJYbwZJWzSA/WD9WM2IqJUn2DSh6QjPs5ngFRudFKWDpqpyj+iKcDGiO5d+bqFnUIRIFGE/QSN2J2SkTomh4vZdxx/ooPoeDNwwnf+v3f9WweIK74ttCjGplK4HFJVXmfXLah/IAb46zTCxf29wFeeRf5bNlwprztRz0Bs+F+W/9wLCTDxlSv0jRKVtowqnQGkvB/Fd6lx/LAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1guX6cjXsAxBOVvZlpwtEU7aGBqJzBE0QewJhfogPo=;
 b=EgICNuc3WIUva9CqV5+9+jqGklwQU+jj9f5pAXywcK7HzZszxqnWeWC5uDU25Y6wYSeLuAmij+fnQrqBvF31cm/VP8oGxNESUvkX6BCloCjlaNF0nbpM7NcDE2oHJb+HyN8obDGgFsvemKfsVrrOj3yXr4vC0tN7K6v2Pqq87lo=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB4808.eurprd05.prod.outlook.com (20.177.34.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 07:09:38 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2094.011; Fri, 19 Jul 2019
 07:09:38 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     Cezary Rojewski <cezary.rojewski@intel.com>
CC:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Sasha Levin <sashal@kernel.org>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH v5 2/6] ASoC: sgtl5000: Improve VAG power and mute control
Thread-Topic: [PATCH v5 2/6] ASoC: sgtl5000: Improve VAG power and mute
 control
Thread-Index: AQHVPUeRRPlk8qJu2UinCpynQ1zx8KbQtnQAgAAB14CAAM1VAA==
Date:   Fri, 19 Jul 2019 07:09:38 +0000
Message-ID: <CAGgjyvGboMPx5wKJ_1DaeYZazSHmQUGwDZHoCBt5vhpVq3Q_bA@mail.gmail.com>
References: <20190718090240.18432-1-oleksandr.suvorov@toradex.com>
 <20190718090240.18432-3-oleksandr.suvorov@toradex.com>
 <9c9ee47c-48bd-7109-9870-8f73be1f1cfa@intel.com>
 <a86e4d6b-ed2c-d2f2-2974-6f00dc6ef68a@intel.com>
In-Reply-To: <a86e4d6b-ed2c-d2f2-2974-6f00dc6ef68a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0022.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::35) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAWsQx2VELWrDG6emqcUSdiO1sr3Cnxjc5JzJaaX4lgnI/zyatnM
        09yaJbg7iaJLsjG9R14ylXIZozHrgLhns2mbIQg=
x-google-smtp-source: APXvYqwxlu70UaBmtIYl4bgUxABiaCwYArCOh/rud9gqTcTyk0lW2rm2jf4Sc8cMpvXrgsjOAdJGpveQPBdb1l/HjWw=
x-received: by 2002:a17:906:1e04:: with SMTP id
 g4mr39852082ejj.48.1563519831549; Fri, 19 Jul 2019 00:03:51 -0700 (PDT)
x-gmail-original-message-id: <CAGgjyvGboMPx5wKJ_1DaeYZazSHmQUGwDZHoCBt5vhpVq3Q_bA@mail.gmail.com>
x-originating-ip: [209.85.208.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba7108eb-2cc7-4023-958d-08d70c180ffb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB4808;
x-ms-traffictypediagnostic: AM6PR05MB4808:
x-microsoft-antispam-prvs: <AM6PR05MB48088A5118F8BBF9136A0A34F9CB0@AM6PR05MB4808.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(376002)(366004)(396003)(39850400004)(199004)(189003)(61266001)(5660300002)(450100002)(446003)(11346002)(66066001)(478600001)(476003)(305945005)(7736002)(54906003)(99286004)(86362001)(68736007)(95326003)(81166006)(81156014)(8936002)(8676002)(316002)(25786009)(102836004)(53546011)(6506007)(386003)(76176011)(26005)(186003)(55446002)(229853002)(6436002)(498394004)(6486002)(486006)(61726006)(6116002)(3846002)(44832011)(6512007)(52116002)(256004)(53936002)(6246003)(9686003)(6862004)(2906002)(14454004)(4326008)(66476007)(64756008)(66556008)(71190400001)(66946007)(71200400001)(107886003)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB4808;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Uixatv9WvM9sTCxnYGMWLav/0N+11oDKlVFeowZmGNoZsRSlXumeACk8eXvPj+69GQ/4hKqSOrYpv+ASGS9CyBlz5wTrK4TGQ6Y0YEb+QryRfbgQaSdbnwy4rKHb+RnvO9a3B7S6k+YugJwFBobpBuK8sQAdOo+8Z9aT5vD1/vsU+KaqM7EW8ciU6cdyIaMhEKgjtq0vKoQ7YpUbBJvyPdVxtE7AC/oDY9Bbw5VqFdOikEq+4A4CZSpHlnR/XN7818Rq7Yv8njzI8Vsj1V83Xj0YkxEDQT3CtQ3pIOjEJAlLob56YqpbMa/gZEBf6laPJdpWm/66ARcaVno0lB+l29T3yeqN/JtZBKszQDHX212zjVhPMU4W4dfdqTwhBVJmKGyStQbURgx2ZzQ/E7oolt2At+Y1AN5GR50mSRaxsTM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F6B8E281CE3234E8133B89150BEC622@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7108eb-2cc7-4023-958d-08d70c180ffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 07:09:38.4488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oleksandr.suvorov@toradex.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4808
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAxOCBKdWwgMjAxOSBhdCAyMTo0OSwgQ2V6YXJ5IFJvamV3c2tpIDxjZXphcnkucm9q
ZXdza2lAaW50ZWwuY29tPiB3cm90ZToNCj4NCj4gT24gMjAxOS0wNy0xOCAyMDo0MiwgQ2V6YXJ5
IFJvamV3c2tpIHdyb3RlOg0KPiA+IE9uIDIwMTktMDctMTggMTE6MDIsIE9sZWtzYW5kciBTdXZv
cm92IHdyb3RlOg0KPiA+PiArZW51bSB7DQo+ID4+ICsgICAgSFBfUE9XRVJfRVZFTlQsDQo+ID4+
ICsgICAgREFDX1BPV0VSX0VWRU5ULA0KPiA+PiArICAgIEFEQ19QT1dFUl9FVkVOVCwNCj4gPj4g
KyAgICBMQVNUX1BPV0VSX0VWRU5UDQo+ID4+ICt9Ow0KPiA+PiArDQo+ID4+ICtzdGF0aWMgdTE2
IG11dGVfbWFza1tdID0gew0KPiA+PiArICAgIFNHVEw1MDAwX0hQX01VVEUsDQo+ID4+ICsgICAg
U0dUTDUwMDBfT1VUUFVUU19NVVRFLA0KPiA+PiArICAgIFNHVEw1MDAwX09VVFBVVFNfTVVURQ0K
PiA+PiArfTsNCj4gPg0KPiA+IElmIG11dGVfbWFza1tdIGlzIG9ubHkgdXNlZCB3aXRoaW4gY29t
bW9uIGhhbmRsZXIsIHlvdSBtYXkgY29uc2lkZXINCj4gPiBkZWNsYXJpbmcgY29uc3QgYXJyYXkg
d2l0aGluIHNhaWQgaGFuZGxlciBpbnN0ZWFkIChkaWQgbm90IGNoZWNrIHRoYXQNCj4gPiBteXNl
bGYpLg0KPiA+IE90aGVyd2lzZSwgc2ltcGxlIGNvbW1lbnQgZm9yIHRoZSBzZWNvbmQgX09VVFBV
VFNfTVVURSBzaG91bGQgc3VmZmljZSAtDQo+ID4gaXRzIG5vdCBzZWxmIGV4cGxhbmF0b3J5IHdo
eSB5b3UgZG91YmxlZCB0aGF0IG1hc2suDQoNCk9rLCBJJ2xsIGFkZCBhIGNvbW1lbnQgdG8gZXhw
bGFpbiBkb3VibGVkIG1hc2suDQoNCj4gPg0KPiA+PiArDQo+ID4+ICAgLyogc2d0bDUwMDAgcHJp
dmF0ZSBzdHJ1Y3R1cmUgaW4gY29kZWMgKi8NCj4gPj4gICBzdHJ1Y3Qgc2d0bDUwMDBfcHJpdiB7
DQo+ID4+ICAgICAgIGludCBzeXNjbGs7ICAgIC8qIHN5c2NsayByYXRlICovDQo+ID4+IEBAIC0x
MzcsOCArMTU3LDEwOSBAQCBzdHJ1Y3Qgc2d0bDUwMDBfcHJpdiB7DQo+ID4+ICAgICAgIHU4IG1p
Y2JpYXNfdm9sdGFnZTsNCj4gPj4gICAgICAgdTggbHJjbGtfc3RyZW5ndGg7DQo+ID4+ICAgICAg
IHU4IHNjbGtfc3RyZW5ndGg7DQo+ID4+ICsgICAgdTE2IG11dGVfc3RhdGVbTEFTVF9QT1dFUl9F
VkVOVF07DQo+ID4+ICAgfTsNCj4gPg0KPiA+IFdoZW4gSSBzcG9rZSBvZiBMQVNUIGVudW0gY29u
c3RhbnQsIEkgZGlkIG5vdCByZWFsbHkgaGFkIHRoaXMgc3BlY2lmaWMNCj4gPiB1c2FnZSBpbiBt
aW5kLg0KPiA+DQo+ID4gIEZyb20gZGVzaWduIHBlcnNwZWN0aXZlLCBfTEFTVF8gZG9lcyBub3Qg
ZXhpc3QgYW5kIHNob3VsZCBuZXZlciBiZQ0KPiA+IHJlZmVycmVkIHRvIGFzICJ0aGUgbmV4dCBv
cHRpb24iIGkuZS46IG5ldyBlbnVtIGNvbnN0YW50Lg0KDQpCeSBpdHMgbmF0dXJlLCBMQVNUX1BP
V0VSX0VWRU5UIGlzIGFjdHVhbGx5IGEgc2l6ZSBvZiB0aGUgYXJyYXksIGJ1dCBJDQpjb3VsZG4n
dCBjb21lIHVwIHdpdGggYSBiZXR0ZXIgbmFtZS4NCg0KPiA+IFRoYXQgaXMgd2F5IHByZWZlcnJl
ZCB1c2FnZSBpczoNCj4gPiB1MTYgbXV0ZV9zdGF0ZVtBRENfUE9XRVJfRVZFTlQrMTsNCj4gPiAt
b3ItDQo+ID4gdTE2IG11dGVfc3RhdGVbTEFTVF9QT1dFUl9FVkVOVCsxXTsNCj4gPg0KPiA+IE1h
eWJlIEknbSBqdXN0IGJlaW5nIHJhZGljYWwgaGVyZSA6KQ0KDQpNYXliZSA6KSAgSSBkb24ndCBs
aWtlIGZpcnN0IHZhcmlhbnQgKEFEQ19QT1dFUl9FVkVOVCsxKTogc29tZXdoZW4gaW4NCmZ1dHVy
ZSwgc29tZW9uZSBjYW4gYWRkIGEgbmV3IGV2ZW50IHRvIHRoaXMgZW51bSBhbmQgd2UndmUgZ290
IGENCnBvc3NpYmxlIHNpdHVhdGlvbiB3aXRoICJvdXQgb2YgYXJyYXkgaW5kZXhpbmciLg0KDQo+
ID4NCj4gPiBDemFyZWsNCj4NCj4gRm9yZ2l2ZSBtZSBmb3IgZG91YmxlIHBvc3RpbmcuIENvbW1l
bnQgYWJvdmUgaXMgdGFyZ2V0ZWQgdG93YXJkczoNCj4NCj4gID4+ICtlbnVtIHsNCj4gID4+ICsg
ICAgSFBfUE9XRVJfRVZFTlQsDQo+ICA+PiArICAgIERBQ19QT1dFUl9FVkVOVCwNCj4gID4+ICsg
ICAgQURDX1BPV0VSX0VWRU5ULA0KPiAgPj4gKyAgICBMQVNUX1BPV0VSX0VWRU5UDQo+ICA+PiAr
fTsNCj4NCj4gYXMgTEFTVF9QT1dFUl9FVkVOVCBpcyBub3QgYXNzaWduZWQgZXhwbGljaXRseSB0
byBBRENfUE9XRVJfRVZFTlQgYW5kDQo+IHRodXMgZ2VuZXJhdGVzIGltcGxpY2l0ICJuZXcgb3B0
aW9uIiBvZiB2YWx1ZSAzLg0KDQpTbyB3aWxsIHlvdSBiZSBoYXBweSB3aXRoIHRoZSBmb2xsb3dp
bmcgdmFyaWFudD8NCi4uLg0KICAgIEFEQ19QT1dFUl9FVkVOVCwNCiAgICBMQVNUX1BPV0VSX0VW
RU5UID0gIEFEQ19QT1dFUl9FVkVOVCwNCi4uLg0KICAgdTE2IG11dGVfc3RhdGVbTEFTVF9QT1dF
Ul9FVkVOVCsxXTsNCi4uLg0KDQotLSANCkJlc3QgcmVnYXJkcw0KT2xla3NhbmRyIFN1dm9yb3YN
Cg0KVG9yYWRleCBBRw0KQWx0c2FnZW5zdHJhc3NlIDUgfCA2MDQ4IEhvcncvTHV6ZXJuIHwgU3dp
dHplcmxhbmQgfCBUOiArNDEgNDEgNTAwDQo0ODAwIChtYWluIGxpbmUpDQo=
