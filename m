Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658844CBEE5
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 14:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiCCNbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 08:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiCCNbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 08:31:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE700188A22;
        Thu,  3 Mar 2022 05:30:52 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223C0sR7013887;
        Thu, 3 Mar 2022 13:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MRkR9RlzkhFjjIg7o+BQHgblDf3txOXLrb7PSoPICgI=;
 b=MZlcKCYpuS7MT9roVt8HS9ObgYtPluoWNwuOfmEMZW1M/nAtbrYWejzcNMYhk5Frcbng
 lMOX2Er0w2J15DJ0AlRDOro2F6fJUWkEfKhto7krJyoOn54A/5qydvcEDkSe+ye9WZBW
 mF+tLCHbK0tQiLDxx3LtB1niKMRReoGzyvj7OiJpXCB8BmHWsrgC1T1f99+9wZP4DWtF
 W+4R2bZvWcTApQq16p9n+6qSA+pT2Ce3O0jkg76K3Xg44HJpP/zz7d5rT8MCgsFJ4ZvT
 KsLYgUS8uKIWYz4Xd8e6ehk4Mcu9o+f4olAOex113aR2r9RuiAh4ZaBHDp4u4H+c571i +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k48tdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Mar 2022 13:30:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 223DG7QB171354;
        Thu, 3 Mar 2022 13:30:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3030.oracle.com with ESMTP id 3ef9b3d8gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Mar 2022 13:30:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SS5SO8LNHkCIm5fAZ6yHv4ZxOgxSgdDvmNSlTAGu5x0EbD4UbScHrj8SLaNNa3hOQ+4Jy7UKZACeYGGnk+0l8s3eFvoIdwZ0dK5/e/dvUoh8V2q3oR+AgxKoZSwzla0hI+3C8FIs7aektA1UfwPzSJJ5RAyGsC/qtzwpcojZBObYggLp5Xx9jWG+kKXk78clfKWi4vK7RvHHXphx46fMGFTfqOyQD6w9bjfT+R3miQIlrdt+50LyjgQKq5BShJ61bqfvTkavHN8JweJXwnNy2jjmSJ01Vk86LiFNrBU0HXRFOBNusEHsoakF5B+PQDVTtzg4hNLeyOhA4gxOBZWmSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRkR9RlzkhFjjIg7o+BQHgblDf3txOXLrb7PSoPICgI=;
 b=K4fYlvJvlFa+xFCUKVHnAFSs6+GF6PUekbiwMMWuyKsRuQg/FBanApIrfLSbQBifgByjDjzoqXRCcVwZEwLjAHoOoezHZQUe5wbSTWos9jMqJQsPGeXLdp42DH0gL2MggiRs9p62VLnTsUeLgHfoojctOb5/QPp/R92HAfB11peVqPNafrLhYrvZHMKISamZX/2hEY3pz0bSACfT26KuaP2Phinofum/+j2yPCkMO6MsPVSttEQbI6I662xb/tS0l5qpC3wS+Lo5gVP4quEfDCRnHoJCW0Fc1FBQy6w6n8mMtyvgJLsV9c0ZWReAmAMruBndBS8ywzcCM0rZsy6kUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRkR9RlzkhFjjIg7o+BQHgblDf3txOXLrb7PSoPICgI=;
 b=w8pjTLHBEj+J7WB0sVfW+y7aueTBbJn9F7JJDf1oLYE3nN3qoJ52CfkqFq+OstV/DQHogwHxYNOwIzdzCFcA/5pAByNADyFQX9O/mA7LgDPUaXgWJTf181eQRq5lGhbivyvHB+VBR32YkzbMz/J6krSjYOmvjHtDUfHjXaMY9Io=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BY5PR10MB3747.namprd10.prod.outlook.com (2603:10b6:a03:1f5::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 13:30:42 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d469:7ab:8ae2:1e6f]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d469:7ab:8ae2:1e6f%6]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 13:30:42 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH stable-5.15.y] btrfs: fix ENOSPC failure when attempting direct IO write into NOCOW range
