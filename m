Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C40C4F0088
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354294AbiDBK3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352322AbiDBK3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:29:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D311AA059;
        Sat,  2 Apr 2022 03:27:16 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321i01H024919;
        Sat, 2 Apr 2022 10:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iU8HfhobRL1Jx/3CbnO3pwRLaev7nRNtwfuZ5T65NR8=;
 b=FuOKoTeEPHEofLu9eAJvX/BEbeGqyUwhOoz3igj+lowT1YNgmyuy9Nc9C9oToRAdMD5I
 qVd30Hbo7IXatac19BBiJhgZVaDNagkhjIm6xxJVPBrgfalkR8BtwT/6BPoUBd/HWL5X
 8OsBlqup02S1Vl7mEgoNpN2B2SqLUSMe6BPxJ4vluFPu4YsqgsGuHb+aW+TeOrjSvjL7
 /yBXhkhxb5C5Q5XXAM8e6JQ/QhcNHxcBToaj5wrHaID8Q5ezTX61ZG16WdlT3S/j3Yka
 MTh1+NJA5b/knGUFC5Ay7NQUJbt+79KkRT0SpeGeSd0sQesu6w4eyApNP2CGGv8BYHW0 XA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d318ds5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232ALO9w024370;
        Sat, 2 Apr 2022 10:27:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0xcf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3OKmZjBtZur1Nmnb2e5t2ZoiI0l4S4YU4tvye5WxfCf7w/7ncbLV6Xjvg8kYMFRW6mNXz0YPY8PsMJaq+E4a4hELQ3XOil4Qynv5Rskwy+acezg9y8iaKQ2Aqp4OWOiGc8EqL+SgU43DVDByxBY8xIuWLpmwqsSAX15HTcQIOPsYBqT0JaoT2dT4nuoC6oj1F42g84Fk2rHcbB0EFFKN3cgbYbxp4+lLzknMLXs/mAogEUmN+ujdPNPq5EloMnVikn8Xh3AQ6a+YqM3iCMmWd80d7lLZYco+78B7I3JrHGNwisNR4EBp/H4YQ3uKVqe9L/8Z89qgIILKX6IurRo/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iU8HfhobRL1Jx/3CbnO3pwRLaev7nRNtwfuZ5T65NR8=;
 b=U6TfGokfczU8CNbp19sXTMcztqON889clIxXxifw+3By2vKT5FqbnPfqsfuuiLG0KAHdyMgNZu9vsEMsXbfv9+uOqGsMmupS3KNVLb7lWc/QeSa4NgaRGQx9o62/uHhg+0RcOLwrHrvW92sgQxWXypPf17SX21aDVlpBjpsUxInxe/DqTB5sbIuDJrGGptCUEL1TsDE++c6KfsTG1xL1rptNGORlxpb55caTCJ+X9sC3jBKOMxe4OMqC/opV5kzIT6dWUhVvlDflpoHNl/IMHOuskhY0fWae33X7ATGCoBOw4XCJcRdHW7vEsUptkjfVQOSAB28BHmOldvg1DZdNzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iU8HfhobRL1Jx/3CbnO3pwRLaev7nRNtwfuZ5T65NR8=;
 b=dPqX2MhIzUVPZtSbzT/uenxBoghurZL3IGsEecpepxmqBMKfPHhPm0A2zUO5tlB9sp6i6F0uP+mdahnFmbMb4m+kzVVlMHczxQaTXFKBSjdJX34LqnwiXDMGVIfOr/YYLGGF+b9hI/XIT8McKoHMgjo4Whh9JTZzLg0U0v4yBMo=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:27:11 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:27:11 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 08/17 stable-5.15.y] gfs2: Eliminate ip->i_gh
