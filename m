Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C215C55398E
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 20:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiFUSdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 14:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiFUSdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 14:33:16 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90083.outbound.protection.outlook.com [40.107.9.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57BE62D1;
        Tue, 21 Jun 2022 11:33:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0wUwzU/AFZfJx/3Vx3+V8eNIoQqA08aPThFJe4ko1Z2OVSRQXUgO699sirO89Ry/3+eDSyaPdFEyJhj/XWliMXpG179B0jZECeszk46HmgLZ09/TB3rjYRJrMUg8052/cai8wtWWSBNiJiTW01+STXYi/tH/O4HFAt8BIKfH7Nyvj3pOFyZ01W4imBImjr/itcDhlm1XwDCcWjQ0cXck2Hkru1kgEQV2eaSSQCRJpMttGWobQG4KDH/RMtOr1zBtfGe2gtGjGvP4CgGlkkF3wYDUscC8H88tgJncKgbdEsrxm9GSXnhmF6Uy93yTgUx8esotmUUClCffGnO6+Qiuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZmEznOZbLwhIhtKWmO8Bnkxy1aXwJnNSOVGgWa9Ibs=;
 b=AKuAwUtnQj0zl/i/cgzgEdpqbdI7H53GGnRmQ17/J7tSN0ayUz38xJR3X5dDnxylNsdNaK3uFYYYoEyAMu6RcDR3qTCEO658tZwf0KGi/Q/4ncxIh5X/wuUDtrOoowQEOMITDJyRQNniO7Pq9LiYtIy3E08v4fy3TD9BFQrGKOC7x2DgCodE2isomXF33gRuGBAeycloXupR4TMq+mjkV0zLXKxUe8+er69KgXQCbACUY7+eRlQQohlEsKiH5an+Hj0yPW4wYfQgZg4DJNWX42piy27KIdn/TKWnYjExEfkbGxCScEYTkiDr/bU5Yj2NWbieDiwujCb++MifPFTgjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZmEznOZbLwhIhtKWmO8Bnkxy1aXwJnNSOVGgWa9Ibs=;
 b=C2lMbrl9gVSBnbbjmCRR+FN5Lo1Pt9yQk2Ptgc1IbwL34zABEYTWBUFSilFyjvd5FeMxETdFXK0oel77pm1JfXS7gR/umPP77G2UvoI3GWp5u7ZC+yqEuTUEUZgJoK02CnXjSCy9iLCqTRa6YbXRx4wuta3qSEXDH4Qde/X1NszywIi/px/3ijKsBZTYCYx2Z+ribSbVPK42NE6q5HnXFgGkYlEqpyOESDyXkaFC5U8mf/DUQPIjSVBJX6Sz+KuerZbJHLRhRgxYXYpnkVhvUuLnlbntIPz+BvmegyjSbVKyWfO8i8U67SooXJ+CGM3sxuM4KUiSEozeQRpJgJbrsA==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB1800.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.13; Tue, 21 Jun
 2022 18:33:11 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%5]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 18:33:11 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v5] powerpc/powernv: wire up rng during setup_arch
Thread-Topic: [PATCH v5] powerpc/powernv: wire up rng during setup_arch
Thread-Index: AQHYhXh1PvCZuYayFUCvQiuwTsxZUK1aL8YA
Date:   Tue, 21 Jun 2022 18:33:11 +0000
Message-ID: <246d8bf0-2bee-7e1b-e0af-408920ece309@csgroup.eu>
References: <20220620124531.78075-1-Jason@zx2c4.com>
 <20220621140849.127227-1-Jason@zx2c4.com>
