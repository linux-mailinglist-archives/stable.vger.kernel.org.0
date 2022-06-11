Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4486D5475B2
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbiFKOms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiFKOmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:42:47 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120079.outbound.protection.outlook.com [40.107.12.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC85C2B;
        Sat, 11 Jun 2022 07:42:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bF8litMaceDkeybtTNVWl61tQXkHxjGYekieNZEagBM8bn131vKsMdRqonFdDqexWJ5V1sXucExudMKeGXwLsiOEDmQfnrpoFdObdR0j9FIiQ6AuwduywxbPuf/4FO/oiJF9LbdYb9uY7n3hPnfziaAAzxUhEPL9pEAGCHOYpTFR00R+G2Pl6VPJ/gzRKF/Ev7ndFG3WPacqia20zbxguf+44t/oE7me0XAA2jP6RH67RJR6Nr41RrgQM6K1ZGlF12T6VkfJOX+kiNI2EzHMRiWeHD16hGQEfPPU10hfpmpACvj4gNlz0en49ERtFx1vcrQvI+WAzIH2X+jxNPdBYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXVnNQZN85mr/uNwhL4HQlue0t0yzy3lUbY+QmRFml0=;
 b=DYccD6IRQFFsBTKrWCZaNJ2wY/xQZUbYb8YGIKVQISo0KmC91ezhMBBjSaWvaxY/vnmdbBQjbnNfDQNkZqk607AV5jjxDxgmFh2BifsfJvlCPydtRcCwRMV6PUsITB3LjnEtCXyq6UjZzBDP8uoQTR4iZIgDv/0gu2A/VDN7gBYHab8+iVJctTFMqaAU6ZhfrSy+Ggfnl4iZCFWJ86IuGnWk3GZKpkjfETM8fgsFkJr2tIloQh9sCmIhTQ3Qm7/uesEpSmnt3HPaiUqqyfYZZMc6gN6R3X97KaOnak/vL3WwZ3aneUXinf8zuMAjRKfvJOezKiXQJdnwP7sBeQgn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXVnNQZN85mr/uNwhL4HQlue0t0yzy3lUbY+QmRFml0=;
 b=VDnBJ0uLvr7MjqZx0K07L7eqx3Nd5Q0Mjh0s7AxOm7EzLmioxzfktLMxB3t+iXrzcMQVO2EgcWlmr5EE+peF4skIRmHHCO6QHXvA2vgO7vFjmP1AAIv8yXawKfMdU3GhFMqTaPrqyYJQSw3VmmaHg/UHHh4RqSURU+foECXh0tMQjkmqdc/Tqd3CEqcKMy0PpBtUdKMpNgsDCy+nj85yt7GVVTqRGFn91G1E/Qo0CrEmTKJZVNw+A/pL+wrIDMUe8LrdUQAWhTi0BDRjRcd/Pb8/fTC4GwVz4XGXiSX0wnQ8xjusoUharg7j74hn77dpuRwuDPQY0sNJRkJoiAm83A==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3905.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Sat, 11 Jun
 2022 14:42:43 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 14:42:43 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] powerpc/powernv: wire up rng during setup_arch
Thread-Topic: [PATCH v2 2/3] powerpc/powernv: wire up rng during setup_arch
Thread-Index: AQHYfXq+Mlroiln7h0CmiW+G4bs8Dq1KSA8A
Date:   Sat, 11 Jun 2022 14:42:43 +0000
Message-ID: <d310a8cf-79f8-89ed-41fd-ebe0281a67f4@csgroup.eu>
References: <20220611100447.5066-1-Jason@zx2c4.com>
 <20220611100447.5066-3-Jason@zx2c4.com>
