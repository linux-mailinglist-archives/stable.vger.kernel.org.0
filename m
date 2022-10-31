Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958AB612F8B
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 05:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJaEyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 00:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaEyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 00:54:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8364110BF;
        Sun, 30 Oct 2022 21:54:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29V3ctts010832;
        Mon, 31 Oct 2022 04:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=weVjZylMG/hqa3+lkBTpUYFMILggk7Jhd55ec0xhuuQ=;
 b=D2Am2BOVa409b0sLIa0Fb/2rwUUTud6W6H+nwtYjwdZFO98T2B9ZQ17MYnhzGUZVTIYr
 AN6+WjuFDnu4E97GgNwsJL7DJ83fJDTIam5EHsgOh2hz/U41iiCxI3tpzInOLm28N84c
 EZ6+dNYCyMU7VClI72Yf9w/yTN6JnZiaiXolFwxN6Ni9JOn9zQyvfj31CPdX03hb3ttF
 MMIYFLlkzQlnXxTadaYRa0YNWtyIeCkkLQOA4FcHgbfD3Llw2RCQIRD9sAv4/m7bfHEi
 6lWfI4lBJgaeVhtcEkuQ7tyEEZfEAsJf59M6Ht7HOcVIDSw1vR+4pD+uBrC+OBFE4qDt +w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgussjcnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 04:54:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29V2Qm3N019586;
        Mon, 31 Oct 2022 04:54:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm8v34f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 04:54:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpuqd4ESOZmtzRndU3rHoDruyo8TJjc+YfA/z8D1eNqiPgZSOTvbu6G3goujOnB1kVqzLpZmmNtWwqhtau58+LFFaxdvla/W2ZSlonEggrlK579DlOu3uCPvuJriMLEDpF1WRGHVKb6mKvLB5S22Ae8dgLqlyhiqXA8aTNab7gVtoipj0mjVWt1XP6ZGzjjSxFefmW766MS0Wd0GR6tCqj275lPkwoniScMCjHBEXUsxi0sces6BOkPK8s5izJtAEh4q7LqwtAjRnDvtFHCnDoKfMNG/xFbpIQWgogv2Rysvzu1IhkRNgooxDsPbiGwYZIT8o07xLN3qRfIhUgjl3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weVjZylMG/hqa3+lkBTpUYFMILggk7Jhd55ec0xhuuQ=;
 b=HAlLmBWAa2e+vrXdM7MeDabK2v5QZ260vD18D92aGAo7vesEjCBbV53bdEAthdXob7LEcmOtqOKLs9N8cfNwUol9XZ0O+S2BgXJNGeDDRneH6NmCBx0S6H0irWzNdKE/WZBRDFgUjkFW6955j87iK75+pOO03BvGVZJe1nhlmOa5RRBW702eMFxpc7C7LsMKidFarUbOWzZ5lzTHX8HK5HyGBSwWs3Ai6+Pisi36OppvJVN88u3xAQIWBI++ygsUj9ufZE77s3mUlMc79k9i0df2442Jn4zQLjVhfX7iH0MQd2s2KVbPkZZAuohAr5hWRuuOW8lD04yzNTYN9WKvfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weVjZylMG/hqa3+lkBTpUYFMILggk7Jhd55ec0xhuuQ=;
 b=pPGZmT2Nlcpy9qL4CigRvpASKV4ob9rbbGxn1hcG4N/xXqZ3R9d5tRdDSP0dUz2+Ut3eX5/G67FDfgitF+wXqOw7uXQKRj5gBJ5SH5PWhGjHc9Fz9eSER6Hfp1t1++ogrTBGBL5LKb3O7lGxrXBX6+9UadcWxaB4yv1kmFgBBuw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5976.namprd10.prod.outlook.com (2603:10b6:8:9c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Mon, 31 Oct 2022 04:54:21 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 04:54:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 3/3] xfs: force the log after remapping a synchronous-writes file