In-Reply-To: <20220621140849.127227-1-Jason@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b59fc07-03ba-4056-dcca-08da53b47ed7
x-ms-traffictypediagnostic: MRZP264MB1800:EE_
x-microsoft-antispam-prvs: <MRZP264MB1800676DB78EFCBA0502C599EDB39@MRZP264MB1800.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /bq7vdirTnDfh+dSvmeyH2y4n8Ir0kq+RpPtUEflzx333nMu84x4bg+V5Hs4Xhx0Y28RMkVO7X31ZwZ5Mih0V/fqITEMUQpzeriHlgoDaFUlqvV9IWui4RRI20mi2MDLwmUhKxVuPXwFdkUvYVMGag2iDnX4H/B1qAAy7hMnpsWxHYJWJKbkDIiH1DwdwX3UUl8o7Im4n486pmUQ+9w73XqToR4Gj6n9MFN6XHab25P/YHWuZd1M0UMXF4udrwtQEVzxyZBelkGU6xzAMKzzNmLTUEcsheQjoVTov43yALsLRFQsxhk2DGjHzcegDCpUgkvFs/Cdhqd9yKHMkuSAfRTw4BjpiHPRhUf8ZI8XlbgH+tnSiBzqj8dSzLA047vcGiGi1EYaof5mkP99wl9W+b5pc6glnVQG+nHty7m5mFTeiOxw3d1XiJq9j3Ng5ZBYAG4K8MiqBV6CdZuBE5P9nOrUyBup6fF7TnGpDbDFfK1TE0/Iy37YJP+e1AX6EA6KqGTLnqKTqH/tGgEc0ACz7UO2Ef9HYIhIR1PmIFygG3l9YbHdpk5bjKUK5JONQJfiZ88sbFAf2dPAHLBQAqZWfpdr+zY251zsc+t6XPDYboGh4RAUQg2ooFNN/qZN80TYcN2ycLFvAkawHTwF/grKlMlhcAfiL4wpXEwo4DP2+fdX7aaS/RsTlGAPGXYV2fOmzVITNP2u6JGA0L+cJ8UhOnLl+aMIPceZgZputChJDmvF7P6P7M1JuYruk/sniw65gPwkW7tQTdlMjlxkcE0DVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(66946007)(76116006)(91956017)(64756008)(478600001)(66476007)(5660300002)(66574015)(6486002)(66556008)(31686004)(8676002)(2906002)(44832011)(36756003)(4744005)(71200400001)(8936002)(6512007)(83380400001)(38100700002)(86362001)(31696002)(2616005)(110136005)(122000001)(26005)(316002)(6506007)(38070700005)(186003)(66446008)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzMwRUpkVnM2T1BDK2hjaHIxZytCWUREelZ5eEJWaUk0VkZZTjRscUxIbmE4?=
 =?utf-8?B?UlRYZSthcnpJNE9kbFJVbHloWDcyTDI5THhkZ1JCZU1tZk5BcitGUFdWa1lB?=
 =?utf-8?B?b2o2TElKU1pKTE5aUlk0Y3BvS1JJeWgrQWxpSUt6emZjQnhoeUcyUHJGMUQz?=
 =?utf-8?B?alVDMndGcDh5TVhGc3lCUHIrQ2JIOElhcnp0VUpGR0g3UUxWSGJEcW5tSlUx?=
 =?utf-8?B?VzhwejV4VEw2MVlRdkdXQ0RuQlJFK0hkeG5MOXFGVFc0VGFYVEVwd3RCcUNC?=
 =?utf-8?B?RGVpa3Y3SksrL2puNG9sSndDZldmYkZhRkljeGpQY2tHQlN2MWM2c0I3dmp5?=
 =?utf-8?B?aTU3cjdXVWQ1MVljSXk5NVY1T2Nybi9WbDhIMnFkbzFwWWZUZEFteitCaDdR?=
 =?utf-8?B?dndnalN0SFVIMmx3dmQyWjdUaXllSEV3RllZSDFKVGZ2MHNVUXlUamJuWWR1?=
 =?utf-8?B?bkZXK2t0UlM0d0JnQkhMNWo5ZnFSaWQwcXRHYUFDSzhLNDdTWTgwNXVrZmdW?=
 =?utf-8?B?cW5obUhXZXZ4eFlLd1p4WmE1UTZUb2JheHVuYzhUaEJnL3Fkb24va2FUeVU5?=
 =?utf-8?B?elByRkZGOFYxY2M0KzRCdVFkajBLUGF1U3QxZ2gvaDJJSEhOR1RnbktkOStx?=
 =?utf-8?B?aWE5bnBTdU45dVpEQ1VKeXRhdVV4VDdaZGRnbVRhY2VwUjUyVTVaWUhVTDAr?=
 =?utf-8?B?VXZ5OWYvM1lHSHhoUVdsUzNBTnVreC9XeGZJa0EzbHZ1dkRjdTBMMkQrOGJu?=
 =?utf-8?B?OTdnRFdLbkF0NGo5d0tBVlk2emJyNjhQdnJTYWJkYnFDQnZtODhpa3dybFIz?=
 =?utf-8?B?QWVWaVU1bUJmQlN4cnhSdkV4OWF0d0oxemFRUWZhdi91dTh6K2RVdGFIS2lU?=
 =?utf-8?B?VlUrWUhWT0p3cUFEcGprdlV2by9RbldzMnowUXB6VnVLZXgrRGRheUpDU3JH?=
 =?utf-8?B?MWZCeWdkczBseGNOTHhVamtxakg2RkdSQjVvQnlMR2ViU2NlZkdJcG1NUzdw?=
 =?utf-8?B?bEJRTFBpUVQ5dXVMb3ZKMzBpZUVZaG9QbEt4MEVhalZTdFdlcTl5K3Q2bWl2?=
 =?utf-8?B?VUlsLzRvbmlQQjNod1FKVzlOZldIYUpHcDNXQ0dQUW16TXRPVll0S1JUeXlz?=
 =?utf-8?B?aHAzQnJBd0djbjM4RDE3NHNFdlNsQ3g2M0RvTTJIa0ZHTGlITVJVWXRhN0Vt?=
 =?utf-8?B?dDJsaC9ERkNvWFBKdlNkRW03VmZUbndZZmQxUTBQYUpBTS9JSGt1U2IvaEx6?=
 =?utf-8?B?VWpqNFRJSTlRVEZncWZJRE9nLytNNUJiZFdTM2F4NDBjMkNoRlJKM213d0lq?=
 =?utf-8?B?eTZ6UGQwcFdGV04vbFh2UTdwV1YxaEZiTURKZ3Q4cjlWbVM2MCtUYzhoVHk3?=
 =?utf-8?B?V2NDYUlUeEZKUVAxVTNXZFN3eUtvb2Z2RU1jc01zODRrbTRsK1N2eC9HWGFE?=
 =?utf-8?B?UW5GSGJ6dlVrQ3JqUmRRK3VWcmtxeVhoMThKYkZldmlHL1JjM3hsS0JGZlZD?=
 =?utf-8?B?WEZSWkJpUnpFZzhwM0FEU25MUmZZeHJXN3pGYWU0Z2NEWG1XNzlUZE44Q1Bv?=
 =?utf-8?B?M210c3gyeEZ3V2dCY0NIV0tiMStKMFpPdThVNGNrelpZbk1ka2VpVENwaFJ6?=
 =?utf-8?B?SGdZTmROREFnRGRCcFp1WWIyK2x2TlVkKzY4VWxEL3gyQTJnaWRrck5ZS2xO?=
 =?utf-8?B?N3hrOHpUaTgwK1VQcm5NSGE5WTAwbVJGaHZuQ1lRYmhkVDVobTlBSGNZZ1E0?=
 =?utf-8?B?c2dCd2FQM1FIbHdYblFyREsvWXd4SWMyZkhjNHVSSnd0MkJZV1BiekRadVQ0?=
 =?utf-8?B?U0ZRZGlaRlM5K0JtNDZodXdjUlVSZTFQeXdwd1ZnMXVSTVFDbkdUZ0gzQnRC?=
 =?utf-8?B?NFhkczEzczVmRzhSWEdhMVgrcDZQUU9iUlJNT25MODh1YUQ5SVJwQkE3Y29G?=
 =?utf-8?B?dEtYdGNTcGxXOXh3NFNIQ09rTVpoYlNFMVBjd1NFUmxzb0hYcVBCbVVpOUpt?=
 =?utf-8?B?ZnlBRHJUU1BhWjNways3TCs2M3MzVnJGRXdKMlFsOFErNkpxd1dOVlNaRWNs?=
 =?utf-8?B?V1UzMDNBUUU0M0tTNlJoQUN6Mi9RSVhVLy9TRGRyM1ZMbWhyeFBPMFlMWS9O?=
 =?utf-8?B?MW13cjJhMS9mU0lkbXduYnA3VzBiSmNReDFubWlFM2NBOGJSOVhaenhoeWh2?=
 =?utf-8?B?KzYwVWo1cE5pR096WkxmK2tJVFVjMFE5c1c4RVI1Nm90MmdCZDdtMDQvSVpP?=
 =?utf-8?B?TXBCb0g3OTVtM1JMeWx6WDhkNy9mcWMwc2hmZDZJVFNBQnBRUHdyODMwY0dm?=
 =?utf-8?B?bGFaRTcweEErWWkvOUcvUXpkOFE5eTVhdmEvNmtxQksrYVNyUWViUkFpWEFR?=
 =?utf-8?Q?euTcHguGh2IP+YuP9UQd7UxYr3/iCVo1d33xT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <790FDF96FF79B2449DFBB83C3ED916BD@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b59fc07-03ba-4056-dcca-08da53b47ed7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 18:33:11.3016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LZk6PI5sFQZ8tckx3MgR5xLmA9P8t079dzZue4hVTzFXCLrsbsgWnTXYeNkCJzAxk3eQd5rCP/TsZcv8HxTYRto90xF5gy4Mv7kGbKWN3lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB1800
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDIxLzA2LzIwMjIgw6AgMTY6MDgsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBUaGUgcGxhdGZvcm0ncyBSTkcgbXVzdCBiZSBhdmFpbGFibGUgYmVmb3JlIHJhbmRvbV9p
bml0KCkgaW4gb3JkZXIgdG8gYmUNCj4gdXNlZnVsIGZvciBpbml0aWFsIHNlZWRpbmcsIHdoaWNo
IGluIHR1cm4gbWVhbnMgdGhhdCBpdCBuZWVkcyB0byBiZQ0KPiBjYWxsZWQgZnJvbSBzZXR1cF9h
cmNoKCksIHJhdGhlciB0aGFuIGZyb20gYW4gaW5pdCBjYWxsLiBGb3J0dW5hdGVseSwNCj4gZWFj
aCBwbGF0Zm9ybSBhbHJlYWR5IGhhcyBhIHNldHVwX2FyY2ggZnVuY3Rpb24gcG9pbnRlciwgd2hp
Y2ggbWVhbnMgd2UNCj4gY2FuIHdpcmUgaXQgdXAgdGhhdCB3YXkuIENvbXBsaWNhdGluZyB0aGlu
Z3MsIGhvd2V2ZXIsIGlzIHRoYXQgUE9XRVI4DQo+IHN5c3RlbXMgbmVlZCBzb21lIHBlci1jcHUg
c3RhdGUgYW5kIGttYWxsb2MsIHdoaWNoIGlzbid0IGF2YWlsYWJsZSBhdA0KPiB0aGlzIHN0YWdl
LiBTbyB3ZSBzcGxpdCB0aGluZ3MgdXAgaW50byBhbiBlYXJseSBwaGFzZSBhbmQgYSBsYXRlcg0K
PiBvcHBvcnR1bmlzdGljIHBoYXNlLiBUaGlzIGNvbW1pdCBhbHNvIHJlbW92ZXMgc29tZSBub2lz
eSBsb2cgbWVzc2FnZXMNCj4gdGhhdCBkb24ndCBhZGQgbXVjaC4NCg0KUmVnYXJkaW5nIHRoZSBr
bWFsbG9jKCksIEkgaGF2ZSBub3QgbG9va2VkIGF0IGl0IGluIGRldGFpbHMsIGJ1dCB1c3VhbGx5
IA0KeW91IGNhbiB1c2UgbWVtYmxvY2tfYWxsb2MoKSB3aGVuIGttYWxsb2MgaXMgbm90IGF2YWls
YWJsZSB5ZXQuDQoNCkNocmlzdG9waGU=
