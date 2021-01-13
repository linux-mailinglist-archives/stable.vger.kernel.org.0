Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8875B2F4137
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 02:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbhAMBaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 20:30:15 -0500
Received: from alln-iport-4.cisco.com ([173.37.142.91]:49603 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbhAMBaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 20:30:14 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2021 20:30:13 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2588; q=dns/txt; s=iport;
  t=1610501413; x=1611711013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aimeo6PVXtiM8tRuzuyuH7j8Y4w092MfhS+jdCvtC6Y=;
  b=l7kji6ANOy02qGp8I+AbFowTXeOd1otwIjRJMJPrAjG4k0TF9tkcjU2Y
   UfNQG+1xbpBLnHt5lMXjBpf39tBlMS8TG2wq41+PcvOh3DKv7vyKZJ0v9
   OfvgK/5C1YSG1UupR6Lzxr7Ildyr+PPC6KAv7Xh6kI70G6fvGztSGzAyV
   8=;
X-IPAS-Result: =?us-ascii?q?A0AHAAC3SP5fkIENJK1iGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQIE8BAEBAQELAYFSUX1bLy6EP4NIA412A5kSgS4UgREDVAsBA?=
 =?us-ascii?q?QENAQElCAIEAQGESgIXgVoCJTUIDgIDAQEBAwIDAQEBAQUBAQECAQYEFAEBA?=
 =?us-ascii?q?QEBAYY4DIVzAQEBBCMEDQwBATcBCwQCAQgRBAEBAwImAgICMBQBCAgCBAENB?=
 =?us-ascii?q?QiDHgGCVQMuAQ6kKAKKJXZ/M4MEAQEGgTMBg3IYghADBoEOKgGCdIN+hj4mG?=
 =?us-ascii?q?4IAgVSCVj6BBAGDBAESASMVgwE0giyCQgd3BwwsUEd6HpJwP6UhCoJ3iSuSV?=
 =?us-ascii?q?qJgLZNlixaWKgIEAgQFAg4BAQaBWAI0aXBwFYMkEz0XAg2OIRqDV4UUhUR0A?=
 =?us-ascii?q?jUCBgoBAQMJfIxfAQE?=
IronPort-PHdr: =?us-ascii?q?9a23=3A0kgmyR9BD0tRuv9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+7ZxKN4fRrkU/HWpjd5/tYiu3Q9af6Vj9I7ZWAtSUEd5pBH1?=
 =?us-ascii?q?8AhN4NlgMtSMiCFQXgLfHsYiB7eaYKVFJs83yhd0QAHsH4ag7Wo3uv/TAVBx?=
 =?us-ascii?q?PzPBZ0IeKzHZTd3Iy70umo8MjVZANFzDO2fbJ1KkCwqgPc06tegYZrJqsrjB?=
 =?us-ascii?q?XTpX4dcOVNzmQuLlWWzBs=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.79,343,1602547200"; 
   d="scan'208";a="627269917"
Received: from alln-core-9.cisco.com ([173.36.13.129])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 13 Jan 2021 01:20:22 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by alln-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id 10D1KMXf023475
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 13 Jan 2021 01:20:22 GMT
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jan
 2021 19:20:05 -0600
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by xhs-rcd-003.cisco.com
 (173.37.227.248) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jan
 2021 19:20:05 -0600
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-001.cisco.com (64.101.210.228) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 12 Jan 2021 20:20:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/ZGKQbOT5MZ5UIXgLu4vVnRiccu4dulaaxkiqBVQmSRmebNoe9Rv0gJG81eoMRoJFgPT4S65WWdXgg1UpZz3B7OyDa38rOF7IYjIdbyEk5fWl2QH6nI01XL8P4YRh+WY4xwRmZ96bqcgbfLckD2h85dn6chAAIW4kQKcf8780LcR/AS2qHs9nFbYJ+tFf0nyJjk7cVtotYgZ8umjmjajDnCIt9xwa9ZOhMXvzNtnc6yfjL/q4sxzMBuQZtgXvquOfSN82zsNM++1CIfChnqYegWnM6o1d4ysuP4uiUGOpoDSrNhY1bvS7ob69IjSMeGXu8PXCcGsBgol8u+3ljW5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aimeo6PVXtiM8tRuzuyuH7j8Y4w092MfhS+jdCvtC6Y=;
 b=Vkwp8IrpzuPEbJ6sRerK3BRMfmW/vcfn5BQiL/frEIG6DI2Rv81dIstW4F5+hfJ5pQRAa98XEMy3Qjw092DaVqHSdFzUj+2BXNhjNRrpbXTJxtqqx83fv8Rg+rdmkF1hJmUqQa0GuKV/QkE6pl5p4K5y2AXau71QLHCdzd1R+A/v4KlnIzIuW9+nOJa6H5+uD2IfIL+S/M2yWzDbp8R1EuRoHhkdovRz4BffvB9iqpULFyZI757wDCHMrsL0biMF3Biz7Wp8V1tuxXnJ0ruktl4vgWa5kULtnG+Gx/tXjGmSqlXPAsE8mDt7LZb0nhbAXj8DEcJZifaGqtOAHUgdsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aimeo6PVXtiM8tRuzuyuH7j8Y4w092MfhS+jdCvtC6Y=;
 b=VhPZr3TGvcglakIIxepyLEJK2Bj/bAO99W/SUYMGi+Qe677+qR5pD2ownsjuc2WGjjkuDp+fPXa7zBfXZT6NQUbRMffvljITNdA+JlKVxEEBYggTDacilNZX5nibmZGZfZzddSYIdi4rZYdJiABZ9n4PIAsVIgV03U0Hd4cJr7E=
Received: from BY5PR11MB3863.namprd11.prod.outlook.com (2603:10b6:a03:18a::28)
 by BY5PR11MB4165.namprd11.prod.outlook.com (2603:10b6:a03:18c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 01:20:04 +0000
Received: from BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::54bd:ca95:6853:1e82]) by BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::54bd:ca95:6853:1e82%5]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 01:20:04 +0000
From:   "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 4.14 147/242] scsi: fnic: Fix error return code in
 fnic_probe()
