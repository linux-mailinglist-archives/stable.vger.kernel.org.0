Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F3552FF78
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 22:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiEUUn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 16:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiEUUn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 16:43:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C5140914;
        Sat, 21 May 2022 13:43:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24LFNolY027713;
        Sat, 21 May 2022 20:41:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5Ah/EyUR/a1B18RauGKSGwXb0kOgTcjQGMGGZdERnOw=;
 b=Yp5Nx7Y/vn9ZKPDl6WXo/7lX0Lk6P9W69gzA0v+y6j7KiWY6tSGReZStH3U5Fh+Brmms
 W1l/dCZ5ebKuutdg5v/sPorh50v6I1taqQDAVO+CRKecF4r1lZt87MJ1r8gfeLHVesmB
 ntSIqK/+wpPm+v3HIN3+6qinY6SxlTSbDHVLSVEq+0gAvzsufyU2sNSK3tUmO9v3xObp
 y/sh6dPoYdq8IVQwxkyZAPpNeU9ptiZD8A7jUNnV2xFoXoUiVH53F/Ph+XYcQVbfkJZJ
 j+JbXbOtaSVZBl5DP9Wj/skGhIFe5SWsHkwE8qHALuWFLIo8fVCfX5NvrGnHmKNy1nOd YA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pv20tr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 20:41:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24LKacvd007421;
        Sat, 21 May 2022 20:41:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph67dfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 20:41:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhKWW+/PWGtr1k/EPo0o8pRRON4sHxuRTpuWtwNEf8+MZnDafWDnE9pWsUhoMcH6hYBYhmdEjrV/GhXOAGrY8bRxAmoVp2A4ys5cULipAG7MuUrIyG3HjCd85cHaQ6SYCkhZXW51k2Oqlhyrzm45+Kc5jytWbqG1z+WAfqIC9JVDWrlVvRShaVe5Ws5eskjEz/6lO7q7l91QfhbZzn0EsPH/xD7ZxUjuWucm8V8+630P7qlK70ofUSeDy2sjjgvz9KXP5b/kHNnAJ4Xxd0InngI6+YJiKnLOpnaOxTraJAnqCrfxbHYELHNPhvPwiCs4x3+8kbCchHDL+3wP6J8Ncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ah/EyUR/a1B18RauGKSGwXb0kOgTcjQGMGGZdERnOw=;
 b=YcTvq5txdJ9hJi/0qi+oGCl16OHHS3B1AM0YMs9bFAgrRqf6RDMg7IOGkR866gp9PwVk9B1j1PFSebIobGce4ZSu5wnDVJGlZ7ek9mH/PyCAOifTU9Xv7qqpdml98Aeb+KF6Qb4VpTgsseBUyhNr7plEcZyrMIwqThL0A8RlWJR8fbVDn+wNFCErhQy82oiBi131jX3EO6w332erpwSnp5n8B3tWm33fEjUXKwpUitvdjoVeCVNjKtinywRTLhN+7LukiGpyGMEs8ZOn+nmhWCRLiF00ROAUipLrfJwLn9zUDt88RScu0Ftns0qWZ0r1e44eLwf7wkJ5f3AihpFnIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ah/EyUR/a1B18RauGKSGwXb0kOgTcjQGMGGZdERnOw=;
 b=J2scOGoYFtDlIglDaqjkYb1C1rfwoabE97sBjCkEB6eZdvaYAhU6suwx5G6yWkQMcMw2NUq1cdlvsLPJzQFXQ2Ph1AAQKwh0V4Ea57WPAL1mU4Zyh8RmDNtIWLUF6NadCsNXmllkd6OfEPdA9dy+v4kEUUDLho8nVQd1A7Gijzs=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MWHPR10MB1869.namprd10.prod.outlook.com (2603:10b6:300:111::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Sat, 21 May
 2022 20:41:09 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5273.019; Sat, 21 May 2022
 20:41:09 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux@stwm.de" <linux@stwm.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR5cM0piVXjf4kWw2Fv1L4O8aq0Zna6AgAAbcgCAAAISgIAAA5uAgA41xoCAABHMgIAAVxMAgAAJFACAABXugIABJ+MAgAANoACAABEJAIAACpiAgAAOXQA=
Date:   Sat, 21 May 2022 20:41:08 +0000
Message-ID: <31E87CEF-C83D-4FA8-A774-F2C389011FCE@oracle.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
 <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
 <YnvG71v4Ay560D+X@kroah.com>
 <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
 <59118799-0148-41F3-BA03-BB69151B74EE@oracle.com>
 <1792eb49d2a9820bbcf7b240f53158170041da6d.camel@hammerspace.com>
 <3FE1F779-A2EC-4E23-BBCC-28C5E8AFCBB1@oracle.com>
 <1a38a01debc727a1e11243fd6207d915ac90c251.camel@hammerspace.com>
 <FB8CBEF6-07B4-416C-B9B4-56E03C7E6628@oracle.com>
 <40D1CC9F-1DA7-4134-9DBD-0C0DFA16A361@oracle.com>
 <78739abdf5fe7aa0aab9b7f3c9d660010868b0f4.camel@hammerspace.com>
 <7831BCDD-00A9-42E7-A533-4D6AFA488AEF@oracle.com>
 <2117abef403c8b6e5e1672031bf8f36c8eafedc9.camel@hammerspace.com>
In-Reply-To: <2117abef403c8b6e5e1672031bf8f36c8eafedc9.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e56fa969-34de-4b2d-0a97-08da3b6a3c49
x-ms-traffictypediagnostic: MWHPR10MB1869:EE_
x-microsoft-antispam-prvs: <MWHPR10MB18695218D36F433996AE16B193D29@MWHPR10MB1869.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qCcl1zm9ESf+/Tz2ukpSWCsG3BkQo1HTtCzE8Zqw5tLvYZRDO6215m+Qq1FDtDGipOrvxPr5KRggC1oN3F3p3g00vUWJP/L3fFubKV31OR1seL+dNqcPPsZEs3s3ILxSU4KmlqthVYGWBsWG/g6BJ+F7HyTLYth+CnUCxbqqBMp4nVVmkI7+qeW7h3MDPOWTeiA/6uO4rrJj+9ebyFEVj4fxx6DYZnETRzUgXrZ3hXk82NGmXGBdQM+lhFezOLgnH58Hck2SD1ostqOkiTtHMJ+YShmk8vcU+hoVtOJ6pnzzg9ffy+hXgYvIZfz6seSkSsgN3CGsHHdRGEIhv48ohaLmm9fc2ty5O7Ljj3qVsdRX2vy7WgCDFIR8IPTLbumgTc62uiZgyWJ4f0ewag0jxHDJhn5gTVrfWShwc8sCIfIXAwELkuxJ4/GQLISekPLRQZ/f2/hgSqJIUqiWxp1Ush8Odbp/HYkwZoBMfh/xdBmkqotn9IvPsZeCVl04yr7rQCeRQ1T316Tas4q4Rg/Lx/Rggx+GzFtQMMmKS3q61kjuccEK46ZK1uWoDhQrJ6/uIb9jgj06dXr9NeAg8PnhXAk9Eb64QnpE+MfCnbBlQepKLJO8EmP9qWLjtXNWrfnbFFT4gCF/dZcw6uDr64HaCQxca0zveDXzRPpT7s0acq0RjP+tGXdaN00akMYtNv+s1SXSnbJDxrhDq4Ren+KlPTkSo4FnaEt4N4NizQ35ipeHcElY8pdQKeNaJahnRBp2Q2bjXV+gkvL1a4kDljfP9EbA3BoJz2/OtJNwqBhkJYoUIsWt8h928yW0Eq6B1sbT9oOeIA1QjAXmIJnb26wBFwqto9gOsUKJn+WbBxTF/vs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(64756008)(38070700005)(8676002)(66476007)(6916009)(54906003)(36756003)(83380400001)(4326008)(33656002)(66946007)(66556008)(91956017)(316002)(76116006)(2906002)(71200400001)(38100700002)(122000001)(186003)(5660300002)(6506007)(53546011)(8936002)(508600001)(966005)(6486002)(2616005)(26005)(86362001)(6512007)(14583001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pH2KK1yR7EHG71+psUC1pOTR1IC2+pes1vB76G1XyKCpY1ZB64AA0hwblook?=
 =?us-ascii?Q?zkDTkypiY7lCvR0HHS3mTCJmeMNruB9irm4WcnJINJBwll9wPd8qCunh0Dv1?=
 =?us-ascii?Q?meTyzqLMO7ZaD2MNbPtYwXH5g7QOxJZXDzfsOH4FRT7qEF/pMLGfS9tZwc0z?=
 =?us-ascii?Q?yITYDC5g0wVcXJ31UTOVDqSJkWcI2IS8/svsWIUSLToegF8KQ3JWO62IFShC?=
 =?us-ascii?Q?3q/4jBVIDvt7p6GUDGG/iVRAmnQatiyKRfEHhMKPD+lpWtj86nPLGJfIfThH?=
 =?us-ascii?Q?qur0GGpg73JP2a91RiAakQNEIE5BEqT9sMLI2hllslULeFEOwc3ZzZ/JjPlg?=
 =?us-ascii?Q?ER4nE343hJIi5Tp/CQPuKTimO/+4Exl0TfvckmoD9WnQfJWTkef3foeuYihx?=
 =?us-ascii?Q?tob1I2w//wk+Sdv4cBEK+VUV+8wbbmSNTHqn6VUFnGBTDFj0wNP/howJA6WB?=
 =?us-ascii?Q?rfbY9g4oNufHwCz2zg3DbICZfIMrA+cYc51Svk28zDiCumeZpf/NzDS/YoAg?=
 =?us-ascii?Q?5kFyCQPELiz2bg91AFH3SbEm5K0y1lHAUKMG58w2bZLfUnz8hNO3IHbq3Kv0?=
 =?us-ascii?Q?m6P2eZy8hu7sv/ws7zff8Rixl/r+yIpjzXgfA3thLyeb2/OxQOo+6tdjHQuH?=
 =?us-ascii?Q?0IINnyIqX7HD2Z18rX3Fkwrfu1qeC2Ajh286VViS9URwVsNeD1mSKOwu1gVE?=
 =?us-ascii?Q?Vzq5lSdcoRa8v8dcau3G+u5Xw+Aqtp7vUYS/YUhTj9HVfcaqVFaEVZWCa59q?=
 =?us-ascii?Q?rpEz7uGuE8cU7ktb7iX2SamfvKCdyzjAWRYw+GpVVOftPMg5GiIN0YGXp9VH?=
 =?us-ascii?Q?50Buy+vB0z03w+4l2dqKmq9vvlTUPv7SgZPQe4q2KUwcXheNGHMM534Vw+So?=
 =?us-ascii?Q?jCtsJ5vVv8CYKmJUEHpm3tz1YgFryHGTeK07CaAP9GUk8qYZyPKGwymwqXg2?=
 =?us-ascii?Q?LAl6RrwfpiD8K+tZ97qkKQ08wL1xVwEEQHOks7lDyWHvXCB8bODqZwAFLIph?=
 =?us-ascii?Q?YHffHqU49y59MGF9K6Y57dhGFGI/+IaZ47RhN4gaB40gc8x6Zy9R3rMzNPUM?=
 =?us-ascii?Q?ahkAedUZVmONiW4CJ4N/Vcm1JEhQxIYvrTRJPfhAbze+qmlzC0pgst2+zWhl?=
 =?us-ascii?Q?Skd7mXhjJ/H0ekjyte7rgs/tZBhe+b5GEFNJkLcgMLkbjGU5v17O5wEacI4b?=
 =?us-ascii?Q?FIcRar+0fJR4ufYgz/Zz1TM1ifm2+AuMBSKgUe5toM8lU9kWuMHYu++bz1AJ?=
 =?us-ascii?Q?jTvxdf3AaNDjvQlQERnQnZD7vE+JNKWLws0Ne5qsLzX+5cVmFQmhLmbAiW3K?=
 =?us-ascii?Q?t1M2mylXQCHuNUdMqBgfrH19lVjGGZgTLy7l4pCPJPrDg9kDjRK2fX6hZ965?=
 =?us-ascii?Q?Y6NtIxBZyWy3mBtwB9dny8lpmMPk9io+p0A3otjAsRLk8ViUAC1corGDI9k4?=
 =?us-ascii?Q?3rqLgnAEPZJR2cKtkDmYSY9TWHnptSlvi96mE8NagBFJFhOYrPp/p64b0EGb?=
 =?us-ascii?Q?eczuZgNiLwW0eq0HO9DRAaRdNIzvqX/P+0gj0qg4uLbSfys++yoscEIW0/Eo?=
 =?us-ascii?Q?/BbwCyNhmjSrUtg9aIOLpBLNa5pYEaruUmdOUYQKfYlrpHN2OE54d8F6lXPg?=
 =?us-ascii?Q?591i+72DT3nQDFSMyVfRzuxkavUSw+ETz1oGbkP8/qVzt4xcKIwZsWfFapTt?=
 =?us-ascii?Q?7lw+nVDJWMMmiEuebvknhNg9wTP2X9McEeZgWHVfUZqNX7lxiEgZ1v3g/xbN?=
 =?us-ascii?Q?6gxfx52ifZtoI/CJzfZFeyWukZf18Vw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <085A17A2A281A04589EE84F231331832@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e56fa969-34de-4b2d-0a97-08da3b6a3c49
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2022 20:41:08.9713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 80Pyez16g3BDsm8OSNtQrPw1RhobxigqA/TFQen6C0BE6YVMf9f3Ib3+jTbgwM6AYaumOS2EcZo/cLkHg24nHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1869
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-21_06:2022-05-20,2022-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205210131
X-Proofpoint-GUID: kEs7tlp_iRF-xqlGVFJ-wGlAdWohQbNS
X-Proofpoint-ORIG-GUID: kEs7tlp_iRF-xqlGVFJ-wGlAdWohQbNS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 21, 2022, at 3:49 PM, Trond Myklebust <trondmy@hammerspace.com> wr=
ote:
>=20
> On Sat, 2022-05-21 at 19:11 +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On May 21, 2022, at 2:10 PM, Trond Myklebust
>>> <trondmy@hammerspace.com> wrote:
>>>=20
>>> On Sat, 2022-05-21 at 17:22 +0000, Chuck Lever III wrote:
>>>>=20
>>>>=20
>>>>> On May 20, 2022, at 7:43 PM, Chuck Lever III
>>>>> <chuck.lever@oracle.com> wrote:
>>>>>=20
>>>>>=20
>>>>>=20
>>>>>> On May 20, 2022, at 6:24 PM, Trond Myklebust
>>>>>> <trondmy@hammerspace.com> wrote:
>>>>>>=20
>>>>>> On Fri, 2022-05-20 at 21:52 +0000, Chuck Lever III wrote:
>>>>>>>=20
>>>>>>>=20
>>>>>>>> On May 20, 2022, at 12:40 PM, Trond Myklebust
>>>>>>>> <trondmy@hammerspace.com> wrote:
>>>>>>>>=20
>>>>>>>> On Fri, 2022-05-20 at 15:36 +0000, Chuck Lever III wrote:
>>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>>> On May 11, 2022, at 10:36 AM, Chuck Lever III
>>>>>>>>>> <chuck.lever@oracle.com> wrote:
>>>>>>>>>>=20
>>>>>>>>>>=20
>>>>>>>>>>=20
>>>>>>>>>>> On May 11, 2022, at 10:23 AM, Greg KH
>>>>>>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>>>>>>=20
>>>>>>>>>>> On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck
>>>>>>>>>>> Lever
>>>>>>>>>>> III
>>>>>>>>>>> wrote:
>>>>>>>>>>>>=20
>>>>>>>>>>>>=20
>>>>>>>>>>>>> On May 11, 2022, at 8:38 AM, Greg KH
>>>>>>>>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>>>>>>>>=20
>>>>>>>>>>>>> On Wed, May 11, 2022 at 12:03:13PM +0200,
>>>>>>>>>>>>> Wolfgang
>>>>>>>>>>>>> Walter
>>>>>>>>>>>>> wrote:
>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>=20
>>>>>>>>>>>>>> starting with 5.4.188 wie see a massive
>>>>>>>>>>>>>> performance
>>>>>>>>>>>>>> regression on our
>>>>>>>>>>>>>> nfs-server. It basically is serving requests
>>>>>>>>>>>>>> very
>>>>>>>>>>>>>> very
>>>>>>>>>>>>>> slowly with cpu
>>>>>>>>>>>>>> utilization of 100% (with 5.4.187 and earlier
>>>>>>>>>>>>>> it
>>>>>>>>>>>>>> is
>>>>>>>>>>>>>> 10%) so
>>>>>>>>>>>>>> that it is
>>>>>>>>>>>>>> unusable as a fileserver.
>>>>>>>>>>>>>>=20
>>>>>>>>>>>>>> The culprit are commits (or one of it):
>>>>>>>>>>>>>>=20
>>>>>>>>>>>>>> c32f1041382a88b17da5736886da4a492353a1bb
>>>>>>>>>>>>>> "nfsd:
>>>>>>>>>>>>>> cleanup
>>>>>>>>>>>>>> nfsd_file_lru_dispose()"
>>>>>>>>>>>>>> 628adfa21815f74c04724abc85847f24b5dd1645
>>>>>>>>>>>>>> "nfsd:
>>>>>>>>>>>>>> Containerise filecache
>>>>>>>>>>>>>> laundrette"
>>>>>>>>>>>>>>=20
>>>>>>>>>>>>>> (upstream
>>>>>>>>>>>>>> 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>>>>>>>>>>>>>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>>>>>>>>>>>>>=20
>>>>>>>>>>>>>> If I revert them in v5.4.192 the kernel works
>>>>>>>>>>>>>> as
>>>>>>>>>>>>>> before
>>>>>>>>>>>>>> and
>>>>>>>>>>>>>> performance is
>>>>>>>>>>>>>> ok again.
>>>>>>>>>>>>>>=20
>>>>>>>>>>>>>> I did not try to revert them one by one as
>>>>>>>>>>>>>> any
>>>>>>>>>>>>>> disruption
>>>>>>>>>>>>>> of our nfs-server
>>>>>>>>>>>>>> is a severe problem for us and I'm not sure
>>>>>>>>>>>>>> if
>>>>>>>>>>>>>> they are
>>>>>>>>>>>>>> related.
>>>>>>>>>>>>>>=20
>>>>>>>>>>>>>> 5.10 and 5.15 both always performed very
>>>>>>>>>>>>>> badly on
>>>>>>>>>>>>>> our
>>>>>>>>>>>>>> nfs-
>>>>>>>>>>>>>> server in a
>>>>>>>>>>>>>> similar way so we were stuck with 5.4.
>>>>>>>>>>>>>>=20
>>>>>>>>>>>>>> I now think this is because of
>>>>>>>>>>>>>> 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63
>>>>>>>>>>>>>> and/or
>>>>>>>>>>>>>> 9542e6a643fc69d528dfb3303f145719c61d3050
>>>>>>>>>>>>>> though
>>>>>>>>>>>>>> I
>>>>>>>>>>>>>> didn't tried to
>>>>>>>>>>>>>> revert them in 5.15 yet.
>>>>>>>>>>>>>=20
>>>>>>>>>>>>> Odds are 5.18-rc6 is also a problem?
>>>>>>>>>>>>=20
>>>>>>>>>>>> We believe that
>>>>>>>>>>>>=20
>>>>>>>>>>>> 6b8a94332ee4 ("nfsd: Fix a write performance
>>>>>>>>>>>> regression")
>>>>>>>>>>>>=20
>>>>>>>>>>>> addresses the performance regression. It was
>>>>>>>>>>>> merged
>>>>>>>>>>>> into
>>>>>>>>>>>> 5.18-
>>>>>>>>>>>> rc.
>>>>>>>>>>>=20
>>>>>>>>>>> And into 5.17.4 if someone wants to try that
>>>>>>>>>>> release.
>>>>>>>>>>=20
>>>>>>>>>> I don't have a lot of time to backport this one
>>>>>>>>>> myself,
>>>>>>>>>> so
>>>>>>>>>> I welcome anyone who wants to apply that commit to
>>>>>>>>>> their
>>>>>>>>>> favorite LTS kernel and test it for us.
>>>>>>>>>>=20
>>>>>>>>>>=20
>>>>>>>>>>>>> If so, I'll just wait for the fix to get into
>>>>>>>>>>>>> Linus's
>>>>>>>>>>>>> tree as
>>>>>>>>>>>>> this does
>>>>>>>>>>>>> not seem to be a stable-tree-only issue.
>>>>>>>>>>>>=20
>>>>>>>>>>>> Unfortunately I've received a recent report that
>>>>>>>>>>>> the
>>>>>>>>>>>> fix
>>>>>>>>>>>> introduces
>>>>>>>>>>>> a "sleep while spinlock is held" for NFSv4.0 in
>>>>>>>>>>>> rare
>>>>>>>>>>>> cases.
>>>>>>>>>>>=20
>>>>>>>>>>> Ick, not good, any potential fixes for that?
>>>>>>>>>>=20
>>>>>>>>>> Not yet. I was at LSF last week, so I've just started
>>>>>>>>>> digging
>>>>>>>>>> into this one. I've confirmed that the report is a
>>>>>>>>>> real
>>>>>>>>>> bug,
>>>>>>>>>> but we still don't know how hard it is to hit it with
>>>>>>>>>> real
>>>>>>>>>> workloads.
>>>>>>>>>=20
>>>>>>>>> We believe the following, which should be part of the
>>>>>>>>> first
>>>>>>>>> NFSD pull request for 5.19, will properly address the
>>>>>>>>> splat.
>>>>>>>>>=20
>>>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git/com=
mit/?h=3Dfor-next&id=3D556082f5e5d7ecfd0ee45c3641e2b364bff9ee44
>>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>> Uh... What happens if you have 2 simultaneous calls to
>>>>>>>> nfsd4_release_lockowner() for the same file? i.e. 2
>>>>>>>> separate
>>>>>>>> processes
>>>>>>>> owned by the same user, both locking the same file.
>>>>>>>>=20
>>>>>>>> Can't that cause the 'putlist' to get corrupted when both
>>>>>>>> callers
>>>>>>>> add
>>>>>>>> the same nf->nf_putfile to two separate lists?
>>>>>>>=20
>>>>>>> IIUC, cl_lock serializes the two RELEASE_LOCKOWNER calls.
>>>>>>>=20
>>>>>>> The first call finds the lockowner in cl_ownerstr_hashtbl
>>>>>>> and
>>>>>>> unhashes it before releasing cl_lock.
>>>>>>>=20
>>>>>>> Then the second cannot find that lockowner, thus it can't
>>>>>>> requeue it for bulk_put.
>>>>>>>=20
>>>>>>> Am I missing something?
>>>>>>=20
>>>>>> In the example I quoted, there are 2 separate processes
>>>>>> running
>>>>>> on the
>>>>>> client. Those processes could share the same open owner +
>>>>>> open
>>>>>> stateid,
>>>>>> and hence the same struct nfs4_file, since that depends only
>>>>>> on
>>>>>> the
>>>>>> process credentials matching. However they will not normally
>>>>>> share a
>>>>>> lock owner, since POSIX does not expect different processes
>>>>>> to
>>>>>> share
>>>>>> locks.
>>>>>>=20
>>>>>> IOW: The point is that one can relatively easily create 2
>>>>>> different
>>>>>> lock owners with different lock stateids that share the same
>>>>>> underlying
>>>>>> struct nfs4_file.
>>>>>=20
>>>>> Is there a similar exposure if two different clients are
>>>>> locking
>>>>> the same file? If so, then we can't use a per-nfs4_client
>>>>> semaphore
>>>>> to serialize access to the nf_putfile field.
>>>>=20
>>>> I had a thought about an alternate approach.
>>>>=20
>>>> Create a second nfsd_file_put API that is not allowed to sleep.
>>>> Let's call it "nfsd_file_put_async()". Teach check_for_locked()
>>>> to use that instead of nfsd_file_put().
>>>>=20
>>>> Here's where I'm a little fuzzy: nfsd_file_put_async() could do
>>>> something like:
>>>>=20
>>>> void nfsd_file_put_async(struct nfsd_file *nf)
>>>> {
>>>>         if (refcount_dec_and_test(&nf->nf_ref))
>>>>                 nfsd_file_close_inode(nf->nf_inode);
>>>> }
>>>>=20
>>>>=20
>>>=20
>>> That approach moves the sync to the garbage collector, which was
>>> exactly what we're trying to avoid in the first place.
>>=20
>> Totally understood.
>>=20
>> My thought was that "put" for RELEASE_LOCKOWNER/FREE_STATEID
>> would be unlikely to have any data to sync -- callers that
>> actually have data to flush are elsewhere, and those would
>> continue to use the synchronous nfsd_file_put() API.
>>=20
>> Do you have a workload where we can test this assumption?
>>=20
>>=20
>>> Why not just do this "check_for_locks()" thing differently?
>>>=20
>>> It really shouldn't be too hard to add something to
>>> nfsd4_lm_get_owner()/nfsd4_lm_put_owner() that bumps a counter in
>>> the
>>> lockowner in order to tell you whether or not locks are still held
>>> instead of doing this bone headed walk through the list of locks.
>>=20
>> I thought of that a couple weeks ago. That doesn't work
>> because you can lock or unlock by range. That means the
>> symmetry of LOCK and LOCKU is not guaranteed, and I don't
>> believe these calls are used that way anyway. So I
>> abandoned the idea of using get_owner / put_owner.
>>=20
>=20
> Then you're misunderstanding how it works. lm_get_owner() is called
> when a lock is initialised from another one. The whole point is to
> ensure that each and every object representing a range lock on the
> inode's list maintains its own private reference to the knfsd lockowner
> (i.e. the fl->fl_owner).
>=20
> For instance when a LOCK call calls posix_lock_inode(), then that
> function uses locks_copy_conflock() (which calls lm_get_owner) to
> initialise the range lock object that is being put on the inode list.
> If the new lock causes multiple existing locks to be replaced, they all
> call lm_put_owner to release their references to fl->fl_owner as part
> of the process of being freed.
>=20
> Conversely, when LOCKU causes a range to get split, the two locks that
> replace the old one are both initialised using locks_copy_conflock(),
> so they both call lm_get_owner. The lock that represents the range
> being replaced is then made to call lm_put_owner() when it is freed.
>=20
> etc, etc...

That is definitely not what it looked like when I traced it. The
reference count managed by get_owner / put_owner did not seem
to be usable for tracking whether a lockowner had locks or not.
The reference count was put pretty quickly after the lm_get_owner
call.

But I'm not interested in an argument. I'll go back and look at
get_owner / put_owner again, because I agree that not having to
traverse the inode's flc_posix list during check_for_locks() would
be awesome sauce.


--
Chuck Lever



