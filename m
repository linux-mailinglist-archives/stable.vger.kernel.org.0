Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71F3637EEF
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 19:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKXSbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 13:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKXSbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 13:31:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7851E7F5B9;
        Thu, 24 Nov 2022 10:31:19 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOIT1Sw006916;
        Thu, 24 Nov 2022 18:31:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=dUS1PA1UkkMCjYqqvNLizt0sSxc0ca7nmcNQ1kxjWoE=;
 b=VIWtv7Tm/AXiMEe3X6WeygOpzdXn7LkIHZH/u5Q/nqbzXmOtZ5AoK7FI8RLHQxkwFnXx
 aEw1UJIPz5wnZBVuAWzXBn0Ohlo7Vb9Ka8JTsPsAx1mOUOPNJLXSq0CTS0ygJX8isWr9
 EfdHokDaqTGADR91nHhc2GhY2yuN+fiQcbZamijQqdNex5pDymyqgor1tsQWdAS52MLu
 iBauJWGf2d+EkIIVDnNf4h+8J7zr7kn2swechdWwIkfIrhCRJT4itqgQ8H6dNznV3bGU
 qStuWA4q0RVIkuHaHJDAP1bqVL0GCQPW93zWEVlC37nBrtHr3IxEHOhfddYB5WsHgEXV tQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1p5fk5gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 18:31:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AOGeDEg004529;
        Thu, 24 Nov 2022 18:31:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk8d614-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 18:31:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEj9uvh/BDu4UhWoeQ5ExMZeZxI5+LnU1MIJHqoe6GWMGJU8Ac8HeYDZ14p1dE6Exd69K8tWf3FcAiCuSlJkWB+lw07n7L7uVTOxq4SGtn9x2o4tUOfkG7mZOQOA7IOgSKeJPda/0y4sbZb4qHO2uxtspt1nZe2YNdjMsly5oF3QoVrSrp1pZ8rEEaDaQvM3TBsN60gkRXEqZIhyQSTqfZkauxtNfc77yIz3fFFepGqPV6MOs3GVBsE7nqT4VnF5VHsGXneCViOH3RVdSDIt+EEqMEVnUXCSePqiyTZCCcgPAp1O7DWZgB8JyaWs+mxDi/aFi85ITpfMZiIYGoAOvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUS1PA1UkkMCjYqqvNLizt0sSxc0ca7nmcNQ1kxjWoE=;
 b=UZhqArlQMcWZbqG9GLm10jMohar2S16SPPjz2JNX9hC17B7cBGCmjikBrV9gW1bveWG9kfJKz2suDfHfGe+g53YJEm4coMAVbsjO0euoCDApTrAcfAGIiQQizjmPr5YGY/8fSjvXb6F8lLeLwjpCFWJxdpfrFXLacvJ0mVUMYtZ7nFRPTmIdR9SXkgWHaNgAsnDtyIRerEj1vNcZCzR4RcQ4z9pNmUzDhxm+9ZGkw6w6//csHX8xAngpX7OjkoZpOb0Vf++FesQ9zozVstquHQdjeMAhp38nMbnnpN51BvVQr45SzpeZ0t7DTdgI8zADYAjvTPCPwzh47pn4fVeD5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUS1PA1UkkMCjYqqvNLizt0sSxc0ca7nmcNQ1kxjWoE=;
 b=OM0h2QaiHZm7goMm2mQYbWqawlsbBSdyxzhguP++7q17arQ4qF/GhY3SZRsd8HRm8aQ6gCMl15eFEMZwlZ/WbJ1f09yR3sWVTmZW51blqp1DQzSWOn2khzF0sjRLjGz9feV+szf/sY7Cu0KPE3vIup20wQMyVlPb0+ue7UShzDY=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CO1PR10MB4482.namprd10.prod.outlook.com (2603:10b6:303:99::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 18:31:02 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::b500:ee42:3ca6:8a9e]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::b500:ee42:3ca6:8a9e%5]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 18:31:02 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Anders Blomdell <anders.blomdell@control.lth.se>
CC:     Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] Make nfsd_splice_actor work with reads with a
 non-zero offset that doesn't end on a page boundary
Thread-Topic: [PATCH v2 1/1] Make nfsd_splice_actor work with reads with a
 non-zero offset that doesn't end on a page boundary
