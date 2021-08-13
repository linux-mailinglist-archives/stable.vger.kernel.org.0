Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAAA3EB3B6
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbhHMJ4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:56:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56350 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240074AbhHMJ4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:56:40 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D9u8FV006971;
        Fri, 13 Aug 2021 09:56:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=/j2rrbIEk/a9YNPO4OzYpTElm6sSwV8Nen7X56oV17M=;
 b=MjiyQpFTSUO59Pjrpw3GhqctP+amdKojWQPHRsM7NCy3ya0qM0KNKcLikaY0EyLlO6O+
 1NPkn5BUh9sPk3xktMs+0oyacf8TGgWLUiEBGEgNnY6iY9Fr5RvUIOGqPG1U8FFAD3l1
 c5Gk3+MOuSlHbq09HxbbTUUct8n2lYGsdSmcahPkBQwU2fK8+/LknFYrw1NdjzXU0TVS
 iJQXfrKBLS1bU6aMhQP5bZEsqrVVEsWktbZmxg2jLVyYTUfpCFBgLyH+Ol1ss/2nDmRe
 Rnm47ZqQv0bMPxlheaoU5zrMJTszbVhnJQLLX5t3UEfcW9D74nTGaJfEuAona+E0vpbC bw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/j2rrbIEk/a9YNPO4OzYpTElm6sSwV8Nen7X56oV17M=;
 b=jCATarO2cw9jwlU33o2HU0UxM4mxvKlXT5xNn1wblTvKHuJSi431WJhWJten4///saSy
 mBV3PiAY5Ma3arWbSwfReszaG5AB+mp6SjhKfC191nuuzrxxJHVAqf1g9xJjaNEhsY2B
 dO31a78Oai+C6aU63cH3uM5gVthIS7YSvRfCTQmO/DLVlijUJP+qC99sVVnDnk4ITweK
 zznrwRqx9hHqW3Vm+3xFGMShI5rwvHRRAyEXxAWNAO9PiSH3B4Ts+cAEwKOANzGJ53h6
 NtQJU6SqpdoEu63ERr1b0zRpcER64vW5wSlI0dooYlVrMxB23aM3sTtGLrcJzv6y4knN ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad2ajjftk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:56:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D9oVAD047370;
        Fri, 13 Aug 2021 09:56:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 3aa3y033bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:56:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1Ubb9V+wxZOqUtfv/YpOQhbOPGsLJtwtI5sv2AIvSGpHMM02FwIfZezj9zbkkm+++BW1Us3KTQFTVe/hugb2ahEYiXZhVhBm2I0RJb78bFWt5klSZcMSAKe9aqmnHlKKofUuMgUi9UoGS1FubcLtuyEIgtcMLQDqyhnfQyyNme2hPmityABnXGFp/d4EUrI3et7gAD/fSj1o6RJKudCxOrGOAaBVzXfYMRAG/l6xNlYxP8YeN1JmPwTzu4haUnI8H2E12gueJx51g5H23GP6LaEUaogmyA9UJaWGLBWMNP9kbh7jql5b/SPCtIliODcaaK9ugx7XMIXJa8VYQR8/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/j2rrbIEk/a9YNPO4OzYpTElm6sSwV8Nen7X56oV17M=;
 b=HazxLkheFgOfgkn/NRdrGxhtptm+V9sDol+SkyFhBYqqaWTiiYet02gj+q/vOXnDjEa8SVEy9AjcEqABrVC94MsXpvoP7TlwYWQcle9qzmmm7anP/5tyGbpB5k6/t7uIvza1U0jUr+/AsBRjsZFhQRES42s53xBN823zclSP+GnASdEWhGJvtzyr1GkCrv2oSw+dKV6BK3Py+RSncG93EocBAoZ08215/XrgWvs7D9AlewIRzMbto6MuZr9F054kp/1CcAORB78XaOsMGYU/ELFBn0A1+noTRgKcul6ybdjjXiKQPaNyNpqZLoHPLzEgwuxatAZ0MQCLJzX40SkBQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/j2rrbIEk/a9YNPO4OzYpTElm6sSwV8Nen7X56oV17M=;
 b=ZLGYELOGm+qdD1isBgi0pFYvZvqkytrCmYJtflRnL9x6icVsN/9/5MF9UkkF4Uh4sWqlnWcNA/AQHgQSAPa1CpGDr2rehXz+URVIqybvO4d2NjhvhREQSRnecJojichAf34uKOpLg8aWBvYBTmYYBUAYs6FbcF7A89LENKnvzG0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Fri, 13 Aug
 2021 09:55:58 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 09:55:58 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 4/7] btrfs: qgroup: try to flush qgroup space when we get -EDQUOT
