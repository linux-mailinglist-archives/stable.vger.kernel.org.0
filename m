Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE238501E63
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347093AbiDNWc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347127AbiDNWcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:32:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F14C4E33;
        Thu, 14 Apr 2022 15:30:10 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EJKxnV032238;
        Thu, 14 Apr 2022 22:30:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=//lQbjyfxI29D4MI73tnBFtgEjvUoVPymuC7OE/GFAA=;
 b=Xp4HsEylBjzxFFQTLjZ2VAHGHsUBLTCuk2cy5SBzc42uV1NIbv76kFEIIV3/cIY3JyEM
 /IZ4CUykCPCHK/G+7kW2vaojiyjBMAXqZL9QlCC9TeQYCfJmKRTrtMkxH+jpe7HCoS7d
 zYQTyMnxqRWMvi1wdPiZkJ8MftYg+/tHf0GxH0NNfFnCpARr3VPuvFrhm+Ykq0QNsiAD
 HkMr5AHxkbCMh4HfrVcJfTGCEBVEJVLq/Aji5eZNKfyxei+muuP9tmiYxyrdHlEAx7u4
 WTLPclqC/m1r8BJ49AV28+c8+VPwfO76/1bbIwNv1s+c36nzZIomtXjn4AQAOADwM9WL Bw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jddp2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMFpMH006379;
        Thu, 14 Apr 2022 22:30:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k5p4we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIgKGHh3KarQPWF2FS4PVQltbeFyuxbWSrNCFDO/6PBi/Fi4iAb/qUabiMmuYK896TuricnOpVUHEkQ8y3sYnhPJRCdxurRJae6h1p750hZGTGmwZV8ZyfhvLDJe9us6m+lB5io40NoR6MCUYxrWePCRyFbqEnBAdFLARSOhlPDoGnXZGmEWCuJBMVl1KrlhYCKIJvi+4MICp5v/93GATXQpDkpbN7afGtaCJ1DDfS6BMpJFL5nI0mDXOmgEZvjD/YIrM+3A72jNYjmJBIOT7/aDu16KB2Ijo5CBWW+FXYy1//8H1Xdk0mOVeStxPoUPct92yKl7r5jjt4fTTv38zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//lQbjyfxI29D4MI73tnBFtgEjvUoVPymuC7OE/GFAA=;
 b=PffcBZPegVxXdJzAWRTY4Y/qtAkyRFXitOHHD9bIES4VwXZjrUXpCQbNIlt9U59j5u9EVoViYyTewTiyzO0DcR8Oh//x6vOaGARYjxLF/j6MTYcaVaJ4usspDDCOEOc8oqJ1gCPLrgnSQITC/LtMIpkxElZd2COIveiFstNdi6Q7uZgYGjuVhUkWtTCKRMHx1oEDJzE2L7lsaTrksek5073KZoLhtvS0ZQtHS3uehXZrdNM9RdGXdD62KUcDgxuW66+vxLZxJ94VsGMsfSy5gkxmemt4rwV/++XRnML+zokoa2SxuWtSWJA1JgB+rV2bAcvr0pfgqUmsOPqALy/ysg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//lQbjyfxI29D4MI73tnBFtgEjvUoVPymuC7OE/GFAA=;
 b=WWuoIfrBGs4981imloidEgXICTgkMHMQ6krXrxdwvPFucwxH4cAFbFaqzJ87PBXvL34jvW/xoVPWJJnQKHo+bQLSKafX1zHrUknZN96uqZMX6cVxp4/If8Q2CcZmxV2iU/T3r+uEGvO4ZGW0VBt1WOlSIFZOoCGEZq2i25NwDTs=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MWHPR1001MB2094.namprd10.prod.outlook.com (2603:10b6:301:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:30:05 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:30:05 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 09/18 stable-5.15.y] gfs2: Fix mmap + page fault deadlocks for buffered I/O
