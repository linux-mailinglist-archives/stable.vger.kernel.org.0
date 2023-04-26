Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3483D6EEE72
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 08:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbjDZGjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 02:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbjDZGje (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 02:39:34 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7505510DE;
        Tue, 25 Apr 2023 23:39:31 -0700 (PDT)
X-UUID: 17a17042e3fd11eda9a90f0bb45854f4-20230426
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XTzJHsou+Z4/Lsj7q9FjMbty9LkhENmUxNnxM4WtAA4=;
        b=JJxvU3Dl1GMhMISbffU5nnAXwI5zJmv/BD/ZOA6RyvxOANsdlL9hf49hJ8vZzeTszx6SBuPjyhLR9pKpWyijIxPnHs71mLeIVL3paOVfbG3kSD2WtNvvz+kfOB8PaCSoO1kOC3hkgK+8Qd0GZmqCKuk4l9GO10OK1VYRU2BG1r0=;
X-CID-UNFAMILIAR: 1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:a9b49bed-1a2e-4525-b2ad-f6ad024be5dc,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:4,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:4
X-CID-INFO: VERSION:1.1.22,REQID:a9b49bed-1a2e-4525-b2ad-f6ad024be5dc,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:4,FILE:0,BULK:0,RULE:Release_HamU,ACTION:r
        elease,TS:4
X-CID-META: VersionHash:120426c,CLOUDID:54258da2-8fcb-430b-954a-ba3f00fa94a5,B
        ulkID:230426091746KB1YA0BJ,BulkQuantity:29,Recheck:0,SF:38|16|19|102,TC:ni
        l,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:
        0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-UUID: 17a17042e3fd11eda9a90f0bb45854f4-20230426
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <tze-nan.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1031181033; Wed, 26 Apr 2023 14:39:28 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 26 Apr 2023 14:39:26 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 26 Apr 2023 14:39:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9TvmO+JL1njjA9fkm6F36T0BHaIrfMjID7ClPxaD98q47N6Tcj1fX+tCAq9vRpJTyx97xQ3IS8JBlSvp0CXA6hhmRx5v5J9taZDnGk+fHZStgnThTkvTzxGcO/KIPwMnxP3W2VdvNKmdf6Rt8uHgrX3pyH0PEvOolp8yBGsJTYL0Gmm5Z8pJvbkDS13V3fr3h/Gs5JQbpSF9JeP5hH3Z2VfPCZvfMn+lbv5PAibmmCRY8BqhuRpluWRtBE9RoSDN3eN3sbjOy5+wlrQtXx2bCAXFRz4k+hUf41Ubgv6JcvNBkq6G4ks2oXEKTBDDP128E19dlKOuL5rm96lrahtFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTzJHsou+Z4/Lsj7q9FjMbty9LkhENmUxNnxM4WtAA4=;
 b=DkYvcj66OV4I4f9WX1Kpj57e1c06lJ4HrVoORBEHwjYSrxPWyEHDnfU9FabuQeEWdsQs2ls4yQxuOVHXy3HfR7WTAmNwPh9+E2IMqteSXWk+PV00OCmgk055oez9ekl225RpHebH7eshG5Z1n8xw0Wl/YaYkCS6RXp15oDyOKXQV0Nm7NpeSG/KowI/MWngcg1jdQMvypWtg29PI2jv9a9zs2tc9yDa09NCCv3F+5U4p08jbHYHOxpx1U4kepnfm7gd7R8zJxaK9a2KvCFOoE8g5LwDG1qBClc40PwfnvQ5HMFFSezwmkTs+Yp5OwxY/mxB9nyLeqOIeaOJ9JDlQFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTzJHsou+Z4/Lsj7q9FjMbty9LkhENmUxNnxM4WtAA4=;
 b=jBtteLDQ8tKdgGoF8MVysBy3pyccxrgkAAG31a4Jt5wpYuEA7GuS17xTaYhQ3H/YcYZTshD5RFVVdkQZJKISQJU1lZdcxuLD2HHSFE5EXZNPkN2q1fxVLWaCj00u3kWOolQzZsgCyQ0M2VdTTrP6Mr/GauYINTGhdpU1ZBVkA3Y=
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com (2603:1096:400:33a::11)
 by KL1PR0302MB5267.apcprd03.prod.outlook.com (2603:1096:820:45::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20; Wed, 26 Apr
 2023 06:39:24 +0000
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::6d55:5655:af99:8cb7]) by TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::6d55:5655:af99:8cb7%6]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 06:39:24 +0000
From:   =?utf-8?B?VHplLW5hbiBXdSAo5ZCz5r6k5Y2XKQ==?= 
        <Tze-nan.Wu@mediatek.com>
