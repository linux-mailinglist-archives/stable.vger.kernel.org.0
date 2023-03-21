Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D961F6C3048
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCULYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjCULYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:24:01 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E474CDE2;
        Tue, 21 Mar 2023 04:23:43 -0700 (PDT)
X-UUID: d21d162cc7da11eda9a90f0bb45854f4-20230321
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Fww/5nJ3s/Mn6LOrzLIo1wn+JCkU+Ud2l29Sidq+as0=;
        b=VRRIX2tmRRdZPYrN2YUpo1awG7wgaNCFSwSiNdQLR4VZKl9rF/Cvk829Ux+IoF7HNRGoPfbyd0/vVkoh+KugaqHfh10NgZVRL+i2JJ1INbWGjULsiVxzvCgqGLlmoRgb+ZM1bP4IJMUFMz9/6hAW0fGfX91k4fqbHSoOh28Tj/Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:3ba3199f-67e5-4f99-913d-53ab03964893,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:120426c,CLOUDID:0dc6e8b3-beed-4dfc-bd9c-e1b22fa6ccc4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-UUID: d21d162cc7da11eda9a90f0bb45854f4-20230321
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
        (envelope-from <tze-nan.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1010644218; Tue, 21 Mar 2023 19:23:36 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 21 Mar 2023 19:23:34 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Tue, 21 Mar 2023 19:23:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWCeCPHKqf73hS1/i+UmwIKyuQ4Pcfnoc9VOUcKdtFX8LmrdUOBgxX14+GerAmc9h9NnQ41pcRZYjUXjiSaKHonE/FrRc+y2UF5SZhienlqi/NhZOhkjKoPn6ixUS4xLvRDAZZWb5COzwzbZ5dgAFZW40bt4+kJM/oa/ooGQ0VrwuwkTV1bvcFgGPjVpxMGc8/zcoTfUc9psK/w8iUmFq8ZEePfJqVYrkwajjPvGQ05fpyvhp8r5HkvxKQ57/tfPq89tuvWFad7r7kdvY7xgBoVS3m5Cu/NNmJBnUM1sJyiupBIyZ+c//CjXToGvWDRMA30FM9AN6f2MUbw7qdOvmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fww/5nJ3s/Mn6LOrzLIo1wn+JCkU+Ud2l29Sidq+as0=;
 b=UjPNAtOTMfvxfnDPSuI3oITqMkERdk34fHfYDNeOoYhCOKHnJF/pCSDTF27ZJ9eJnokSl5KNCGOlu7x7It+Am1w6zd5/dd978MsMj2K9s08p98byzOzNZ3IzkHky7qSoGIMqEtwCf95phK8bm5BdzTFXuJ7TcMiHRfejdQ0OHo+6+K/S3AtcR+bvPOL2j7J6vLfeOAuMBPlX1ZIIQMYw6ZPk732whCQYw96Xwi9hPj9n86bAPW80eIw4EWZTIbi8jzzGDz4ZhCs7grr8mqCnna3uG9ihhUXHVHyTmJMigSB9r0E1xlMPltNLWdC58FU8yJIiNBJ0orB+ypA1kQ5ITA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fww/5nJ3s/Mn6LOrzLIo1wn+JCkU+Ud2l29Sidq+as0=;
 b=h54eH2CEdCQmUXHTp/mVb9zWxnrbmLBrp7UrBgCLJFwBaVUGYJwHQy/mHLCOd9NdsQRWXUG/Yplh88bJCQ8a0W7LVGYLK7UOLH3xrCfeS29K9y2Yx/3NvPLj0lnLtCqkplxO2T+YTMmv3A7EdV9hHEPG63wfjqx/qm3BpUp3gVI=
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com (2603:1096:400:33a::11)
 by TYUPR03MB7088.apcprd03.prod.outlook.com (2603:1096:400:355::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:23:32 +0000
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::a334:8b07:f1a9:99d3]) by TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::a334:8b07:f1a9:99d3%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:23:32 +0000
From:   =?utf-8?B?VHplLW5hbiBXdSAo5ZCz5r6k5Y2XKQ==?= 
        <Tze-nan.Wu@mediatek.com>