Date:   Fri, 15 Apr 2022 06:28:47 +0800
Message-Id: <087a752bc8848ad8814bee4648d8b9d855c8438c.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::25)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1d607b0-949e-4329-ebe6-08da1e6652da
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2094A92F60ED6F86231CE12AE5EF9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vLXrb/4D+GtttL4ClOQXMWGSuaYpYKSnpqR/uFfEc1b9XpOxquOpiJG3WbfJbObtylTVNeJUECLWsh49mvnAOeiFZAD9x2U5oWpgq1OGU3NyrXSUWyOCrXL9NiY1ToO8j976bNJzn/uvvRm5g7LbGbVlsTQce/2UAXkaRAmLVizPAM9kdDF3K7Jqc57cVww9c3aTvmCRM37LC7+ETqhS8rYTsfui+CBZK/LRFSEwlOap87hAb7jVYMpuMxZ38vp1GgazEQkIiPbr4hp3xUHvE/BAn9dmUsjdvsIFb0WWtHa6G71yzlrlGrUh/K60j6KuoYMMyvpxQeKcfXevsafwIcnpwf8agIxlFkf5sQDc3abjwg4yENSCqny/3G4ICL0zqV0W4YXqcLzL5v5ya9QIunK26oRzZM0QnVeSLAx/o95g7W0Hf6I39FCsoz5Pc3Ifa15nyFly3ow+AUoLWgrM8MtWjzxk+3RBd3O8LQARLXOKi1V1cEGef7nLRY3snmuUX0J1liAhuXD8Vj72fu5fpXCz8pVinDWUWF5ac42uTvzZrj/Xeg7Z+dAM1e2XqCFvS0CpkondJ9M2VL28IyoLS36jitWIFH9mMlX+RTIM8Q+jGUV10GN6wBNhzqd/Xs4jTvZW54IL1VJclG2ZuhUXiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(2906002)(86362001)(44832011)(508600001)(6666004)(6506007)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(6916009)(66476007)(83380400001)(66946007)(66556008)(4326008)(38100700002)(2616005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dOANZ2P65sT4xm3CPgZhASTMGT9R+T6w9K6p58MtKQaLOCdGnSCSdE/Fbl2D?=
 =?us-ascii?Q?v2LB3qu7ZV7FfgUkrwVn+RLaR9u0JfgiZGfgVrl6vXyTsYhE5MJBpD5od5W7?=
 =?us-ascii?Q?7z83W0RyPe5SOeNx76VFt7vS8GLlkr5wfZbCHDxnaeINweU8OjOUlpwnlMbU?=
 =?us-ascii?Q?O91AR2kauQDqiPtgqEn4onmlXUEyPvmIc64csDBRjmZBdi4oJP3+1jjQt+45?=
 =?us-ascii?Q?vtzlebD2ws43QIc79KWWSnMndLo4c2c4r3nLSCqkL1rrJkp7FVTKl4z2xEfP?=
 =?us-ascii?Q?PRQ2OLKrgnC47XQd8zvV4qQ6d87isIDmxgYCuWo+tem6tTuX3/jA+I4CssN6?=
 =?us-ascii?Q?q2cegZHNo7GFvbAVZH4REjLVxHrMDOTdiqY50vF3fl/VBihQQuGZoQ3jNBCm?=
 =?us-ascii?Q?0UepbsD4Efwtn8ZNFx7ofRim6FIz4hTmrNbKEIkqKz7GamJfETTcSwntIO/s?=
 =?us-ascii?Q?xZK6m8+yZLM0ZTkYLcCoSXrN31ZTJdn2H/UyiCd1/4SivFFLBLQYZVMspUbY?=
 =?us-ascii?Q?LsQuwO+RjnFLfgd8kxkoSuKarIVBblKm8DBXFcGXkzfx1HXD9VYUSqUX17Uw?=
 =?us-ascii?Q?0cLcArnqZKCOCzveo2JJG18M938s0bSNKV3MuESmfFdyv/f9RfckLyy3LVEz?=
 =?us-ascii?Q?WRWRYcWxKmbi+JyIKSjXh2NqLrW5G9xG/hKAbpDOMoaikysACIGMb/6gcFlo?=
 =?us-ascii?Q?iNYXXoPCrZX0/DZmDGDbhUhvJz6A33X5NHq0lgYBG008HljyjUulCgz8g7Gm?=
 =?us-ascii?Q?ly9lpJEaB5PhyVvD2lS+1UuuSXu53k8k8VJlS/tq2LJq7FWi5mq3NhCyaHob?=
 =?us-ascii?Q?jbwW3zHGf6d0P2Z1LhiIMPUKoZF3KWHcNcyDIm7rTSkyl5fYwnc+F5efTbmy?=
 =?us-ascii?Q?jOKsv/8p2TxZRlnWMWKy/D5YGjY6rvfgno+jOElJWoNBPiG6UrQdMxrHYcwz?=
 =?us-ascii?Q?6V0mjOUmrZMC6kzf9Q+sjxntiJccbfy0CToHB8o5fF567Lo3FeRdybA3ZM5a?=
 =?us-ascii?Q?w5YoEJ9ebwf/HmSbDYtvVTBB2Z974LFWiamqmNHe2UDEZWFO14UIvPQQn5tb?=
 =?us-ascii?Q?U9BNPjjsqDGcdGWcZoIIMoo6VpBvDYxnPIs3CYZw1UvwDLHQUrIq+/rDFs+K?=
 =?us-ascii?Q?lHAy/oJe3DYc43+RfWdS63oo37wKZBLUy3YBl0c2pEun2O1oeS6iaJtbuaG6?=
 =?us-ascii?Q?5lxWFhKZxBIr24rbuHIDAXoiPuQtmvnSDVgh4FKjRrogsPhuAfeSDRoSe0vs?=
 =?us-ascii?Q?/HpLj4LzfOReKGFuJlwL3o4wdp0bTKafgF79zNPW3nBEW9tfSZydqeIFtcZ7?=
 =?us-ascii?Q?wb6gb3aQaBY6jHktSGUpkRWvNFfyO1nSgYZpexf4WXh8Lz66d/sh4qk5Qj/u?=
 =?us-ascii?Q?fERtzAoGuWNDHey37SOjU+xowPM90nUgkZUxAcyrrkic4iVeO9x8vngN2WFf?=
 =?us-ascii?Q?NgaeSP7lZRnfLkw5ZJvYYwkiZ9j7hwaenzSmrtKKyHbzuUP+LRLo130cbK8D?=
 =?us-ascii?Q?liHVwxoCj0h6dWc1SgROeLYTXheP0Do8kUhIewH4F6v5ahnnCga5VviWtBHD?=
 =?us-ascii?Q?R1WK70znc0wOt8IJdlCZJyrvUKWIOZMOog1CBf40HOxv+p8ofhrMKzP5sr6t?=
 =?us-ascii?Q?SxC0ZsHQ2l2PrSZEO+4SBwmi3GbfxVu0/d2/RM1EcWnD2NvscDDil94pk1lW?=
 =?us-ascii?Q?eq4QNfUAe/hr/rxmTgcNVDfOFPlCWl2A6Oyn0feIAshR6gnSqLZcyc+xvJWJ?=
 =?us-ascii?Q?QzfHYpw6qmwdUZK3of55xzLRswFT4Ss5a/a5ONfwt01xV/mQcMxP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d607b0-949e-4329-ebe6-08da1e6652da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:30:05.4265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmRBup4gag/O2uQ0HZYinyvTVHAMpDSO1oF+GOpvgSCTS8fq2Ezx+EQmrSHgLQc+VoyXHCu4SRRYZ2F/U+avwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: II3naCtbDWodFyu9mKbsJvi18qRz6toP
X-Proofpoint-GUID: II3naCtbDWodFyu9mKbsJvi18qRz6toP
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

commit 00bfe02f479688a67a29019d1228f1470e26f014 upstream

In the .read_iter and .write_iter file operations, we're accessing
user-space memory while holding the inode glock.  There is a possibility
that the memory is mapped to the same file, in which case we'd recurse
on the same glock.

We could detect and work around this simple case of recursive locking,
but more complex scenarios exist that involve multiple glocks,
processes, and cluster nodes, and working around all of those cases
isn't practical or even possible.

Avoid these kinds of problems by disabling page faults while holding the
inode glock.  If a page fault would occur, we either end up with a
partial read or write or with -EFAULT if nothing could be read or
written.  In either case, we know that we're not done with the
operation, so we indicate that we're willing to give up the inode glock
and then we fault in the missing pages.  If that made us lose the inode
glock, we return a partial read or write.  Otherwise, we resume the
operation.

This locking problem was originally reported by Jan Kara.  Linus came up
with the idea of disabling page faults.  Many thanks to Al Viro and
Matthew Wilcox for their feedback.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/file.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 94 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 288a789cb54b..2d0aa55205ed 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -777,6 +777,36 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 	return ret ? ret : ret1;
 }
 
