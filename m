Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86A711F011
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 04:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfLNDBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 22:01:52 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:37134 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbfLNDBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 22:01:51 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B9D82C0116;
        Sat, 14 Dec 2019 03:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576292510; bh=BOjJLsl0xE29jNkx8cHPnpWJIMNw20xlQ7Q709hN1HU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=gUSFE7Qa4c2K441TSH4MKFJjcp/UcQ3VIVJCMd1KODKAiQPBrPChSv7uSZOeJaxcl
         1aYws3zGHkJsYPsD6Am64SzQ1VvU5Iq2Eu8D2unzmat5q4s5g8TAzYLrSmhXA5VOFZ
         oaYK0QyRHxifCo05nEz+Lp27HheQFWf5PiRxRpEs9mccDDsN8dQdD7AbJOZwzBJYmg
         EmH3UmdovYe0njNpnhZPo49riCLCOo5JjuHgRxEMyTfAdimvDilRWwcPLDMH7PIjT8
         o083a/gbioRSQNy/c5bU32OiHUz8EG4uaKLN8AvxnWlazFpZRPMGIc6NX2YZGto2dI
         WWYljD0dcDWgg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7F34CA0083;
        Sat, 14 Dec 2019 03:01:50 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 13 Dec 2019 19:01:41 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 13 Dec 2019 19:01:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbERpYK0+PdW0DDjjEc5XKBKQ3BcircefMcFzWc1+3QkUory3ilg1EbRchCb/NGufctWyPv/KiKmQJjsfszTNnlceKPRzW/0owr/hLwODblF4kL8RisUrD75PmxHsJSY5X7atMuUhJ7R3yotrxXQ3fzbwVpw+imbks33LtNj6eEdYX97Zm16tlxCoM5kv2qEemmqO5vrWUO+r13PdhriFkcoE9hF01XTR6ZjYeF/n5Zqvf4GAWDL4ymstr9d7tjdbwWXwsE8ymUp9Ji/BtEbVzNPH8rAJ+c7bFsvMLFZk/L5lmNeepoJlYvy4dCQEGTqW649shs5LBs4YODriB5UGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOjJLsl0xE29jNkx8cHPnpWJIMNw20xlQ7Q709hN1HU=;
 b=gZ+6MzDDrScRTX5v2n2+zRLrJCKBRb8gZWASQiBgIRyUsFGn7Gss6Y0oNDILjgC5MOnWKO6sVwgYDS8XYU0VIUi5gDCt85TtKxlEhM2QwK+rZy6N0Qe27k0GaaYknCatgctMAm9ofIbdKHhcZ6k+i9+RlsFNcUIl7y5rCw+Fl4Tqx5aD+ztn7zrwyVuoIZStjcjilC/3QLTyflnNs9vPHbM0zfpMp1hIFeaY+ZUijaJOsZQKRel6SfMwrShZ4b5Z5+7/H+iCgfVpPF5E2S0sm+J8oCIL6dWTlgEdPkSXTuj+Sbeg9nh23lTluZjXVfexbQ6ooUy/rJbKqAV7LE46Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOjJLsl0xE29jNkx8cHPnpWJIMNw20xlQ7Q709hN1HU=;
 b=ooBltAt0yB025b9cYzLkSx2w7w5TnW4lZfMtHW7gl+0gHtyRKN0KHGzaKhV9tQCEPK+IRfDk4gnK9lG5Ldno7RbWmjGJl9NsrFQ2k/wMyMJ7yAD5Hy7+vW4OkuGTu6IEpti4k24oeVfW4hNWrg0IVS+AXc22wvhDabtZjUWqdCE=
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com (10.172.78.22) by
 CY4PR1201MB0215.namprd12.prod.outlook.com (10.172.78.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Sat, 14 Dec 2019 03:01:40 +0000
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4]) by CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4%8]) with mapi id 15.20.2516.018; Sat, 14 Dec 2019
 03:01:40 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix request complete check
