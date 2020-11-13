Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA7F2B1F24
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 16:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgKMPtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 10:49:02 -0500
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:64210
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726437AbgKMPtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 10:49:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIg7bFFDcVKSvDQSA5IcaI7YIajOvo4m+2LI/hn5OhdjY6nZHvIyMEIEpgToTlWEjsLhJ3VzgpftAMAwP0CcQiSA/y+3AUH4vml/BrA34iCHIiCSvCZtRvRdnxd9e2iVtyXz5iw2rqGS2z8uWJdj7ueHB8IXzqrwdhKX73IgjAXAt/R1/Vpz+3GpaCiAISCXYOBe6FllokUL5HVxbuz+fjUNo41tMR+sEVEaSkB6kp6XxXDf/jkVJUkod9CPDczVIezh3h8w5mHr/Krh5hlfEUZIG7bLhhQEMmDtE1YWD73HxKFl62m6FrMjEPLRLQLIdxVP9qpOFWsWqzqpTvSSVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOPIzImRDYgEMrzBBDMWCshgZWp/gLYwBH7milchkZU=;
 b=h+d3daqNvSs8m40XKGFnIFwvf3izGlHOC+n261NrRtVvlZdi/ONW0W3IZX0+xjJ4LTqBju2+D4zXUez4YoC5vuUiMTy61wG8BkZV123EMEbC+BCjLKJhkwiBASodWelppfm7/hotkHDHuUZ+y1GDOFtwNWB5d+R7Bf1lGTlHGswfrt4RDVWWNWWXLgxl5ZMyOdHx5l0q4jVTVgOirV0kQdBTmleVl/PJenLGWaw7mJA/0wJJ6WVM0VBms9vXqixRUVCic+CSsDdXyIrfdabkzUbwVJBRZQJn4HvWpG9pkB26u5/cKVvc6drjcFAghYDsLShKiF2BKKdwtUfW1ROqYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOPIzImRDYgEMrzBBDMWCshgZWp/gLYwBH7milchkZU=;
 b=D8QneKFHSNnyVQzv7GG5nclTFTSvKRAUkmXB0Us24W+vzIY4TD8ER3U0wk/09NY/0wygnWbgVXPklL1kDO0P5DVEYrVuVu0j4QpasThOl9koUMMvsd6Uco9jc6yCc9egQKpTGniQ9xaIP6fz7iyUvfJvOrNjYauWSm/of6EU7rA=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR10MB1943.namprd10.prod.outlook.com
 (2603:10b6:903:11a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 13 Nov
 2020 15:48:59 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::6d08:ba9e:476a:8523]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::6d08:ba9e:476a:8523%6]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 15:48:59 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ALSA: usb-audio: Add delay quirk for all Logitech USB
 devices
Thread-Topic: [PATCH] ALSA: usb-audio: Add delay quirk for all Logitech USB
 devices