Date:   Fri, 13 Aug 2021 17:55:27 +0800
Message-Id: <740e4978ebebfc08491db3f52264f7b5ba60ed96.1628845854.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628845854.git.anand.jain@oracle.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0124.apcprd03.prod.outlook.com
 (2603:1096:4:91::28) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR03CA0124.apcprd03.prod.outlook.com (2603:1096:4:91::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 09:55:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ca7106b-0252-4578-8101-08d95e408c9c
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB48527888EAE60E313106C39CE5FA9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86foJs8JzgLdiJ3A/BnKjPgHhhteaAEDEbQmD/pS2/YztqHS/BI0nyhRDLM+1lSqNDKjvr3gjTZ1hXn5JlzoI/hDNqmkfGuCqdW9kNCqHkRLFW3aR5qMiNKojG08qbkjGB7t54iE5kWUnQAvMYPQmtkpaWSooXR/pgSLP6nQz3uCcrON84RcJuV2CYGsI7iWSONIepzD6eeHuvxKGvEqgQsksb7i/nhfbcQ+v7w00xz+dtmW6C3+scuhnh7ph0wJQO32FIdOP8Tfx8Bo1zCHphDeV/usUfh+oLdCeUTSuHz8tRuK0xkIZnCypmx4DL1J1pgWqfEnaqKuOszvqSCUI/uBSolvkJbCOyZ1pN4ShJHkT1uW6aRN6c9G3L8RaRSbewfxHkOb9vP9KX7xR4QV5VpFy4HWogErwgoN66Jsf/oXtiEXMowgRPmxf10iXPTMAsClfe4faRyatTWt3Aj04hKmOYc/U/WJF7ogVxeUFXMu+A++03D0R/KyYhjkw+c/Ysr2NLO8H/eQa5SMdwG7iL0S0ccYPniJy+1A9Ys+Fjkai0obEXOR3zcUcAw2GrqthajdoApWwVKmC/nIHQDyIcRlpDnTIovqauYDqFvpbd++Cz2I2iouTy3S57KOEOZ29eJjr4+CXAHekuTHPqYG8HWMF8wXoqUg2PVOGUA6lKZCiHMhTbPsWC4xSq/kcTu6tVGSZxSRkKSB8NPVPlnpag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(107886003)(8936002)(8676002)(2906002)(478600001)(316002)(83380400001)(54906003)(44832011)(4326008)(956004)(2616005)(4001150100001)(86362001)(186003)(66946007)(26005)(66476007)(6666004)(6486002)(6512007)(52116002)(66556008)(36756003)(5660300002)(38350700002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U1AIkUh859cam8tpbkMOqn2qxLrWc5r3GG0f2GSc7YzXI4exxbhRQPSq431j?=
 =?us-ascii?Q?8Zz5RvL9BmJU9OSmNqlZom9viGPhKu04FKIRK0zS2odmQCq4OFElQKfy3CaX?=
 =?us-ascii?Q?vnc54nJ+Fx2AUYLi+AOkRQ/NaD9+0BpovphRm0C9P2vhbUSS9aPInuvkvAy0?=
 =?us-ascii?Q?uNZDo/7zem8LF5S6SP8vKVm9wrs1M8lhVep5li05Ws7r3UTAsf3FAj9EdRi6?=
 =?us-ascii?Q?p91KYOm9TUeG8v0w5GCrD2/WrypgZ9gRR0vU9J/IpN1+xw5UYdZry7PDnI4l?=
 =?us-ascii?Q?c4ZLYfetfgYyFc8NLnAWiTZEndxNsvz4s/GmT3dmfJ1wTka4XQjvUs2weQl7?=
 =?us-ascii?Q?H2gR7/AWfvdSGwYCo47mL3HbOTfTINNK2qtwVkyKpWLLTzR7c5NVVAm4vseE?=
 =?us-ascii?Q?bIKMMteRrbN6jf7EBxsMX376jrMeh8mQJjAs3+clMIzgy8j2jXjU/P9KygI9?=
 =?us-ascii?Q?8qpfkr53mbQujc8IRicp6P94lNbicyIED1fW8Tda7Hy/bCfpkzsjNFgLScBB?=
 =?us-ascii?Q?t5XFVeUJt4CMiexAQqcXjugREdeTX+hly4Zw4COMM3mUvusYsaX2plE0csV6?=
 =?us-ascii?Q?CYveDfNF8YHBFSg/Peso5DqmAhSLJovFo2GM8WkzwyTC3gVzZRXKbfoxeU0v?=
 =?us-ascii?Q?g+NoovzArUx04w0Q6l6LjouTqeaK+xwRR0Ps17BfVOr6f+qofwgcgnVvN1Yj?=
 =?us-ascii?Q?Q/dxh6mokhvDXghAASTKcK9xIVbzF6uFfuXLfSr4jt5apuUqC0Dq/uYfNJSn?=
 =?us-ascii?Q?HtW9xEw9a4tKP+0vUvnj9vaNOHPd+oSxvJ2qpeGLz1zthLvE+DiEvIWNk3m3?=
 =?us-ascii?Q?mvtzuy3QAqaU6ZxdNj44ivzVZJb9ftgR+d8vAbYW2lW627LDqBm5trajNHgu?=
 =?us-ascii?Q?N8jL2iNEwqn7Xn3KmfwpDa4DBA7ZT0o7lQ+mUyyY4Y8vFDO+BgDen/NAUmbO?=
 =?us-ascii?Q?Bpvl9WaHIcdik2+5j/PV/x9JGmEhGCjjnteLPlYDfeOIrcIRyID/9K2ylxey?=
 =?us-ascii?Q?ZG1yC1YQQ8UUTDe+HLXbz+cNQQdEf96ikiZx+afjzxSix65NWdZhWVl4cPDj?=
 =?us-ascii?Q?MQiw43qO/7Vor0nEo6pY66T9sW2YCLLrGkfIfiuYF0r+ETSdN8iOoL+oBo9P?=
 =?us-ascii?Q?ApqTBLWao4isJKB8c/fIHv8UC9eW7dDLj6FdfaVrPT5CrjkkJKiLiipk/hVT?=
 =?us-ascii?Q?zNNkcCcvtV7PlnnUQal62XSQpBivKCuiVqrvGahlcdazgxkMufIGpv6quWBt?=
 =?us-ascii?Q?lcBkCPt96fPP0rL4Sv+fvZkT20xAKgqFVggqz/AscLvGSkAHyzUrWQGYGO/V?=
 =?us-ascii?Q?7us07L/KpuA7TogEObsa/0lx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca7106b-0252-4578-8101-08d95e408c9c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 09:55:58.2627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQkJ2VuZcLsqxF1nc0C2yAyuQdyFtLTijE/7PzopIJKO5TG/a/QaKAwebh8Wjl9mWiMN1eFbRP098xa7JnTbGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130059
X-Proofpoint-ORIG-GUID: N9c0nQ9_JHTw7jVTlHusBrCtTd0Q1Rih
X-Proofpoint-GUID: N9c0nQ9_JHTw7jVTlHusBrCtTd0Q1Rih
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit c53e9653605dbf708f5be02902de51831be4b009 upstream

[PROBLEM]
There are known problem related to how btrfs handles qgroup reserved
space.  One of the most obvious case is the the test case btrfs/153,
which do fallocate, then write into the preallocated range.

  btrfs/153 1s ... - output mismatch (see xfstests-dev/results//btrfs/153.out.bad)
      --- tests/btrfs/153.out     2019-10-22 15:18:14.068965341 +0800
      +++ xfstests-dev/results//btrfs/153.out.bad      2020-07-01 20:24:40.730000089 +0800
      @@ -1,2 +1,5 @@
       QA output created by 153
      +pwrite: Disk quota exceeded
      +/mnt/scratch/testfile2: Disk quota exceeded
      +/mnt/scratch/testfile2: Disk quota exceeded
       Silence is golden
      ...
      (Run 'diff -u xfstests-dev/tests/btrfs/153.out xfstests-dev/results//btrfs/153.out.bad'  to see the entire diff)

[CAUSE]
Since commit c6887cd11149 ("Btrfs: don't do nocow check unless we have to"),
we always reserve space no matter if it's COW or not.

Such behavior change is mostly for performance, and reverting it is not
a good idea anyway.

For preallcoated extent, we reserve qgroup data space for it already,
and since we also reserve data space for qgroup at buffered write time,
it needs twice the space for us to write into preallocated space.

This leads to the -EDQUOT in buffered write routine.

And we can't follow the same solution, unlike data/meta space check,
qgroup reserved space is shared between data/metadata.
The EDQUOT can happen at the metadata reservation, so doing NODATACOW
check after qgroup reservation failure is not a solution.

[FIX]
To solve the problem, we don't return -EDQUOT directly, but every time
we got a -EDQUOT, we try to flush qgroup space:

- Flush all inodes of the root
  NODATACOW writes will free the qgroup reserved at run_dealloc_range().
  However we don't have the infrastructure to only flush NODATACOW
  inodes, here we flush all inodes anyway.

- Wait for ordered extents
  This would convert the preallocated metadata space into per-trans
  metadata, which can be freed in later transaction commit.

- Commit transaction
  This will free all per-trans metadata space.

Also we don't want to trigger flush multiple times, so here we introduce
a per-root wait list and a new root status, to ensure only one thread
starts the flushing.

Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h   |   3 ++
 fs/btrfs/disk-io.c |   1 +
 fs/btrfs/qgroup.c  | 100 +++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 96 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7960359dbc70..5448dc62e915 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -945,6 +945,8 @@ enum {
 	BTRFS_ROOT_DEAD_TREE,
 	/* The root has a log tree. Used only for subvolume roots. */
 	BTRFS_ROOT_HAS_LOG_TREE,
+	/* Qgroup flushing is in progress */
+	BTRFS_ROOT_QGROUP_FLUSHING,
 };
 
 /*
@@ -1097,6 +1099,7 @@ struct btrfs_root {
 	spinlock_t qgroup_meta_rsv_lock;
 	u64 qgroup_meta_rsv_pertrans;
 	u64 qgroup_meta_rsv_prealloc;
+	wait_queue_head_t qgroup_flush_wait;
 
 	/* Number of active swapfiles */
 	atomic_t nr_swapfiles;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e6aa94a583e9..e3bcab38a166 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1154,6 +1154,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	mutex_init(&root->log_mutex);
 	mutex_init(&root->ordered_extent_mutex);
 	mutex_init(&root->delalloc_mutex);
+	init_waitqueue_head(&root->qgroup_flush_wait);
 	init_waitqueue_head(&root->log_writer_wait);
 	init_waitqueue_head(&root->log_commit_wait[0]);
 	init_waitqueue_head(&root->log_commit_wait[1]);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 50c45b4fcfd4..b312ac645e08 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3479,17 +3479,58 @@ static int qgroup_unreserve_range(struct btrfs_inode *inode,
 }
 
 /*
- * Reserve qgroup space for range [start, start + len).
+ * Try to free some space for qgroup.
  *
- * This function will either reserve space from related qgroups or doing
- * nothing if the range is already reserved.
+ * For qgroup, there are only 3 ways to free qgroup space:
+ * - Flush nodatacow write
+ *   Any nodatacow write will free its reserved data space at run_delalloc_range().
+ *   In theory, we should only flush nodatacow inodes, but it's not yet
+ *   possible, so we need to flush the whole root.
  *
- * Return 0 for successful reserve
- * Return <0 for error (including -EQUOT)
+ * - Wait for ordered extents
+ *   When ordered extents are finished, their reserved metadata is finally
+ *   converted to per_trans status, which can be freed by later commit
+ *   transaction.
  *
- * NOTE: this function may sleep for memory allocation.
+ * - Commit transaction
+ *   This would free the meta_per_trans space.
+ *   In theory this shouldn't provide much space, but any more qgroup space
+ *   is needed.
  */
-int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
+static int try_flush_qgroup(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	/*
+	 * We don't want to run flush again and again, so if there is a running
+	 * one, we won't try to start a new flush, but exit directly.
+	 */
+	if (test_and_set_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state)) {
+		wait_event(root->qgroup_flush_wait,
+			!test_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state));
+		return 0;
+	}
+
+	ret = btrfs_start_delalloc_snapshot(root);
+	if (ret < 0)
+		goto out;
+	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	ret = btrfs_commit_transaction(trans);
+out:
+	clear_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state);
+	wake_up(&root->qgroup_flush_wait);
+	return ret;
+}
+
+static int qgroup_reserve_data(struct btrfs_inode *inode,
 			struct extent_changeset **reserved_ret, u64 start,
 			u64 len)
 {
@@ -3542,6 +3583,34 @@ int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 	return ret;
 }
 
