Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10021924EF
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 11:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCYKCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 06:02:47 -0400
Received: from mail-eopbgr30114.outbound.protection.outlook.com ([40.107.3.114]:42230
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgCYKCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 06:02:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UB79wf/ZMWPGJ3jZWkZDz80/sMZzVbBds8Kr5ArPDTScxlhni2XR20RdPeQX1fkMNO70OMvVgy+hlsBInGEG91GSq2vrdoUVKDrF1Twlp8/Zv8gbuZvu3mQWoB8ntFkYGm5FwYOibqjKA8yigxf4s2m0cFvC07Egg3FUqmen0InFF3/YFv/36v7pIMNm0ePOI0vZ+vYsTGlDfVIHCWMzZS/Zd94m9atSqiAg4ewSdMnLvtQM2rsFQaHYiaSNkX/OdGjtPrG83NY48FjYDSHksm7JnLKs+gaOG7AGMVFs9SN63tnjD6HCeMUV4X0fdJXncdmxBDTtnMdm86bKbLFxKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lis+06dtj/TfA2Pn9gFLzOGtNERcqEjkMGrOwU1+npM=;
 b=Dc0RybGe5XCX2fzYJOU+PBm07gpYf6vo9lXZltMcdy4rDG9nYIjX49ZbtUWisScOoXE/nrtvp24f3ZNda1xD2mQTlSMtAKe3gwaqOr3W6IWo2dJe/yyPZdw/mlJvY4sNoJhZlaoNmSQrlLkMg7egM/p3lIanMI/h/0cx1xZFC+l8ZxnjUqIIoQPrIih9ZKFFaGVCExFoMDz48kSYbCEGHvzz11T+Afmm6rBW+chubxz8HvTGhopyrVdH0QDac8woW8DQMXuR9pTHgbD7B7LDwIXHk/G08KVUuIpgtvXUpBCSQSmyBlJc/+u+n8/+I6f19bX306z5dVXlEjS5BMm7Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lis+06dtj/TfA2Pn9gFLzOGtNERcqEjkMGrOwU1+npM=;
 b=ixX4KYyeVbYdJJqjqe7xUoi7sWQWNaCXJyuGRvXOsf86wkyOyKZh1B+fJ3kDYKfzdOQmBT9/uhO5UKWlNirC5X0CiBXp91ibCfoUxE9oqs5r15rzQ1FNKsYYhn3PGGOwXL0FD7OjtbVt+aDPxoMDoNN/R8zyUgc80ZCV05kF428=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) by
 HE1PR0702MB3659.eurprd07.prod.outlook.com (52.133.6.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Wed, 25 Mar 2020 10:02:41 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87%5]) with mapi id 15.20.2856.017; Wed, 25 Mar 2020
 10:02:41 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "osandov@fb.com" <osandov@fb.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: 4.19 LTS high /proc/diskstats io_ticks
