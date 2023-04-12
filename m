Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9936DE968
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 04:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjDLC2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 22:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLC2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 22:28:13 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9331BC8;
        Tue, 11 Apr 2023 19:28:02 -0700 (PDT)
X-UUID: a33a7c04d8d911edb6b9f13eb10bd0fe-20230412
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=YNQZZip6q/pEwq6SXvzVc3jwtnHEZCLuDTDEOwIYK6w=;
        b=b5r1U+Eh1orbj/n7rlBWaRHQi+iObUoP71yGfN+vIdaJtoaCqCCeGh0lDZsgHD46EgirkU3KT8soBpxp60OiTQrFkJUbrrQvFyww3V+daYZsHG8VvL1lH36YdYMEtI3xL1/11sO9jlbsa5X/26HxqLOD3B35180UfR6kR8foinU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:1910b7f1-0c9a-4096-a03d-487a53ccd977,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.22,REQID:1910b7f1-0c9a-4096-a03d-487a53ccd977,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:120426c,CLOUDID:21da05a1-8fcb-430b-954a-ba3f00fa94a5,B
        ulkID:230412004414VIL05J2N,BulkQuantity:17,Recheck:0,SF:19|17|102,TC:nil,C
        ontent:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:
        0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: a33a7c04d8d911edb6b9f13eb10bd0fe-20230412
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
        (envelope-from <tze-nan.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 639580478; Wed, 12 Apr 2023 10:27:57 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 12 Apr 2023 10:27:56 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Wed, 12 Apr 2023 10:27:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8IkkMLHCMyffTFToy1Mr+UaGnSdsJYqML3annma52j5aSFGlgBmNiJC/4/ny6OYNj4++fLvZdIXDzhvZQTpHYMx78PUWI8Ji+7/CEF/UyVYmJk3kfWlKUIkLsnOX2kCDPvuXquS/jvziLP1ZumaCes8UXUA5FVhvs55XuZkSk9CyttoBS0AgLIeQ8DEgA9psGQUUSSMsoPeFrtQa5KDNU5oZI8ZPrrQ2nJk7/08F5HCs0yyJ/Y5Mk6oJykBG0L4+f/1cFwANMPksMpo3qzXYjnwpxAqHJHB9wZwTQ9kdvaQUZkNpH/RwYVBQSPDpkCEY8l6H0AhAp/rDsSDHcgSDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNQZZip6q/pEwq6SXvzVc3jwtnHEZCLuDTDEOwIYK6w=;
 b=KQf8yogVUozT2KQbir6z28yLeRNXNq+2jU/Mi1uFGc00DJs7dBgpWuriXw9JpmuhPhugx+0KFdDewnZmM6FQJ08T2hNT3oBr1Q0kjFnJ7l+d9axv+vXIr+qJoghFogxccrFA52ZeWLHHJSSsiKO9mxP+cZ9nKFgE+LF6yqu2vOHOcLVMEdt/B8bUJmVO+fa6zvu97D9dv+KmJDDJTj8wQAfDIEWj2rj1rqUSlPJ83/lWT0Ba1D/Mriw9wyfZ/YfOUkuXEyqMSxV7HeUqlLWHr66BSOPcWny5a1ZSLB5tnzX1BZDox/Ibd3QmYMWm5oYiBAkefLHGeaRZdai5FAY62Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNQZZip6q/pEwq6SXvzVc3jwtnHEZCLuDTDEOwIYK6w=;
 b=Wwxu7ls5KU4j2YXGccFfhFINUyqsnPDIcahgxIRCKMNkiaJ9vYdbr5P0NddzK/Wdyj8FRNNsAkg+n8D+e+HOhcLpSk90VTjBZxAmZt3ZIXSbzGWHc08D19uHTl46K/MARGDV/mO9rAczzXFak0YwGhSoi7DGEPxDvh3weaJ/CQU=
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com (2603:1096:400:33a::11)
 by TYUPR03MB7085.apcprd03.prod.outlook.com (2603:1096:400:358::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 02:27:54 +0000
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::ec58:cfe8:ee7e:e344]) by TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::ec58:cfe8:ee7e:e344%4]) with mapi id 15.20.6254.030; Wed, 12 Apr 2023
 02:27:53 +0000
From:   =?utf-8?B?VHplLW5hbiBXdSAo5ZCz5r6k5Y2XKQ==?= 
        <Tze-nan.Wu@mediatek.com>
