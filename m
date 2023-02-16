Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87ECA698CEF
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBPGag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBPGaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:30:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F903D094;
        Wed, 15 Feb 2023 22:30:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2KAcu025733;
        Thu, 16 Feb 2023 05:22:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6mDoHXgQbGlD3pj5SdS7xBAv6xLFz017nRs1BwZ141c=;
 b=sHBeHO7AfRm/yjwQfoVBFQZWhDZoqFwGUyvPE+7s5vNY0roIflRjQhTuBijGFzQVKLY1
 nC3/6wQ0b6tbYaKwvGKwHVUv3Gz24xVtMPXUbI7r2huV1xQ8KoUzL+LZZc2b/KspNmPw
 SLG6HeQsjLWEPDI7b4pOsRpgNbjYPAduyB3/tSnXiyp10yuYMi4DfLNfMQph4VZQPDls
 mQTI859PmWTz/lKfDPzz4R06EVzC5jIqCzSEhbtGfvhGEKaxbLt2KcGKL/tzQZYCwmHh
 dK7k1KfSzGc4FURFF+dHLojNYLnOYJFHrD/VX0HFLIT3V3a9zPkc8Jz+XSypqasS3NNz aA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m12apd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2vHk6032447;
        Thu, 16 Feb 2023 05:22:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84kgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByPEmF0mS6nF4+PbCGnHTL1r1nl/s+eAwd19zPwVWNERU8hxERwX7cLJppTUie4LeGSIwrPUWQ/S9Q8DuYDa5Ec64gGikwwl4B69DrP2dMF9RGE1G/kAnKgWOKJUelw+2j6LM3BKQjNA+elI3NU163zP1ruziEV1LH7zl79Dwhz0ev8c0rO2c/SNMJ7NVhpu/+HYuGcv8O8B6XsUm+IcmdH1zN4IoPaC3gCVUmTgHOj0lhCxHhLJjBYGcPMyhEXmast6p/zRqGvpYtqobn84yhZWM4O40nkIqn6F/K08piC3V7XdEDGu//u/Tr6qVUxHM3zon6RibXAoWrk2PJI14g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mDoHXgQbGlD3pj5SdS7xBAv6xLFz017nRs1BwZ141c=;
 b=JWNDQlsp4K1fhMuzjzP8GswYWdxqELBurBldQnlGEm6olwXjiFr3v+PdlU5Yyol3KFImOTn+9Hn9lkPoglCwRG6ur8br9o4CMY6deWN0HTZw1N6Q4GfuqxszWKUIA4fR3YFeG/FRUJUyaWw+ThQm3A3uT258g/JxlQqHyfH5yRysJ+AlCqiMBRddgntS5rpCZ5d0R8EU3qTral9PqKEfWy53XIE9lfpAfN7nXvDI7fZjSEWAkW5wPqLTmSGyqN6Rne30EGoYnn1YnNYlZUyuSqJNe51KUzUX4z24DnWcqzJcroPu3+30KWdKd53d3chyXN1UcYPc+i/3Ucv+dd/PKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mDoHXgQbGlD3pj5SdS7xBAv6xLFz017nRs1BwZ141c=;
 b=oED73YtY1OSWUgRXv55ghnVPz4EyiHCySgjnC4QUfywl/+9akwuFgQlGB+OsQ6fpri8ya6HRmLStTyrkK/z+pa5g5fAfvOZnow+Vd2b4tEokZnERF3uzJc2wYwPhSpzXRVwKcFqRbRY51J9D7clRhps/ozg7YKfcDLMyyhxaYu0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:22:48 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:22:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 19/25] xfs: expose the log push threshold
