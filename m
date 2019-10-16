Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2A2D98E5
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 20:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbfJPSKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 14:10:37 -0400
Received: from mail-eopbgr10074.outbound.protection.outlook.com ([40.107.1.74]:27438
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbfJPSKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 14:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJp46p0f5fJQPqXbt6g6dsfoqdzyfoq/X6SEsIkmATA=;
 b=iqhwmsAEn6BjhbFn0Bhtv5t/Hia/U9CUp/2xjIWB9pitfTOr7OQitNMu88nGrioLwPLoReO3ujbW72R8Pdi5IC1aJBT7AwfkzJxv9QKY899kTOUI8eUOlH4oTgZLmsBQtzDhn1J4H421dM4kpurMkaZHTi+lTff2QiMgMvjLYHo=
Received: from VI1PR08CA0209.eurprd08.prod.outlook.com (2603:10a6:802:15::18)
 by DB6PR0802MB2583.eurprd08.prod.outlook.com (2603:10a6:4:99::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.16; Wed, 16 Oct
 2019 18:10:26 +0000
Received: from VE1EUR03FT036.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::201) by VI1PR08CA0209.outlook.office365.com
 (2603:10a6:802:15::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.21 via Frontend
 Transport; Wed, 16 Oct 2019 18:10:26 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT036.mail.protection.outlook.com (10.152.19.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 18:10:24 +0000
Received: ("Tessian outbound 3fba803f6da3:v33"); Wed, 16 Oct 2019 18:10:24 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8535bf5ecf38a98f
X-CR-MTA-TID: 64aa7808
Received: from 2d84bdfe6c83.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.5.56])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 74817124-14AA-49D4-98AC-7AC886397444.1;
        Wed, 16 Oct 2019 18:10:19 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-he1eur02lp2056.outbound.protection.outlook.com [104.47.5.56])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 2d84bdfe6c83.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 16 Oct 2019 18:10:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX/vAb86QcFctRwA333L1GA+ixvwuKIjWwShgK+fL9d5dsU/3kjE58GMI5f2FRAeeBEJFXHvSK+/5ix9ueCvoPH2LR683XA1911W7uRYaID3RzrtGfn/G2tOmEWMqJYgoMsPsj8kv9KRplIDQ1nwTPevYNhRDZcdBFi87nlggp7RD1FIoHjnsKZWWQJltbOkWgDHQSYhcUQ9hpMPDHDY/0YTzCN55z++SyV1bu1iTzFK10yJJUQwxvKAQo1mODPOt/JOHjnFOradyKeMAIzsPCwu/dnOkCV3p/uZQkeFR0/dIE9ZllGSLNjNN3KaZjHpHp4BqdRrPP7s6DyzQoE56A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJp46p0f5fJQPqXbt6g6dsfoqdzyfoq/X6SEsIkmATA=;
 b=DsyXQXONp7EN52Q58+kIurTEh/NnXIqsIwuNXGBWjPjP8nBeemhMaomZ26pa/wJDXrOfH3Fv9CAcNQIXTtfAn91fV8xJQ3Ms3kmb9pvVp3k0hwqTrFuAPqFmsVDokyBkOYaxOI1P/VXp2405m+WmQDEC6W2lju2PAsH0AvXWYw0t5pTuidHQHwfdU/KvN9Z/JVHvHdCs+wxw6dBEC1VT9geY0WygkWNHcdNaPqgQe0dFwfo3T762KIEKnEipxTFwqI/NUZE/LH2iNtPyMO7UIVF7xdpulhHxm+Lcndz44syPEP9rpUzdy9/sUj8YKWXsrLb/wwiNY0y+Oho/0E4SJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJp46p0f5fJQPqXbt6g6dsfoqdzyfoq/X6SEsIkmATA=;
 b=iqhwmsAEn6BjhbFn0Bhtv5t/Hia/U9CUp/2xjIWB9pitfTOr7OQitNMu88nGrioLwPLoReO3ujbW72R8Pdi5IC1aJBT7AwfkzJxv9QKY899kTOUI8eUOlH4oTgZLmsBQtzDhn1J4H421dM4kpurMkaZHTi+lTff2QiMgMvjLYHo=