Date:   Thu,  3 Mar 2022 21:30:31 +0800
Message-Id: <4d7223dc5a3e02562e48012334f76ed598bc9792.1646313523.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0601CA0015.apcprd06.prod.outlook.com (2603:1096:3::25)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90204113-2e2c-4a86-f5f8-08d9fd1a03b2
X-MS-TrafficTypeDiagnostic: BY5PR10MB3747:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3747123383A2AE1D3FD39A35E5049@BY5PR10MB3747.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MT0c7den8oskSOITU1oe0ZxFVGOgpvh7e5k5WC47LG/o00BXfLInLuPNpJ2x4l1bt58jgw3/qZ/U6YuMpUx5Cw+lhS3rC7e9AroEJeRayUr5YjBdAa3iSwxVqsYRjKvxPkVHyCKDAQdLgp3bV9SrHbFo41w88SNvifXkqOvpKGv9DzgVDfuC6VzytXgwquh0/KiuAdkvm8K8CkCQSq7cOhlm8etoyXFlrzAWU5/ong2lFNhIiWHp0/voWbObjKWv+BmYai+xeSgkNhPQszuSX+JK+Va9dN7RqQAsVfQplA31wk5Mzg/yAu7tUWuGssGsbBWipVDs+HcKO3Ay/zEhIkkDUVA3xrDCc9Ltrv0UH+MoGESKiHnj3jz8SmutcDFXyXTvZuXSYsuPMnxRUPg1K9bq7I/aZNztLAQmU2XHA/CiVWvEM/LeJ/s+7rOBdpPFPjohA+RoxJ8lzkAFBXrrrGC79/v61coKS9+0hRikLXUdehCqfvTSon3qxGsGgB053TfyqeSRMynRYPEF4JGA2VFtQRbNEnVBw6mK80ObJKo8PT086a9XHzYikNjprfG09v1Ju10kd/yJ3boNWoREzd0iiffb3Y5at1f0xDApg7VUpWOWBruMwTLB8GJPRAR8UqgI3k/cJcsjKs9GwHB4vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6512007)(54906003)(6916009)(2906002)(6506007)(86362001)(66476007)(66556008)(66946007)(8676002)(4326008)(36756003)(316002)(44832011)(508600001)(2616005)(83380400001)(38100700002)(107886003)(8936002)(6666004)(5660300002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iLgELVhW8WY1c/sL8oSQ8hspUTvXQ5FdhiRJ9OX88CSjQUcu0A6sKQARA2+t?=
 =?us-ascii?Q?OHukhPscNyCHbtVNkLBiMHT137sFmSpE+XcJQn4Clr8275NoVXS+mBmcd0D+?=
 =?us-ascii?Q?3yBEyypSh8zw/UmPwSxTH6HcrMsxzR1x7HK0G1cp4wFIVspzusr1h47hH13O?=
 =?us-ascii?Q?N9njrA2yOVmiy2KOTde2O7H+UhsBhpI2dpzHRMfYt3V2/goq8Bm8mP0skRFN?=
 =?us-ascii?Q?jSzSQcB6+zAziUyN2iSwKUNSxNSr/CyxVrpwv6j5mQzGa/dLtkNGvody9xdk?=
 =?us-ascii?Q?uo9UilsMtlAnKdvV5yEBv8qAQZzDqezu9SFMYB0KTPNjsvTxv8omjnXx0SI3?=
 =?us-ascii?Q?Ez5mSYFF6ej3pn9YCBFcWair15DXZMNv6b0ok0p9jeduQtR51XEjmoT7jcgs?=
 =?us-ascii?Q?FhmqF6VHWqF7FUGyQNqkmzqIYchNlU1Kc2vx1Z32801F5HmcC/LoLn3wrgpv?=
 =?us-ascii?Q?4PiA7xIPAanyRZqoBLeaSUZSPmFRoVwtZuBMiD1FSq/HKZjF3F8ZzMQtLedZ?=
 =?us-ascii?Q?3dvjxUMUPzFGLhdmQIIDFKQNiE1gk0XtOI9CBCEAKiY9bpGXiM9hrSlqKA1b?=
 =?us-ascii?Q?LfJSj1/YKBDjcDHNklCk4PVifBLHrnXsBudZkrHxP3knJn9aJf/2ils6AukW?=
 =?us-ascii?Q?A/YHLcvm8Duyx71+dejaHRrGSpuIemO9dC3fQbJ2tWhgmBa+T5Jkv5bVt8cE?=
 =?us-ascii?Q?w0RXUrpgLnUYuo7tQU0u4H4agpWnvn9vVI+m5dGUimerfC1dTMTPUoHsfvAj?=
 =?us-ascii?Q?A45fC74yq+YSMelGPg2Qv8P2XZhG9b3qIniq6ZbBr5QEwu+NzFiyFhNJ9hEG?=
 =?us-ascii?Q?Bu75QwPFbUTQrj+QX2jtTvGiIQI2jfa2Xa//mmww0B3Nk9zpW/NXhAsKOPnf?=
 =?us-ascii?Q?lDrXJjSqjdKhDZagqnkNc4L+k3DqGLbuK9wq1D6tZckGYxtH3zuD9Uj1ge0B?=
 =?us-ascii?Q?vFI/pYcWui34ZVdan9myiSuBwFKPEouvHZpFhghQC4KOa2wH2O/38GLFl3V/?=
 =?us-ascii?Q?CYVQs1miVPYvpZMGwCH62uaGZN8POFNyL2kLYgt3DUN/3A38x5vsWuloYR+G?=
 =?us-ascii?Q?eYi7NyMTpiO6zETKGwkNWbeKsknVenkCQQWYPp/k4Rtm9wBpw2yLuTmr6DT5?=
 =?us-ascii?Q?yONEX7wGaUizmWfyDa+7XWQ0q3z05zX7/zfrt/ugBfOedBZveniOLQijoqd0?=
 =?us-ascii?Q?ZJz9odjttQsZUDDBwzHa95ot+mC6EsPwf/HKm60eqdRuIsxwd+EputmFlLOr?=
 =?us-ascii?Q?oiVgww69808xKDhwRFdwjgDRbfpzT5N/+gFrD1Kzn8L/lmtRAqoCFLROFJnL?=
 =?us-ascii?Q?nVnZ309kujDWyZ+BV8CAu4NRkM7cKYml6Za2i571fVr5DHjEBEuZcNeRnGc8?=
 =?us-ascii?Q?pDD4btnjfhyr/uOSLVaqYV74+i5xqXJR0DJIKJxxmZM/nd75fTz9PJiLtJ57?=
 =?us-ascii?Q?IyL7+pokpFincRtt36EU6S/SMYbcqCnKpLqjgDowsEYNBUGF5xAQuQlecBOX?=
 =?us-ascii?Q?oQrS8o6kB0vbgAaZLERYPX5/MQbgqDsPXLUL/zftfpBErxxe4Yd4uDeQCkNF?=
 =?us-ascii?Q?GC8gDqAKlAbmnXuSab+8dR3PdAV7701F263OFO+AgDu971YHQKXm8YOOZSl5?=
 =?us-ascii?Q?EnBybhsw1QYL6ZhkBEaE6ps=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90204113-2e2c-4a86-f5f8-08d9fd1a03b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 13:30:42.5641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E1egvDbJ6f/4Bc1W0pVKVDL9yfAcDrayNShGM/lqDD/uXonVAqvBV+5VyD2tWhMM7ZHtOCyK3rw1LBSiT432Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3747
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203030063
X-Proofpoint-ORIG-GUID: ki7qJP5yUeiqZbBULQgdwat0h4rCcRGg
X-Proofpoint-GUID: ki7qJP5yUeiqZbBULQgdwat0h4rCcRGg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Commit f0bfa76a11e93d0fe2c896fcb566568c5e8b5d3f upstream.

When doing a direct IO write against a file range that either has
preallocated extents in that range or has regular extents and the file
has the NOCOW attribute set, the write fails with -ENOSPC when all of
the following conditions are met:

1) There are no data blocks groups with enough free space matching
   the size of the write;

