Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1657A61EA07
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 05:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiKGED7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 23:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiKGED5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 23:03:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5152A60C5;
        Sun,  6 Nov 2022 20:03:54 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A6M2YNw018998;
        Mon, 7 Nov 2022 04:03:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7yDuZMRnQVX4upvcVRoezSLbFbtsrRyePEW13VB8zqc=;
 b=x8DTvOrm6aDielyx1dzwLbiUYgaC/oLJLU9O+kwsxX5uNUKum97+bdSX/72ry+nsPi66
 LJu8GqBt95d0XRcVof0YMJqy00whfg7UZ5wbftU9RiuX9swzz1TvHbb1R6lokSp7v7YE
 5fQnKpOvmMsWV+Z009Om/6mMgCRbHayI+q2ye1kiQ4FvMcCxHC6Ql+DpMGKx1zpp745i
 4O6nPHoKABPpewlLeyB8OWorMyz8zRzUxNnKScO75/vdhKozqQHZGBcfGgGKfG+RbZ80
 WhOKNPdEqSW370WP2lIFvN5bhnD/oAnYvAXwyK32+1hEa4Ckx1b4pnUBbO4Ucrd9OU1Q CQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj2eau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:03:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A73ugbT024352;
        Mon, 7 Nov 2022 04:03:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsbv6f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:03:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3Db1QNWHI6pj76NvECHhHzKCiDHenz+dDFZFAaCoMUlGkHfB16UfxLRDv277vttrHITLSzM9xNiF+sH2Ymde1Ubfx5/YoevgRFWp0OEnvNofz7x8py+mitnCxcq6UmKq3GMqKDsYIdHnvek4qCUwaupudiYXDy1xJui1tLcBhMtRlaJUCV3YIof0nu7rrzdqc1rUQ74WAC1N6vaiv4rnoeI/jAd46te3xHGRlYSab8n7PV5R4lt2BvRA8Ogd1fsRnRQ1E7J9zy4sTF5Sn7BkOr72tOyX8Q2RheMU8NVIooxSSeGbJn9knC0wV9uRxEXhPBQywAKjgRP3Eqhim3H/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7yDuZMRnQVX4upvcVRoezSLbFbtsrRyePEW13VB8zqc=;
 b=UJdXpfPs5FV8W5IhVlztVtURNNb0pMOga/8uFZoDI5sIcFndkpz4Q1TC5ZXj23iB80W6s6ng/FJeByXa1GBloKaB/TZ0m86FVM1q6gcMfWXDvgoOBukHpyOIgLqDVqOlHRMJyTcnyroz41vYtuMYziJjMEUJJbMK0+YtGHswMWnIirWWhA41dShA5hGdYIZ5AXnRbGlg5rqkFGpNNq3uaqFzDxobB5V6Pndtb0NR3MZn6ENRIAPLWDbRNqFc/kdefw9Xmex/FOw23/is5l+W3O0Ut6nGBhoYfAXibQ/XFFSrpZ+V3+oCfcORwPcRaROoGFX5jTgkeoa3kp2KUx7LQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yDuZMRnQVX4upvcVRoezSLbFbtsrRyePEW13VB8zqc=;
 b=Nm+1593ReROY4bYUrILxmYwTmKajwuSL9x6j81xw05rzFubA7aQQ2dh8xuKf0vjnfnj3SleIHEmoAiYjBYfu7toJsjKSDUfJajWWEfmQqWQSxbtVLoDYkGXw3DunYcYHe8QhTL0zXSRHeTdm3XRi5mhJi25UJPAuyR2G5z9eqY0=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 04:03:47 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%4]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 04:03:47 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 2/6] xfs: use ordered buffers to initialize dquot buffers during quotacheck
