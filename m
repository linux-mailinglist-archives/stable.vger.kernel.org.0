Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C66E6A7950
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCBCHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjCBCHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:07:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C410D51F9E
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:07:32 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321N8x1f017238;
        Thu, 2 Mar 2023 02:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=B56hlV2dN8MTYrhSeEkCaqC7QtGjp5UDY1X5GUgGpIA=;
 b=uaXrJvqXu9oOeSpRx2DV/rmwUTFGV5CrH6nuZVgkA2+QIXfFMYvrsaU0Ce8cD6dJNZkx
 cr7zykEZKf+yitDqg58hiV6G37ppAoODHtzdrGVH5iDqUOMcIPwMkGZkCUo5hu3Kvsbq
 UoPrmVChL8EkQ7LLHY454GbLnioSXpAogTkmnWIISLNHfv1KlDb4zZpuboAOcL3SVN9n
 n4T8wni5W0xxWCqfd5UCNHX1Vzg2qVRdaArfD7TgMFACkNUzzK8/V1amFjk+OaEsl5qs
 Nho+Fc9Qn3gPOR1CPBXtvnQYb09UZBd1qvc1B96BrvYYoIKxHwnjzsUoJBKBGUN5b7Xn 0A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nybaktgtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3220a3tl015895;
        Thu, 2 Mar 2023 02:07:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9pg87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aV9uEEBvdT/cPgekd1btovkbFAMxt/dLWDiPq/3QVGHprAN4oT4gCznDgDYHxPlIf4E2deF9VcUw3fChfnxoe84StI2QT+dS5ZpP0MNse4ugYnPZotLla1CIRByGJcr2GaKH6DoqJdGpG3zGDmmq81kA7EEQCGNwZK5v50nCIeeXMDSGUzOyQLwEfZz2Mxvl/thKzemed10Y60tv1xmPvd/tXczdS5AVwODWajh4LDuvyV9mFyU7a0KjEjk9ph4zxvgf4fM46VbaBQDOTU1rD/0WnY1q2RT9W1qG8cJI8yb9gJjNox0G2ry2S65g46vx3I8ER4Vdy/QDRZ6oHsbnGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B56hlV2dN8MTYrhSeEkCaqC7QtGjp5UDY1X5GUgGpIA=;
 b=LDHxuOd8W+7fcTuV78QnW2A9KbiczkXgo6I9hWfPL/XpaEkqob+tCZwTxYy1UBFsidaCGC7F0nRJksIElX+WE17q+5pzdMgtRPTlG8dHr8CTNpTjH1K2TZL+6Jz9pKQz+WH7TDde+um6QBut8g4DlHReBaxPFzMOa1tjmp7M06HYrjXdri9WLhsPUmDqYvJwY7Pd/l/amuOyfGxpWI5NZR4AfVuEURq44F/7rtQAgOqHpeEGUQVHGA7ZFfsnwCFe7Tw5hLKLOW2wan+NWDmk7RuyMqUusFN2gOxGgd30+Jd5xYZviWJZcohZMnWC0cICxc3BUw7BgzkRSX93vx94eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B56hlV2dN8MTYrhSeEkCaqC7QtGjp5UDY1X5GUgGpIA=;
 b=TE2NFl0TysbHkMeY9qVnwvREVESlBcAPT7mleQFcm6qUQ/xexGZVndQ92BnQZHRPdgoJNA9H4dLXp8Mu6QMpXT99EaMN77ssTDLoH3HDmStXlh7/D8ooSsXv6qbQBVMWcwmuPJQC/kVgG6B1gFYsZPQLzhAANK0E6fJeFcKJWe0=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM6PR10MB4284.namprd10.prod.outlook.com (2603:10b6:5:21f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 02:07:24 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:07:24 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 v3 4/6] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Wed,  1 Mar 2023 19:07:02 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v3-4-122fc5440d4c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0020.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::33) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM6PR10MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: 28774c70-6b65-49de-2dd5-08db1ac2dd88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EGZqcvuh9bq7kmiCYoIm9LiYd40ilOzrn4OndA2SxnH6Gy9tHSdIZAuSaTNuxFWtu7dR/4lLUVo0sS42otJxJqafVsWwopM58kb//P0gHWz8RK8tsFShGQL5GFhVDf5Gvz2mCKw7/DKTIDTqeiJ5eL384L/llPuPQII1PCfOM7Pm77qlKEoFb0zENYfACaj3pb0/szsGnbHVmMbbTF35sAVQUOpdn/Qfyiwaoa1EKhKdXLcgARuBnf3qp0p+yskMsD9tSIegoJw8Y6dZ0iziPuDN2cxFBTKgkGZl5GQItdw3+XIktf75CEWb4P0GoJL3SjmiSgqJxb6iYVYlBHy+rLzaNqTnQolJ6o0kRIOkPSkDKsB4Rs5BrJloZ63vc2MyjqNYQIGA/T8/vbupiPExQCLTqrNpvgUR6ZgHUeRtOg13o2BP0MwnSx3rRs4fMaqTrKPMRq0D+7DLl/ZtDj9A6Q0DsCDfHXqf7kTi4A8JN8LAUkQEsEnjGTju62VGoekXj31B3yEeua4XUA862/LbJFiVCb6ogd7SjTinMzBj4SCGwjkaU6StnXlt9iBPWK7+CNiZ7taopnduDCoKARTUkbVEE0oTZkw96DTOG+Eiof1UY0zKt2ZuIZuHRzaNcRe5lc0M2T5Jg++LXO5nayzXemMcOB/KxcaOeCRH7Wbi3movwELfBwtOUxHZolTk9d31
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(66476007)(66556008)(8676002)(8936002)(66946007)(316002)(54906003)(38100700002)(966005)(36756003)(2906002)(6486002)(6512007)(86362001)(6506007)(26005)(186003)(6666004)(478600001)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGJ1YjM5aUluSG0wTHArdDdaOTNIakhHaW9kRldvWi82eHlGRmVrTHpQUHFn?=
 =?utf-8?B?QUhkdmc0U1F3N2hseXRSamcvSnVQYXgyWmUxNG9pT0JnbGwreWprdExvb3Ru?=
 =?utf-8?B?WUprOURhTGJCSUZ3Q3pGOXU2Y3dZTGxTcnBQU1BuSUloUnV3MmtZWUlPUC9R?=
 =?utf-8?B?NDRxRE9kZjZWTlk5Nm1idXdmUUNha3hwVlFWUjc0cUhYalRxQ2p1VjkzSkZG?=
 =?utf-8?B?Z0tJVzVXcHZYVlJZT0pURk14N1Z5VXZkVWVnc3RjYTlmWkdlcEFSZVUrdmpT?=
 =?utf-8?B?NXl0QnlOdGg4cnRhRit5OE9RT2V2Tm5lOS93OTl3K3RrclJKVHowODE4WWNo?=
 =?utf-8?B?YzFtcFJGV04rc0tNUXIxdVVMaFNiZDZzQnJkTVZlTXRiYndCV2NYcDJvL3R5?=
 =?utf-8?B?cnBBenJSZXBUanZQNytiOFgraUZ4bThkTm1reTM3M3hFMkFzdkZSdHJaQy9s?=
 =?utf-8?B?UmhCbzA1dzFndlpSclpzTmJaU0QydThwYkxBRUdlbVpocGZBaGxiL3BrajF5?=
 =?utf-8?B?N1kvelpEVG5lUEMxeFRsUFY5dHZsLzByaHVBekNFeDhMa1ZVaDRHemZkdVBS?=
 =?utf-8?B?bHRwdFptOElTOWV0NTAwTFlsM1haNkN5RGJuWFB4QW5CSGlydUxScVorZ0l0?=
 =?utf-8?B?cXFMYnA1dmFsNWw4a2I4SEhkRUI3MkpCYUNkWkM5V0NDZHFkL3Q5ZDd1RmpZ?=
 =?utf-8?B?eUt5ZkF2WG43Z21hbzBORmNNVjV4cW1mM2NNVVJHdjQ5UHNoT1NMZnQzNTAz?=
 =?utf-8?B?ZzhjT3hBUzZxY2gxY01aUjRXWWJDMG9VYXM2SERPNFdkaU5ZUnY1Rmh2Q1Jr?=
 =?utf-8?B?bnUzQ2czbXF4dFBGNVF5VkZ3ZG1zcHBHdlZraHFEVVppZ3BlQ3d2cFhqUXg2?=
 =?utf-8?B?VWZMdTBWbERsbmR4bUdwWExRcUoySStPa0N6Ylk5M3IzRDlXK0NpMy8reU9L?=
 =?utf-8?B?NElYK0VweDNmc0ozblpYRW1ObGRCbzVTYVd4WStUcS8yc2R4SW5iTVhOd1dK?=
 =?utf-8?B?ME9NanlCOEhXNm1EVG5aYlp0dUFCTHQwV2VwRzRXNHFKWFRjdiszalVCYkpJ?=
 =?utf-8?B?QjdlZnBmTmtndjJvRlNTVVNMZ3g5MEFhQWxhcjdNSGJhajJUczFGbHdiSmtQ?=
 =?utf-8?B?TVRvVFVZblhQT1dNKzNIeG1Wd0lYSnlBdncyN3VKd0JqbE02ZnljVnBVVEtY?=
 =?utf-8?B?OE9rTXBUYU1sWG1tWEYyb01Ud1o1VW8yU25VYlJrbVF2cFIveTVKS3pCV3JD?=
 =?utf-8?B?bnpFR1N2Z3RVRTFLczZjdzNlTXdWZURWSS9sZXlucjhRSnhGU3p4azB6aDNq?=
 =?utf-8?B?Y2tYanVFeWY1NTRLb1BZVFQrSTZEUlBaLzJZWWtGcEhrWnFVM1ppZ1JnZEpU?=
 =?utf-8?B?VHJhbUlhMXpsZUdxVkRCV3BMaXYzVkRPNGVmSDVjeUJITGV3dERDa2twWVB3?=
 =?utf-8?B?MWdOQnVXTUlhQ2Z2R080TkVWeTNkbXBFUkw5bUFZVDFBSTM5OUxMZVlOUTJ5?=
 =?utf-8?B?c1ZudlhSb3ZtemcrbURKdE5zYWQ1L1NUV1F5Vjk4RUV3dVlnSWlCdkc0TTBO?=
 =?utf-8?B?dllkSEc0c0JNeUlkdWRmUG5kTU45NCtadUZ0YU4xaWhqdTR0MjFiVFFwTG8y?=
 =?utf-8?B?M2NEWFlQdmg1dzRJMmYvRUppRGhoUDZmT3JJK3BlR3h6Tit6WXhNSmxHbVpy?=
 =?utf-8?B?T1dSSWxZQkNub1FDMTBBRVJnemZKelFialRpRWxsUjh2eW0wNk04OTlXNXZR?=
 =?utf-8?B?dkp6ekRiMk5ub3lsZUg0NFJObEdoeGtXcy9uYVZpSnVKM2hLNmdpOHUwWHkz?=
 =?utf-8?B?T01BVDZqMWRwa1luSFBIUTY5V0xGQkFocE5oOG1KRVNtNzZnWGRXcTRMc3Rk?=
 =?utf-8?B?djFWT1JwWStJd085NmV6ckRrdDVTTFNiRFQvTWFkVWFySzBrUllwSnBxY2xm?=
 =?utf-8?B?OGt5eEZQdkZIQlM2eUVObGF4TVFzamtyQWdCWmc5dHBUS1h2QXRYRUFHOWI5?=
 =?utf-8?B?dDVWa21HWlJvTXhMcHpyenE1NVNqd3Z5T2xKbnZIQmVhVjM5Ujl5QytuRC9l?=
 =?utf-8?B?K2RKRUY5YVdZVUdRRmtTY1NvSjYvQ1JJZGF0YXhBRzF6aFpzR041SUJrcys2?=
 =?utf-8?B?dklqL0JUZUFyVCszVGRCMEVORGhZdjIxVDFzT0NZTEcwMFBZSzVaTzBFWE9a?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OINo+yNXnacHOddATtq0FghXK9iFOy3kiFFRKm/Io+RnQjh8AA6yIJuijWPaLGGNEwo4DFlC1SpWwdrSttC5Hcqol3Z3S0rxfKRZ8hRnnf6LguRzQi4Tb1p6iWeizZrj7f2k7N2DhY6ZRUUyI6JLAqtNB12Ja5rLAo+rJzBehOCEqoYmi8OAf+a3LumV0brlHqTVBd2WXoL+PxtVVieQtE0U/JgspZzrlzIwiItn0M+FZZ8+dk3TrAmV6X6VO7YoGPgSr6jPT/zcRcziKfNRgmqcdZK7ZxTmeCZ62VVek4wkDzvfGo74Y4lrykdzMNiqro7WH+i+jbLogiExnQf9uHmFNRr0DDh8lyHSRYYzZI22Kelt7hdAQTB/JoY1japtyDFBtQoVv3cM7GkiXHL/ktnda0Qy6jyH0fdMwMzqRh+qpvfbDdQChj50LI2zDdljmGz3iLUMOoVlaXkcjRIsFcYpI6hgsGMzkwq8URLyQq//exoRmh2MrERIJEzyEdYuLWultCq1OzfrFac2QPL+cIpmmPn3SFBItkyey4KGLVBqTgistEaTx9XZp65ZHmPUbUM6n5d2zezweuth0dnxQBwwkxOhZR0UC5KPa/YFQ2SpFpqclAOi2fxRDWSdTa3NUEjJHriNgCrLBZ19DLD56N30LyJs+ONgNpjn3Ru2DP96ANc9D3X0QpkbfGv29PPpZr3XzIUEFXFLnhvr2sOMA+BIn4I/muv97E2XqYvSvwe166te8ZYrWt/V1kyDVmV20+oRErvgMG8UigBpnGrzQ+zsYv52qgjBGJ2V3YODEejVlClsA2iJa0uHBFi4vCelWa6I/ndO/fFkdbxay1SntdOASk2XaPDMOiZlVfPs4SRL88uNOVBp5VT6sWy5c1u0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28774c70-6b65-49de-2dd5-08db1ac2dd88
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:07:24.7598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8mAr1Dw+ZZa9KRDWVs5go80onknF4dmpJVyL/jO6RQo4cwriUE5J0feteXnQZijtMwHQRyeofE85rRZh346r0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4284
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-GUID: brpqspdYnVXXi2K_gP0hl0PCjxG6sG-v
X-Proofpoint-ORIG-GUID: brpqspdYnVXXi2K_gP0hl0PCjxG6sG-v
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 07b050f9290ee012a407a0f64151db902a1520f5 upstream.

Relocatable kernels must not discard relocations, they need to be
processed at runtime. As such they are included for CONFIG_RELOCATABLE
builds in the powerpc linker script (line 340).

However they are also unconditionally discarded later in the
script (line 414). Previously that worked because the earlier inclusion
superseded the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 137). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier, causing .rela* to
actually be discarded at link time, leading to build warnings and a
kernel that doesn't boot:

  ld: warning: discarding dynamic section .rela.init.rodata

Fix it by conditionally discarding .rela* only when CONFIG_RELOCATABLE
is disabled.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Link: https://lore.kernel.org/r/20230105132349.384666-2-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4d5e1662a0ba..46dfb3701c6e 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -395,9 +395,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }

-- 
2.39.2

