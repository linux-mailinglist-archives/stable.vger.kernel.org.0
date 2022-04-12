Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405544FCEB0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347755AbiDLFSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347740AbiDLFSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:18:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FA7344F7;
        Mon, 11 Apr 2022 22:15:50 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C1kKna012649;
        Tue, 12 Apr 2022 05:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=VXhvYgHCI8teKTC0JpwFjQ0ZxEBrqYZP/5krj2OwKvc=;
 b=giDg+RMPuS/ErXlEaMA3KKSqvvaOBq0QWwtBZIOMMOghDOHxXIgCEtdFYA1Txw8uKQ8v
 xeN4yhoPpfh4/grosjZF5snfF27APnIAGyK0JUxr87uuxV/mgCSjbjUYw5pWQqEpNqvx
 SirHNDhFDxyHf4R230+uvzuFCG/5F4falW35sgbd8/jJ56JFSTyFcSs74ZvWomJigAsd
 hhHK/EDmZTYLvZwlFrBXiSkkIKmgN90O8Zh/lttrTdo/AcV6ncwvkYGW9PBciuhQCQ9j
 LOSECz1oXUad8ofuRzcQdGqv3Z3CJl+m2eKzUDwqmzPvyWrPqibsedvSHUZ05J7mTXbJ nA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptwnr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:15:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5BPwm006188;
        Tue, 12 Apr 2022 05:15:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k2ckgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:15:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoSY+b9MTaWQL6UjfhRlxAx7GdvT9QhaY7pqQrHE6edkTh5jeLOxONq5XoMw98jvWU0TTw8chv9M29SqSOPVc3+qqJBnn2cRJtXQ8AwpQdyK6v855DoVZX2mIQsNGxKiJu7ZaIQTZGIQwryy2+C6oCo/gSmzTfQ7zfn4x15x8d10zoqjGZSQMguSU0jCgSsauhS0oiNZEwrG1Qo32BeGbntwqxEaB7Cc7Z0nYE8cpAqLCsyPK1gtcVjIdlH60n2y6SZkvACXLU/WNIGEcepxKV7WNtWcwP+NIXG2P06vFPHDmaQccmDtN6JkB8TanTtUP3ljWHSetO/yz1KxER4Tzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXhvYgHCI8teKTC0JpwFjQ0ZxEBrqYZP/5krj2OwKvc=;
 b=a2PIrr6A6B+PqRxONfW4nrJbhFqjYNzWivNsZAm8c6M4ckGNLA+bxZ8l8+SoL411vlUrfpyoVMH4xFbPYqNaoBxcU6VaWpesxUeQeGLgwLz4NjArFy8/HV5o849bkq1sYHxXQaTlT8uEAA/Tt0USWextj1O11F+McgZi3eFdzp9IgpcwUhFuL8Iz7eLhpCDBn9wfwTqqWD92u/bX9DQ/6uX2+FOpR9DEsA2rESZYSqgkMoV8H/zmQ/DEnJYNuaQLOF0bv7wcmYtomO/x/253IjeLm9K3eBwIhH1MXAB6GZrxf85rfU4NdKCFGxrWzNFYzPf7Z3TsS9nZIRls0sXmHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXhvYgHCI8teKTC0JpwFjQ0ZxEBrqYZP/5krj2OwKvc=;
 b=QFNml5ONU6u2qICHaLrRp174YsSTEJifAJXZpGC+Kn5X5Tyq4l+vvtiRbU4ikD8CxsnKou9tkh09+GQUpzoqWsfqy2J5d4B9aa3K/elJf/TaZyBiVOPJUV+PJIfWrnDrHiUluKijXp9YPaxtWeBvTOnWQg6EuNqXsndGTDKRTYQ=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:15:44 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:15:44 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 02/18 stable-5.15.y] iov_iter: Turn iov_iter_fault_in_readable into fault_in_iov_iter_readable
