Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1064A460FD6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 09:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241780AbhK2IQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 03:16:35 -0500
Received: from mail-bo1ind01olkn0174.outbound.protection.outlook.com ([104.47.101.174]:41184
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231634AbhK2IOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 03:14:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMs2zri9d+5oZqCkmwQDzVYN8BjpapbLR8ZmiEAkGLO5D77rl4XOrBHocNRIH+276tPqQbLpUepQHPQKf5UGUB0qerW8kH0mLvjwpXn/ueeLUswoChCOZNzVs6z1n1I7xwQHEyH/vEC0LhJKbpEtlKQK1KIGfxgymjJmp/yGy2QSeWaIg5+KsHzCdub4/V7A9ZqxKn0f9E1Ymj3hISTrqcJM7cN8fZbwnQyqF+Zd+vk7F0L+6/sSnT8MtnpmAfDkSKnw4NIkPOiN+pPwHy/eKY6kkDXblwjo8TUzTp22TPTyy54mEol7J+5ZZoYQIuY8XpKuTVIBvbzqiCYeEQaPUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9Uk+/wkJD+SEzs1dd+ocAPxct2CnKt49JPtFNMO4yM=;
 b=QACi1lE+4wdPWSesh671suCdTmMS6X3mC/DUdbR78M3Qoqgd/moxR9zftlOqG7smma8+YkjG1O+KpSGZA7SkBCLsPi2IQ2yW8a6CNu+Q4La+jcmLc0YTFqJXMkOQ1a1TN68y3EtFJDMlSAzLfp7UxeuS9AiqkUumz8RrQfNFG86FalILJ0mIUXUoQDpN9aYxCZ3FOQ+M9BioI+eiedfu+SgjzSvLCRNnuwOrn520SL995iJDJzDfU/yCgELgQ1D2vJW9eI93jlub4YqRU2DEJ1cutYudpGJKjUhYm3ZolraErjDE+yCLfxzwipIUwX5fPfkn7MmMoqC4vCssRBQnBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9Uk+/wkJD+SEzs1dd+ocAPxct2CnKt49JPtFNMO4yM=;
 b=uuy+qdwqbsw0Y6RavgZ7Ty+DzJD799DqNHx0eqgqgy8MSyG2cm6f+BpZcccVhCqsWkPIqyR1ibTaVJ2FYeCQgKkILKB1INifICXi2ak7KjtB5ShEs4taJRZrF2thDjHgxOjrs1dkm6N1GdewLouXoYuDQx4v/VDyG34cX/0MgBtnkfw85MdNndkBX/hMv//FnqEbyC4DjljUr9dfVJ29GotmovnoHmgiIR8YePzzfayl4FTuPxOSO3jKzKV32rZ8WEuZMUtpZOv12zi4/0S1TWLa+rCNEAY0R7pqnG5pE36EO4ql81Vwtl2B0MqNTzhWScw4sLJM4IdzAhsfBcpy1Q==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4895.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:2c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 08:11:12 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 08:11:12 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Marcel Holtmann <marcel@holtmann.org>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/6] btbcm: disable read tx power for MacBook Pro 16,1 (16
 inch, 2019)
Thread-Topic: [PATCH 2/6] btbcm: disable read tx power for MacBook Pro 16,1
 (16 inch, 2019)
Thread-Index: AQHX5PKQXvZS6gRfDUeYXwKSvRtbmqwaJqEAgAAAzwA=
Date:   Mon, 29 Nov 2021 08:11:12 +0000
Message-ID: <47A8DBEC-322F-4C42-AF69-5FDB828B8680@live.com>
References: <20211001083412.3078-1-redecorating@protonmail.com>
 <YYePw07y2DzEPSBR@kroah.com>
 <70a875d0-7162-d149-dbc1-c2f5e1a8e701@leemhuis.info>
 <20211116090128.17546-1-redecorating@protonmail.com>
 <e75bf933-9b93-89d2-d73f-f85af65093c8@leemhuis.info>
 <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com> <YZSuWHB6YCtGclLs@kroah.com>
 <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
 <5B9FF471-42DD-44DA-A9CE-0A83BA7A4212@live.com>
 <EBE48AE4-BCE3-42A6-BA8E-304C789C4667@holtmann.org>
