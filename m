Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1C3547670
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 18:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiFKQZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 12:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbiFKQZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 12:25:38 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120079.outbound.protection.outlook.com [40.107.12.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF318CE7;
        Sat, 11 Jun 2022 09:25:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blwPemzm7EnXHD0vODnZkSundxB6KZTPUd8wRYv2ZkWzk8I2gi9+mvxf/4HLNHoCoRjzcoy5Frl6XAFNrnZBVXbI6IM/m8jOXGtKPU+e//JwrfayuPr5mwNYbafDQR+u1R1x7fWrq3OX1d9HSdnfjADU/1cqsWowUsnCL2kpLewx/HvvgR32XENmK/4PRehe9m2XxPgQ3qYUl2kdTmm5GdJg79kd0JIDxYitsOnU/jf/RIG3e7GEMIIM5lUGLNgYVBsiCU/rQORHp0xCgeRRLhJu/auTExncWyFj1bDnm0MebYuaUq0gaaICvGK7XxtATSXjsMxW2e3/uGb2b7n61Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wQLSKw7agjhs/chpx3wGx9T0ECE8wo9kDhwc0sp4Tc=;
 b=G8zQtm0oxJMflRFSZr8TKwqqtkUD9j8JgcrKXt6d6a2XXcx4BKOrznlIz3rarE5SqMbBSt0Vq8W8+T8mJt2CzHhiINXjyPZRarON8qZ9uMipq1y3kkTLzDHtSMLr9k5rRWbJ0XdCgCH8/Dt4OqjSYuezx/1flbstrk34mMWvvUgqbWqMD/pKBhaKSKrvR7tbtwXJucMKXYg6N/L/S2QSnBc2bL4v9YzNP8YR1gDaiLUs2cjkznGO3tlbwGKtAPxfLXlbOeks8ExHA9/+2igvi42TvtuesJemu7tx+KOPRxZLPLXNZPiBD1MiGQ5sKQl6lz75TnRl1jps3MuyVbLqKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wQLSKw7agjhs/chpx3wGx9T0ECE8wo9kDhwc0sp4Tc=;
 b=ZcRJGTrtm0e1J4qEsp9WE/ed8dyFO4etY75b55zkWP3kx9bU56puKth5/AsKcAPFKRTMtzdPvO7mNiUl3qKyBrhAx4CoNoBceUbNO82WNJXVYtMWr3zgVdxtpli5O7z3FheSnRkU1INeAnGVb6sJpckJva3AFfFUyocxtiyqc5oO1OpNv5q43U5456OuSFhStFrkUfo/Cg1JiQ7lllo36oTCoLgJEQw10XOtnQae28jPV8AKyj+WC+jnuR0J62qqoOFJvn6WcnvudYKAc2WooxKGGpLE72eSgaj1LgjVezhvZFgiV+pM8OCg+Ru1X8x97yS1IJAHNvLlVegvGX4tYQ==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PAZP264MB2605.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1e4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.11; Sat, 11 Jun
 2022 16:25:36 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 16:25:36 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] powerpc/pseries: wire up rng during setup_arch
Thread-Topic: [PATCH v3 3/3] powerpc/pseries: wire up rng during setup_arch
Thread-Index: AQHYfaVnlXLpUH05BkytsPT8kH0CvK1KZHcA
Date:   Sat, 11 Jun 2022 16:25:35 +0000
Message-ID: <10b58eaf-ef0e-fe45-2547-f688481d0cde@csgroup.eu>
References: <20220611151015.548325-1-Jason@zx2c4.com>
 <20220611151015.548325-4-Jason@zx2c4.com>
