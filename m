Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F383D3EFE0D
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbhHRHol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:44:41 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:6753
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239061AbhHRHoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 03:44:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Meela6MclhmhKU7fAqgHrIJbIVyNoky25Yd0j+DeAkuACKllDPv95R7kOTHddm0Vtz+E45pmbU1RuI0HJl76UDVxPistXoLog60bXXri9zIrfq2WLrYObKnnMhpl2h2Vx5LuFg+IXTm/A1KyADUKKAyCD2gLgFAA51xfzVzN1JkePoKtuFgxjHJWaOW7LS3AagwwH2V+qMpwSRWIUgx/7euvS543Z+FuSECs5ZbRa7xe+rsBrpXfxTNQVRQUEo3Uv1zQMbEYRtyyjaV1yP4efw/rzD4dMf8l802lpMlBCHGSUCqWAQG+c7OXWeFXg1T7LSoAqE+zqag/+1qtJqOgpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CPWJyAoUZL22u+WifiGzTVr2NCrbxjjFGw0jfYjRHc=;
 b=PQEw33gVlsoHSGcGm6ZESVQWGnEQhbR5pI9p5b4qzeY1T0p7ho6J4GHfGwXJOaFNrJ1CQjAxcNHoVyn1e0fsYse42Y24R2SjUytNFYd7EKaA2K7+x4/vLH1YiRdHGx+oTN+feeBYRTsuwyDaLH3OwgsBwlsYLvHKisFkXwcMPlyysH3KgMNebdFG6gbww4rEc7TZEwpkfr9OhfxICxr7NdXmy8EulWMu/7ol02JDB2ejzGoQYyXsKzy8oTQWhdgNBBIYCTsfLAX0hjh4fs+LlLswHIrwSQghq5LZxghss9o2ypewaMZx0ALy+spWS2O+rkhOwey6EDlnFz0HIAGdqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CPWJyAoUZL22u+WifiGzTVr2NCrbxjjFGw0jfYjRHc=;
 b=pPFEoUHlWYf1Fpu9AR5CEiflHtV2oJg9cjNZ4bvrJP8tMhJk3DFJDHIuSvQG+ONp/XlWTgDGvBU/vbxpjjkdf6CSDhoPNE2ja7V//7vFNub/RcAKCtFt/SEUM9f19A2sc6qc87dy/teWl/8/tZWcUK/MhVPSy2XnRBY+kE1gH99cMvRbHtVSym7ylQYkjtxWsAUOn7aL6TAECjXx0PvcKq3ocDy54GYdrmibf3SqaRI937LCYfBaJGtD+MeGOvoiytLa+BV1Xk2f1nshFZFvK8AuRs5xAggde4tspwuIXNLpcKtQ0EgJcDAcefdTboOE7IBi/EfffZChC1HvZHBnkg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3093.namprd12.prod.outlook.com (2603:10b6:a03:dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Wed, 18 Aug
 2021 07:44:03 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74%5]) with mapi id 15.20.4436.019; Wed, 18 Aug 2021
 07:44:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "pavel@denx.de" <pavel@denx.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Moshe Shemesh <moshe@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>
Subject: Re: [PATCH 5.10 49/96] net/mlx5: Fix return value from tracer
 initialization
Thread-Topic: [PATCH 5.10 49/96] net/mlx5: Fix return value from tracer
 initialization
Thread-Index: AQHXkp+q/2tC88OAHEa65ZCE60uocqt3+82AgADokwA=
Date:   Wed, 18 Aug 2021 07:44:03 +0000
Message-ID: <ddb6cd7b4e7a7b1d0fb46809702f0d7a2fc9c419.camel@nvidia.com>
References: <20210816125434.948010115@linuxfoundation.org>
         <20210816125436.588162993@linuxfoundation.org> <20210817175137.GA30136@amd>
