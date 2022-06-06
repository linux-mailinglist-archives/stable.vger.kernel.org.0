Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD71C53ECC8
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiFFRNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiFFRNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:13:08 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020021.outbound.protection.outlook.com [52.101.61.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4075222280;
        Mon,  6 Jun 2022 10:02:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/2N8SqW92wdoNtpyueMhrgGKDT7XRHgjDWcocfsuMXDhKr1Rh3pzsIHDf4vKbCT+x6PcThgUtwRAW2KVDpzU65z5T+sfXM4Y2IlZHLP1LlCwMD1an7LGEZUn5Xt1U3XSheGQLs60hSF/Cm73c8by8bu57niex7w1AG1vfxF3SE2XEoGKdsDIa8Q74+w8blvC7KfZ5uCZIS9RhGP5rSuPuVFuIIqRbb/7bmwzx6XARuXMlLtJo3L6mNOT4TvedmREYZX/lE6XqqmSExDf6PU0hGfDYlyoPe0vTtsbnisxh0oVr356sG3epIt3JbpaLTRop4BxsaHJVtWyP7lSIsvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qpjXYyvgh1OIvujfxNG32EPFnha1uv3PsBWN7VzQuY=;
 b=QGeCFc8dgbgjqFgBdKCZmKKRdKirH2ik5dbuGJy/hL7kV3CNpW44NG9XzSMIdfssmaDnVJLO6jSCMEPNbziMyda8bog8Ek5x1o/atdMf12W2S0MB2a8YOLrcMtTdN8CRvqqfEAWiGO0MoTSlRljVkcvGXBt5BES1znKvgcGtT6jxD3mhSO3X/UsskXAncKeji57okPT350Mbh88BfwVeBE+8OdnDNKErZo24WHL+g7nQ6WLvgTwW+Oyi+z38/cZ2HZXB3NYrpiodOQ2TxefpJaMlyp3Lq96O8gvSU5I8W4NA8gGzO6JwBiTvLCLRV4s4YYn8YWspsHc56HcBe/rvfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qpjXYyvgh1OIvujfxNG32EPFnha1uv3PsBWN7VzQuY=;
 b=IGHko/QljiuQ9+Q9ZnhN8uuQOmofI1fig9++c5r2WyvSuEFHdyaJqbkEBZl90IF5OAdbQ3AXjNQ+fb0quKPse+D3dQys4B49LPWYC5+vjy4DSHTof+IjPHZUUFT4brfhDu306SZCHuLuDH4SP4MQZV5NJ5Xiqy8IonmQD6Tlqrw=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SA1PR21MB1301.namprd21.prod.outlook.com (2603:10b6:806:1e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.1; Mon, 6 Jun
 2022 17:02:41 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::68e7:19d2:b892:127b]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::68e7:19d2:b892:127b%7]) with mapi id 15.20.5353.001; Mon, 6 Jun 2022
 17:02:41 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "quic_jhugo@quicinc.com" <quic_jhugo@quicinc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        =?iso-8859-2?Q?Krzysztof_Wilczy=F1ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: RE: Patch "PCI: hv: Fix multi-MSI to allow more than one MSI vector"
 has been added to the 5.18-stable tree
Thread-Topic: Patch "PCI: hv: Fix multi-MSI to allow more than one MSI vector"
 has been added to the 5.18-stable tree