+static inline bool should_fault_in_pages(ssize_t ret, struct iov_iter *i,
+					 size_t *prev_count,
+					 size_t *window_size)
+{
+	char __user *p = i->iov[0].iov_base + i->iov_offset;
+	size_t count = iov_iter_count(i);
+	int pages = 1;
+
+	if (likely(!count))
+		return false;
+	if (ret <= 0 && ret != -EFAULT)
+		return false;
+	if (!iter_is_iovec(i))
+		return false;
+
+	if (*prev_count != count || !*window_size) {
+		int pages, nr_dirtied;
+
+		pages = min_t(int, BIO_MAX_VECS,
+			      DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE));
+		nr_dirtied = max(current->nr_dirtied_pause -
+				 current->nr_dirtied, 1);
+		pages = min(pages, nr_dirtied);
+	}
+
+	*prev_count = count;
+	*window_size = (size_t)PAGE_SIZE * pages - offset_in_page(p);
+	return true;
+}
+
 static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 				     struct gfs2_holder *gh)
 {
@@ -841,9 +871,17 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct gfs2_inode *ip;
 	struct gfs2_holder gh;
+	size_t prev_count = 0, window_size = 0;
 	size_t written = 0;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 */
+
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = gfs2_file_direct_read(iocb, to, &gh);
 		if (likely(ret != -ENOTBLK))
@@ -865,13 +903,34 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	}
 	ip = GFS2_I(iocb->ki_filp->f_mapping->host);
 	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+retry:
 	ret = gfs2_glock_nq(&gh);
 	if (ret)
 		goto out_uninit;