In-Reply-To: <EBE48AE4-BCE3-42A6-BA8E-304C789C4667@holtmann.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [67/aF07I0Gec6ADm105hvEAyTCPeDiQnUaUnHujQQXzT6mx24vOmjlyN92nPc3mS]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b0be6a9-15df-4f43-66d0-08d9b30fcf0a
x-ms-traffictypediagnostic: PNZPR01MB4895:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: urY9UrGKkclTlTU5ppRBv0LYeJXLASXKynMO7mBIrSq8O6yAHIQK+W+qsjgmJR1/83Wxb8VguTJSxGEJrdY6IPG/h1ZisUUAY11nhUgpPyBuDguKpf40L+xVoy80A5CZpH1Ckei0B//UpU2DWp9X0LlE081dg1GvO2eaG5fftmFcnQtLXIs7ezE3AsC2YDyyr4cRCjKTVj1oq2oGCEQtIzD9SL5rGtpZhT2mQ0sPLvRJLLOkf+GwW2pjU+H4QvEhn1y4wXCzAW40TJXOO1rQi4qTVdBwU3KQYXAaRYKI1kco2vxdiqbUqXE9/eCpCbDmht3feNEu25/GwZkPdOePh74TUCVcBnrIOgFXKXxHJlRGwU5BF+iIa04kmvCqOmYkOjUHmt+Z4zk+JvFB7qI10QURSWqC+rnyWlMixsLUqsXpLQWo7N51Unryc96/QcF4WlfCJ6JaysDx+DLsFNolvch/mVlPR7HcWb2SF3Fo3LlpiANUhsYJeRqpCNQYQnmxG5ZYrYbCF7UmWti0h4uVTHiNB2YO09OmvFeWCvb81KTCpnDx1VPvuh9+yxPwg74DwgJqes0xbmE5tP3D4KJrGg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 8t2JM1tbpvtuElDIbAN3i/S4ym5RAWU1PgUxRdZMKtNIDP+tYx9SWd8V+F3e+Ic5uI73W83dbuZ5F+kvIS738lEZtXIlg73aDU8DaK9zlrdiH/2uGXLvoHb9m8cRUjvPnn7tZzKopaExZLvycwUfyLSBzkHcmsCydXLkxDrJY+ghL7SyvSHgdb+cvlRr0+7TPg07AxHLEgqglcpFkqq4IQLFMJ5sRy2t3q8BIW/NTKLUyHbwaAuKBYKmZMOWp7GV/LKjcbwiBdhCc7rTqNu3ClrFHxJ7GehFVsRQLzjK3t+41MScnaqywCFaMcVecRr9FR209UOC7DzRZ2YWWf7Fy/pS8zX0UosrUYpQg+O6TjzU1PU6bmrD8bCGKkkhVEsxmKR1/Zdt4RR2LrfVEZzsEXXM/U/e+z3FITrvfwAHNky6QU297hrXZBiXYBlw1p0uGPg9ya3ZmfKbD8oVChzlzycAEA+beyZMNjv0mHabovG44lqdLRSFoYaiD6RmUaHWlQlMevpfdrIKVOVuBr1eZOz9Cquch51tSdPV1fF9HjuRVmguu4ibx0Am7p7LlnGQozl6RlbZp0pOvVh3imkuHt3z4GNiLaA3PDIyQjZJflSRYdj7obokdW69df6JK+yzXBdFZsZN2gUGfqzwMQ/C6/Yk68fPi6zNobRwNMB/FLLb3JTy/CPnt73fzuh9WHaaKHrurxBCKu+dKqj7dlhx/827Q8QvqZe1LdrRnoQvk4hfQ+a8TuVVG3E0/bxg3MwhoC5uWMNVFX0PosGGBQXcGA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4546B0D0FC55E4084739A10E80D8344@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0be6a9-15df-4f43-66d0-08d9b30fcf0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 08:11:12.8704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4895
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gT24gMjktTm92LTIwMjEsIGF0IDE6MzggUE0sIE1hcmNlbCBIb2x0bWFubiA8bWFyY2Vs
QGhvbHRtYW5uLm9yZz4gd3JvdGU6DQo+IA0KPiBIaSBBZGl0eWEsDQo+IA0KPj4gQmx1ZXRvb3Ro
IG9uIEFwcGxlIE1hY0Jvb2sgUHJvIDE2LDEgaXMgdW5hYmxlIHRvIHN0YXJ0IGR1ZSB0byBMRSBN
aW4vTWF4IFR4IFBvd2VyIGJlaW5nIHF1ZXJpZWQgb24gc3RhcnR1cC4gQWRkIGEgRE1JIGJhc2Vk
IHF1aXJrIHNvIHRoYXQgaXQgaXMgZGlzYWJsZWQuDQo+IA0KPiBsaXN0IGFsbCB0aGUgTWFjQm9v
a3MgdGhhdCB5b3UgZm91bmQgcHJvYmxlbWF0aWMgcmlnaHQgbm93LiBXZSBhZGQgdGhlDQo+IGlu
aXRpYWwgYXMgYSBsYXJnZSBiYXRjaCBpbnN0ZWFkIG9mIGFsbCBpbmRpdmlkdWFsLg0KPiANCj4+
IA0KPj4gU2lnbmVkLW9mZi1ieTogQWRpdHlhIEdhcmcgPGdhcmdhZGl0eWEwOEBsaXZlLmNvbT4N
Cj4+IFRlc3RlZC1ieTogQWRpdHlhIEdhcmcgPGdhcmdhZGl0eWEwOEBsaXZlLmNvbT4NCj4+IC0t
LQ0KPj4gZHJpdmVycy9ibHVldG9vdGgvYnRiY20uYyB8IDIwICsrKysrKysrKysrKysrKysrKysr
DQo+PiAxIGZpbGUgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9ibHVldG9vdGgvYnRiY20uYyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2J0YmNtLmMN
Cj4+IGluZGV4IGU0MTgyYWNlZTQ4OGM1Li5jMWIwY2E2Mzg4MGE2OCAxMDA2NDQNCj4+IC0tLSBh
L2RyaXZlcnMvYmx1ZXRvb3RoL2J0YmNtLmMNCj4+ICsrKyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2J0
YmNtLmMNCj4+IEBAIC04LDYgKzgsNyBAQA0KPj4gDQo+PiAjaW5jbHVkZSA8bGludXgvbW9kdWxl
Lmg+DQo+PiAjaW5jbHVkZSA8bGludXgvZmlybXdhcmUuaD4NCj4+ICsjaW5jbHVkZSA8bGludXgv
ZG1pLmg+DQo+PiAjaW5jbHVkZSA8YXNtL3VuYWxpZ25lZC5oPg0KPj4gDQo+PiAjaW5jbHVkZSA8
bmV0L2JsdWV0b290aC9ibHVldG9vdGguaD4NCj4+IEBAIC0zNDMsOSArMzQ0LDIzIEBAIHN0YXRp
YyBzdHJ1Y3Qgc2tfYnVmZiAqYnRiY21fcmVhZF91c2JfcHJvZHVjdChzdHJ1Y3QgaGNpX2RldiAq
aGRldikNCj4+IAlyZXR1cm4gc2tiOw0KPj4gfQ0KPj4gDQo+PiArc3RhdGljIGNvbnN0IHN0cnVj
dCBkbWlfc3lzdGVtX2lkIGRpc2FibGVfYnJva2VuX3JlYWRfdHJhbnNtaXRfcG93ZXJbXSA9IHsN
Cj4+ICsJew0KPj4gKwkJLyogTWF0Y2ggZm9yIEFwcGxlIE1hY0Jvb2sgUHJvIDE2LDEgd2hpY2gg
bmVlZHMNCj4+ICsJCSAqIFJlYWQgTEUgTWluL01heCBUeCBQb3dlciB0byBiZSBkaXNhYmxlZC4N
Cj4+ICsJCSAqLw0KPiANCj4gQWN0dWFsbHkgbGVhdmUgdGhlIGNvbW1lbnQgb3V0LiBZb3UgYXJl
IG5vdCBhZGRpbmcgYW55IHZhbHVlIHRoYXQgaXNu4oCZdA0KPiBhbHJlYWR5IGluIHRoZSB2YXJp
YWJsZSBuYW1lIG9yIHRoZSBETUkuIEl0IGlzIGp1c3QgcmVwZWF0aW5nIHRoZSBvYnZpb3VzLg0K
QWxyaWdodCwgSSBwcmVwYXJlIHRoZSBwYXRjaGVzIGludG8gYSBzaW5nbGUgb25lDQo+IA0KPj4g
KwkJIC5tYXRjaGVzID0gew0KPj4gKwkJCURNSV9NQVRDSChETUlfQk9BUkRfVkVORE9SLCAiQXBw
bGUgSW5jLiIpLA0KPj4gKwkJCURNSV9NQVRDSChETUlfUFJPRFVDVF9OQU1FLCAiTWFjQm9va1By
bzE2LDEiKSwNCj4+ICsJCX0sDQo+PiArCX0sDQo+PiArCXsgfQ0KPj4gK307DQo+PiArDQo+PiBz
dGF0aWMgaW50IGJ0YmNtX3JlYWRfaW5mbyhzdHJ1Y3QgaGNpX2RldiAqaGRldikNCj4+IHsNCj4+
IAlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KPj4gKwljb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCAq
ZG1pX2lkOw0KPj4gDQo+PiAJLyogUmVhZCBWZXJib3NlIENvbmZpZyBWZXJzaW9uIEluZm8gKi8N
Cj4+IAlza2IgPSBidGJjbV9yZWFkX3ZlcmJvc2VfY29uZmlnKGhkZXYpOw0KPj4gQEAgLTM2Miw2
ICszNzcsMTEgQEAgc3RhdGljIGludCBidGJjbV9yZWFkX2luZm8oc3RydWN0IGhjaV9kZXYgKmhk
ZXYpDQo+PiANCj4+IAlidF9kZXZfaW5mbyhoZGV2LCAiQkNNOiBmZWF0dXJlcyAweCUyLjJ4Iiwg
c2tiLT5kYXRhWzFdKTsNCj4+IAlrZnJlZV9za2Ioc2tiKTsNCj4+ICsNCj4+ICsJLyogUmVhZCBE
TUkgYW5kIGRpc2FibGUgYnJva2VuIFJlYWQgTEUgTWluL01heCBUeCBQb3dlciAqLw0KPj4gKwlk
bWlfaWQgPSBkbWlfZmlyc3RfbWF0Y2goZGlzYWJsZV9icm9rZW5fcmVhZF90cmFuc21pdF9wb3dl
cik7DQo+PiArCWlmIChkbWlfaWQpDQo+PiArCQlzZXRfYml0KEhDSV9RVUlSS19CUk9LRU5fUkVB
RF9UUkFOU01JVF9QT1dFUiwgJmhkZXYtPnF1aXJrcyk7DQo+IA0KPiAJaWYgKGRtaV9maXJzdF9t
YXRjaCguLikpDQo+IAkJc2V0X2JpdCguLiwgJmhkZXYtPnF1aXJrcyk7DQo+IA0KPiBUaGVyZSBp
cyByZWFsbHkgbm8gbmVlZCB0byBoYXZlIGEgdmFyaWFibGUgZm9yIHRoaXMuDQpGaW5lLCBJbGwg
Y29ycmVjdCB0aGlzDQo+IA0KPiBSZWdhcmRzDQo+IA0KPiBNYXJjZWwNCj4gDQoNCg==