Thread-Index: AQHYeZWxgOEDuTw1xUyk0KZkntBOz61CmGSA
Date:   Mon, 6 Jun 2022 17:02:41 +0000
Message-ID: <BYAPR21MB1270ADDD7775284F1187E823BFA29@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20220606110755.135215-1-sashal@kernel.org>
In-Reply-To: <20220606110755.135215-1-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6dc2be61-fa0e-4919-8f44-fa737ba40827;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-06-06T16:52:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76ce57de-736b-4045-344d-08da47de5e03
x-ms-traffictypediagnostic: SA1PR21MB1301:EE_
x-microsoft-antispam-prvs: <SA1PR21MB13014AB471279BE4013BD21DBFA29@SA1PR21MB1301.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AfRvHFK40Ha/c0qiImnmnqTLGsOwjECtKiMnWiOLNGLX1nibe2BJXB1oDURk9DQ1JhIwFt5OgGc14sclBY7Uyx52Tzy3ZYz9M0g9FaYyJWWCI+exWKKG3DLyu9C4Vk0fPHUncIigdu8eeCrw8GAdnGXs5/TY6dmKCErp05px55FmTZCGoFW0283hAVpNxr9dAoqaBIYh+OnmJSFNXUDFJnQxJnSGf9kvRNIKURQ7v7En2Zlml4LqPdCkK0f9XhfA5HgIvroMrRSr6S7V7r9E+xOuV/jOF9O0Ms74GsYrCnHltbPf2O45QFR6Ibs8zSvXNb7WyH9wDvZtFZy8bJ8ElMgntF2vqW4n3hDT6CKrrUclxgDSBFDyXG+QnLBK2PtXZKWfPMQZnn01xA6YhQmOqYM9LIABtgo5o2Ho2xrsl0N8exEAbk3SLY5Xh7FFpydJJ808iWCGyFlA3lQQ8P+IPENg4CPqMxf0XCqZz+dgrevPy9wqzN3sJCxkuO0RwFlSOTNuJ+4qEOX/rk+9Z+m1Ot5hqtf2hbiur8J5q7vmF3dbJvhwv2ansvWnfrxMq8Xq+aNQK+zM8FNo+3nW2nBNcbxU62zIM5EvRZdzOJ4mujcFOUI7c3JgtJPonO+GcYRP0z18TLDJlRFOXDQho1mMCYR4/WXzbh1suzjPwljKMu+iaudhBaFlwf62QhD59mAcXhwOUOS5s6HnXKVD0PsPDj+NccwSQHJfU5yj5u8rs2covuOS5jtM7AB6EPDZ7zQ5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(508600001)(71200400001)(9686003)(316002)(2906002)(86362001)(10290500003)(33656002)(110136005)(54906003)(38070700005)(8990500004)(122000001)(6506007)(7696005)(53546011)(82950400001)(82960400001)(66574015)(55016003)(8676002)(186003)(38100700002)(66946007)(26005)(76116006)(52536014)(64756008)(66446008)(66476007)(8936002)(66556008)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?6aLVqAmLfdL5sYFmrpoxvZXdncG2X9DM/npYfL+67r+OBiLvIpTPLj7y2H?=
 =?iso-8859-2?Q?AjNjOJPKIXdnqdy+j6dvoJY8oyA4YEn3gNcoDzXQLsHj0U1Vzu3JNqLnYs?=
 =?iso-8859-2?Q?kBZaiK4Al5tJVaSh3naKCkMXLYrgJLy4zpsNEM1P++necSvYDLTrV4TYC2?=
 =?iso-8859-2?Q?LkF63lG7Hc4dponTn9Yvm+yaDnzCCmT8Jm7UmyMvnPl+RyUTetcnNfF03a?=
 =?iso-8859-2?Q?673R3ghCiXpjItCtfCSaQA2CnLA+P+IJBJ7a7Svt8nyBk/Wut4TcCWYLzx?=
 =?iso-8859-2?Q?+cwdzYLjcu3xCbc1Gx/dvsc8po6m77jurxt9vel0ftIJdIVJ+h5jRDVwwk?=
 =?iso-8859-2?Q?veg3ffK+4opYzCbwvqEYJBTDQSkd1nY4S8J31J7N0MxEk23rdg+jQdjWrJ?=
 =?iso-8859-2?Q?NuBYfRYILuWt4YawpgZJp3zSX/eEnXpmRmqecmZJuW/gfV4FaMo91t7oE0?=
 =?iso-8859-2?Q?ZwmwcKKqixIcx0k/LFTuRE0FR82jVpZHm56fPKfRixFOdptI5qTZKha1da?=
 =?iso-8859-2?Q?JVWxgqzLGl5AFHoFmNiEuAMKI4DzRAXuLraPf5EdH4Lf+9SNe6FI9W8Dgd?=
 =?iso-8859-2?Q?hU8c+AA9hVzAtnGWRH/bbqfPF2GoqPCquYNZKJS/F4f2F3R2F8vnumDDsS?=
 =?iso-8859-2?Q?x0p+/KeUNr79vRvhNzugmOb0MQuFdIHWTOJiURjpsmkFc6rWO3XOas4Ngt?=
 =?iso-8859-2?Q?zdlA2eqhYg9FvY5K2QF3p4g8UhkxPg97bNdJTR3GvCVEinb7w79hRRUp8/?=
 =?iso-8859-2?Q?6ZyMt06VLepOXLQrOK9pREpDawrqXIoPRW46MzI1bv1oR+dVbAsmlENshJ?=
 =?iso-8859-2?Q?YW+6HTF+X13Pp9JlAZcOll0JrrQhq7y5Ly5q1x1/bcFjTfRtzpzYEFVK29?=
 =?iso-8859-2?Q?A0dKP05BQ/xjutMamSQvKIpeyTpgMoR+3Een0wjJRbkWUABdyoab3iInr9?=
 =?iso-8859-2?Q?GTw0yPgC2oO1fxcZL35wk0sNobhrApIdlLkiCDiRMMbaynBGErvCBNe7O4?=
 =?iso-8859-2?Q?TZA2aeXsczCdV0qPrdtKPjsPbMhqqdISc7duJ9NGAsqsJhAw7Se8wHMPb1?=
 =?iso-8859-2?Q?pfXh3zGL4gqs9MGIRTheu353oJJeH3K44mBzlnON6D4YxCR67qLtrf8ch/?=
 =?iso-8859-2?Q?7jhbL8Qj2m6G7KkpAw7Mf3Q55OFYZSzd5qi1Z2RrN+8caGm9FaOdKuFN99?=
 =?iso-8859-2?Q?/1WH+J8w95jeHKYX3sc9zhdUgLpXj2liFIm+sO3m9AmpobKOBp9fzRsAi1?=
 =?iso-8859-2?Q?BJaPiL099NQoZLuJ7xY70sH4n0ePUb4oyXU6VWrShx7Mps+MeblFE+ZKg2?=
 =?iso-8859-2?Q?02rjQuLGkCKVOyxS+97dC13YIpMb5Sx3UH+S+3taaKyN1sN1pQvSlYm3yJ?=
 =?iso-8859-2?Q?rAlcis13Lmmj+fDqO8DFkANd8TM9VTqkPKMQ/cmhE4OFbN7Rj93U2Vtb3N?=
 =?iso-8859-2?Q?sKHd15nWHJN7nSc+kD8H7YCic6ofY2DXhjXBRzDnwj2t6yIL94+FQkrOMT?=
 =?iso-8859-2?Q?7bo8JsltMJXD2FoR3qgCbVE5zyCCbp21TRIE22MTspRdNmLToDjPe4DQw9?=
 =?iso-8859-2?Q?apf1Y1M5/0Ep6GzNyB/KBm5NW0dzKLNrmax1GdpTaYjSpzMNKj55f6qdWg?=
 =?iso-8859-2?Q?f5xwqP6Tu2Ec1wkyvBAntzKrWTzy0deC+/zygicqvSqdGQDa8WfoV3Xlgo?=
 =?iso-8859-2?Q?thEEmh0GEjVeoTy7lijWNjYdNhQ/X3ydsVmKhuV71K27jEUK/cSBeq63rT?=
 =?iso-8859-2?Q?oeh7PRe4Cqpg2xlCuaV9kPVAdBsPCjY9bFQcEHImktf1wUfSNINhJI2j/Z?=
 =?iso-8859-2?Q?Fp7+IdJ0kg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ce57de-736b-4045-344d-08da47de5e03
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2022 17:02:41.1301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Orc4Fs+3kiEiZv99jM+vjg1SaI3WrU6uvexKcYFRn1wd/xomMpzYbxUVXcy6unMGEtB4KlUfGiuv7O6wvKLH4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB1301
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Sasha Levin <sashal@kernel.org>
> Sent: Monday, June 6, 2022 4:08 AM
> To: stable-commits@vger.kernel.org; quic_jhugo@quicinc.com
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>; Dexuan Cui <decui@microsoft.com>; Lorenzo
> Pieralisi <lorenzo.pieralisi@arm.com>; Rob Herring <robh@kernel.org>;
> Krzysztof Wilczy=F1ski <kw@linux.com>; Bjorn Helgaas <bhelgaas@google.com=
>
> Subject: Patch "PCI: hv: Fix multi-MSI to allow more than one MSI vector"=
 has
> been added to the 5.18-stable tree
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>     PCI: hv: Fix multi-MSI to allow more than one MSI vector

(+ stable@vger.kernel.org)

Hi Sasha and stable kernel maintainers,
If we want to support multi-MSI in the pci-hyperv driver, we need all of th=
e
4 patches:

08e61e861a0e ("PCI: hv: Fix multi-MSI to allow more than one MSI vector")
455880dfe292 ("PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI")
b4b77778ecc5 ("PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()=
")
a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MSI")

Multi-MSI can't work properly if we only pick up the first patch.

We need to either pick up all the 4 patches to 5.18/5.17/etc. or pick up no=
thing.
I suggest we pick up all the 4 patches.=20
The patch author Jeffrey may want to chime in.

Thanks,
-- Dexuan
