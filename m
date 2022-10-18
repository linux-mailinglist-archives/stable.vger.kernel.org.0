Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ED8603633
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 00:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiJRWpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 18:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJRWpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 18:45:44 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCD4CC82E;
        Tue, 18 Oct 2022 15:45:40 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29ILBg9T032109;
        Tue, 18 Oct 2022 15:45:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=0J1iFdU3G1znYL27+52AMQR4ilKd9idcvwpOxxPQzYs=;
 b=Z/AON7m7/KAcGizRHW25cQljwcwy6bAJuAq5WuNEOTzzkmJpoVkE4NpIQqyhQ74tylw+
 lsGf0A7g7VFC2QJJMsunSkD1alH0cnTzcKZMbSzyNzkd8rkzq+apDmpVuFgHs2vKuTHS
 PXBA/1hrXJwyX3Tom//TaxsNnOlmfd4Av1qRkweczaqoZEuyZenzrQCmeTMRiNc4qTYr
 EMKJoOaLI+aE2DSDiWhottS7sCld9yVb6daUiQcUL1TOQKm+IuMgikNEcWRBIX/N6/tE
 TOo8vDjA1hevxVVVSMagA2R1Jg9xYseXTir2Xu094fb0K/MJH5Gzj4+Z3BjhRQDQBtvp Jw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7usuv11d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 15:45:24 -0700