2) There's not enough unallocated space for allocating a new data block
   group;

3) The extents in the target file range are not shared, neither through
   snapshots nor through reflinks.

This is wrong because a NOCOW write can be done in such case, and in fact
it's possible to do it using a buffered IO write, since when failing to
allocate data space, the buffered IO path checks if a NOCOW write is
possible.

The failure in direct IO write path comes from the fact that early on,
at btrfs_dio_iomap_begin(), we try to allocate data space for the write
and if it that fails we return the error and stop - we never check if we
can do NOCOW. But later, at btrfs_get_blocks_direct_write(), we check
if we can do a NOCOW write into the range, or a subset of the range, and
then release the previously reserved data space.

Fix this by doing the data reservation only if needed, when we must COW,
at btrfs_get_blocks_direct_write() instead of doing it at
btrfs_dio_iomap_begin(). This also simplifies a bit the logic and removes
the inneficiency of doing unnecessary data reservations.

The following example test script reproduces the problem:

  $ cat dio-nocow-enospc.sh
  #!/bin/bash

  DEV=/dev/sdj
  MNT=/mnt/sdj

  # Use a small fixed size (1G) filesystem so that it's quick to fill
  # it up.
  # Make sure the mixed block groups feature is not enabled because we
  # later want to not have more space available for allocating data
  # extents but still have enough metadata space free for the file writes.
  mkfs.btrfs -f -b $((1024 * 1024 * 1024)) -O ^mixed-bg $DEV
  mount $DEV $MNT

  # Create our test file with the NOCOW attribute set.
  touch $MNT/foobar
  chattr +C $MNT/foobar

  # Now fill in all unallocated space with data for our test file.
  # This will allocate a data block group that will be full and leave
  # no (or a very small amount of) unallocated space in the device, so
  # that it will not be possible to allocate a new block group later.
  echo
  echo "Creating test file with initial data..."
  xfs_io -c "pwrite -S 0xab -b 1M 0 900M" $MNT/foobar

  # Now try a direct IO write against file range [0, 10M[.
  # This should succeed since this is a NOCOW file and an extent for the
  # range was previously allocated.
  echo
  echo "Trying direct IO write over allocated space..."
  xfs_io -d -c "pwrite -S 0xcd -b 10M 0 10M" $MNT/foobar

  umount $MNT