In-Reply-To: <20210817175137.GA30136@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3 (3.40.3-1.fc34) 
authentication-results: denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2336a01f-4f61-4adb-5f7a-08d9621bf32c
x-ms-traffictypediagnostic: BYAPR12MB3093:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3093B8360A521359D60AA2B5B3FF9@BYAPR12MB3093.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G+Fzcp6VzneQWLH2RYMRYaLGSeF3nM3PcH1ENhgjEj8j6zZfBdwZgPk2t+cBGgd7/+gmFnT+ma4JAfCx/1BKUyTSDh8Z4X0No/JObpqUXy97mTy5XWvtfrkP81QtUyJItd9VCsQUCkqzomuGuK2qHgPkykinGt8Go4OukB72oVlfiOnzAo4RFYwdGjYFdJ/sa+RH3zDQoRMPSlevBHF/I2/ycyKXlp4SYJaMQ3dGUhTePwpyZFYz8eE2wzeMor7dmM17pYCqBzG1OmZmUBnpTpJn4i4q53R6R8JkDQi36B9O8I0fsjTyGd+PFh4xrfgiiSbJColQ8Go+D1XBGT0LTqpY5zHi2UxHLcxU20QPPqr26OS7pC1xVWOpNlQ3A/Ptf9kmBF3vqXbvp3bbbC8bkk7XlGqkLtyes8pOreclxvNPllXhSiEsH6b6A2w3JF+2RJZK38ufmvhrkt0iG/BsVv0Vf3w34yVu7KiaupnLdtnEZEFlkrgKH+/Ym0Lh/g3+Z+gFs7pgG18ZLpE+2ZwBDuCKN6RxRHbvktUkLZlAnyHLaiHlK/zQOv4Inj+yPpjQj43gsGeh4xAcitPxnizS0+yNoU3qz3Zl1D0l0eSM7nFhgQOCHAngYhfOzpcG/QdmpDXkVBhsZ2eAhX+X2WwSws68rb9ec4vvGgqlTD4CpRJ9aH6WHgwuOngHK88a0bPVxXy50abkgdRvs1D+/JKCLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(110136005)(66946007)(6512007)(6486002)(83380400001)(5660300002)(66476007)(316002)(66446008)(64756008)(66556008)(478600001)(71200400001)(54906003)(38100700002)(122000001)(36756003)(4326008)(8936002)(76116006)(2616005)(86362001)(186003)(26005)(8676002)(6506007)(107886003)(2906002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3ZqMnBTbXB5VFQwcVBROTNhZWcwbmJzdkVMNDNyb2ZLWjZNS1ROUlMwSjZ3?=
 =?utf-8?B?UlZ5Um5ySHNpY1NyNjVXNGlwdnBPQ0NpVGVORmpLOGxXR2w1QlU4cjlraXJy?=
 =?utf-8?B?dzFMVnh5WUxqeGRBcXRjS0VzVTdOT2xxMEc5ZmFlRFhoWHRwKzloaEZ3L3dk?=
 =?utf-8?B?S245cHgvTU01ZzVzdGFYK2QyMkl4eGF3cXBDRHR3ZmNEWCt5bk5JZGs0Qk1M?=
 =?utf-8?B?cFFJckEwaGdScFJib2pUS2VkTUdJSWt4bjRmWXFHeGgyQ0ZYK2ZTT2pBazNC?=
 =?utf-8?B?WVZFTXZFSzhZNnErOVdxWVhIZEV3WkdpL2V0YXhZdDlKc0tNRU9KU2ppT0l4?=
 =?utf-8?B?dXFFeS9XS3czdFZSNVQwQjZnRVNBdTV2SXIyNjBJMU5hZUpPakVLN0tmQW9t?=
 =?utf-8?B?cWNZdkZaOVNSOXIydHlhMHludEh3bDJ2dmNacTZKVlErVEJvbzJYQ2dhQ3Rx?=
 =?utf-8?B?ZTVMUEdzL3JpZnBZbjZLZ2ljSnBRQXR1TVNLQld6ZEx2anNGNSs1NXg4Q0d1?=
 =?utf-8?B?bHJQTTlkWE1QbWwxbzNhcEtYSGZHbTVhUkZDRnZRWkpES1drYjNPK0R3YTZN?=
 =?utf-8?B?akNtVWxuZ3NuMUpjOFh5Wm9YK3E2YWFMMU4rZEVRMUp5QWVyajVDTjVMeUFD?=
 =?utf-8?B?bkQzR3JldC85OVdHcytVdFNSSzZhOFFueHFyaFMvd1ppZDI3aVJqYXdGSTNj?=
 =?utf-8?B?RHZOMks3MmZXSWY0RmNucnNBRGM0MkVzQStZL2JHZWp6aExwUEVhTk9mSlpB?=
 =?utf-8?B?cWlpZTdNMVFNeFA0dk5Eakg1SGlsWTJ2TkpZcVYxYmQ2N3J3eE00amZqV0dn?=
 =?utf-8?B?Q3RMKzlBYmd0SGx0UG1xMzFMZHg3R0ZZYjhqazRiWlFuR0tIWndCM1JWOHEw?=
 =?utf-8?B?TEUxSmJ5dnc3K1o1L2lTNitJd1V5OFJzaXZKQm4wRVdqWW9vVERIL2hDN003?=
 =?utf-8?B?TEZIQkZkdUJFb3dYNkRsaWJDclZJWGpaMlluSWRQaGNhYVpKcHR5L3VNRUl6?=
 =?utf-8?B?M2Z0Z0gwN3pTWFgyMkl6RE9WYU4vZU1GUFBGWkt1bXl2RG83dENWL2Z5V2pZ?=
 =?utf-8?B?Wk5sK3RmY0k4YXI1NG5BOS9tUExqdHZ0MGJySjZmMU1vd21jeVR0Q1d1QlFj?=
 =?utf-8?B?Z1RtNEpKYVRBRWtJcE5Ec3JrMlJ4bHhUM1hzNEkyQjJ4Q1VNanlaUzlwMWE2?=
 =?utf-8?B?dlFHMnVyNjc5MkFTNkNRc1Q4WiszZGh1SGhRSHJIRlZVZ1F0YWVKeGptMXly?=
 =?utf-8?B?L2VNQlNMcWhrcW1qVzhKQlJReHF1di9ta2VzQU9TNW81ZVFDRzI2OHBHWmJD?=
 =?utf-8?B?a0gwV3UzTGdEOGQxTHplZFJ3RkhQYTR1Q0MvQ0FXOHoyVDN0K3l2RGw5L2ho?=
 =?utf-8?B?TDRkRVM2VEJCNnBDMlF4ZThtWnI4Wmt1WEJLK3h6Z3B6VERZSHdVT2pmYXQ0?=
 =?utf-8?B?Qzc2QXBFbW9jY05IcUZuTDFxeFQ5MEg1Q1EyK1ptb1k2WE5lckFxK0xSZmQ3?=
 =?utf-8?B?REJkMm83R1NIVkJPRVRkWDdhRVh3UCtMSjE0dEROSzMxQW5sR0FIUStOVjBw?=
 =?utf-8?B?ZnNOQTMxekhRMEhqOTVTb1JzWE1UNy9JMXJibWQ2KzMra0J1ZGkrQi9HS0RX?=
 =?utf-8?B?dXJGblcvK2RiVjg3RFJVSlpucHZCaEtrMFZxd3NBbndCSWMxWElIK3JSMjgx?=
 =?utf-8?B?RHpRMVF6alNpazlsdGZRejZZQTA3dTltN0RGMkRjM3JqZDVuMFErL0VFWkJ3?=
 =?utf-8?B?QnI2UWhyamRaTkhSZ0wrd2sxOUJ1SUJ3T1JpYTBqcWJYSStnMEliM0hHV3g2?=
 =?utf-8?B?Y2h3QU1YR0NqZzRhb04xUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF0F01B51CD01D4FB3368D90A41EB1E2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2336a01f-4f61-4adb-5f7a-08d9621bf32c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 07:44:03.1443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QEM2vLZm1E+wSbglVEyuCs+bwZAFZsdXhFHA3YVqZKLuq5jFxNiUiVs+PSr8ac2M1K46/rPT43/BiYvpziqauw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3093
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIxLTA4LTE3IGF0IDE5OjUxICswMjAwLCBQYXZlbCBNYWNoZWsgd3JvdGU6DQo+
IEhpIQ0KPiANCj4gPiBbIFVwc3RyZWFtIGNvbW1pdCBiZDM3YzI4ODhjY2FhNWNlYjk4OTU3MThm
NjkwOWIyNDdjYzM3MmUwIF0NCj4gPiANCj4gPiBDaGVjayByZXR1cm4gdmFsdWUgb2YgbWx4NV9m
d190cmFjZXJfc3RhcnQoKSwgc2V0IGVycm9yIHBhdGggYW5kDQo+ID4gZml4DQo+ID4gcmV0dXJu
IHZhbHVlIG9mIG1seDVfZndfdHJhY2VyX2luaXQoKSBhY2NvcmRpbmdseS4NCj4gDQo+IFRoaXMg
aXMgYWN0dWFsbHkgdHdvIGZpeGVzIGluIG9uZTogVGhlcmUncyBjYW5jZWxfd29ya19zeW5jKCkg
YWRkZWQNCj4gdG8NCg0KWWVzLCB0aGUgcmVhc29uaW5nIHdhcyB0aGF0IHRoZSBwYXRjaCBpcyBm
aXhpbmcgdGhlIHdob2xlIGVycm9yIHBhdGggb2YNCnRoZSBmdW5jdGlvbiBpbiBvbmUtc2hvdCBz
aW5jZSB3ZSBjYW4gYmxhbWUgaXQgb24gYSBzaW5nbGUgY29tbWl0Lg0KDQo+IHRoZSBlcnJvciBw
YXRoLCBidXQgdGhlcmUncyBhZGRpdGlvbmFsIGVycm9yIHRoYXQgbmVlZHMgZml4aW5nLg0KDQpZ
ZXMuDQoNCj4gDQo+IENvdWxkIHNvbWVvbmUgZmFtaWxpYXIgd2l0aCB0aGUgY29kZSB2ZXJpZnkg
aXQgYWZ0ZXIgbWU/DQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgUGF2ZWwN
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBhdmVsIE1hY2hlayAoQ0lQKSA8cGF2ZWxAZGVueC5kZT4N
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZGlhZy9md190cmFjZXIuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9kaWFnL2Z3X3RyYWNlci5jDQo+IGluZGV4IDNkZmNiMjBlOTdjNi4uODU3YmU4NmI0
YTExIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZGlhZy9md190cmFjZXIuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZGlhZy9md190cmFjZXIuYw0KPiBAQCAtMTAwNyw3ICsxMDA3LDcgQEAgaW50
IG1seDVfZndfdHJhY2VyX2luaXQoc3RydWN0IG1seDVfZndfdHJhY2VyDQo+ICp0cmFjZXIpDQo+
IMKgwqDCoMKgwqDCoMKgwqBlcnIgPSBtbHg1X2NvcmVfYWxsb2NfcGQoZGV2LCAmdHJhY2VyLT5i
dWZmLnBkbik7DQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyKSB7DQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgbWx4NV9jb3JlX3dhcm4oZGV2LCAiRldUcmFjZXI6IEZhaWxlZCB0
byBhbGxvY2F0ZSBQRA0KPiAlZFxuIiwgZXJyKTsNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJldHVybiBlcnI7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3Rv
IGVycl9jYW5jZWxfd29yazsNCj4gwqDCoMKgwqDCoMKgwqDCoH0NCj4gwqANCj4gwqDCoMKgwqDC
oMKgwqDCoGVyciA9IG1seDVfZndfdHJhY2VyX2NyZWF0ZV9ta2V5KHRyYWNlcik7DQo+IEBAIC0x
MDMxLDYgKzEwMzEsNyBAQCBpbnQgbWx4NV9md190cmFjZXJfaW5pdChzdHJ1Y3QgbWx4NV9md190
cmFjZXINCj4gKnRyYWNlcikNCj4gwqDCoMKgwqDCoMKgwqDCoG1seDVfY29yZV9kZXN0cm95X21r
ZXkoZGV2LCAmdHJhY2VyLT5idWZmLm1rZXkpOw0KPiDCoGVycl9kZWFsbG9jX3BkOg0KPiDCoMKg
wqDCoMKgwqDCoMKgbWx4NV9jb3JlX2RlYWxsb2NfcGQoZGV2LCB0cmFjZXItPmJ1ZmYucGRuKTsN
Cj4gK2Vycl9jYW5jZWxfd29yazoNCj4gwqDCoMKgwqDCoMKgwqDCoGNhbmNlbF93b3JrX3N5bmMo
JnRyYWNlci0+cmVhZF9md19zdHJpbmdzX3dvcmspOw0KPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJu
IGVycjsNCg0KdGhpcyBpcyBjb3JyZWN0LCBkbyB5b3Ugd2FudCB0byBzdWJtaXQgdGhpcyBwYXRj
aCBvciBkbyB5b3Ugd2FudCB1cyB0bw0KaGFuZGxlID8NCm1heWJlIGl0IGlzIGJldHRlciBpZiB3
ZSBkZWxheWVkIHF1ZXVlX3dvcmsoKSB0byBhZnRlciBhbGwgdGhlIGZyYWdpbGUNCmNvZGUgYmVo
aW5kIGl0LCB0byByZWR1Y2UgdGhlIGVycm9yIHBhdGggaGFuZGxpbmcgLi4gDQoNCnRoYW5rcyBm
b3IgcG9pbnRpbmcgdGhpcyBvdXQuDQoNCg==