To:     =?utf-8?B?Q2hlbmctSnVpIFdhbmcgKOeOi+ato+edvyk=?= 
        <Cheng-Jui.Wang@mediatek.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "zanussi@kernel.org" <zanussi@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        =?utf-8?B?Qm9idWxlIENoYW5nICjlvLXlvJjnvqkp?= 
        <bobule.chang@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH] tracing: Fix use-after-free and double-free on last_cmd
Thread-Topic: [PATCH] tracing: Fix use-after-free and double-free on last_cmd
Thread-Index: AQHZWJGzSG3WGoP58UCw7mn23f1plK8A37WAgAQ+SAA=
Date:   Tue, 21 Mar 2023 11:23:32 +0000
Message-ID: <aec9e115ab4302711625387b3116c7fd1d326f3d.camel@mediatek.com>
References: <20230317053044.13828-1-cheng-jui.wang@mediatek.com>
         <20230318143533.1890d9bc@rorschach.local.home>
In-Reply-To: <20230318143533.1890d9bc@rorschach.local.home>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB7183:EE_|TYUPR03MB7088:EE_
x-ms-office365-filtering-correlation-id: 7b41798f-10b7-4ce3-0e76-08db29feb3fb
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: An/X4m5MF6AGzbiItbUsHkvBA3yUaYKLVGH+qhOdpDsGwC0WeGgGPPVgML7PW8JS3zsgPlZttD011Uk7B6BbLmCY2c/mErhIYzf9ErptGkh9vw1axaAzYEkw8D3dfOwrOuD3w2PccWP9AfxBubnslxJbIhtnVS0MUGM3xNDdg1LeKnX97KPFjCl/yEBYo4L+aGuWSX4/Oh8E+zs7dzlM7bg8LMCoW0Qajs2rY8KLY36FHWrMaRzzRrjs/JUtGM06bahuW5+QYsvdrLFJrgawb2vNgUy7mVpJowWAhSQf4UkfwUP/DxEIAHDqL6JVu1ljedi6NqZCtEDb/jA9hzOcar/6CPbzWD/Nv/aThDyMq8s2DSbljS7nJRt3nk6o4trf/wZRnpJoVKRKQBkxeRueJlCU+jS68NbyvQQ3SNaocWC58JWOOn7mbF6IDuMNH31fXFNNt/R2vyl6yRdZiakcCFF4u9ErgmsaWM2Df7JQxOeUUBAcpd/Ks0yDTkz+xSvVZOJoQr0uFUQkEJet5yu+/wwO1uqE63igkbjaN8G2A3Qscb02FjY4d1gwm9+v+DbHa6MzxBP5fznsh4YkNBMnvPOrzb4xEIq5ESirc06bV+snTa5YWbUcd330NlFnPTyZ82gBNa+7BOgL29JI3jK5rpF7H00HV8QzwKjMndWm2bhghbDEr5RPURiypVfFOIn0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB7183.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199018)(54906003)(110136005)(5660300002)(316002)(86362001)(6486002)(2616005)(83380400001)(38100700002)(38070700005)(122000001)(71200400001)(85182001)(966005)(478600001)(6506007)(6512007)(36756003)(186003)(26005)(2906002)(4326008)(8936002)(7416002)(41300700001)(8676002)(91956017)(66556008)(66476007)(66446008)(66946007)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWJzWU43d2pUcGhGQVJSMTFkaDZnUlJObUJoc2VuTnA4ZU4vTmdacTJ4NWhQ?=
 =?utf-8?B?WkpuTzNYRFJpTTZhRldTOUFuZUZpMjhob1VrZnBlVkZSN2QxQkdIOC9ieTRT?=
 =?utf-8?B?SGxTQ1grYmRwcWJ6RFJkODNsWmpWL0JKMTM2YkxyWUY5SStJa2MzcGFaZ21k?=
 =?utf-8?B?bUMvUXlld2lmaHVGaU5kSnhMb3BoSnBsNEh4OTVkLzFQdFRPNGh6QkJjSXBr?=
 =?utf-8?B?b205MHBqc0RwSUxaSW8yTGhzMWdLUWNmNG1YYi92MmRsN29CcmJ1bXRhcmM1?=
 =?utf-8?B?UHJHZzVqSGdta1pyaW1HNkdTektoS0hQV055NXhsKzU5SGRudzFrQlpZbXV3?=
 =?utf-8?B?VDQxcGw3a2NzdFRNZEdTNUJ4cjgxa2x1Q0pXYUVEOFhQZVR5SWVBU25rT3hV?=
 =?utf-8?B?dGxEUHg5eWpqOVlpaU1mbXgvV2srL1FjRHNZL3NrazRJelJiQS9kZ3dyODJR?=
 =?utf-8?B?R2Z0T2tiLzlWZTVPdzIvVVRMR28xVFRtbnRqSjNvcU9SN1hIMWEvd0tKaE90?=
 =?utf-8?B?R2dkZURqUjdDOWdIOTVvMEl1eHQvOW43cG4xdkVIbFZOdE5US3NYTEltL2th?=
 =?utf-8?B?eVpNSHc2NlR2YzRLeXNiQkw1cm55QnBQN3JGcFdnUStiMi9NRm5Ic3FMZkxK?=
 =?utf-8?B?OUMwK0VWUytUTEovOFhDK2ljUUQySTNYR3ZqbVhnQzV6Q0pVcmRTQTN6ZWxP?=
 =?utf-8?B?RUkxU3Mvd0JjVm9BSDVzQTc1WS96ZWRqNWFvMWZBTkJpNkhpWDU3SHI5N0FK?=
 =?utf-8?B?V05ENzhRTElBTUhSZGNVR2w5SXhOOTFyTmR1KzJsYUdvWUw1UGVPYkU4ZlRE?=
 =?utf-8?B?OWhGWHM2NENmUWVabHJmN1JkdlluSW5kM1ZZbmpvY3dOZ3hSalM1cTNJc1lw?=
 =?utf-8?B?blViNXlVR25GTkRBdnJjZGw5T2dhajZyNXhBdGVkV29HWEltVDNMT21icG55?=
 =?utf-8?B?dzRMSjBqZ2tFSjMrN0ZDc3NlQXYxY29WdkNoc3h2Mjg2K043YkRUVDY5MHZC?=
 =?utf-8?B?N1FLZVY5Tk9FcW12RkxmbGNPaEJ2NzFPWE5ISmdtV2JYeG4yNGFJUDJQNXNv?=
 =?utf-8?B?NndFSlBrbFA3SGJJZFEyMEVXVm9XaVAxTXlDTmJ5YlA1K1dLODNpNFd6NW9F?=
 =?utf-8?B?K0VvSFhsY1Fpc1d4eGJvOG1UREFEdlUwZGhzUFBMWTRtWXkrRDQ2Rjd3QXpr?=
 =?utf-8?B?MG80WkRZQzJ3YTNoYUk5UFU1TVg3bFBYYVNhVnNBTzVTZGlxK29YdlBuR0J3?=
 =?utf-8?B?SndLaWhjZFlPQ0VZUXh5YnlOZUMyeFlEeno1bmxuOTFZNloxUk9zWXkxdENY?=
 =?utf-8?B?Y3FwTnJRR3dvNHBGS292bUVMWHYySFRtQW1EYms2RVRTaXZVOFZKWnh2T2sr?=
 =?utf-8?B?RWxUbFZyc3BFNGhoSTFYaVdzeTlBeDFpUzJoQkR6T0tLWTg1TWJOUXd4UlpV?=
 =?utf-8?B?UUI3YndGbktmNFg1RHk5dG1HcmlkN3ZSQzJKZlBWV1RlWTFqTVNYOUhCbkxu?=
 =?utf-8?B?T1d1ekRsY0lwS2pPY2FtZ0NtNzlubXBMK3h2OHM1aEo1ejArd0srRW8vbnh5?=
 =?utf-8?B?TTdNWDNxQ1dobTRVdXI2dkZDd2JRNlRBaWNqdHZlZy9TbnJuTS8vOVdYT0tI?=
 =?utf-8?B?M0lTTTlHUllGMzI3cWdQSkdXMmc2UG0xaCszYVhMV2NSZGQzUGdtdWhPeDY0?=
 =?utf-8?B?N2sxT3lwRURoWlpRYjhNcHByNDZUc3JDamYvdFI0aG9laUhLOUQwKzdzRWFs?=
 =?utf-8?B?R1pMUGxlWjUycmZWeC9qMlhrblVDSEtCc3NWclBSMWg4ZEE3MmFWZksxM2Zt?=
 =?utf-8?B?OWprOXFJK3JlbnFMOTkxNS8zdWxxMzF1dERmbThIbzFuNkN3YnRIM1EvU011?=
 =?utf-8?B?Z0FjSlNjTDA4dzBXSWhXV1pmR2NPUklRcC9mMGEzaUdwNXl6QmdkRUNwM2VH?=
 =?utf-8?B?NHB5QUs1SGkyQWZLdm9kSC9CeDlhT21sM1RndGZxL1FsbVEwdFh1MHNHL1k1?=
 =?utf-8?B?RzhGczFydDBQTzVkdWcwWEI1Q3FrallOZ0E1MzhXZVpvUnpQTjQ5Nm9CYmFX?=
 =?utf-8?B?czVmVnEvK3hkMVErMk5lc0E1ZlMvSE51VjJzYmgwcDFYTTN0MlNYcGZjOGZT?=
 =?utf-8?B?UUp5SjNFbzVnSWUweHZaczFBMmlka2Zab3d5ak0xY0VScXNoYUhodEpZTjFF?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C89158318D1FCE44AFE5A440DA1538E1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB7183.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b41798f-10b7-4ce3-0e76-08db29feb3fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 11:23:32.0902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oeXbrZQfUxY5dMY2AuZz9332UJRRfFwGmrRdLdJCPN8x1VAwSAm6CfdDOoqvc0vIhFqQidKMQ0TqzTaNClDdNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU2F0LCAyMDIzLTAzLTE4IGF0IDE0OjM1IC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gRnJpLCAxNyBNYXIgMjAyMyAxMzozMDo0NCArMDgwMA0KPiBDaGVuZy1KdWkgV2FuZyA8