Thread-Index: AQHY/239SEcVcSHvz0mNdsR515WWZ65OZvKA
Date:   Thu, 24 Nov 2022 18:31:02 +0000
Message-ID: <716E1527-6C55-4A16-8330-DEF32BDAF4D1@oracle.com>
References: <9e45fed2-f9e9-8c5e-3c33-993de330f11e@control.lth.se>
In-Reply-To: <9e45fed2-f9e9-8c5e-3c33-993de330f11e@control.lth.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CO1PR10MB4482:EE_
x-ms-office365-filtering-correlation-id: 7866dacb-7eef-4072-5de4-08dace4a0aae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CMmaJY9gbl3lEzWxlILeSZojXFGq61K5BPOoMtLOPlhrPDfXgcl3FAzd/eEdKcybBZE4sVPYsPsyPmn1hlT22xqUfgjX8S+GZDLeVemlKaYUEbdW3JYxOuXfbCuLOa3wDbzSqgURVrNLpNcelvUcSwQ79mBLK3AEtBTE0jDSMlBwDK/CtqngGrNFf299i4EU0LAiY7DLRMkG6Q7+YRqJ+Ga49e0ZQdK8MFhRqx7QZYDrP76NPJAWQ9GUirBNWgZqH1ZrV1u4+mLWZNrW+vgBuhW411yVZ+LF6B6a1C1O8tolfzeTCc2RK8m/88ZoeqzpoR3Vt1QADBnR1O4j0QmEvK07qsPalpvtdpJw5rrev7SKFUQC90geT29btKNdTFE5ccQNb9dcgrDke1FNTSPjZSsmE8YwBAhz/1vlNlDPU74P5i5aI89qPKdcOVit35+bxIisAuozloEfELHpzYpah0rXits4xHfJYXEq8Kx7ZzK4rG7tkPjI4BMlXEUzh8GuHhU6Y99dTBPOxyB9FM+0L0Z6zulIhQvJ0bc8vmzHBut/s2noYzoVHABp8gTP0zyv2itDSJqjMRi87cFcm6hbJeTHHiXRuBPcZeKXFXTfRheYw6GfgQF2D6SlGLaDAPKu90/caZPFDlNxFPHnThYD6jw1DU1gWij5iwVOftxOV30zX+lxgIBHfOiWnJ5yCPJj/+pNqDuBv1Bcfh0O3QfgZK2SMeTPRmhhjQEs1w7v1xyuduNdAoVidK6JlgOd5wiZNPEE+5pplZsD0rhO6XUPUilZNiiwmy0sEo2Aa+AL1oagpXD91kIOr3t6oxxy2B2z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199015)(2906002)(122000001)(83380400001)(26005)(8936002)(6916009)(38070700005)(41300700001)(6512007)(6506007)(54906003)(316002)(86362001)(33656002)(186003)(2616005)(36756003)(5660300002)(53546011)(76116006)(91956017)(478600001)(38100700002)(66446008)(8676002)(66556008)(71200400001)(6486002)(66476007)(966005)(4326008)(66946007)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NsgNmw7xDYpiohY5kAJuBpzCy4Gy7UeiUfPbvSYvi07WLfQ0uLZWcJ5xWQ25?=
 =?us-ascii?Q?ppEUdYkXXZWLErpoGnewp4lFyAH2nqOyLlaWjyOwhgpVe/NnZQ+RxV6yTR9V?=
 =?us-ascii?Q?52b9wlbC5KZsCvR2PCBYz0/o2l+CDRVQDigwqeqQssrIamjytvbHhaPHzyYg?=
 =?us-ascii?Q?HgNH2tT5xuye9bsMLO9bFVftTpvHyo9+bpqVRT++8Q+bl3j3YgR5ebqXF1Kt?=
 =?us-ascii?Q?cEHKXdzwEa0DdSwiRjy/Hzlgn1vjB8jXZinZyJGZgTAGj2g+r8SLZnbD1OGO?=
 =?us-ascii?Q?RIDQ4V6zxvoKB06vDSMfshMpEGeCKjzKCsgaHly+TvMLbD55WHNa7i/khkZs?=
 =?us-ascii?Q?aGCeGEnET9Gu914c/9Xzsb99lXUp++cIHUbVCS2D04I5C7k0IRBIQNy9wZzI?=
 =?us-ascii?Q?JSz9S/KeJJCgU/5zIBzzKzwKmOsV53oF+dLD2ME7O2UVz8eGBpaAkNyRegu3?=
 =?us-ascii?Q?NPSYDiB8zFzJZqNu7uiFNVMZWI6GveihXCUvS9fqxN9yy+Gnu3m/2KgPMhIt?=
 =?us-ascii?Q?dmpqKgvXTEIz6eIwCnFvy03ngXTTukfeqW0W1EznxR8n3EQil93/4B34cgFM?=
 =?us-ascii?Q?Rammsjk1zB6j/k49+I8iy4Vu1zAKHcbtmmnm8eTBD1cobbn5rAnzkxYVdufl?=
 =?us-ascii?Q?V8+ktz/ca9CHaJj2tdbRfpl5ZVtww8WC0fgywrSH68EIBKgP71Noe6w/FVeZ?=
 =?us-ascii?Q?v/6mJPB93taX325LXDjaTSLe0/Npq0XDWoUgZoNWXsYgqjfFvpOx0b2h7WYE?=
 =?us-ascii?Q?1KtTOA20wsIR0hwScJpD/jsRE1Rmvna38pL/UmO4ejRgdsBfCWHX3kpR2GP9?=
 =?us-ascii?Q?jJrsNMq77E3MoOr06eVXMi1MlWNgHu2EdT+W/vqvPrYllJGLa5VPgXrkvIcA?=
 =?us-ascii?Q?DpDM4mwJpPWg1CBqZZhPbfNKkOPz4ilUMKIOmgrZ9/FsooibNP49wIrJuJX2?=
 =?us-ascii?Q?ZUSBixyXI7Fjgd106UfYUDtCYG09DaE6f6dWvhaSrTSb8yq8ZGq6IHiIi+5T?=
 =?us-ascii?Q?nbQk4McpFmEFkRUt++sBxi2crlv90ZO7kQ902bqkV6MW3fkR6uhyMfIWKjLv?=
 =?us-ascii?Q?RDeyq8FVb4RIpK9jrUaIfFv1RYQDpq4i/SnS3P1LeZVMVL0viLnNZ8WjA9Tb?=
 =?us-ascii?Q?VpCBTT3+rtzufqS1l5z5YWbEscjMhmI5L/1sz1hs+pau+BlkXtPnk+1qrnj6?=
 =?us-ascii?Q?5VoKa7rQI5VIYRWK/D3+/Ct89J4yHcT4qv1cOZqO9qgRBvSYLGPuQ0RD5wIS?=
 =?us-ascii?Q?QtI0uVCzWib53Jx9iccetjZ32Ayd1FC9QfU8AbgTGW73JmmEX8LJLxNfMr02?=
 =?us-ascii?Q?6sM/gr9+WTfzq7zbCv0qNxHJccVwrytXMS72qiAs3u9GhK1D9a/yD+1AR27X?=
 =?us-ascii?Q?EIHNeHljhKaWN4TwDzAbwEqmat5UV7c5/pYzj6EdV0XcYiYHAMBjrtGNCjyf?=
 =?us-ascii?Q?nON/bsYDl1g3D0XmAI83yL3bsRpqF9yflNZIW1xhARPtl5PwheMTex71yjaP?=
 =?us-ascii?Q?BRrv4sITZEqiLq6lwTr7VKs4g5H0pFSmxSFHB2ZztlNTqWte9528Zv4Qz62Q?=
 =?us-ascii?Q?rhx51BfwzyiGQE0MBaGmd4hDDd6TqkOSAzoW8Sgd5p8rQ6rkREIvgm+6Xw9V?=
 =?us-ascii?Q?Zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4DAD8850A440D94B94DD8B1DF494E53A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?slMhIia6/0S5cgp1+zPlvQgRhizeyQQuk9c+N8wyKErbv/NdxpkH7P52yT4J?=
 =?us-ascii?Q?/9GEehkM+zCNIXlf6NmzynpyUT8cfUjEVZcs6jmnZNjGyX7RIVu+Dk1wSDe5?=
 =?us-ascii?Q?wr7SKdPn4NTNkWXNiM/uE1FFV04qrvMDfJtnTZos3xjjL58pCoiBvyc2qeiW?=
 =?us-ascii?Q?fhMfPmtUr8PhIxJIDe6Cmdc8ETuORx18MPqMqxbWBSkiOe/YKIECLcaxA3RY?=
 =?us-ascii?Q?Vw01xR86wfcjuoQSwSDZNh93xv+ANk+fXZQvGn383up9RN/SZ9tNES4J1pCl?=
 =?us-ascii?Q?rIFURBlPWvjG5VfP/WQnJuCXDGSsMC+uIhx6FInqpolJW/KokPnUK1sEK37j?=
 =?us-ascii?Q?1OXJELWom12ySFTc6Ld5W8x+HkxZFOn244e9ozybZFh5lD01d2dQmZ9mkiyt?=
 =?us-ascii?Q?T1XK0IswR/3upR2Y3wmiBmfd231AfVvRTLPvawDQGnfU+iimvRPhTuK64HYl?=
 =?us-ascii?Q?rt8aSKFnA9A+va7vfbX7TIdxQZceBg/LGwM/ziK9kQtRAHMdeJ5Kwzmh5p8X?=
 =?us-ascii?Q?4jIOf9oCKH21fuTHyM2KRSEsZHewFAADiknpjlFhGBOaRrFHBPJULbhhjY4x?=
 =?us-ascii?Q?K41DLj5sWt6ZvHEAgPV9cGlfzxtpEnbOVd7ua62RNEAgY5+Swj/TtUmtnhVY?=
 =?us-ascii?Q?GnV5QsxrmFGcddMvYeXKcj/PXaAMTxn8REXjJ1iiXHSGVtH5+GkyeBMqSJgN?=
 =?us-ascii?Q?uVoafBxxji9ZF04N9ltW2eLdQnP35l91z94uxwiMmrMqprF9Lji+2u53xAiM?=
 =?us-ascii?Q?YXySKJJTGPak13g2xbSxGxWpti7ii8pfa04uDMNtb5VmOCCmsA5TCoZbgHZC?=
 =?us-ascii?Q?eBPWe1gV5ywKwyEzItFAjqiAEYERT1VRLTSjYqV8pS/rgE04qG8IEexsrWQB?=
 =?us-ascii?Q?aOW/nxCRYQfpRHao0xLahShmyZtDFMWMwc3dvZ3ATpkZBoX+a1JTEMPSmxAj?=
 =?us-ascii?Q?CzJvNhDfA4+vnTpbx9Ls0qRm2LIXqOaup9vW+B2wjbXSiJp6KufKfMT5MXDP?=
 =?us-ascii?Q?gHiD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7866dacb-7eef-4072-5de4-08dace4a0aae
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 18:31:02.8120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nLqZNu4/LB780MvOT89tDwVNkO7ScEtRJqgur1xZ7eAIfkFvc1af6MSv20vPLDhsgRgDKYFRCPrtub8yMCRoNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4482
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_11,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211240138
X-Proofpoint-ORIG-GUID: S_iLd9v5qcexUOTBWPcOtbTTt5OvNeox
X-Proofpoint-GUID: S_iLd9v5qcexUOTBWPcOtbTTt5OvNeox
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Nov 23, 2022, at 2:00 PM, Anders Blomdell <anders.blomdell@control.lth=
.se> wrote:
>=20
> Make nfsd_splice_actor work with reads with a non-zero offset that doesn'=
t end on a page boundary.
>=20
> This was found when virtual machines with nfs-mounted qcow2 disks failed =
to boot properly (originally found
> on v6.0.5, fix also needed and tested on v6.0.9 and v6.1-rc6).
>=20
> Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=3D2142132
> Fixes: bfbfb6182ad1 "nfsd_splice_actor(): handle compound pages"
> Cc: stable@vger.kernel.org # v6.0+

