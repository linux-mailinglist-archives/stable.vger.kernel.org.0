Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9225553A75
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 21:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353545AbiFUTXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 15:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354025AbiFUTXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 15:23:21 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120079.outbound.protection.outlook.com [40.107.12.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7794013CD6;
        Tue, 21 Jun 2022 12:22:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMrpei5eASabkdPJwmL+5CYa5iBzM/mOCtbt4CV5a07SJY1Xf7L33uzOKTHfAWLywqYymwgDlJbBa+OS/9twSV1aYE6kHbR0M6e+IlarRVDbVOGLsBtpkyEcfMz2gCC4veinZZhmBr6eOOKcz9vtoPKXhNuJsvKjZNpQkewR2Fy2oZlq4phKKbKcVOVgMElMVhwSEAyQYTl54B5qPEJS+xkTeVlWUiwl/U1mGiI290L8Y67uoCgNnnVJHgcSC/Zg4wRVJ8+yzATYvXQQ3b1d+9sdqJs9qLK1+vJPld+nMxHzLCP98DEQdlkDd6Oe6BaP0en+62lzvvQyMyUmuyqnCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4L69yNvJkpuO5FqNdjOVb9cRmuNvCzEs3tEebzOd6U=;
 b=fWbEMhZZYHVl8Nti5UxAeAvO4fbufbM5gPyaDmj0H6i2G8L/55t3LEUXN850LBLbBvpiSep/znp2aRphvvaI+RQ1GV+w5qab/N2oNYPbYNkEplNpt1l7L945igLXQv4DWc464X1BnRRTQ0s+zJ2Kx7mbdIn+4z2gw7V1gbWMuCkZhKCZ0lH5iYEHPzJU9Sr4i62Ezi2I5WBxLvnNhLRmA7c+AtKcygLn9v+eTulhnq4UhUIbjHjNR+AZzp4eOR1/VrPNXohs9jSM1eYxYG2hPjgzO2WDWpvZmGbefmHXt4Mb1BlqBRks1Jx5tFmbwukFOzDdYFrmMNApRAE2vpREdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4L69yNvJkpuO5FqNdjOVb9cRmuNvCzEs3tEebzOd6U=;
 b=HMoLlRHN4CjY7z/q/sIIN5LWeaZCR2680kqAMAP8IWwIwnSqpDhe9QFirrnAVadzcWGGvZZt7dMxh+qNqBYJRXJLWPxiKxnUKqm7pnCkCbNmxL++l4MmwwPxVjv69IHvxWuqDBJ7VyDAcmNwsC+ZXTBK0ZPIhwH+ZmJkw8oc15UhbxtCRJLBq+GjEUpYuNmEqFWADifYxUrCnbgP0QDV3TxUu/mnhuKyzZbPdBmA0TltdIC54aEq1LFN08TEPl+rxarZgb2E/zcnFw1oZR6f/l3uZOMJzFDzN7nAZCiZbRI7GYEZGidVu+dmvJsSQCfXnXegfFoYt9Dw7A9cfZcVyQ==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PAZP264MB2895.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1e6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Tue, 21 Jun
 2022 19:22:56 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%5]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 19:22:56 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     Michael Ellerman <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v5] powerpc/powernv: wire up rng during setup_arch
Thread-Topic: [PATCH v5] powerpc/powernv: wire up rng during setup_arch
Thread-Index: AQHYhXh1PvCZuYayFUCvQiuwTsxZUK1aL8YAgAAEGwCAAAnLgA==
Date:   Tue, 21 Jun 2022 19:22:56 +0000
Message-ID: <a354de5e-1d07-3759-a55e-a9179890cfaa@csgroup.eu>
References: <20220620124531.78075-1-Jason@zx2c4.com>
 <20220621140849.127227-1-Jason@zx2c4.com>
 <246d8bf0-2bee-7e1b-e0af-408920ece309@csgroup.eu>
 <YrISWLwm8m7OPFom@zx2c4.com>