In-Reply-To: <20220611151015.548325-4-Jason@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 382e4eb7-7400-4910-fcc7-08da4bc703c0
x-ms-traffictypediagnostic: PAZP264MB2605:EE_
x-microsoft-antispam-prvs: <PAZP264MB260583124E8DE5429D2B8C99EDA99@PAZP264MB2605.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SN1yZB1gAiE2z8+xlE/6YmBf8pkBwmew65cEOST2/lSAYn4mAMDYTAFuEvbnAC+yPkcQlOQKACFDKa7hMD1MT4tI8j8j68ACVA/pBecNL03p8MHRXUqnVDM4+5SadNkPCjhhU2hiBY1FeUQegCHIZ2+oYTqKTFtG0H1PMg2iS4t/ijgQGIHWtBTO/FS4su/IamdiZQ0oCeGDBmZajiEmhdNWwN8jWT1V6ZuRLET7ldgDZJpSyMBL0/TELzVvWnmZp6XHBP/hxTCI09Eu4gnFQ6QJcoyNL4558lrDH6HLWIsc7cGcHjIoWPYpuclYVM79U3OC8hvEji0le21vHnaoqBgi9BKUYAjxnQpaaQh9zcmZBOk4rmcFO87LBDbDt9TJNd7gZqzwBcst902iXvzm8r5bx8LCBsasIGYs9NdFaePOCjLCEdiNOzN0+RWyzeN5fMPm6cq4TLNWbsUJqPWXM2ZdNIlHubq31kPFOrqWcaD1Lilcm8HiWmEPHAcOG8DeWqo0/iaHyRKo8RYRGanrcYXnF6dS6833CjafnIBRnfU9jm+4rcFEuZgVN4/WgXxT2brCBJLfNe6oUiLqVUTovoeBuiSUeLctd1WA/YFtkyVd5UbRPgip2AOmZRBlmBr1cIX5p/TIToHn24OpAckbizVyJsp7EEwJgjXwhUQyomu8rLn6yLnvB+vUBWM6/tfm9Oo2cx8yrvg8kZ/cRGdlkXbjbNoYHFCUDjyrKpLpjmZUeVpo7V0TXAbRGeo3hb3CJnoajFYCBy0IaqWasTrD3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8676002)(76116006)(66946007)(66476007)(66446008)(64756008)(4326008)(6486002)(6512007)(508600001)(66556008)(5660300002)(8936002)(91956017)(44832011)(71200400001)(26005)(38070700005)(66574015)(2906002)(36756003)(316002)(31686004)(38100700002)(186003)(110136005)(83380400001)(122000001)(86362001)(6506007)(31696002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDljd1d4WmgwQXFRRmpvR1hJQTNXNzRWVVlscmNaZXpndWljNlZCSDdVWTlq?=
 =?utf-8?B?Qzlud2hoKzk0WDAvaWI2cmovZDlkL1prTFZOUVFjTmJRMU95NkJIemJxVGk0?=
 =?utf-8?B?MUtaQjhkZWE0NzV6SnIzUGxaYkVpSitPeDZNeHpmTEF5WGFOcitXZnRwTk41?=
 =?utf-8?B?MG5Oa2c3OHljN2h6VWxYcnk5UVl2VnRKZWFGYXVXNEhQRDN4eWR1OGpWbXhx?=
 =?utf-8?B?RktGZzE0MzFvOXFzalVrZUtHNFM5dUp4bEd0NndoaS9zT3R0dEZaQ05kT2x6?=
 =?utf-8?B?dHZFNnNJVEJ0REg2WHdxSVNhdGZHbWRaWUFwMVI2R3BBS05JQm9WenpSejNE?=
 =?utf-8?B?KzgzSUowZnhXTFhtUG8yanlxOGN1di9hUENNdGQxQnVGMjFrQnBTZUN6MXRy?=
 =?utf-8?B?Ky9CZUh6NzdzdUgyakFXUTB3aHYrZW9CN2FOUXdPVXI1dGpoSDNkQ0pJM2t4?=
 =?utf-8?B?UXh5bVYxSEtERHVnTjNTb2h1NG1HZzlmbHdQemRDOVh4K0tBNTZZdnp3cWFt?=
 =?utf-8?B?VWxGQ3VTdnM0Zk90SUdFbXR1UXIrcTNYa0crUGkvNUk4N0FGTTJnLzI3NWFN?=
 =?utf-8?B?ejNkMmZKbDN2cGx1Zit2TisxVll5ejU0ZG5NVkt2RUVnd1dHNWVNUVVTZ1BF?=
 =?utf-8?B?Wm9MbHdCdjlUMU9qakFMWUgrMHo0WDY4eVZmZ2Zzd1VOYzdLSk0wM0Z5Wlhq?=
 =?utf-8?B?WlBvOWoxSlEyMHFIa29lWGg1d1Y3M3VuUVBBZm1xb3duak1FN1hxbkJ5SnBF?=
 =?utf-8?B?VjFXRis1YW5BU0JyK1duMVk5UkFjZ3hrc3FGTXZ3WmpUMTkyeW9pOThVdkZl?=
 =?utf-8?B?NzNrZUprc252dllwRjhMTHBiSytmMFNrRzRONFV3dTI2M2FJcVZLSzBpQlo4?=
 =?utf-8?B?ZEJRNGdDY1JFOU55RnJWNE9QSUNiREE3OHNUTkpRejdvdlBhaG9uS1R4ZEtE?=
 =?utf-8?B?d21yWUlwaFo1d0QzYm5KWi8yKzR1aGI5TWJVUDc3Z3VIRmw5ekIydG5ETmxB?=
 =?utf-8?B?Vld2ZlFFUkpyd2NVZUdBT21hMSswaSt1S2lnV1RwREJuMDhNREhwUVQwS1cz?=
 =?utf-8?B?MlN5ZXByR3NMckp5cUwvV05YTkV0enVrcFZ6Qy9sN0hkMEVQWnJPREhsT29j?=
 =?utf-8?B?MzF1bnhRVUYrR1lIMzV4OXJKdk5SZWtxaVV1aU9QYXljcUFvaGw4dUgyUGdW?=
 =?utf-8?B?dnM2djhhTEtSdmZEa3YrK3BiVlpyNXRzR0hwTmJNTTI0aE0wbTBzVEliamJy?=
 =?utf-8?B?QnM5bnl2YnE4cmp3QjFHK1M3M3Q2MTcybldwYlJxdmtSN3hMdWNGSmM0MnZU?=
 =?utf-8?B?OWN3VFVGNjRyV3JzaXI4bWVqRkNsTVhJM0RvTnVFdFNZQnF3d1pRVXZZNzJH?=
 =?utf-8?B?Ny9Zbzl6SE41ekx0a3J5bm5jOWg2bS95bXh0V0d1MHlJTStsRFpqSjc3UWpP?=
 =?utf-8?B?MjI1NjR3eTZITlhJM3RtWkVvNWFVTC9SVlRSMjBmcGc0dkxUc0lFNG1ZeVhV?=
 =?utf-8?B?N0ZxOHB3bFNNSi9yYlZXbTF2VGNUbU5mdXFwOWNjamQ0akYxQjBYZkMwZXFO?=
 =?utf-8?B?a285eHRIV1dnYTAxMVRsL3pId2QzZG5LQlh1NVp0T29OUVBBT1pnd2xQYkZ2?=
 =?utf-8?B?Y0tKb1JONnRxb3J1blRWcExJS1lWbUtLZXR2eTRWMjJWaDQvZ3RYcTcyTHN4?=
 =?utf-8?B?dHB1UXdWZDlEUWFGeUYrYUZERHdhVmQzSVZBdTkrMy9hOVRpMGs2d3F1WGQ1?=
 =?utf-8?B?TmE3Z1kvYkk2K0liMGNJMlFENERZVmczdWN1dkd1Tk5ZZkZpbGhqcVd4eWZL?=
 =?utf-8?B?d1JzN1E3NlJOT05PZ2lHQm1NMTZTRmJLTjBQMXl4NVNmODJPZ2hMZDhncGlv?=
 =?utf-8?B?S01sZVZzdzYwdG9VQXBRd1FvckFNQ0xtcFNQY2ZLcGd2YjV3UWVkUGZRTjI4?=
 =?utf-8?B?MVA5Mk8yVVBzVGZMcDRjbTRMRUFvNUFZTVZxanJiQkg5VmwxQWU4YkkxNlZ4?=
 =?utf-8?B?Q2FJTElQc3FmMG5RTzBhS2hjbWJOaXdDU1FxekI5QWsvWkFBK3Q0Rk5UcGhS?=
 =?utf-8?B?SWk5U0lmUUp6TThOZm1OUEZYc1BtVXEraE1taDY2SWtJekZ5elVrN2dmVUZi?=
 =?utf-8?B?dzdrZWlVM3UyZGNsOTlnUTJGUVUrUm9BUDR2U29DK1RvM0ZYWEh3Z0s2VnpJ?=
 =?utf-8?B?V1VWSGVhQ0hoQTJjWVhNaE8rYURyc0hBVXd0U1B1UUhUZFJDR3pTVGd4bXc3?=
 =?utf-8?B?UlpaQjViMjh3SWlCakFDdTRFQkNFWVZXemhRSXRuNjhTektQM1NxVWpvaFQw?=
 =?utf-8?B?M1NqdXEvTUxON01ONGFPWlovcGpTUk55ZU1wRkQrcGM4VWxUVGFuSDVNS3VV?=
 =?utf-8?Q?yLeWiEiR8+cAn7XVYqBU8eoZjcO6jiY2/GrVv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39BE9EDFED6C764AA2D677A9BDF35E77@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 382e4eb7-7400-4910-fcc7-08da4bc703c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 16:25:35.9744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0z+c5RAAGGHZWZBjDf41kT+ZBu5/AzoM/qsz6mwUVemep1vAa6MVfEceJ5QR384csnyFZ+/CFJfp8bmo+dQ7S3+4RHUmDO79ohgPlqWJYaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAZP264MB2605
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDExLzA2LzIwMjIgw6AgMTc6MTAsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBUaGUgcGxhdGZvcm0ncyBSTkcgbXVzdCBiZSBhdmFpbGFibGUgYmVmb3JlIHJhbmRvbV9p
bml0KCkgaW4gb3JkZXIgdG8gYmUNCj4gdXNlZnVsIGZvciBpbml0aWFsIHNlZWRpbmcsIHdoaWNo
IGluIHR1cm4gbWVhbnMgdGhhdCBpdCBuZWVkcyB0byBiZQ0KPiBjYWxsZWQgZnJvbSBzZXR1cF9h
cmNoKCksIHJhdGhlciB0aGFuIGZyb20gYW4gaW5pdCBjYWxsLiBGb3J0dW5hdGVseSwNCj4gZWFj
aCBwbGF0Zm9ybSBhbHJlYWR5IGhhcyBhIHNldHVwX2FyY2ggZnVuY3Rpb24gcG9pbnRlciwgd2hp
Y2ggbWVhbnMNCj4gaXQncyBlYXN5IHRvIHdpcmUgdGhpcyB1cC4gVGhpcyBjb21taXQgYWxzbyBy
ZW1vdmVzIHNvbWUgbm9pc3kgbG9nDQo+IG1lc3NhZ2VzIHRoYXQgZG9uJ3QgYWRkIG11Y2guDQo+
IA0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBDYzogTWljaGFlbCBFbGxlcm1hbiA8
bXBlQGVsbGVybWFuLmlkLmF1Pg0KPiBDYzogQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5s
ZXJveUBjc2dyb3VwLmV1Pg0KPiBGaXhlczogYTQ4OTA0M2Y0NjI2ICgicG93ZXJwYy9wc2VyaWVz
OiBJbXBsZW1lbnQgYXJjaF9nZXRfcmFuZG9tX2xvbmcoKSBiYXNlZCBvbiBIX1JBTkRPTSIpDQo+
IFNpZ25lZC1vZmYtYnk6IEphc29uIEEuIERvbmVuZmVsZCA8SmFzb25AengyYzQuY29tPg0KDQpS
ZXZpZXdlZC1ieTogQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1
Pg0KDQo+IC0tLQ0KPiAgIGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9wc2VyaWVzLmgg
fCAgMiArKw0KPiAgIGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9ybmcuYyAgICAgfCAx
MSArKystLS0tLS0tLQ0KPiAgIGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9zZXR1cC5j
ICAgfCAgMSArDQo+ICAgMyBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDggZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVz
L3BzZXJpZXMuaCBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9wc2VyaWVzLmgNCj4g
aW5kZXggZjVjOTE2YzgzOWM5Li4xZDc1Yjc3NDJlZjAgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcG93
ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9wc2VyaWVzLmgNCj4gKysrIGIvYXJjaC9wb3dlcnBjL3Bs
YXRmb3Jtcy9wc2VyaWVzL3BzZXJpZXMuaA0KPiBAQCAtMTIyLDQgKzEyMiw2IEBAIHZvaWQgcHNl
cmllc19scGFyX3JlYWRfaGJsa3JtX2NoYXJhY3RlcmlzdGljcyh2b2lkKTsNCj4gICBzdGF0aWMg
aW5saW5lIHZvaWQgcHNlcmllc19scGFyX3JlYWRfaGJsa3JtX2NoYXJhY3RlcmlzdGljcyh2b2lk
KSB7IH0NCj4gICAjZW5kaWYNCj4gICANCj4gK3ZvaWQgcHNlcmllc19ybmdfaW5pdCh2b2lkKTsN
Cj4gKw0KPiAgICNlbmRpZiAvKiBfUFNFUklFU19QU0VSSUVTX0ggKi8NCj4gZGlmZiAtLWdpdCBh
L2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9ybmcuYyBiL2FyY2gvcG93ZXJwYy9wbGF0
Zm9ybXMvcHNlcmllcy9ybmcuYw0KPiBpbmRleCA2MjY4NTQ1OTQ3YjguLjZkZGZkZWFhY2U5ZSAx
MDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVzL3JuZy5jDQo+ICsr
KyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9ybmcuYw0KPiBAQCAtMTAsNiArMTAs
NyBAQA0KPiAgICNpbmNsdWRlIDxhc20vYXJjaHJhbmRvbS5oPg0KPiAgICNpbmNsdWRlIDxhc20v
bWFjaGRlcC5oPg0KPiAgICNpbmNsdWRlIDxhc20vcGxwYXJfd3JhcHBlcnMuaD4NCj4gKyNpbmNs
dWRlICJwc2VyaWVzLmgiDQo+ICAgDQo+ICAgDQo+ICAgc3RhdGljIGludCBwc2VyaWVzX2dldF9y
YW5kb21fbG9uZyh1bnNpZ25lZCBsb25nICp2KQ0KPiBAQCAtMjQsMTkgKzI1LDEzIEBAIHN0YXRp
YyBpbnQgcHNlcmllc19nZXRfcmFuZG9tX2xvbmcodW5zaWduZWQgbG9uZyAqdikNCj4gICAJcmV0
dXJuIDA7DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGljIF9faW5pdCBpbnQgcm5nX2luaXQodm9pZCkN
Cj4gK3ZvaWQgX19pbml0IHBzZXJpZXNfcm5nX2luaXQodm9pZCkNCj4gICB7DQo+ICAgCXN0cnVj
dCBkZXZpY2Vfbm9kZSAqZG47DQo+ICAgDQo+ICAgCWRuID0gb2ZfZmluZF9jb21wYXRpYmxlX25v
ZGUoTlVMTCwgTlVMTCwgImlibSxyYW5kb20iKTsNCj4gICAJaWYgKCFkbikNCj4gLQkJcmV0dXJu
IC1FTk9ERVY7DQo+IC0NCj4gLQlwcl9pbmZvKCJSZWdpc3RlcmluZyBhcmNoIHJhbmRvbSBob29r
LlxuIik7DQo+IC0NCj4gKwkJcmV0dXJuOw0KPiAgIAlwcGNfbWQuZ2V0X3JhbmRvbV9zZWVkID0g
cHNlcmllc19nZXRfcmFuZG9tX2xvbmc7DQo+IC0NCj4gICAJb2Zfbm9kZV9wdXQoZG4pOw0KPiAt
CXJldHVybiAwOw0KPiAgIH0NCj4gLW1hY2hpbmVfc3Vic3lzX2luaXRjYWxsKHBzZXJpZXMsIHJu
Z19pbml0KTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9z
ZXR1cC5jIGIvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVzL3NldHVwLmMNCj4gaW5kZXgg
YWZiMDc0MjY5YjQyLi5lZTRmMWRiNDk1MTUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcG93ZXJwYy9w
bGF0Zm9ybXMvcHNlcmllcy9zZXR1cC5jDQo+ICsrKyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMv
cHNlcmllcy9zZXR1cC5jDQo+IEBAIC04MzksNiArODM5LDcgQEAgc3RhdGljIHZvaWQgX19pbml0
IHBTZXJpZXNfc2V0dXBfYXJjaCh2b2lkKQ0KPiAgIAl9DQo+ICAgDQo+ICAgCXBwY19tZC5wY2li
aW9zX3Jvb3RfYnJpZGdlX3ByZXBhcmUgPSBwc2VyaWVzX3Jvb3RfYnJpZGdlX3ByZXBhcmU7DQo+
ICsJcHNlcmllc19ybmdfaW5pdCgpOw0KPiAgIH0NCj4gICANCj4gICBzdGF0aWMgdm9pZCBwc2Vy
aWVzX3BhbmljKGNoYXIgKnN0cik=