Date:   Mon,  7 Nov 2022 09:33:23 +0530
Message-Id: <20221107040327.132719-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221107040327.132719-1-chandan.babu@oracle.com>
References: <20221107040327.132719-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:195::22) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: e397637d-58a2-4a32-85ef-08dac07511df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vy4966872r1aNuTyq1eX5W9NLdtHvReVIJzIAF24r6zaqRoEBKDXCas6/wKsYTmZDxe3GHvemfASXqxUy/2LsKZ9ybC2OELoM8sQ0TTo1IvfRLbZj8BB165kEfNVA+xSdLaXbFZxjQ5zL8Iz2/tsPaXCX6U3CeMI3wwAti5zp95yjj4+3UuPGgAH9jxDSYjbPRy3QdPt8jy3fYyWvNgRbRviENqm0Isx5yE2DY25cl00LgfJcfKOlQgnDL6S01ZwNI0Yuxy4j6Cmk24EBVG8se1uyZDzD2swafxXRdpb7JuYj0P2C8pEBAgcrVyShPH6TQKH6Pyp/g58xaQH7jHm21C4nx4+nKPuOlCz//u/Nwp5JAqUfWAZB2h6dgB5pFi9HST84/i5bYgapsN+jnhPZ/Wi+5lq81NEl8XcfAXchjs3yEdm3UYjFm8KTUvIv3ExADnxLYrzhlpO+ENaT1q8Gyz6g17Fs8DfE5n6Y3ENfDwH5NW9wP6VJLNEJY6NJ+gZJ4QPwr3KGKH146IWkmcl5yyRLw4J/NbsBxz6nYmoHhwXYiYKxVVbHpjS2t2RsWudJ40eh00qERbOrIa1FMVZ8QJe9QZet0K2iXYJjpOFJjq9UxfxY03Xp8WDbV3RNg6k1OTqL4ueF4onfVgHli8IvyM8JyDWdKJZridnfCMBN2sNzK+OZHVqmx7FJckBybpJsGxDahoTJ6YOHwjPnpT1bQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(1076003)(186003)(6512007)(26005)(6666004)(6506007)(2616005)(83380400001)(15650500001)(2906002)(478600001)(6916009)(6486002)(38100700002)(5660300002)(41300700001)(8936002)(316002)(8676002)(66476007)(66556008)(4326008)(66946007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uFu4bb2VLuEIpaWsa/qLO+B6u9hUBGwQZ+iZBK3sg8WG6S304VVG1RBcWxb4?=
 =?us-ascii?Q?G0bTBLFrxJJii/o1wxUVTACN+c55M+HHgOeX6ly+AHpGl6bIGVVCtkyK/ynd?=
 =?us-ascii?Q?PbdzkrAHjAFOP27Pr6t5uBGBHx2NyPmjoh/+mOt6ZKASAUPrYR8p8KITf67/?=
 =?us-ascii?Q?6GbSTqO5PWvv9FOUO+sUXnkOJzKnwLc5633QUqzeSLB9/QggOpQLVzjrJAtO?=
 =?us-ascii?Q?JXxZGeXFx1mHuZzS9J8ebWL1p5z6VB9AWdBQt6wR6IhdxOLI/1/gBWTpuyha?=
 =?us-ascii?Q?TfgDtJGKiQsSVlJzH+iMxO0Qt9cIX4zyPvILUDJPcLY2YKKu9WWoEMcX8Jc9?=
 =?us-ascii?Q?KU7/QX2CCYfDw35dMYA1n3KuR7B85dzR6t8XlltVoyjGZ1EbUG96ViZa3lTm?=
 =?us-ascii?Q?/sK4MQjRqbIV/sc5W8B0ghRwUgQVWjZPo5tCtKvuBD0t6pK+WJWmwtiWs+7J?=
 =?us-ascii?Q?l8MLOHyFoX4meH4PEgU6t/uJ+29w0Tm3FNIb1+LAWjQr19Tu5AsP9XOUClSo?=
 =?us-ascii?Q?YMgrbrLfwy2+clgqyMw+kxyJkUW1c7As+JioUQCHm+LX0glQgctXng4dRzTF?=
 =?us-ascii?Q?FKPciwXSTEJkUoRvIxPwrPpiSR+aquJT9hMMO+fQ7PGIcRS4d6tUe4CrxdQJ?=
 =?us-ascii?Q?hJT+2QdOZ0VAuOwQ9ISY8VHoloPL6Om7EkFP2sfn3LykLjWFoGxrXghyvzPJ?=
 =?us-ascii?Q?C29OW6SBeZN7YbTUhFsyLTdCIdtU6XBxbZvglF4lVK55hqAl3PsBqQ2Lo/0d?=
 =?us-ascii?Q?iOKdU+WFxrv8VLi7Y6GG6qli41D/8269xtfDQ3EN6HULhsWkBoaFDEQ6fV3I?=
 =?us-ascii?Q?V20gs+8R2+5QwRNXRqEHarmu/RlrzximvWSrN50mrLLq4i1KFnPyoEDsPo+o?=
 =?us-ascii?Q?ugpDsFaJzvq4KBoHMY/XkTVQPJS7a+BPC5xheQJDXrItARReuFkBVh1eh2Q2?=
 =?us-ascii?Q?HQRwQfO3VHSuw7RSpQPRMmxorNJ98VwWdmgAF/vl99XrTNk2SsQY7tHErtyA?=
 =?us-ascii?Q?Os5wl0uJ5gr0NVS2kTnYqWIo9bz6h3nZ80bnPYre5i1BspxkzFzjHe1pyVES?=
 =?us-ascii?Q?fDsKUCadud3IsA2sntiQKLjlIRGA/u+LxlhWfrSAOMr2l+MBPdcYJNzuH3Yd?=
 =?us-ascii?Q?UFkJJtgwNfglaUj+E1HaXAN6tmajsfIQ9YW6uv8KGK819Fl7OFI19S/zOPeh?=
 =?us-ascii?Q?edpTeFe69cHyUkxfG8PlRwV/A1zKuM0grqZM6cy4agssJ5ceh8jW6dOI5Kyz?=
 =?us-ascii?Q?XAyJ7bBnuCbKHkknj4Ej2BkpUIZSxvwmdp1QBaQTx6NI9mEquD9+x0KcEy1L?=
 =?us-ascii?Q?f1C1IrRMYwn6y844qFQg5glD2R/X8KjKuTo825FlhT9IffbHC0ihleeOkY5z?=
 =?us-ascii?Q?dQu4KPibxxKOtiUqFgesmWb32ERFVbWHChNrgQgAkNRZzb1Dzwcus78TtjRX?=
 =?us-ascii?Q?EUnJLclEeRxol5VfzFDFX2LNVfWr1vvFZxhQ8fovRr4UNf0056WDS3vEwD8R?=
 =?us-ascii?Q?GnziW99zeyD652dp957OP5CNPkAxt9eOmoj6tgFeYxQYqvNt3lr+9hrpT0lP?=
 =?us-ascii?Q?nuRy/6zPLMhMTIblVSe0BIfcSUYpR1SLfOIn36NK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e397637d-58a2-4a32-85ef-08dac07511df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 04:03:47.2570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2Il3zk+7iyzDdVuY6B4ZGKnirtZtFWraysIWRp3IjYJbH6IelN9kJDdkLxRJypouGY7mE8B/uFZ+9WEhgi3Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070032
