Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB936DEA75
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDLE3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDLE3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:29:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C371244B1;
        Tue, 11 Apr 2023 21:28:59 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLGCTP022973;
        Wed, 12 Apr 2023 04:28:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=geVhvOhq0QYJcqzQAFB834EJ1o05Hf8uwTER5yK5E1U=;
 b=d7dTeb/zBqZ+aVbBAiY/dISf6KTVphEzOEk69AIYmFuEikCoJy0pjq+N2IdkOJE22LMj
 NIi7z2LEWa3ysGDvsMdP92xfX/R1H+xfrzhwbq4qXQLN75Z7mATca4s4X+vMJh/y3+vx
 LEzlAlbItAAN5/TSf8q3ILeFrKQRD0bqogEPGekPm8Fe6jWXptegrXSxBJNUh5Dmlr9x
 a/x3S5sH9Lsj8WseRMRKf1pw/Y/+ITBVkDpPEmc0rio/uUCHaUZ5Wshqn6oMUs2FuAmA
 KxlWqUy1objqH7Ub/Jm2+fuEsJQZGF5W+NqDiIjXm4h+ZJ9TqRXLJdI8DKAfp/gB0JBQ pQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwf4h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2aXF6012945;
        Wed, 12 Apr 2023 04:28:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdq0pbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffJI+CPm90eKJ/zJBDbN5ZGBGC45u5EqIDYn6rASmoOC/tHAQQzdx4HoNa2a2VNGEIIYIowBrqBOSu2YzqPz+EsxYBXMJCfi0vPIAqS5ok+4r8qNKCQydLfgFiAmdyeroLSv095KpRbbnaqryXl0fC5BZQSBK8acUisbaEj4Wbo9rdB4C6bwdvYamZl8v2dqOCh4TH6HRRTPgFZx/JzL0kZhZ+SF/ZKzXL33K/E1P982MBVk5uNE1UsaIH+S2u3VJhv/U0/VWQXOtuQUKIuF7DTsYPQZUYDlbETctlLcxKdBqAWIpo2tKTRLMGKbZwSz2BUlSH5Qcg4p7yCc9SR+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=geVhvOhq0QYJcqzQAFB834EJ1o05Hf8uwTER5yK5E1U=;
 b=KKulUdiSWoYfTAtXqpdMWM6glWsWQrD2wcOJmLbXcN2VrUFtUeuWH57fILzYX31dqyuHMVLwNM9TEMftV/b9kCDWdh92c4zxLa22BfSAp9HNPc7R/QDTKRuwse1YrHVEQJWLxpXDX6AeBAxT07AktP/X334AK1Ym6++cLcYf6KiSCdUfDmLRiBX1NjZvFKVO8Sz2XAOSjilMqfvksD7BHAiggGaVHFHCYee/hg1D7/iQ34y9tqQIBND8X5/z1Sz0monILtYAOjrtK+aSmfObCUBr1aO6xjX69SeEYL6LR8++2ImYjM2koJQC3kpZIV/+xWXuQtFZjDcz1MWGD66B9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geVhvOhq0QYJcqzQAFB834EJ1o05Hf8uwTER5yK5E1U=;
 b=BupvyX0GaHqqBTTd7SIWC5h/ZeTdM7Bs8jOYQQHcKTO1Cr+nOXkr/lS3yfl+kVVjv2iwIlxSnUGZtq6jLtgWBVobMhScIgJJrLZjGl7fi7kOSqD4qIIwMVjBTOatNZvQ/7CUC71EC5sYbS0zKTA/8CJWXVhKRvry7KvtH7Cyo9g=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:28:42 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:28:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 11/17] xfs: fix up non-directory creation in SGID directories