Date:   Thu, 16 Feb 2023 10:50:13 +0530
Message-Id: <20230216052019.368896-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0090.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: dd1d001b-777a-47d1-da8c-08db0fddd784
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ad9Qb5/tQEitpoehgtKPandPSJ26v6bCW12eRn8XP7wA3p5OA3YtGeRMMj5TgGE9g7JuJnSXupbHZaz9bPuqXUaX7S4LlsVpbvm65oJyNHwuUcM+UbzqXykZgstd5PxftswUIuugxksvqIpanyZ7cr68JxTGL+cO8bzK997J4l12kJ+1YTI8opW6nXYlDriNnRrVJJsQTOyGSnhiXjXU5P01qPE1vnuXF9WiyMMSyf+BnRV36f9dtDybULyVbZINRX+fvhIZ02qVDhl9iCZxnIEurI8bpoBT7ubPF86iLq6hEVsaCp7sdHEV8GgPySoIaS7TGMA66lbpcnMeRZf1FnpVsLmA984jFAk4WSkZ6ROuNXsOizAS4rMR6LswvqccwI/Q052Gv0aKW60Wg2T+jLPaalIsyGc2EXC/j9eAA8zWp8XPI9/aGPTVbQ9IOvCDXk/X29PRTsPZA1LObQ7vdcn5N6wMt6hxWhpPpk7icWoIHYdg0OYWsJ1tufDRFfcsHnxVaC8WBwcS+nCMYZ2PYHsfYIJWj+/UcwjlaqUCErDiceH9GazqhMSXbC52NkHTDoNZDD8UW323EdpvTZOpmzTDb/Di8hUvNXfSAVxaOCdvrHwQYJJ66Y92hWIPrJDH4N/YRbPOGmBU70qJFF/iog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(6666004)(1076003)(478600001)(38100700002)(5660300002)(2616005)(2906002)(6486002)(6506007)(86362001)(36756003)(8936002)(66556008)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GvX923m6ro1u0Q0Hm6+sV5yLPdCDwSaiDGZviEfVzIQs53L6NgFXdH2PTNkJ?=
 =?us-ascii?Q?QeCqr1HlUv9eLUyVv+1AEFF/j235wOLvhOrfM4LoJtzVflzIZLvR6GgWrtFv?=
 =?us-ascii?Q?D6vZCMrq2r9nEN4l6G3qM13K9fnmscYSYCNOYY//9P6u0+bl0mt76qyM2OQl?=
 =?us-ascii?Q?AO9G5L1r99iW3p0saz0c1jDrmX1xbiBBvZrgQBZlG3J9FPsJVv9DrHDYUEOc?=
 =?us-ascii?Q?tfg3R+1wLl0e/wCPAMDnY8+Ilt1bQtKRLTQA0t0cwmhIY5ej6YHT4WtAyNN3?=
 =?us-ascii?Q?rMdhCG9JOgWHTUYqgOpaJN8Cobk8+PCwYKZvq/R6fR74U+06+ZBUWEyqK+uo?=
 =?us-ascii?Q?MB8fueQvA+t21XTzdIbzNpYKCaSmAVVpay8hRdpZxx9hNXnbe7IK5eaRT0rD?=
 =?us-ascii?Q?+voipwWSz1VfSmCaO1TxEGyxMCwXU1a8MS9wZtJG9TnO9zaIlCnezuNd5l7v?=
 =?us-ascii?Q?6EVNyh0B6O2vAC8CIP64gKJMTrMTaDDpxl2awkFB8T9oNUvB5gw/yjalCXwh?=
 =?us-ascii?Q?kMxQ8WBBpuf2tY7io/msrNB093ITXhPeq+3RftIitn610xDtTwa3as9yyIOz?=
 =?us-ascii?Q?StYjpHkVGAO91N5VR5n+ccsk13XFTSQlBt88WdO+SqbP3j6ifS4XJ9rqrNCB?=
 =?us-ascii?Q?AIMCZ1dkF00obBgqu2iH8JZC4WmU0GSgrt+cfsD6xabsXD1usl5DNYi7aiJR?=
 =?us-ascii?Q?m0ewwdER+om6FbudzDBsylK0zfrzTg1HHvmdmSjYff7P1ca+njD3HeIkFr1N?=
 =?us-ascii?Q?j60dHL+/LN+eA7pMFSFxkL0l7f1JKIQAyOakPFxuh3zQ5RgOW/XUR1M2dbNL?=
 =?us-ascii?Q?u7YFYiho0Za2xHdgM0+uBu7VfvGCMLzqIJo2nI5KfYPx3ehV1QoFqTfoLuFh?=
 =?us-ascii?Q?ZdXGg1i9o5+Zz5wpA6nL6ciW5P5NgT1iCE+YP8fwbrLPMiO9yvZT7X9fSaGP?=
 =?us-ascii?Q?mXKbMM+Dpd7ANSEl0X58Aj9BNBZTmP0LF2wzDP9I0HypYgg/K5nQGvtXZRoL?=
 =?us-ascii?Q?ZTrL1SKS7ZKUwctaSrf1nlA1S0xeK1045py9/IVQHazAdFEETx3A2pFymThB?=
 =?us-ascii?Q?cWQVcAUwoAP/2rCRGZrWJwGB7tqVQdr85Jx0Nfjl4oIl+1pFFYgOBveu7Eaz?=
 =?us-ascii?Q?/zrB/9W61b8UV+97NXEBQ0gTXFNEv1TFPN0/GeODjD8sxYYpL7chAQaoHskG?=
 =?us-ascii?Q?YWIUnNjyIel9KslWQGJpDrbi9imfng8Tf/RN8yHzDo5CjsplE7OMm7FFsX1A?=
 =?us-ascii?Q?DoPt+mhK1Q1guwUuHxNj4krFnUeu45jBbUDZwSjmFTrreLVtG7B1NdBNNUk4?=
 =?us-ascii?Q?JThexNU2nVUScrsj6dQCuRuQ2iy92fwdwJM+jIcKaVDUDi2YHwCf3OyGyC8n?=
 =?us-ascii?Q?tRpxPdc7wLARZHMcKPVoqjljL5oAlNjF65hFND9YwlZfiPImSwud2Qsv3Uz5?=
 =?us-ascii?Q?pmLnzV/nJXseZDsC9TQbkZJXETN7diwGSE66QPIDbP1D1U1s93M1X9l27CyH?=
 =?us-ascii?Q?lt0NJuI238XCrgELIsrawNeGgw+9VEFuLpEoS4JpMpanq2XhqblCqAXjcMd7?=
 =?us-ascii?Q?ESHtefw/cArhpy/NnDv64ADaWVLTCmuKfwxJCcIKdU7xCuAC7z03SQMjSyfR?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XbYBiuza33CumvVzQ4xFR9xoJ9VgutkvNOI/TncA/is5HNIg1TfjdaKDMNdTNx8nhvcXD8oX9qWJeOdR52ila3RPXhaytz+KzCL3oYBl1NKwRgCwh8qnM85/i2iCcssWpxAcrQqF9qjqOVS+1i22vp+p0eBaWBq9hydTPVfnW2tWHb/ZVrHojHzfScXXhJkN6aSXXi9XbUuzzPk2TvH6CDAnehHyVOSWqBqahYIT1Kz1/BE9IzjfuUzxXQHRDiZnBsSPQ9UAQlTNnxA/lhwTg79QEugcJ/xx4e/hn1wU7zyfFFHL+gjG4Cgr84sguBFp+3JF83RUtOsqwrjliFITanIYpracwjGrph1q6PnWC+gvCqjG8QUjsyr4n+8zRGryFpxTreRP+L4U6H08qnDn8chPoiyTGt2zi9grJ/H5aeyaZxzQIOwfRvCgefv/+Me5TtssdHkH5BR9eFhJaRWIa0xrxqioLkPdvYjr6xP5x4bMp/Usy5l7eWyTm50kYxQQxIYhKKfy3g6x4OfF1avItrYcYUMJwrHOj1ygpjJ056TMcLb8op60vjkwWYNwb1SEyCCnx1EKuYU0pGobj80LBXHNKm97LO3wT0CmvTi5VHi1xAWcftqVLbCeEfzJEF9yMFHHg4lURDZj2giypZO0KohyeGcEuIg+pdZ6CrHq1YSUXyF0XMGhOj5cWJMGsat1yaDoIsTU43ioVfFOhPVqXe9BrWtKF8Dp2Qjd/19fCbhSLkxC3EGNVmdidpD0xnfEKAwZ+ipgGvqR7QXYUeuhh81i65jVUv8+J12Rg7IFEjboFUnAjrk53quFabTFy6qlS1voyHOlZezEeI/U9fmmvfET3aULdY0I9canphnykVm5Bs1YTPlXlIPLg6ipO9br
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd1d001b-777a-47d1-da8c-08db0fddd784
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:22:48.3241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: syuGPq3Qtpu9z0dRldeQoAVyYVfC0I9KEu1vqcH1Da22fJbE4IsYwymE+kbHyN9TyV5bJqZUjuvBJjq+c1r4rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-GUID: Y5n1ew0J-jCtp3mKm260F0NopM_VCrdt
X-Proofpoint-ORIG-GUID: Y5n1ew0J-jCtp3mKm260F0NopM_VCrdt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit ed1575daf71e4e21d8ae735b6e687c95454aaa17 upstream.