Received: from mailhost.synopsys.com (badc-mailhost4.synopsys.com [10.192.0.82])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4A03240083;
        Tue, 18 Oct 2022 22:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666133123; bh=0J1iFdU3G1znYL27+52AMQR4ilKd9idcvwpOxxPQzYs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=VJitNCkHC3L7y3gwrzgENpfkHm4LQLKZtaDThCZY2+Vry3IbxsOp0FewxTUn1JDvj
         ur9fvhWQb6CtSzEgfyCk2h4YXzZL+CRShXjTEN1Xz3fje2nLNShw+YyAVgCmHi5MC0
         GoUkhefKSmjmtyBwSMLch/zqxSKAJNLWYz+71N03oqHDjP6jpHXZEV4X1yjvRGeTFB
         +VnIVoIzVzwdh4/SRiQSE7gcVKmBktdxLmLeyq2XOVK4gs+6PxW0bmGGkVJNphSTn1
         OSkXCWIXbgJTIO91sZRovSCYvMGNZn6laN43Y3UmUhoyS++Ux+wtWEWs2XryigKuEK
         EA7Q0WSdr3qcg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id BEE7BA006F;
        Tue, 18 Oct 2022 22:45:20 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id AFAEA801FE;
        Tue, 18 Oct 2022 22:45:19 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="aJqOkpQ5";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aan99iDIAno94H3xEHizlOTovWSdKIfDbX448xaokasr7CGfXasN91Fb6FkNBgQYMYgg5HjjOaUD0lfwmbrLfhO2GAG6SzwEJfB7axX8Dqf+HJs3thfeyycuAiSTuzlakHUOxBiC2vr6L5yKmfeE+Q5woX6n/lzSdU99ytTtqfCZMO6XZP15fODADrf5lq4JkBkpoHOiR0LAHcv6ZV6FhGBDjsJMa5BpyS/FFozkeCL8ILVNtN55amHvnwat6l3OonEATwhHYJd7S4iLpebJMvZUyumY39i6gegXp3YN9YuR/ola4x4AsSse/3hBI1/IJS/N0KPuhUJN/+Nazr36wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0J1iFdU3G1znYL27+52AMQR4ilKd9idcvwpOxxPQzYs=;
 b=d/o+88EE1U89KzJACT9fuj3WzotQD9I1YLLI2xCIX/RgcWzdPBwwHHhEw0xCbPDdkHOHmJUCLpmSgilYA4CSGJLrTr+zTbbOMrr+01/O+Y6uBnPedZ3jwPoSTRNvubq3PFk1cUMzU0JrUrT2867RWGp7X2jlZ0qA0yE/lMYCxFiZN/cNQ7e2fGmnJAxz5tMzzTNYFT6xTsqZUjzVYgVPLIi/B2SUOmVBhlXWSuowaRCXzOJH4FRxm6CDp1RTfJh28KtrETfQG/z/BqXCUf12Vq4xir0VtAJHIt6Zw9XgdnLHaYpQGyksWW5EYfTL11dSG4JaDwjzW29YGl9G6fCOUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0J1iFdU3G1znYL27+52AMQR4ilKd9idcvwpOxxPQzYs=;
 b=aJqOkpQ5P7JWrnt9lQz71+hbDIuVRGfBaagmm+6mt6vnXrkrKBxFDIPeAY6sAs29Nt/OSmnrRLGluPWGJ1/n1z42jfo/oY9ufp3uT2aqXTvHVdiN9wTu3Br8JHVEFcRj3Gqzjj630OAXriEao3EgmHBNj9cqCcFsNV/mzVzMYrc=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by DS7PR12MB5984.namprd12.prod.outlook.com (2603:10b6:8:7f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Tue, 18 Oct
 2022 22:45:16 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Tue, 18 Oct 2022
 22:45:16 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Michael Grzeschik <mgr@pengutronix.de>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Dan Vacura <w36195@motorola.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Jeff Vanhoof <qjv001@motorola.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Topic: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Index: AQHY4mrMbMdbRPcOxEKXMohPF6Ycjq4TGoiAgABOUICAARXvgIAAB78AgAA7LQA=
Date:   Tue, 18 Oct 2022 22:45:16 +0000
Message-ID: <20221018224506.g7qv632fznfbprhz@synopsys.com>
References: <20221017205446.523796-1-w36195@motorola.com>
 <20221017205446.523796-3-w36195@motorola.com>
 <20221017213031.tqb575hdzli7jlbh@synopsys.com> <Y04K/HoUigF5FYBA@p1g3>
 <20221018184535.3g3sm35picdeuajs@synopsys.com>
 <20221018191318.GB9097@pengutronix.de>
In-Reply-To: <20221018191318.GB9097@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|DS7PR12MB5984:EE_
x-ms-office365-filtering-correlation-id: 81c47d25-0136-4cf4-0f5e-08dab15a6d14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FsGJLxbKJqMal9UZ0bDRGhUZIHcmQ6CUJe7mwZCNM5ApT9WE1h5bkb9VWXWJ2ue16tgFxikwFERhAWY/wEPd0asBiXVnqr2x6mSTB+qNCq85+hympZqlZwE9oZbkOesiOiUT6QUasO9EvC7P8DnKm7nshnYU9IQwyR7ZwdAwCNhhh7Tko410dyaVzy8JIOF+bMydp1fV4IB0mt9sLaGRinKS+RwnGphcU7VsuL3IWygX99r9XhoN3g1Yfuy+OZZ0flPA5Mjxm5ifV48QOApT4v2J2H9+zkB6EUkNE6/7o5G+tpIHE0TuDdfctKHXPJ62yaSnPZ57dsR2LM12OHjRk7VgECTblByPvFIsACjJO6yoyauJfVPQB+sJuMoS+LAPF+4NdV+n6mBmdqvQUetA3lcLnV9BcsnRaGtJFJQAbHM/hSyLRDcwZh2le91dXPqvZ7JRNvnZzmU1rKsQz+knbQnUIZJASMIZv/qgZLZ7nyDgnWo9D6WrjD4pepcjZSgNaDUWdo1VMMDWPLO2NQz2QbwfkfArtm9zdc1Oq1t4hLhWcrA7227My7+q+Ks5ssob2TxYt3S3ODZPGCM0bN1uIWafIyASycQa4uNncvZ0Lmqcvj+DLwFdVmnmLfqMv3pqbMSglnRmrR3AGAxSE4ZK5lbrYkjAXak6gMNwTKyi0lgdDqvPxbxgYcUdDUWyhz0m6eACyvGSKavBushJKYu+rQJ5H9woYrT+KmKP8+jHLW0DmCnU2X8EB2nLtXZHnT5u9XUgcR7yoMn94aO4PZCBvxa32loHWjfxutjn/JDbcn4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(39860400002)(136003)(376002)(84040400005)(451199015)(6486002)(64756008)(76116006)(6916009)(478600001)(4326008)(8676002)(5660300002)(7416002)(316002)(966005)(66556008)(66476007)(66446008)(66946007)(71200400001)(2906002)(86362001)(36756003)(8936002)(41300700001)(6506007)(83380400001)(1076003)(186003)(38100700002)(54906003)(38070700005)(26005)(122000001)(2616005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0Vuc1pzRHArZ3dKOUZjOE9ELytWVVYrMnZMeHdWQUs2NythS3FpYUlPSm5S?=
 =?utf-8?B?NWY2SnlrZisxZ2ZWSnQ4ZHF1L2F0Q25JaFlDV1VEVDh4K1Z2OFN0NlNsb2xG?=
 =?utf-8?B?THBVbFdEQ0VUV1h1WEJKZGowc2lyeEpZNDJiRjJvc2t4MndTc1AyMHhHU0JN?=
 =?utf-8?B?bTkyWkZnd1BGL1U0THhiOTdjTU1ra0R1OHpmM3BabnhsMlhMdGpEMHNnTHlF?=
 =?utf-8?B?NXZiZUkyTHlwYk5Pb1pmZHBXZ05QYTIyRU5uNXllU3lqZlBxWnFUd05ldGVG?=
 =?utf-8?B?c1o1c1plS1lqZk5Qb0s1ekF1a2xVN2RRZmoydGJpenRYallFR0RRTVAxVXlu?=
 =?utf-8?B?amhqdi81M3ZPVlF4RjdwcG9CT0IwSCtQRTlwbzk5NDVtLzZremhCN0o3U21i?=
 =?utf-8?B?UGpuRW9Ndlk0aUF0Y0hSNWl2bjR2enNNamhudmhyU3ZqZkRDaVJvWjk2eHBR?=
 =?utf-8?B?MEZFcWxIcnRmeW8yWUQ2dGVzenF1aDJXK0hVUUI3UmdWNEg1WnRkcW9acnds?=
 =?utf-8?B?NWVOdmlhdytvNGcraFE0ZEQ1ZXhhYnY0NnRMVEdQOVFKQzBiSkFMU0J2cURS?=
 =?utf-8?B?eTFzdE05eWJ1SHNPaE9qY2hZR3ZZNzk5enNpTlQxTXhFV3duSEllU3RZL2tm?=
 =?utf-8?B?YXdRVk9IVWh4VmQzS0FnUmpuNmt3N1E4d2ptVXA3TFVlb3FqZFdQeVFBNmVx?=
 =?utf-8?B?YnhFV3h2K3VGendJY201Y3hCQzhhUG1sK240UUM3djA1K1UzMnAyeHBFeDhp?=
 =?utf-8?B?ejFxVkdMVlROb0ora1B5WUpPblc4YnlkaytPMllCbjRxcmwxdktlNUd5clNo?=
 =?utf-8?B?K0dPSFpzbExPN1FUMDJNVUE2UEdzeElrZ2wxT3FpUVRWMVA5N3VIRlkxdnMr?=
 =?utf-8?B?T1VJcHQxM2pjYnI5N0Vram9yb0xiZnpNMWtIVHplWkZtSGxFMnNqTXRTNzlD?=
 =?utf-8?B?ZTd1bjNJMm1nS1J5Ykk3ekYydHZnWDVYaDFtT09GR2dQRmlZRVh3cHVQRy9n?=
 =?utf-8?B?R2wzRXNNTFRFQnhIVklJVlQ2ZGFkajg2KzEzckRXRFFaemMvZzV5cDlaRzky?=
 =?utf-8?B?d0lHNEo0K3VIaXN1SEpOMkJ3V2Q3OENnUTQwd3JyL1hrc1pBVlNEOHFSaGN6?=
 =?utf-8?B?T1YxeE9xNk1Md0tGcHVSUldvU2dIUU5DWFVPMk53T2lkOTdpMkFNWnJTV2NO?=
 =?utf-8?B?Z3ZxVWZJeC9JcDRaN3dBOGs5NnFVL0FWSDhtZ1p2WTRxNm9BYVJTMXdTVG1N?=
 =?utf-8?B?aGRiY2FpRGZyV0tzYVVwdlUwZi84bmgxMnpKbW1aYzI4RHN0QnB6ZVE3eGdl?=
 =?utf-8?B?aHFLNno5Rkk4Y3gzbkJIV2RveDFOQklTZzJLejUxcVVadHplYmtrRXhKam83?=
 =?utf-8?B?REFlcFpWRGtIb0d2eU1RQ0dJbVlJR1psSEszQ0w3NkZIdTFaOWdyZ0I5TmhU?=
 =?utf-8?B?bThwNU50SVBqejFaWmFBVHdyM3RmZXRtMXEwWVVKRWNrNDc1c0NUUG1kNHh1?=
 =?utf-8?B?RFl0NytpdjFJb3hXejhSY1RqTG9Va2xlbVc0R3hjZVpMWDFGNHY0NTN5YkJJ?=
 =?utf-8?B?bW82SHpQc3pmNkJMZGpkc1FUOVNsR3A4Z0hGNUNDbUtwKy95cU1hamNzTHNy?=
 =?utf-8?B?Y3NGVDlGTWNLN3lVYUxDZHUyQS95R2FSWUhOOXlDLytaWTJwZVRYKzNSSmhV?=
 =?utf-8?B?eDNFdnBBR1N5K25yNFJNL2dMamtDbElpWTZxV1JaMnpJVHB1TkxFNE05M0Ey?=
 =?utf-8?B?dmpoSHMySEdUSGtyUzRDeW1WTFRZQXVySkZHem95amowbkhraXFWKzhYVmNS?=
 =?utf-8?B?bnhpNWVPSFY1dTVFQms4d2ZIYzZoRmx2REllVDdFOTlkc0kzMmNzUDZ2ZHNS?=
 =?utf-8?B?dDM2RDdJcTl3cVBaNmVhbFV2eTVNbTVSbjRmaU04SzhpOU44MjlGSjFBRHZ2?=
 =?utf-8?B?NVgxTGF6dFI0Q2w4OEhnNWRlUHFscUlnaHlYdy81TGxpUFN1ZXduaFd3VWl4?=
 =?utf-8?B?ZXNuS2JZTlQycGd0dUVKNjN3WlFadHdmMUd1YXFET0FNaWZ6WElsdEE4NG1Y?=
 =?utf-8?B?QWc3VURieVdremx6Yzh1eXh1UkdwQVF3ejhpMW5acG9UNzBrK0RaV0hxMzFY?=
 =?utf-8?Q?oFW4zhwe78xr0Gvhrenp1l8b0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28D3308D450C014C9572E4EB22029F94@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c47d25-0136-4cf4-0f5e-08dab15a6d14
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 22:45:16.0925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rzVZ3oWMNmbCSTLSyE35OIOFRKaDfsX7E6CGDLiK3Bztl7dFxg4ktgZKil56FkgKueHXAf0EV8EvalYKjvg8Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5984
X-Proofpoint-ORIG-GUID: y3k_go9mzEtWM6If4-MpHASGF6dFVO7Y
X-Proofpoint-GUID: y3k_go9mzEtWM6If4-MpHASGF6dFVO7Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 adultscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210180128
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBPY3QgMTgsIDIwMjIsIE1pY2hhZWwgR3J6ZXNjaGlrIHdyb3RlOg0KPiBIaSBUaGlu
aCwNCj4gDQo+IE9uIFR1ZSwgT2N0IDE4LCAyMDIyIGF0IDA2OjQ1OjQwUE0gKzAwMDAsIFRoaW5o
IE5ndXllbiB3cm90ZToNCj4gPiBPbiBNb24sIE9jdCAxNywgMjAyMiwgRGFuIFZhY3VyYSB3cm90
ZToNCj4gPiA+IE9uIE1vbiwgT2N0IDE3LCAyMDIyIGF0IDA5OjMwOjM4UE0gKzAwMDAsIFRoaW5o
IE5ndXllbiB3cm90ZToNCj4gPiA+ID4gT24gTW9uLCBPY3QgMTcsIDIwMjIsIERhbiBWYWN1cmEg
d3JvdGU6DQo+ID4gPiA+ID4gRnJvbTogSmVmZiBWYW5ob29mIDxxanYwMDFAbW90b3JvbGEuY29t
Pg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gYXJtLXNtbXUgcmVsYXRlZCBjcmFzaGVzIHNlZW4gYWZ0
ZXIgYSBNaXNzZWQgSVNPQyBpbnRlcnJ1cHQgd2hlbg0KPiA+ID4gPiA+IG5vX2ludGVycnVwdD0x
IGlzIHVzZWQuIFRoaXMgY2FuIGhhcHBlbiBpZiB0aGUgaGFyZHdhcmUgaXMgc3RpbGwgdXNpbmcN
Cj4gPiA+ID4gPiB0aGUgZGF0YSBhc3NvY2lhdGVkIHdpdGggYSBUUkIgYWZ0ZXIgdGhlIHVzYl9y
ZXF1ZXN0J3MgLT5jb21wbGV0ZSBjYWxsDQo+ID4gPiA+ID4gaGFzIGJlZW4gbWFkZS4gIEluc3Rl
YWQgb2YgaW1tZWRpYXRlbHkgcmVsZWFzaW5nIGEgcmVxdWVzdCB3aGVuIGEgTWlzc2VkDQo+ID4g
PiA+ID4gSVNPQyBpbnRlcnJ1cHQgaGFzIG9jY3VycmVkLCB0aGlzIGNoYW5nZSB3aWxsIGFkZCBs
b2dpYyB0byBjYW5jZWwgdGhlDQo+ID4gPiA+ID4gcmVxdWVzdCBpbnN0ZWFkIHdoZXJlIGl0IHdp
bGwgZXZlbnR1YWxseSBiZSByZWxlYXNlZCB3aGVuIHRoZQ0KPiA+ID4gPiA+IEVORF9UUkFOU0ZF
UiBjb21tYW5kIGhhcyBjb21wbGV0ZWQuIFRoaXMgbG9naWMgaXMgc2ltaWxhciB0byBzb21lIG9m
IHRoZQ0KPiA+ID4gPiA+IGNsZWFudXAgZG9uZSBpbiBkd2MzX2dhZGdldF9lcF9kZXF1ZXVlLg0K
PiA+ID4gPg0KPiA+ID4gPiBUaGlzIGRvZXNuJ3Qgc291bmQgcmlnaHQuIEhvdyBkaWQgeW91IGRl
dGVybWluZSB0aGF0IHRoZSBoYXJkd2FyZSBpcw0KPiA+ID4gPiBzdGlsbCB1c2luZyB0aGUgZGF0
YSBhc3NvY2lhdGVkIHdpdGggdGhlIFRSQj8gRGlkIHlvdSBjaGVjayB0aGUgVFJCJ3MNCj4gPiA+
ID4gSFdPIGJpdD8NCj4gPiA+IA0KPiA+ID4gVGhlIHByb2JsZW0gd2UncmUgc2VlaW5nIHdhcyBt
ZW50aW9uZWQgaW4gdGhlIHN1bW1hcnkgb2YgdGhpcyBwYXRjaA0KPiA+ID4gc2VyaWVzLCBpc3N1
ZSAjMS4gQmFzaWNhbGx5LCB3aXRoIHRoZSBmb2xsb3dpbmcgcGF0Y2gNCj4gPiA+IGh0dHBzOi8v
dXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3Qv
bGludXgtdXNiL3BhdGNoLzIwMjEwNjI4MTU1MzExLjE2NzYyLTYtbS5ncnplc2NoaWtAcGVuZ3V0
cm9uaXguZGUvX187ISFBNEYyUjlHX3BnIWFTTlotSWpNY1BnTDQ3QTROUjVxcDlxaFZsUDkxVUdU
dUN4ZWo1TlJUdjgtRm1Uck1rS0s3Q2pOVG9RUVZFZ3RwcWJLekxVMkhYRVQ5TzIyNkFFTiQNCj4g
PiA+IGludGVncmF0ZWQgYSBzbW11IHBhbmljIGlzIG9jY3VycmluZyBvbiBvdXIgQW5kcm9pZCBk
ZXZpY2Ugd2l0aCB0aGUgNS4xNQ0KPiA+ID4ga2VybmVsIHdoaWNoIGlzOg0KPiA+ID4gDQo+ID4g
PiAgICAgPDM+WyAgNzE4LjMxNDkwMF1bICBUODAzXSBhcm0tc21tdSAxNTAwMDAwMC5hcHBzLXNt
bXU6IFVuaGFuZGxlZCBhcm0tc21tdSBjb250ZXh0IGZhdWx0IGZyb20gYTYwMDAwMC5kd2MzIQ0K
PiA+ID4gDQo+ID4gPiBUaGUgdXZjIGdhZGdldCBkcml2ZXIgYXBwZWFycyB0byBiZSB0aGUgZmly
c3QgKGFuZCBvbmx5KSBnYWRnZXQgdGhhdA0KPiA+ID4gdXNlcyB0aGUgbm9faW50ZXJydXB0PTEg
bG9naWMsIHNvIHRoaXMgc2VlbXMgdG8gYmUgYSBuZXcgY29uZGl0aW9uIGZvcg0KPiA+ID4gdGhl
IGR3YzMgZHJpdmVyLiBJbiBvdXIgY29uZmlndXJhdGlvbiwgd2UgaGF2ZSB1cCB0byA2NCByZXF1
ZXN0cyBhbmQgdGhlDQo+ID4gPiBub19pbnRlcnJ1cHQ9MSBmb3IgdXAgdG8gMTUgcmVxdWVzdHMu
IFRoZSBsaXN0IHNpemUgb2YgZGVwLT5zdGFydGVkX2xpc3QNCj4gPiA+IHdvdWxkIGdldCB1cCB0
byB0aGF0IGFtb3VudCB3aGVuIGxvb3BpbmcgdGhyb3VnaCB0byBjbGVhbnVwIHRoZQ0KPiA+ID4g
Y29tcGxldGVkIHJlcXVlc3RzLiBGcm9tIHRlc3RpbmcgYW5kIGRlYnVnZ2luZyB0aGUgc21tdSBw
YW5pYyBvY2N1cnMNCj4gPiA+IHdoZW4gYSAtRVhERVYgc3RhdHVzIHNob3dzIHVwIGFuZCByaWdo
dCBhZnRlcg0KPiA+ID4gZHdjM19nYWRnZXRfZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdCgp
IHdhcyB2aXNpdGVkLiBUaGUgY29uY2x1c2lvbg0KPiA+ID4gd2UgaGFkIHdhcyB0aGUgcmVxdWVz
dHMgd2VyZSBnZXR0aW5nIHJldHVybmVkIHRvIHRoZSBnYWRnZXQgdG9vIGVhcmx5Lg0KPiA+IA0K
PiA+IEFzIEkgbWVudGlvbmVkLCBpZiB0aGUgc3RhdHVzIGlzIHVwZGF0ZWQgdG8gbWlzc2VkIGlz
b2MsIHRoYXQgbWVhbnMgdGhhdA0KPiA+IHRoZSBjb250cm9sbGVyIHJldHVybmVkIG93bmVyc2hp
cCBvZiB0aGUgVFJCIHRvIHRoZSBkcml2ZXIuIEF0IGxlYXN0IGZvcg0KPiA+IHRoZSBwYXJ0aWN1
bGFyIHJlcXVlc3Qgd2l0aCAtRVhERVYsIGl0cyBUUkJzIGFyZSBjb21wbGV0ZWQuIEknbSBub3QN
Cj4gPiBjbGVhciBvbiB5b3VyIGNvbmNsdXNpb24uDQo+ID4gDQo+ID4gRG8gd2Uga25vdyB3aGVy
ZSBkaWQgdGhlIGNyYXNoIG9jY3VyPyBJcyBpdCBmcm9tIGR3YzMgZHJpdmVyIG9yIGZyb20gdXZj
DQo+ID4gZHJpdmVyLCBhbmQgYXQgd2hhdCBsaW5lPyBJdCdkIGdyZWF0IGlmIHdlIGNhbiBzZWUg
dGhlIGRyaXZlciBsb2cuDQo+ID4gDQo+ID4gPiANCj4gPiA+ID4NCj4gPiA+ID4gVGhlIGR3YzMg
ZHJpdmVyIHdvdWxkIG9ubHkgZ2l2ZSBiYWNrIHRoZSByZXF1ZXN0cyBpZiB0aGUgVFJCcyBvZiB0
aGUNCj4gPiA+ID4gYXNzb2NpYXRlZCByZXF1ZXN0cyBhcmUgY29tcGxldGVkIG9yIHdoZW4gdGhl
IGRldmljZSBpcyBkaXNjb25uZWN0ZWQuDQo+ID4gPiA+IElmIHRoZSBUUkIgaW5kaWNhdGVkIG1p
c3NlZCBpc29jLCB0aGF0IG1lYW5zIHRoYXQgdGhlIFRSQiBpcyBjb21wbGV0ZWQNCj4gPiA+ID4g
YW5kIGl0cyBzdGF0dXMgd2FzIHVwZGF0ZWQuDQo+ID4gPiANCj4gPiA+IEludGVyZXN0aW5nLCB0
aGUgZGV2aWNlIGlzIG5vdCBkaXNjb25uZWN0ZWQgYXMgd2UgZG9uJ3QgZ2V0IHRoZQ0KPiA+ID4g
LUVTSFVURE9XTiBzdGF0dXMgYmFjayBhbmQgd2l0aCB0aGlzIHBhdGNoIGluIHBsYWNlIHRoaW5n
cyBjb250aW51ZQ0KPiA+ID4gYWZ0ZXIgYSAtRVhERVYgc3RhdHVzIGlzIHJlY2VpdmVkLg0KPiA+
ID4gDQo+ID4gDQo+ID4gQWN0dWFsbHksIG1pbm9yIGNvcnJlY3Rpb24gaGVyZTogYSByZWNlbnQg
Y2hhbmdlDQo+ID4gYjQ0YzBlN2ZlZjUxICgidXNiOiBkd2MzOiBnYWRnZXQ6IGNvbmRpdGlvbmFs
bHkgcmVtb3ZlIHJlcXVlc3RzIikNCj4gPiBjaGFuZ2VkIC1FU0hVVERPV04gcmVxdWVzdCBzdGF0
dXMgdG8gLUVDT05OUkVTRVQgd2hlbiBkaXNhYmxlIGVuZHBvaW50Lg0KPiA+IFRoaXMgZG9lc24n
dCBsb29rIHJpZ2h0Lg0KPiA+IA0KPiA+IFdoaWxlIGRpc2FibGluZyBlbmRwb2ludCBtYXkgYWxz
byBhcHBseSBmb3Igb3RoZXIgY2FzZXMgc3VjaCBhcw0KPiA+IHN3aXRjaGluZyBhbHRlcm5hdGUg
aW50ZXJmYWNlIGluIGFkZGl0aW9uIHRvIGRpc2Nvbm5lY3QsIC1FU0hVVERPV04NCj4gPiBzZWVt
cyBtb3JlIGZpdHRpbmcgdGhlcmUuDQo+ID4gDQo+ID4gSGkgTWljaGFlbCwNCj4gPiANCj4gPiBD
YW4geW91IGhlbHAgY2xhcmlmeSBmb3IgdGhlIGNoYW5nZSBhYm92ZT8gVGhpcyBjaGFuZ2VkIHRo
ZSB1c2FnZSBvZg0KPiA+IHJlcXVlc3RzLiBOb3cgcmVxdWVzdHMgcmV0dXJuZWQgYnkgZGlzY29u
bmVjdGlvbiB3b24ndCBiZSByZXR1cm5lZCBhcw0KPiA+IC1FU0hVVERPV04uDQo+IA0KPiBXaGVu
IHdyaXRpbmcgdGhlIHBhdGNoLCBJIHdhcyBsb29raW5nIGludG8NCj4gRG9jdW1lbnRhdGlvbi9k
cml2ZXItYXBpL3VzYi9lcnJvci1jb2Rlcy5yc3QuDQo+IA0KPiBBZnRlciBsb29raW5nIGludG8g
aXQgdG9kYXksIEkgc2VlIHRoYXQgRVNIVVRET1dOIHNob3VsZCBiZSBzZW5kIG9uDQo+IGVwX2Rp
c2FibGUgKGRldmljZSBkaXNhYmxlKSBhbmQgRUNPTk5SRVNFVCBvbiBzdG9wX2FjdGl2ZV90cmFu
c2Zlci4NCj4gU28gSSBwcm9iYWJseSBqdXN0IG1peGVkIHRoZW0gdXAsIHdoaWxlIHdyaXRpbmcg
dGhlIHBhdGNoLiA6Lw0KPiANCg0KSSB0aGluayB5b3UgbWVhbiBFQ09OTlJFU0VUIGZvciBlcF9k
ZXF1ZXVlKCk/DQpkd2MzX3N0b3BfYWN0aXZlX3RyYW5zZmVyKCkgaXMgY2FsbGVkIGZvciBib3Ro
IHNjZW5hcmlvcy4NCg0KPiBUaGUgZm9sbG93dXAgcGF0Y2ggd291bGQgdGhlbiBqdXN0IGJlIHRv
IHN3YXAgdGhlIHN0YXR1cyByZXN1bHRzIG9mDQo+IF9fZHdjM19nYWRnZXRfZXBfZGlzYWJsZSBh
bmQgZHdjM19zdG9wX2FjdGl2ZV90cmFuc2ZlcnMgb24gdGhlDQo+IGR3YzNfcmVtb3ZlX3JlcXVl
c3RzIGNhbGwuDQo+IA0KPiBNaWNoYWVsDQoNCkNhbiB5b3UgaGVscCBtYWtlIGEgZml4Pw0KDQpU
aGFua3MhDQpUaGluaA==