Date:   Sat,  2 Apr 2022 18:25:45 +0800
Message-Id: <f3cd4ff8a92d35a00dd2f2b3a379f354f57bedbb.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0241.apcprd06.prod.outlook.com
 (2603:1096:4:ac::25) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbcb8ad1-4150-4d7b-a392-08da149358d5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30490C656EDFE226552B597FE5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eaKxFdCqdenZV4VMU0RBuf2jO/JBjBZTJ56Qb095UmIx+3o2tFOW1eecCnkLKuK/MSbtSAQuGo8ZDzbUwfg/InqSMqONLjwu2Ox3EiSOT0/0sqaCw/4kRa1SL3psk8EAXgVyKIF9GSKTym0qgRkeAsakpVWu71llDj7L2hYQqkma699yQ5jC2kHIRIRelwUShXFnsIL/JcIj5L2g94KrKkU610fGtbzFIW6gPEhImG7wnaj7aw3Gm8MTUVUvQUcsESgwZMOl7eD77MfoxokH+sDseSLnn8ntLerIRxo7wLvmYNLvqXAdcQSalHQTFB2if0FV8lh6Zz3GEtV48Ls4+hKE0BiOCcg8413WcAW8zWEGwqFXbF5KTthJCIp4NBrc77tiojlceEOgAKRM0C/rGhd9dqU/3ROF6FgEttJPH1iO6AfgRWLbPGA4xiA6dcEWshFO2RFP8ciBP7TG4i62uNnxzPT56t1BuNzRBvBN+KWcCVWkleFUn/J1tJvsrLyxPIBelnjXUWdAuQHewTDLhSM/KCk3ANMVZMm5PZ+QpUi2OZ7vXEmRfIaN7sda+tAHzbtQFXiB/XlFQ9IsAEqeHO/Xj5sLuz940NOU2KScD0UApf9Aax1wkzO/pfYvWYLgIp6/N++oGWT3vai1e8rytw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(26005)(6486002)(66476007)(54906003)(6506007)(36756003)(6512007)(86362001)(5660300002)(66946007)(107886003)(66556008)(8676002)(2906002)(6916009)(2616005)(186003)(6666004)(4326008)(38100700002)(8936002)(316002)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eZDxuCNhu0CshhOnXEWdYY+RU/vwR8IHQBa2d26srbmL2/saiv1xh2Vad1An?=
 =?us-ascii?Q?QtGm7gbLoJXJ59/yuJZ6R9aPAv3bzePDgz42+PRRONQfe8F85cALllbpKmTt?=
 =?us-ascii?Q?N6RuhxuguYNiLfCCSRY/iZyMS6rmZhfXF9n/zdF3PG/7Pp3lsO0E/ZuaBwaW?=
 =?us-ascii?Q?EV5w2sQtcoMZh+4eNaRa4dknNxwxBLnFAFqB8xbrmrQ46R7sf+2JNUEBZ6kr?=
 =?us-ascii?Q?44tXSoLiX+SfrS9RlsYYIO4P1J1eQwayZe5i8zDOjJCOiq7TdzG7IJ0iDwOT?=
 =?us-ascii?Q?QSW4zAd8FQcWcswZZXQTiUEHRNUao7ppziSNZhpi+/WTAn/3oY3MgGJMYNZw?=
 =?us-ascii?Q?gY188m4BwShvIcAePN3An8MY3mCCtYLT6cX/Kpjx9HIdswQEL5aOk0X7hn0a?=
 =?us-ascii?Q?uEOiRaI2yjdqoZlAIAIK/Lp8x4hxVRJZd96RlOrSyCeXzed8zZouocHP486H?=
 =?us-ascii?Q?E8+dwgztS+aK/ccqHI1vZK7l6jeOgw62+5M0Pyd+UzDYdr8gxYpRtCrPId5l?=
 =?us-ascii?Q?+LyFfWawU1d+mGHE/jIs6TywQK7dv990R+hZ4biAtlCXyfXSzom3cni1K03G?=
 =?us-ascii?Q?7ZHtIoAp8eCpDFBUihWV99kuZK+KIE3mPbiS27c3eKhZtCATCSKWE78R3ZJr?=
 =?us-ascii?Q?2jyhXTSQWUjPEvTx9uQdIFoJRsnpYvTWb+a+wavnKBVeDhoAkIKIa55NZhcG?=
 =?us-ascii?Q?EedoMQDYpbFdkfkFYVBPrnTe+XJA5t0AaRm/rjgu0lqVdGwyRQpJ2QN5tRh4?=
 =?us-ascii?Q?T+4YhRcXeHQ6AH/uXIFbvL8C57ZgDE4LhsI9NcJhwx2gztf6Y0tOulWmfFz+?=
 =?us-ascii?Q?Q8vmrV5+pQO3hjM9g2CZwblh7LORIArZRBzuDX3o9WQenAEKjiDAywgI7nkf?=
 =?us-ascii?Q?ofrKE2tp+Yr2Gqkfr32GvlMiqIaZP5Rp1DYZTvCgHrnd6FoI726Zytng+sTd?=
 =?us-ascii?Q?IVKiQ2SufMGSXfmNB8XH2H00ZPjlb4vFr5VmLu+GtcjqZ+qnPcrtfVZz9zmj?=
 =?us-ascii?Q?kqpzVOsbdB8NXvBiL0pSls9xFzAxFBzYSL3ROsstrNrYGX7I6KR6ogRPjXnS?=
 =?us-ascii?Q?4FQAc+2evmjsx2Z1voKp+RHNX1G88ctyU9rkQWVCfdpCUEIoin8IWB3tJFQh?=
 =?us-ascii?Q?LqRAO3DQY0PPZMWdXvlHs7mlUdKhHkInouSyw5f77l+YQRukC2BlFFtNF8T1?=
 =?us-ascii?Q?9AVanhQbVB2faqUVTvIaBQpWjWhoR8x27kGp81q26IgrVWTQ4Vcu8IsNZwLj?=
 =?us-ascii?Q?nuvnCijb7gEO+s6+mSeu7Kp2VaiDrYgJgH34iIJsXC/a7U64ABZOIwUMyxtR?=
 =?us-ascii?Q?LguwanGAsNx/+sN1sRCoh3t6OeJNUD6QefU6G0/9zifW9dSUbei/FLiZhiQQ?=
 =?us-ascii?Q?SVvXvB5NnCXGbm3bw6w8KwhYsv0NFdJGHSOcPHH2y2flnkjW/EDV/f1NKJkZ?=
 =?us-ascii?Q?n/3hmAFdEmTRvyxYdjS77FFNOrodTfUkqmG/MaJ/1KOnzCGgPVFPz6KUBR3g?=
 =?us-ascii?Q?EVT8q/StLtovTP6svMOk6kgFP76+OPFQ0p1G7PNegqlWfq3x44C3Qj/9PaDv?=
 =?us-ascii?Q?7apN1iPJcNWlzzxk5nQcZ2g/NjbBk6Ttb3x9vmepSQGlFJfc9ENhH4gq6QJZ?=
 =?us-ascii?Q?tc8RRaUP8a8yMJcKbNIp28Cxn7QNwNd485t7UB0UgQ28NYHG7Dpvvd4id1aW?=
 =?us-ascii?Q?wNSlwTqI1QbOwAB/JsUMxTn5egxH7F5a/yvE3iyNoKfP+/9XTspSljMca921?=
 =?us-ascii?Q?5qniQEwviQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcb8ad1-4150-4d7b-a392-08da149358d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:27:11.0271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hyQAr2cuc87IevQ4mazUynY6bfAS2ianaALGE04zACvARTAim2wEXYamvi+0rbTknQf01oYsMQIUnwAFfFLfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-GUID: -f52CWXjJKI5LTxqJWTOUbLb_00uBcY2
