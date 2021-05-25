Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C64390122
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 14:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhEYMmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 08:42:52 -0400
Received: from mail-eopbgr30093.outbound.protection.outlook.com ([40.107.3.93]:8260
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232590AbhEYMmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 08:42:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4LmZ6+gr4/oa9r/FbjXGEXXOS6TtTiIf/wBEAlXzpl3DT4QMqp3CeNcN9PfNPccGPG/12EEAm3RHn89EFLc3ZC4cS80Ax5KzBkG6nd9Pf892JNkNOJICO49MjzciLpWFsp28vDqdrNIBDH61mhDSW1+f7R+2rqWqKExos/IVkDMlx1wDONwNtK4d2csifexb8e3w5MojhZOb3qIKzSiBbyLdK+e9TLShISi9EsaX76L/DzOqsckT9tw+BTYpIlRk4WSsSNz6GC7g20bxbYEKxnCoFTZOsPWchDBtLi60qBN/XmpmeYaF7/YGYSZkvm9uVzwGnYP7noT6MzcFJsffw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTFkxAi3auCaCKwP16bLkqs6vm7DH+2ztrmbU4GBjac=;
 b=O/6eU2dlkTzLY4odbrhFEsUNY4eplTUz2RBZXtm2sUmTUf3Miiq2eFx/qepfbUnFvFd5o7DcVL9x+LLNc38DOVTut8pNweR3ocu5/QM3QyYEUP7xXYuVHiBqc7Cm15HyGR2S22o9EGcUSnrl4YBdBH6icvHXdsADLZUwQcmY159jS6F2J9WJdR+wRVtenldFoWtowubrrdi0nPlQxf03VAg1X1NgSa3HANmztWRIAHRgIMdvF52Ems1hA5U24B8g9rdWKanErOy+0+6WN31vzCUp8o+TYheb/3S2zsqpcWS6+3sXGptZC6Cm2ScBz3hwnZKm0yTpBjg5/XkUcawN2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTFkxAi3auCaCKwP16bLkqs6vm7DH+2ztrmbU4GBjac=;
 b=hZtk6OtkYeI/Yo8JqaIqR0Yf2KRBU4atjObwI9w1rxhT+Zxi6/WX1WjKQp1HVivvVtqhX4Bc7i2ANUdPhE4LZ/FUEs8Xpam+t4Ml4pcbrX59/I9mVtH3vlT8c70EoCOXzL3qeW2sdKIZcFSO4eaNeEfsG8in8A1CdWQovfYxDV0=
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com (2603:10a6:7:2c::17) by
 HE1PR0701MB2460.eurprd07.prod.outlook.com (2603:10a6:3:70::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.12; Tue, 25 May 2021 12:41:15 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85ed:ce03:c8de:9abf]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85ed:ce03:c8de:9abf%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 12:41:15 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jan.kratochvil@redhat.com" <jan.kratochvil@redhat.com>
Subject: LTS perf unwind fix
Thread-Topic: LTS perf unwind fix
Thread-Index: AQHXUWNAMimraUixrEyqdytsWPBp1w==
Date:   Tue, 25 May 2021 12:41:15 +0000
Message-ID: <682895f7a145df0a20814001c508688113322854.camel@nokia.com>
Accept-Language: en-US, en-150, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.1 (3.40.1-1.fc34) 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nokia.com;
x-originating-ip: [131.228.2.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e119111-75bc-4d38-9059-08d91f7a6319
x-ms-traffictypediagnostic: HE1PR0701MB2460:
x-microsoft-antispam-prvs: <HE1PR0701MB24607E9A86FD10710ACE3A0EB4259@HE1PR0701MB2460.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0aR526Tew5KdA+FJ/y1aJgA1in64VIR3oWJDvfOkvFu2bCGSeNGWC//lyiSb5KTlSXp6whpQkJ5wrUAviHYYB5gA+J0IVsXFMifAIh5NG/mMkFsYF63ELVQ2c4xQp38WUmgyTPTD96m8OOSKqRArQEAtzi6tC8GLPTORb85acOtqZOU5NNTlPpFZO7Kve+Je1hxgMEz2ULgEZSGyrJwRWEIJWEs9fkfvXVdbAhvZSHJ1qwL14CsEx8Pi1oTN5HOqMCoSwg4nloqHdVhBmeUw23mYjYikpNX70tmWdFWNC47xinvTbBIb0gDJWuqs8ceRaO9zKFFVt6QOHXQkAtHBXvMhf+Gl0rm1F3ov4HYhH0gFMCDRpo07RFzOWXGf600NNFkP5tVxciet4tvMXy0NsEnphjYfPh8dJGwfKVNh+li7P8FeKQGaKvZUotLmyXvi1WYTf95ut1B0vg3qOc7k1KYcYrGXK7NWUrWrQrtUYuMN2aMEsrAybThtMpJtSg0kfdchmFqfFVhGOjIKD0FZfyb2/hMe3sbzEGJBo5bODgaMO5EG77VIB5O6Wl3VBojYLhitn97hzPI4VP4QPfBYTXrjhek6Rih3L1qPUSNVLJI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(478600001)(76116006)(2616005)(2906002)(36756003)(6512007)(66946007)(5660300002)(122000001)(38100700002)(186003)(6506007)(3480700007)(6916009)(86362001)(66556008)(6486002)(64756008)(71200400001)(8936002)(54906003)(66446008)(66476007)(26005)(316002)(4326008)(8676002)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TTd3OVQxd0hiMEZNVVlFYTh2TE9EMGhWdFNVMFF1eHNnaTdlaXZQM21Vc0Nm?=
 =?utf-8?B?dGpRZ3djYWg5TWZ0dEpQd2xrMHJadVIwSnZid3RITmwwR2licjROS2xMRmFj?=
 =?utf-8?B?cWVKY1pDaG1zS0MvYWlLTWl5ZVZNdEJwOStmaEZIMjNCMXhhMGFuZGpxVDdL?=
 =?utf-8?B?SUp3dG1EL0UwUWFzQmx3K1N6RElPOTdxc2MzTzhUajFzRjZPVWZENDE5TWdn?=
 =?utf-8?B?bzZxY1R5RzhuK29JYW9OcHBmV1VON3BleExuL21JNzFhcWRTTExqYWRDdCtk?=
 =?utf-8?B?Znc5cmdKSndETnNnemFnMnNXbU1nY2tlVHRVSTZyVlF1WE5UZzlFdWUxKy9Q?=
 =?utf-8?B?WGt5N0hXQ2tNYTJ0aEVxVWdDM3RQeUN5d0RzSDl3YXg1SGVwaUI3dEh5MnlF?=
 =?utf-8?B?SVloTXdGVWFINzVZQ0lteVErUGJPYzl1TTgrdm9NUS93Z2pxZXZiSng0YkJ2?=
 =?utf-8?B?bEhuZ1RVem1tbzcrTldHSzI2cWFZWFdqMFV5b1QyODUyWklZWFVrZkRiMDVH?=
 =?utf-8?B?UlhCOHhYV3FWTEp2N1hqY0oxNVJQZjRrWXlXZXhLQ2hvclRmRzgvN3VYaVE4?=
 =?utf-8?B?ckI1Z2Z1WEtGek9HdUsxTGw1dnEvNGp2RFh2MTBPNjJ4MkpEWENIaUMyYXAx?=
 =?utf-8?B?SjZqS1BRQ0JUY29FZFI0K0crQnltdUhuajQ5WDRmL2x3SGh2M2YyVDN2NVhX?=
 =?utf-8?B?SkE0V01sZG5hUnJyZlRMK0dUdmFuM3MzUGNoZUgxY05ZYklIWDQ0VDVYd0Zj?=
 =?utf-8?B?bjBBek5sWUplUWlWM0Z4cE1LNnhTb2hlenZ2RXFRSDU2NVpBUVU1ejhZRDl6?=
 =?utf-8?B?RGVJTEQvRWRLYmJpdGxrZnlQdU4xbm4vN0hHbEJ1WmI1WWxUdklyU2Qyc3Yv?=
 =?utf-8?B?ZVVNRmV3NHI1MTV5ZjhkRjdBT0paNWFnc2NyaDBnUm5sMm90ZGJMUGxuMlVV?=
 =?utf-8?B?M2JLdVJBdkd6U0N2VlB1Z1NGbnlZOFpScG90Q1Zqd2UzY1o2WC8wbFNhMTYx?=
 =?utf-8?B?eTBrajZuam5LYkZLbytDdFhERDRWU1hKMDZ1MmQ4TjUrZ2lUQzJzVUNibUxv?=
 =?utf-8?B?WGVLM3BKeHh1amxWckpkVkdjOFdST0NsMkxMa1ZIR2pITi9aZVBSTm5Pd0hR?=
 =?utf-8?B?Z3kxS3hJOGFETXZjdVJCWWFINkZXZlNzeXVpSkM2elhjbnhYaGgrYkw5S3FI?=
 =?utf-8?B?U0UvMXhRUkFwM2ZrdGV6RjUwTk9JWktjOEtleVFQRGR5R2RJb29FY3kxUGRQ?=
 =?utf-8?B?aGVjM1VkY01DSnJFc3E3a0t0TnlFMzNRc3pVbVhKenZxUWVjZStQb1lxMTRu?=
 =?utf-8?B?cHpFL1FkdVc1VVdvQWhCNmxUQlV2ZDZ3Z1M2YjRwSm1IUUwvVVFDTFgvU0JS?=
 =?utf-8?B?aElhYndUd0xTQ3B0NnBOZFFmZi9tOTlTWFB4QS8zTVo2RFRPcHd3NXEyOUFF?=
 =?utf-8?B?VEEwdnVvTGYvUklsbitmdmVwUTQyKytuRGRnU0NvQW41OGFacE9BM0NkVkNh?=
 =?utf-8?B?c05ZbG1HYXNXTGk4OW5LOENtN1grT1BxdnNaWlBQTlU1bThYck1GNVZkVk82?=
 =?utf-8?B?S2pnaEtuOWNVY0RtM1czM1EvYjBjb3hnejBRMldsbmdOV2V5MTBPN1VqdGdX?=
 =?utf-8?B?Y29CSHl1bTJuQlBEVloxYUg4Z0QweWd1eCsyLzZmWFJ1NzZjNUZwTU9TZWpU?=
 =?utf-8?B?MDRMSG14OEJuVGRLaktwZHVaU1ZXdzJNRzhwcDdBN0p4K2RDVTJlSGJwZEh3?=
 =?utf-8?Q?Mly8ZHWzaDAlccqZ6nkgLu8rqYwod5gdTAGHF1V?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <32B06FE1E6FE654C85EC09EAB42B361E@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e119111-75bc-4d38-9059-08d91f7a6319
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 12:41:15.7297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fNpCd3FgUVJ7yvWTCPOU7a5929MJlGZqLS6V5X/tMQnfBI9QqH7mq8hubjRPBWaTvdAjok9/rTpFSBM0rrA5DwQsTY4IJuVHQepiTxKBnt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0701MB2460
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KQ2FuIHlvdSBwbGVhc2UgY2hlcnJ5LXBpY2sgdGhpcyB0byBMVFM6DQoNCmNv
bW1pdCBiZjUzZmM2YjVmNDE1Y2RkYzcxMTgwOTFjYjhmZDZhMjExYjIzMjBkDQpBdXRob3I6IEph
biBLcmF0b2NodmlsIDxqYW4ua3JhdG9jaHZpbEByZWRoYXQuY29tPg0KRGF0ZTogICBGcmkgRGVj
IDQgMDk6MTc6MDIgMjAyMCAtMDMwMA0KDQogICAgcGVyZiB1bndpbmQ6IEZpeCBzZXBhcmF0ZSBk
ZWJ1ZyBpbmZvIGZpbGVzIHdoZW4gdXNpbmcgZWxmdXRpbHMnIGxpYmR3J3MgdW53aW5kZXINCg0K
DQotVG9tbWkNCg0K
