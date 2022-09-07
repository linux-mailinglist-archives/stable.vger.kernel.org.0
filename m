Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF405AFF54
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 10:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiIGIkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 04:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiIGIkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 04:40:19 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47C66315;
        Wed,  7 Sep 2022 01:39:29 -0700 (PDT)
X-UUID: a510a772f1ab4e7bbb90f9d731f3a76e-20220907
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=1Ib0qd4dU+wF2VHsN6Q3EsRHdoka2OThUbRK8Y7H7F0=;
        b=kE7vZzraPeKX/taPKbuCP5ra5T5ox5b2EZPslbb+IeGl4C3wmJksSluIjSBI5NGN4pEjtktDMHigQX7c7HMf23TRw9XYZQ56PMNHG4ss2H8d2T0QJFGpfrlhr70ftQHb/OTX2NiexRQ/uEL98s0Ua31KZDX2/TPtTUvcnscGSd8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.10,REQID:bce8ee77-0c2f-478c-8dc5-c0cc58c533ea,OB:0,L
        OB:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release
        _Ham,ACTION:release,TS:-5
X-CID-INFO: VERSION:1.1.10,REQID:bce8ee77-0c2f-478c-8dc5-c0cc58c533ea,OB:0,LOB
        :0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_H
        am,ACTION:release,TS:-5
X-CID-META: VersionHash:84eae18,CLOUDID:314ef456-e800-47dc-8adf-0c936acf4f1b,C
        OID:IGNORED,Recheck:0,SF:17|19,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:n
        il,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: a510a772f1ab4e7bbb90f9d731f3a76e-20220907
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <yee.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 622151457; Wed, 07 Sep 2022 16:38:00 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 7 Sep 2022 16:37:58 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Wed, 7 Sep 2022 16:37:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCuHDZgQCLlQFT/XgfmkWNbS0uVhGsKfomXJtmPCcI1YrENBv6k5fGJ2EZ6yHApyPIrzH0k33sKYqz9mtemRZvGEnIqK7GNAFo4yJ4wJ+75umxlcGopyV/G1jSBkBo2O4pISXI3M1nliFFjx2HjtZ4bkAHY924nUxHTIf1fxVMC37TSYm7N723QXkLSNtf3MYNbRTOvVivRc86dUT7halGXHXVuJWWShu+Uuw8FigqfRlwxi8OAyoHQNg+tlWwpEGmRXR+tpVKTUSVuPbrTyTaHgJBBkaRS6GkL4Ffd/hctbv17ZMlrZ990Fh05XBaXmLdf5Fw1OfGtifQqojs+2zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ib0qd4dU+wF2VHsN6Q3EsRHdoka2OThUbRK8Y7H7F0=;
 b=oeXkr+HK6lhNuyuxR3/AQcd8bNaf2u9MGaGA+vvEDGhlSvivhdyN4rUPwB5VA7xcp+tVXV+mS2BWXO095gjO2ArXo3xUWnaF6KHLdPCjZpRzvla3xSepgEpXTeMlqquEQWntORkP2GW5yRLTQnzO5ePXk6RDnX0awZjjhN1LAiFfdnv1gwhRGGu5PdpCDSObsa1q0ew9/LQL8MMVh7iO8SKPKtSK9FNvTUCxrM6liGow68gneNFNH7NYyj/yJhhk9Cj5pjIRBQzEKyM0aFs2afwwx2bMZ34v4y1Lm983vMXYWsnxpJHd5HjWvIRLhAZgSBrBkM0oeas/rC46om7nuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ib0qd4dU+wF2VHsN6Q3EsRHdoka2OThUbRK8Y7H7F0=;
 b=HlyK4XLtEf/abHd41HZSe+A2Wc9zQ4OTzqxXhaBg4T9NbxOaqaGeAESqsncEy4vGSdRUaOatRcrZAR0MXsc19zNccHouuYsyx7XQAEtUUBxZyNVkSSgyLoUL6IhvTXykeyYE5jciv6/2Ou4DRJAwC/MMDhq+YOp/MvzeWAmRZ+c=