Separate the computation of the log push threshold and the push logic in
xlog_grant_push_ail.  This enables higher level code to determine (for
example) that it is holding on to a logged intent item and the log is so
busy that it is more than 75% full.  In that case, it would be desirable
to move the log item towards the head to release the tail, which we will
cover in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icreate_item.c |  1 +
 fs/xfs/xfs_log.c          | 40 +++++++++++++++++++++++++++++----------
 fs/xfs/xfs_log.h          |  2 ++
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 3ebd1b7f49d8..7d940b289db5 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -10,6 +10,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_icreate_item.h"
+#include "xfs_log_priv.h"
 #include "xfs_log.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 63c0f1e9d101..ebbf9b9c8504 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1537,14 +1537,14 @@ xlog_commit_record(
 }
 
 /*
- * Push on the buffer cache code if we ever use more than 75% of the on-disk
- * log space.  This code pushes on the lsn which would supposedly free up
- * the 25% which we want to leave free.  We may need to adopt a policy which
- * pushes on an lsn which is further along in the log once we reach the high
- * water mark.  In this manner, we would be creating a low water mark.
+ * Compute the LSN that we'd need to push the log tail towards in order to have
+ * (a) enough on-disk log space to log the number of bytes specified, (b) at
+ * least 25% of the log space free, and (c) at least 256 blocks free.  If the
+ * log free space already meets all three thresholds, this function returns
+ * NULLCOMMITLSN.
  */