X-Proofpoint-GUID: qtF7wVdbMsjJMDSpkd5g92z5PxCP7vz-
X-Proofpoint-ORIG-GUID: qtF7wVdbMsjJMDSpkd5g92z5PxCP7vz-
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

commit 78bba5c812cc651cee51b64b786be926ab7fe2a9 upstream.

While QAing the new xfs_repair quotacheck code, I uncovered a quota
corruption bug resulting from a bad interaction between dquot buffer
initialization and quotacheck.  The bug can be reproduced with the
following sequence:

# mkfs.xfs -f /dev/sdf
# mount /dev/sdf /opt -o usrquota
# su nobody -s /bin/bash -c 'touch /opt/barf'
# sync
# xfs_quota -x -c 'report -ahi' /opt
User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            3      0      0  00 [------]
nobody          1      0      0  00 [------]

# xfs_io -x -c 'shutdown' /opt
# umount /opt
# mount /dev/sdf /opt -o usrquota
# touch /opt/man2
# xfs_quota -x -c 'report -ahi' /opt
User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            1      0      0  00 [------]
nobody          1      0      0  00 [------]

# umount /opt

Notice how the initial quotacheck set the root dquot icount to 3
(rootino, rbmino, rsumino), but after shutdown -> remount -> recovery,
xfs_quota reports that the root dquot has only 1 icount.  We haven't
deleted anything from the filesystem, which means that quota is now
under-counting.  This behavior is not limited to icount or the root
dquot, but this is the shortest reproducer.

I traced the cause of this discrepancy to the way that we handle ondisk
dquot updates during quotacheck vs. regular fs activity.  Normally, when
we allocate a disk block for a dquot, we log the buffer as a regular
(dquot) buffer.  Subsequent updates to the dquots backed by that block
are done via separate dquot log item updates, which means that they
depend on the logged buffer update being written to disk before the
dquot items.  Because individual dquots have their own LSN fields, that
initial dquot buffer must always be recovered.

However, the story changes for quotacheck, which can cause dquot block
allocations but persists the final dquot counter values via a delwri
list.  Because recovery doesn't gate dquot buffer replay on an LSN, this
means that the initial dquot buffer can be replayed over the (newer)
contents that were delwritten at the end of quotacheck.  In effect, this
re-initializes the dquot counters after they've been updated.  If the
log does not contain any other dquot items to recover, the obsolete
dquot contents will not be corrected by log recovery.

Because quotacheck uses a transaction to log the setting of the CHKD
flags in the superblock, we skip quotacheck during the second mount
call, which allows the incorrect icount to remain.