To:     "warthog9@eaglescrag.net" <warthog9@eaglescrag.net>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
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
Subject: Re: [PATCH v5] ring-buffer: Ensure proper resetting of atomic
 variables in ring_buffer_reset_online_cpus
Thread-Topic: [PATCH v5] ring-buffer: Ensure proper resetting of atomic
 variables in ring_buffer_reset_online_cpus
Thread-Index: AQHZd9swamBGCh+73kuunwoQYHt79q88yg+AgAAcNwCAAD2wgA==
Date:   Wed, 26 Apr 2023 06:39:24 +0000
Message-ID: <49578dd84e1789d107b997cc5bdb8e85a771c42e.camel@mediatek.com>
References: <20230426010446.10753-1-Tze-nan.Wu@mediatek.com>
         <20230425211737.757208b3@gandalf.local.home>
         <e3d77a20-fd14-5846-5d46-de2db69af45b@eaglescrag.net>
In-Reply-To: <e3d77a20-fd14-5846-5d46-de2db69af45b@eaglescrag.net>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB7183:EE_|KL1PR0302MB5267:EE_
x-ms-office365-filtering-correlation-id: e8fbff6e-c05a-4190-f766-08db4620f9aa
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g+ZGp8hamvdplQaAZ6CLWhKHsSXh1kQ9sRQuQU6KjeLVqFT8eohghbz8V3hABTFhB4Ylysra7ZSxk+BEFB/3Zia4dfqgFq9yqLNJqNRW0TD/pgJPrnC19Cr3tIbtP4IvuMZmmztUN0/ENzcp4aDxEb81aioKUaB1nc4/a2mrjs8+f2muYUA7qMc9Ift/fsPVAHal41cI1li/X2u4uveHYxuBBEExf+jwf4TbZrZMbguJT9Y0kJlvpSYEcJy/ZaVeBntihqKpNhOzYkE79UXx8TQ6N4MilKn2gmiQRW1fW7YQaSq1zbshjm3Nv9JRGNSJ7B9BBNeyU4FvE9RPLp2/ecLrQVf1I/iFL75WXVpN3ywIijbZ6NJrRYeDsCgs8ffP2aMl1tiGATyjmkn5LtBqF31ozyzePsqwQBMajLzHbsI7FyXxxniY100uqJbMRqmChWFrm52tqiNzJV5ZrGtQX09Ryki6dHh4jwEk43t006xFu4g7NyyC3frFQ3HVpF39Dnq2WutiUUgI2r/hWHvppKRB/kL98yOVDUBt46VUt2CSCTo2L/TQMQb73Lf0NyntkNRxlycExkFl5wD+9jDWRx09797gDnjQ7Z5Dpw+y356iJRuCbnFDTEjLrJ3Fmk/MNUgXjHgfMkzAMU5j6O8hMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB7183.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199021)(54906003)(110136005)(2616005)(83380400001)(6512007)(478600001)(6506007)(6486002)(71200400001)(26005)(966005)(316002)(4326008)(66946007)(76116006)(66556008)(66446008)(122000001)(41300700001)(64756008)(66476007)(53546011)(186003)(38100700002)(5660300002)(36756003)(7416002)(85182001)(2906002)(38070700005)(86362001)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2M3QlNGZUFGbFNEb0Ztd1ZZdWtBeVE3N0FVWVEwbnJveUhvM040bDdtaXcr?=
 =?utf-8?B?SW5ub0FlbjE0ZGVZWjd0RzFoUnUyc1MxVGEyb0YxUm5kTnRFaHBrQW1ZT1Bv?=
 =?utf-8?B?MlhERWZoTXVCU1NVN05odWF3TEJ5a0dsUHBNaklkLzRhcDh5RmpYd3pCYisr?=
 =?utf-8?B?ZW04eFVkZDdFYlM3WVhxajBUbHYxcUt2RzhwWTBwUSsrZUo3Z1hNUlV1UVlq?=
 =?utf-8?B?TmRSMCtSUEtMdElWeVhWNklqRllpRVh4cThlb2RNem9ORlNXM2N0VDdDcGNX?=
 =?utf-8?B?MzEvU2JmdkVPUnVLSHIvTWZUN1BFdmdkalpuc2hFWE5EemhhM0IrMTk4dmY4?=
 =?utf-8?B?UnRKMjhaK3VRUy9SZ2h1TS9Bd3A2WENSdmtYa2FDRnpDR3YrT2N2SU1XdDR5?=
 =?utf-8?B?N2loRFhuZjhmVk14T2w2Q2w2dDdXMmV4L214VTkvbm9pdWNsSEhjdTVZSWpm?=
 =?utf-8?B?cG80MjJLWDMwanJ5UjRyVitmRElEdkVoR0tWTklzRXVmNWUyeFVDMEZKYWNy?=
 =?utf-8?B?Zk9OUkcrQ2J1dUxkdkZRbTlkR29IVk9iQmJhNmo3V2NoQXJ2aC9UbW1HVy9O?=
 =?utf-8?B?aUF6ZTJvRk9lR09BYVMrWHAyZTV6MkhTSzBXL1NsZVN3RE1uOWZ2ckZ6cVdJ?=
 =?utf-8?B?OUdHMlhaS1hON0x0eG5zWnNzZ1hiRnZjeEdRRUovbzFEUk5NemxqRUI3UnR2?=
 =?utf-8?B?NHBsUjEwWGZZRi96YXE0Zms2MGowenBFNHdsQm1ZdmFNdVVNdm9FRk00UERL?=
 =?utf-8?B?MEVYTTlXUTE2MW4yQUZoVTJhY0pENlNXZUZXL2hsOTREbWJ1K3UwZU1VVjk0?=
 =?utf-8?B?YTBnS3IrUC92VE43Tmk2dk5GQWVnQWRiYjcyYXByVVVuTUl0U0FXdDlCLzEr?=
 =?utf-8?B?b2JHUnpWU0hnRGNBeHhGSVA0WUVLalBOMlI4NC96M2xXQXQwdFlEY25tU3Aw?=
 =?utf-8?B?c1krb2hBWnczWXZHV1ZKTDhVSWRwWnhOTjZUeUlLZ0RZRi8rRUg0ZkVyR0Zt?=
 =?utf-8?B?OUdITmU2VDhJQmYzTFlUY1JpUEhpcmNySFJjOTk4S1NRbGsvNkVzN1V2MCtG?=
 =?utf-8?B?Rk54R2ZLaUpONTh0UG9vczdIcmhwNndWSXlIVExlWHZzTXRCOGhLNmp6YTAz?=
 =?utf-8?B?c0ZCZHBocUhUNWRqWE5xeHlaY2tUT3paVllBTVpxdGhRZVNNSnovT3Q0Sk02?=
 =?utf-8?B?Z3E2TXFlM2lsV1ZzbWE4OTNYQ2pITFFDSnQ3NU9MT2tjdmFtNlNKODE1QWlF?=
 =?utf-8?B?NXR6MUVtK2ZBWm5tN3ZlWlZmZFJKQzQvMWxVbmlqOVgxTDdrRW1RU1FLRUxa?=
 =?utf-8?B?RFVEYURUakZPMGN4ZFpOVTNkdUVsY3B6MjZ0K1BNYklYZktCUEhPMFg0Vkxr?=
 =?utf-8?B?S25xMzd3WCtGM3hWL0lWdzFIeTR5LzZ6MDdnS0lwdUI4dVJLQ0YrNEJZbTMx?=
 =?utf-8?B?UnhRMWZFTlVlcy9xOGlTeFVJMkwyL0NkUmNScUVNdkc5dGZObHBwOFZzU2lq?=
 =?utf-8?B?R2FGQUZHVDZ0T2RzZG1NUitrN2pwTkhaNHpQWGU0a0ozbjVBMXlEK2MzMVFY?=
 =?utf-8?B?V28vd0ZQaVlScVVTWk1kbEdDUkJPYnQxTGlHMGVua0J5QzdIWnJjdWRpWU0z?=
 =?utf-8?B?WmRkcTJXbmtYSTd3NmNVemhWZDdPZnNITnAvUEtJenRtcS93KzNjZmlxT2du?=
 =?utf-8?B?Vit5R2NlMmlycm9UVEJUK2VWL3ptTU1iNW1LR2dqQk1zVTU3ZjhBM2EvZnlX?=
 =?utf-8?B?ZUsvWXhHNnVSNDQxakFLWU9STWpVV2VVOW9sZFg3UTlqdGtsUGp1eXRNa2Rq?=
 =?utf-8?B?dmN3bUNBUTQvd0hHL0VxUFZveTVMRVhiczREaDd6VCtOSFdpVXR5OS85NUpE?=
 =?utf-8?B?bFJ0QWhWWkFDVXdRRWFSMDNYN2NsTllVeXU1U1R4QmJ0ckdDcTFJckVieFFl?=
 =?utf-8?B?dUl4UmhVanRtcC9maVYwWVVKQnNleG9xU2pyVVNERVdGSW1nazBUdnVJbDBr?=
 =?utf-8?B?SHdiMGhHa05JbCtTQS9rdUlrNmtTRWljSk9NamE5ZEw5V3JzOTdxNGxjN1Vn?=
 =?utf-8?B?eDJsWjNiNGVMemx0TjQ1TUtSYmNmd0ZPU0JFdVFEaXJydkJsYmVJcFAvOVln?=
 =?utf-8?B?V1JKemFHeFlPNFpPdW5EU0FBRjlLSTU1QWEwa28yNHZQbGN6M09EREJDUEhq?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <174921A584CED04EB9ABECBD8684C89D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB7183.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8fbff6e-c05a-4190-f766-08db4620f9aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 06:39:24.4264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xdiUlexM8cmCVTmCwDVjpDhHDog81aYDwuWFwNN6EiHKJa2dy4ENkV6+T506Oy1W9xwjRGNIrSLfxOWpRgYT0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0302MB5267
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTI1IGF0IDE5OjU4IC0wNzAwLCBKb2huICdXYXJ0aG9nOScgSGF3bGV5
IHdyb3RlOg0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiANCj4gDQo+IFJhbiBhZm91bCBvZiB0aGUgdGFib28gZmlsdGVyczoN
Cj4gDQo+IElsbGVnYWwtT2JqZWN0OiBTeW50YXggZXJyb3IgaW4gRnJvbTogYWRkcmVzcyBmb3Vu
ZCBvbg0KPiB2Z2VyLmtlcm5lbC5vcmc6DQo+ICAgICAgICAgIEZyb206ICAgVHplLW5hbi5XdTxU
emUtbmFuLld1QG1lZGlhdGVrLmNvbT4NCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBeLW1pc3NpbmcgZW5kIG9mIG1haWxib3gNCj4gDQo+IEkndmUgc2VlbiBhIGZldyBvZiB0
aGVzZSBidXQgSSd2ZSBiZWVuIHVuYWJsZSB0byByZXBsaWNhdGUgdGhlDQo+IHByb2JsZW0uDQo+
IEkndmUgYSBzdXNwaWNpb24gYnV0IHNvIGZhciBiZWVuIHVuYWJsZSB0byBwcm92ZSB0aGUgdGhl
b3J5IG9uIHdoYXQncw0KPiB3cm9uZy4NCj4gDQo+IC0gSm9obg0KPiANCiAgU28gSSBzZW50IHRo
ZSBwYXRjaCBhZ2FpbiwgYnV0IHRoaXMgdGltZSBJIGNoYW5nZWQgdGhlIG5hbWUgZmllbGQgaW4N
Ci5naXRjb25maWcgZnJvbSAiVHplLW5hbi5XdSIoaW50ZXJuYWwtdXNlKSB0byAiVHplLW5hbiBX
dSIuDQpUaGlzIGNhbiBhdm9pZCB0aGUgbGluZSAiRnJvbTogIFR6ZS1uYW4uV3U8VHplLW5hbi5X
dUBtZWRpYXRlay5jb20+Ig0KYmVpbmcgYWRkZWQgdG8gdGhlIG1haWwgd2hlbiB3ZSBleGVjdXRl
ICJnaXQgc2VuZC1lbWFpbCIsIGFuZCBpdCB3b3JrcywNCnRoZSBsYXN0IHBhdGNoIEkgc2VudCBp
cyBub3QgZmlsdGVyIG91dCBhbnltb3JlLg0KDQotLS0NCkhlcmUgaXMgdGhlIG1hZ29yZSBkaWZm
ZXJlbmNlIGJldHdlZW4gdGhlIHBhdGNoZXM6DQpvbGQgcGF0Y2goZmFpbCk6DQogIEZyb206ICJU
emUtbmFuIFd1IiA8VHplLW5hbi5XdUBtZWRpYXRlay5jb20+ICAgPD09IChtb2RpZnkgYnkgZWRp
dG9yDQpmcm9tIFR6ZS1uYW4uV3UgdG8gVHplLW5hbiBXdSkNCi0tLQ0KbmV3IHBhdGNoKHN1Y2Nl
c3MpOg0KICBGcm9tOiBUemUtbmFuIFd1IDxUemUtbmFuLld1QG1lZGlhdGVrLmNvbT4NCi0tLQ0K
DQogLSBUemVuYW4NCj4gT24gNC8yNS8yMyAxODoxNywgU3RldmVuIFJvc3RlZHQgd3JvdGU6DQo+
ID4gDQo+ID4gRm9yIHNvbWUgcmVhc29uLCB0aGlzIGVtYWlsIGRpZCBub3QgbWFrZSBpdCB0bw0K
PiA+IGxpbnV4LXRyYWNlLWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcsIGFuZCB0aGVyZWZvcmUgZGlk
IG5vdCBtYWtlIGl0DQo+ID4gaW50bw0KPiA+IHBhdGNod29yaz8NCj4gPiANCj4gPiBKb2huPw0K
PiA+IA0KPiA+IC0tIFN0ZXZlDQo+ID4gDQo+ID4gDQo+ID4gT24gV2VkLCAyNiBBcHIgMjAyMyAw
OTowNDo0NCArMDgwMA0KPiA+IFR6ZS1uYW4uV3UgPFR6ZS1uYW4uV3VAbWVkaWF0ZWsuY29tPiB3
cm90ZToNCj4gPiANCj4gPiA+IEZyb206ICJUemUtbmFuIFd1IiA8VHplLW5hbi5XdUBtZWRpYXRl
ay5jb20+DQo+ID4gPiANCj4gPiA+IEluIHJpbmdfYnVmZmVyX3Jlc2V0X29ubGluZV9jcHVzLCB0
aGUgYnVmZmVyX3NpemVfa2Igd3JpdGUNCj4gPiA+IG9wZXJhdGlvbg0KPiA+ID4gbWF5IHBlcm1h
bmVudGx5IGZhaWwgaWYgdGhlIGNwdV9vbmxpbmVfbWFzayBjaGFuZ2VzIGJldHdlZW4gdHdvDQo+
ID4gPiBmb3JfZWFjaF9vbmxpbmVfYnVmZmVyX2NwdSBsb29wcy4gVGhlIG51bWJlciBvZiBpbmNy
ZWFzZXMgYW5kDQo+ID4gPiBkZWNyZWFzZXMNCj4gPiA+IG9uIGJvdGggY3B1X2J1ZmZlci0+cmVz
aXplX2Rpc2FibGVkIGFuZCBjcHVfYnVmZmVyLQ0KPiA+ID4gPnJlY29yZF9kaXNhYmxlZCBtYXkg
YmUNCj4gPiA+IGluY29uc2lzdGVudCwgY2F1c2luZyBzb21lIENQVXMgdG8gaGF2ZSBub24temVy
byB2YWx1ZXMgZm9yIHRoZXNlDQo+ID4gPiBhdG9taWMNCj4gPiA+IHZhcmlhYmxlcyBhZnRlciB0
aGUgZnVuY3Rpb24gcmV0dXJucy4NCj4gPiA+IA0KPiA+ID4gVGhpcyBpc3N1ZSBjYW4gYmUgcmVw
cm9kdWNlZCBieSAiZWNobyAwID4gdHJhY2UiIHdoaWxlDQo+ID4gPiBob3RwbHVnZ2luZyBjcHUu
DQo+ID4gPiBBZnRlciByZXByb2R1Y2luZyBzdWNjZXNzLCB3ZSBjYW4gZmluZCBvdXQgYnVmZmVy
X3NpemVfa2Igd2lsbA0KPiA+ID4gbm90IGJlDQo+ID4gPiBmdW5jdGlvbmFsIGFueW1vcmUuDQo+
ID4gPiANCj4gPiA+IFRvIHByZXZlbnQgbGVhdmluZyAncmVzaXplX2Rpc2FibGVkJyBhbmQgJ3Jl
Y29yZF9kaXNhYmxlZCcgbm9uLQ0KPiA+ID4gemVybyBhZnRlcg0KPiA+ID4gcmluZ19idWZmZXJf
cmVzZXRfb25saW5lX2NwdXMgcmV0dXJucywgd2UgZW5zdXJlIHRoYXQgZWFjaCBhdG9taWMNCj4g
PiA+IHZhcmlhYmxlDQo+ID4gPiBoYXMgYmVlbiBzZXQgdXAgYmVmb3JlIGF0b21pY19zdWIoKSB0
byBpdC4NCj4gPiA+IA0KPiA+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IENj
OiBucGlnZ2luQGdtYWlsLmNvbQ0KPiA+ID4gRml4ZXM6IGIyM2Q3YTVmNGEwNyAoInJpbmctYnVm
ZmVyOiBzcGVlZCB1cCBidWZmZXIgcmVzZXRzIGJ5DQo+ID4gPiBhdm9pZGluZyBzeW5jaHJvbml6
ZV9yY3UgZm9yIGVhY2ggQ1BVIikNCj4gPiA+IFJldmlld2VkLWJ5OiBDaGVuZy1KdWkgV2FuZyA8
Y2hlbmctanVpLndhbmdAbWVkaWF0ZWsuY29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogVHplLW5h
biBXdSA8VHplLW5hbi5XdUBtZWRpYXRlay5jb20+DQo+ID4gPiAtLS0NCj4gPiA+IENoYW5nZXMg
ZnJvbSB2NCB0byB2NTogDQo+ID4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjMw
NDEyMTEyNDAxLjI1MDgxLTEtVHplLW5hbi5XdUBtZWRpYXRlay5jb20vDQo+ID4gPiAgICAtIE1v
dmUgdGhlIGRlZmluZSBiZWZvcmUgdGhlIGZ1bmN0aW9uDQo+ID4gPiAtLS0NCj4gPiA+ICAga2Vy
bmVsL3RyYWNlL3JpbmdfYnVmZmVyLmMgfCAxNiArKysrKysrKysrKysrLS0tDQo+ID4gPiAgIDEg
ZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+ID4gDQo+
ID4gPiBkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL3JpbmdfYnVmZmVyLmMNCj4gPiA+IGIva2Vy
bmVsL3RyYWNlL3JpbmdfYnVmZmVyLmMNCj4gPiA+IGluZGV4IDc2YTJkOTFlZWNhZC4uMjUzZWY4
NWE5ZWMzIDEwMDY0NA0KPiA+ID4gLS0tIGEva2VybmVsL3RyYWNlL3JpbmdfYnVmZmVyLmMNCj4g
PiA+ICsrKyBiL2tlcm5lbC90cmFjZS9yaW5nX2J1ZmZlci5jDQo+ID4gPiBAQCAtNTM0NSw2ICs1
MzQ1LDkgQEAgdm9pZCByaW5nX2J1ZmZlcl9yZXNldF9jcHUoc3RydWN0DQo+ID4gPiB0cmFjZV9i
dWZmZXIgKmJ1ZmZlciwgaW50IGNwdSkNCj4gPiA+ICAgfQ0KPiA+ID4gICBFWFBPUlRfU1lNQk9M
X0dQTChyaW5nX2J1ZmZlcl9yZXNldF9jcHUpOw0KPiA+ID4gDQo+ID4gPiArLyogRmxhZyB0byBl
bnN1cmUgcHJvcGVyIHJlc2V0dGluZyBvZiBhdG9taWMgdmFyaWFibGVzICovDQo+ID4gPiArI2Rl
ZmluZSBSRVNFVF9CSVQgICAoMSA8PCAzMCkNCj4gPiA+ICsNCj4gPiA+ICAgLyoqDQo+ID4gPiAg
ICAqIHJpbmdfYnVmZmVyX3Jlc2V0X29ubGluZV9jcHVzIC0gcmVzZXQgYSByaW5nIGJ1ZmZlciBw
ZXIgQ1BVDQo+ID4gPiBidWZmZXINCj4gPiA+ICAgICogQGJ1ZmZlcjogVGhlIHJpbmcgYnVmZmVy
IHRvIHJlc2V0IGEgcGVyIGNwdSBidWZmZXIgb2YNCj4gPiA+IEBAIC01MzYxLDIwICs1MzY0LDI3
IEBAIHZvaWQgcmluZ19idWZmZXJfcmVzZXRfb25saW5lX2NwdXMoc3RydWN0DQo+ID4gPiB0cmFj
ZV9idWZmZXIgKmJ1ZmZlcikNCj4gPiA+ICAgICAgZm9yX2VhY2hfb25saW5lX2J1ZmZlcl9jcHUo
YnVmZmVyLCBjcHUpIHsNCj4gPiA+ICAgICAgICAgICAgICBjcHVfYnVmZmVyID0gYnVmZmVyLT5i
dWZmZXJzW2NwdV07DQo+ID4gPiANCj4gPiA+IC0gICAgICAgICAgICBhdG9taWNfaW5jKCZjcHVf
YnVmZmVyLT5yZXNpemVfZGlzYWJsZWQpOw0KPiA+ID4gKyAgICAgICAgICAgIGF0b21pY19hZGQo
UkVTRVRfQklULCAmY3B1X2J1ZmZlci0+cmVzaXplX2Rpc2FibGVkKTsNCj4gPiA+ICAgICAgICAg
ICAgICBhdG9taWNfaW5jKCZjcHVfYnVmZmVyLT5yZWNvcmRfZGlzYWJsZWQpOw0KPiA+ID4gICAg
ICB9DQo+ID4gPiANCj4gPiA+ICAgICAgLyogTWFrZSBzdXJlIGFsbCBjb21taXRzIGhhdmUgZmlu
aXNoZWQgKi8NCj4gPiA+ICAgICAgc3luY2hyb25pemVfcmN1KCk7DQo+ID4gPiANCj4gPiA+IC0g
ICAgZm9yX2VhY2hfb25saW5lX2J1ZmZlcl9jcHUoYnVmZmVyLCBjcHUpIHsNCj4gPiA+ICsgICAg
Zm9yX2VhY2hfYnVmZmVyX2NwdShidWZmZXIsIGNwdSkgew0KPiA+ID4gICAgICAgICAgICAgIGNw
dV9idWZmZXIgPSBidWZmZXItPmJ1ZmZlcnNbY3B1XTsNCj4gPiA+IA0KPiA+ID4gKyAgICAgICAg
ICAgIC8qDQo+ID4gPiArICAgICAgICAgICAgICogSWYgYSBDUFUgY2FtZSBvbmxpbmUgZHVyaW5n
IHRoZQ0KPiA+ID4gc3luY2hyb25pemVfcmN1KCksIHRoZW4NCj4gPiA+ICsgICAgICAgICAgICAg
KiBpZ25vcmUgaXQuDQo+ID4gPiArICAgICAgICAgICAgICovDQo+ID4gPiArICAgICAgICAgICAg
aWYgKCEoYXRvbWljX3JlYWQoJmNwdV9idWZmZXItPnJlc2l6ZV9kaXNhYmxlZCkgJg0KPiA+ID4g
UkVTRVRfQklUKSkNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiA+ID4g
Kw0KPiA+ID4gICAgICAgICAgICAgIHJlc2V0X2Rpc2FibGVkX2NwdV9idWZmZXIoY3B1X2J1ZmZl
cik7DQo+ID4gPiANCj4gPiA+ICAgICAgICAgICAgICBhdG9taWNfZGVjKCZjcHVfYnVmZmVyLT5y
ZWNvcmRfZGlzYWJsZWQpOw0KPiA+ID4gLSAgICAgICAgICAgIGF0b21pY19kZWMoJmNwdV9idWZm
ZXItPnJlc2l6ZV9kaXNhYmxlZCk7DQo+ID4gPiArICAgICAgICAgICAgYXRvbWljX3N1YihSRVNF
VF9CSVQsICZjcHVfYnVmZmVyLT5yZXNpemVfZGlzYWJsZWQpOw0KPiA+ID4gICAgICB9DQo+ID4g
PiANCj4gPiA+ICAgICAgbXV0ZXhfdW5sb2NrKCZidWZmZXItPm11dGV4KTsNCg==