-STATIC void
-xlog_grant_push_ail(
+xfs_lsn_t
+xlog_grant_push_threshold(
 	struct xlog	*log,
 	int		need_bytes)
 {
@@ -1570,7 +1570,7 @@ xlog_grant_push_ail(
 	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
 	free_threshold = max(free_threshold, 256);
 	if (free_blocks >= free_threshold)
-		return;
+		return NULLCOMMITLSN;
 
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
 						&threshold_block);
@@ -1590,13 +1590,33 @@ xlog_grant_push_ail(
 	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
 		threshold_lsn = last_sync_lsn;
 
+	return threshold_lsn;
+}
+
+/*
+ * Push the tail of the log if we need to do so to maintain the free log space
+ * thresholds set out by xlog_grant_push_threshold.  We may need to adopt a
+ * policy which pushes on an lsn which is further along in the log once we
+ * reach the high water mark.  In this manner, we would be creating a low water
+ * mark.
+ */
+STATIC void
+xlog_grant_push_ail(
+	struct xlog	*log,
+	int		need_bytes)
+{
+	xfs_lsn_t	threshold_lsn;
+
+	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
+	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
+		return;
+
 	/*
 	 * Get the transaction layer to kick the dirty buffers out to
 	 * disk asynchronously. No point in trying to do this if
 	 * the filesystem is shutting down.
 	 */
-	if (!XLOG_FORCED_SHUTDOWN(log))
-		xfs_ail_push(log->l_ailp, threshold_lsn);
+	xfs_ail_push(log->l_ailp, threshold_lsn);
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 84e06805160f..4ede2163beb2 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -146,4 +146,6 @@ void	xfs_log_quiesce(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 bool	xfs_log_in_recovery(struct xfs_mount *);
 
+xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
+
 #endif	/* __XFS_LOG_H__ */
-- 
2.35.1