Thread-Topic: 4.19 LTS high /proc/diskstats io_ticks
Thread-Index: AQHWAoyFep1pzs45BEyxl7dts+ZHIA==
Date:   Wed, 25 Mar 2020 10:02:41 +0000
Message-ID: <564f7f3718cdc85f841d27a358a43aee4ca239d6.camel@nokia.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-originating-ip: [131.228.2.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e5989092-aae0-4a2d-344b-08d7d0a3a844
x-ms-traffictypediagnostic: HE1PR0702MB3659:
x-microsoft-antispam-prvs: <HE1PR0702MB365991557EBBCBD2A71B2B6AB4CE0@HE1PR0702MB3659.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(81156014)(316002)(6512007)(71200400001)(8676002)(86362001)(54906003)(76116006)(478600001)(81166006)(110136005)(66556008)(64756008)(66446008)(66476007)(66946007)(8936002)(36756003)(4326008)(966005)(2906002)(5660300002)(2616005)(6506007)(26005)(6486002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3659;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eiP7lbwyplkKIIWE+5V78dv7rDrdC+fheYLsPgvb6CRHtkCeTyP5xElrMQQonhQPgMoK0knfDhscbRm+6w8+fyrHosfbOonWfC1xv1YqN8kWac8fZcxKh4RlqqrnN2laRwzfKfm/FuizqRV/CxP/+C1BRocCrercWyVHslIa+QSJhqvW7SqQTD0tAnm8NCDyHg6lFx+TOTvHDofKLKMeNfaWl+4ZnNXPAvkGYOW8HkHTGd5InBUGBSHszJlo2++FCEgT61qLQe4GivwRHxEKRkxWocdxnVm0Pl61H7U/MYpaS78JcPFUhxcg/hX2gtrFrWTbNpBLzN0EGC4XjXhwtALqp5STcuo2zx30evwAw8/p2nVUHZIwQCZQvsQ7FYGOU5XMo2uQ6gUiOXtvZe5agldDoAv1MDr9vH/ysJRbwRmoGDNF2tmy5gZZmV6GYz9xa7trbTug36TMV3abkMgJyZ5LnsXmWDEdpCefZzaoibRaXHwm5c55mmrN+8MIGM/ae8O7Qw8P83+7IPaIx69bTg==
x-ms-exchange-antispam-messagedata: sdqDnKl7YL7XPlamH3kXcbBUw0wEFCYYCGGqGYOr/IXkATImswxMBiB1Z2IuWGRasIZIFACwlb1vLhSZA/5BySBQcIbgvdV5gS1k0tfgLnMFu4UZX2J+JZGSbmXGwD9M77KucvyjO2ThWctkKPGgIA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7FCF671CAF08F45AC44ED26D6A2F181@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5989092-aae0-4a2d-344b-08d7d0a3a844
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 10:02:41.5964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J9M7bFBITNfTZzTSjUB3xaxhQp+CVll4lL7wMaA/ys1eDQfxXPAUFDOTCM8kJZnu8kqIgJfapXhj/s7I5Q3q/iJOqlIHvEPfqn1PahSylkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3659
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNClRvb2xzIGxpa2Ugc2FyIGFuZCBpb3N0YXQgYXJlIHJlcG9ydGluZyBhYm5vcm1hbGx5
IGhpZ2ggJXV0aWwgd2l0aCA0LjE5LnkNCnJ1bm5pbmcgaW4gVk0gKHRoZSBkaXNrIGlzIGFsbW9z
dCBpZGxlKToNCg0KICAkIHNhciAtZHANCiAgTGludXggNC4xOS4xMDctMS54ODZfNjQgICAwMy8y
NS8yMCAgICBfeDg2XzY0XyAgICg2IENQVSkNCg0KICAwMDowMDowMCAgICAgICAgREVWICAgICAg
IHRwcyAgICAgIC4uLiAgICAgJXV0aWwNCiAgMDA6MTA6MDAgICAgICAgIHZkYSAgICAgIDAuNTUg
ICAgICAuLi4gICAgIDk4LjA3DQogIC4uLg0KICAxMDowMDowMCAgICAgICAgdmRhICAgICAgMC40
NCAgICAgIC4uLiAgICAgOTkuNzQNCiAgQXZlcmFnZTogICAgICAgIHZkYSAgICAgIDAuNDggICAg
ICAuLi4gICAgIDk4Ljk4DQoNClRoZSBudW1iZXJzIGxvb2sgcmVhc29uYWJsZSBmb3IgdGhlIHBh
cnRpdGlvbjoNCg0KICAjIGlvc3RhdCAteCAtcCBBTEwgMSAxDQogIExpbnV4IDQuMTkuMTA3LTEu
eDg2XzY0ICAgMDMvMjUvMjAgICAgX3g4Nl82NF8gICg2IENQVSkNCg0KICBhdmctY3B1OiAgJXVz
ZXIgICAlbmljZSAlc3lzdGVtICVpb3dhaXQgICVzdGVhbCAgICVpZGxlDQogICAgICAgICAgICAx
MC41MSAgICAwLjAwICAgIDguNTggICAgMC4wNSAgICAwLjExICAgODAuNzUNCg0KICBEZXZpY2Ug
ICAgICAgICAgICByL3MgICAgIC4uLiAgJXV0aWwNCiAgdmRhICAgICAgICAgICAgICAwLjAyICAg
ICAuLi4gIDk4LjI1DQogIHZkYTEgICAgICAgICAgICAgMC4wMSAgICAgLi4uICAgMC4wOQ0KDQoN
CkxvdHMgb2YgaW9fdGlja3MgaW4gL3Byb2MvZGlza3N0YXRzOg0KDQojIGNhdCAvcHJvYy91cHRp
bWUNCjQ1Nzg3LjAzIDIyOTMyMS4yOQ0KDQojIGdyZXAgdmRhIC9wcm9jL2Rpc2tzdGF0cw0KIDI1
MyAgICAgIDAgdmRhIDc2MCAwIDM4NDk4IDczMSAyODE2NSA0MzIxMiAxNDYyOTI4IDE1NzUxNCAw
IDQ0NjkwMjYzDQo0NDgxMjAzMiAwIDAgMCAwDQogMjUzICAgICAgMSB2ZGExIDM1MCAwIDE5MDc0
IDI5MyAyNjE2OSA0MzIxMiAxNDYyOTEyIDE1NDkzMSAwIDQxNTYwIDE1MDk5OA0KMCAwIDAgMA0K
DQoNCk90aGVyIHBlb3BsZSBhcmUgYXBwYXJlbnRseSBzZWVpbmcgdGhpcyB0b28gd2l0aCA0LjE5
Og0KaHR0cHM6Ly9rdWR6aWEuZXUvYi8yMDE5LzA5L2lvc3RhdC14LTEtcmVwb3J0aW5nLTEwMC11
dGlsaXphdGlvbi1vZi1uZWFybHktaWRsZS1udm1lLWRyaXZlcy8NCg0KDQpJIGFsc28gc2VlIHRo
aXMgb25seSBpbiA0LjE5LnkgYW5kIGJpc2VjdGVkIHRvIHRoaXMgKGJhc2VkIG9uIHRoZSBGaXhl
cw0KdGFnLCB0aGlzIHNob3VsZCBoYXZlIGJlZW4gdGFrZW4gdG8gNC4xNCB0b28uLi4pOg0KDQpj
b21taXQgNjEzMTgzN2IxZGU2NjExNjQ1OWVmNDQxM2UyNmZkYmM3MGQwNjZkYw0KQXV0aG9yOiBP
bWFyIFNhbmRvdmFsIDxvc2FuZG92QGZiLmNvbT4NCkRhdGU6ICAgVGh1IEFwciAyNiAwMDoyMTo1
OCAyMDE4IC0wNzAwDQoNCiAgYmxrLW1xOiBjb3VudCBhbGxvY2F0ZWQgYnV0IG5vdCBzdGFydGVk
IHJlcXVlc3RzIGluIGlvc3RhdHMgaW5mbGlnaHQNCg0KICBJbiB0aGUgbGVnYWN5IGJsb2NrIGNh
c2UsIHdlIGluY3JlbWVudCB0aGUgY291bnRlciByaWdodCBhZnRlciB3ZQ0KICBhbGxvY2F0ZSB0
aGUgcmVxdWVzdCwgbm90IHdoZW4gdGhlIGRyaXZlciBoYW5kbGVzIGl0LiBJbiBib3RoIHRoZSBs
ZWdhY3kNCiAgYW5kIGJsay1tcSBjYXNlcywgcGFydF9pbmNfaW5fZmxpZ2h0KCkgaXMgY2FsbGVk
IGZyb20NCiAgYmxrX2FjY291bnRfaW9fc3RhcnQoKSByaWdodCBhZnRlciB3ZSd2ZSBhbGxvY2F0
ZWQgdGhlIHJlcXVlc3QuIGJsay1tcQ0KICBvbmx5IGNvbnNpZGVycyByZXF1ZXN0cyBzdGFydGVk
IHJlcXVlc3RzIGFzIGluZmxpZ2h0LCBidXQgdGhpcyBpcw0KICBpbmNvbnNpc3RlbnQgd2l0aCB0
aGUgbGVnYWN5IGRlZmluaXRpb24gYW5kIHRoZSBpbnRlbnRpb24gaW4gdGhlIGNvZGUuDQogIFRo
aXMgcmVtb3ZlcyB0aGUgc3RhcnRlZCBjb25kaXRpb24gYW5kIGluc3RlYWQgY291bnRzIGFsbCBh
bGxvY2F0ZWQNCiAgcmVxdWVzdHMuDQoNCiAgRml4ZXM6IGYyOTliN2M3YTlkZSAoImJsay1tcTog
cHJvdmlkZSBpbnRlcm5hbCBpbi1mbGlnaHQgdmFyaWFudCIpDQogIFNpZ25lZC1vZmYtYnk6IE9t
YXIgU2FuZG92YWwgPG9zYW5kb3ZAZmIuY29tPg0KICBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9l
IDxheGJvZUBrZXJuZWwuZGs+DQoNCmRpZmYgLS1naXQgYS9ibG9jay9ibGstbXEuYyBiL2Jsb2Nr
L2Jsay1tcS5jDQppbmRleCBjMzYyMTQ1M2FkODcuLjU0NTBjYmM2MWY4ZCAxMDA2NDQNCi0tLSBh
L2Jsb2NrL2Jsay1tcS5jDQorKysgYi9ibG9jay9ibGstbXEuYw0KQEAgLTk1LDE4ICs5NSwxNSBA
QCBzdGF0aWMgdm9pZCBibGtfbXFfY2hlY2tfaW5mbGlnaHQoc3RydWN0IGJsa19tcV9od19jdHgN
CipoY3R4LA0KIHsNCiAgICAgICAgc3RydWN0IG1xX2luZmxpZ2h0ICptaSA9IHByaXY7DQogDQot
ICAgICAgIGlmIChibGtfbXFfcnFfc3RhdGUocnEpID09IE1RX1JRX0lOX0ZMSUdIVCkgew0KLSAg
ICAgICAgICAgICAgIC8qDQotICAgICAgICAgICAgICAgICogaW5kZXhbMF0gY291bnRzIHRoZSBz
cGVjaWZpYyBwYXJ0aXRpb24gdGhhdCB3YXMgYXNrZWQNCi0gICAgICAgICAgICAgICAgKiBmb3Iu
IGluZGV4WzFdIGNvdW50cyB0aGUgb25lcyB0aGF0IGFyZSBhY3RpdmUgb24gdGhlDQotICAgICAg
ICAgICAgICAgICogd2hvbGUgZGV2aWNlLCBzbyBpbmNyZW1lbnQgdGhhdCBpZiBtaS0+cGFydCBp
cyBpbmRlZWQNCi0gICAgICAgICAgICAgICAgKiBhIHBhcnRpdGlvbiwgYW5kIG5vdCBhIHdob2xl
IGRldmljZS4NCi0gICAgICAgICAgICAgICAgKi8NCi0gICAgICAgICAgICAgICBpZiAocnEtPnBh
cnQgPT0gbWktPnBhcnQpDQotICAgICAgICAgICAgICAgICAgICAgICBtaS0+aW5mbGlnaHRbMF0r
KzsNCi0gICAgICAgICAgICAgICBpZiAobWktPnBhcnQtPnBhcnRubykNCi0gICAgICAgICAgICAg
ICAgICAgICAgIG1pLT5pbmZsaWdodFsxXSsrOw0KLSAgICAgICB9DQorICAgICAgIC8qDQorICAg
ICAgICAqIGluZGV4WzBdIGNvdW50cyB0aGUgc3BlY2lmaWMgcGFydGl0aW9uIHRoYXQgd2FzIGFz
a2VkIGZvci4NCmluZGV4WzFdDQorICAgICAgICAqIGNvdW50cyB0aGUgb25lcyB0aGF0IGFyZSBh
Y3RpdmUgb24gdGhlIHdob2xlIGRldmljZSwgc28NCmluY3JlbWVudA0KKyAgICAgICAgKiB0aGF0
IGlmIG1pLT5wYXJ0IGlzIGluZGVlZCBhIHBhcnRpdGlvbiwgYW5kIG5vdCBhIHdob2xlIGRldmlj
ZS4NCisgICAgICAgICovDQorICAgICAgIGlmIChycS0+cGFydCA9PSBtaS0+cGFydCkNCisgICAg
ICAgICAgICAgICBtaS0+aW5mbGlnaHRbMF0rKzsNCisgICAgICAgaWYgKG1pLT5wYXJ0LT5wYXJ0
bm8pDQorICAgICAgICAgICAgICAgbWktPmluZmxpZ2h0WzFdKys7DQogfQ0KIA0KIHZvaWQgYmxr
X21xX2luX2ZsaWdodChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IGhkX3N0cnVjdCAq
cGFydCwNCg0KDQoNCklmIEkgZ2V0IGl0IHJpZ2h0LCB3aGVuIHRoZSBkaXNrIGlzIGlkbGUsIGFu
ZCBzb21lIHJlcXVlc3QgaXMgYWxsb2NhdGVkLA0KcGFydF9yb3VuZF9zdGF0cygpIHdpdGggdGhp
cyBjb21taXQgd2lsbCBub3cgYWRkIGFsbCB0aWNrcyBiZXR3ZWVuDQpwcmV2aW91cyBJL08gYW5k
IGN1cnJlbnQgdGltZSAobm93IC0gcGFydC0+c3RhbXApIHRvIGlvX3RpY2tzLg0KDQpCZWZvcmUg
dGhlIGNvbW1pdCwgcGFydF9yb3VuZF9zdGF0cygpIHdvdWxkIG9ubHkgdXBkYXRlIHBhcnQtPnN0
YW1wIHdoZW4NCmNhbGxlZCBhZnRlciByZXF1ZXN0IGFsbG9jYXRpb24uDQoNCkFueSB0aG91Z2h0
cyBob3cgdG8gYmVzdCBmaXggdGhpcyBpbiA0LjE5Pw0KSSBzZWUgdGhlIGlvX3RpY2tzIGFjY291
bnRpbmcgaGFzIGJlZW4gcmV3b3JrZWQgaW4gNS4wLCBkbyB3ZSBuZWVkIHRvDQpiYWNrcG9ydCB0
aG9zZSB0byA0LjE5LCBvciBhbnkgaWxsIGVmZmVjdHMgaWYgdGhpcyBjb21taXQgaXMgcmV2ZXJ0
ZWQgaW4NCjQuMTk/DQoNCi1Ub21taQ0KDQo=
