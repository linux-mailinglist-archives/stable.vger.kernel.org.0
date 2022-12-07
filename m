Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A361F645EE3
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 17:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiLGQ2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 11:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiLGQ1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 11:27:36 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2044.outbound.protection.outlook.com [40.107.12.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C360A69338;
        Wed,  7 Dec 2022 08:26:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdtUyXqVREM6ga5z7reHuTTZhc7R98vT2tW0RcF2wG5FIkrvm1XIuvAD1r5GTLKtrvwvQwyxGHWI1Z65g0vJrDS62o4AamOW9b5vVBc41bzROUegausovCBaf1l0aMZherIvnMVVNS4KjDoarKeRngQryyfNOY/Bp4QxqlMiWWH6bPbbY9nx+1HUFXSdrVdY3OOnqTmiW3K6/E7c12PdYTxTiNcnW9it/sLOlgWAuAbyj7IucaHlSg8h8zkQ7TtmdXEqp4qEw8p4Jbn0C5v2DVPFlHxvSCS4V9iAlqg2b4tz7Ha1kphjeK2dpxO4sDd8MEM7WGqIypYTDtEPf4IoPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOcgG/OaNBRN6kTu9bq77YnY7CApM3DGBdU9iIZIQmk=;
 b=KTDxVflVgwuXxucRjACxMYHRVgBTFb0CQfq+N9PA5oTUQirvsMc273XNwCg6Y6xb6RodiB2pOPbaMz2zWxgIBEzhxzcn4b22sWdxYkFp0rGi5LQ3VlI6gOnzD3T/13+aK1M/TH8vLVrnGhXTkeZF5pEAQSsZwX4Io1vVLwu6b1+FRkdkqP0aOm2GR52I5mg6vlBQJaoFzgnxEmKuoDNzk0+egX1jQtvTfmUIWMHtGp89Qfy0aQWi0OC5GP5w+Pffo9RuCl+1b03iBCf9afOysxHifTgmlruKq4DgpwGbJDJXQToR49/oM9wfTw28KA9T321qpcaQbL2fKb6JY1FUMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOcgG/OaNBRN6kTu9bq77YnY7CApM3DGBdU9iIZIQmk=;
 b=i+nIGM9RgAwlnkQK3hRsF+KnJeQgJDBCEvJvkki3It+SJZtghs5LO8i9a6OrIgbKihvIWPTTt9DqCc/Rdr1153M76BonUSi5wGpF0xguJZcq4mBrVEyTapr4YtigP2uGyoZQ9YsM+VKgsPWWqIU4k7JTawQt1E0jRJFzEuor+kAfuOJBWrgZR2j3rTi/YbeXyL8+/1CGGC9vNnaYkqwOfVFzHDVfBp9J8OCem+/msNfP8x033T8ZEhJB0z2RLNNBsKll145gOVQkvmoCwKu/yJSR4Wo3jwqI35SAC9ow6bcqiQiw2xZZn88yXh5zj8GBTUQpJ30NEfeoy/dnNzyYkw==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB2987.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:30::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 16:26:54 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::a85b:a9b6:cb36:fa6]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::a85b:a9b6:cb36:fa6%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 16:26:54 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Jeanson <mjeanson@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Thread-Topic: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Thread-Index: AQHZBaANAqqRYC4fWEmzGmz7Z31vrK5ey1WAgADVqwCAAApsAIAAFL6AgAAamACAABHWAIABCOKAgADBCYCAANx7gIAAEzEA
Date:   Wed, 7 Dec 2022 16:26:54 +0000
Message-ID: <61d98db6-68b3-1a5c-f59b-592048c742fd@csgroup.eu>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
 <87pmcys9ae.fsf@mpe.ellerman.id.au>
 <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
 <219580de-7473-f142-5ef2-1ed40e41d13d@csgroup.eu>
 <323f83c7-38fe-8a12-d77a-0a7249aad316@efficios.com>
 <dfe0b9ba-828d-e1a5-f9a3-416c6b5b1cf3@efficios.com>
 <87mt81sbxb.fsf@mpe.ellerman.id.au>
 <484763aa-e77b-b599-4786-ef4cdf16d7bd@efficios.com>
 <87cz8wrmm6.fsf@mpe.ellerman.id.au>
 <6db50470-ac37-0328-37a2-760665668b5f@efficios.com>