Thread-Index: AQHWudMglpstayskekOO5Bc0b19TYanGNVkA
Date:   Fri, 13 Nov 2020 15:48:59 +0000
Message-ID: <51f0d803f7f48c5f1e5068e12f1f186a169b4fbd.camel@infinera.com>
References: <20201113153720.5158-1-joakim.tjernlund@infinera.com>
In-Reply-To: <20201113153720.5158-1-joakim.tjernlund@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a8a89b1-84f5-443c-2833-08d887eba31c
x-ms-traffictypediagnostic: CY4PR10MB1943:
x-microsoft-antispam-prvs: <CY4PR10MB1943F6188AD9AD6894FCCC57F4E60@CY4PR10MB1943.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Sz/OQpMHE8VynXoamQR7o6/jcObSvikllBtdBuS9hp96xAD8jh1wt8Zcf7uBHZZCpskqwOggPmUz1R0AXwdDDVNC9X40dmzUMpUcH2S6e5kT1YFkB/RPYSCiIlqTNXyomnrg0syI3Vj4gsldCVNImVhoQMnlnxt+GRfQhKljt1GFfb51/g8NzECtCwBONHU7bTuzr7219eGixVhmo2/LkYCxgmh8yjZU2Sf99qNQ3526xDfig+rj6CrHGcmHn+kezr5FGnFEAqKnbNT7hWMDIyh32b4yIPgSUEKz8CnlQou9LQbpZSz6sp0OtcsVXX6l4EQj3aV/8y8Rd2VVIknMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(66946007)(64756008)(91956017)(26005)(6916009)(5660300002)(4326008)(71200400001)(8936002)(450100002)(76116006)(66556008)(83380400001)(186003)(2616005)(66476007)(8676002)(66446008)(316002)(2906002)(4001150100001)(86362001)(36756003)(6512007)(6486002)(6506007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DMH9N+X8CYqFpI57fTTS+lsWYXvicVwj5+y5Fx/2JDcwpFg6LZ44WXfe8JnLIMDYxLN8jBlLDLTVM/1kmVanP3C/13g/rdBcDc+SPXgmNNoOYlL1Rx/mm8ecRqeBoxntvwr9hUarKqtUTGifay0cm2JYG55YxvdEaTPly3lYXa7wu9Z/BBrCyQubNWG1AZSnQo/TVvjDCdkQkXdGXSvgqj5VsoI6YwhTuuOPR0ixMOGn1hl3DDep+NPJlMVDBZ1T1qVq+1/4R8h1T+3TzDweHDLCVTNQM+tAe/w92cUkrlEUM28QWUaiOq/cuL4wS9DSgfZ0YmC1UNXWZ7WtKvx1809gATeX4YO2IQM8m+zSaPup+KZx9biQ6UJpuLU03RvdTTfFuzIimI3LQzPDZ65SM2gSEAW/CQrTjTCBKk87S0GqQ155hTrotdH5atrPp8/bWSqYxjHxxoZzWBK7udc5mWcWXKvVQ9AdBcNR9EORbsj2ex8yW6zk56EUPKYdJ6q8SCpujusVDOvHMVAkzRd1x/DBVCXXEsxeQgvMfvDiAYH0Rw2AcffnAhf+hF/qV5WavSaNIh0P/MJew1jsD0SypYbydP3do4rx2Yi3ivktXSkTCv89d06wZJSqDMWUX9wD3h8/Z7V5fz48vGJfzlRQmg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <271A9E38262D0845943A7BC8FFE7650D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8a89b1-84f5-443c-2833-08d887eba31c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 15:48:59.5601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Ve4MN6o5ZXT89IGvZJmF+YsdbFcclwdcYjx9TcSlOJw7maxeqZyesypRgbs2jcgb59/1aV3ADpzM0oXemdcYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1943
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTEzIGF0IDE2OjM3ICswMTAwLCBKb2FraW0gVGplcm5sdW5kIHdyb3Rl
Og0KPiBGb3VuZCBvbmUgbW9yZSBMb2dpdGVjaCBkZXZpY2UsIEJDQzk1MCBDb25mZXJlbmNlQ2Ft
LCB3aGljaCBuZWVkcw0KPiB0aGUgc2FtZSBkZWxheSBoZXJlLiBUaGlzIG1ha2VzIDMgb3V0IG9m
IDMgZGV2aWNlcyBJIGhhdmUgdHJpZWQuDQo+IA0KPiBUaGVyZWZvcmUsIGFkZCBhIGRlbGF5IGZv
ciBhbGwgTG9naXRlY2ggZGV2aWNlcyBhcyBpdCBkb2VzIG5vdCBodXJ0Lg0KDQpNYXliZSB0aGlz
IGRlbGF5IHNob3VsZCBqdXN0IGJlIGRlZmF1bHQgZm9yIGFsbCBVU0IgYXVkaW8gZGV2aWNlcz8N
Cg0KIEpvY2tlDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBUamVybmx1bmQgPGpvYWtp
bS50amVybmx1bmRAaW5maW5lcmEuY29tPg0KPiBDQzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAo
NC4xOSwgNS40KQ0KPiANCj4gLS0tDQo+IMKgc291bmQvdXNiL3F1aXJrcy5jIHwgMTAgKysrKyst
LS0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvc291bmQvdXNiL3F1aXJrcy5jIGIvc291bmQvdXNiL3F1aXJr
cy5jDQo+IGluZGV4IGM5ODlhZDgwNTJhZS4uYzUwYmUyZjc1ZjcwIDEwMDY0NA0KPiAtLS0gYS9z
b3VuZC91c2IvcXVpcmtzLmMNCj4gKysrIGIvc291bmQvdXNiL3F1aXJrcy5jDQo+IEBAIC0xNjcy
LDEzICsxNjcyLDEzIEBAIHZvaWQgc25kX3VzYl9jdGxfbXNnX3F1aXJrKHN0cnVjdCB1c2JfZGV2
aWNlICpkZXYsIHVuc2lnbmVkIGludCBwaXBlLA0KPiDCoAkgICAgJiYgKHJlcXVlc3R0eXBlICYg
VVNCX1RZUEVfTUFTSykgPT0gVVNCX1RZUEVfQ0xBU1MpDQo+IMKgCQltc2xlZXAoMjApOw0KPiDC
oA0KPiANCj4gDQo+IA0KPiAtCS8qIFpvb20gUjE2LzI0LCBMb2dpdGVjaCBINjUwZS9INTcwZSwg
SmFicmEgNTUwYSwgS2luZ3N0b24gSHlwZXJYDQo+IC0JICogIG5lZWRzIGEgdGlueSBkZWxheSBo
ZXJlLCBvdGhlcndpc2UgcmVxdWVzdHMgbGlrZSBnZXQvc2V0DQo+IC0JICogIGZyZXF1ZW5jeSBy
ZXR1cm4gYXMgZmFpbGVkIGRlc3BpdGUgYWN0dWFsbHkgc3VjY2VlZGluZy4NCj4gKwkvKiBab29t
IFIxNi8yNCwgbWFueSBMb2dpdGVjaChhdCBsZWFzdCBINjUwZS9INTcwZS9CQ0M5NTApLA0KPiAr
CSAqIEphYnJhIDU1MGEsIEtpbmdzdG9uIEh5cGVyWCBuZWVkcyBhIHRpbnkgZGVsYXkgaGVyZSwN
Cj4gKwkgKiBvdGhlcndpc2UgcmVxdWVzdHMgbGlrZSBnZXQvc2V0IGZyZXF1ZW5jeSByZXR1cm4N
Cj4gKwkgKiBhcyBmYWlsZWQgZGVzcGl0ZSBhY3R1YWxseSBzdWNjZWVkaW5nLg0KPiDCoAkgKi8N
Cj4gwqAJaWYgKChjaGlwLT51c2JfaWQgPT0gVVNCX0lEKDB4MTY4NiwgMHgwMGRkKSB8fA0KPiAt
CSAgICAgY2hpcC0+dXNiX2lkID09IFVTQl9JRCgweDA0NmQsIDB4MGE0NikgfHwNCj4gLQkgICAg
IGNoaXAtPnVzYl9pZCA9PSBVU0JfSUQoMHgwNDZkLCAweDBhNTYpIHx8DQo+ICsJICAgICBVU0Jf
SURfVkVORE9SKGNoaXAtPnVzYl9pZCkgPT0gMHgwNDZkICB8fCAvKiBMb2dpdGVjaCAqLw0KPiDC
oAkgICAgIGNoaXAtPnVzYl9pZCA9PSBVU0JfSUQoMHgwYjBlLCAweDAzNDkpIHx8DQo+IMKgCSAg
ICAgY2hpcC0+dXNiX2lkID09IFVTQl9JRCgweDA5NTEsIDB4MTZhZCkpICYmDQo+IMKgCSAgICAo
cmVxdWVzdHR5cGUgJiBVU0JfVFlQRV9NQVNLKSA9PSBVU0JfVFlQRV9DTEFTUykNCg0K
