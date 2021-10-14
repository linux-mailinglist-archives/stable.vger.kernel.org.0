Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5325442D168
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 06:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhJNERN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 00:17:13 -0400
Received: from mail-ma1ind01olkn0159.outbound.protection.outlook.com ([104.47.100.159]:3467
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229457AbhJNERM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 00:17:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoxQ5dc558q4V6+ujyYyVXaFC99+Au5hYQPgTiDjSkH43Q1qX9ZlBVwTxJlAmrXOE2jkWYaF6wcYKqUpvT8FKWoGuMk3U9H48ezrye7O3oTFctqVYqGEJjTOmcotzj6Uyi5aUzBkNUjpu/ehmi6lPED+oO43UVRKUOo0nIxPvGgXq5x+E2tLixIr0/OXyUrPvFetQLCD2wGj+nBKU0iCsQ3Hp8829rECAx+cvw+4Ak/aWE10PdAwG2orSyhQgTM5DvsrSIpYJdRM6CAIVAEROHCmNgn/c2QiA4SqFsOS02plUzUgEP4RfjnZIcJ8ctYmj4o31tPHZhdA3eeqp3qrWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hnd5z/O8+Bp4tU/hZTjVUF7vxy9UghK2kfSxxsyR5X8=;
 b=MYX4HbESV/ZuPrOR/iBIkEhAfh3tS1PFe9hq8kNR6myhVHTMGgtwAbquc8n1nC98ptjRNIpsF0hEnDWoZPk38D+CfnIU1mStb4fqdeYEpLd+qNiWYaatxbwS7U3vJ40/Sr/lyhWzdazjWIm1F1fYlutIuHKjkh+m/IDL0D3GdolSl9tyLd6DacKKmTROWeVr77csg1ZC0lfOhk+3N6ud46mFtT7taJiSZ5FbU1WozN4f7u03N7xVwtyu4/WAApIwHDIp5D/eG1fRotwWjgCZP9AGnysfjnSN/AUh42YtIUf94AmJfq3F7Cxh7sedyntt2/9mezCmwUUmczklhAb9mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hnd5z/O8+Bp4tU/hZTjVUF7vxy9UghK2kfSxxsyR5X8=;
 b=pBDFQweLAp0tcex/cKs/HT3T2aktZJF5PWeyn6T1C8BTnKwvsBpEfttbXDImgJQgXirhwc7liABI3C520cwAWNr0gpAr4DcxnFVC9pHDe1x/1irFsjlxNuR54O0f/exHqnMGNCAl1b/rs5jyq4rGWFgS9d7PiOa9r7P8eKIq97VdS3YIX681/nPqnLuoVlHiMUlhbP9HIJQnFTe4V4Q5GmvdngI6AsPfG4Mj9nyMV/G4Yal8c4BmukfvQ7dAk5KlktYuPMXuCTvxity7NVPHr4uX4gFVeXl3Ja7rZ5Skl3fvlQFYg0KVo3F3D2A1hgKUoP8qTezt0z5VPYoWccL3KQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB5015.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:5a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 14 Oct
 2021 04:15:05 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::fc30:dd98:6807:9ea]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::fc30:dd98:6807:9ea%4]) with mapi id 15.20.4587.026; Thu, 14 Oct 2021
 04:15:05 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Thread-Topic: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Thread-Index: AQHXuZ5MX/VfaFrLFEeYbYAmwFc+mqvPTb8AgAKjIYA=
Date:   Thu, 14 Oct 2021 04:15:05 +0000
Message-ID: <FC366D8C-0360-49B2-B641-5A3FD50E3398@live.com>
References: <7E63F4C9-6AE9-4E97-9986-B13A397289C5@live.com>
 <YWV4bnbn7VXjYWWy@google.com>