Received: from SI2PR03MB5753.apcprd03.prod.outlook.com (2603:1096:4:153::11)
 by PS2PR03MB3752.apcprd03.prod.outlook.com (2603:1096:300:33::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.7; Wed, 7 Sep
 2022 08:37:57 +0000
Received: from SI2PR03MB5753.apcprd03.prod.outlook.com
 ([fe80::230a:8704:b949:2e0]) by SI2PR03MB5753.apcprd03.prod.outlook.com
 ([fe80::230a:8704:b949:2e0%5]) with mapi id 15.20.5612.012; Wed, 7 Sep 2022
 08:37:56 +0000
From:   =?big5?B?WWVlIExlZSAop/Wr2L3LKQ==?= <Yee.Lee@mediatek.com>
To:     Greg KH <greg@kroah.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patrick.wang.shcn@gmail.com" <patrick.wang.shcn@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH 5.15.y] Revert "mm: kmemleak: take a full lowmem check in
 kmemleak_*_phys()"
Thread-Topic: [PATCH 5.15.y] Revert "mm: kmemleak: take a full lowmem check in
 kmemleak_*_phys()"
Thread-Index: AQHYwb67/+WrwmfXvk6J9bnulVZ75q3ST1yAgAEE7cA=
Date:   Wed, 7 Sep 2022 08:37:56 +0000
Message-ID: <SI2PR03MB57538512401A213D21B7882C90419@SI2PR03MB5753.apcprd03.prod.outlook.com>
References: <20220906070309.18809-1-yee.lee@mediatek.com>
 <Yxc4U/8zzfkHHv+W@kroah.com>
In-Reply-To: <Yxc4U/8zzfkHHv+W@kroah.com>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5753:EE_|PS2PR03MB3752:EE_
x-ms-office365-filtering-correlation-id: aaa923cc-0ace-4dcd-d799-08da90ac4395
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OTJTfVvAhia+gQg2QvPDFoXX5y65kndd3PwxhtlIsY9hjQzUlv5oBkAAGhElSP5XvA4lPbswFQiL4I0ROcnslgHXgRrNeR/W9ppCBNemVDySziNBUlayuRNpC9MAlKTXKZCCIfl4NNbRsq5Zr8lS44PiyRa+rrcswpn4ekN0j4/lqgK4MKsv2Nk7lgRmII+4h7yAgQ5H9ObW/WayhSW0jRSY8w3fyymwDHZbymO9ZYVP80CNaRHwDQ7T/eiq/jPzdIo/qcbJNPrzhC8OexZtorP9e7nZftqmTMy/Gu3qQP/R930MY8usUtuKs+G0NZ8XEBWtKpcoXmIGdJKkCfzrUIjHQm4oOa5ArOjEuJ0rSDHT4XAOpEKT8I5NuYQ9bc3FtFNSKu7O3wjswaacQoOaxY+oiLfIyA9gtRfuFetLdTwPNz7VtLjmrrTMB8LV2RQfIEKGU/TIAeR82ibn70iFZxPDmJU+6a221gKT4kbyVUN9kHJK5ThIBA7LEmy1/knDFs5KtyBYUyur8sWltBG3CcvnopGrrMsPWbjPfIN6OrnwB1W3e9hzrqV68zg9P/qGton7cQLcdOkYMVXTV/Hfrt7JXYaiHmIfU2v6XEX+PiYVKWkZF1yOBz/K8wzN/7M5mvGEB4ni8z2Ytbo5soETuqJBdDENX2EGxzLMa7QedoFJolKLmTdvhZnR/fPwke2dmJeqiI20QpNvERPo1yqVzEkcDsiN5b4LlNK3zRnCGF10mrzhFYx7V8svZ5OYKsWBSFMIbzsvNxKp21WSwU+CN2U79mpVZq2dSQHlyg5RY39kkVDKZsWSXY4jmlN6mFs9mSyKdQbgXOf/TR4Q545wDxr30CppuXwX1WVMyE3M9qo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5753.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(66446008)(8676002)(186003)(4326008)(64756008)(122000001)(76116006)(66556008)(66946007)(38100700002)(66476007)(41300700001)(71200400001)(9686003)(6506007)(54906003)(26005)(7696005)(83380400001)(2906002)(316002)(6916009)(53546011)(52536014)(55016003)(5660300002)(85182001)(33656002)(8936002)(478600001)(38070700005)(86362001)(7416002)(505234007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?cEFwMTViYjZnVUlwYk5nY3BYZVdYRzV5eGRsUkhKMDlMditRdTQrOWs4SFVBYWVG?=
 =?big5?B?MVowM1NmOUpwS0pndEhLbVAxdUY1eGxIQUY5cndncWxSVE1Jb21IaHFZMmpzNXVr?=
 =?big5?B?c0p2WlE5dnlUd0V0VTd2dXNKVzQ4YmR4UFk5MXh5OVpmL3Rtd3BuYk1QZzQ2cXFj?=
 =?big5?B?ZW5ORWs0eUJuek4zYlFiWFNXVEh3cExyWGRRelptUktmOERvdzljblNUZzd2R05x?=
 =?big5?B?TW9LQWZFcVZKZlRSRnhQUGtiUHJSbkZqNTZXL3oySTErcUdvS09JQ2xuMStBc25Z?=
 =?big5?B?OEFwM3pid3hobVQ0N0lSQlRRY2xUU1laRjZwVXNnWFBUMGtOeW11WHdVdW91cUNo?=
 =?big5?B?aHNUcDU0YjBndzhWTzMwRnR2WEhGakt3b0tpS3EyVDFnTnVkK3NwTkRiY3F2R0ow?=
 =?big5?B?T1BET3o5dk5yWjkrb20wU1phMXFKdmY2YktHU2EwbWNoSnoySUNxdENGb2hvYVZp?=
 =?big5?B?NmtWTWZZckdFUy8yQStoM2ZIblVqejRBVjNMZHNkZ0k2QXNXSXBoRks2WWxINEV5?=
 =?big5?B?ejZ6clZCc1ZvK1lmMEJWWDdXR0tVV21pZm5Qa0l3SmJ6cDBKcURMOEhzSGxrME1X?=
 =?big5?B?WkNud0dFcS9qOEk3dDk2SXlCVjhydjgwMGJuVmVaVzRZSmQ3dXVWNXBXeTcxMU1B?=
 =?big5?B?ZGlWdE9WTTdhNEpvQ3RwSHFScW84eTZndG56YVMxVVdVNzNoRUNOdEpBVENLdFBT?=
 =?big5?B?Z1FCcWs0K0xsNzZIRXNwVnoxNHlUemJGcnF3ckhJY3M1aW93d3FBeWhpMGxWSnls?=
 =?big5?B?NTA0MzRYSzM5anRBT0p2MnlKMjVVRkdSK3RlNUs2RTkvdzZSMlltemhDbUFBWGdz?=
 =?big5?B?Wm1UVFVOSmNPZlh0OVR0NnNGU29Wa2JhbWNuZFNqdGF3Z1BlSklROS8xN3l0V2JS?=
 =?big5?B?aFdpakVmOHYvcHVmQnk5QWRTVGNRUDFmMFVMU1lWQUh4UzNpYXRBQm1ldHRVVkhu?=
 =?big5?B?ZVpkMlowQ3N6M3FZRklLc2RMaTlVMS9PdmRDMnliWWw4YkU5YjVYdE80OWZSVENn?=
 =?big5?B?VXppODMwRjlWTTZEZk5LZkZQWmlzTXdGcTRTdnAvWURSTzFYZWtqVG9rRGRNTEQy?=
 =?big5?B?TnFraVRaVk9ZT2ZZWTlIQjF1VGo1b2M0RXRZT0xsVEdFS252bjhaQlUzclkxNmli?=
 =?big5?B?dTFBZnl3UFZuc1pmNHBUZXNCUStDUmJYMlBWd1AweWFsZ1R2RlNnZTQxUFVJdzJj?=
 =?big5?B?NkVzeE16d2RoZEwwY2FBR2lVRlhpMW41S0ZVSE55cTdwTWI1eEdGWis4Z0hsSTRq?=
 =?big5?B?VG5BKzczTDd6WmpLd1BhQm1YUXIxRjd4bGszM3grSkFMTndnVGtVME9YQ1h4OUxw?=
 =?big5?B?dmdMbVJyMGFNTGUrV0E1bjdkeVJpMGR5NlNSS2JlbzdIVTZLZktOSnd1aGJsemox?=
 =?big5?B?cVdUM2FxQ283TnkrS2k0R3NWZ0FodmR5ZkJITlJEWk9MY0daTkxPdDJOVXo2Y2hQ?=
 =?big5?B?NjhHY2pQVDlvaHR6dlpia0hVd0ZOWHNIR1lCQk9ncVlIMnByRkY2RjlZTHhZajNr?=
 =?big5?B?SktUai96cUZPOTF4MlBldGNWVWFLOG4rM0N0Vmo5bGlGMGJaZlBGaHlmK0pFaDBr?=
 =?big5?B?NW1mSEFEU056ZlZyY3dYVVhsQ0RJeXl2MzQrSTlrOEhyc2IrN0RSekhCOVUrR2RT?=
 =?big5?B?bTMrQWNtRnh6eFNSSkVQMlE0T3FoSmpUQlFGWXJPUE1vcUl4eGlIREtyNFpOTnZJ?=
 =?big5?B?VDVrYW16VXBsbFNsUEI1OG5CRlExTGN0dENaaThsRU1CaDJiTklwVlM1YTZjUHcx?=
 =?big5?B?czYzNGZDeVFQaDZNUGw3WEhoSjVwb1I2M2E1cUtqd2tmZUFZTlFIZmRIN0Zpc25m?=
 =?big5?B?VStTdjVtSHZzbnpvMENoSENzUjdjWitvS05DdUxLS3RLWmYvSUk4SnFIblgwU2g4?=
 =?big5?B?TzVadDdIQS9XQnRDdGhLcWpVQUtCOVA5OVhjeFRRaEFKYllFempIY0VBMUE5S1hs?=
 =?big5?B?eDcvQUt1ZHAyR2w1TXZKeHg3Q1NJTTlGcFR4Y2Y4VFBpejdDMEpXWHNEakF5d3lt?=
 =?big5?Q?CyWros9La8V2AE+W?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR03MB3752
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,T_SPF_TEMPERROR,
        UNPARSEABLE_RELAY,URIBL_CSS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlIGNvbW1pdCBpZHMgYXJlIGxpc3RlZC4NCg0KTGludXMgdHJlZTogICAgMjNjMmQ0OTdkZTIx
ZjI1ODk4ZmJlYTcwYWViMjkyYWI4YWNjOGM5NA0KTGludXgtNS4xOS55OiAgMjNjMmQ0OTdkZTIx
ZjI1ODk4ZmJlYTcwYWViMjkyYWI4YWNjOGM5NA0KTGludXgtNS4xOC55OiAgMjNjMmQ0OTdkZTIx
ZjI1ODk4ZmJlYTcwYWViMjkyYWI4YWNjOGM5NA0KDQooYmFja3BvcnRlZCkNCkxpbnV4LTUuMTcu
eTogIDBkMmUwN2MwNGM3ZjdkODNjNzVjNTZkYTNlMmY5NzBjNTY1M2FkZTANCkxpbnV4LTUuMTUu
eTogIDcwZWE1ZTdiMzhjMzBiNjA4MjFlNDMyYWJkZTZmM2MzNTkyMjQxMzkNCkxpbnV4LTUuMTAu
eTogIDA2YzM0OGZkZTU0NWVjOTBlMjVkZTNlNWJjNGI4MTRiZmY3MGFlOWYNCkxpbnV4LTUuNC55
OiAgIDUzNGQwYWViZTE2NGZlOWFmZmYyYTU4ZmIxZDVmYjQ1OGQ4YTAzNmINCkxpbnV4LTQuMTku
eTogIDdmNGYwMjAyODZlMGJkNGFhZjQwNTEyYzgwYzYzYTVlNWJkNjI5YmMNCkxpbnV4LTQuMTQu
eTogIDA3ZjEwOGYxNWZkNzVhOWJmZjcwNGVlZDcxOGNjMTJmOTFiMDgwZGMNCkxpbnV4LTQuOS55
OiAgIDk2ZWI0ODA5OWE3ZTc0MDc2OGQyMTVhOTg5YjI2ZTBhZjczODEzNzENCg0KVGhhbmtzLg0K
DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogR3JlZyBLSCA8Z3JlZ0Brcm9haC5j
b20+IA0KU2VudDogVHVlc2RheSwgU2VwdGVtYmVyIDYsIDIwMjIgODowOSBQTQ0KVG86IFllZSBM
ZWUgKKf1q9i9yykgPFllZS5MZWVAbWVkaWF0ZWsuY29tPg0KQ2M6IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IHBhdHJpY2sud2FuZy5zaGNuQGdtYWlsLmNvbTsgc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZzsgQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT47IEFuZHJl
dyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+OyBNYXR0aGlhcyBCcnVnZ2VyIDxt
YXR0aGlhcy5iZ2dAZ21haWwuY29tPjsgb3BlbiBsaXN0Ok1FTU9SWSBNQU5BR0VNRU5UIDxsaW51
eC1tbUBrdmFjay5vcmc+OyBtb2RlcmF0ZWQgbGlzdDpBUk0vTWVkaWF0ZWsgU29DIHN1cHBvcnQg
PGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZz47IG1vZGVyYXRlZCBsaXN0OkFS
TS9NZWRpYXRlayBTb0Mgc3VwcG9ydCA8bGludXgtbWVkaWF0ZWtAbGlzdHMuaW5mcmFkZWFkLm9y
Zz4NClN1YmplY3Q6IFJlOiBbUEFUQ0ggNS4xNS55XSBSZXZlcnQgIm1tOiBrbWVtbGVhazogdGFr
ZSBhIGZ1bGwgbG93bWVtIGNoZWNrIGluIGttZW1sZWFrXypfcGh5cygpIg0KDQpPbiBUdWUsIFNl
cCAwNiwgMjAyMiBhdCAwMzowMzowNlBNICswODAwLCBtYWlsdG86eWVlLmxlZUBtZWRpYXRlay5j
b20gd3JvdGU6DQo+IEZyb206IFllZSBMZWUgPG1haWx0bzp5ZWUubGVlQG1lZGlhdGVrLmNvbT4N
Cj4gDQo+IFRoaXMgcmV2ZXJ0cyBjb21taXQgMjNjMmQ0OTdkZTIxZjI1ODk4ZmJlYTcwYWViMjky
YWI4YWNjOGM5NC4NCj4gDQo+IENvbW1pdCAyM2MyZDQ5N2RlMjEgKCJtbToga21lbWxlYWs6IHRh
a2UgYSBmdWxsIGxvd21lbSBjaGVjayBpbg0KPiBrbWVtbGVha18qX3BoeXMoKSIpIGJyb3VnaHQg
ZmFsc2UgbGVhayBhbGFybXMgb24gc29tZSBhcmNocyBsaWtlIGFybTY0IA0KPiB0aGF0IGRvZXMg
bm90IGluaXQgcGZuIGJvdW5kYXJ5IGluIGVhcmx5IGJvb3RpbmcuIFRoZSBmaW5hbCBzb2x1dGlv
biANCj4gbGFuZHMgb24gbGludXgtNi4wOiBjb21taXQgMGMyNGUwNjExOTZjICgibW06IGttZW1s
ZWFrOiBhZGQgcmJ0cmVlIGFuZCANCj4gc3RvcmUgcGh5c2ljYWwgYWRkcmVzcyBmb3Igb2JqZWN0
cyBhbGxvY2F0ZWQgd2l0aCBQQSIpLg0KPiANCj4gUmV2ZXJ0IHRoaXMgY29tbWl0IGJlZm9yZSBs
aW51eC02LjAuIFRoZSBvcmlnaW5hbCBpc3N1ZSBvZiBpbnZhbGlkIFBBIA0KPiBjYW4gYmUgbWl0
aWdhdGVkIGJ5IGFkZGl0aW9uYWwgY2hlY2sgaW4gZGV2aWNldHJlZS4NCj4gDQo+IFRoZSBmYWxz
ZSBhbGFybSByZXBvcnQgaXMgYXMgZm9sbG93aW5nOiBLbWVtbGVhayBvdXRwdXQ6IChRZW11L2Fy
bTY0KSANCj4gdW5yZWZlcmVuY2VkIG9iamVjdCAweGZmZmYwMDAwYzAxNzBhMDAgKHNpemUgMTI4
KToNCj4gICBjb21tICJzd2FwcGVyLzAiLCBwaWQgMSwgamlmZmllcyA0Mjk0ODkyNDA0IChhZ2Ug
MTI2LjIwOHMpDQo+ICAgaGV4IGR1bXAgKGZpcnN0IDMyIGJ5dGVzKToNCj4gIDYyIDYxIDczIDY1
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwICBiYXNlLi4uLi4uLi4uLi4uDQo+
ICAgICAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAgLi4u
Li4uLi4uLi4uLi4uLg0KPiAgIGJhY2t0cmFjZToNCj4gICAgIFs8KF9fX19wdHJ2YWxfX19fKT5d
IF9fa21hbGxvY190cmFja19jYWxsZXIrMHgxYjAvMHgyZTQNCj4gICAgIFs8KF9fX19wdHJ2YWxf
X19fKT5dIGtzdHJkdXBfY29uc3QrMHg4Yy8weGM0DQo+ICAgICBbPChfX19fcHRydmFsX19fXyk+
XSBrdmFzcHJpbnRmX2NvbnN0KzB4YmMvMHhlYw0KPiAgICAgWzwoX19fX3B0cnZhbF9fX18pPl0g
a29iamVjdF9zZXRfbmFtZV92YXJncysweDU4LzB4ZTQNCj4gICAgIFs8KF9fX19wdHJ2YWxfX19f
KT5dIGtvYmplY3RfYWRkKzB4ODQvMHgxMDANCj4gICAgIFs8KF9fX19wdHJ2YWxfX19fKT5dIF9f
b2ZfYXR0YWNoX25vZGVfc3lzZnMrMHg3OC8weGVjDQo+ICAgICBbPChfX19fcHRydmFsX19fXyk+
XSBvZl9jb3JlX2luaXQrMHg2OC8weDEwNA0KPiAgICAgWzwoX19fX3B0cnZhbF9fX18pPl0gZHJp
dmVyX2luaXQrMHgyOC8weDQ4DQo+ICAgICBbPChfX19fcHRydmFsX19fXyk+XSBkb19iYXNpY19z
ZXR1cCsweDE0LzB4MjgNCj4gICAgIFs8KF9fX19wdHJ2YWxfX19fKT5dIGtlcm5lbF9pbml0X2Zy
ZWVhYmxlKzB4MTEwLzB4MTc4DQo+ICAgICBbPChfX19fcHRydmFsX19fXyk+XSBrZXJuZWxfaW5p
dCsweDIwLzB4MWEwDQo+ICAgICBbPChfX19fcHRydmFsX19fXyk+XSByZXRfZnJvbV9mb3JrKzB4
MTAvMHgyMA0KPiANCj4gVGhpcyBwYWN0aCBpcyBhbHNvIGFwcGxpY2FibGUgdG8gDQo+IGxpbnV4
LTUuMTcueS9saW51eC01LjE4LnkvbGludXgtNS4xOS55DQo+IA0KPiBDYzogPG1haWx0bzpzdGFi
bGVAdmdlci5rZXJuZWwub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBZZWUgTGVlIDxtYWlsdG86eWVl
LmxlZUBtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAgbW0va21lbWxlYWsuYyB8IDggKysrKy0tLS0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQoNCldo
YXQgaXMgdGhlIGdpdCBjb21taXQgaWQgb2YgdGhpcyBjaGFuZ2UgaW4gTGludXMncyB0cmVlPw0K
DQpBbmQgd2hhdCBhYm91dCBvbGRlciBzdGFibGUgdHJlZXMgd2l0aCB0aGlzIGNvbW1pdCBpbiBp
dD8NCg0KdGhhbmtzLA0KDQpncmVnIGstaA0K