Date:   Tue, 12 Apr 2022 13:14:59 +0800
Message-Id: <a7cf1134ead5c32eb451e52e40d2eb4a17862b96.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::33)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0089201-e1fc-4189-9381-08da1c437ef6
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3329E4710AE346419A256439E5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6//ElLfBI3AhwByAGF4o4sHwP8q+AlaGNJIIk6STeg1v5wNuYPSkjt7hMdnX40NOnXlRh8x3VHad5kDug7YtQNQ+MLyufpcUUwBqkZ+czkTyEir6T0nDS/15k10BwoNYZ68l2KtaEiZkoVRkjPz2Wu2MFiQoJZhF9ODV0TQGrDJmmeTnwuhcftLJjd1W01Gac38ysPDRjc09lHXM3sFJBXN1YhdnIeeal/bXcl7G6KwJ+uVYQhwzcEDbRz4CVS1IGnn1bb97Els/fnVDUEKrDtAiX9+0YkpCgCh5P2ShWmQiZuD/wRCT96xGFF0z7H2Qq6NoNuHDV63ZOTytDKps1YSThiVkp0EDcu+olzUiYWkTJ7x9/QdgcbB0PK+BCqzS9JM/Zubkevqf5MMWWgIHELVZMHy1pJLdfhl0o7paa/dxJgw/GW2bpQHN8yV8OwjFyEjEQWhWjb+dIErGB1y/NrtdpqYua5HJAiQ6qzdZh090SB5XoCOJOd+9A2kN82iDuFEJgvcIYL36FO9T1iR9Z+agsy18frB6J31SIPfEaMKHygKvFzD+6XCqUP2zKQHGpO5ZqWmmfrYnudWffR84wjTZ3RzZf21SRpqAcwkiQ5C9E5VdPT4yz8q6bBcaaEYcOWiSNLzhGJiCtQwTbqWRJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JzLxzn9hBfqeuVP/7/PXzX9pdqsFytgF1kYFbzC/imEytIlisHLcbxKKVlJg?=
 =?us-ascii?Q?WifCzAEyvbZZZi8cIsF5wu4VbDc46q2S407JY/bTqUhxTch8hK2vkmgtBpVl?=
 =?us-ascii?Q?8VJjRACkVeZjek0vxCh50os5cqSgWq7bg8kPzyF3wmfYNK0Y7VBRwW9HC0Wf?=
 =?us-ascii?Q?6ORWuNj1SV2fyIdl+b6c+JDv1BW7uZWy0W3pLisLC+MdIq+Y3Nbu+MgmQD5R?=
 =?us-ascii?Q?2wx3kLbK/zbRscZJb0Gg3UNjHdRcbs4apsScXwHpNH5b0glfEezOHnOG+a2w?=
 =?us-ascii?Q?nTAUAFxbUNB4+0ZS3Z/xUmndeu7am3F6tkQheMBXewgTCu2AD1wzOMGM1ul8?=
 =?us-ascii?Q?VVb+i+iW7dhC04Bn6ALVbJrpLMThsz7A1b9PvV3xZNCE7srgzOTxsDLvf11j?=
 =?us-ascii?Q?bIz5RWAsx95O95+sldI7VPXmWZ1drrvxvzLlOVO4j9VeMmJAfPPh9nFVED/c?=
 =?us-ascii?Q?EAHeuRsD6I+Idgenjg4yKXc/BbQM3QRKAlwzOlc4b/HB63ucW0au9DVRUNEm?=
 =?us-ascii?Q?CMtKLlOXsrm69/9PoOwfjjb5tzxCVCkd0wO9lhAZDwk6U1UPMzl7c7QeZkah?=
 =?us-ascii?Q?K4eNYzBHpblXej0HqE/hjDFg02BEuf9IkDgb0TXy05TzdGPMJ91+63UJoRE8?=
 =?us-ascii?Q?O1MMcn+fzAz1lfdonbuWKFpHpEBiPpyB+ad2kARAmIXBsVzS5o+7nhF1PZNU?=
 =?us-ascii?Q?kmIJ+3YIIyuUDgxw1HMOwK1e1JNBTXv+erbA9Y27Ly1kafybzZx9399hbxmJ?=
 =?us-ascii?Q?kThMURmoaOaZvOl6FAQnWB5EQAWCHWlPTeyHPr4Fol2Hz6qVOhK1BYF0rBin?=
 =?us-ascii?Q?AUvJvwRTuDgfhk4LEB7M9J6s30SoqtRjWFCtjpcIqgYHiUlTF47iZFv8l11l?=
 =?us-ascii?Q?njjex7oIOUsaM7sfEX0ukLargaIX4HhWVaBMoFjJ/+ihvM4eeo+2No98FAQl?=
 =?us-ascii?Q?0ABF4N5/YzHNiy2R6Jez6Bll3fe0rwoLlCfhuZLoVx4kBuIQPO5nyXRThBOX?=
 =?us-ascii?Q?3LRbDxoSl5m1JhQwtUkv1Aayxn6A+0uichP4MacwTKJ1tEZ0s2fXfnzud0v/?=
 =?us-ascii?Q?GuUESEuGAe33x6RieWNvCOFiKbx1XgDn1QAO5ifAHJ+GmSo/hDmFaG8rAttn?=
 =?us-ascii?Q?usobXTCGrGyCSRTea2KfRmc3hE2oNTCCwTvQ6qf5Le4bMKwM6ofap3pRMRNp?=
 =?us-ascii?Q?gTL3ONb5Jr18kldPfiPCKKu3/Ke/l+T0z14H17hovMObYEEhv88S5IBXIHvh?=
 =?us-ascii?Q?nyxqXT+zmTiUekGs1DoiTbXdwM9XoVrQX4aZ4KoybYxK0HedTMnxrfptnNwH?=
 =?us-ascii?Q?RbQeMlkv7xt0tbcE7pZ7MundvmKB5JNya5kT+MAaa0X/5rscyRtHPYWpTM+G?=
 =?us-ascii?Q?KrwYz1Y/hvzsc43S4X+mNcZK9Kttc/+hTnyERvmLbGSX9IPFT+j03ZM05cvT?=
 =?us-ascii?Q?d/TeoqpaHyrBi4Ams6WFEtOpFlltODh3SLbI61dEyJfTCfxEeI/7/Y7QXxHW?=
 =?us-ascii?Q?iMcXCpZi/Sf+UsMk1fLbgsu5DRXIyRFk+TFY6g4MyuxAd1loU/+rIu66E8M7?=
 =?us-ascii?Q?9FEVBzM0H7Fh0jfEaAAYk2HA+SGafnpTOuyEv8EHXPjrqnhK6cO33dquHDqT?=
 =?us-ascii?Q?kjQiiTBNyT0cvCUc2LuIfkl7O89XTRPI5lBewMQEsoM7AkgTC14h9jX1mTDF?=
 =?us-ascii?Q?AifyvHkxf5BiMWab+JgNsK2QxowxZToWU3pN0237WZJnRCvU3klw4p65BCh6?=
 =?us-ascii?Q?CVVOj4GG+K7r/chZhBm6DG5X+B+QJKWpg3eFBtE6KMInvUpX4K6x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0089201-e1fc-4189-9381-08da1c437ef6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:15:44.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9DDJ0Mj5gN5Lp2o7dkmhFNnu6pLdF/Bf+XnlvesTx045AaQ1o6TOAaDVaPeM3GmHprFPxT0sEedhG2frw0qlGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120023