In-Reply-To: <20220611100447.5066-3-Jason@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1af45a27-80b7-4dcd-ac38-08da4bb8a4d5
x-ms-traffictypediagnostic: MR1P264MB3905:EE_
x-microsoft-antispam-prvs: <MR1P264MB3905CC984E3E60E35518E507EDA99@MR1P264MB3905.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zsFcqbzmFrAcDU3vnTc6ZrhgMrMIgIYxfSjYY+0nHySCuZDIEMh5XUTPgPK7ZyEdHXyy3GOBitdL62nyVFGAnr8wjmHtofd4vjKVp36Ww85nMqu1JRmO/lB647Tlvwz4ih/Zqe22G/8osff4VlG7Fe2gdPIrKVdzrgndkJl+sLfN1ZH1FVzrYQ3CjuaWN1kjrUuvnhJMUCyNUfM07m1xlvoze2lEstAeUMY6fhWZXpwzjG70iO595KF5F1RDXF1pjUlmFBa+G/Qc14q0AVh9O4avxtDV6WdCCqTI71tevq3dknASilhbrNFO4NWPa7M0CDVV4378wZqi2WNaFYP5W6yi0p9ILXq66Cfd5QqVsexn0TfBvyL06hxfZwAffsvQZvwnWoDo44LOlx0MQ74T4p0sHLvSzEDcpNiKgPJSfuUmVBwB0S3uej0HvCB4KzOsaDDisCZasfsb1X1kRCSSt+VYZqnBo+qGSoefnBss/tWbpTGY5jlBmGZtm0adE7TekwQxu1kT5K1Y8GySHYtwwCV9pqJAoCodXKyWIoREcjvDkuOu+CkE8c4kNPE8XkgtkdU5WWTDEbXUnpUd5WSQaEFJP8WOF2xspXjeIR1cjYARX22X0GMgTKbfDmnW4V4GbFaD6XeFlZMGDTuK5OzaI3Kt/zs/kFX2+/2vPxHkvSZViRtnsxGto0pD9eAV9dExpH4lXtj/aw3pLIhpTepiEsdvGofKwI2CAkFAR6nOeYs4WXVs5BQMifP6MUxqokv7YyEIWKxNSsoO5ir7qoqe+2iskt/3lajUqwTT+Hb0ttE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(4326008)(64756008)(8676002)(76116006)(91956017)(31686004)(44832011)(36756003)(66446008)(66476007)(66556008)(8936002)(316002)(5660300002)(66946007)(71200400001)(6486002)(6506007)(110136005)(2906002)(508600001)(38070700005)(6512007)(26005)(122000001)(38100700002)(66574015)(186003)(86362001)(2616005)(83380400001)(31696002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a21NNUYxNUlDMVZGUXNZVnMzQzNzeFhIVkNSU0R1NTk2K1hnM2VZOEExa25N?=
 =?utf-8?B?Mk9JK0toQjg5QTlWR1Y1Y0hXcU9rRjl2YkllUTBHN3ovSVY2RUZCbFFXWGFJ?=
 =?utf-8?B?L3E1QkJxUGNDRmhCejRqN3c2VXlncW56V0tqc1d0cnFyZU9SUWIzekFoUDJV?=
 =?utf-8?B?YWZZQUcvdVdIK2RaYnNoNjIwSGloaUF6TDUwU1cvd281b3AzdDc4QTdwbWx2?=
 =?utf-8?B?K0hONmZlUlJLYmRvMGNlQzAzSmFqczBzTUI2ZmZXMDdqVy9XQzUvTlJrZDh6?=
 =?utf-8?B?UGZEWWg2M3I0WDJURFlGQW5BOW4yYTRGQUpyNURDTTUzVENwVzVEcTdTUzVh?=
 =?utf-8?B?bFVNMENNQ0NKQjhFUGozM29oa3VmNzNCUjkyZWU0a1hNOXdwVnRIamlnRWU3?=
 =?utf-8?B?UnlSdHZJVU1nS0k5cDFCaTE0SzZTWHRXaTEzVTRsVll1bmE4NnQyT3NnM2x0?=
 =?utf-8?B?MzBuQU9pVnlIaXlTOXdBWlRYU2ZibWJaMlZRVEJqak9uSThJNUtVbU5yMkxE?=
 =?utf-8?B?WUJGK3I1RnVscmRKQUN1eHgxTzBSUWZvb0dKZFZSQWpwTVRxMmtJUStidlMw?=
 =?utf-8?B?VkdSbTdYWG9QYkg1MFdZdDZuSnV2b3lwbmhEWmFxZEQ3UHNRVjJLcXNUb0p3?=
 =?utf-8?B?dXh2S2Njd2VRU2xNMi9zRmFiRnBaRjB6WkVYZXRPSm0zaHZzSk1ZREd0alJh?=
 =?utf-8?B?aHo4OE9aN3FXVmxaTFJSVXp6RHdpY29nSTJ0TWFnVXdqMGtXL2dIZ2RScW5a?=
 =?utf-8?B?ZmsxOTYxcmtqRjVPTU92OVhvTDN6U21ROXc0L1A4SUI0L3lXcy9BM3VqS1E1?=
 =?utf-8?B?cDhrZXcza1ZpQSsyWjRxemwzbVZ0b3NZb3VwY2EweXNwLzQrK3hrODQzS0VJ?=
 =?utf-8?B?TnZwVDBpcGxKWWJadnBZdmhOL0hvQ3FaNUxjL0NJaU0zRVFpbit3MXNiNEcv?=
 =?utf-8?B?cEg3YXhPdmVoclVEWnR3eS9ZM2VzTERhRDBaOGFnOFdoZWNHK2FCRm1NUFBz?=
 =?utf-8?B?VEg5NHhVb2VhVVFCaWhKTmV5RkY1cExUOHpIRC9uRDdFYzB5alM4bVV2WG1s?=
 =?utf-8?B?anUrdWtZTE9QbWl4WVA5NldUU3lnY1ZlUkgwYmxER3k4em41TlJNV2NBVW9N?=
 =?utf-8?B?bkdPQlcvNitBbjcxOE5HK1hZSWlyWXZNZXRWTUVYaGhLN1FJeCt2NEN6OUFz?=
 =?utf-8?B?MC9rckdnSFYvY1BjUkovKzFhTnhqRy9GQWsrbHVUekNlNXFCalhUbWdXSmtz?=
 =?utf-8?B?QlRPcTVnWmp3SkRsTGJVTXpuTGdoWmtRRDhTeXpmUFFkS1MyRnNXS2w0ejgz?=
 =?utf-8?B?RW56QlEyR1gyb29heVRCSHRjUkNiZDlZZWxZZDVMTFNTaUIvVVFhUHZYTUY3?=
 =?utf-8?B?SjVKUmF0ajAySVhNSUZUYkxTZXBOZ29HZFRnZUwzWTFXZFRucGVjWnA4VExH?=
 =?utf-8?B?T3haTUREczczdDV1SXVxdGExa3RVUHlJdVhrQzBxRm1yMmZtemlrRThRdnE4?=
 =?utf-8?B?ZndGZlQvamlvWTY5bVI4Ky9udktZZ0MvUE1xT2Vvajk4bFdUbjdzc25kV1N2?=
 =?utf-8?B?WCtBR2lqWUluQkxoUk9rMGc0NXdmSGNZd3Z0Y2J0cW9kZDhpcjFVdTh5ZDJr?=
 =?utf-8?B?YUxpTlJMTnJRTkZZYTRBZjJ6WmhIUFgxNUxVZTFCUEFkelBMTnNGN0pNRHk5?=
 =?utf-8?B?ZDhMTE1hNHBqSmhvc2lhZ0xMNUJzUnVVUFlZS21la2FQYkgwYzFxdjcxdFMy?=
 =?utf-8?B?cWdWVVlHV3FhWnR6bWVRL0QvMjNmcTBRTmRHUVBCa3JHeTZHWkdBdjBoOFpJ?=
 =?utf-8?B?NmtTYjJveHArMU8xVU9VUXBkMmVobWtOcitCRDZ6Q0Q3Y3cyd1U5OVJZQ2lK?=
 =?utf-8?B?RmkxcjBCRjBnYjJvTXpkSitQRDl3SUNCL1FUWE1BRTl3a05HdXo4UW9QRGoy?=
 =?utf-8?B?YzNsZVF4OXQzQ3VKVUxyV3pRKzFPT3BMYXZFL3FzeWZoVkRKRldLOUhGU0JJ?=
 =?utf-8?B?MmZiTHlJTlFFb3dLL2JzcXYvNWI3VFovS3d5TzdsUFNEdkR6WHZUdmRnK0g5?=
 =?utf-8?B?THlXbE1FbzdhR1l2RnQya3RqNkFHY0JSTmFXZlVMTE9UcU1ab0RFYVVva2ZP?=
 =?utf-8?B?aVVPa0l3MnRFbTFTUlE4djRrQ2EvQkxReVRLcGlTZXR4TnJJVSt4TC9zR3lW?=
 =?utf-8?B?Y3IvdERRVE9INjhYNUNmQ0RyMERjallLdktBdExVRktBK0FIbjB1VVU3MCtT?=
 =?utf-8?B?K0VRQnd6SDNmbFdNc0dMNXVvbjEwR0gzQ3hqRVRpQ0YyRHF5dm5kd0lVdkMx?=
 =?utf-8?B?YjRWaVlDeFVLb05Oa0Q3RUZBZi82bmo2TERrcFE4dTJ0QXFWcUNud082K3JH?=
 =?utf-8?Q?CYp2OCVIoJnOpYWLbQ0H+KYUhzR10QnJD8MzU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90B90F2C19CEC5438283600B35709B81@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af45a27-80b7-4dcd-ac38-08da4bb8a4d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 14:42:43.7723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zMTTE35Y/fHGbvPk1oxl9C7McyZm/5UrzwuyhI7EdsLmgQHPTspQeNQA1aWOCRdudeZFQfz0mOBnT790jZKhjWGaZ8DsR36WwZFR82Hy5pE=
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
Y3Nncm91cC5ldT4NCj4gRml4ZXM6IGE0ZGEwZDUwYjJhMCAoInBvd2VycGM6IEltcGxlbWVudCBh
cmNoX2dldF9yYW5kb21fbG9uZy9pbnQoKSBmb3IgcG93ZXJudiIpDQo+IFNpZ25lZC1vZmYtYnk6
IEphc29uIEEuIERvbmVuZmVsZCA8SmFzb25AengyYzQuY29tPg0KPiAtLS0NCj4gICBhcmNoL3Bv
d2VycGMvcGxhdGZvcm1zL3Bvd2VybnYvcm5nLmMgICB8IDE3ICsrKystLS0tLS0tLS0tLS0tDQo+
ICAgYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wb3dlcm52L3NldHVwLmMgfCAgNCArKysrDQo+ICAg
MiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcG93ZXJudi9ybmcuYyBiL2FyY2gv
cG93ZXJwYy9wbGF0Zm9ybXMvcG93ZXJudi9ybmcuYw0KPiBpbmRleCBlM2Q0NGIzNmFlOTguLmVm
MjRlNzJhMWI2OSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wb3dlcm52
L3JuZy5jDQo+ICsrKyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcG93ZXJudi9ybmcuYw0KPiBA
QCAtODQsMjQgKzg0LDIwIEBAIHN0YXRpYyBpbnQgcG93ZXJudl9nZXRfcmFuZG9tX2Rhcm4odW5z
aWduZWQgbG9uZyAqdikNCj4gICAJcmV0dXJuIDE7DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGljIGlu
dCBfX2luaXQgaW5pdGlhbGlzZV9kYXJuKHZvaWQpDQo+ICtzdGF0aWMgdm9pZCBfX2luaXQgaW5p
dGlhbGlzZV9kYXJuKHZvaWQpDQo+ICAgew0KPiAgIAl1bnNpZ25lZCBsb25nIHZhbDsNCj4gICAJ
aW50IGk7DQo+ICAgDQo+ICAgCWlmICghY3B1X2hhc19mZWF0dXJlKENQVV9GVFJfQVJDSF8zMDAp
KQ0KPiAtCQlyZXR1cm4gLUVOT0RFVjsNCj4gKwkJcmV0dXJuOw0KPiAgIA0KPiAgIAlmb3IgKGkg
PSAwOyBpIDwgMTA7IGkrKykgew0KPiAgIAkJaWYgKHBvd2VybnZfZ2V0X3JhbmRvbV9kYXJuKCZ2
YWwpKSB7DQo+ICAgCQkJcHBjX21kLmdldF9yYW5kb21fc2VlZCA9IHBvd2VybnZfZ2V0X3JhbmRv
bV9kYXJuOw0KPiAtCQkJcmV0dXJuIDA7DQo+ICsJCQlyZXR1cm47DQo+ICAgCQl9DQo+ICAgCX0N
Cj4gLQ0KPiAtCXByX3dhcm4oIlVuYWJsZSB0byB1c2UgREFSTiBmb3IgZ2V0X3JhbmRvbV9zZWVk
KClcbiIpOw0KPiAtDQo+IC0JcmV0dXJuIC1FSU87DQo+ICAgfQ0KPiAgIA0KPiAgIGludCBwb3dl
cm52X2dldF9yYW5kb21fbG9uZyh1bnNpZ25lZCBsb25nICp2KQ0KPiBAQCAtMTYzLDE0ICsxNTks
MTIgQEAgc3RhdGljIF9faW5pdCBpbnQgcm5nX2NyZWF0ZShzdHJ1Y3QgZGV2aWNlX25vZGUgKmRu
KQ0KPiAgIA0KPiAgIAlybmdfaW5pdF9wZXJfY3B1KHJuZywgZG4pOw0KPiAgIA0KPiAtCXByX2lu
Zm9fb25jZSgiUmVnaXN0ZXJpbmcgYXJjaCByYW5kb20gaG9vay5cbiIpOw0KPiAtDQo+ICAgCXBw
Y19tZC5nZXRfcmFuZG9tX3NlZWQgPSBwb3dlcm52X2dldF9yYW5kb21fbG9uZzsNCj4gICANCj4g
ICAJcmV0dXJuIDA7DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGljIF9faW5pdCBpbnQgcm5nX2luaXQo
dm9pZCkNCj4gK19faW5pdCB2b2lkIHBvd2VybnZfcm5nX2luaXQodm9pZCkNCj4gICB7DQo+ICAg
CXN0cnVjdCBkZXZpY2Vfbm9kZSAqZG47DQo+ICAgCWludCByYzsNCj4gQEAgLTE4OCw3ICsxODIs
NCBAQCBzdGF0aWMgX19pbml0IGludCBybmdfaW5pdCh2b2lkKQ0KPiAgIAl9DQo+ICAgDQo+ICAg
CWluaXRpYWxpc2VfZGFybigpOw0KPiAtDQo+IC0JcmV0dXJuIDA7DQo+ICAgfQ0KPiAtbWFjaGlu
ZV9zdWJzeXNfaW5pdGNhbGwocG93ZXJudiwgcm5nX2luaXQpOw0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC9wb3dlcnBjL3BsYXRmb3Jtcy9wb3dlcm52L3NldHVwLmMgYi9hcmNoL3Bvd2VycGMvcGxhdGZv
cm1zL3Bvd2VybnYvc2V0dXAuYw0KPiBpbmRleCA4MjRjM2FkN2EwZmEuLmEwYzUyMTdiYzVjMCAx
MDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wb3dlcm52L3NldHVwLmMNCj4g
KysrIGIvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wb3dlcm52L3NldHVwLmMNCj4gQEAgLTE4NCw2
ICsxODQsOCBAQCBzdGF0aWMgdm9pZCBfX2luaXQgcG52X2NoZWNrX2d1YXJkZWRfY29yZXModm9p
ZCkNCj4gICAJfQ0KPiAgIH0NCj4gICANCj4gK19faW5pdCB2b2lkIHBvd2VybnZfcm5nX2luaXQo
dm9pZCk7DQo+ICsNCg0KU2FtZSBoZXJlLCB0aGUgcHJvdG90eXBlIHNob3VsZCBnbyBpbiBhIGhl
YWRlciBmaWxlLiwgc2hvdWxkIGJlICd2b2lkIA0KX19pbml0JyAoYW5kIGluZGVlZCB0aGUgX19p
bml0IGlzIHBvaW50bGVzcyBpbiB0aGUgcHJvdG90eXBlLCBvbmx5IA0KbWF0dGVycyBpbiB0aGUg
ZnVuY3Rpb24gZGVmaW5pdGlvbikuDQoNCk1heWJlIHRoZSBuYW1lIHNob3VsZCBiZSBwbnZfcm5n
X2luaXQoKSBsaWtlIHRoZSBzZXR1cCBhcmNoIGJlbG93Lg0KDQo+ICAgc3RhdGljIHZvaWQgX19p
bml0IHBudl9zZXR1cF9hcmNoKHZvaWQpDQo+ICAgew0KPiAgIAlzZXRfYXJjaF9wYW5pY190aW1l
b3V0KDEwLCBBUkNIX1BBTklDX1RJTUVPVVQpOw0KPiBAQCAtMjAzLDYgKzIwNSw4IEBAIHN0YXRp
YyB2b2lkIF9faW5pdCBwbnZfc2V0dXBfYXJjaCh2b2lkKQ0KPiAgIAlwbnZfY2hlY2tfZ3VhcmRl
ZF9jb3JlcygpOw0KPiAgIA0KPiAgIAkvKiBYWFggUE1DUyAqLw0KPiArDQo+ICsJcG93ZXJudl9y
bmdfaW5pdCgpOw0KPiAgIH0NCj4gICANCj4gICBzdGF0aWMgdm9pZCBfX2luaXQgcG52X2luaXQo
dm9pZCk=
