Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EAE2CD973
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 15:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgLCOlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 09:41:16 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:15300 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbgLCOlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 09:41:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607006475; x=1638542475;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kYxU7BAfZs7UA2fkX6FDjffk0Io3lI33/oE2Tl0d92o=;
  b=VefcuvSViG1drLs1zIMv1rzD7yyMLqQUzYfp8/b/A/lSKIRwDjFQqGv8
   iC0h6berqizcoaF/taKS8JBgT1Gz/WqYzz0BYiFS6BDWs/isldXhUejZH
   42iOKOVTnxHRGjPl2qsZxmlUvT0hIsq4h/5CkOGcSujyk0eQB7ufTAEAJ
   V2ZIOjP9v/dQzYQcAYj3dZwBFY7BBlwBIZQ9+XrFWUyhsHQavg33k9XtY
   k8xGB2OH8Bo9R/vdg0vqI2rlo6Og2x39oIX94agBx3O1sAvquouHTD6Gv
   oUbcX3tnrRkgTJtzFGgv6+T4mChdWD21LKN3vImqmd6C+DjPHkbVldDZD
   A==;
IronPort-SDR: H0ffqA39Vs03j4uw6DP+rG9PxtXuyGmBDs0oK8EMDklly4GaMp9rS5f9fP3mTaJZk3n6Uk11fO
 1va38V5eup4SofQ3ps8OKa1C1lUI7AEw564rUtIKnIw9XJO9rdpoYeozSCItB59kqZfZs5kGlP
 Kj0aE0JjpOt5cO2+DgfKYz1PPfd8mOquMImemT2q0NbQiFgCsN+7q7qWTY4rBDMeIBzrmBmRIt
 vw06RfJO8j40tERiReh5fOQe/7GlYCZhoLzGRGpmIlLRcRpjbLRB1k44n2vxJQVEsG+7yGowwB
 9So=
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="100747789"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2020 07:40:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 07:40:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 3 Dec 2020 07:40:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAPIvb3gbrSHdUy+tEFttZGXIgYIcTZpTXubva7bwsJfInCKWQpMvXAQyrJrV8gXGKZ1je/F3R0x7FXqwlbpl+Wx1c4gK2uAOoz5xLN9W9OyWIzA62EYE7Kvu7B6UHF2VbWdoDmLjtzwXWRWP3VPddrPC8ie4Nr5Pz4akrBgTcLgxI2uM1QWG9nI9TkmGmZAFMquu8lGCyNBWeaF9qXnaLakWdV0WGwouW161ed73KREWq2x20LPks/Io2i9mTc0UbrZwLMPV7LbH1+k/DoIzlC7jOzVFyaNGo1M99EP+Oc3AXUtCftxhN5nzxFabrRn5N1jLcuTZgtITpLwilDfJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYxU7BAfZs7UA2fkX6FDjffk0Io3lI33/oE2Tl0d92o=;
 b=i5VeU8LjijoOs2NBZKBmF1lhJZRqVwRw83HTUIFcXtiVAL4wrsm6GYQk5pRuCZHXoYrZ6Q5h53fTqIepzFI5kW0lVS5WitbZ3rPv4uzOFbC1C1ipy2yhQorku9r++ihZeyGnblwfCZca0P7J5Vutv54SqsLciGGtEcsnIrpZfNL2Wzk5hCll2WeVYJPkwvGRe53CTghMmxZ53Wnu4hAE4EkfF8t1SpKzTWyKzzWjr5bD5RDKBnK/+QYKDECFxCnpOf9bgiLhmH1n5cjhHCu4FBV+mVDb0tyOr96f8PdJvOFcc8Wb/cCRCwBTslqrlf+rCdk6LQ9Fo8OcQDJTCHLuNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYxU7BAfZs7UA2fkX6FDjffk0Io3lI33/oE2Tl0d92o=;
 b=GEZ0nT2vRB7G2HwBSoxOTlpd6BzEULdVV9FTK9JdXj3RQ+cuWVw+mB8B61fs0OeX+mL0xwXrFnoS6I9ynS9HIGV8RaE2KryU1oiZE9ZHezefEUP59mCMqVscGFLGhzORauUEBV4pVmcGyrDyTNXnXTjfxvy88ya5RNLprYMQoEM=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SA0PR11MB4687.namprd11.prod.outlook.com (2603:10b6:806:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Thu, 3 Dec
 2020 14:40:07 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::6903:3212:cc9e:761]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::6903:3212:cc9e:761%7]) with mapi id 15.20.3632.020; Thu, 3 Dec 2020
 14:40:07 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <michael@walle.cc>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <boris.brezillon@collabora.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the
 SST25VF064C