Date:   Mon, 31 Oct 2022 10:23:54 +0530
Message-Id: <20221031045354.183020-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221031045354.183020-1-chandan.babu@oracle.com>
References: <20221031045354.183020-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:54::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: 78268afb-5141-492a-67fc-08dabafbf943
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ma2NtJDWopFjWVAAe5MHrMchlvjPRo7whDehU5IoJH+aIr6UQ9Pc+jDawe7jk6S/BndoViKgeKe4G5Byc6r0AsVghJ45bagiwWFke5VkHl16aDLBbIlkoQw0SmWr4/sjzmdQq1qZ2YlcYjQP/b1ZVuaMzIl53ci/4/R5tI9TFuxKzQDjfWp0o/AIMFt5/3Koe83w6oFKusoz03fzxbMPhplnme71JNVH990e8o8Dalhv5AU2kIqB8uVhkvpFZH3OH7P8IbK9FpChS2KNYeAHTM9GzR99bqduo49S7OhvvOkbkgM2Z3DXcMja4RKcdeDJNeG973tQRKg7QEXXDDku3zs0xvT+7uV+Ct51+dj1H6nNgy/KJOUunia6HzSSSeT6Vmgb1qa761WgkDCnWxhORIGtjxGk9y60G6FVU5KL/qw9iQq30Uh23jKZ2y8+ujq4injIbLEEncnt4YZUkv3p+LsNN7T9jo16Y3qGnafVeEDz2mdFKsRSQhDNJxvADHpixPR3Mw4bard/aKpxjAMT5pyvaBQZmSMAqKSeRhC3AG6/zIokUv0OaEVHapI0iyW8B6oVY/vjt3kO320VcJUpjQihP3eWPMIpw06nPjswERlVV6UahSGC2BBwzsF4C0mcAtACXQkEsb7u7K8McCEFb8+BVHLj5qWS8ZbcL2qLL7DegejNuFGxihbGTD5U1WDmy/uKvYQYWoJRvSzCcPOYyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(396003)(346002)(39860400002)(451199015)(83380400001)(86362001)(6666004)(6486002)(2906002)(38100700002)(36756003)(6512007)(26005)(1076003)(2616005)(186003)(66946007)(316002)(66476007)(66556008)(8676002)(4326008)(478600001)(6506007)(41300700001)(5660300002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6rYURRdEtYs66BjmQzUOoMYAImUagafEdkp4MYJozUiPmDh3wTEAHMYYOPwn?=
 =?us-ascii?Q?BJqtdOCFW6VWKLB8jr/mb/WigWuyVRAO5AJgkYmzoyXfvwGDHN/+cyPxD0oq?=
 =?us-ascii?Q?akT1F4qGiE9wcPYbXL00x4dg2ErIekYx0BQhQkA5KdbkVJrebkMSo7uwxNpo?=
 =?us-ascii?Q?1WD79bqHUcp3ec99dsWn0vmd2Kv9p4Q4NNLNuq14hD5RpY9GqyvxFtzHac1D?=
 =?us-ascii?Q?VxrV0TsjqYFWCYR92IAzQJvjy+sKQIywR0Eilv5ZfI2oJQS7Ab1hEinqa22k?=
 =?us-ascii?Q?HHsJl+4HgfBVjuMVwBKzQt0Vf522gruHycN7zIiRa/LXxEYOI2iWqSKf8IgK?=
 =?us-ascii?Q?x45tJjFpZSfmYf31IK8COGn8IwqxSNdcN9qyay0LziGnhjTsmO9ffQ5xIDZD?=
 =?us-ascii?Q?sH2u0YE+xBUAssGloilYubLXiZ7VdH3WMGjfYYML0mu3bkpzElLjcInzIS7z?=
 =?us-ascii?Q?nZasFXnVdJegcqc42z9W1rAryCjrswPqZlv+bCR7vhRhnSQzPAuKXmfAtC5d?=
 =?us-ascii?Q?6XDlJ7F4mF0pesYdfGvz3goxRmkKBfIGIw43Ji4MHIAYNCEwdO6h1MpRNmvp?=
 =?us-ascii?Q?Bf8dIcb/jD1UTPU1LJvz4+h+6OxpruzMcQVT4CP72OoKY50ILQTHwFcifW5/?=
 =?us-ascii?Q?zWmafssXcKI7x5LoCknOfxxbi6zZEt/obja/1xkQhYVPzAPIsyXY72+js2x2?=
 =?us-ascii?Q?NU/45mP41g6/QQKaOCEvB/DNAamTW5FozSNnQJHFBaoBKe+X/P+eHESWCSs/?=
 =?us-ascii?Q?2eHAvWp7xo2YYU3WRJVgIuuTwe/Cax0C+ffx5pPnu/+crQxM2xBb71ooLfnR?=
 =?us-ascii?Q?A2k+RFi1w3qfdvU5PbQ+RBmMGoYyDi/7FWOoUDxFG0uSx3pA9BjZQTvWQiOI?=
 =?us-ascii?Q?JPz2OgI/n42UsAJdtdSAmu8HmUMNsVuvSxjx5U7Iw+q+/+rw8ga90GWXv9N+?=
 =?us-ascii?Q?KbkT8guDW3TGNfUUFnFwUplPhHJyg+LW/eHHQDh9VkzIi2PjnqoIrkxvz7Cu?=
 =?us-ascii?Q?1HHNhLnGUHWrpHL+wVhfWuQl59fuIzXSUF3BkxvCB0mMH1W8VXe/uvr+2JRG?=
 =?us-ascii?Q?L8EbNa9b3kkpfubjRGZmdlgmNF9Xai9+v9RV60oa/HPnInrftfQTynTGc2Hg?=
 =?us-ascii?Q?3sc373rENbOcIexUrhYz/57aVxIZjyWn3nS+tmVo1QYVM6OCcxB5D3dC1ZDm?=
 =?us-ascii?Q?nUmr5bTp/ONbQ+2AmSrK5fjT41AGWCc2KE737MbCjFkCrQWegGoLhQFNfSSx?=
 =?us-ascii?Q?Nwz6YImsWAk2qGI+upZrrDOHM2PfOnOpixFxHYqEfEnQL3nG3g0s0XSB30Vr?=
 =?us-ascii?Q?3njdPrSlcxq+BF1+tx5HzMk2A0V/XYs22ikSaPVJ+kxj7PHOf9xFVbf8JnZL?=
 =?us-ascii?Q?N9bZM1OqEg7VTliY5Un0OenvmaIN+LaR7ZHDTpWk3cVw2DUJ1QM+nnP4QGtS?=
 =?us-ascii?Q?PG8Ucui0KSNvD3A69mkAE+1VpBOLyxPgUNDZGrgM3lDaw53cz/RrAQkiskJx?=
 =?us-ascii?Q?3RQLhYorcq2YedTb2pFxTY1yqci3eXQUq9fogY3u6pT4ICOOy7qMTz12od6C?=
 =?us-ascii?Q?s7v3bqGTi0sMD+QrbmUK7iESA4OVIyohPtOug4pGx+iVjGELink4WatPIoOO?=
 =?us-ascii?Q?OQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78268afb-5141-492a-67fc-08dabafbf943
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 04:54:21.0503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B0FzU405nnBGCsGcFyWgl7boNrnNsIS26TD/AEpm4P6DGUv29Ixwz94H8VAR9DVVnoQ/RElvuSHP/ZNV/nQekA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_02,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210310031
X-Proofpoint-ORIG-GUID: uQZe37SXdMOiYVIwEeH8ncsTdgsbhMEp
X-Proofpoint-GUID: uQZe37SXdMOiYVIwEeH8ncsTdgsbhMEp
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

commit 5ffce3cc22a0e89813ed0c7162a68b639aef9ab6 upstream.

Commit 5833112df7e9 tried to make it so that a remap operation would
force the log out to disk if the filesystem is mounted with mandatory
synchronous writes.  Unfortunately, that commit failed to handle the
case where the inode or the file descriptor require mandatory
synchronous writes.

Refactor the check into into a helper that will look for all three
conditions, and now we can treat reflink just like any other synchronous
write.

Fixes: 5833112df7e9 ("xfs: reflink should force the log out if mounted with wsync")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_file.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cbca91b4b5b8..c67fab2c37c5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -990,6 +990,21 @@ xfs_file_fadvise(
 	return ret;
 }
 
+/* Does this file, inode, or mount want synchronous writes? */
+static inline bool xfs_file_sync_writes(struct file *filp)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+
+	if (ip->i_mount->m_flags & XFS_MOUNT_WSYNC)
+		return true;
+	if (filp->f_flags & (__O_SYNC | O_DSYNC))
+		return true;
+	if (IS_SYNC(file_inode(filp)))
+		return true;
+
+	return false;
+}
+
 STATIC loff_t
 xfs_file_remap_range(
 	struct file		*file_in,
@@ -1047,7 +1062,7 @@ xfs_file_remap_range(
 	if (ret)
 		goto out_unlock;
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
-- 
2.35.1

