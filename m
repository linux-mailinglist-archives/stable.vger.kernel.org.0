Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DF95475AD
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiFKOkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiFKOkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:40:51 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120089.outbound.protection.outlook.com [40.107.12.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8450BCB;
        Sat, 11 Jun 2022 07:40:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAYq1W6DZ297GctyGydxanJNYusViIyHhE0chcy8/AleWGjTzXn85AWJRexEyePUGUcLQhVOz5FrfAfNDXVwk/ouuFh+pAnJCpBtfapFze0YvFgWEP8vrMAr4tqezP6vlUzuxLKAxsn8S4u8Os6JCR0gpEllah8XwubvBSJbdjL6OfeyWlqrbwUC/z9ywek2b9NWjpdXUMAreUW6i3+LTxE88u1xXR6GMj6YW7juVZ8fSn5iTQQm35rLuqiJ4sqGJl6NITVnB3GFBaCl+qBmsila80vMp6OFYmtsiDkAkdcJmez2/ZvN6kwRXIOD2AJ7NdbhoYMstZbCLRow5JYT6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qb0OxJTPBubEUsTNUQXI4gEMIIi7XvROrchKnMVLTg=;
 b=De3GbaSJ6SnV/72ZpWIzFPRqmkDPWK2YXVQ4hbYCSc6xn+XpHIoVZPecyaE5U0Z4S5EwWxNhyx/vvpnB8Ya+7wFYsPhv6cPBsfQXax909luQ0DzMxW/cFULs+iNnilB+091lJMaDaOxqOuqVtP9CNzUkSi4/yV7WKePkJ/qM6HlLzbkoCfybdjm5GlLX5svftTbUXcyFlp8ywFAucPTUGnTfHB2jptpo09h9lvnMitcoJV1DL1+B0xdqP1uk2BKD2MflgmVyjB+Z4+F2l/kl44mg5AthWaYqzCO5u/IpuQc28K3CXxLmY/iewO+ebZ+Ax+4EobQqeOvAJ/J3n996eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qb0OxJTPBubEUsTNUQXI4gEMIIi7XvROrchKnMVLTg=;
 b=QaCriGNXuTrBRXV61u5Z0+spMFazoQjRGsYllTbf8X8HFzw4GHhlbr5gEsQBDpr/Loq+wHweGqZD1XHD/uN7Pwgo4sxyR93ESKWvhYvyXxnX9YIeLNcTT7yDevDZPVW5CGivf/ZNfMnX2Qpnd2GwurNNt0o/oUdtCKBZmj3uIjbS2c8tx9TitELDn1HsrajU+sRGNF8YM4eFJ8yEf/erl6W66TO6WSLE5sPoY7N2L8cFQAGiz2zxaJDFD/BiHQ/FRLSy44co0jY0vbN3oIpPOzffvyHn/FU9v2QrYYKiBmVElv+MNW7T29A0R9t3kWIZYWmAXtxwbsVP/SF5XEOdKw==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3905.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Sat, 11 Jun
 2022 14:40:46 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 14:40:46 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] powerpc/microwatt: wire up rng during setup_arch
Thread-Topic: [PATCH v2 1/3] powerpc/microwatt: wire up rng during setup_arch
Thread-Index: AQHYfXq8DcYmY+ypHEaglXyg0zBxaq1KR4SA
Date:   Sat, 11 Jun 2022 14:40:46 +0000
Message-ID: <6432586f-9eb9-ac71-7934-c48da09a928e@csgroup.eu>
References: <20220611100447.5066-1-Jason@zx2c4.com>
 <20220611100447.5066-2-Jason@zx2c4.com>