Thread-Topic: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the
 SST25VF064C
Thread-Index: AQHWyYIxbYejLXpUREmrcdCKcR8FGQ==
Date:   Thu, 3 Dec 2020 14:40:07 +0000
Message-ID: <fe37e295-9d74-160c-9b16-bbd5dcd5a638@microchip.com>
References: <20201202230040.14009-1-michael@walle.cc>
 <20201202230040.14009-2-michael@walle.cc>
In-Reply-To: <20201202230040.14009-2-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [79.115.63.95]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1002a76-7ca8-4b37-fd50-08d897995460
x-ms-traffictypediagnostic: SA0PR11MB4687:
x-microsoft-antispam-prvs: <SA0PR11MB46879D7BC4CAA7BEF2F39271F0F20@SA0PR11MB4687.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VCVhpUkQ5uhJmnCt+2wTZlQklDtaySsxYueXXh/WVzymZ8vAZ4XHitjfwL0Jjdmy1uIgLzkOVYJuTuRoA3VZ6cZUWTjut9+WyKJuM8kNYGP8K7104AahR1Kw6d0hQCSzOokM0l3ZHCrP0s1gRXiQEwMKGUfBEjMT76t6tBGcnESIA32dpz07n39WV7jdazW+rqqV0t2fbx00zd/IybsjQgQxa4jg64hjsYBHvxIvg4T3H6zO7rEIBhWgQMT4LJwCdp4kL4TZi1Bq+QEtHIJCBqxAdkg0vM9k7FICaIHRwzns/oRIpwKDBxmg5taVI4gUFlaV9UkQiuuM5WWHTKwS7GMS09fwUx6LUCS+y9i712Om4jvNe7mx9hqBFfGZNKeTJgOScZ9CFvG4Rr9fXCbzzpiUlltSsaMiPa0JIxC8GeU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(6486002)(36756003)(54906003)(86362001)(71200400001)(64756008)(8676002)(66946007)(316002)(66476007)(2906002)(4326008)(31696002)(110136005)(76116006)(66446008)(66556008)(2616005)(8936002)(31686004)(186003)(6512007)(26005)(4744005)(83380400001)(53546011)(5660300002)(6506007)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WVliN0NhQTE0UFR4Z05RM2wvUG84eFBjakg1RldMNnZ2U0d5dk1tVUtGV051?=
 =?utf-8?B?WnhyemIrbnlHbGNsblU3RDA2K0llQUJ4VStzdGw0K29xZldFR25WSHVOQmgr?=
 =?utf-8?B?eXpubHYvNHhHeHZDYWJGNVlFcDJMTjZnaWZUcFRmcUp2Qi9Ibyt4U0hIQ2ZH?=
 =?utf-8?B?aCtOa2FsdVpQOUU4d2lEZ2FJUFZrZ3hMSmJJRDJTRDNyMXYzaFBib2hXNTg4?=
 =?utf-8?B?bEV0aThwcEpnNjMvZU1ObU9OMmhGbkVZQ1l4NGxWTDJBNU5Pa3VBSGlkYk1v?=
 =?utf-8?B?UXA2SzZheDMrcThkVm93WGdqcDZweGliSHpqUUxHbTViOXdnbDEyVEhlMFB2?=
 =?utf-8?B?YkhEd2JMR01XRnNGaUpIVGZEWTNzZlo5R25JMFZvOVkzM09WSGdsN0w5VjNB?=
 =?utf-8?B?SUFpd3d1Rk1UM3QxWEE2OVFGM2ZoU1Z4czliekU4Z016Y3FUVjdiV1FUaFRY?=
 =?utf-8?B?dnVuVnlwQnpnS1NKbmowcWVIb3lFd2JFcXhEOEttVHF3UTVLMWJaa0NzNC9j?=
 =?utf-8?B?bnE1UFB0VVp1RVNra3R1TkVXenZaQUUxZGZSWmt3U0gzaGpEYjB4ZWZrWENP?=
 =?utf-8?B?alFLQlcwcmJjTEJqb25HMEI2dmJHa2FTdXl1dk5FWnRuVHNaa3BnMVhPMENz?=
 =?utf-8?B?UEI3SzAvOUlYNnpmcCtJYTBhUTFoTS84ZjUxN3U1WXRuTGVnclNrSExrQVV1?=
 =?utf-8?B?S1o0bHlvMmx2U2thMWVwMGR3aWFsdWtWY29xK2F6WmRPSFVyNUx4emozSXk0?=
 =?utf-8?B?RVdIZ3FsdUtuK3lMcDAyMUhRSXlIejJMOEpuTk5UQWlpOXRqVUJJVVIrRHRa?=
 =?utf-8?B?bWQ3T2hoNldKYWJJbDF2REs3VVFYMmRRY1dvZUFRV1FWcTJYamZQMThjWmJN?=
 =?utf-8?B?c1cvNFlsTTdNeFQvVTZ5T3JLTDBOdkxSVjliNTVaVkNvNGRFQ3ZMSUNwR3Z4?=
 =?utf-8?B?OWhzemVCUXN0VzFUUXd4SjMyMXpkd2lLczFaZ2VhaU16SVA4SzFQVThJUkRp?=
 =?utf-8?B?L0JjQTZlQXdETmYzZzJwdnRrRkJ5Y00yM0NieHpHZ3haZkZVMjFPbEkyYUpL?=
 =?utf-8?B?Z3dUMlBubUk5M1BaSjFzcTR5ZXhvbWJSZkNybTkzenJKWGxHUTFBRUxJcExv?=
 =?utf-8?B?WnhlS0k2dTNacDFXM1BxblNIV1JzK2hJN2kyLy85OEE2ejdRRURRNXJzU0tY?=
 =?utf-8?B?N1JOM21UZDA0ckxqZ3U4RVlaTlZzakR5dWk2S1FueHRTaDVYYnE0UVNuYXZF?=
 =?utf-8?B?OThnRFZiam1XOU0vbjlNb09ubzZGb0Q5YnQvZFVqVm5ZcFBFRS9md0xxQllX?=
 =?utf-8?Q?/Q/ZdWT5rLTMc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F02BBDC9A854C147AD8196C24F4DC8AD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1002a76-7ca8-4b37-fd50-08d897995460
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 14:40:07.3093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QtOiZYc2lSQ9+fDtophGDxyFA0PHD28JGmvU843ED7HBFvgpwL63AHCQiwt4ig58SNtlhp9a59BrVLXf+G/BQYlgCELKAI8YdgwmaS+hXFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4687
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTIvMy8yMCAxOjAwIEFNLCBNaWNoYWVsIFdhbGxlIHdyb3RlOg0KPiAtLS0gYS9kcml2ZXJz
L210ZC9zcGktbm9yL3NzdC5jDQo+ICsrKyBiL2RyaXZlcnMvbXRkL3NwaS1ub3Ivc3N0LmMNCj4g
QEAgLTE4LDcgKzE4LDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmbGFzaF9pbmZvIHNzdF9wYXJ0
c1tdID0gew0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBTRUNUXzRLIHwgU1NUX1dS
SVRFKSB9LA0KPiAgICAgICAgIHsgInNzdDI1dmYwMzJiIiwgSU5GTygweGJmMjU0YSwgMCwgNjQg
KiAxMDI0LCA2NCwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU0VDVF80SyB8IFNT
VF9XUklURSkgfSwNCj4gLSAgICAgICB7ICJzc3QyNXZmMDY0YyIsIElORk8oMHhiZjI1NGIsIDAs
IDY0ICogMTAyNCwgMTI4LCBTRUNUXzRLKSB9LA0KPiArICAgICAgIHsgInNzdDI1dmYwNjRjIiwg
SU5GTygweGJmMjU0YiwgMCwgNjQgKiAxMDI0LCAxMjgsDQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFNFQ1RfNEsgfCBTUElfTk9SXzRCSVRfQlApIH0sDQoNCkFuZCBJIHdvdWxkIHB1
dCAxLzcgYWZ0ZXIgNC83LCBzbyB0aGF0IEkgY2FuIHNldCB0aGUgbG9ja2luZyBmbGFncw0KaW4g
c29tZSBvcmRlcjogU1BJX05PUl9IQVNfTE9DSyB8IFNQSV9OT1JfNEJJVF9CUC4gV2UgZmlyc3Qg
aW5kaWNhdGUNCnRoYXQgdGhlIGZsYXNoIHN1cHBvcnRzIGxvY2tpbmcsIGFuZCB0aGVuIHdoYXQg
a2luZCBvZiBsb2NraW5nLCBCUDMsDQphbmQgbm90IHRoZSBvdGhlciB3YXkgYXJvdW5kLg0KDQph
bnl3YXksIGp1c3QgY29zbWV0aWNzDQoNCg==