When running the test:

  $ ./dio-nocow-enospc.sh
  (...)

  Creating test file with initial data...
  wrote 943718400/943718400 bytes at offset 0
  900 MiB, 900 ops; 0:00:01.43 (625.526 MiB/sec and 625.5265 ops/sec)

  Trying direct IO write over allocated space...
  pwrite: No space left on device

A test case for fstests will follow, testing both this direct IO write
scenario as well as the buffered IO write scenario to make it less likely
to get future regressions on the buffered IO case.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/inode.c | 142 ++++++++++++++++++++++++++---------------------
 1 file changed, 78 insertions(+), 64 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e92f0b0afe9e..58053b5f0ce1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,8 +60,6 @@ struct btrfs_iget_args {
 };
 
 struct btrfs_dio_data {
-	u64 reserve;
-	loff_t length;
 	ssize_t submitted;
 	struct extent_changeset *data_reserved;
 };
@@ -7763,6 +7761,10 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_map *em = *map;
+	int type;
+	u64 block_start, orig_start, orig_block_len, ram_bytes;
+	bool can_nocow = false;
+	bool space_reserved = false;
 	int ret = 0;
 
 	/*
@@ -7777,9 +7779,6 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
 	    ((BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
 	     em->block_start != EXTENT_MAP_HOLE)) {
-		int type;
-		u64 block_start, orig_start, orig_block_len, ram_bytes;
-
 		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
 			type = BTRFS_ORDERED_PREALLOC;
 		else
@@ -7789,53 +7788,92 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 
 		if (can_nocow_extent(inode, start, &len, &orig_start,
 				     &orig_block_len, &ram_bytes, false) == 1 &&
-		    btrfs_inc_nocow_writers(fs_info, block_start)) {
-			struct extent_map *em2;
+		    btrfs_inc_nocow_writers(fs_info, block_start))
+			can_nocow = true;
+	}
 
-			em2 = btrfs_create_dio_extent(BTRFS_I(inode), start, len,
-						      orig_start, block_start,
-						      len, orig_block_len,
-						      ram_bytes, type);
+	if (can_nocow) {
+		struct extent_map *em2;
+
+		/* We can NOCOW, so only need to reserve metadata space. */
+		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), len);
+		if (ret < 0) {
+			/* Our caller expects us to free the input extent map. */
+			free_extent_map(em);
+			*map = NULL;
 			btrfs_dec_nocow_writers(fs_info, block_start);
-			if (type == BTRFS_ORDERED_PREALLOC) {
-				free_extent_map(em);
-				*map = em = em2;
-			}
+			goto out;
+		}
+		space_reserved = true;
 