X-Proofpoint-ORIG-GUID: pYULXEPjGLpGRS3JVPWKYMyZuhl1Ih2Q
X-Proofpoint-GUID: pYULXEPjGLpGRS3JVPWKYMyZuhl1Ih2Q
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

commit a6294593e8a1290091d0b078d5d33da5e0cd3dfe upstream

Turn iov_iter_fault_in_readable into a function that returns the number
of bytes not faulted in, similar to copy_to_user, instead of returning a
non-zero value when any of the requested pages couldn't be faulted in.
This supports the existing users that require all pages to be faulted in
as well as new users that are happy if any pages can be faulted in.

Rename iov_iter_fault_in_readable to fault_in_iov_iter_readable to make
sure this change doesn't silently break things.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/file.c        |  2 +-
 fs/f2fs/file.c         |  2 +-
 fs/fuse/file.c         |  2 +-
 fs/iomap/buffered-io.c |  2 +-
 fs/ntfs/file.c         |  2 +-
 fs/ntfs3/file.c        |  2 +-
 include/linux/uio.h    |  2 +-
 lib/iov_iter.c         | 33 +++++++++++++++++++++------------
 mm/filemap.c           |  2 +-
 9 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a1762363f61f..5bf4304366e9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1709,7 +1709,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		 * Fault pages before locking them in prepare_pages
 		 * to avoid recursive lock
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, write_bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, write_bytes))) {
 			ret = -EFAULT;
 			break;
 		}
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0e14dc41ed4e..8ef92719c679 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4279,7 +4279,7 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		size_t target_size = 0;
 		int err;
 