Thread-Topic: [PATCH] usb: dwc3: gadget: Fix request complete check
Thread-Index: AQHVsigAd9WQJ29skU2jXDoNP4DdNqe48UuA
Date:   Sat, 14 Dec 2019 03:01:40 +0000
Message-ID: <5a7554e4-a12e-d29c-1767-5dd75183922f@synopsys.com>
References: <ac5a3593a94fdaa3d92e6352356b5f7a01ccdc7c.1576291140.git.thinhn@synopsys.com>
In-Reply-To: <ac5a3593a94fdaa3d92e6352356b5f7a01ccdc7c.1576291140.git.thinhn@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [149.117.75.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51084fa8-5388-4c68-0315-08d78041f135
x-ms-traffictypediagnostic: CY4PR1201MB0215:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1201MB0215B1125B6E29DEB1C6E6AEAA570@CY4PR1201MB0215.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 025100C802
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(396003)(346002)(199004)(189003)(26005)(110136005)(6506007)(86362001)(2616005)(2906002)(5660300002)(31686004)(36756003)(54906003)(316002)(31696002)(186003)(6512007)(8676002)(8936002)(6486002)(81156014)(64756008)(76116006)(66946007)(4326008)(71200400001)(66476007)(66556008)(81166006)(478600001)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0215;H:CY4PR1201MB0037.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FxlAszZHZ93cnoNRhf//O8d41VU+luw0gbYinAm717+TdGiXrR6x5hh9WGgIAwE1PNxuzMy0smjdrtPgIuE7mtGG1NWjFH0yOAvz4htsFdkCX83+pZI6MOXIei3dTyZ2aB7jbSX0pyj9IdUle5VuGoxxmffDczM43w60s9MU59FbbPUp3zBhSTjhGEqrzd3R/mIbwnOd0+3U+bHQ8ni0m/ER18moKyEhH5ihDn7xrQWWLlnDl9FAl+Ubu/aJ8WnZwyOxXAA9VUzfyfgLP5sInc1Tp5zZ8Ijdv9VAKhUosrCnQoHi7txgEpErEPxoQjeqdLvfP4wpuXpHjXXxnhwbKEZkgxYxnR4E4AcOE8kiPVSXngw8xc+luaOu5arMF3OgNWHZqXZSZzI1cCRNZFGy0kg6xDK285HK4hzHv+RIMgdlWVPtEt3B+hpeUJ36Ylk1
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3F00FA53A3C324FBABF3DA2B57ED6C6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 51084fa8-5388-4c68-0315-08d78041f135
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2019 03:01:40.3077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jxzaMQwfY4T6sy4N77RiQTlDY+vTiZguNIwJcdU+IoR3yGdIAV1pJASHB7w4zDHgNXVlKKY4sulBwoOmfOem7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0215
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZyBhbmQgRmVsaXBlLA0KDQpUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+IFdlIGNhbiBvbmx5
IGNoZWNrIGZvciBJTiBkaXJlY3Rpb24gaWYgdGhlIHJlcXVlc3QgaGFkIGNvbXBsZXRlZC4gRm9y
IE9VVA0KPiBkaXJlY3Rpb24sIGl0J3MgcGVyZmVjdGx5IGZpbmUgdGhhdCB0aGUgaG9zdCBjYW4g
c2VuZCBsZXNzIHRoYW4gdGhlDQo+IHNldHVwIGxlbmd0aC4gTGV0J3MgcmV0dXJuIHRydWUgZmFs
bCBhbGwgY2FzZXMgb2YgT1VUIGRpcmVjdGlvbi4NCj4NCj4gRml4ZXM6IGUwYzQyY2U1OTBmZSAo
InVzYjogZHdjMzogZ2FkZ2V0OiBzaW1wbGlmeSBJT0MgaGFuZGxpbmciKQ0KPg0KPiBDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5ZW4gPHRoaW5o
bkBzeW5vcHN5cy5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgfCA3
ICsrKysrKysNCj4gICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspDQo+DQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIGIvZHJpdmVycy91c2IvZHdjMy9nYWRn
ZXQuYw0KPiBpbmRleCBiM2Y4NTE0ZDFmMjcuLmVkYzQ3OGMyMDg0NiAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdl
dC5jDQo+IEBAIC0yNDcwLDYgKzI0NzAsMTMgQEAgc3RhdGljIGludCBkd2MzX2dhZGdldF9lcF9y
ZWNsYWltX3RyYl9saW5lYXIoc3RydWN0IGR3YzNfZXAgKmRlcCwNCj4gICANCj4gICBzdGF0aWMg
Ym9vbCBkd2MzX2dhZGdldF9lcF9yZXF1ZXN0X2NvbXBsZXRlZChzdHJ1Y3QgZHdjM19yZXF1ZXN0
ICpyZXEpDQo+ICAgew0KPiArCS8qDQo+ICsJICogRm9yIE9VVCBkaXJlY3Rpb24sIGhvc3QgbWF5
IHNlbmQgbGVzcyB0aGFuIHRoZSBzZXR1cA0KPiArCSAqIGxlbmd0aC4gUmV0dXJuIHRydWUgZm9y
IGFsbCBPVVQgcmVxdWVzdHMuDQo+ICsJICovDQo+ICsJaWYgKCFyZXEtPmRpcmVjdGlvbikNCj4g
KwkJcmV0dXJuIHRydWU7DQo+ICsNCj4gICAJcmV0dXJuIHJlcS0+cmVxdWVzdC5hY3R1YWwgPT0g
cmVxLT5yZXF1ZXN0Lmxlbmd0aDsNCj4gICB9DQo+ICAgDQoNCk5vdCBzdXJlIGlmIGl0J3MgdG9v
IGxhdGUsIGJ1dCBhZnRlciBUZWphcydzIHBhdGNoKiB0aGF0IGZpeGVzIHRoZSBTRyANCmNoZWNr
IGluIGR3YzMsIGl0IGV4cG9zZXMgYW5vdGhlciBpc3N1ZS4gV2l0aG91dCB0aGlzIHBhdGNoLCBx
dWl0ZSBhIGZldyANCmZ1bmN0aW9uIGRyaXZlcnMgd2lsbCBub3Qgd29yayB3aXRoIGR3YzMuDQoN
CklmIHdlIGNhbiBwaWNrIGl0IHVwIGJlZm9yZSB0aGUgbmV4dCBtZXJnZSwgaXQnZCBiZSBncmVh
dC4NCg0KVGhhbmtzLA0KVGhpbmgNCg0KKlBhdGNoIG9uIEdyZWcncyBicmFuY2ggdXNiLWxpbnVz
OiA4YzdkNGI3YjNkNDMgKCJ1c2I6IGR3YzM6IGdhZGdldDogRml4IA0KbG9naWNhbCBjb25kaXRp
b24iKQ0K
