Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFA06E1980
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 03:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjDNBRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 21:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDNBRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 21:17:02 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA6040F1;
        Thu, 13 Apr 2023 18:16:57 -0700 (PDT)
X-UUID: 082b6cf2da6211eda9a90f0bb45854f4-20230414
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=eRdwCz3aIdqjE+q0y5ipyd1eThbc9jPVN+D0Y9eiURA=;
        b=TTmZmnqZ2iGPoHWikPL05YBaBo5ZwvQG+4Ca92qioLtERIudHa11RXU+e3twW2YbLsF9MrMEszVX4FHF1z/ja9VhwFGEUv/16zZir2u7v22mLL2uD9VFAcS2EIiVfWMdbEOxWMRV9axvlKs5tuAqugbWdlPPq71RVCNmHSkH1Nk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:d74fc9c9-2297-4399-aa0a-5eaa8eae30df,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:120426c,CLOUDID:797e0084-cd9c-45f5-8134-710979e3df0e,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 082b6cf2da6211eda9a90f0bb45854f4-20230414
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <tze-nan.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 705154530; Fri, 14 Apr 2023 09:16:49 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 14 Apr 2023 09:16:49 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 14 Apr 2023 09:16:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yk1al80Em3DfB11Nos/eYJYrUA9FNIpfSFMYzzw94oBXb0KdT6bCA7n0m9We3iH1nZH/G4yXe6NHGRi8rWB9EDJZMSUBFSU6MoggjG2i1mJwqybMQB+pH7jedFpZLOgQBx69ZCTwuJTyJLteo3bZYLynop0hC4MqgCF+7h7XOoZZPjj/5AVjhKXuDQiGmIbXuR7qGoA947N4SOcu98DL5daR8g17YtRY49IxN519kcKqfY+s2PyAbhsVbdU5Q212JP/wd5xXsGXgieOfiaLqA9ZCg0X6Kgw68iV93v/3/++WN5fx2LWB0OAK9qKimLX0PkwXF0PUG6o8hzJzLuBVfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRdwCz3aIdqjE+q0y5ipyd1eThbc9jPVN+D0Y9eiURA=;
 b=KR26pHIKzUyam1yONhwu1gMT/EHLtalC6Za6HU0z4ExiKsRcCUY7S0jkU5axUwT5zEzQGaDk6izUK6tmCfuoGf6fgMymCUBno/lhpvKbPUv7NqP+Tm/3aEXbFNGddDQJiDBWSiTprSkW7b8ZGBKo8eDCj2w314XURH5AJBdOfezpRseu/8BXP2UWuvP5QTdY/TCyQ5zVEFOSFDUmBoF2yHTqKhXdLl71rjXVOCip0spJbfou9tiq5e5DnwDUayrWFxAqkwKZiBIBqIQvgtMI8gvccm4COtRJ6LWc8eYEyEb5nh01UzyQ6T06L9HlA+u7vVsx1cLpiaWTBYC19PijmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRdwCz3aIdqjE+q0y5ipyd1eThbc9jPVN+D0Y9eiURA=;
 b=b9rYjhHinIKJc2MDxYyBm72ZfsXrNSVX9uXjBsze3BCuiYHNYcfgCWtO99AiLPUk5mw+KZW4lBnrnX/5oQh5lrv4ufqH/FIpa1Pexs/S+0AL9ypj3mZPa9RPYPQCtmrScoLzSMcqlkDLCxoWb8Ak7NETKYfCqamAgiM5Aifjq7o=
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com (2603:1096:400:33a::11)
 by PUZPR03MB6965.apcprd03.prod.outlook.com (2603:1096:301:fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 01:16:46 +0000
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::6d55:5655:af99:8cb7]) by TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::6d55:5655:af99:8cb7%5]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 01:16:45 +0000
From:   =?utf-8?B?VHplLW5hbiBXdSAo5ZCz5r6k5Y2XKQ==?= 
        <Tze-nan.Wu@mediatek.com>
To:     "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?Q2hlbmctSnVpIFdhbmcgKOeOi+ato+edvyk=?= 
        <Cheng-Jui.Wang@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        =?utf-8?B?Qm9idWxlIENoYW5nICjlvLXlvJjnvqkp?= 
        <bobule.chang@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>
Subject: Re: [PATCH v3] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Thread-Topic: [PATCH v3] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Thread-Index: AQHZa38KrpoyHt4TVEOuF1N51i1qDq8qBooA
Date:   Fri, 14 Apr 2023 01:16:43 +0000
Message-ID: <3747eb90487f6eb9cd2f6ff84208c08d4b958bd9.camel@mediatek.com>
References: <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
         <20230410073512.13362-1-Tze-nan.Wu@mediatek.com>