Received: from DB7PR08MB3292.eurprd08.prod.outlook.com (52.134.111.30) by
 DB7PR08MB3098.eurprd08.prod.outlook.com (52.134.110.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Wed, 16 Oct 2019 18:10:16 +0000
Received: from DB7PR08MB3292.eurprd08.prod.outlook.com
 ([fe80::bc69:7a3a:d0f6:b45d]) by DB7PR08MB3292.eurprd08.prod.outlook.com
 ([fe80::bc69:7a3a:d0f6:b45d%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 18:10:16 +0000
From:   Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To:     Dave P Martin <Dave.Martin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
CC:     nd <nd@arm.com>, Will Deacon <will@kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Jan Stancek <jstancek@redhat.com>,
        Vincenzo Frascino <Vincenzo.Frascino@arm.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Subject: Re: ? FAIL: Test report for kernel 5.4.0-rc2-d6c2c23.cki
 (stable-next)
Thread-Topic: ? FAIL: Test report for kernel 5.4.0-rc2-d6c2c23.cki
 (stable-next)
Thread-Index: AQHVhDBBmd5Q9VIuyUmhlKanBAeRAaddWlQAgAAcvICAABp4gA==
Date:   Wed, 16 Oct 2019 18:10:16 +0000
Message-ID: <ecf22341-bad2-e20b-f12c-cc80ebafda2a@arm.com>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
 <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
 <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
 <20191014162651.GF19200@arrakis.emea.arm.com>
 <20191014213332.mmq7narumxtkqumt@willie-the-truck>
 <20191015152651.GG13874@arrakis.emea.arm.com>
 <20191015161453.lllrp2gfwa5evd46@willie-the-truck>
 <20191016042933.bemrrurjbghuiw73@willie-the-truck>
 <20191016144422.GZ27757@arm.com>
 <20191016145238.GL49619@arrakis.emea.arm.com>
 <20191016163528.GA27757@arm.com>
In-Reply-To: <20191016163528.GA27757@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [217.140.106.54]
x-clientproxiedby: AM0PR05CA0052.eurprd05.prod.outlook.com
 (2603:10a6:208:be::29) To DB7PR08MB3292.eurprd08.prod.outlook.com
 (2603:10a6:5:1f::30)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Szabolcs.Nagy@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: e6150b7d-2dd6-4781-5b36-08d752641dc8
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: DB7PR08MB3098:|DB7PR08MB3098:|DB6PR0802MB2583:
X-MS-Exchange-PUrlCount: 2
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB25837AC733990DAD5A28F004ED920@DB6PR0802MB2583.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:5797;OLM:5797;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(54906003)(486006)(2616005)(58126008)(478600001)(6512007)(6486002)(65956001)(110136005)(64756008)(66446008)(66556008)(66946007)(66476007)(66066001)(86362001)(6436002)(65806001)(229853002)(44832011)(36756003)(6306002)(31696002)(446003)(7736002)(476003)(305945005)(11346002)(26005)(256004)(14444005)(81166006)(14454004)(6246003)(386003)(102836004)(186003)(316002)(99286004)(6636002)(81156014)(6506007)(31686004)(25786009)(6116002)(71200400001)(71190400001)(3846002)(8676002)(4326008)(966005)(76176011)(8936002)(52116002)(5660300002)(53546011)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR08MB3098;H:DB7PR08MB3292.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: w1PCdmiy6MbfIy2LnjW+ZvOyxbNZevzen2ZtH2PzpAkirm3PjREr8mPtL8lh37iP96Mnng9nKmasgthwCeULZg3wKt/Ts4h7pYZrnTaRU61eb692zUfVoIK7srYjK2j+n6pgnwbohJNsp3JDbmJFcb9q9XF06kFrWJLkxLJZTVftifwo/3Hk9fR+7n3BrHHKaQEGi3PTyDXWtsrpNiS2WEV+D0ge9sEMPZLbZBZ2K5+6BX084Yg+sk/8HIQ+uRsZGLAkB/mogfOthpynWjuFnag1gyHOA3AoGSKSBb7uJjXmXYFOUpkRshlHoSR0gu5RXgvtfm9BCNJNw3dkBvJs+wE+sYw3WeHMig04OYUQ6pR+lIOPzyIu+N7HhfVhGHiOYmQE7h67oy1jMGqO2kSOCrhvK7Xwk15DUnZ9iuDuZTzQr98itCWTZqIz3P/hXAiUcBJA8dTf4kUfI+6/ruj5FA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B836C5DA58C494A8B551AAC4B997B2B@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3098
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Szabolcs.Nagy@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT036.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(189003)(199004)(50466002)(31696002)(4326008)(966005)(31686004)(26005)(5660300002)(70586007)(102836004)(23676004)(36756003)(26826003)(478600001)(86362001)(76130400001)(25786009)(22756006)(2486003)(14454004)(8676002)(6306002)(6246003)(436003)(107886003)(66066001)(336012)(110136005)(305945005)(6116002)(36906005)(63350400001)(65956001)(7736002)(11346002)(126002)(47776003)(476003)(486006)(229853002)(99286004)(2616005)(6512007)(54906003)(2906002)(65806001)(316002)(446003)(14444005)(356004)(386003)(6506007)(53546011)(76176011)(8936002)(186003)(3846002)(58126008)(70206006)(81156014)(6636002)(81166006)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0802MB2583;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: e9f0aa8e-3cde-472c-4891-08d7526418bd
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXiHCSxg04EaylcJjFuvsv2cKaV6WKQtD4wDs4awWe8W/FF6bHgBaOgQ5QszOrCQlqj6iirzp/i0sJ2SfdzG2VgcOiS5O/RfSAQDOWeMbOxd9nb3SmDlRy3fRz4sPAKlE2+lsi4xkdr/izMZMY4N7uIwfpWNpPNJ+bW/ziwG/0nMsEAGoHnObnk/WVdC0mPbv20xDBvfs4Q3uxitQrvuiFc+6TnuZ1lka9C9DQj2Uq1JOfPvnwmjoyFI5Cc/8yIpD1pRBY2x6iAAPFY+yJdq9xPuEPO+BQPT6WBZ3WJwRfYA0FEiuCCvSItH9Df1RSehTV5vsa9ILB5Ijwq7z08uNRWBUB8TkP+rmZWZasMRf62+xRmwYzHzorHfSqmYQX4P4dsG9N5U2pzJOTM+8xWzNt6Odas+ZIJzKIbZLu6TVl4NRgsAR+r9DcdgpnPFEJKW0LJlZNmeZA4uRj0GBtjC9w==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 18:10:24.5040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6150b7d-2dd6-4781-5b36-08d752641dc8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2583
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTYvMTAvMjAxOSAxNzozNSwgRGF2ZSBNYXJ0aW4gd3JvdGU6DQo+IE9uIFdlZCwgT2N0IDE2
LCAyMDE5IGF0IDAzOjUyOjM4UE0gKzAxMDAsIENhdGFsaW4gTWFyaW5hcyB3cm90ZToNCj4+IE9u
IFdlZCwgT2N0IDE2LCAyMDE5IGF0IDAzOjQ0OjI1UE0gKzAxMDAsIERhdmUgUCBNYXJ0aW4gd3Jv
dGU6DQo+Pj4gT24gV2VkLCBPY3QgMTYsIDIwMTkgYXQgMDU6Mjk6MzNBTSArMDEwMCwgV2lsbCBE
ZWFjb24gd3JvdGU6DQo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL21l
bW9yeS5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9tZW1vcnkuaA0KPj4+PiBpbmRleCBiNjFi
NTBiZjY4YjEuLmMyM2M0NzM2MDY2NCAxMDA2NDQNCj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9tZW1vcnkuaA0KPj4+PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL21lbW9y
eS5oDQo+Pj4+IEBAIC0yMTUsMTIgKzIxNSwxOCBAQCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxv
bmcga2FzbHJfb2Zmc2V0KHZvaWQpDQo+Pj4+ICAgKiB1cCB3aXRoIGEgdGFnZ2VkIHVzZXJsYW5k
IHBvaW50ZXIuIENsZWFyIHRoZSB0YWcgdG8gZ2V0IGEgc2FuZSBwb2ludGVyIHRvDQo+Pj4+ICAg
KiBwYXNzIG9uIHRvIGFjY2Vzc19vaygpLCBmb3IgaW5zdGFuY2UuDQo+Pj4+ICAgKi8NCj4+Pj4g
LSNkZWZpbmUgdW50YWdnZWRfYWRkcihhZGRyKQlcDQo+Pj4+ICsjZGVmaW5lIF9fdW50YWdnZWRf
YWRkcihhZGRyKQlcDQo+Pj4+ICAJKChfX2ZvcmNlIF9fdHlwZW9mX18oYWRkcikpc2lnbl9leHRl
bmQ2NCgoX19mb3JjZSB1NjQpKGFkZHIpLCA1NSkpDQo+Pj4+ICANCj4+Pj4gKyNkZWZpbmUgdW50
YWdnZWRfYWRkcihhZGRyKQkoewkJCQkJXA0KPj4+DQo+Pj4gSGF2aW5nIHRoZSBzYW1lIGluZm9y
bWFsIG5hbWUgKCJ1bnRhZ2dlZCIpIGZvciB0d28gZGlmZmVyZW50IGFkZHJlc3MNCj4+PiByZXBy
ZXNlbnRhdGlvbnMgc2VlbXMgbGlrZSBhIHJlY2lwZSBmb3IgY29uZnVzaW9uLiAgQ2FuIHdlIHJl
bmFtZSBvbmUgb2YNCj4+PiB0aGVtPyAgKFNheSwgdW50YWdnZWRfYWRkcmVzc19pZl91c2VyKCk/
KQ0KPj4NCj4+IEkgYWdyZWUgaXQncyBjb25mdXNpbmcuIFdlIGNhbiByZW5hbWUgdGhlIF9fKiBv
bmUgYnV0IHRoZSBvdGhlciBpcw0KPj4gc3ByZWFkIGFyb3VuZCB0aGUga2VybmVsIChpdCBjYW4g
YmUgZG9uZSwgdGhvdWdoIGFzIGEgc3Vic2VxdWVudA0KPj4gZXhlcmNpc2U7IHVudGFnZ2VkX3Vh
ZGRyPykuDQo+Pg0KPj4+PiArCV9fYWRkciAmPSBfX3VudGFnZ2VkX2FkZHIoX19hZGRyKTsJCQkJ
XA0KPj4+PiArCShfX2ZvcmNlIF9fdHlwZW9mX18oYWRkcikpX19hZGRyOwkJCQlcDQo+Pj4+ICt9
KQ0KPj4+DQo+Pj4gSXMgdGhlcmUgYW55IHJlYXNvbiB3aHkgd2UgY2FuJ3QganVzdCBoYXZlDQo+
Pj4NCj4+PiAjZGVmaW5lIHVudGFnZ2VkX2FkZHIgKChfX2ZvcmNlIF9fdHlwZW9mX18oYWRkcikp
KAlcDQo+Pj4gCShfX2ZvcmNlIHU2NCkoYWRkcikgJiBHRU5NQVNLX1VMTCg2MywgNTYpKSkNCj4+
DQo+PiBJIGd1ZXNzIHlvdSBtZWFudCB+R0VOTUFTS19VTEwoNjMsNTYpIG9yIEdFTk1BU0tfVUxM
KDU1LDApLg0KPj4NCj4+IFRoaXMgY2hhbmdlcyB0aGUgb3ZlcmZsb3cgY2FzZSBmb3IgbWxvY2so
KSB3aGljaCB3b3VsZCByZXR1cm4gLUVOT01FTQ0KPj4gaW5zdGVhZCBvZiAtRUlOVkFMIChub3Qg
c3VyZSB3ZSBoYXZlIGEgdGVzdCBmb3IgaXQgdGhvdWdoKS4gRG9lcyBpdA0KPj4gbWF0dGVyPw0K
PiANCj4gSXQgbG9va3MgbGlrZSBTVVN2NyBoYXMgbXssdW59bG9jYWwoKSBhbmQgbXByb3RlY3Qo
KSBhbGlnbmVkIHdpdGggb25lDQo+IGFub3RoZXIgcmVnYXJkaW5nIEVOT01FTSB2ZXJzdXMgRUlO
VkFMOg0KPiANCj4gaHR0cHM6Ly9wdWJzLm9wZW5ncm91cC5vcmcvb25saW5lcHVicy85Njk5OTE5
Nzk5L2Z1bmN0aW9ucy9tcHJvdGVjdC5odG1sDQo+IGh0dHBzOi8vcHVicy5vcGVuZ3JvdXAub3Jn
L29ubGluZXB1YnMvOTY5OTkxOTc5OS9mdW5jdGlvbnMvbWxvY2suaHRtbA0KPiANCj4gU28gd2hh
dGV2ZXIgd2UgZG8sIGl0IHNob3VsZCBwcm9iYWJseSBoYXZlIHRoZSBzYW1lIGVmZmVjdCBvbiBi
b3RoDQo+IGNhbGxzLg0KPiANCj4gDQo+IFRoZXJlJ3MgYW5vdGhlciB3cmlua2xlIHRoYXQgb2Nj
dXJycyB0byBtZSB0aG91Z2guICBSb3VuZGluZyAia2VybmVsIg0KPiBhZGRyZXNzZXMgdXAgY2Fu
IHNwdXJpb3VzbHkgY2hhbmdlIEVOT01FTSB0byBFSU5WQUwgLS0gYnV0IHRoZSBmaXggZm9yDQo+
IHVzZXJzcGFjZSBhZGRyZXNzZXMgKGkuZS4sIHJvdW5kaW5nIGRvd24pIGNhbiBsaWtld2lzZSBz
cHVyaW91c2x5IGNoYW5nZQ0KPiBFSU5WQUwgdG8gRU5PTUVNLg0KDQp3ZWxsIHRoaXMgd2FzIHRo
ZSBwb2ludCBvZiB0aGUgYml0IDU1IGNoZWNrLCB0byBhdm9pZCBib3RoLg0KKHdpdGggdGhlIGFz
c3VtcHRpb24gdGhhdCBnZXR0aW5nIEVJTlZBTCBpcyBub3QgaW1wb3J0YW50IGlmDQpvdmVyZmxv
dyBoYXBwZW5zIHdpdGggbGVuID4gMl41NSBhbmQgMCBiaXQgNTUpDQoNCmFzIGZhciBhcyBpIGNh
biB0ZWxsIHRoZSBFSU5WQUwgZm9yIG92ZXJmbG93IGlzIGxpbnV4IHNwZWNpZmljLg0KDQppIHRo
aW5rIHJldHVybmluZyBFTk9NRU0gZm9yIGludmFsaWQgYWRkcixsZW4gcGFpcnMgc2hvdWxkIGJl
DQpmaW5lLCBpLmUuIHplcm8gZXh0ZW5zaW9uIGlzIG9rLg0KDQppIHRoaW5rIHRoaXMgaXMgY29u
c2lzdGVudCB3aXRoIHBvc2l4IHJlcXVpcmVtZW50cywgYW5kIGFyZ3VhYmx5DQpldmVuIHdpdGgg
Y3VycmVudCBsaW51eCBtYW51YWwgd2hpY2ggZG9jdW1lbnRzIEVJTlZBTCBmb3Igb3ZlcmZsb3cN
CmluIG1sb2NrLCBidXQgYWxzbyBFTk9NRU0gZm9yIHVubWFwcGVkIHBhZ2VzIGluIHRoZSByYW5n
ZSwgc28gYm90aA0KZXJyb3JzIGFyZSBvayBvbiBvdmVyZmxvdy4NCg0Kc28gdGhlIGJpdCA1NSBj
aGVjayBvbmx5IG1hdHRlcnMgaWYgc29tZXRoaW5nIHNvbWV3aGVyZSByZWxpZXMNCm9uIHRoZSBl
cnJvciBjb2RlIGluIGEgc2lnbmlmaWNhbnQgd2F5IHdoZW4gY2FsbGluZyBzeXNjYWxscyB3aXRo
DQpub25zZW5zaWNhbCBhcmd1bWVudHMuDQoNCj4gPiBNYXliZSB0aGlzIGlzIE9LIC0tIHRoZSBT
VVN2NyB3b3JkaW5nIGRvZXNuJ3Qgc2VlbSB0byBjYWxsIG91dCBhZGRyZXNzDQo+IHdyYXBhcm91
bmQgYXMgYSBzcGVjaWFsIGNhc2UsIGFuZCB0aGVyZWZvcmUgc3VwcG9zZWRseSBkb2Vzbid0IHJl
cXVpcmUNCj4gRUlOVkFMIHRvIGJlIHJldHVybmVkIGZvciBpdC4NCj4gDQo+IFRoZSBhc3ltbWV0
cnkgaXMgY29uY2VybmluZyB0aG91Z2gsIGFuZCBhIGJpdCB1Z2x5Lg0KPiANCj4gQ2hlZXJzDQo+
IC0tLURhdmUNCj4gDQoNCg==
