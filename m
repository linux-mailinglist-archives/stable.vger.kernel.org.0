Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE40652C9C
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 07:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiLUGAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 01:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiLUF77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 00:59:59 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F9F20BFF;
        Tue, 20 Dec 2022 21:59:49 -0800 (PST)
X-UUID: 80278c3b18a041a4b0cc30ef71f4955c-20221221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=UzxZCt3a88L0opM15sxzZH5zUmPdBmqL12jX5artoT0=;
        b=XZowDxR8VwZbGaF5Q/jJx2DjeEGakrOqYD4j+rhMn72+0q39Cwf+BgF4mwTgZjQLBivdTYvLRFCwWZer0Yd/JKECxLU3lAXh3Cl3FWqUfZsAj2AWDuH1k0vnQyVcl6BSamDVg7X5CzUTl2JRJRqKfOsMgmraBLdjb6PelJGa+SQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:4f9a8a25-67e7-4fda-b89b-174d48444be7,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:dcaaed0,CLOUDID:d46086f3-ff42-4fb0-b929-626456a83c14,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 80278c3b18a041a4b0cc30ef71f4955c-20221221
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1906233531; Wed, 21 Dec 2022 13:59:41 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 21 Dec 2022 13:59:40 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Wed, 21 Dec 2022 13:59:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBsgOgpAXSbo1xns8UCaSxIh/npDVrQVg8R7NEfwTYWsUl0CdwlmZIOMMtqhlX1pY+hKkgFFzCc0TJkBfdSRxW/5DWWmGB2AiqQtwZyjHDS1Iyxvo+i0H0Eh1zt8yhqo1PBsyx/iePlJ1gtoBDQOEvCkznabPYdyt5nVhRvmbrbP7oxGoelLt6u5mIlpFuTUhoDEPnzLHLTLDKEeqCo5P8LHdJjmdwM0A7f0YGWzpEzZkNVmUFGzpllWVDVM796+vGBIqRg4g2Lwz5tD2z4lrHDuo2nKtnIOmLXXDzBefR8ut4wU7hfGa3G4EOLH9hMkU9qblWyvO/2hiWxSgVbSkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzxZCt3a88L0opM15sxzZH5zUmPdBmqL12jX5artoT0=;
 b=SE3oHU4JWfCeZIqckpNsrVVrH/zsrntl83JWsN9JOuQMWza9vhvYY4/XVbHEhVnsFJ/kpnscx39kj6OMOvyhX5uVBtB7voa1knu33o/RO/+JLXh3Pbj7ElsgtYEOpZkm6PtZCfs4jqBElU3BFxV8Str2b8IBK4MZ+vx99Iya9OBfELbW61nXdNm0oxOcAG4zAWX3KlwX+Z7Z2tvgaSPTXNbNNGm6SezAY8f6t6yxqzLsL+xPdA7WLbcnPwQ9UsBkPsHk6fGliSKLEUHx2ZHys2vSh6Gk5lHiCATQ2yKQX2B3iLtkvoSkZPhpiD2a9Z+QD9/xeSxbq51USt1ZgcKtyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzxZCt3a88L0opM15sxzZH5zUmPdBmqL12jX5artoT0=;
 b=gW1wxpZCrQb7TBFqdcdbFt6jwu7WOTE56Z/z4VkJuOFu0R0DedahGXfO28ODdXsXcpbwmoqjCfWaW3KOZkf9Z/xXoi5x269ZvZEeHk/nrv/7PglJ0/qi+GiVDTF3JLnHAv2EzuNOMurv8xkAIeRH5jKnISoSTlarbochyc7+CMs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB5499.apcprd03.prod.outlook.com (2603:1096:4:12a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 05:59:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448%4]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 05:59:38 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "dlunev@chromium.org" <dlunev@chromium.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v6] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Topic: [PATCH v6] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Index: AQHZCtY+I4whNt0QQkW2t7AnC4Fqta5sv1EsgAqXQgCAAJaPAA==