In-Reply-To: <20230410073512.13362-1-Tze-nan.Wu@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB7183:EE_|PUZPR03MB6965:EE_
x-ms-office365-filtering-correlation-id: ec6e55de-939e-4a6d-6a82-08db3c85e8f2
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: myDArm7w0ITcoS/PC4blC0LtwxwRJSSGjWhuqa79bZzJFArQtuXIhWizeNif0HcTR+SabtOiFUs5AnD3BNrB4F5o5wWZ0rqEc8fAD0TNWJ6oX1Xetp+YFj/m4lQflNRPiRnooKeONOKSELL+4I9Vj1isq3QkEdSZhJu1XYKUfhn6DeY0rmG4dJCLBAx23sQK31fAV7w87leuKSe2+DoAFcn9t2LyuqjC6P9B4S8Z2VPnzEOClFb1o3epU6qV3G67+aIJKOZEeN8pMQMzbwzPguBrg5XbyqtY4sAFD2XTCxszVd7uS1OvJtoqHJ5T0swGq2Qr9C54A0cQ3SzHxLpv/ObRT0PUzoSvflWlDjPmQhdkWfBplayGWxjITFAOet0OpBTVyAg5JhuVBMIPM3edgWdHazWhFlW2NuA9DdSrHszgU0t/V2i87SGr2oTrW7djOaK7JsjXjyv8N4l5gWRrM7wLg98eOX0exQxxlBzueBppRqhqvNrHDUcnis80/OR+I4v6qAQjHUgtAYeHNW13EHizPQeKKJSprtHI0eRvXG/5fhpqi3YXzId9l6pZ3FPR2rrhphDwZ5+G+x32b5hHa+Zk/5didgr3O6qGLC6Fvc+KEL5eCI4QV6udmxyENgS8j8vanocoxdpbYaCvGQczwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB7183.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199021)(8676002)(85182001)(38100700002)(36756003)(5660300002)(2906002)(7416002)(38070700005)(86362001)(8936002)(4326008)(122000001)(316002)(66556008)(64756008)(41300700001)(66946007)(66446008)(66476007)(54906003)(110136005)(2616005)(966005)(76116006)(558084003)(6506007)(26005)(186003)(6512007)(71200400001)(6486002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjFVb25zRVRqRGZOSTFQdUo2VFNleHZ3aHNuN2ZpY1V6YklQTXMxdlRXbzFv?=
 =?utf-8?B?ZFVPWlNSRkJ1SUtVeWxHZlRPNlFoSmN2L21IQzEvQ1lydm1kSjl4Rk9YU1Zo?=
 =?utf-8?B?NjFmQ0hWZk9EU1RucWVVUEVyMDYxMGpnTW9yMGxLVTNmakJkeU84QmZCUCt6?=
 =?utf-8?B?SGd6dW8ydDBaUzlrZFFHS2JJcEVEK2k4aitSTGhhVG9xdThOS2Zpem9ySmJp?=
 =?utf-8?B?dWxqUnJIenRWTVl0RXlZN3JmT1UrbWp2ZXprTFJXT0Ercm1GUnJqNzJ2Zkk4?=
 =?utf-8?B?eUtTNWZXc1NvQnErV1V5bGVDTVpOZVhaWnczdWxWOGRUYU1ITDNVTnFiNnZz?=
 =?utf-8?B?ekl6anFLUWpZa0tnK2pwZ216TUEwS2oxWU05WmVyTUVXMmVoMG1WMVcwUEZU?=
 =?utf-8?B?VTVBSXNQZ0VrNW9YRkhSU0pHUFV1REw1R3l6UXlCcm5oYzdjcENjNWxjbTZD?=
 =?utf-8?B?anFkWXB5Znoxa0VBMWtCdVpGZ3BWaGhLOSt4eWpkdmRuZUszWGVKU05DTVB6?=
 =?utf-8?B?Z25mOXJjK3ZjaFA4Y0RkcGordW1BdDQ3aHg3U0czbkxHK3BON1JNazRFU2xD?=
 =?utf-8?B?R0RuTGR0c2NTVWlDZzJNaTZ6T0ZLQjZaY2VHVjl4aHpsWU9ONWVuckxaRDdz?=
 =?utf-8?B?TjgvTDNvc2JRcGJKUmQ3SmJTMUhyM3BJNkF1Wml2eko1SjNUYTQzNno0M2kx?=
 =?utf-8?B?L2krMmw4QnlnSGpBL0pXVmdpYnhuaVlNdEpuRE5hTFFaOElhSnJ5YlkzL3VY?=
 =?utf-8?B?OHM1Q3FwcnhrV09Nenp2TkF2dmdpbjRVVGFPWlVhMlFNWlVkY3Z0ZlVEWC9S?=
 =?utf-8?B?a1lDT3duQjRVNHl2VFdzeGRJdlUxZ05nYVgxb1A4UFhLN24xUS9YOFo4alNL?=
 =?utf-8?B?UldGNWZkaGE5LzkwRy9QZnhsZTAydER5Q2dtakxQMFo0R0h4czZhei8zQy9G?=
 =?utf-8?B?Yk1mWVRvS2xMNUlpMFNMNVBvbmgyQm05dEx4QlFhbC9PYXFIZDVLaDg2elJ0?=
 =?utf-8?B?dmt0YVhhNUlSdjR0WXBxNStocVJvbGMwVDR2c2JjbVdubWFSV2IwVFpXbU82?=
 =?utf-8?B?VVdVdjNvUjBOOWQ5Nmo3OGVjajBEMkJNTHM0aDNDOGFsSXF1cDZ3Tk5zR1FJ?=
 =?utf-8?B?RGxiSnlaeTVZaEJGY2ZFM0dwaXZseDFWWm40YXM5QlMyeTVVNm0ycmxuNFZM?=
 =?utf-8?B?TUtGNFM1TUw1aEJ0a2s3eThORzl2cmxBb08ydGpmTEdvRDdkV0l2VTA5V3V5?=
 =?utf-8?B?ZG1XMmJVMkN6cnhJNDYxYWxiZGs2MGdPRlorRW10eXRZZmNHcEZVaXRZbkFW?=
 =?utf-8?B?NXF4dGVwN3BpWW56dlN4dXhkQ01XVXRGMWViR0JaVFo4OVNYMUNHNVB3anFn?=
 =?utf-8?B?aDJ6QXUvVTJ0VWNKSnZGRVliWVNlcm14d1BkbWsvTDNpMWlZWWtoUFFvYVJn?=
 =?utf-8?B?Y0VMcnhQYUVpd2lBeW9vYkcxR0VzdDZYa0ZrM2FuNmNlVkpucHlYVGxPNUcy?=
 =?utf-8?B?ZzlneERUcTRhd0djQmNyK1lNYkZKQmFkemZHcHdLc0ZUMEJsRTVZMVlsWDZX?=
 =?utf-8?B?dlcxdDRHOWFuNDVaN08yZitzVXhVK1Z0RVZVZXZMSlFzeWh4VlhFT3IzdGI2?=
 =?utf-8?B?Ryt3V1FGVmhaU2d1RWg2aFk5VlBuT0dNNW5aMHZsUHZjZ2pGVzJYdXZSbGpT?=
 =?utf-8?B?akVsSWtPQmJLTkxnakxSUC8xNVlVeE9XbEl3bGRuSExuRDRZN256OVFEdm5q?=
 =?utf-8?B?R1hpWnhIekZkaUUzSExEaVltTlQrRHBXL24zbFo4b2tHd2JCbnNNRmZQRGx2?=
 =?utf-8?B?WkttMkFZOERxRTBQTXdCMFBIN3VPMnN2VGtVM0JCYnhyc3NHOXN5V2kvb0Rx?=
 =?utf-8?B?Y1hYNTBEZzJDTTFqamM5b1JvQ2lCeFF5WHd4UEZqbXdESnJpRjBCeHdBcmpT?=
 =?utf-8?B?alF6MUo0U3VTNzhQZUN0L0luT3JpY3RBL0VBU1ZkOFp5TmZRS1dIdHh5bWZR?=
 =?utf-8?B?SVEzZlVZREN3THRBNERYNjdmMzBDU1Q3NGk5Y0JndVlsQjc0dTJHRXlIdUlN?=
 =?utf-8?B?TTU5SWs1M2NEMmdPSjVYbkNRMnFaWHp5OGIxa1NhbzhCU2tlOEVIbXE3QW9n?=
 =?utf-8?B?ZVRKVWRmOHJkZmJxREs0ZHV4ZlRDU3Fxb0QyS2VFMVBDd0REWlljWHlVYURW?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DD6E13CD4E27B4C9CBE5D7C17EB32C1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB7183.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6e55de-939e-4a6d-6a82-08db3c85e8f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 01:16:43.9313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /lb/WC5KDiIuyASec2zH+a/OlyKoc4RoE2hyqJxlUlvIr25zX6quL0WzxMQUd6fbxTt5WGqer2i569kBI4tjVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB6965
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SW4gY2FzZSB0aG9zZSB3aG8gYXJlIGZvbGxvd2luZyB0aGlzIHRocmVhZCBidXQgYXJlIG5vdCBp
bmNsdWRlZCBpbiB0aGUNCmNjIGxpc3QsIHRoZSB2NCBwYXRjaCBjYW5ub3QgYmUgZWFzaWx5IGZv
dW5kIGJ5IHRoZW0gZHVlIHRvIHRoZSB0aWxlIG9mDQp0aGUgbmV3ZXIgcGF0Y2ggaGFkIGJlZW4g
Y2hhbmdlZC4NCg0KTGV0IG15IHB1dCBhIGxpbmsgaGVyZToNCiAgDQpodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9sa21sLzIwMjMwNDEyMTEyNDAxLjI1MDgxLTEtVHplLW5hbi5XdUBtZWRpYXRlay5j
b20vDQo=