"b4 am" and other tooling failed to recognize the diff content in
this email, so I've applied Al's version to nfsd's for-rc, after
running some regression tests. See:

https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git/log/?h=3Dfor-=
rc

I will see that a pull request is sent to Linus before 6.1-rc7.

Thanks for reporting and chasing this down.


> -- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -869,12 +869,13 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, str=
uct pipe_buffer *buf,
> 		  struct splice_desc *sd)
> {
> 	struct svc_rqst *rqstp =3D sd->u.data;
> -	struct page *page =3D buf->page;	// may be a compound one
> +	// buf->page may be a compound one
> 	unsigned offset =3D buf->offset;
> +	struct page *first =3D buf->page + offset / PAGE_SIZE;
> +	struct page *last =3D buf->page + (offset + sd->len - 1) / PAGE_SIZE;
>=20
> -	page +=3D offset / PAGE_SIZE;
> -	for (int i =3D sd->len; i > 0; i -=3D PAGE_SIZE)
> -		svc_rqst_replace_page(rqstp, page++);
> +	for (struct page *page =3D first; page <=3D last; page++)
> +		svc_rqst_replace_page(rqstp, page);
> 	if (rqstp->rq_res.page_len =3D=3D 0)	// first call
> 		rqstp->rq_res.page_base =3D offset % PAGE_SIZE;
> 	rqstp->rq_res.page_len +=3D sd->len;
>=20
> --=20
> Anders Blomdell                  Email: anders.blomdell@control.lth.se
> Department of Automatic Control
> Lund University                  Phone:    +46 46 222 4625
> P.O. Box 118
> SE-221 00 Lund, Sweden

--
Chuck Lever



