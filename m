Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B41E52FE88
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 19:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241616AbiEURYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 13:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiEURYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 13:24:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C970066F80;
        Sat, 21 May 2022 10:24:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24LG3xgp001987;
        Sat, 21 May 2022 17:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4AB/2lQBeE1rWnZ3FPIvWrCk26AGKGLMQtl4vnoqPEY=;
 b=XD6bVcosjFmO7p+njf37QIDKl5APQDl0NMyFd4UegfjJ8aP9QBkNswO8hBsCBTeoDGn2
 IjzgNGbi0fD7EJlWaSYJwi5r8No5B1xo1fILT4Bzi1faqV/2itPHueNPzUTL6dpgR1uN
 U+K/9YB0fbME5u9hWkwmVxTpqesC/HJX/Yd48k056inOEvgKG/9z6xKv0k79fid8TxZc
 uufXRmuSC9S3aXVS0PU5emjPaQz3SExFN5grwIajKtVcvssLCPetELniOa2r5cNZn+ZO
 2d8msxDVlD6P1IENqMDhd5SzXOQtYJk3KpoaKTc5eudyItTfqTyouajJOPhZOKFMclaY xw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6rmtrm9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 17:22:08 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24LHM43H015694;
        Sat, 21 May 2022 17:22:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph6nyah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 17:22:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbWUT0DG4+8OQjrxZkaTYrOtNXG4ZWEqtItdh3QqblejrYlnnnq90/BVHKUAgVlWO6LRmvLLUv4gH87teUQvUIWP5OujlzFfr+6v5jS3qbSc0CXy+B54YZblrqKn4Yly1hZaX+Km65DoXSexowOccwVSmJ4yKK8Hu/uhUaas4bESfWpGWn9FBPyAqs1iiRgig4cjZMVKhokQslFHSSLPR9LOb/brn1hSc5gLMhZypQfKlkAxaEACblbsi38SLxIZyParfhr0m3hbKOlnaaJ5b89tAzVDum5m4X0BJVM/i0iEgcMSMLHCdYjimDjtyqyVmVmt9miJx6m0617cSio1Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4AB/2lQBeE1rWnZ3FPIvWrCk26AGKGLMQtl4vnoqPEY=;
 b=Pj/9I/9Yvb/M/R/beeG/fQUozD1sYJo++Th1fMwvnG26CeW/pE87HmBT8A1KI2PgZV4Fjkw5ivPDXI7G6r4tCiqGW9B7triO7ZPAkSkw8tj+n3pd1AHagh+rfZMPCEo3jrhCywakpqZiQpQSZR/odxnd6pnF5CtJkP8E0lLLpjjK32gEIFdj+dCCstqem5qWmmsdEH5nhNS83NpB8fjAgZad6zPB2eUC+J0Z5k5n3K9Sbr8xVsopHOIerdTseyXlnPHmj7iZ2OKWpYfvphQiL67zACDKnLKRg/t/+Vxhd8oqdHfMFsL1/1JYH+uKbJRY14jm2Hyt5PmOeNLxrGMpnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AB/2lQBeE1rWnZ3FPIvWrCk26AGKGLMQtl4vnoqPEY=;
 b=NmxqLrAltKwHjKWB0l+0fmqJuGrtRTCXx4pZ1EvjDe6K3IM27QZwGxB23Nm8stBhi1OOhPC5kQ8es9JhFdtDeblg6HWcl8VfpL7bmB7x9pKiPwaEt1zr958I8K30bcP1D1vSKbLXIjsoK7ko2fKXr8Xn8QJmy7OhxNCuA6OP8M4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA2PR10MB4667.namprd10.prod.outlook.com (2603:10b6:806:111::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Sat, 21 May
 2022 17:22:05 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5273.019; Sat, 21 May 2022
 17:22:04 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>,
        Jeff Layton <jlayton@kernel.org>
CC:     "linux@stwm.de" <linux@stwm.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR5cM0piVXjf4kWw2Fv1L4O8aq0Zna6AgAAbcgCAAAISgIAAA5uAgA41xoCAABHMgIAAVxMAgAAJFACAABXugIABJ+MA
Date:   Sat, 21 May 2022 17:22:04 +0000
Message-ID: <40D1CC9F-1DA7-4134-9DBD-0C0DFA16A361@oracle.com>
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
In-Reply-To: <FB8CBEF6-07B4-416C-B9B4-56E03C7E6628@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f68e07a3-b351-4170-92d6-08da3b4e6d00
x-ms-traffictypediagnostic: SA2PR10MB4667:EE_
x-microsoft-antispam-prvs: <SA2PR10MB4667724CF7A4AC99E43F601093D29@SA2PR10MB4667.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7qEKeQMrajNpbq9BisoxJ13bFwrQA7BLGLFgzQ/nLEXAYorWhb9dv0bd3/UcHvdt1obuVuSU6zgTBeH1WT2q6TxUGxkG64GKR5A2BPv3w8Or6qs9sixisxCqIZBkzhbxdzUkqOVsTSCuZcS6kodNYD5l79tsrxlrYhJ+lHzXoVWPxHG80cczfmnFZVvo6Qfe/mj/oWsbPGrTGNbcMENcNHdF8rYpTMgJvl+/hcTbDuHnljyvmVfMA0knNOV8f+kOfPjTQNF7cPrf/6NuHY/uUlPRNCEScy8G2Lk9oeRgM9tBgyl+ZD7SB46CGU2iesklNnwUcOXlbiwmlh58vHR9UfDcXjK3XnwUJ1QbMfk8l3Q/bKt2yyEc+FbinlOSgwAuTbHXnF8HcHp7GSrNh/+WMpiEwppBwT797g2dAwFhBkImbL6KbEIlRBq8+V6nVWpqG7/FqJksDNvOHmDNchRumS8NmeVIngj+viDN3VpYJwC0UnSWxwG630dC5t8B7bP75zA1vNYbDD28MPrCOPJOY72Jb1Uup4YX5tNYaUtTPaTE+dkdtTAgXCcc+ooZKrPeacKtS1hHtQpqzM80hHWfnEe0id8tWzbdTThUrU9RoaS/oY6KS7y1ykPXsdmexcz9zbutiTIHtVk2e1hqJvHlDMu9Pabhw456rzGbmXihQGNmvYZjpOmtwJPUhnmpPdyy/mbuxLn0TZ7NT3wnx3fZ0PKITkwyoU8gw+YtuFlw3qX8TBwkSPsIB0ycSyGhRiJrw4d6zJiWw3iDV+Y9zk0Tz+DapNlPewYMhMowACAzWppCr27BFn1NcfQdaDhLq1yThq7mLCOya//m9LfpeUxDXIaeRw51OHanNxYKipCMLPU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(38070700005)(54906003)(110136005)(38100700002)(186003)(966005)(6486002)(122000001)(2616005)(53546011)(508600001)(4326008)(8676002)(8936002)(66946007)(66556008)(64756008)(66446008)(66476007)(6506007)(76116006)(86362001)(33656002)(26005)(6512007)(91956017)(5660300002)(2906002)(36756003)(83380400001)(71200400001)(14583001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kW3lXwnXG9dTzgaMmBLlXJYgL5Si4mPJx34PFUxh4yEakPo4PRY4yJwATgo2?=
 =?us-ascii?Q?kz2zNTt4Ok2l7RR5pCGuLEDLN06z9IQGWP4dCITQaTC7Gg2xRXNAh2+XWY5v?=
 =?us-ascii?Q?zb07/C4CBvHD0CCyjHr12lOWaGap8kmironzXHjv03zSKnLoJX+9RhfMuiIR?=
 =?us-ascii?Q?dqte0RROXA6b5xnlLG/expbsSzXRlRAhwBmOuzc9UE87guJsjxnrCdGGRzKD?=
 =?us-ascii?Q?BXY9VMgdUJEpUce93wrZH6Mdtjcr5qtfY051h6+9cirFHD9eMFtS94L/wnzw?=
 =?us-ascii?Q?2XIvQM/xKGV7ibZQsaNyQWhf2GD2tYl4zzbgpZ0Fl/ZqfgtpHMZmB9Kn/JOk?=
 =?us-ascii?Q?cz3JALpNZ0AVbab+EOXQ2N+RIt4FmUsMFd+D5MJFo+m4c/yZEjGGVfOao4f1?=
 =?us-ascii?Q?iT5qJQxJxhbowySPfIUVDad4DR1FMnl8OjAzfygjhnGdFzLOKUWjoukOnMsp?=
 =?us-ascii?Q?ZmBuZGR5/BORyI92IXeaNJ2af/q998ZJ39PYumoj6TW9Uf9WUENp5COJI+o1?=
 =?us-ascii?Q?mfw0Cui8KFTvXgPPF1YYIROLLLHVf1cCQzztqucOouGxw8qr/i6ijMgS/iFN?=
 =?us-ascii?Q?x7c35imGkMynWgcgPZeake2pK5VuqpUV11qX1haDWhxWUi7ebiChd3BJYfpV?=
 =?us-ascii?Q?+87THJ4pDvl8V7xY8eGo7p5zWiO13/kvIzcsG7AMpOvkQ81+McLHulIye+C5?=
 =?us-ascii?Q?X99+F+U8YbTnuJeQRmKwJaZvBTJhsKr/aXYuyCgR8SzGtJm4TmagG6j4sidF?=
 =?us-ascii?Q?1pFRiJE9CtV7Ky1CYkr+9IGkOKSMRhxDK4FlzAls8h3GJwDQBBx1dTpHPsZx?=
 =?us-ascii?Q?LrUjJgGDAr6hOi/793Lvq8eF/BewntzDohp7gsX0IrHGwSPLqA01ak4fujDA?=
 =?us-ascii?Q?mmBSi3CB8RMUsr2D6s8ya+IAsHYtiWgxDBOICmi6zxlp56nrulUIz7E6XTgS?=
 =?us-ascii?Q?4Zqp+lGAlj/x9JDmZviBZjCw+nJQoqruA2LA+Su/18HD9AvXqqEiZiZRlyv5?=
 =?us-ascii?Q?eWnq+cEbVv7q+/S7+8KlXQTmctdy5ooYhyXDYDX4Rg91L+Aij6EqtwRVG8lq?=
 =?us-ascii?Q?xWxsdn1GE7FuUATPbgt88jnCcFISrB3Hl3B5c2etTt9PwvRQmLF5UU7gUC69?=
 =?us-ascii?Q?sL5LffcDd9YbsQi2kCBDcehZIxddny1HCRvCb/niaFdJgmwM63NfrrRwcBdQ?=
 =?us-ascii?Q?MTxsRJQ9q9f7XaUr3W3FEhS8sKCSPt0GWF39DBZh5yTAitDxSsvyQPwO9c5v?=
 =?us-ascii?Q?f6nmjPSH3x4gWed9YyrSXx7iK9xZYyTnzrFPsvypqKaWiXXb136J3jUkgcU2?=
 =?us-ascii?Q?+C3BMIKWBePp8RB3V5Y3enBgrHsOO22bVhnk+XytuyaXMDaOELnSKyCCapa+?=
 =?us-ascii?Q?IyuhRH0d86y6eQahT/Unmn3bqBKytSt+cp9vWZCb5kFgWGE7O2hhGw4hb68J?=
 =?us-ascii?Q?JsIjUGMQ8tgRpEm8pTi3GR1wxDgFa84XyKTOdedQYthW7dHx+aRuWRRD1T1Z?=
 =?us-ascii?Q?tsHR5zbN6YxfQiwx4xFbeFDmj3RtpLUk53NCr/o/ZJaf85sreLO0Ev7qSR1g?=
 =?us-ascii?Q?lnQnkgpWpqWGCzFYmGY+vDFYnNyU3lax4ezLr/GBshQqXAVkinkrkE0CSCFT?=
 =?us-ascii?Q?lyBHvGo9HOUnb7fFt78SVKSXwBuwSeCQOn/Ffz2pF4Z5CiGZeDAAEypFCnfU?=
 =?us-ascii?Q?7JTpO7ikaWyLCrY9MuFDlDvitDYvU2W8yl8rFuyfDGNdJo5kkqZKCpOo47KY?=
 =?us-ascii?Q?fSvkNy4DMLM+xWEhoDG4Aoss/OdXmmE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B1ACCCB50512C4F90F645DF2363E581@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f68e07a3-b351-4170-92d6-08da3b4e6d00
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2022 17:22:04.8275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hM2EmG+LOMC0gh5GcEzwWKKlVo35H7mm6b6Pk1L0nkn9qltSm5gH12w+WYnTXsty2xW0yzLiQLWOmZb10T8STA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4667
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-21_06:2022-05-20,2022-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205210110
X-Proofpoint-GUID: KDBbQkEDokmWZO9RJoTtef1reZ0ArN17
X-Proofpoint-ORIG-GUID: KDBbQkEDokmWZO9RJoTtef1reZ0ArN17
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 20, 2022, at 7:43 PM, Chuck Lever III <chuck.lever@oracle.com> wro=
te:
>=20
>=20
>=20
>> On May 20, 2022, at 6:24 PM, Trond Myklebust <trondmy@hammerspace.com> w=
rote:
>>=20
>> On Fri, 2022-05-20 at 21:52 +0000, Chuck Lever III wrote:
>>>=20
>>>=20
>>>> On May 20, 2022, at 12:40 PM, Trond Myklebust
>>>> <trondmy@hammerspace.com> wrote:
>>>>=20
>>>> On Fri, 2022-05-20 at 15:36 +0000, Chuck Lever III wrote:
>>>>>=20
>>>>>=20
>>>>>> On May 11, 2022, at 10:36 AM, Chuck Lever III
>>>>>> <chuck.lever@oracle.com> wrote:
>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>>> On May 11, 2022, at 10:23 AM, Greg KH
>>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>>=20
>>>>>>> On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck Lever III
>>>>>>> wrote:
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>> On May 11, 2022, at 8:38 AM, Greg KH
>>>>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>>>>=20
>>>>>>>>> On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang Walter
>>>>>>>>> wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>=20
>>>>>>>>>> starting with 5.4.188 wie see a massive performance
>>>>>>>>>> regression on our
>>>>>>>>>> nfs-server. It basically is serving requests very very
>>>>>>>>>> slowly with cpu
>>>>>>>>>> utilization of 100% (with 5.4.187 and earlier it is
>>>>>>>>>> 10%) so
>>>>>>>>>> that it is
>>>>>>>>>> unusable as a fileserver.
>>>>>>>>>>=20
>>>>>>>>>> The culprit are commits (or one of it):
>>>>>>>>>>=20
>>>>>>>>>> c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup
>>>>>>>>>> nfsd_file_lru_dispose()"
>>>>>>>>>> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd:
>>>>>>>>>> Containerise filecache
>>>>>>>>>> laundrette"
>>>>>>>>>>=20
>>>>>>>>>> (upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>>>>>>>>>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>>>>>>>>>=20
>>>>>>>>>> If I revert them in v5.4.192 the kernel works as before
>>>>>>>>>> and
>>>>>>>>>> performance is
>>>>>>>>>> ok again.
>>>>>>>>>>=20
>>>>>>>>>> I did not try to revert them one by one as any
>>>>>>>>>> disruption
>>>>>>>>>> of our nfs-server
>>>>>>>>>> is a severe problem for us and I'm not sure if they are
>>>>>>>>>> related.
>>>>>>>>>>=20
>>>>>>>>>> 5.10 and 5.15 both always performed very badly on our
>>>>>>>>>> nfs-
>>>>>>>>>> server in a
>>>>>>>>>> similar way so we were stuck with 5.4.
>>>>>>>>>>=20
>>>>>>>>>> I now think this is because of
>>>>>>>>>> 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63
>>>>>>>>>> and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though
>>>>>>>>>> I
>>>>>>>>>> didn't tried to
>>>>>>>>>> revert them in 5.15 yet.
>>>>>>>>>=20
>>>>>>>>> Odds are 5.18-rc6 is also a problem?
>>>>>>>>=20
>>>>>>>> We believe that
>>>>>>>>=20
>>>>>>>> 6b8a94332ee4 ("nfsd: Fix a write performance regression")
>>>>>>>>=20
>>>>>>>> addresses the performance regression. It was merged into
>>>>>>>> 5.18-
>>>>>>>> rc.
>>>>>>>=20
>>>>>>> And into 5.17.4 if someone wants to try that release.
>>>>>>=20
>>>>>> I don't have a lot of time to backport this one myself, so
>>>>>> I welcome anyone who wants to apply that commit to their
>>>>>> favorite LTS kernel and test it for us.
>>>>>>=20
>>>>>>=20
>>>>>>>>> If so, I'll just wait for the fix to get into Linus's
>>>>>>>>> tree as
>>>>>>>>> this does
>>>>>>>>> not seem to be a stable-tree-only issue.
>>>>>>>>=20
>>>>>>>> Unfortunately I've received a recent report that the fix
>>>>>>>> introduces
>>>>>>>> a "sleep while spinlock is held" for NFSv4.0 in rare cases.
>>>>>>>=20
>>>>>>> Ick, not good, any potential fixes for that?
>>>>>>=20
>>>>>> Not yet. I was at LSF last week, so I've just started digging
>>>>>> into this one. I've confirmed that the report is a real bug,
>>>>>> but we still don't know how hard it is to hit it with real
>>>>>> workloads.
>>>>>=20
>>>>> We believe the following, which should be part of the first
>>>>> NFSD pull request for 5.19, will properly address the splat.
>>>>>=20
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git/commit/=
?h=3Dfor-next&id=3D556082f5e5d7ecfd0ee45c3641e2b364bff9ee44
>>>>>=20
>>>>>=20
>>>> Uh... What happens if you have 2 simultaneous calls to
>>>> nfsd4_release_lockowner() for the same file? i.e. 2 separate
>>>> processes
>>>> owned by the same user, both locking the same file.
>>>>=20
>>>> Can't that cause the 'putlist' to get corrupted when both callers
>>>> add
>>>> the same nf->nf_putfile to two separate lists?
>>>=20
>>> IIUC, cl_lock serializes the two RELEASE_LOCKOWNER calls.
>>>=20
>>> The first call finds the lockowner in cl_ownerstr_hashtbl and
>>> unhashes it before releasing cl_lock.
>>>=20
>>> Then the second cannot find that lockowner, thus it can't
>>> requeue it for bulk_put.
>>>=20
>>> Am I missing something?
>>=20
>> In the example I quoted, there are 2 separate processes running on the
>> client. Those processes could share the same open owner + open stateid,
>> and hence the same struct nfs4_file, since that depends only on the
>> process credentials matching. However they will not normally share a
>> lock owner, since POSIX does not expect different processes to share
>> locks.
>>=20
>> IOW: The point is that one can relatively easily create 2 different
>> lock owners with different lock stateids that share the same underlying
>> struct nfs4_file.
>=20
> Is there a similar exposure if two different clients are locking
> the same file? If so, then we can't use a per-nfs4_client semaphore
> to serialize access to the nf_putfile field.

I had a thought about an alternate approach.

Create a second nfsd_file_put API that is not allowed to sleep.
Let's call it "nfsd_file_put_async()". Teach check_for_locked()
to use that instead of nfsd_file_put().

Here's where I'm a little fuzzy: nfsd_file_put_async() could do
something like:

void nfsd_file_put_async(struct nfsd_file *nf)
{
	if (refcount_dec_and_test(&nf->nf_ref))
		nfsd_file_close_inode(nf->nf_inode);
}

--
Chuck Lever