+/*
+ * Reserve qgroup space for range [start, start + len).
+ *
+ * This function will either reserve space from related qgroups or do nothing
+ * if the range is already reserved.
+ *
+ * Return 0 for successful reservation
+ * Return <0 for error (including -EQUOT)
+ *
+ * NOTE: This function may sleep for memory allocation, dirty page flushing and
+ *	 commit transaction. So caller should not hold any dirty page locked.
+ */
+int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
+			struct extent_changeset **reserved_ret, u64 start,
+			u64 len)
+{
+	int ret;
+
+	ret = qgroup_reserve_data(inode, reserved_ret, start, len);
+	if (ret <= 0 && ret != -EDQUOT)
+		return ret;
+
+	ret = try_flush_qgroup(inode->root);
+	if (ret < 0)
+		return ret;
+	return qgroup_reserve_data(inode, reserved_ret, start, len);
+}
+
 /* Free ranges specified by @reserved, normally in error path */
 static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len)
@@ -3712,7 +3781,7 @@ static int sub_root_meta_rsv(struct btrfs_root *root, int num_bytes,
 	return num_bytes;
 }
 
-int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+static int qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 				enum btrfs_qgroup_rsv_type type, bool enforce)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -3739,6 +3808,21 @@ int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 	return ret;
 }
 
+int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+				enum btrfs_qgroup_rsv_type type, bool enforce)
+{
+	int ret;
+
+	ret = qgroup_reserve_meta(root, num_bytes, type, enforce);
+	if (ret <= 0 && ret != -EDQUOT)
+		return ret;
+
+	ret = try_flush_qgroup(root);
+	if (ret < 0)
+		return ret;
+	return qgroup_reserve_meta(root, num_bytes, type, enforce);
+}
+
 void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-- 
2.31.1