In-Reply-To: <YWV4bnbn7VXjYWWy@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [39oI0cuApYZ6k4j6IwnUF4l5fI2BtdM+]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54c265cb-64c9-4a61-edc7-08d98ec93380
x-ms-traffictypediagnostic: PN2PR01MB5015:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6lYqJAbkjWEWb5iObvQxpxjA+qWJeWSBwyCfWrmgnef8TPOPzsxO8fLXmuvjPTdv7MSuWJSj4Rp73oh1+Cz6bk2BSsArIVZbjrgH2rb4L2gIOrQ6I1SteKlNqYS0OVCOLDPc8EV8SAvd+ALKec7c+aR9YeskkqF7ZSCOyjqrPO0RcEn+rameCPlnn/k7r/PrBSiAcFONZ2P4q/JFo9/+uPEQ2tddx57gtz1gPK2nKdI18vLvu3gF8GkQGBv5Vtpgpeq+uXh7Zvnc+qvfM4hDTQEpbimXzlJ4cHPK1hTMMxwRpu2QROv1jUkAGnzwnx3APOIKbLKlqwBJ0QePWpRcSWartT9tC7anrJQSofeD2D5JddBfnmfKgETQYd69WWWj3OiL3YCuRJ4Dqxta+1pe0vIe6n9Wgc4QMwS2Y4w6P7vMfUdEANrnEIo8534WzSLkUkllJb69kH6D+TLclSgdmnOM2uzImkkiqQ6aAR1uYa/QgtoxSmCtrv4zMs7en1zNZoVyi2I9z5ZD0jV1v1uwmOXKDxlTT5c0cCXn7zSn6Xk=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: y0rYcLF4QaBHwyReNFJkJJN4bkkSh9/hEjxT5NyUK++y7qaq96eVDZDzmhER+gNdQhi0ENOYCKLWDm33ow6DLcmxyzgJpROMM6b8BjarRmFeHzBhW3aCaQc1YpTQaBlqAc0nAt8aXZqQF9iwEP8u6g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <77A3FBF6A9E8D44EA4DC3239C53AE2D2@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c265cb-64c9-4a61-edc7-08d98ec93380
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 04:15:05.2487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB5015
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogT3JsYW5kbyBDaGFtYmVybGFpbiA8cmVkZWNvcmF0aW5nQHByb3Rvbm1haWwuY29tPg0K
U3ViamVjdDogW1BhdGNoXSBBZGRlZCA4MDg2OjM4YTggdG8gdGhlIGludGVsX2xwc3NfcGNpIGRy
aXZlci4gSXQgaXMgYW4gSW50ZWwgSWNlIExha2UNClBDSC1OIFVBUlQgY29udHJvbGVyIHByZXNl
bnQgb24gdGhlIE1hY0Jvb2tQcm8xNiwyLg0KDQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0K
U2lnbmVkLW9mZi1ieTogT3JsYW5kbyBDaGFtYmVybGFpbiA8cmVkZWNvcmF0aW5nQHByb3Rvbm1h
aWwuY29tPg0KU2lnbmVkLW9mZi1ieTogQWRpdHlhIEdhcmcgPGdhcmdhZGl0eWEwOEBsaXZlLmNv
bT4NClJldmlld2VkLWJ5OiBBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4
LmludGVsLmNvbT4NCi0tLQ0KdjMtPnY0OiByZXZpZXdlZC1ieSBsaW5lDQoNCmRyaXZlcnMvbWZk
L2ludGVsLWxwc3MtcGNpLmMNCnwgMiArKw0KMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KQ0KDQoNCmRpZmYNCi0tZ2l0IGEvZHJpdmVycy9tZmQvaW50ZWwtbHBzcy1wY2kuYyBiL2RyaXZl
cnMvbWZkL2ludGVsLWxwc3MtcGNpLmMNCmluZGV4IGM1NGQxOWZiMTg0Yy4uYTg3MmI0NDg1ZWFj
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZmQvaW50ZWwtbHBzcy1wY2kuYw0KKysrIGIvZHJpdmVy
cy9tZmQvaW50ZWwtbHBzcy1wY2kuYw0KDQpAQCAtMjUzLDYgKzI1Myw4IEBAIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgcGNpX2RldmljZV9pZCBpbnRlbF9scHNzX3BjaV9pZHNbXSA9IHsNCg0KCXsgUENJ
X1ZERVZJQ0UoSU5URUwsIDB4MzRlYSksIChrZXJuZWxfdWxvbmdfdCkmYnh0X2kyY19pbmZvIH0s
DQoJeyBQQ0lfVkRFVklDRShJTlRFTCwgMHgzNGViKSwgKGtlcm5lbF91bG9uZ190KSZieHRfaTJj
X2luZm8gfSwNCgl7IFBDSV9WREVWSUNFKElOVEVMLCAweDM0ZmIpLCAoa2VybmVsX3Vsb25nX3Qp
JnNwdF9pbmZvIH0sDQoNCisJLyogSUNMLU4gKi8NCisJeyBQQ0lfVkRFVklDRShJTlRFTCwgMHgz
OGE4KSwgKGtlcm5lbF91bG9uZ190KSZieHRfdWFydF9pbmZvIH0sDQoNCgkvKiBUR0wtSCAqLw0K
CXsgUENJX1ZERVZJQ0UoSU5URUwsIDB4NDNhNyksIChrZXJuZWxfdWxvbmdfdCkmYnh0X3VhcnRf
aW5mbyB9LA0KCXsgUENJX1ZERVZJQ0UoSU5URUwsIDB4NDNhOCksIChrZXJuZWxfdWxvbmdfdCkm
Ynh0X3VhcnRfaW5mbyB9LA0KLS0gDQoyLjMzLjANCg0KPiBPbiAxMi1PY3QtMjAyMSwgYXQgNToy
OCBQTSwgTGVlIEpvbmVzIDxsZWUuam9uZXNAbGluYXJvLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBU
dWUsIDA1IE9jdCAyMDIxLCBBZGl0eWEgR2FyZyB3cm90ZToNCj4gDQo+PiBBZGRlZCA4MDg2OjM4
YTggdG8gdGhlIGludGVsX2xwc3NfcGNpIGRyaXZlci4gSXQgaXMgYW4gSW50ZWwgSWNlIExha2UN
Cj4+IFBDSC1OIFVBUlQgY29udHJvbGVyIHByZXNlbnQgb24gdGhlIE1hY0Jvb2tQcm8xNiwyLg0K
Pj4gDQo+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPj4gU2lnbmVkLW9mZi1ieTogT3Js
YW5kbyBDaGFtYmVybGFpbiA8cmVkZWNvcmF0aW5nQHByb3Rvbm1haWwuY29tPg0KPiANCj4gV2hv
IGlzIHRoZSBhdXRob3Igb2YgdGhpcyBwYXRjaD8NCj4gDQo+IFdoeSBoYXNuJ3QgdGhlIHN1Ym1p
dHRlciBzaWduZWQgaXQgb2ZmPw0KPiANCj4+IFJldmlld2VkLWJ5OiBBbmR5IFNoZXZjaGVua28g
PGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbT4NCj4+IC0tLQ0KPj4gdjMtPnY0OiBy
ZXZpZXdlZC1ieSBsaW5lDQo+PiANCj4+IGRyaXZlcnMvbWZkL2ludGVsLWxwc3MtcGNpLmMNCj4+
IHwgMiArKw0KPj4gMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPj4gDQo+PiANCj4+
IGRpZmYNCj4gDQo+IFRoaXMgaXMgbm90IGEgZm9ybWF0IEkgcmVjb2duaXNlLg0KPiANCj4gRGlk
IHlvdSB1c2UgYGdpdCBzZW5kLWVtYWlsYCB0byBzdWJtaXQgdGhpcz8NCj4gDQo+PiAtLWdpdCBh
L2RyaXZlcnMvbWZkL2ludGVsLWxwc3MtcGNpLmMgYi9kcml2ZXJzL21mZC9pbnRlbC1scHNzLXBj
aS5jDQo+PiBpbmRleCBjNTRkMTlmYjE4NGMuLmE4NzJiNDQ4NWVhYyAxMDA2NDQNCj4+IC0tLSBh
L2RyaXZlcnMvbWZkL2ludGVsLWxwc3MtcGNpLmMNCj4+ICsrKyBiL2RyaXZlcnMvbWZkL2ludGVs
LWxwc3MtcGNpLmMNCj4+IA0KPj4gQEAgLTI1Myw2ICsyNTMsOCBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IHBjaV9kZXZpY2VfaWQgaW50ZWxfbHBzc19wY2lfaWRzW10gPSB7DQo+PiANCj4+IAl7IFBD
SV9WREVWSUNFKElOVEVMLCAweDM0ZWEpLCAoa2VybmVsX3Vsb25nX3QpJmJ4dF9pMmNfaW5mbyB9
LA0KPj4gCXsgUENJX1ZERVZJQ0UoSU5URUwsIDB4MzRlYiksIChrZXJuZWxfdWxvbmdfdCkmYnh0
X2kyY19pbmZvIH0sDQo+PiAJeyBQQ0lfVkRFVklDRShJTlRFTCwgMHgzNGZiKSwgKGtlcm5lbF91
bG9uZ190KSZzcHRfaW5mbyB9LA0KPj4gDQo+PiArCS8qIElDTC1OICovDQo+PiArCXsgUENJX1ZE
RVZJQ0UoSU5URUwsIDB4MzhhOCksIChrZXJuZWxfdWxvbmdfdCkmYnh0X3VhcnRfaW5mbyB9LA0K
Pj4gDQo+PiAJLyogVEdMLUggKi8NCj4+IAl7IFBDSV9WREVWSUNFKElOVEVMLCAweDQzYTcpLCAo
a2VybmVsX3Vsb25nX3QpJmJ4dF91YXJ0X2luZm8gfSwNCj4+IAl7IFBDSV9WREVWSUNFKElOVEVM
LCAweDQzYTgpLCAoa2VybmVsX3Vsb25nX3QpJmJ4dF91YXJ0X2luZm8gfSwNCj4gDQo+IC0tIA0K
PiBMZWUgSm9uZXMgW+adjueQvOaWr10NCj4gU2VuaW9yIFRlY2huaWNhbCBMZWFkIC0gRGV2ZWxv
cGVyIFNlcnZpY2VzDQo+IExpbmFyby5vcmcg4pSCIE9wZW4gc291cmNlIHNvZnR3YXJlIGZvciBB
cm0gU29Dcw0KPiBGb2xsb3cgTGluYXJvOiBGYWNlYm9vayB8IFR3aXR0ZXIgfCBCbG9nDQoNClNv
cnJ5IGZvciB0aGUgbGF0ZSByZXBseS4gQWN0dWFsbHkgbXkgZW1haWwgY2xpZW50IG1hcmtlZCB0
aGlzIGVtYWlsIGFzIHNwYW0gYW5kIHB1dCBpdCBpbiB0aGUganVuayBmb2xkZXIuDQoNCg==