To:     "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?Q2hlbmctSnVpIFdhbmcgKOeOi+ato+edvyk=?= 
        <Cheng-Jui.Wang@mediatek.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        =?utf-8?B?Qm9idWxlIENoYW5nICjlvLXlvJjnvqkp?= 
        <bobule.chang@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>
Subject: Re: [PATCH v3] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Thread-Topic: [PATCH v3] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Thread-Index: AQHZa38KrpoyHt4TVEOuF1N51i1qDq8mUqeAgACjHgA=
Date:   Wed, 12 Apr 2023 02:27:53 +0000
Message-ID: <ef0ebc2f0f934ff5c35719f1960d24a5838ff770.camel@mediatek.com>
References: <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
         <20230410073512.13362-1-Tze-nan.Wu@mediatek.com>
         <20230411124403.2a31e12d@gandalf.local.home>
In-Reply-To: <20230411124403.2a31e12d@gandalf.local.home>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB7183:EE_|TYUPR03MB7085:EE_
x-ms-office365-filtering-correlation-id: daef61b9-fa59-4815-059a-08db3afd84f2
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j9V0aWTTAc1BxJoBGdkOw62W4FS2LM9fjBhmoHrJcul3GVChpytaedq7Xre11gVIsfBi/5VK315Etgr4aNKUL1rHfv/6/xTVAuK9qktpswoL4GIOmBqs0QHSDP7NGdaeYaYtMWaW6vmGOZwnw8y8j3iq/lnTCB0x9bAsS4jaVV8F8Kw8tXMD+EzMBFzLvRYLbyZGt9I2+mdmQajKR73WFlO2YDAc2HJikysocuaPJOv/rLSlC7HmAWyHjYFqT+2eB8MzL/d4Z9sMT/mdlRvQGFclJowaLfIr8vq23kV3IvDANY8K/CteoH/sMQG+aLTyf0/GyfKzlODKm5se1vypu7LU5jMUPIBOE2qExVUtJhK+pe6n3gdgjHqEIw35mZECuoqN5W5+evTr0iZgk8Qx5OfU3NUbiHRpPvE92tcd82iFKyCOArTXEzVXuY6V2XfYJsEPDQ77RWDIPi3FPUKOYaxxmoBrpMn3rlhAv8Fn4rPb60QFL7uzOuBBbt4JGWtpZOa68bISGlzjRYY3EV2eGL6dvUsOUxEqvx6NDqgSCjhgaXUL5izVPXOHSq4Ls/JqFiuUaodnojg+njUJvWMPtBmfYzQKcDby4O1ZU01SH8l7NZ2oox+qH9ne3YDoiC5S+oZpX38yuj8F1YlGfGyvoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB7183.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199021)(71200400001)(478600001)(86362001)(83380400001)(6512007)(36756003)(85182001)(122000001)(2616005)(38070700005)(38100700002)(966005)(2906002)(26005)(316002)(54906003)(6506007)(186003)(5660300002)(64756008)(6486002)(7416002)(66476007)(8676002)(6916009)(66556008)(8936002)(41300700001)(4326008)(66446008)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dC9WMk5kZFZwYWVPOWZ3dGxaWHl5WjNCTS9OdXRQdUZkeE9YY3ZLMkRlbVI2?=
 =?utf-8?B?bXRKTEtjYVBsK3ZKTGQ1NW9IWlBwZVpML0diVVhZQ3BzTU5DWERRSE1maXJr?=
 =?utf-8?B?RlNwVUM1a0RRNEY2aHZ5WDhZWWRWWG0vTSs0ZHZQNnRiQmQ4MnM2R2JqVXox?=
 =?utf-8?B?QVNEdzcvQW1VVjJTcWtNZmpGZys3bGRDRlVXZzZWWFFJVDJTeG1NdG9RZlpm?=
 =?utf-8?B?NjRuY2pya3U5RW5JUEJBV1ZrdDBlZCtXcGRxTE5TQnRGTnFjZlFqOVlBVE1M?=
 =?utf-8?B?TGZ0YnZUcFRkb25QOTRkY1pXbkpGL3QvLysxRzNuREhGbG9tbWN5UlpiblJu?=
 =?utf-8?B?dHJIR3RBZkFtQzh3TXFrN0I4M0lrczY5d0E3RysraVhJQ2lxZGtQeVBRdjFF?=
 =?utf-8?B?NExFRWl0Q0cxZFBGOGtHYW1rb0dNaXVwVXF5eE5zeGdackh2YkFTMzlhSnRv?=
 =?utf-8?B?YWYvRXpaWFJkSDBQNDhCVHJXVG1zaW9ybFNzdENMTWNvaVNqT2tWZE9VMDlm?=
 =?utf-8?B?VkhxcTNTMGRoQitHWmQ0NUZRSUMzd0ZFbjFIL1RPVGI2bGZvR3lVU0FrY3JP?=
 =?utf-8?B?WEZ4M3lDSWp2SUtSQk54aGtXckFMMHNIUGFGbFAwWG1WVi9TUHUvbnJnWFM2?=
 =?utf-8?B?dEwwTlNvUEQwTVByRUdmeTFlL1hmSE5sV1FLUUkzUVVXWXE3Y2lXSmhWRFJY?=
 =?utf-8?B?Qk9OSjJwWTJ3dmpmdEJUajIwV1crRUI1MXBacWM3S3U4TzdVQTJiQ1lEOFZa?=
 =?utf-8?B?WEdtS2U3ZzFNMjFzUEY0Si8zSTBxRkxUWExxMkgwVUZ6S2pTTjZkNG1tRnlm?=
 =?utf-8?B?em5IRm9Od3dSRUsrT1RLMHIwNXVTS1R6ajROVHM1WkxDQUEvREtkYkllbEtq?=
 =?utf-8?B?cmxYc2w4M0pLUlh0clpVM3ZuUzdkcVZwV2dyTnpYK013VDVQM2gyVmM0UXRo?=
 =?utf-8?B?SHlCMFBTblh2NklySE1DeXR0WkFTUGdvV0g3dVRyZGh5OFlKakhVTXF4RXdh?=
 =?utf-8?B?cmZNeGhPbGFaTWlKdVRkMFN0RGdWK2t3Unc5Q3FScXhOU1hnZFZzTEpTR2Er?=
 =?utf-8?B?eFVLeVFnL1ZQMUpLQnhqd29OZ2lhcklWbEZ4bW51ODdpL3l2czYva0ViK0lB?=
 =?utf-8?B?SzRBOFFqakhJQzA1V1JlN3hydVpncW1qNXdNUWVMOHYrM0c1aDNEY1kwUm5a?=
 =?utf-8?B?OStLT1JBMStIaVlGNjB0Skg3YUxtTDlhWDIxd3lGd1oydXdOdVJVTlVTRW9x?=
 =?utf-8?B?eHUvT2J2SGFFbjlPdFhLa2JETXhkVTVEdTU3MTE0aUVJazEwcnZRTlFwbm4z?=
 =?utf-8?B?QUpzblpJUkVDMnA3a1lYZkdyelpYNW9jc0xsR0hSWDE5SlJHTkE5dE0zZGZP?=
 =?utf-8?B?U0pmejNaY0tGcUJmSTdQeDhCa1IvdEN6VUlUam5sL1FnY2J1Q2NnSzIyMVVl?=
 =?utf-8?B?Q2I3aW5LOVB2ZFluQjBzeTdxSTArVTF3QmZZKzZ4akVMeXpIOHFKbmJnT3pY?=
 =?utf-8?B?akhqV0JRMHJXTE1kcUlBalpJeFRCbDhCeXJnMEQvVWlDY1FYUkprM2s0aTZn?=
 =?utf-8?B?citucW9wMExHT2ZHY3dKcXczbTQwaG4xelV6cGkvaEpnQm9oYm9RUXA0WlV4?=
 =?utf-8?B?d0tCTjE2RDVaZTV0SUhUa2JxbTRDU2M4VjhUY3FWVk12VnNtS0hLNE5zNEJk?=
 =?utf-8?B?UGdjZmFoSlg1aHB2QnZlSnNjaWZpbmkrUEQ1SFpsU01STXdwUCtlZjFRb2Vs?=
 =?utf-8?B?VkdoTGRjVjBzbFQxeFZuaHpDRlF4V3ZIdEpxd21ZblRUZndFRzFUcDljeTBN?=
 =?utf-8?B?QlgreTV2alNNbGVEdU1YWHhKK1VsUjllQTg2dVhEVVhYSy9uVFlMUlc0VTRF?=
 =?utf-8?B?dVlUWnhwSHVVTzh6LzhhM1d0RVcxSG8xSVFRTHA5YlFWTnFwdTZuVGFTSlpv?=
 =?utf-8?B?K0hRZE0wemVPN0NxM3FNRytkUHFpK0ErWjhpcENsR3E2ekgzVVpXa1kzQ0VS?=
 =?utf-8?B?b2NVNlkvSm1FV3FtelpuaXpVWVdSVFdkMXBPSHZ5QW1aZzU3MEN5Z2l1RlNB?=
 =?utf-8?B?OUJTbVM5MUZDbnBuUU5KWlBuTXpTbUZOd1NlZFAxYzkvRjNkdEFJRnNGUWtR?=
 =?utf-8?B?dUVheXdZRFRYOURoNFpqZ3l6S1NXQmQ0bDFVNkpFS1JDL1FNSnBvR1VOcmpL?=
 =?utf-8?B?NXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C732BAC6B706A346B079DCEE0BB9914C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB7183.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daef61b9-fa59-4815-059a-08db3afd84f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 02:27:53.4087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IWpdm+pgR1nAZg+XpQZBaej8etXd46unF6Xkh+Awn0m5VArDYcTma8dTUNGivJjBQYTYKE2+5cAMhTQasMnYSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7085
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgU3RldmUsDQoNCk9uIFR1ZSwgMjAyMy0wNC0xMSBhdCAxMjo0NCAtMDQwMCwgU3RldmVuIFJv
c3RlZHQgd3JvdGU6DQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5r
cyBvciBvcGVuIGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5k
ZXIgb3IgdGhlIGNvbnRlbnQuDQo+IA0KPiANCj4gUGxlYXNlIGhhdmUgZWFjaCBuZXcgcGF0Y2gg
YmUgYSBuZXcgdGhyZWFkLCBhbmQgbm90IGEgQ2MgdG8gdGhlDQo+IHByZXZpb3VzDQo+IHZlcnNp
b24gb2YgdGhlIHBhdGNoLiBBcyBpdCBtYWtlcyBpdCBoYXJkIHRvIGZpbmQgaW4gSU5CT1hzLg0K
PiANCg0KTm8gcHJvYmxlbSwgZ290IGl0Lg0KDQo+IE9uIE1vbiwgMTAgQXByIDIwMjMgMTU6MzU6
MDggKzA4MDANCj4gVHplLW5hbiBXdSA8VHplLW5hbi5XdUBtZWRpYXRlay5jb20+IHdyb3RlOg0K
PiANCj4gPiBXcml0ZSB0byBidWZmZXJfc2l6ZV9rYiBjYW4gcGVybWFuZW50bHkgZmFpbCwgZHVl
IHRvDQo+ID4gY3B1X29ubGluZV9tYXNrIG1heQ0KPiA+IGNoYW5nZWQgYmV0d2VlbiB0d28gZm9y
X2VhY2hfb25saW5lX2J1ZmZlcl9jcHUgbG9vcHMuDQo+ID4gVGhlIG51bWJlciBvZiBpbmNyZWFz
aW5nIGFuZCBkZWNyZWFzaW5nIG9uIGNwdV9idWZmZXItDQo+ID4gPnJlc2l6ZV9kaXNhYmxlDQo+
ID4gbWF5IGJlIGluY29uc2lzdGVudCwgbGVhZGluZyB0aGF0IHRoZSByZXNpemVfZGlzYWJsZWQg
aW4gc29tZSBDUFVzDQo+ID4gYmVjb21pbmcgbm9uZSB6ZXJvIGFmdGVyIHJpbmdfYnVmZmVyX3Jl
c2V0X29ubGluZV9jcHVzIHJldHVybi4NCj4gPiANCj4gPiBUaGlzIGlzc3VlIGNhbiBiZSByZXBy
b2R1Y2VkIGJ5ICJlY2hvIDAgPiB0cmFjZSIgd2hpbGUgaG90cGx1Z2dpbmcNCj4gPiBjcHUuDQo+
ID4gQWZ0ZXIgcmVwcm9kdWNpbmcgc3VjY2Vzcywgd2UgY2FuIGZpbmQgb3V0IGJ1ZmZlcl9zaXpl
X2tiIHdpbGwgbm90DQo+ID4gYmUNCj4gPiBmdW5jdGlvbmFsIGFueW1vcmUuDQo+ID4gDQo+ID4g
UHJldmVudCB0aGUgdHdvICJsb29wcyIgaW4gdGhpcyBmdW5jdGlvbiBmcm9tIGl0ZXJhdGluZyB0
aHJvdWdoDQo+ID4gZGlmZmVyZW50DQo+ID4gb25saW5lIGNwdXMgYnkgY29weWluZyBjcHVfb25s
aW5lX21hc2sgYXQgdGhlIGVudHJ5IG9mIHRoZQ0KPiA+IGZ1bmN0aW9uLg0KPiA+IA0KPiANCj4g
VGhlICJDaGFuZ2VzIGZyb20iIG5lZWQgdG8gZ28gYmVsb3cgIHRoZSAnLS0tJywgb3RoZXJ3aXNl
IHRoZXkgYXJlDQo+IGFkZGVkIHRvDQo+IHRoZSBnaXQgY29tbWl0ICh3ZSBkb24ndCB3YW50IGl0
IHRoZXJlKS4NCj4gDQoNCldpbGwgcmVtZW1iZXIgdGhpcywgd29uJ3QgaGFwcGVuZWQgbmV4dCB0
aW1lIDopDQoNCj4gPiBDaGFuZ2VzIGZyb20gdjEgdG8gdjM6DQo+ID4gICBEZWNsYXJlIHRoZSBj
cHVtYXNrIHZhcmlhYmxlIHN0YXRpY2FsbHkgcmF0aGVyIHRoYW4gZHluYW1pY2FsbHkuDQo+ID4g
DQo+ID4gQ2hhbmdlcyBmcm9tIHYyIHRvIHYzOg0KPiA+ICAgQ29uc2lkZXJpbmcgaG9sZGluZyBj
cHVfaG90cGx1Z19sb2NrIHRvbyBsb25nIGJlY2F1c2Ugb2YgdGhlDQo+ID4gICBzeW5jaHJvbml6
ZV9yY3UoKSwgbWF5YmUgaXQncyBiZXR0ZXIgdG8gcHJldmVudCB0aGUgaXNzdWUgYnkNCj4gPiBj
b3B5aW5nDQo+ID4gICBjcHVfb25saW5lX21hc2sgYXQgdGhlIGVudHJ5IG9mIHRoZSBmdW5jdGlv
biBhcyBWMSBkb2VzLCBpbnN0ZWFkDQo+ID4gb2YNCj4gPiAgIHVzaW5nIGNwdXNfcmVhZF9sb2Nr
KCkuDQo+ID4gDQo+ID4gTGluazogDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8y
MDIzMDQwODA1MjIyNi4yNTI2OC0xLVR6ZS1uYW4uV3VAbWVkaWF0ZWsuY29tLw0KPiA+IExpbms6
IA0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL29lLWtidWlsZC1hbGwvMjAyMzA0MDgyMDUx
LkRwNTB1cGZTLWxrcEBpbnRlbC5jb20vDQo+ID4gTGluazogDQo+ID4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvb2Uta2J1aWxkLWFsbC8yMDIzMDQwODE2MTUuZWlhcXBiVjgtbGtwQGludGVsLmNv
bS8NCj4gPiANCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+IENjOiBucGlnZ2lu
QGdtYWlsLmNvbQ0KPiA+IEZpeGVzOiBiMjNkN2E1ZjRhMDcgKCJyaW5nLWJ1ZmZlcjogc3BlZWQg
dXAgYnVmZmVyIHJlc2V0cyBieQ0KPiA+IGF2b2lkaW5nIHN5bmNocm9uaXplX3JjdSBmb3IgZWFj
aCBDUFUiKQ0KPiA+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNv
bT4NCj4gPiBSZXZpZXdlZC1ieTogQ2hlbmctSnVpIFdhbmcgPGNoZW5nLWp1aS53YW5nQG1lZGlh
dGVrLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUemUtbmFuIFd1IDxUemUtbmFuLld1QG1lZGlh
dGVrLmNvbT4NCj4gPiAtLS0NCj4gDQo+IFRoaXMgaXMgd2hlcmUgdGhlICJDaGFuZ2VzIGZyb20i
IGdvLiBBbmQgc2luY2UgdGhpcyBwYXRjaCBpcyBub3QNCj4gc3VwcG9zZSB0bw0KPiBiZSBhIENj
LiBCdXQgc2luY2UgaXQncyBzdGlsbCBnb29kIHRvIGhhdmUgYSBsaW5rIHRvIGl0LiBZb3UgY291
bGQNCj4gZG86DQo+IA0KPiBDaGFuZ2VzIGZyb20gdjIgdG8gdjM6IA0KPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9saW51eC10cmFjZS1rZXJuZWwvMjAyMzA0MDkwMjQ2MTYuMzEwOTktMS1UemUt
bmFuLld1QG1lZGlhdGVrLmNvbS8NCj4gICBDb25zaWRlcmluZyBob2xkaW5nIGNwdV9ob3RwbHVn
X2xvY2sgdG9vIGxvbmcgYmVjYXVzZSBvZiB0aGUNCj4gICBzeW5jaHJvbml6ZV9yY3UoKSwgbWF5
YmUgaXQncyBiZXR0ZXIgdG8gcHJldmVudCB0aGUgaXNzdWUgYnkNCj4gY29weWluZw0KPiAgIGNw
dV9vbmxpbmVfbWFzayBhdCB0aGUgZW50cnkgb2YgdGhlIGZ1bmN0aW9uIGFzIFYxIGRvZXMsIGlu
c3RlYWQgb2YNCj4gICB1c2luZyBjcHVzX3JlYWRfbG9jaygpLg0KPiANCj4gDQo+IFdoZXJlIHRo
ZSBwcmV2aW91cyB2ZXJzaW9uIGNoYW5nZXMgaGFzIHRoZSBsb3JlIGxpbmsgdG8gdGhlIHByZXZp
b3VzDQo+IHBhdGNoLA0KPiBpbiBjYXNlIHNvbWVvbmUgd2FudHMgdG8gbG9vayBhdCBpdC4NCj4g
DQoNClN1cmUsIGEgbGluayBoZXJlIGlzIHJlYWxseSBoZWxwZnVsLg0KV2lsbCBmb2xsb3cgdGhp
cyBmb3JtYXQgaW4gdGhlIGZ1dHVyZS4NCg0KPiANCj4gPiAga2VybmVsL3RyYWNlL3JpbmdfYnVm
ZmVyLmMgfCAxNCArKysrKysrKystLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRp
b25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9rZXJuZWwvdHJh
Y2UvcmluZ19idWZmZXIuYw0KPiA+IGIva2VybmVsL3RyYWNlL3JpbmdfYnVmZmVyLmMNCj4gPiBp
bmRleCA3NmEyZDkxZWVjYWQuLmRjNzU4OTMwZGFjYiAxMDA2NDQNCj4gPiAtLS0gYS9rZXJuZWwv
dHJhY2UvcmluZ19idWZmZXIuYw0KPiA+ICsrKyBiL2tlcm5lbC90cmFjZS9yaW5nX2J1ZmZlci5j
DQo+ID4gQEAgLTI4OCw5ICsyODgsNiBAQCBFWFBPUlRfU1lNQk9MX0dQTChyaW5nX2J1ZmZlcl9l
dmVudF9kYXRhKTsNCj4gPiAgI2RlZmluZSBmb3JfZWFjaF9idWZmZXJfY3B1KGJ1ZmZlciwgY3B1
KSAgICAgICAgICAgICBcDQo+ID4gICAgICAgZm9yX2VhY2hfY3B1KGNwdSwgYnVmZmVyLT5jcHVt
YXNrKQ0KPiA+IA0KPiA+IC0jZGVmaW5lIGZvcl9lYWNoX29ubGluZV9idWZmZXJfY3B1KGJ1ZmZl
ciwgY3B1KSAgICAgICAgICAgICAgXA0KPiA+IC0gICAgIGZvcl9lYWNoX2NwdV9hbmQoY3B1LCBi
dWZmZXItPmNwdW1hc2ssIGNwdV9vbmxpbmVfbWFzaykNCj4gPiAtDQo+ID4gICNkZWZpbmUgVFNf
U0hJRlQgICAgIDI3DQo+ID4gICNkZWZpbmUgVFNfTUFTSyAgICAgICAgICAgICAgKCgxVUxMIDw8
IFRTX1NISUZUKSAtIDEpDQo+ID4gICNkZWZpbmUgVFNfREVMVEFfVEVTVCAgICAgICAgKH5UU19N
QVNLKQ0KPiA+IEBAIC01MzUzLDEyICs1MzUwLDE5IEBAIEVYUE9SVF9TWU1CT0xfR1BMKHJpbmdf
YnVmZmVyX3Jlc2V0X2NwdSk7DQo+ID4gIHZvaWQgcmluZ19idWZmZXJfcmVzZXRfb25saW5lX2Nw
dXMoc3RydWN0IHRyYWNlX2J1ZmZlciAqYnVmZmVyKQ0KPiA+ICB7DQo+ID4gICAgICAgc3RydWN0
IHJpbmdfYnVmZmVyX3Blcl9jcHUgKmNwdV9idWZmZXI7DQo+ID4gKyAgICAgY3B1bWFza190IHJl
c2V0X29ubGluZV9jcHVtYXNrOw0KPiANCj4gSXQncyB1c3VhbGx5IGNvbnNpZGVyZWQgYmFkIGZv
cm0gdG8gcHV0IGEgY3B1bWFzayBvbiB0aGUgc3RhY2suIEFzIGl0DQo+IGNhbg0KPiBiZSAxMjgg
Ynl0ZXMgZm9yIGEgbWFjaGluZSB3aXRoIDEwMjQgQ1BVcyAoYW5kIHllcyB0aGV5IGRvIGV4aXN0
KS4NCj4gQWxzbywNCj4gdGhlIG1hc2sgc2l6ZSBpcyBzZXQgdG8gTlJfQ1BVUyBub3QgdGhlIGFj
dHVhbCBzaXplLCBzbyB5b3UgZG8gbm90DQo+IGV2ZW4NCj4gbmVlZCB0byBoYXZlIGl0IHRoYXQg
YmlnLg0KPiANCg0KTmV2ZXIgdGhvdWdodCBhYm91dCB0aGF0IHVudGlsIHlvdSB0b2xkIG1lLA0K
SSB3aWxsIGtlZXAgaXQgaW4gbWluZCBiZWZvcmUgZGVjbGFyZSBhIGNwdW1hc2sgbmV4dCB0aW1l
Lg0KDQo+IA0KPiA+ICAgICAgIGludCBjcHU7DQo+ID4gDQo+ID4gKyAgICAgLyoNCj4gPiArICAg
ICAgKiBSZWNvcmQgY3B1X29ubGluZV9tYXNrIGhlcmUgdG8gbWFrZSBzdXJlIHdlIGl0ZXJhdGUN
Cj4gPiB0aHJvdWdoIHRoZSBzYW1lDQo+ID4gKyAgICAgICogb25saW5lIENQVXMgaW4gdGhlIGZv
bGxvd2luZyB0d28gbG9vcHMuDQo+ID4gKyAgICAgICovDQo+ID4gKyAgICAgY3B1bWFza19jb3B5
KCZyZXNldF9vbmxpbmVfY3B1bWFzaywgY3B1X29ubGluZV9tYXNrKTsNCj4gPiArDQo+ID4gICAg
ICAgLyogcHJldmVudCBhbm90aGVyIHRocmVhZCBmcm9tIGNoYW5naW5nIGJ1ZmZlciBzaXplcyAq
Lw0KPiA+ICAgICAgIG11dGV4X2xvY2soJmJ1ZmZlci0+bXV0ZXgpOw0KPiA+IA0KPiA+IC0gICAg
IGZvcl9lYWNoX29ubGluZV9idWZmZXJfY3B1KGJ1ZmZlciwgY3B1KSB7DQo+ID4gKyAgICAgZm9y
X2VhY2hfY3B1X2FuZChjcHUsIGJ1ZmZlci0+Y3B1bWFzaywgJnJlc2V0X29ubGluZV9jcHVtYXNr
KQ0KPiA+IHsNCj4gPiAgICAgICAgICAgICAgIGNwdV9idWZmZXIgPSBidWZmZXItPmJ1ZmZlcnNb
Y3B1XTsNCj4gPiANCj4gPiAgICAgICAgICAgICAgIGF0b21pY19pbmMoJmNwdV9idWZmZXItPnJl
c2l6ZV9kaXNhYmxlZCk7DQo+IA0KPiBBbnl3YXksIHdlIGRvbid0IG5lZWQgdG8gbW9kaWZ5IGFu
eSBvZiB0aGUgYWJvdmUsIGFuZCBqdXN0IGRvIHRoZQ0KPiBmb2xsb3dpbmcNCj4gaW5zdGVhZCBv
ZiBhdG9taWNfaW5jKCk6DQo+IA0KPiAjZGVmaW5lIFJFU0VUX0JJVCAgICAgICAoMSA8PCAzMCkN
Cj4gDQo+ICAgICAgICAgICAgICAgICBhdG9taWNfYWRkKCZjcHVfYnVmZmVyLT5yZXNpemVfZGlz
YWJsZWQsIFJFU0VUX0JJVCk7DQo+IA0KPiANCj4gPiBAQCAtNTM2OCw3ICs1MzcyLDcgQEAgdm9p
ZCByaW5nX2J1ZmZlcl9yZXNldF9vbmxpbmVfY3B1cyhzdHJ1Y3QNCj4gPiB0cmFjZV9idWZmZXIg
KmJ1ZmZlcikNCj4gPiAgICAgICAvKiBNYWtlIHN1cmUgYWxsIGNvbW1pdHMgaGF2ZSBmaW5pc2hl
ZCAqLw0KPiA+ICAgICAgIHN5bmNocm9uaXplX3JjdSgpOw0KPiA+IA0KPiA+IC0gICAgIGZvcl9l
YWNoX29ubGluZV9idWZmZXJfY3B1KGJ1ZmZlciwgY3B1KSB7DQo+ID4gKyAgICAgZm9yX2VhY2hf
Y3B1X2FuZChjcHUsIGJ1ZmZlci0+Y3B1bWFzaywgJnJlc2V0X29ubGluZV9jcHVtYXNrKQ0KDQpN
YXliZSB3ZSBzaG91bGQgdXNlIGZvcl9lYWNoX2J1ZmZlcl9jcHUoYnVmZmVyLCBjcHUpIGhlcmU/
DQpzaW5jZSBhIENQVSBtYXkgYWxzbyBjYW1lIG9mZmxpbmUgZHVyaW5nIHN5bmNocm9uaXplX3Jj
dSgpLg0KDQo+ID4gew0KPiA+ICAgICAgICAgICAgICAgY3B1X2J1ZmZlciA9IGJ1ZmZlci0+YnVm
ZmVyc1tjcHVdOw0KPiANCj4gVGhlbiBoZXJlIHdlIGNhbiBkbzoNCj4gDQo+ICAgICAgICAgICAg
ICAgICAvKg0KPiAgICAgICAgICAgICAgICAgICogSWYgYSBDUFUgY2FtZSBvbmxpbmUgZHVyaW5n
IHRoZSBzeW5jaHJvbml6ZV9yY3UoKSwNCj4gdGhlbg0KPiAgICAgICAgICAgICAgICAgICogaWdu
b3JlIGl0Lg0KPiAgICAgICAgICAgICAgICAgICovDQo+ICAgICAgICAgICAgICAgICBpZiAoIWF0
b21pY19yZWFkKCZjcHVfYnVmZmVyLT5yZXNpemVfZGlzYWJsZWQpICYNCj4gUkVTRVRfQklUKSkN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+IA0KPiAgICAgICAgICAgICAg
ICAgYXRvbWljX3N1YigmY3B1X2J1ZmZlci0+cmVzaXplX2Rpc2FibGVkLCBSRVNFVF9CSVQpOw0K
PiANCj4gDQo+IEFzIHRoZSByZXNpemVfZGlzYWJsZWQgb25seSBuZWVkcyB0byBiZSBzZXQgdG8g
c29tZXRoaW5nIHRvIG1ha2UgaXQNCj4gZGlzYWJsZWQuDQo+IA0KPiAtLSBTdGV2ZQ0KPiANCg0K
VGhhbmtzIGZvciBhbGwgeW91ciBzdWdnZXN0aW9ucywgbGVhcm4gYSBsb3QgZnJvbSBoZXJlLCBy
ZWFsbHkNCmFwcHJpY2lhdGUgOikuDQpJIHdpbGwgdXBsb2FkIGEgdjQgcGF0Y2ggaW4gbmV3IHRo
cmVhZCBhcyBzb29uIGFzIHRoZSBuZXcgcGF0Y2ggcGFzcyBteQ0KdGVzdC4NCg0KLS0gVHplbmFu
DQoNCg0KPiA+IA0KPiA+ICAgICAgICAgICAgICAgcmVzZXRfZGlzYWJsZWRfY3B1X2J1ZmZlcihj
cHVfYnVmZmVyKTsNCj4gDQo+IA0K