-			if (em2 && IS_ERR(em2)) {
-				ret = PTR_ERR(em2);
-				goto out;
-			}
-			/*
-			 * For inode marked NODATACOW or extent marked PREALLOC,
-			 * use the existing or preallocated extent, so does not
-			 * need to adjust btrfs_space_info's bytes_may_use.
-			 */
-			btrfs_free_reserved_data_space_noquota(fs_info, len);
-			goto skip_cow;
+		em2 = btrfs_create_dio_extent(BTRFS_I(inode), start, len,
+					      orig_start, block_start,
+					      len, orig_block_len,
+					      ram_bytes, type);
+		btrfs_dec_nocow_writers(fs_info, block_start);
+		if (type == BTRFS_ORDERED_PREALLOC) {
+			free_extent_map(em);
+			*map = em = em2;
 		}
-	}
 
-	/* this will cow the extent */
-	free_extent_map(em);
-	*map = em = btrfs_new_extent_direct(BTRFS_I(inode), start, len);
-	if (IS_ERR(em)) {
-		ret = PTR_ERR(em);
-		goto out;
+		if (IS_ERR(em2)) {
+			ret = PTR_ERR(em2);
+			goto out;
+		}
+	} else {
+		const u64 prev_len = len;
+
+		/* Our caller expects us to free the input extent map. */
+		free_extent_map(em);
+		*map = NULL;
+
+		/* We have to COW, so need to reserve metadata and data space. */
+		ret = btrfs_delalloc_reserve_space(BTRFS_I(inode),
+						   &dio_data->data_reserved,
+						   start, len);
+		if (ret < 0)
+			goto out;
+		space_reserved = true;
+
+		em = btrfs_new_extent_direct(BTRFS_I(inode), start, len);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out;
+		}
+		*map = em;
+		len = min(len, em->len - (start - em->start));
+		if (len < prev_len)
+			btrfs_delalloc_release_space(BTRFS_I(inode),
+						     dio_data->data_reserved,
+						     start + len, prev_len - len,
+						     true);
 	}
 
-	len = min(len, em->len - (start - em->start));
+	/*
+	 * We have created our ordered extent, so we can now release our reservation
+	 * for an outstanding extent.
+	 */
+	btrfs_delalloc_release_extents(BTRFS_I(inode), len);
 
-skip_cow:
 	/*
 	 * Need to update the i_size under the extent lock so buffered
 	 * readers will get the updated i_size when we unlock.
 	 */
 	if (start + len > i_size_read(inode))
 		i_size_write(inode, start + len);
-
-	dio_data->reserve -= len;
 out:
+	if (ret && space_reserved) {
+		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
+		if (can_nocow) {
+			btrfs_delalloc_release_metadata(BTRFS_I(inode), len, true);
+		} else {
+			btrfs_delalloc_release_space(BTRFS_I(inode),
+						     dio_data->data_reserved,
+						     start, len, true);
+			extent_changeset_free(dio_data->data_reserved);
+			dio_data->data_reserved = NULL;
+		}
+	}
 	return ret;
 }
 
@@ -7877,18 +7915,6 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 	if (!dio_data)
 		return -ENOMEM;
 
-	dio_data->length = length;
-	if (write) {
-		dio_data->reserve = round_up(length, fs_info->sectorsize);
-		ret = btrfs_delalloc_reserve_space(BTRFS_I(inode),
-				&dio_data->data_reserved,
-				start, dio_data->reserve);
-		if (ret) {
-			extent_changeset_free(dio_data->data_reserved);
-			kfree(dio_data);
-			return ret;
-		}
-	}
 	iomap->private = dio_data;
 
 
@@ -7981,14 +8007,8 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			     &cached_state);
 err:
-	if (dio_data) {
-		btrfs_delalloc_release_space(BTRFS_I(inode),
-				dio_data->data_reserved, start,
-				dio_data->reserve, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), dio_data->reserve);
-		extent_changeset_free(dio_data->data_reserved);
-		kfree(dio_data);
-	}
+	kfree(dio_data);
+
 	return ret;
 }
 
@@ -8018,14 +8038,8 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 		ret = -ENOTBLK;
 	}
 
-	if (write) {
-		if (dio_data->reserve)
-			btrfs_delalloc_release_space(BTRFS_I(inode),
-					dio_data->data_reserved, pos,
-					dio_data->reserve, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), dio_data->length);
+	if (write)
 		extent_changeset_free(dio_data->data_reserved);
-	}
 out:
 	kfree(dio_data);
 	iomap->private = NULL;
-- 
2.33.1