-		if (iov_iter_fault_in_readable(from, iov_iter_count(from)))
+		if (fault_in_iov_iter_readable(from, iov_iter_count(from)))
 			set_inode_flag(inode, FI_NO_PREALLOC);
 
 		if ((iocb->ki_flags & IOCB_NOWAIT)) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bc50a9fa84a0..71e9e301e569 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1164,7 +1164,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 
  again:
 		err = -EFAULT;
-		if (iov_iter_fault_in_readable(ii, bytes))
+		if (fault_in_iov_iter_readable(ii, bytes))
 			break;
 
 		err = -ENOMEM;
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 97119ec3b850..fe10d8a30f6b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -757,7 +757,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
 			status = -EFAULT;
 			break;
 		}
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index ab4f3362466d..a43adeacd930 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1829,7 +1829,7 @@ static ssize_t ntfs_perform_write(struct file *file, struct iov_iter *i,
 		 * pages being swapped out between us bringing them into memory
 		 * and doing the actual copying.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
 			status = -EFAULT;
 			break;
 		}
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 43b1451bff53..54b9599640ef 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -989,7 +989,7 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 		frame_vbo = pos & ~(frame_size - 1);
 		index = frame_vbo >> PAGE_SHIFT;
 
-		if (unlikely(iov_iter_fault_in_readable(from, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(from, bytes))) {
 			err = -EFAULT;
 			goto out;
 		}
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 207101a9c5c3..d18458af6681 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -133,7 +133,7 @@ size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
 				  size_t bytes, struct iov_iter *i);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
-int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes);
+size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
 size_t iov_iter_single_seg_count(const struct iov_iter *i);
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 2e07a4b083ed..b8de180420c7 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -431,33 +431,42 @@ static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t by
 }
 
 /*
+ * fault_in_iov_iter_readable - fault in iov iterator for reading
+ * @i: iterator
+ * @size: maximum length
+ *
  * Fault in one or more iovecs of the given iov_iter, to a maximum length of
- * bytes.  For each iovec, fault in each page that constitutes the iovec.
+ * @size.  For each iovec, fault in each page that constitutes the iovec.
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
  *
- * Return 0 on success, or non-zero if the memory could not be accessed (i.e.
- * because it is an invalid address).
+ * Always returns 0 for non-userspace iterators.
  */
-int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
+size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t size)
 {
 	if (iter_is_iovec(i)) {
+		size_t count = min(size, iov_iter_count(i));
 		const struct iovec *p;
 		size_t skip;
 
-		if (bytes > i->count)
-			bytes = i->count;
-		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
-			size_t len = min(bytes, p->iov_len - skip);
+		size -= count;
+		for (p = i->iov, skip = i->iov_offset; count; p++, skip = 0) {
+			size_t len = min(count, p->iov_len - skip);
+			size_t ret;
 
 			if (unlikely(!len))
 				continue;
-			if (fault_in_readable(p->iov_base + skip, len))
-				return -EFAULT;
-			bytes -= len;
+			ret = fault_in_readable(p->iov_base + skip, len);
+			count -= len - ret;
+			if (ret)
+				break;
 		}
+		return count + size;
 	}
 	return 0;
 }
-EXPORT_SYMBOL(iov_iter_fault_in_readable);
+EXPORT_SYMBOL(fault_in_iov_iter_readable);
 
 void iov_iter_init(struct iov_iter *i, unsigned int direction,
 			const struct iovec *iov, unsigned long nr_segs,
diff --git a/mm/filemap.c b/mm/filemap.c
index d697b3446a4a..00e391e75880 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3760,7 +3760,7 @@ ssize_t generic_perform_write(struct file *file,
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
 			status = -EFAULT;
 			break;
 		}
-- 
2.33.1