Y2hlbmctanVpLndhbmdAbWVkaWF0ZWsuY29tPiB3cm90ZToNCj4gDQo+ID4gRnJvbTogIlR6ZS1u
YW4gV3UiIDxUemUtbmFuLld1QG1lZGlhdGVrLmNvbT4NCj4gDQo+IEhpIQ0KPiANCj4gVGhhbmtz
IGZvciB0aGUgcmVwb3J0IGFuZCB0aGUgcGF0Y2guIFNvbWUgbml0cyBiZWxvdy4NCj4gDQo+IEFs
c28gY2hhbmdlIHRoZSBzdWJqZWN0IHRvOg0KPiANCj4gCXRyYWNpbmcvc3ludGhldGljOiBGaXgg
cmFjZXMgb24gZnJlZWluZyBsYXN0X2NtZA0KPiANCj4gPiAtLS0NCj4gPiAga2VybmVsL3RyYWNl
L3RyYWNlX2V2ZW50c19zeW50aC5jIHwgMjMgKysrKysrKysrKysrKysrKysrKy0tLS0NCj4gPiAg
MSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+ID4gDQo+
ID4gZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFjZV9ldmVudHNfc3ludGguYw0KPiA+IGIv
a2VybmVsL3RyYWNlL3RyYWNlX2V2ZW50c19zeW50aC5jDQo+ID4gaW5kZXggNDZkMGFiYjMyZDBm
Li5jZTQzOGVjY2FiMmUgMTAwNjQ0DQo+ID4gLS0tIGEva2VybmVsL3RyYWNlL3RyYWNlX2V2ZW50
c19zeW50aC5jDQo+ID4gKysrIGIva2VybmVsL3RyYWNlL3RyYWNlX2V2ZW50c19zeW50aC5jDQo+
ID4gQEAgLTQyLDE2ICs0MiwyNSBAQCBlbnVtIHsgRVJST1JTIH07DQo+ID4gICN1bmRlZiBDDQo+
ID4gICNkZWZpbmUgQyhhLCBiKQkJYg0KPiA+ICANCj4gPiArc3RhdGljIERFRklORV9NVVRFWChs
YXN0Y21kX211dGV4KTsNCj4gPiArDQo+ID4gIHN0YXRpYyBjb25zdCBjaGFyICplcnJfdGV4dFtd
ID0geyBFUlJPUlMgfTsNCj4gPiAgDQo+ID4gIHN0YXRpYyBjaGFyICpsYXN0X2NtZDsNCj4gDQo+
IFBsZWFzZSBrZWVwIHRoZSBtdXRleCBhbmQgdGhlIHZhcmlhYmxlIGl0IHByb3RlY3RzIG5leHQg
dG8gZWFjaA0KPiBvdGhlcjoNCj4gDQo+IHN0YXRpYyBERUZJTkVfTVVURVgobGFzdGNtZF9tdXRl
eCk7DQo+IHN0YXRpYyBjaGFyICpsYXN0X2NtZDsNCj4gDQo+ID4gIA0KPiA+ICBzdGF0aWMgaW50
IGVycnBvcyhjb25zdCBjaGFyICpzdHIpDQo+ID4gIHsNCj4gPiAtCWlmICghc3RyIHx8ICFsYXN0
X2NtZCkNCj4gPiAtCQlyZXR1cm4gMDsNCj4gPiArCWludCByZXQgPSAwOw0KPiA+ICsNCj4gPiAr
CW11dGV4X2xvY2soJmxhc3RjbWRfbXV0ZXgpOw0KPiA+ICsJaWYgKCFzdHIgfHwgIWxhc3RfY21k
KSB7DQo+IA0KPiBDaGFuZ2UgdGhpcyB0byBqdXN0Og0KPiANCj4gCWlmICghc3RyIHx8ICFsYXN0
X2NtZCkNCj4gCQlnb3RvIG91dDsNCj4gDQo+ID4gKwkJbXV0ZXhfdW5sb2NrKCZsYXN0Y21kX211
dGV4KTsNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsJfQ0KPiA+ICANCj4gPiAtCXJldHVybiBl
cnJfcG9zKGxhc3RfY21kLCBzdHIpOw0KPiA+ICsJcmV0ID0gZXJyX3BvcyhsYXN0X2NtZCwgc3Ry
KTsNCj4gDQo+IEFkZDoNCj4gDQo+ICBvdXQ6DQo+IA0KPiA+ICsJbXV0ZXhfdW5sb2NrKCZsYXN0
Y21kX211dGV4KTsNCj4gPiArCXJldHVybiByZXQ7DQo+ID4gIH0NCj4gPiAgDQo+ID4gIHN0YXRp
YyB2b2lkIGxhc3RfY21kX3NldChjb25zdCBjaGFyICpzdHIpDQo+ID4gQEAgLTU5LDE4ICs2OCwy
NCBAQCBzdGF0aWMgdm9pZCBsYXN0X2NtZF9zZXQoY29uc3QgY2hhciAqc3RyKQ0KPiA+ICAJaWYg
KCFzdHIpDQo+ID4gIAkJcmV0dXJuOw0KPiA+ICANCj4gPiArCW11dGV4X2xvY2soJmxhc3RjbWRf
bXV0ZXgpOw0KPiA+ICAJa2ZyZWUobGFzdF9jbWQpOw0KPiA+ICANCj4gDQo+IEluIHRoaXMgY2Fz
ZSwgeW91IGNhbiByZW1vdmUgdGhlIHNwYWNlOg0KPiANCj4gCW11dGV4X2xvY2soJmxhc3RjbWRf
bXV0ZXgpOw0KPiAJa2ZyZWUobGFzdF9jbWQpOw0KPiAJbGFzdF9jbWQgPSBrc3RyZHVwKHN0ciwg
R0ZQX0tFUk5FTCk7DQo+IAltdXRleF91bmxvY2soJmxhc3RjbWRfbXV0ZXgpOw0KPiANCj4gPiAg
CWxhc3RfY21kID0ga3N0cmR1cChzdHIsIEdGUF9LRVJORUwpOw0KPiA+ICsJbXV0ZXhfdW5sb2Nr
KCZsYXN0Y21kX211dGV4KTsNCj4gPiAgfQ0KPiA+ICANCj4gPiAgc3RhdGljIHZvaWQgc3ludGhf
ZXJyKHU4IGVycl90eXBlLCB1MTYgZXJyX3BvcykNCj4gPiAgew0KPiA+IC0JaWYgKCFsYXN0X2Nt
ZCkNCj4gPiArCW11dGV4X2xvY2soJmxhc3RjbWRfbXV0ZXgpOw0KPiA+ICsJaWYgKCFsYXN0X2Nt
ZCkgew0KPiANCj4gVGhpcyBzaG91bGQgYmU6DQo+IA0KPiAJaWYgKCFsYXN0X2NtZCkNCj4gCQln
b3RvIG91dDsNCj4gDQo+ID4gKwkJbXV0ZXhfdW5sb2NrKCZsYXN0Y21kX211dGV4KTsNCj4gPiAg
CQlyZXR1cm47DQo+ID4gKwl9DQo+ID4gIA0KPiA+ICAJdHJhY2luZ19sb2dfZXJyKE5VTEwsICJz
eW50aGV0aWNfZXZlbnRzIiwgbGFzdF9jbWQsIGVycl90ZXh0LA0KPiA+ICAJCQllcnJfdHlwZSwg
ZXJyX3Bvcyk7DQo+IA0KPiAgb3V0Og0KPiANCj4gPiArCW11dGV4X3VubG9jaygmbGFzdGNtZF9t
dXRleCk7DQo+ID4gIH0NCj4gPiAgDQo+ID4gIHN0YXRpYyBpbnQgY3JlYXRlX3N5bnRoX2V2ZW50
KGNvbnN0IGNoYXIgKnJhd19jb21tYW5kKTsNCj4gDQo+IFRoYW5rcywNCj4gDQo+IC0tIFN0ZXZl
DQoNCkhpIFN0ZXZlLA0KDQpUaGFua3MgZm9yIHRoZSBjb21tZW50cywNCnRoZSBuZXcgcGF0Y2gg
d2l0aCBjbGVhbmVyIGNvZGUgaXMgbm93IHJlYWR5Lg0KDQpTaW5jZSB0aGUgdG9waWMgaGFzIGJl
ZW4gY2hhbmdlZCwgSSBjcmVhdGVkIGEgbmV3IHRocmVhZCBmb3IgdGhlIG5ldw0KcGF0Y2g6DQoN
Cmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMzAzMjExMTA0NDQuMTU4Ny0xLVR6ZS1u
YW4uV3VAbWVkaWF0ZWsuY29tLw0KDQotLSBUemUtbmFuDQoNCg0K