Fix this by changing the ondisk dquot initialization function to use
ordered buffers to write out fresh dquot blocks if it detects that we're
running quotacheck.  If the system goes down before quotacheck can
complete, the CHKD flags will not be set in the superblock and the next
mount will run quotacheck again, which can fix uninitialized dquot
buffers.  This requires amending the defer code to maintaine ordered
buffer state across defer rolls for the sake of the dquot allocation
code.

For regular operations we preserve the current behavior since the dquot
items require properly initialized ondisk dquot records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 10 ++++++-
 fs/xfs/xfs_dquot.c        | 56 ++++++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 22557527cfdb..8cc3faa62404 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -234,10 +234,13 @@ xfs_defer_trans_roll(
 	struct xfs_log_item		*lip;
 	struct xfs_buf			*bplist[XFS_DEFER_OPS_NR_BUFS];
 	struct xfs_inode		*iplist[XFS_DEFER_OPS_NR_INODES];
+	unsigned int			ordered = 0; /* bitmap */
 	int				bpcount = 0, ipcount = 0;
 	int				i;
 	int				error;
 
+	BUILD_BUG_ON(NBBY * sizeof(ordered) < XFS_DEFER_OPS_NR_BUFS);
+
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		switch (lip->li_type) {
 		case XFS_LI_BUF:
@@ -248,7 +251,10 @@ xfs_defer_trans_roll(
 					ASSERT(0);
 					return -EFSCORRUPTED;
 				}
-				xfs_trans_dirty_buf(tp, bli->bli_buf);
+				if (bli->bli_flags & XFS_BLI_ORDERED)
+					ordered |= (1U << bpcount);
+				else
+					xfs_trans_dirty_buf(tp, bli->bli_buf);
 				bplist[bpcount++] = bli->bli_buf;
 			}
 			break;
@@ -289,6 +295,8 @@ xfs_defer_trans_roll(
 	/* Rejoin the buffers and dirty them so the log moves forward. */
 	for (i = 0; i < bpcount; i++) {
 		xfs_trans_bjoin(tp, bplist[i]);
+		if (ordered & (1U << i))
+			xfs_trans_ordered_buf(tp, bplist[i]);
 		xfs_trans_bhold(tp, bplist[i]);
 	}
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9596b86e7de9..6231b155e7f3 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -205,16 +205,18 @@ xfs_qm_adjust_dqtimers(
  */
 STATIC void
 xfs_qm_init_dquot_blk(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_buf_t	*bp)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_buf		*bp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	xfs_dqblk_t	*d;
-	xfs_dqid_t	curid;
-	int		i;
+	struct xfs_dqblk	*d;
+	xfs_dqid_t		curid;
+	unsigned int		qflag;
+	unsigned int		blftype;
+	int			i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
@@ -238,11 +240,39 @@ xfs_qm_init_dquot_blk(
 		}
 	}
 
-	xfs_trans_dquot_buf(tp, bp,
-			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
-			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
-			     XFS_BLF_GDQUOT_BUF)));
-	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
+	if (type & XFS_DQ_USER) {
+		qflag = XFS_UQUOTA_CHKD;
+		blftype = XFS_BLF_UDQUOT_BUF;
+	} else if (type & XFS_DQ_PROJ) {
+		qflag = XFS_PQUOTA_CHKD;
+		blftype = XFS_BLF_PDQUOT_BUF;
+	} else {
+		qflag = XFS_GQUOTA_CHKD;
+		blftype = XFS_BLF_GDQUOT_BUF;
+	}
+
+	xfs_trans_dquot_buf(tp, bp, blftype);
+
+	/*
+	 * quotacheck uses delayed writes to update all the dquots on disk in an
+	 * efficient manner instead of logging the individual dquot changes as
+	 * they are made. However if we log the buffer allocated here and crash
+	 * after quotacheck while the logged initialisation is still in the
+	 * active region of the log, log recovery can replay the dquot buffer
+	 * initialisation over the top of the checked dquots and corrupt quota
+	 * accounting.
+	 *
+	 * To avoid this problem, quotacheck cannot log the initialised buffer.
+	 * We must still dirty the buffer and write it back before the
+	 * allocation transaction clears the log. Therefore, mark the buffer as
+	 * ordered instead of logging it directly. This is safe for quotacheck
+	 * because it detects and repairs allocated but initialized dquot blocks
+	 * in the quota inodes.
+	 */
+	if (!(mp->m_qflags & qflag))
+		xfs_trans_ordered_buf(tp, bp);
+	else
+		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
 /*
-- 
2.35.1