X-Proofpoint-ORIG-GUID: -f52CWXjJKI5LTxqJWTOUbLb_00uBcY2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 1b223f7065bc7d89c4677c27381817cc95b117a8 upstream

Now that gfs2_file_buffered_write is the only remaining user of
ip->i_gh, we can move the glock holder to the stack (or rather, use the
one we already have on the stack); there is no need for keeping the
holder in the inode anymore.

This is slightly complicated by the fact that we're using ip->i_gh for
the statfs inode in gfs2_file_buffered_write as well.  Writing to the
statfs inode isn't very common, so allocate the statfs holder
dynamically when needed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/file.c   | 34 +++++++++++++++++++++-------------
 fs/gfs2/incore.h |  3 +--
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 59442e35fcf3..0c1b1d259369 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -877,16 +877,25 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return written ? written : ret;
 }
 
-static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
+					struct iov_iter *from,
+					struct gfs2_holder *gh)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_holder *statfs_gh = NULL;
 	ssize_t ret;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
-	ret = gfs2_glock_nq(&ip->i_gh);
+	if (inode == sdp->sd_rindex) {
+		statfs_gh = kmalloc(sizeof(*statfs_gh), GFP_NOFS);
+		if (!statfs_gh)
+			return -ENOMEM;
+	}
+
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, gh);
+	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
 
@@ -894,7 +903,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *fro
 		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 
 		ret = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE,
-					 GL_NOCACHE, &m_ip->i_gh);
+					 GL_NOCACHE, statfs_gh);
 		if (ret)
 			goto out_unlock;
 	}
@@ -905,16 +914,15 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *fro
 	if (ret > 0)
 		iocb->ki_pos += ret;
 
-	if (inode == sdp->sd_rindex) {
-		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
-
-		gfs2_glock_dq_uninit(&m_ip->i_gh);
-	}
+	if (inode == sdp->sd_rindex)
+		gfs2_glock_dq_uninit(statfs_gh);
 
 out_unlock:
-	gfs2_glock_dq(&ip->i_gh);
+	gfs2_glock_dq(gh);
 out_uninit:
-	gfs2_holder_uninit(&ip->i_gh);
+	gfs2_holder_uninit(gh);
+	if (statfs_gh)
+		kfree(statfs_gh);
 	return ret;
 }
 
@@ -969,7 +977,7 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			goto out_unlock;
 
 		iocb->ki_flags |= IOCB_DSYNC;
-		buffered = gfs2_file_buffered_write(iocb, from);
+		buffered = gfs2_file_buffered_write(iocb, from, &gh);
 		if (unlikely(buffered <= 0)) {
 			if (!ret)
 				ret = buffered;
@@ -990,7 +998,7 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (!ret || ret2 > 0)
 			ret += ret2;
 	} else {
-		ret = gfs2_file_buffered_write(iocb, from);
+		ret = gfs2_file_buffered_write(iocb, from, &gh);
 		if (likely(ret > 0))
 			ret = generic_write_sync(iocb, ret);
 	}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 0fe49770166e..3b82fd2e917b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -386,9 +386,8 @@ struct gfs2_inode {
 	u64 i_generation;
 	u64 i_eattr;
 	unsigned long i_flags;		/* GIF_... */
-	struct gfs2_glock *i_gl; /* Move into i_gh? */
+	struct gfs2_glock *i_gl;
 	struct gfs2_holder i_iopen_gh;
-	struct gfs2_holder i_gh; /* for prepare/commit_write only */
 	struct gfs2_qadata *i_qadata; /* quota allocation data */
 	struct gfs2_holder i_rgd_gh;
 	struct gfs2_blkreserv i_res; /* rgrp multi-block reservation */
-- 
2.33.1