In-Reply-To: <YrISWLwm8m7OPFom@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa578dea-7d5c-4bd1-89a3-08da53bb71fc
x-ms-traffictypediagnostic: PAZP264MB2895:EE_
x-microsoft-antispam-prvs: <PAZP264MB2895F192D4BCD39DE0F78DFEEDB39@PAZP264MB2895.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I3O9ExvHOmEvucOyti9GabztzEa6VheFCR/MtDQ8U0aL05nF+VnnwhXxHIlcBwkL2rajaQHXTjZ6ThLVDEvmtNW15CWrKSf3PciT5BWeSh6HkrNkXag8PrqUMhpvmrfHw0eO55WClI7eLlCc/q9fVyGrvsSUSzQgZ32XOgcrZupM++YM4Eu3GvLhLMFihQaeel7+ai+2H/IWpAG5118k1inkCIfnomEx4VMlrjGEJTW1qEXONT11zP5w6wjcGjeJI/rog6JipdCsFzTbtnnz/9y0hVmT7+7A7RSxE6s1rFDnETQCs0YRJ/soQMRa9+WEm/rIU0t+JfbjXV3RuQl6gciOKXLadnOb08TgUOFoiYv82jlkTX2W51S5KYccQF/Q7xvtSZ598CurydKBUouB2fwzReXi0hDPoeEJElD0LPF61J1aEYdVGryJ9MtJmA5INWLl3nnZMvhToPYmST7VxTQtEZuiX+Z5GYxN0ORvMXVOE1+2J+S4elbHni6uiBMD87EFHkYd+082spMnOaaZeBOfopPugV3SC7W4X92MxUR75ZPIyg7BrWsbUg6hn+ilx8CJ4SaBzhSLW9uRSll+jn3SnmNM7IKIVztZrYRrqwW01snevuYS+I6hVLm8rXFhBq/bxiwJTpb/xtlJsij86KAt9TzgvTWc0VS06JnTIsCDr8J8yNUYm3PFj65d3FY/14UvBNeWlkTVQBheo561pHlLqbAOhsODXyU6hOLAAvSiUBHoW0XVhe69bgE8Sde0yiJkoDq0XA46ADIzQJVayA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(136003)(39830400003)(346002)(76116006)(38070700005)(64756008)(66446008)(8676002)(83380400001)(31696002)(91956017)(71200400001)(122000001)(54906003)(66946007)(316002)(4326008)(66476007)(6486002)(66556008)(478600001)(186003)(86362001)(8936002)(6916009)(38100700002)(6512007)(6506007)(5660300002)(36756003)(2906002)(26005)(44832011)(31686004)(66574015)(41300700001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXhsMHlqWWtNMXJLQzZaeW0vekpZY0FZa2N2bzNORC8xR0twcjEyVEE4TTFq?=
 =?utf-8?B?Y3JDVHgxa3d1UWx6cVpMM2RsK2dSd3V1QzdEVHRDaGNtZk91NGQyWVdWK1R2?=
 =?utf-8?B?OFk2RllMeHJlYTR3QW5BNkJUOHNSWFVmNjlSbDB3dzhzQ3VGUzdrNXBOTGxZ?=
 =?utf-8?B?M3FqOXFPbkRadmVUcThOeHFIN3p0SmwrcXU2NlliYjR5dmZDaTVnQkVOd0hF?=
 =?utf-8?B?WHVyK2RsdG5LVWp0Yk1YRXVOVm1PRm5HOG85RE83dmxnUmRoRkR6VTJjUU5F?=
 =?utf-8?B?eXdCU0l0UWhWRFpUUlN0dXNBRzFaaFNqWEt5dU9UUm5ERml0b2Q4d2txeUlI?=
 =?utf-8?B?WG80N2xUQzNWVGIxOTVpSzk0Qk1ValhTMlFXZzBNQ2kvQVpUamtLM2c4Uzgw?=
 =?utf-8?B?VmMveTdsNlBBdE5nVGN2NWJQNE4zakV0YTNrMHB0Mm1QMWZHVUcxNHpEMUwx?=
 =?utf-8?B?NlhpZmp2UTBhTEJESjQxK3lGMEkwMHNRQmFneG02dU96NWtlNmg5WjhZZU9x?=
 =?utf-8?B?Q3ZHa0NxWFQ5M2hOYVFLMFZDSlI2VkNXU1hYemR3b3M2b0QrbnBZWTQwQWE5?=
 =?utf-8?B?dkYrV1J5cDA0bC9PSHpVem5hUThVTHRUanZpcm8vRCtSbkM2VE5QWVl6YUFI?=
 =?utf-8?B?Lzh1UlVkcWdIVzlWeWNGbGovRVZnY2ZTZWV2OUxISTNJNFZsUzFkY1FUUnRz?=
 =?utf-8?B?YXVvWXJRWS9scTV2U0UvU3VsOGdOQlhnY1dER1ZaZmNuVGE0czVZR3d6TXdp?=
 =?utf-8?B?alNHS3RuK085QjZiTmVocUIyUDVIVGtaTmlxZWdZOUVqQXZjQUlweUJ0Z1hF?=
 =?utf-8?B?TStsRS8wYWhqK2tKd2xNcXd6elVXVVVBZ29DaHFGOFBLak1sNXA1RWdzSXQ3?=
 =?utf-8?B?NlB2OUNvUWJwalV2M0laZDRJNnFIa25pbmFoTitlbEFURXp0M1ZxckVReDlQ?=
 =?utf-8?B?Tzk1WWZpRWlidUw2RkFJK3hKZHJxTktNMmVjRi9EbngyYzZkcE9uSDV4Z0hS?=
 =?utf-8?B?dU5MOFB5ZUhUYldnMmhLYWZQcVpuLzR3Q2JKeUlsM3d4SjdmOEQxbHhoZEJG?=
 =?utf-8?B?ckhHeWU2NVZOVjM3OWc1UXAvaVU5Tkg3OVdEbU1wMnA3a3JUMkFkR042akc2?=
 =?utf-8?B?VUtUd2EranhjZ3FweXEzOVhVN2M4ZGdyR0tjekFQUGhScVY5UTRWS2NUUGJv?=
 =?utf-8?B?bEE5KzI4UnBhdXBESkRyWW8xcFV4aGpNTllxQmdUTzVSaDBHZm9DQlF3UkRo?=
 =?utf-8?B?OEVuSUthS3NJNXZrWk5ZK210OHNFV1plZ3pKb2NwbW83TGl2c3hNRUR2cm5O?=
 =?utf-8?B?Zjg2b1FVUXJYc3NUVjdNRXh1WVdveFc5UnY3djM5OUpNaUV1OEhFUGF6MTNV?=
 =?utf-8?B?SDE5QXdybUhZQUlja05jOThlYmpNbGViQk5ZdlM3NG80K24yZjI5YmxUSTlI?=
 =?utf-8?B?cWNnOGVWbW0yOGdnNXVlVUcyM1lBWkNnVVBjVkFsYnpEVlk5MXJJNk5iRDgz?=
 =?utf-8?B?b09UMkJveGY4QUc2T3UwMWNQaXQ3dGQ5TTdDK3ZaelhqNk5wV0Rqak9BR3hW?=
 =?utf-8?B?ZGs4K1BwV0FUMUNNTzdRb0NYOG52OVRBYXdHem1MVWo1djZSa25aSlo5aWlP?=
 =?utf-8?B?azc4b3Y2blk0eDVaRnFKMFUwNFVXdFk0RjVscFBKK0VZQ2pNRzJldHhlMnE1?=
 =?utf-8?B?MndkN1RYeHdsVDkwWmNnYWdqQ0pubDVEenUxOTBZN2pzb3Y1Q3NXeEpJTFBj?=
 =?utf-8?B?a0RHNktiekNHOGF4ZUNvZDJpeEJPOGJoTk14MFBMMFFxZFZIZVpNd3MvWE1Q?=
 =?utf-8?B?ZUFmZkc1aWNSNC9JbzZ3UXZJa3dDditpNFdWdC8zV0k1VFNIbG1zWWRzOGJy?=
 =?utf-8?B?a09kNHZ1SGNqNVgvQWxSazdNaFBTbjI1aldhSlBDWk5rRTNoTzlpZERnWFRp?=
 =?utf-8?B?c1I2SmF5OTV4SjVxTEJNNEx4anp5ejRjcVZaeGs1aWZGNjhvZmoxWWw1RzI1?=
 =?utf-8?B?aGxUK3h0WXVKajNTUFJ5ZjFPTHlJOTF4MHNrL1pYeVdaTWdBUTk4SlFRVzBu?=
 =?utf-8?B?RmNHOGZyQzdIa1BCU1J2TFRxSGYyb1VMTlUyeDV6VlY4VXVIZHpyTXJUUFFs?=
 =?utf-8?B?SC9MMkVtTmZSb0NjYytBUElIMTFqQkI4R3NiTXIxdWs0Z1ppbVVaMC9EdFdQ?=
 =?utf-8?B?K1ZhQXhRdCt6QTlOMGc4R3hLYWYyenFHTm1Db2JrbUt5NEJDcTJYYU0ySW1X?=
 =?utf-8?B?WWt5YkxmTWs0U3A1RHErS2cvaWZaa01sTXBySnArZmNUMzZBY2o3NkxJQmJF?=
 =?utf-8?B?NXBmQUI5bGRXaFRJZHN6N2RwM3RwNDM4NHNydWZ2SCsxMlplOURLajI5UVJq?=
 =?utf-8?Q?5txoS5DxT8bpIFK5cfw0DMUACxiCAp/si4/Am?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC22164F81BD4F46A9F14A4BB18BF72C@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: aa578dea-7d5c-4bd1-89a3-08da53bb71fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 19:22:56.2243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MB0FYDhxdclDhlEgVKfLO12AWgzJJgIsY+6ed0GPOMrj8KN4YuoI1QB7bjH77UTxAD0ccJSzHP4k663QBqpJESn1qv4jeXABxdG84rvREXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAZP264MB2895
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDIxLzA2LzIwMjIgw6AgMjA6NDcsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBIaSBDaHJpc3RvcGhlLA0KPiANCj4gT24gVHVlLCBKdW4gMjEsIDIwMjIgYXQgMDY6MzM6
MTFQTSArMDAwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+IExlIDIxLzA2LzIwMjIgw6Ag
MTY6MDgsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKgOg0KPj4+IFRoZSBwbGF0Zm9ybSdz
IFJORyBtdXN0IGJlIGF2YWlsYWJsZSBiZWZvcmUgcmFuZG9tX2luaXQoKSBpbiBvcmRlciB0byBi
ZQ0KPj4+IHVzZWZ1bCBmb3IgaW5pdGlhbCBzZWVkaW5nLCB3aGljaCBpbiB0dXJuIG1lYW5zIHRo
YXQgaXQgbmVlZHMgdG8gYmUNCj4+PiBjYWxsZWQgZnJvbSBzZXR1cF9hcmNoKCksIHJhdGhlciB0
aGFuIGZyb20gYW4gaW5pdCBjYWxsLiBGb3J0dW5hdGVseSwNCj4+PiBlYWNoIHBsYXRmb3JtIGFs
cmVhZHkgaGFzIGEgc2V0dXBfYXJjaCBmdW5jdGlvbiBwb2ludGVyLCB3aGljaCBtZWFucyB3ZQ0K
Pj4+IGNhbiB3aXJlIGl0IHVwIHRoYXQgd2F5LiBDb21wbGljYXRpbmcgdGhpbmdzLCBob3dldmVy
LCBpcyB0aGF0IFBPV0VSOA0KPj4+IHN5c3RlbXMgbmVlZCBzb21lIHBlci1jcHUgc3RhdGUgYW5k
IGttYWxsb2MsIHdoaWNoIGlzbid0IGF2YWlsYWJsZSBhdA0KPj4+IHRoaXMgc3RhZ2UuIFNvIHdl
IHNwbGl0IHRoaW5ncyB1cCBpbnRvIGFuIGVhcmx5IHBoYXNlIGFuZCBhIGxhdGVyDQo+Pj4gb3Bw
b3J0dW5pc3RpYyBwaGFzZS4gVGhpcyBjb21taXQgYWxzbyByZW1vdmVzIHNvbWUgbm9pc3kgbG9n
IG1lc3NhZ2VzDQo+Pj4gdGhhdCBkb24ndCBhZGQgbXVjaC4NCj4+DQo+PiBSZWdhcmRpbmcgdGhl
IGttYWxsb2MoKSwgSSBoYXZlIG5vdCBsb29rZWQgYXQgaXQgaW4gZGV0YWlscywgYnV0IHVzdWFs
bHkNCj4+IHlvdSBjYW4gdXNlIG1lbWJsb2NrX2FsbG9jKCkgd2hlbiBrbWFsbG9jIGlzIG5vdCBh
dmFpbGFibGUgeWV0Lg0KPiANCj4gVGhhdCBzZWVtcyBhIGJpdCBleGNlc3NpdmUsIGVzcGVjaWFs
bHkgYXMgdGhvc2UgYWxsb2NhdGlvbnMgYXJlIGxvbmcNCj4gbGl2ZWQuIEFuZCB3ZSBkb24ndCBl
dmVuICpuZWVkKiBpdCB0aGF0IGVhcmx5LCBidXQganVzdCBiZWZvcmUNCj4gcmFuZG9tX2luaXQo
KS4gTWljaGFlbCBpcyBydW5uaW5nIHRoaXMgdjUgb24gdGhlIHRlc3QgcmlnIG92ZXJuaWdodCwg
c28NCj4gd2UnbGwgbGVhcm4gaW4gdGhlIEF1c3RyYWxpYW4gbW9ybmluZyB3aGV0aGVyIHRoaXMg
ZmluYWxseSBkaWQgdGhlIHRyaWNrDQo+IChJIGhvcGUpLg0KPiANCg0KVGhlIGZhY3QgdGhhdCB0
aGV5IGFyZSBsb25nIGxpdmVkIG1ha2UgdGhlbSBhIGdvb2QgY2FuZGlkYXRlIGZvciANCm1lbWJs
b2NrX2FsbG9jKCkuDQoNCkJ1dCBmYWlyIGVub3VnaCwgaWYgdGhleSBhcmUgbm90IHJlcXVpcmVk
IHRoYXQgZWFybHkgdGhlbiBqdXN0IGRvIGl0IGxhdGVyLg0KDQpDaHJpc3RvcGhl