Date:   Wed, 12 Apr 2023 09:56:18 +0530
Message-Id: <20230412042624.600511-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0007.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 461fd48e-d20f-4196-9ded-08db3b0e65b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m26Ssxp0qP15GwGv6xEnbwo93S8xeChcypy8JGPX77qW3stKD+7rKB+EJO2ernSZ4xjv+HMyPdK7xC+ZwrKD1KEi21STYh6HhX36+1/sMyMA7YPRDagISwDlzkT4iOAqAApDJX9jj4TfRaaRw2sZt0pu4jXHc+UMKvMtbK8pJfDu3wRXWweQ3eyqQyjeI3QBLtDyE/1YEnAD9fvZ/3hy94DKgifS3JaBXXREohi5NUHlo7Nzy04ZINFAbN2ZZ5zKZ8Qe4ANoCy/qG/ejSNTKO7WgUJl7qRSZ2HEWAu9CvOTKFs5iHruPYThjRUXnuFON1k6ccvj0H2mSafBnnLhb4JXnVYE/MBcoDKiINO6VAUCbkk8BdlQztcYhs+cO+n4RTxodigI4u3cYawwZMMHdNCBsBmb+WhP05XMxECykXPFBawPXywgRMRhZaRcT0Ya0FUiIfRgyU/eWveD8cZyg/S9Wovh18hMGfLW+42vAlRLidXWEkCxyxRbZVBS8Ij40xZs251EFSU6oJYWThzlwPwK8pN5QnEy2t7nQYruPBnVmZNFEVV1MzOVU7FRe7I/F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(6666004)(83380400001)(8936002)(2906002)(5660300002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cmGqAJ5dM8dypvdK9UZTKbpc1VLKsupk3cBYhOB3M+ibKGhwH8uN3K5Am5LV?=
 =?us-ascii?Q?JTB2Cn4cvE9STy7akpQ32LINtg5otyQ7ix4fOn+G3FMHKtgobf+XjfUdRfi5?=
 =?us-ascii?Q?U6uZhSel/YZyXY6IP9JQSCInRF4ZCnZ4XVn73iZrjufhckeLTfBZwSwyDhC7?=
 =?us-ascii?Q?qUPbu8HFgGc6PHXY+9LCYiG1aG19C2WWcn3uC+aa3h/bVuWPPUOYcrtUUPC9?=
 =?us-ascii?Q?SX5K8ezZRLzgOZFb38XflXfaZhmsSZjYdCDy8UFZlCXtCelYUBMxcEwQbqXe?=
 =?us-ascii?Q?JZ7GyKAUhhU0ir8WQsBTCPt2LoTtiOB6RT9F01SlyROLZSOwc9nes+JiIjpi?=
 =?us-ascii?Q?9JQOPZSJQS6/bg4TeMQUuQq3lxdvqm/9RuZ81gh7yn+UhkQS2osy6dq0f673?=
 =?us-ascii?Q?IYMRT5iGH/6tRXWfzXagNONe1/ou4hqVOpVVPZE2c6CiRrLSb//HihQzCjEp?=
 =?us-ascii?Q?WnAUYxQ4kl/U/vI3zupcYB5TMnt9RWjKBeOBR70G0bQqSELwQYjGSwe10XXV?=
 =?us-ascii?Q?7HtPirF/PZwtgc0Kxqouo0o6KfKiHrp2ruu7L6i0QYQlMhkMD6W+1dSTVzMe?=
 =?us-ascii?Q?UvKzRZIw4yo6DrHJ545gkAIiUfASRO6KSaYN/FwTdWAXPzLNkZm+qh+bJgW7?=
 =?us-ascii?Q?6mQ83nXzWP0VUd5u+7RmHinQPKRNdONPXk6gLIowK19H9NMsYQMYlPeFwALL?=
 =?us-ascii?Q?TU6FOvvnWy3f1yX6ElzhzElR+WZGxAFNscfTKAL1F1FHHGP+IDVd8yAB4ftb?=
 =?us-ascii?Q?TrwLQI6Ii/D4WU/HxKYBikrfELFH7C4nhaASETV2kqft8p32mv3F5ucj50+d?=
 =?us-ascii?Q?aH2a5qVxMCkqayKnHlgonnc8IxCzYDCm1QfHVYzRXsV0xAfL0d9K41EPriY6?=
 =?us-ascii?Q?mOOHGOwjnajfESklwA3KXlT8jzsCfH+tCn6+28saZFzUGYtNFrdUQFjI2k3q?=
 =?us-ascii?Q?Snv1hSJTT85QMbQae3Z4e1AuwjgbElQRmTLz8aL5qwpwBJG6Ga2qEpfgquhX?=
 =?us-ascii?Q?E2GQKjwlsU770PE4XPXknUG4yFxVUAkRMKvAkq3loqYsJ6FZ0HVbPlyZwIeX?=
 =?us-ascii?Q?S2EO4ZDunDz0UfksG30JvIEg+Vix7h2nxEOZYHgC+PrZg61VX+dXljaqsa8z?=
 =?us-ascii?Q?IEIF9ftyTZnSNU/9TmkcQDvLi1tQDg5B0LUztUvi+JM8ElmiPXkYs5XlN5va?=
 =?us-ascii?Q?et9HwzfTnmvYrC+QiExISirfJxHU1Dex1bUGqKabBpvDoq5BMjB6R4QoCFhC?=
 =?us-ascii?Q?HeYp1Bg16kU7GUaQumcFh8WJ+x7IVDrOH5f92+IRcP3jMubz/yL/b7bgAp0K?=
 =?us-ascii?Q?oR1nXEiTsYKtt1i36o6su5Y1dkQoMGTPN1V3AgPsxDXo8678e+05ZLWckXB2?=
 =?us-ascii?Q?rEAMAy4gMMDaW4dq/Tn2Tp3jvi6kT9QCHYl41bas/B70zUHUTzzl3Yn6cOxL?=
 =?us-ascii?Q?Euime8hSm6eqhHPl0Fbk812Mjxi8hIXP+XtZrOXH2JrVh8eNagi2hVR4PQtA?=
 =?us-ascii?Q?DNALV2WcEKsp2Ok4h6Ei33CG3M66DlWddCLNqSVe1Dla0igdv+R3egJjtYKN?=
 =?us-ascii?Q?pgLt6E9hqeGOxxYC3tZYd1fqzFBGhvc+OI517DSFDOyvKVkDP+/GO1cLUzkw?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wRVL0dbNxvHcD73HZsz+FbYBzxbtR8TvJN0uCi8YKhJaxyZs5/AjpCkUWf8HtMwdizHa9AuOIGOkZrGSOakmkbyK2AnyspwK2alMqA0P/tehVskn2M1EVPo8dLIIRg4YeDMPLgTkuyWe+ykxiY3HN+7gTXYb0ocavMKsdHQR3MjZz5ElaYink1SKDniGqllN97tEfRz3ubpk0uu82wFC1vW2fVhmiHuHO0fyiXlsm0LJoZLZQagMUjTMxE4gAutbr8KPx6rMf7fFSKxTOgYQTv76j+a7q4dnFglspZ+vcu0daSfEfO2ruNYqLDvlDv9i2V9Hx6i9Sy/SPUVuD3PnonElwNqVo2JTnezjKS0GI5DWQOWkfHbBJtDLajwHVS1a8DtCpniuVJUcUnpOD+o8ZXpjdcOjRRCwbZUKavfLQbhCXJrirvjzpAnzHwFT6x6/eQ9eH/seHN8VA6JtUfFECkDQ7O+FCKcSWOlo+isVy2e/wxL8YydysWEy8ranSYfPS9OQ0/hM5Wzkrufu7JoductXXrgRoj+H0RhROigW2WPFEDBHWUB4h1aR2LAEXMr2ZODZXES1j3jP5kPbXgVF8EFEKWB/PGLqiDhU+1q2wZTvf3/5g+osBIe0/GEIe1ORhXMxo6qdZBfCED41uhAQhbkMhqMfQ42xTqGgG86zJy3A7oBw4KpCuU4+RF6lZWpGKV7xeX+ceMEDvi4e8Pe98yARdj+XDIGnA65UiWJPHatzTit4zKjskMuiy/BHvO5SaPpSmkfsdz/Q45Oy8bSEAEgWYvFCUTz9wdESErAm6Vs+hiuewCe+0gSdmMJzsPS04vrhVfLo1R6gBZzjCIn1wlICUoR9MhnvyNkAEwZBzebOZrIYmKp7fcfHlLaO9a6B
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461fd48e-d20f-4196-9ded-08db3b0e65b9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:28:42.7441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gfzUJxUR1WYFuqgy0VPoZIA+6Ml+XwJ7dwYMrTiJ5StdAM2CWE+TiZWsStMjGQec7DUow4g+l1NcE9A3v8d8xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=757 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-ORIG-GUID: hO9i1XoCrLDtKpA-sTQ67gw0mUzaSDEu
X-Proofpoint-GUID: hO9i1XoCrLDtKpA-sTQ67gw0mUzaSDEu
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.

XFS always inherits the SGID bit if it is set on the parent inode, while
the generic inode_init_owner does not do this in a few cases where it can
create a possible security problem, see commit 0fa3ecd87848
("Fix up non-directory creation in SGID directories") for details.

Switch XFS to use the generic helper for the normal path to fix this,
just keeping the simple field inheritance open coded for the case of the
non-sgid case with the bsdgrpid mount option.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6bc565c186ca..568a9332efd2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -750,6 +750,7 @@ xfs_ialloc(
 	xfs_buf_t	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
+	struct inode	*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount *mp = tp->t_mountp;
 	xfs_ino_t	ino;
 	xfs_inode_t	*ip;
@@ -795,18 +796,17 @@ xfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	inode->i_uid = current_fsuid();
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
-	if (pip && XFS_INHERIT_GID(pip)) {
-		inode->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
-			inode->i_mode |= S_ISGID;
+	if (dir && !(dir->i_mode & S_ISGID) &&
+	    (mp->m_flags & XFS_MOUNT_GRPID)) {
+		inode->i_uid = current_fsuid();
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = mode;
 	} else {
-		inode->i_gid = current_fsgid();
+		inode_init_owner(inode, dir, mode);
 	}
 
 	/*
-- 
2.39.1