+retry_under_glock:
+	pagefault_disable();
 	ret = generic_file_read_iter(iocb, to);
+	pagefault_enable();
 	if (ret > 0)
 		written += ret;
-	gfs2_glock_dq(&gh);
+
+	if (should_fault_in_pages(ret, to, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(&gh);
+		leftover = fault_in_iov_iter_writeable(to, window_size);
+		gfs2_holder_disallow_demote(&gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(&gh)) {
+				if (written)
+					goto out_uninit;
+				goto retry;
+			}
+			goto retry_under_glock;
+		}
+	}
+	if (gfs2_holder_queued(&gh))
+		gfs2_glock_dq(&gh);
 out_uninit:
 	gfs2_holder_uninit(&gh);
 	return written ? written : ret;
@@ -886,8 +945,17 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_holder *statfs_gh = NULL;
+	size_t prev_count = 0, window_size = 0;
+	size_t read = 0;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 */
+
 	if (inode == sdp->sd_rindex) {
 		statfs_gh = kmalloc(sizeof(*statfs_gh), GFP_NOFS);
 		if (!statfs_gh)
@@ -895,10 +963,11 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	}
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
-
+retry_under_glock:
 	if (inode == sdp->sd_rindex) {
 		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 
@@ -909,21 +978,41 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	}
 
 	current->backing_dev_info = inode_to_bdi(inode);
+	pagefault_disable();
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+	pagefault_enable();
 	current->backing_dev_info = NULL;
-	if (ret > 0)
+	if (ret > 0) {
 		iocb->ki_pos += ret;
+		read += ret;
+	}
 
 	if (inode == sdp->sd_rindex)
 		gfs2_glock_dq_uninit(statfs_gh);
 
+	if (should_fault_in_pages(ret, from, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(gh);
+		leftover = fault_in_iov_iter_readable(from, window_size);
+		gfs2_holder_disallow_demote(gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(gh)) {
+				if (read)
+					goto out_uninit;
+				goto retry;
+			}
+			goto retry_under_glock;
+		}
+	}
 out_unlock:
-	gfs2_glock_dq(gh);
+	if (gfs2_holder_queued(gh))
+		gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
 	if (statfs_gh)
 		kfree(statfs_gh);
-	return ret;
+	return read ? read : ret;
 }
 
 /**
-- 
2.33.1