In-Reply-To: <6db50470-ac37-0328-37a2-760665668b5f@efficios.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MRZP264MB2987:EE_
x-ms-office365-filtering-correlation-id: 2310b6c3-abb2-4283-d492-08dad86fda40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TSE0kGDUhVca6BzTG6odCWyP+J3Oq8fTU7HwVLkM+4rZ1waizbcI3q2wK9JNvnzdlsnCyZ7Cd8KPT3r2X3CXY+dwLQef8D1FVU7mDR1elnZOJ8YGkokeMgQog0rMpeKZKjRNdyCdgrCYt/S2zxG5p4lWUP6xYardW3s0km7vv/NVk71BGDVLHxWedAynbQWeNF0hVR8jTvEuMgHI1/3vM3PTPTE3uQLNW8q8846CF2mKBF+KEtZXZx906sQ/k4L4f5xBY1cUdkz0lzdWn9+WA8tcfogeqS/pEyiS6SvZBjUD/iPPFc9tLvOs2rCJR8n4UKfTbqLUG7XQKQvUCTiLcTZApBIZXdPcjynwhGbXBQDPf3DHD4gfcL/052hRe8SWlAZ7esYSVkUovTb88t1FGjsRapUrlt71vN2ganrW4o3gTgt0f31UG5xN8fmfslpRJ0yq6tiufZE/YZUDOfmaXNiiVSPdw/Dh1A3X0a/CSuSuydhc3xLasSFWIgcmXZ54mMmwQVwKu1qNR5YZ1eqbIyBG9Pnakvq1RB6M2H6E/I8QPB0ydjFMzP/KMCzCLfH/w7i8EG6N+tR+YjiUz4sNLPtpBcWk6xRLS+a4qC7Gv7PctIUGriMlpagMy409nTeEuKJZ7/l2yEeE5cBr47d89raBMyWb0+zNMa8mRVu58RXLeVqn2+CudTOyjGwPgkMdoYYCdeL0TlPxA+EDGKsL2+UwRxPlRlZRwuoA5Vb5oAHnbW+PwiieYqksBnfKAB3EKas+5sxOQjbB6M5bFiQZkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199015)(31686004)(38100700002)(83380400001)(38070700005)(478600001)(6486002)(44832011)(2906002)(8936002)(5660300002)(7416002)(53546011)(36756003)(31696002)(4744005)(186003)(71200400001)(66946007)(66446008)(66556008)(66476007)(64756008)(76116006)(6506007)(91956017)(8676002)(122000001)(4326008)(110136005)(54906003)(86362001)(2616005)(316002)(6512007)(41300700001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUMzYytxRm05N3MzdTNrU2syTlRSem9Mdmljd2U0TmU3TWdvSTFtOHRzMVlF?=
 =?utf-8?B?YTlDc2F2ZUpDMCtiNnJiU2hLUGJza2JqSmJVT0lIb2FlUnE4WE1MMTRWaDFT?=
 =?utf-8?B?T2ZnR0tPckQzTUtVNlBHc21HbmIyK2NEWFZYb3BlVkZYZ0syam1qY3ROaUti?=
 =?utf-8?B?K3VuR2Q3SktuMzlFa3FTTDU5UjUrSEErdFJ6Ykt4OTVIdm5DZ0RYQ1ZSWVY5?=
 =?utf-8?B?RGJDQXh2cjJ1NWltV0R6REVLTHh6WmRzaThCUEhpVnpPRys4SUxlSnBvSklI?=
 =?utf-8?B?TVpRbzRQaHhkZWpOOVZoejBMOUNNbDl4RnBGQy9LRk81aFd6SEtHRlNPT3V4?=
 =?utf-8?B?TU1iNGZFaFNQZVRnU1BOTkRvZ1J0NkFDV3NlQXNDc21UNnpsTlBUQUVSeHBa?=
 =?utf-8?B?V0RxQUIwSmNObnJnM3g0ZlRwL1lOMC9jNVMvd1dnSG0xd1FDaXY4eGVZYVQ5?=
 =?utf-8?B?WFZJeW5UUVhrTFFXY04xSDZwcllwbUl4ckswZzZlZ3M1dlAzQVNxcXlCSXdx?=
 =?utf-8?B?VjJhSDhnSmZ5RUl2S2kwQWNLTkZKU3pyTkQwSzUxUWFhN0d6WDROaVRxdTRM?=
 =?utf-8?B?SWtiWW5oUlRvZmFQQ3h5TldzcGVhSEUrenJqeDN0UmZsSTRqYW5ET3pOQ09W?=
 =?utf-8?B?QXJ6Vm9lUk1DeVdsbFV6emxZMmRESjBzcThtTXorNnNTMkhkOXB3OEgvOXFp?=
 =?utf-8?B?NzNveGNpNFRsbEFWNnhxTGU5ajdITEtoSDlveDUyU2lhNmZKYzFYNXZ3TVht?=
 =?utf-8?B?RDdQdG1Xa1BVUWZkTGdOamhSbWhsSjV2cGE3OUZ4ZUdienprWG5MRGFEMldL?=
 =?utf-8?B?NitlZE1Dd3liMmRpdjU2SkdBbkZjQkJNSGI1d002dmJTdG1iZlpYOEhiRzJj?=
 =?utf-8?B?enRHRlBwZHlJSW40a2tZQW1KanlsdzNmTFpKNzhHTXF3VFArbVZTVVVqT3dl?=
 =?utf-8?B?TGNTcjBxa2grRmpiQ3dLTXdqSU55Y3k4N1BXRDVYZ05DSTlFRlR1YmtSNklB?=
 =?utf-8?B?MnRZZEoyWUQxd0E0S1BHV0VpTTJaZ1FRSjRvbHhrQkxZQUVzQVhudFBRMzBD?=
 =?utf-8?B?T0RtdUtoekNtd0RMbUNXa0hoWUwza2FDampLSm5YWTV2WWZLczRzMnh5WExG?=
 =?utf-8?B?dEtGU1pmeXF1L092elF1ZjNpK0hnOVFaZC9VZ2p0MHl5YVhBbUk2dDJ2cmh2?=
 =?utf-8?B?N3QyNmcvbWRVSVIrZ3NzczZmeTFhY09VbTM4Z2xjcFVaRUtMMy80bmpVMWRl?=
 =?utf-8?B?ZmRCUlB3U1FjMURMMTRiUTlkb3JYVThwVXIxRUJMeTc4Y3lEMjNSbHF5cHQx?=
 =?utf-8?B?RkJYU1J5Y1ZUbkxmRzdqSmxMNnhSQytDcE1mUEliZ0dYa3NEUzRXWWsyNkx0?=
 =?utf-8?B?WVY2SThLWEQ2RGUxSGdwcjArWlBZdUdDcmZGVkxGTUtqcVhaMFRNcUhJVlpn?=
 =?utf-8?B?T0svcG0zb25UQ1dJQ1U4ak5EU3JPc2xHb2dtVFk5K0xLSzR0dXp0VU1yekp0?=
 =?utf-8?B?ZHB1SVdyU1l2V0plazRJREo4TFROSVFhWEhULzRxUGZOMFgrUTBtYXlTYnJv?=
 =?utf-8?B?VUNwUG5IbmlFUmcwUGZOblFIbUNyeFlPZjB4REcyTlNIS0tuU2dEaHBKMHor?=
 =?utf-8?B?U21vaGc5R3E1MUVtRmdhR1kxS3NHTXh3a1BhQVBWVVFmSmRhQ05sTHZFVzNT?=
 =?utf-8?B?MmZwWXN2T1phanNWc1crOFcwMlJlWWdyb3hZejZEM3kwamxBS3ExdGo4UHp1?=
 =?utf-8?B?dmg1enN2d29HaytkRW0rZ281M1Exd0NvVDNma1BQQWtRb2U4ZjdOOEVLN2lL?=
 =?utf-8?B?c2FDMWswN1BGNVVncWVKZkJkVEs4ZWJzb3FPOHI1LzE3OG0vQWY0eWV1aGpT?=
 =?utf-8?B?cUd2OEc4WEZuNFE4bTRSWU1KL0p5SkpOZzJtTE5OWDFKT3dsdnVDSkRLOWFn?=
 =?utf-8?B?UytVdHBKMFJQa3E5czkzcE1NenNhZ05OdTBRUm8ySVJLUEdIdjUzQTY4UE5O?=
 =?utf-8?B?M2tIMzFmeG4wRFRNSjZoSkVKOEVQa21laWdCZmdHZDMvRlcyM0tQTmt3ZVVv?=
 =?utf-8?B?SmwvT2U0eThxSjhuSnN3YWRDSjkzd2ZRV2xvQ3Rheit4V3JsVCtnakhTV3Zr?=
 =?utf-8?B?U3B4Zk5ONi9LZGEyM2tmQTlHQmpOL3ZxZytuMlJYaHJmMjNVQTQyeW1La1Y4?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <211A2B86C1ACD0438AB2605F15B6E781@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2310b6c3-abb2-4283-d492-08dad86fda40
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 16:26:54.0685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJOQ6v+YRlbFr5qzsmXhZcbwRBYdsjv+KAUcAlmoJWA9+hK42LYTbmTeg934Bv0GX2nkfjVg+RgJ664V2tptd0R6m0XZEXxsM0FxMsm2cOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB2987
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDA3LzEyLzIwMjIgw6AgMTY6MTgsIE1hdGhpZXUgRGVzbm95ZXJzIGEgw6ljcml0wqA6
DQo+IE9uIDIwMjItMTItMDYgMjE6MDksIE1pY2hhZWwgRWxsZXJtYW4gd3JvdGU6DQo+PiBNYXRo
aWV1IERlc25veWVycyA8bWF0aGlldS5kZXNub3llcnNAZWZmaWNpb3MuY29tPiB3cml0ZXM6DQo+
Pj4gT24gMjAyMi0xMi0wNSAxNzo1MCwgTWljaGFlbCBFbGxlcm1hbiB3cm90ZToNCj4+PiBJTUhP
IHRoZSBzZWNvbmQgb3B0aW9uIHdvdWxkIGJlIGJldHRlciBiZWNhdXNlIGl0IGRvZXMgbm90IGlu
Y3JlYXNlIHRoZQ0KPj4+IGtlcm5lbCBpbWFnZSBzaXplIGFzIG11Y2ggYXMgS0FMTFNZTVNfQUxM
Lg0KPj4NCj4+IFllcyBJIGFncmVlLg0KPj4NCj4+IEV2ZW4gaWYgdGhhdCBkaWQgYnJlYWsgc29t
ZXRoaW5nLCBhbnkgYnJlYWthZ2Ugd291bGQgYmUgbGltaXRlZCB0bw0KPj4gYXJjaGVzIHdoaWNo
IHVzZXMgZnVuY3Rpb24gZGVzY3JpcHRvcnMsIHdoaWNoIGFyZSBub3cgYWxsIHJhcmUuDQo+IA0K
PiBZZXMsIGl0IHdvdWxkIG9ubHkgaW1wYWN0IHRob3NlIGFyY2hlcyB1c2luZyBmdW5jdGlvbiBk
ZXNjcmlwdG9ycywgd2hpY2ggDQo+IGFyZSBicm9rZW4gdG9kYXkgd2l0aCByZXNwZWN0IHRvIHN5
c3RlbSBjYWxsIHRyYWNpbmcuIEFyZSB5b3UgYXdhcmUgb2YgDQo+IG90aGVyIGFyY2hpdGVjdHVy
ZXMgb3RoZXIgdGhhbiBQUEM2NCBFTEYgQUJJIHYxIHN1cHBvcnRlZCBieSB0aGUgTGludXggDQo+
IGtlcm5lbCB0aGF0IHVzZSBmdW5jdGlvbiBkZXNjcmlwdG9ycyA/DQoNCiQgZ2l0IGdyZXAgInNl
bGVjdCBIQVZFX0ZVTkNUSU9OX0RFU0NSSVBUT1JTIiBhcmNoLw0KYXJjaC9pYTY0L0tjb25maWc6
ICAgICAgc2VsZWN0IEhBVkVfRlVOQ1RJT05fREVTQ1JJUFRPUlMNCmFyY2gvcGFyaXNjL0tjb25m
aWc6ICAgIHNlbGVjdCBIQVZFX0ZVTkNUSU9OX0RFU0NSSVBUT1JTIGlmIDY0QklUDQphcmNoL3Bv
d2VycGMvS2NvbmZpZzogICBzZWxlY3QgSEFWRV9GVU5DVElPTl9ERVNDUklQVE9SUyAgICAgICAg
aWYgDQpQUEM2NF9FTEZfQUJJX1YxDQoNCg0KQ2hyaXN0b3BoZQ0K