In-Reply-To: <20220611100447.5066-2-Jason@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d0402cd-23c7-4706-dcf1-08da4bb85f29
x-ms-traffictypediagnostic: MR1P264MB3905:EE_
x-microsoft-antispam-prvs: <MR1P264MB3905B6798CC5F24992F69F7BEDA99@MR1P264MB3905.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U47rk97Mele05lQVLgHk0/FLnWynVqfuYxOSrm+q53IwOOrweHyzO1pC9KX1OuVRxHAllLqalG9ukEfrkuwSau3/sNhFFF5qOQgV9Nj9dCRwIEFQFocTXG52z7PW0HMDAQ4vevcjH3T7pYzEA5F/IJK9T5Fq6dnw18Z6BSA0mRyxk6dmSWxSlGPy1elyxGyLAEBFYwiENffVQYOmuNEHmeDxxTL/iWzVJDPPYnLJDJ1CAJ+Q9XKK58qWZ/ymyH0UtldT/pEQdjHqTMYRgPvqu/Wkkn8x9DyMzjxXeOkmDIH2JvjOQEvWzFbWp2QNPJL07rTJ+zH+FceYXLWkmrSpeN7T7pyGlgE79DxRWyN5MuJbGw4ieb+HB9CfPF7LcHtnmFsRlNszDCnMwokaTFBuJ4Wm/8xDTKIbrPx+r8PRuKUCzol998Vn+9UAnwRPOPozQ5iKdMgqJ1CZ7q+Wzhewh8gTotSc46FLunvbWufbvT4piujme6MC/mlg5WyCDWF2pMWXNNqr2D3aYxoTSV19W2ll2gjuE2J/byy9hxNHtk0AlOl5KUJkT/wtIRwr2dY8zHzSHY9KSAWC57Bak8cr6LLHLUcL7QHHH41VEKwPyuRWwTK8RBRAGX5DYwuExXobKY+Sb1VZTwP1Iqf+6rr0AW11q1XtvijlEhnHDS2L445pgSiw2Pe+1q4g2Cyb6fj5V4J2vaV+cJEOFLL5ZhTEq4XR/2k9+35AAcnRzEx64x/LajCgXDFbvHjJwtUMcf/6hmB0MGA8YKg1LHYA7sQsfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(4326008)(64756008)(8676002)(76116006)(91956017)(31686004)(44832011)(36756003)(66446008)(66476007)(66556008)(8936002)(316002)(5660300002)(66946007)(71200400001)(6486002)(6506007)(110136005)(2906002)(508600001)(38070700005)(6512007)(26005)(122000001)(38100700002)(66574015)(186003)(86362001)(2616005)(83380400001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q294emtVNGs3TW5sZlFjdWhOblpuSC9sV1BERjhCdnZjN3ZTVHlxelNvVWZh?=
 =?utf-8?B?NFVBdFJhak5uMG5tK1RPZGhCZWRCWmZ4c2QxNE9oSkpla3NYTFpzTGxaQW9O?=
 =?utf-8?B?VURGalRNQjZNVWhiRVpTYVRVMCsyaGlkUjlSZEErSjJDNDk2NG5pMUthYmty?=
 =?utf-8?B?RTNNcWNTU1FQSko4aUpmRGJWTnNTYmdVWGR2SHY0aWtCK2Fsa3lNNDZRTVNw?=
 =?utf-8?B?Q1dVWk81anF2eHVNZ2JuQ0JDRGdZNGNBVTdCYURnM09NRFE4UjBLM1dPUGgy?=
 =?utf-8?B?SVl2Z1NVTnliMjkva2FuNWJYSFJoaTBqN0lla2c3L3JMd3YrY3ZUU1NNU0Nm?=
 =?utf-8?B?Z2dLVnhrTnl0blFKbXpMdUo4dzBTY2VtaUpuc2JyeW0xTDZkRDBURTR3WWZi?=
 =?utf-8?B?WlkrNk9IcHlPTnRLU2NhTWsxemRVTnVBUnBlVG1qcURzUUprMG5rUXhhdkhs?=
 =?utf-8?B?d0EvOE04SEdoblBXaDFGMVpnQmVMcFpwK1JXRDhDQXlFNlZzYUtkd3IxRm5z?=
 =?utf-8?B?MWoyTTlxMXJ6MUFKTXN3UHBBeVJxM2Z1eDlTb1BXb1MyM1U5REt1Q1dBVWx5?=
 =?utf-8?B?bDBXRDJYUGNsZ1dxN1RQTnpybC9scXNIQ3poUGVOMERobm9sRmRvbjNabFJQ?=
 =?utf-8?B?RG5ZUFRhckdackl0ejVqSVkwZjNjTzFaUEVOMjFjcGpNUXErelNnUzVRZ1J1?=
 =?utf-8?B?NmVlS3RSNzJNWTBUc1c1elVidi9ML1MzTnRqQlE5amdRa1pwQnRtQ2FyUWFE?=
 =?utf-8?B?QjR4QjFzT1M0R0JNdnhlcTY5TWppaUVwOEo5TkN4Wlg0YkxXWEU2V1lZa1pK?=
 =?utf-8?B?elZFbXFXcVBRNHJTeVFtZ09iVkxQZjBCVDFuS212U0FmekY5SUlXYWIrVzN0?=
 =?utf-8?B?ZU05V3Y3RFVEWXkrVld2dFc5c2tLMlVBVWp4ZS9tYndLVFVrME02QmJ1Q2Vh?=
 =?utf-8?B?d3RzY2VmTHQ1OHJ1QVEwUmhPY3QvYWxEbTNCRWZmMVFabWltbWpvOUQ3WnE4?=
 =?utf-8?B?MWdzUEtGOVNWQUFNLzNLazhKdXNOUHRaakhTOGdUaVRRNlhGWGdsMlFnMDhM?=
 =?utf-8?B?VVJBeDA5ZXMzTmZybFBqeDBCbVdqR0VhZWFwcWVTWm5uYWIzT3ZTMjZBc1dl?=
 =?utf-8?B?T3ZUNDlZMWg1L0o4ZXk5dUlxN3M5bzJoZU5jRHJYV2JDU2g1SzIyRDZBdFV2?=
 =?utf-8?B?bWtjTmVSVm1vdmsza29wakNjTERGS2VZRThWa0RMYlBNT2NINit0dkpQbmRo?=
 =?utf-8?B?b1R4RlhxNFRtbUhuNW84ZTFpWnlUTVR0My9sQnpOMnd2Vkpqb1JJZktaNlBm?=
 =?utf-8?B?eG5sc0tTRmlGL0ZsdzNDdG1pZ24zVnJWcWNBQjEvVUVhVzlteGIwZXJYWUtK?=
 =?utf-8?B?L1NoUUV4TXBqd1ZiY1dkN0tSTUtyaXNQQVY3OHV2TUdwTUU4Z0l3cVZZOGVP?=
 =?utf-8?B?UGFseDJpOXRxUkQyZlNnNXVyc3NkbExiYTcwUTdmTHZGRzFqZ0hSRS96OGRq?=
 =?utf-8?B?dG5CUWtGZGVrWktuNFljSHQ2VU41MExEa082SDdWaDVwdmR1UmlybnQwM3Fa?=
 =?utf-8?B?TGt6VW0vWk5tYXp3UW5MVnhMVCt0Lzc3YUxPb0syU25wR3RjRXJwaVZDa2JO?=
 =?utf-8?B?alA4VS9RNmVJcS9PamtOY1B5NElxRjN5cW1SZ29xQ0c5TGVkek5PbjVjb0pF?=
 =?utf-8?B?aXFkYkZPY0ZveFZPWCtEOHpSTklaV0pJdmRwdDJUTUJoMWlKSHgzc0lpU2xx?=
 =?utf-8?B?Q3g3L1dqWmRWanlSbzVrNk16T3VWN3VPcmNFa0FHa2plQW1qT2NYckY2M0gy?=
 =?utf-8?B?WkxFbm5qejZIS2Ywa0dIdTZiVnh6bldNS0I3dEJQblBpaWhIZ3drTTJBZzQ5?=
 =?utf-8?B?NGVDR2oxYktHcit2NGZCSkwvNVFEaUhpSGtXOXl4VU93V1RJcFlHa2pBdDFk?=
 =?utf-8?B?bHhGL3lRWWIxTUYzRDk3THVWM3ZDNHFTakl2ZktHNnYzZTVyRGU0MnN0TkZN?=
 =?utf-8?B?emY2R3dRcjJWL0QyYnRQK2FISk5STVlOM1A1Tncvb0VRb1RmUnAyTTl6aXEz?=
 =?utf-8?B?cUZTdjgxdXVSTFpPQlBNdzNhWDdBcW4wT0hBOEhIWXVua213Y0xKYUVNdzBB?=
 =?utf-8?B?ZUtzajFjVU41RWkvK0ZWdlZaZHdEekhGSjlzVWZGaHFLTXNSQjVmVm5Yaktx?=
 =?utf-8?B?SVBSd3dsZ1NkaTQ4UEtpQzNWMTlkQkd3K0hpNFEyeWNqMjNVTUtLbGFWY0NZ?=
 =?utf-8?B?TGZBaU11SzdlL0psbWp6dFE3ZWJRZVVuakRhVFczdk82MlFJS3lOWXVDM1g5?=
 =?utf-8?B?M0Qrb3p3S0k0UzM0WUpzYmNoTFgrcU96L3oveFdiT2dFZjZremVqdC9WS013?=
 =?utf-8?Q?Wo/9wyAeGHg19EICx0pgx0hbvh1a/TWUm2/LU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0AA7B53636C6C24C9DAF4B10CED1DBFC@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0402cd-23c7-4706-dcf1-08da4bb85f29
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 14:40:46.8678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KnJgFPrgwC2cbHcTmsMvlGAZfUym4KRGFB7HO19JP5Ob70pn90Bn0wXhBrDGyDIC/v9ng0KzVMFW76GNcq/EaPFWy/30yCM+3x1MlDz/r1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3905
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDExLzA2LzIwMjIgw6AgMTI6MDQsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBUaGUgcGxhdGZvcm0ncyBSTkcgbXVzdCBiZSBhdmFpbGFibGUgYmVmb3JlIHJhbmRvbV9p
bml0KCkgaW4gb3JkZXIgdG8gYmUNCj4gdXNlZnVsIGZvciBpbml0aWFsIHNlZWRpbmcsIHdoaWNo
IGluIHR1cm4gbWVhbnMgdGhhdCBpdCBuZWVkcyB0byBiZQ0KPiBjYWxsZWQgZnJvbSBzZXR1cF9h
cmNoKCksIHJhdGhlciB0aGFuIGZyb20gYW4gaW5pdCBjYWxsLiBGb3J0dW5hdGVseSwNCj4gZWFj
aCBwbGF0Zm9ybSBhbHJlYWR5IGhhcyBhIHNldHVwX2FyY2ggZnVuY3Rpb24gcG9pbnRlciwgd2hp
Y2ggbWVhbnMNCj4gaXQncyBlYXN5IHRvIHdpcmUgdGhpcyB1cCBmb3IgZWFjaCBvZiB0aGUgdGhy
ZWUgcGxhdGZvcm1zIHRoYXQgaGF2ZSBhbg0KPiBSTkcuIFRoaXMgY29tbWl0IGFsc28gcmVtb3Zl
cyBzb21lIG5vaXN5IGxvZyBtZXNzYWdlcyB0aGF0IGRvbid0IGFkZA0KPiBtdWNoLg0KPiANCj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IE1pY2hhZWwgRWxsZXJtYW4gPG1wZUBl
bGxlcm1hbi5pZC5hdT4NCj4gQ2M6IENocmlzdG9waGUgTGVyb3kgPGNocmlzdG9waGUubGVyb3lA
Y3Nncm91cC5ldT4NCj4gRml4ZXM6IGMyNTc2OWZkZGFlYyAoInBvd2VycGMvbWljcm93YXR0OiBB
ZGQgc3VwcG9ydCBmb3IgaGFyZHdhcmUgcmFuZG9tIG51bWJlciBnZW5lcmF0b3IiKQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBKYXNvbiBBLiBEb25lbmZlbGQgPEphc29uQHp4MmM0LmNvbT4NCj4gLS0tDQo+
ICAgYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9taWNyb3dhdHQvcm5nLmMgICB8IDkgKystLS0tLS0t
DQo+ICAgYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9taWNyb3dhdHQvc2V0dXAuYyB8IDggKysrKysr
KysNCj4gICAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9taWNyb3dhdHQvcm5n
LmMgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL21pY3Jvd2F0dC9ybmcuYw0KPiBpbmRleCA3YmM0
ZDFjYmZhZjAuLmQxM2Y2NTY5MTBhZCAxMDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL3BsYXRm
b3Jtcy9taWNyb3dhdHQvcm5nLmMNCj4gKysrIGIvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9taWNy
b3dhdHQvcm5nLmMNCj4gQEAgLTI5LDcgKzI5LDcgQEAgc3RhdGljIGludCBtaWNyb3dhdHRfZ2V0
X3JhbmRvbV9kYXJuKHVuc2lnbmVkIGxvbmcgKnYpDQo+ICAgCXJldHVybiAxOw0KPiAgIH0NCj4g
ICANCj4gLXN0YXRpYyBfX2luaXQgaW50IHJuZ19pbml0KHZvaWQpDQo+ICtfX2luaXQgdm9pZCBt
aWNyb3dhdHRfcm5nX2luaXQodm9pZCkNCj4gICB7DQo+ICAgCXVuc2lnbmVkIGxvbmcgdmFsOw0K
PiAgIAlpbnQgaTsNCj4gQEAgLTM3LDEyICszNyw3IEBAIHN0YXRpYyBfX2luaXQgaW50IHJuZ19p
bml0KHZvaWQpDQo+ICAgCWZvciAoaSA9IDA7IGkgPCAxMDsgaSsrKSB7DQo+ICAgCQlpZiAobWlj
cm93YXR0X2dldF9yYW5kb21fZGFybigmdmFsKSkgew0KPiAgIAkJCXBwY19tZC5nZXRfcmFuZG9t
X3NlZWQgPSBtaWNyb3dhdHRfZ2V0X3JhbmRvbV9kYXJuOw0KPiAtCQkJcmV0dXJuIDA7DQo+ICsJ
CQlyZXR1cm47DQo+ICAgCQl9DQo+ICAgCX0NCj4gLQ0KPiAtCXByX3dhcm4oIlVuYWJsZSB0byB1
c2UgREFSTiBmb3IgZ2V0X3JhbmRvbV9zZWVkKClcbiIpOw0KPiAtDQo+IC0JcmV0dXJuIC1FSU87
DQo+ICAgfQ0KPiAtbWFjaGluZV9zdWJzeXNfaW5pdGNhbGwoLCBybmdfaW5pdCk7DQo+IGRpZmYg
LS1naXQgYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL21pY3Jvd2F0dC9zZXR1cC5jIGIvYXJjaC9w
b3dlcnBjL3BsYXRmb3Jtcy9taWNyb3dhdHQvc2V0dXAuYw0KPiBpbmRleCAwYjAyNjAzYmRiNzQu
LjIzYzk5NmRjYzg3MCAxMDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9taWNy
b3dhdHQvc2V0dXAuYw0KPiArKysgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL21pY3Jvd2F0dC9z
ZXR1cC5jDQo+IEBAIC0zMiwxMCArMzIsMTggQEAgc3RhdGljIGludCBfX2luaXQgbWljcm93YXR0
X3BvcHVsYXRlKHZvaWQpDQo+ICAgfQ0KPiAgIG1hY2hpbmVfYXJjaF9pbml0Y2FsbChtaWNyb3dh
dHQsIG1pY3Jvd2F0dF9wb3B1bGF0ZSk7DQo+ICAgDQo+ICtfX2luaXQgdm9pZCBtaWNyb3dhdHRf
cm5nX2luaXQodm9pZCk7DQoNClRoaXMgcHJvdG90eXBlIHNob3VsZCBiZSBkZWNsYXJlZCBpbiBh
IGhlYWRlciBmaWxlLCBmb3IgaW5zdGFuY2UgYXNtL3NldHVwLmgNCg0KY2hlY2twYXRjaC5wbCBy
ZXR1cm5zIHRoZSBmb2xsb3dpbmcgd2FybmluZzoNCg0KV0FSTklORzpBVk9JRF9FWFRFUk5TOiBl
eHRlcm5zIHNob3VsZCBiZSBhdm9pZGVkIGluIC5jIGZpbGVzDQojNTk6IEZJTEU6IGFyY2gvcG93
ZXJwYy9wbGF0Zm9ybXMvbWljcm93YXR0L3NldHVwLmM6MzU6DQorX19pbml0IHZvaWQgbWljcm93
YXR0X3JuZ19pbml0KHZvaWQpOw0KDQpBbmQgSSB0aGluayB0aGUgX19pbml0IGtleXdvcmQgdXN1
YWxseSBnb2VzIGFmdGVyIHRoZSB0eXBlLCBzbyBzaG91bGQgYmUgDQondm9pZCBfX2luaXQnLg0K
DQo+ICsNCj4gK3N0YXRpYyB2b2lkIF9faW5pdCBtaWNyb3dhdHRfc2V0dXBfYXJjaCh2b2lkKQ0K
PiArew0KPiArCW1pY3Jvd2F0dF9ybmdfaW5pdCgpOw0KPiArfQ0KPiArDQo+ICAgZGVmaW5lX21h
Y2hpbmUobWljcm93YXR0KSB7DQo+ICAgCS5uYW1lCQkJPSAibWljcm93YXR0IiwNCj4gICAJLnBy
b2JlCQkJPSBtaWNyb3dhdHRfcHJvYmUsDQo+ICAgCS5pbml0X0lSUQkJPSBtaWNyb3dhdHRfaW5p
dF9JUlEsDQo+ICsJLnNldHVwX2FyY2gJCT0gbWljcm93YXR0X3NldHVwX2FyY2gsDQo+ICAgCS5w
cm9ncmVzcwkJPSB1ZGJnX3Byb2dyZXNzLA0KPiAgIAkuY2FsaWJyYXRlX2RlY3IJCT0gZ2VuZXJp
Y19jYWxpYnJhdGVfZGVjciwNCj4gICB9Ow==