Thread-Topic: [PATCH 4.14 147/242] scsi: fnic: Fix error return code in
 fnic_probe()
Thread-Index: AQHW3RtcJquzumBbTEywsU6DTIdlPaok2iQQ
Date:   Wed, 13 Jan 2021 01:20:04 +0000
Message-ID: <BY5PR11MB38639C2650BE0C2D97196862C3A90@BY5PR11MB3863.namprd11.prod.outlook.com>
References: <20201228124904.654293249@linuxfoundation.org>
 <20201228124911.941490459@linuxfoundation.org>
In-Reply-To: <20201228124911.941490459@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=cisco.com;
x-originating-ip: [2600:1700:ce00:1710:8134:b3ad:f9c7:9112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b227f9d6-1ba0-4c92-1f3d-08d8b7615b36
x-ms-traffictypediagnostic: BY5PR11MB4165:
x-microsoft-antispam-prvs: <BY5PR11MB4165F7002AF0B517242A0794C3A90@BY5PR11MB4165.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:183;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rgOtuYCvwgWcVhoPr8w0iy1WXVd7nigzT/cvjqozQ2PhDO+wbf6oYGleVkWO+sZs4gVGMst/3RpI0T3+Bw7z8vIirdCscHMgkY1nvAgl+vJf2rvj2RriOsP/3aJ7G8wl+4p2vAZcFP3tItpKwPJipRRrqmR/T/1kViHjfa7jNxtn1DETST+70nJda5uFllor4vxId8Gw2/8ru0ldcNjr5QuXzlSwlFnVDH0lbEBLJW94HmVgywJX3aQSKEiEFwJk/tYJeHrjt2KpX9dH5HHrdUorGRsw5FbtAsT4MV8EepJi9hRKPW/RuX6kD/KdiB4gGxhX6iOk9V7mF0xA4+vl+PXWvmHIk1Jni1vzsgiJbq7eOkfIMevj2xFMrpfpB032IfawSDaHxMj1w+wtHAqFQ814247HmTIGdromRfWmuVxBkTtWQwLgwBhaFxgFtnqAWShjZBs8+I9if+5zkMqqGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3863.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(346002)(39860400002)(64756008)(66476007)(66556008)(53546011)(52536014)(8936002)(86362001)(9686003)(5660300002)(66946007)(33656002)(6506007)(316002)(66446008)(110136005)(186003)(8676002)(71200400001)(55016002)(76116006)(83380400001)(966005)(2906002)(4326008)(478600001)(7696005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aW1GcUlBWEdGNmhiSHE3WnFyazhyd2xaU2ZLR3pWalRnMVd4K2JOdWUva29h?=
 =?utf-8?B?eHJCMWlsMWpWaERGYUwzSjVuakFKaThpYUw1OWRKeU1NY01vRGtUUjFJNWJU?=
 =?utf-8?B?dnZIcjB1MmN6MzlkRTNsVFV4Rkh2NDNMR1lHTUhTY1lZQ2JGQ05nai9pMkhx?=
 =?utf-8?B?QWhuNWxzQ2NYQlMybzcwd1FrTFA4UDhlVmRCN3g5QnhiL2l1MmltNUdnT2Ft?=
 =?utf-8?B?NndmT0FsaitiSk14UXBjR2lBRDFnRktCKzhhNzJYR1h6SEMyQ1MwWjBsdWEz?=
 =?utf-8?B?aExKd3Fpakc1QlAvd0pzbnFGZUZRSmpLOFNNN1dSektHa1JaRlR1YmtLN0ZT?=
 =?utf-8?B?OGdMaXNTZTNjMDhTV2ZBNmtDbmpyOW1jWjk4bXBxK1VkKzdxYlJRdXpXYUVP?=
 =?utf-8?B?RERYcWhlTnNBZm01Q29pTENjbjBHQkkzb2dZekJ3SFNNTXR3VFZsL0doTFBl?=
 =?utf-8?B?bGV6RjAydkRBOGZNQWdtNzd1ZURubklJaHlYdFZiV2RRZ3lUT2FTMlNCU0pC?=
 =?utf-8?B?Q2ViQmVkM1VJc2J0SGxLd1E4QWlnZVYxOGl3OEdoaEF3UVBxS1h1RGJ5YXJv?=
 =?utf-8?B?b3NOYWxOMFBLUVVRckJGcFNhMkx5L2pkWEZGRExlM1U3RnVuVi9IM2xCUjBu?=
 =?utf-8?B?L080aUQzZXZ4cEZ2ZHJKVlRDdGZNeklUUjl2cTlraVNQSHExWHNLYWpWSXBu?=
 =?utf-8?B?MWZORWhjNTBPQW1iNVp2L2xrc3F3QU9XS0wrTS94aDcrd0pHNld4SmFLQzlT?=
 =?utf-8?B?L2lVaHZxOFBKZEFxUU9wTWZQeXR4OVlQSU84VjdmaFVScWlYQzFGRjQxZmlO?=
 =?utf-8?B?S2YyNlc4bVFXVEVzRERSZEEyRUQ4TFYxNFEyOEVsSzUwUFpVK2kwQlp5d2lO?=
 =?utf-8?B?UUV6MWhmSzVVSW8xS2RoM2tnQzFkVk1ZeE9zcFJSZlRBSWJhVTNxNlJBTEF5?=
 =?utf-8?B?dWd2M1FEZmx4ZGFrRENyWnpub0xqWnJpcDJMQVgzOWdoZkt4aGd6QjJ6c2d0?=
 =?utf-8?B?eDNQQjZOZ2xzZU1RY0phV1FBYVZyNnhQZDNxaHZPOHp4Z3dJZzBwcTR5V2xC?=
 =?utf-8?B?a1B3Q1RpeExkZ2x2TGNveUsrbG8wMm1uajZ4OEZ1ODdUbVFOS01LVW9helhL?=
 =?utf-8?B?SVdkYXh0bmF5elNEenkydjI5ZnI3YVJJamN2M1FqSGpMS2FXTzZtN05yN2cv?=
 =?utf-8?B?VTlLN1Bvd042dXVyRTFUdmRPWWQrcGFZbGRMTVdkZ1BWSWxHbzNmNE40ZnRK?=
 =?utf-8?B?L1ZkVEhaODQ0ZzJyZFh6VTB1L3ZwbXNEUjNpUG4vdzVyMUduMnE1am5YZENK?=
 =?utf-8?B?STFJQWp3MDZ0TUZzT1l2Wk5nWUhpMzNYYU5Odlhjd1V3UldMMjhBQitvN0lU?=
 =?utf-8?Q?aF9ucfs6ZeM1XwojKW3gLc+50w0tOVfk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3863.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b227f9d6-1ba0-4c92-1f3d-08d8b7615b36
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 01:20:04.2189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aZ3e/8JaqX12XFNu25ow/qZ9klDmBpt6lP6dIgS6p4L6VWY08pOPQF8u9rWn0lAx81kHLAW1VA1JqqXx8PcXHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4165
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: alln-core-9.cisco.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QWNrZWQtYnk6IEthcmFuIFRpbGFrIEt1bWFyIDxrYXJ0aWxha0BjaXNjby5jb20+DQoNClJlZ2Fy
ZHMsDQpLYXJhbg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogR3JlZyBLcm9h
aC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gDQpTZW50OiBNb25kYXksIERl
Y2VtYmVyIDI4LCAyMDIwIDQ6NDkgQU0NClRvOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQpDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IEh1bGsgUm9ib3QgPGh1bGtjaUBodWF3ZWkuY29tPjsgS2Fy
YW4gVGlsYWsgS3VtYXIgKGthcnRpbGFrKSA8a2FydGlsYWtAY2lzY28uY29tPjsgWmhhbmcgQ2hh
bmd6aG9uZyA8emhhbmdjaGFuZ3pob25nQGh1YXdlaS5jb20+OyBNYXJ0aW4gSy4gUGV0ZXJzZW4g
PG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPjsgU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwu
b3JnPg0KU3ViamVjdDogW1BBVENIIDQuMTQgMTQ3LzI0Ml0gc2NzaTogZm5pYzogRml4IGVycm9y
IHJldHVybiBjb2RlIGluIGZuaWNfcHJvYmUoKQ0KDQpGcm9tOiBaaGFuZyBDaGFuZ3pob25nIDx6
aGFuZ2NoYW5nemhvbmdAaHVhd2VpLmNvbT4NCg0KWyBVcHN0cmVhbSBjb21taXQgZDRmYzk0ZmU2
NTU3ODczOGRlZDEzOGU5ZmNlMDQzZGI2YmZjMzI0MSBdDQoNClJldHVybiBhIG5lZ2F0aXZlIGVy
cm9yIGNvZGUgZnJvbSB0aGUgZXJyb3IgaGFuZGxpbmcgY2FzZSBpbnN0ZWFkIG9mIDAgYXMgZG9u
ZSBlbHNld2hlcmUgaW4gdGhpcyBmdW5jdGlvbi4NCg0KTGluazogaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvci8xNjA3MDY4MDYwLTMxMjAzLTEtZ2l0LXNlbmQtZW1haWwtemhhbmdjaGFuZ3pob25n
QGh1YXdlaS5jb20NCkZpeGVzOiA1ZGY2ZDczN2RkNGIgKCJbU0NTSV0gZm5pYzogQWRkIG5ldyBD
aXNjbyBQQ0ktRXhwcmVzcyBGQ29FIEhCQSIpDQpSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8aHVs
a2NpQGh1YXdlaS5jb20+DQpSZXZpZXdlZC1ieTogS2FyYW4gVGlsYWsgS3VtYXIgPGthcnRpbGFr
QGNpc2NvLmNvbT4NClNpZ25lZC1vZmYtYnk6IFpoYW5nIENoYW5nemhvbmcgPHpoYW5nY2hhbmd6
aG9uZ0BodWF3ZWkuY29tPg0KU2lnbmVkLW9mZi1ieTogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0
aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhc2hhIExldmluIDxzYXNo
YWxAa2VybmVsLm9yZz4NCi0tLQ0KIGRyaXZlcnMvc2NzaS9mbmljL2ZuaWNfbWFpbi5jIHwgMSAr
DQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvZm5pYy9mbmljX21haW4uYyBiL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfbWFpbi5jIGlu
ZGV4IGFhY2FkYmYyMGI2OTUuLjg3OGU0ODY3NjI3MjkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvZm5pYy9mbmljX21haW4uYw0KKysrIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19tYWluLmMN
CkBAIC03NDYsNiArNzQ2LDcgQEAgc3RhdGljIGludCBmbmljX3Byb2JlKHN0cnVjdCBwY2lfZGV2
ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqZW50KQ0KIAlmb3IgKGkgPSAwOyBp
IDwgRk5JQ19JT19MT0NLUzsgaSsrKQ0KIAkJc3Bpbl9sb2NrX2luaXQoJmZuaWMtPmlvX3JlcV9s
b2NrW2ldKTsNCiANCisJZXJyID0gLUVOT01FTTsNCiAJZm5pYy0+aW9fcmVxX3Bvb2wgPSBtZW1w
b29sX2NyZWF0ZV9zbGFiX3Bvb2woMiwgZm5pY19pb19yZXFfY2FjaGUpOw0KIAlpZiAoIWZuaWMt
PmlvX3JlcV9wb29sKQ0KIAkJZ290byBlcnJfb3V0X2ZyZWVfcmVzb3VyY2VzOw0KLS0NCjIuMjcu
MA0KDQoNCg0K