Date:   Wed, 21 Dec 2022 05:59:38 +0000
Message-ID: <35850d1c8f042d59f14f268502aa30ac497b2d5e.camel@mediatek.com>
References: <20221208072520.26210-1-peter.wang@mediatek.com>
         <yq14jtyekv2.fsf@ca-mkp.ca.oracle.com>
         <CAONX=-d-LZSV9-R=oLDFKsBG8Zd90wXOcGR44kPaorDH-Y7MnQ@mail.gmail.com>
In-Reply-To: <CAONX=-d-LZSV9-R=oLDFKsBG8Zd90wXOcGR44kPaorDH-Y7MnQ@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB5499:EE_
x-ms-office365-filtering-correlation-id: 526ea338-af04-4683-63c2-08dae3188b4b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kbbN3xXy02uhjepkxkGxIycCBAQYWTzGZy0UmAU5Ev0hr8lEAw2qvcAiEga+MnGWqBkWjwZf007iNbGcszvQ5XLgAf3G8Wn4XIGvxZLIQcIduGbh4p41ktgTis30DkmUZAgugAjdZfCtIwlEvUoyeVY5zSSuZS4PriejU8vx8u7ImgaBZ2Zr1g74AvsD8Macm2j/whsB9yS0UNY0wspkFGQHuY98ohYusK2NfyS3zqaXsuy7AQdIfmrDeaQ8PV+qiUAZB1e4ne9vwd6FXOBB2qEm3xTniV82QdfdY1OP108u+Z+5EE/NhdAiT6h9Qu92TqBj2U3UFWD67OnlTshZv67nyml1iF6qeTtp/VBCfAJ2TGop6OJs7N0LuzGzMUV6k7s2bPpCZZeJgPs9++8r3uEsklA6dVlNuHkEggXcrceGZnInlezM9p2ZSrCRl5PIFvljWdgJnn4zRtMtaCg4xiIAl3avbA1ChX4+9oSk4jlaGmpsQr7RMv4o9gyaXglPNZyiAqafcwK77lRzlWUZ511e6Fa7WFu8B+h8r/n5kgyg1d5b7m36pVQdi0UevsxrlNSkkVFUiRCWeiOL4xREn1gClRviLLDbNERvMUc2eJwdm2Ln8R4a9ZCDAgtFky9KUIeeNFLtqwN+fmOv7oHOHO59y81rwfgyona90LH2oBujPIKWq+4npvCIFZflCfGqkVHiZRQH81i9M/JEi2o5EvOgGmX7hPVorIL6JxlCR5E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199015)(6486002)(71200400001)(66556008)(6506007)(54906003)(110136005)(478600001)(64756008)(107886003)(66446008)(4326008)(8676002)(26005)(76116006)(186003)(91956017)(2616005)(66476007)(6512007)(316002)(66946007)(2906002)(36756003)(83380400001)(4001150100001)(15650500001)(8936002)(41300700001)(85182001)(38070700005)(5660300002)(38100700002)(122000001)(86362001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2U0dWFhN3Y1aDdrSnVwNXFBL3hZbERHVXJiSTZpL3lDV0N1eEhJdXloUUk5?=
 =?utf-8?B?djduYk5NR3g2MGFnYjlaVW5BaFNiSnkvN3UyVCtYeHRRLzhLRGpIcGNDdHpE?=
 =?utf-8?B?YjFVSjc4bW1GWm9xSUIxNS9CUXlzcjVwMHZkY2tNQ0hpekFERzlqVEZ6YXJJ?=
 =?utf-8?B?MHhMbTRkZEN0bDR0WSswMS91UUswam0rYStMRGJ3MXhaS1BkQzNyS1NGZnpk?=
 =?utf-8?B?QmNrVjRTbE1LNllpV1MvNG5GRmw3eEtnN3dqWU5xVC8rc0hZaXBLYkpLdktR?=
 =?utf-8?B?OFBFZFpXWTZFemVoYkxMSk4vcWVhN2NEWHE1MjZyOVJBZ0NXWExRRkV5OXkx?=
 =?utf-8?B?RmNuRFRxdEwxYlRpb0ZrZVBQcmU2RG5NaW5NNUhXdHZOVXFGS0NMNS92a3d4?=
 =?utf-8?B?YmJjSUlFdGI2ajgrbUVUVEdkYzdMMTlpTWEzbTJRRzBYZlV2R1NaRHJRdlFn?=
 =?utf-8?B?NXc5NnlkNUVpbGRIWEYzM2pTelRUU2E2Z3lCaW5jNCtxYVdxc0Qwbmk2QWVP?=
 =?utf-8?B?UzUyRm1XbS9tMTFlRlNIT2ZFMzhCandQSU9mZEY2eXB5dmY5cy8vZ3dTUDR3?=
 =?utf-8?B?V0tyYjgvY1lvbTBLK2ttU2ZWS0MzRmppZFRpbE5DdTVQK2J3V0RFLzBDZGlI?=
 =?utf-8?B?NjZncFFPUnBlSXdKV0VlWVFpZ2NGcXhRZE1EZ1lTTXRBbGsvZ1Jybm9NZnVM?=
 =?utf-8?B?aEFtaWNqS3RMQWFMWll6ZHJZcklEeExFajVhUXVNMDdDbEVjNkdxZzVtVFR4?=
 =?utf-8?B?aGZCZUltbkU1eWMvVVR5TTV2MjU3T1lTbGpvMWhIeGpMaGVIa1NJcWUyY3pY?=
 =?utf-8?B?a0FNa2pCYlBBTEN6SUp0aWpUK1FoaGV6MmpWVkg4cHJPSEZpdExSeUVLUnh5?=
 =?utf-8?B?YWUyVUpIU2dweFdsUGVKUVNuRWE5ZWFLVXVJeXhFYVVNRC9WQTVlc0FHcWJL?=
 =?utf-8?B?djRiSy8vaHBIelVwMmxIR3oyckhBRFpLS1huUEEvNWFqL1dsYi9OemRKNlFR?=
 =?utf-8?B?ODZJMDlTOU50dFp3aGVNZ243QW5ab0QwS09OQWljTWRCcEhJRGxMZ1NJd2d2?=
 =?utf-8?B?VXhwSzVZcExtV3VISE1Qcm4rbVR0OCtDZXdQSUgzbVJxV3BWVThpc1RDK1cw?=
 =?utf-8?B?S2ppcWdDT2ZrK1g0dXhSc1VBckhOV0Erd3RzQ0xNb2NLd2ZvdElwWEduK2tm?=
 =?utf-8?B?cktZdm1ZZDB6YXJxZEZlUk5QVDh3dnZNbklOeCtFWU1Xei9zOVM0RGxMVkNG?=
 =?utf-8?B?Q1JySjhjNVlYR2FXZEV3c21HQTFpbGRRUEQrTmlTV0tTa2pCbUxZaUU2Y21Y?=
 =?utf-8?B?TFVablJHNDJlWURJWTZEdlNKRGtRNnJPY25LSjdPdUwyUnhHU1BxYlVqWk16?=
 =?utf-8?B?ZXZ0MlpIdnM1ZGN4ZmRSeTVrU1BBQy9GTVBBdnVJUHJjMktTQmZ1S1ZWaWdU?=
 =?utf-8?B?VWd1bnB4U0lpWjJkTEt6UlAvVURyL3A0YlVCcXBrZ3pqOGxtcERUNzVCTHFO?=
 =?utf-8?B?bEh1aFhlRWtVQjVscllhcllSUG0walV1akNlclAzaHJEaEZhdnZpZHU0aWpF?=
 =?utf-8?B?UTlueGFLZGxqUyt1NVFERU1tVUhPOTZRZHJ6V0NlZ0YzdFpWai9Cb2tKaWpF?=
 =?utf-8?B?TVNNNTVMYTdYSjFLZFEwaitISnBpeEl3RW1sbVRHZWl3a0Z1Z3U4d2JQQXg4?=
 =?utf-8?B?MlNWd201cmRuTkxFVmxvaGRBUVJSQnVyOXE4UC9FWnRYbEUvV1FJZFFYdnQz?=
 =?utf-8?B?elRibk9MZ2ZGNWtnNmg4UlVwbkRTYld6S0t5dCtRZWJyY1NHVHNNOEg2YXpY?=
 =?utf-8?B?Y0gvZjZ5WU5abkdkUG43WjVobUplTk1kbU5tcVZpVFFXS1FoV1R6MzVKeG9k?=
 =?utf-8?B?a1NmUGhOVnJ6Q3BTN3FqZHVJUXg4L0FEaStIaDVYRUVOeDRjV3ZWV1dHaHhQ?=
 =?utf-8?B?VmVHdEVtQTFwK2dQNnZkMjB6bWZZeCs2NExSWm9zU1FzaVFIZ1B1ZG9aVmFl?=
 =?utf-8?B?SFNuV1NEcTFlZVFQS1RFNUtCODg3SHlhSHQ2R0IwUHA4YklYMy9ZUm0xaEFS?=
 =?utf-8?B?a3FXK0NVK2pybkJ2RVI1aFB0QTZDdVhFdDBVL3Y4bThYY0lwUTRoVFVIbS9U?=
 =?utf-8?B?aDJySXpDb3ZiSkFGenJkbjMwWWVBUEhuQ0w5dDhOeHdSeTQ0SllBMnB2NUtF?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71BF56DAAB64454A8A82808B49420ACE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526ea338-af04-4683-63c2-08dae3188b4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 05:59:38.1571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m8egs7cy0tnbQC83LZ1ZT+LWZ6/dluQnYG9BUxzboo3A3CslY/W6AIzYEr1QxHRBi+clydxIz2FyiuZsqrwYRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5499
X-MTK:  N
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,RDNS_NONE,
        SPF_HELO_PASS,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIyLTEyLTIxIGF0IDA4OjAwICsxMTAwLCBEYW5paWwgTHVuZXYgd3JvdGU6DQo+
ID4gQXBwbGllZCB0byA2LjIvc2NzaS1zdGFnaW5nLCB0aGFua3MhDQo+IA0KPiBUaGVyZSBpcyBh
biBpbnRlcmVzdGluZyBzaWRlIGVmZmVjdCBvZiB0aGUgcGF0Y2ggaW4gdGhpcyBpdGVyYXRpb24N
Cj4gKHdoaWNoIEkgYW0gbm90IHN1cmUgd2FzIHByZXNlbnQgaW4gdGhlIHBhc3QgaXRlcmF0aW9u
IEkgdHJpZWQpOg0KPiBJZiB0aGUgZGV2aWNlIGF1dG8gc3VzcGVuZHMgd2hpbGUgcnVubmluZyBw
dXJnZSAtIGNvbnRyb2xsZXIgaXMNCj4gc2VlbWluZ2x5IHJlY2VudCBhbmQgdGh1cyB0aGUgcHVy
Z2UgaXMgYWJvcnRlZCAod2l0aCBubyBwYXRjaCBhdCBhbGwNCj4gaXQgaGFuZ3MpLg0KPiBUaGF0
IG1pZ2h0IGJlIG9rIGJlaGF2aW91ciB0aG91Z2ggLSBpdCB3aWxsIGp1c3QgbWFrZSBpdCBhbiBl
eHBsaWNpdA0KPiByZXF1aXJlbWVudCB0byBkaXNhYmxlIHJ1bnRpbWUgc3VzcGVuZCBkdXJpbmcg
dGhlIG1hbmFnZW1lbnQNCj4gb3BlcmF0aW9uLg0KPiANCg0KSGkgRGFuaWlsLA0KDQpJIGFtIG5v
dCBzdXJlIGlmIHRoaXMgaXMgc2ltaWxhciByZWFzb24gd2UgZ2V0IFNTVShzbGVlcCkgZmFpbC4N
CkJ1dCBpZiB3aXRob3V0IHRoaXMgcGF0Y2ggd2hlbiBwdXJnZSBpcyBvbmdpbmcsIHN5c3RlbSBJ
TyB3aWxsIGhhbmcsDQp0aGlzIGlzIG5vIGJldHRlci4NCkFuZCBJIGhhdmUgYW5vdGhlciBpZGVh
IGFib3V0IHJwbSBhbmQgcHVyZ2UuDQoNClRvIGRpc2FibGUgcnVudGltZSBzdXNwZW5kIHdoZW4g
cHVyZ2Ugb3BlcmF0aW9uIGlzIG9uZ29pbmc6DQoxLiBEaXNhYmxlIHJwbSB3aGVuIGZQdXJnZUVu
YWJsZSBpcyBzZXQsIHBvbGxpbmcgYlB1cmdlU3RhdHVzIGJlY29tZSAwDQphbmQgZW5hYmxlIHJw
bS4NCiAgIEJ1dCBwb2xsaW5nIGJQdXJnZVN0YXR1cyB3aWxsIGV4dGVuZCBycG0gdGltZXIsIHNv
IHdlIGRvbid0IG5lZWQNCnJlYWxseSBkaXNhYmxlIHJwbSwgcmlnaHQ/DQoyLiBDaGVjayBiUHVy
Z2VTdGF0dXMgaWYgZW50ZXIgcnVudGltZSBzdXNwZW5kLCByZXR1cm4gRUJVU1kgaWYNCmJQdXJn
ZVN0YXR1cyBpcyBub3QgMCB0byBicmVhayBzdXNwZW5kLg0KICAgVGhpcyBpcyBjb3JyZWN0IGRl
c2lnbiB0byB0ZWxsIHJwbSBmbGFtZXdvcmsgdGhhdCBkcml2ZXIgaXMgYnVzeQ0Kd2l0aCBwdXJn
ZSBhbmQgc3VzcGVuZCBpcyBpbmFwcHJvcHJpYXRlLiANCiAgIEJ1dCBpdCBzaG91bGQgYmUgc2lt
aWxhciBhcyBjdXJyZW50IGZsb3csIHJldHVybiBFQlVTWSB3aGVuIGdldCBTU1UNCmZhaWw/DQoN
ClNvLCB3aXRoIGN1cnJlbnQgZGVzaWduLCBpZiBwdXJnZSBpbml0aWF0b3IgZG8gbm90IHdhbnQg
dG8gc2VlIHJwbQ0KRUJVU1ksIHRoZW4gaGUgc2hvdWxkIHBvbGxpbmcgYlB1cmdlU3RhdHVzLiAN
CldoYXQgZG8geW91IHRoaW5rPw0KDQoNClRoYW5rcy4NCkJSDQpQZXRlcg0KDQoNCg0KPiBsb2Nh
bGhvc3QgfiAjIHVmcy11dGlscyBmbCAtdCA2IC1lIC1wIC9kZXYvYnNnL3Vmcy1ic2cwDQo+IGxv
Y2FsaG9zdCB+ICMgdWZzLXV0aWxzIGF0dHIgLWEgLXAgL2Rldi9ic2cvdWZzLWJzZzAgfCBncmVw
DQo+IGJQdXJnZVN0YXR1cw0KPiBiUHVyZ2VTdGF0dXMgICAgICAgICAgICAgICA6PSAweDAwDQo+
IA0KPiBbICAgMjUuODAxOTgwXSB1ZnNfZGV2aWNlX3dsdW4gMDowOjA6NDk0ODg6IFNUQVJUX1NU
T1AgZmFpbGVkIGZvcg0KPiBwb3dlciBtb2RlOiAyLCByZXN1bHQgMg0KPiBbICAgMjUuODAyMDAy
XSB1ZnNfZGV2aWNlX3dsdW4gMDowOjA6NDk0ODg6IFNlbnNlIEtleSA6IE5vdCBSZWFkeQ0KPiBb
Y3VycmVudF0NCj4gWyAgIDI1LjgwMjAwOV0gdWZzX2RldmljZV93bHVuIDA6MDowOjQ5NDg4OiBB
ZGQuIFNlbnNlOiBObyBhZGRpdGlvbmFsDQo+IHNlbnNlIGluZm9ybWF0aW9uDQo+IFsgICAyNS44
MDIwMjBdIHVmc19kZXZpY2Vfd2x1biAwOjA6MDo0OTQ4ODogdWZzaGNkX3dsX3J1bnRpbWVfc3Vz
cGVuZA0KPiBmYWlsZWQ6IC0xNg0K
