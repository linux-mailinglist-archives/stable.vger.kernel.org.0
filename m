Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2574D4E1967
	for <lists+stable@lfdr.de>; Sun, 20 Mar 2022 03:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbiCTCFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 22:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiCTCFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 22:05:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDA413F7B;
        Sat, 19 Mar 2022 19:04:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JDh87O027688;
        Sun, 20 Mar 2022 02:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VX5gUWbY4cpl+TWWcFbSDTSbg+4+6qAZkNUrIdUCg8w=;
 b=M6iN4QMvWOlGzEwVFDCxQcWD36UCGR9c5u/EWOIxZxgTJurKCByMqQvX+av5nKgQDlsk
 c89itrpP6NZqNmTb64aI1fCDXvXBth9SqPb4C51qaiKFzmFB1vCZ9A7nTvpLZmGlwJYr
 WXPTQLnhn21yG4cnTrqeyM5fl5bJbhjebytoR/X9dA21QafDs7dOmpyWiTvl4k7AQlko
 Y3MrAo8cDgNGjsBWTeYAuay148r8JSDVifEjHjFt29mfe9i9l69kjEd5fCVlPj+S7tMJ
 XQfIH5Z8+JW3yopOPLZ2AbsX+f5qKh37ohp4ic5PAObQDMmWuwWFxo1NBHhiY6W5PEev rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1rx2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 02:04:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K1ua5u023073;
        Sun, 20 Mar 2022 02:04:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3ew8mg7xbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 02:04:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0Mr4TA8hp0/wjhkC+QMN+F3YQZ0PdyS1c3CU/+XfBgm67pRkKU/ZCj8uXsEXUS+rgjy/rE72p5xTNLydidZp6b6HDCQqvFDGtK+shcpKy05Xt/BoEFUFQJVJUhZKcOlwgeSWrocZ5TUmoO9e19Fd19IfA69hSqjHRjnUbFmSJ65/i0woFa1xkOl+XyVDH0jLzw6fgRaG5OgWKrR13axT8jx2b2Hll1VWerYW66weG1xbvgtsWLixE8B8mJ+Z0kewEhu5b6DhqVWWTI8zQL98tZj++jB2+hRYZVNSVRPTK6p/kq9TiJmqHAibyHsY47XLkV1u/gikmBG7p3q2OP1Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VX5gUWbY4cpl+TWWcFbSDTSbg+4+6qAZkNUrIdUCg8w=;
 b=Q66VYmmJJ/XKtcsZogYqxXk8OcI/HkNUSo1IkK9avmKsj6s84zBmy+n8AAQoim+0KFvs12Mq1DqG3pO9AVZF06/AAoazou6ErYQjM4mrX5FI8HgRE4l7nXaIdrzIRohqqh0V0iUw+p+Zfdgg6JbxbogE8qx55Yfw5zc0PhVWwVCj+TGBFkgdcZwnWFQferfREvh5GGSXasBuxTtLMo9/VJcprzpvUwLD43zAfmomolcjWG5VPdQcwGYKfqf7DUdMHdZxYNmm3IEQ6fHLcNsaWJnGe8CIreylkHh7x+5984ObuZCiOAUWdVlorhTKaEENcC2EoE1Ko0KPNH+Wo6uAzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VX5gUWbY4cpl+TWWcFbSDTSbg+4+6qAZkNUrIdUCg8w=;
 b=Amb5stluLCkTLgc8LYU9tSaqJY8IGGUlUaxtk/CA63KdSBm3MMWInIvzudU1mw1PArHbtIX/ckC+pADegHJ7HPPxTPS6BV5udgkOKS0EixlO+drXhp52f9xTRSeZT2Y9pqmHepD9179BkSptznE0W4fJJQPEef8/89XJ9lMyGN0=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by SA2PR10MB4556.namprd10.prod.outlook.com (2603:10b6:806:119::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Sun, 20 Mar
 2022 02:04:09 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d469:7ab:8ae2:1e6f]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d469:7ab:8ae2:1e6f%5]) with mapi id 15.20.5081.014; Sun, 20 Mar 2022
 02:04:09 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH stable-5.15.y, stable-5.16.y] btrfs: skip reserved bytes warning on unmount after log cleanup failure
Date:   Sun, 20 Mar 2022 10:03:17 +0800
Message-Id: <25358f0838c5a22923a8163e38415acaca94b01d.1647741632.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0089.apcprd03.prod.outlook.com
 (2603:1096:4:7c::17) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d03f11cb-455b-4f59-fab2-08da0a15eb74
X-MS-TrafficTypeDiagnostic: SA2PR10MB4556:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB45562562880FE9BD12F25FE7E5159@SA2PR10MB4556.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GS3woBwCfOW4tIvEWfB7HPQd6/wB8EYhyaIYPEQuYBoOiG9VHFVR4RZod9OzQnjbShkSrRtJeo2x1DdEAS+Cp925FqBz6BP22L147zvsHw/HYfoJXstLANPd2JneHcTtJGjW1WII2rUojfyoeDLUW0QJnXYb2ShmqaXmXTaNpXLAG8OLY/TwZQIzb3FL4CTkeG+Vv2DZZheapS9zgEDkBrUVjIVsKDGZUIlIgyTNc5fJcyJFt1LCV6jsVLOu+t581W47si2bfHZyOAefX+Kj2qSfGrWmkYXsv7if6gtKl/0XjQF68OBpuh+qXOdlcHyDfWn6o8p2Eik+58BPzrxzM9WHYsGjTcNHpLEr4Ovbk1baeW1Nw2169xW8HqcIbc7r+nMBznB47x4sybNqv3UaFmycsqwD29GOZDTEcvW/F6kTbMagd0ImKnPIRe9RnayP/pgIMsq3hwJdg1DMp/zNXQVJqfBqYJU7lEBIjxPQ45n4X9N3c5t6E7VdpYpepWyqKkPF/KgWX06asO1MPh6yZC2LWLkzX9NwvjvPNKunaInnmlgYSvcVETdsR6i/l5MX2KGrcYHNtJuBZChmlLvYm/h3PRS8LDzJ+ke3WoM+Vs20HGl6ISgqCTCRM7P+KSvxQvncB8+OrPqFL8at3i0F8G64yCh1VF3n/KxcgK+sFB/0IX1XMXaMMAeNVZH+AprsjFBNmTQ67leZCkmJTRvwT5mKTATLygp4JPvtuegqYt6RKOZQ6hPrfGhfvXgjPRjjSDVMV9Xaj/dE5yXhcVSZjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(8936002)(30864003)(5660300002)(6666004)(66476007)(4326008)(6486002)(38100700002)(966005)(66946007)(45080400002)(44832011)(86362001)(66556008)(2616005)(26005)(107886003)(186003)(83380400001)(6506007)(6512007)(2906002)(36756003)(6916009)(54906003)(316002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/PM9e1gKW9hLCbdOFaLXzBDWeGte9EXHT70BD3MotMhjFtXKXHZ0cPMW2u9Y?=
 =?us-ascii?Q?N1924WkCm/gZLjYusEIlC8JTcdgS872jZ4xE1U/MXTuh59abdSceKSydu16t?=
 =?us-ascii?Q?oe8D6ZKZJKzASpQaAzgcPAqRbdlD9kQJ67XkKmcQqURLsulIBg0Xo1U/taGX?=
 =?us-ascii?Q?Iv+JXX25egxmvn2tAo0eBQvmWeuFLnUsdtkaJDd7YJPU5G7noH5mqr0QzHYL?=
 =?us-ascii?Q?+PmTidC24YAhgQuN84Y1q42Qva/AJ7fETmyIxomuMIPv7P8zKJuH73hG5JKb?=
 =?us-ascii?Q?V9jyVhStREvVFH0yHeZnwcCMp2LzsrFH1iGLNMfSWifvJRk1hOOxOniwtxB4?=
 =?us-ascii?Q?4z1c4kbIL0l/qu2jTfVJxvRoNmaJG6F+JokM4jo6WmhLkSNnRvi6BZaDVzSZ?=
 =?us-ascii?Q?qTcaHvLbodbKCvfC69mPzhSt0w6rVcAbloi3AQGiOWT5t761vtFBO77ujIph?=
 =?us-ascii?Q?QFrkDBTL6DiTtmaNxVOQRpTLAfQQIpm8K8sQOosvfp4xQsYrRiI14KCrzxrI?=
 =?us-ascii?Q?G6TZ9mL0SlYT0D4ArkRJ77wY2EUBDwtaKs4jotWG9GAfTUP/caX+6yjg/cQH?=
 =?us-ascii?Q?LaQIQ2IhvTm3tuG+frSwIg6DZucmd1Bc/gBnSyPGQykXwTELdoYGzdbMbHKM?=
 =?us-ascii?Q?bqfp1gKjMjVnLwhH6vc5qaHS3UYnZB6Ap6ywTI1yg+piT2+Vwt98fiv0TW+3?=
 =?us-ascii?Q?6KzFbiizBD/YEGL1SFnyWKKfGRF9vL28Xdposza0vpy7+4+KiNw5JIudiJXr?=
 =?us-ascii?Q?Wplw46zoZg/KetpcRf3hzuPrOVrFyi8tfEseYyfJJrTEbRY130ZgdrWxuX0W?=
 =?us-ascii?Q?VgAEGM1HmWXVQgFjTNop92mbQ0VkOr7KjGo8wrZlyl7W1WdIC+aRjyMu1t5x?=
 =?us-ascii?Q?kjqrrREH3FfCP1iwJHIYhtP3cZq56jQoDaiLPuHJb3t0bIFD6uSSYmJ//Fnw?=
 =?us-ascii?Q?DmAR2vQU+B2cJ31hABcAlttXcFBvEi+2NP0zGh5sxg+CmU2HG7nZMzSVBUPG?=
 =?us-ascii?Q?6Iu4ElnuFnu00SPeOfew5Y+pfMZdbqmiKU3o16rotFXmNuwB1fIzoIDhPN7L?=
 =?us-ascii?Q?X22FAtkj1cj5v07995gVhMUaB9RCl6Uf6wMEFn8dxEHVm43DW1EqFmzXw1EK?=
 =?us-ascii?Q?JakgA2XW5h67gRgTtP8xdNfQTTiZsEJOPUinoPAMbaeScKfloro4MckKPnO3?=
 =?us-ascii?Q?Nj+T9U9SWD02xly5M09YSRbgrUgcwNj+uxBH1ipEvb6vsOwf4fb327x+s35N?=
 =?us-ascii?Q?AhtCE34IW5nGKM9ytMQZ8Ikf+VC2a2gRKUswlMpOOD6/RacsDTuwTxVd84Tq?=
 =?us-ascii?Q?7tH5lpjlZqk6/pboSXMMl4P8xrpeiwJ0l+SKoul2V/37PX6//e+uk4e8EmC3?=
 =?us-ascii?Q?F4Nxq0KfjAAFUnDIvzVVvEbIJZlBZSXSlqPRUJ3XmR0x/wzMqmdYXW/+dbKG?=
 =?us-ascii?Q?9pSk94dokH/OKT5N3MFx/+tdPY2ygGHV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d03f11cb-455b-4f59-fab2-08da0a15eb74
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 02:04:09.3185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JdD0OPiNKYU+kmq+wOne7tZJBDv9z8KoeDo2eT6WFBdUorALCojlUzv10/9cFc+ZrnbWNArzzg65WD9jLBThvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4556
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200012
X-Proofpoint-GUID: 3Xe8WJhgsiUrgOQifgrzXccJINtiBI1h
X-Proofpoint-ORIG-GUID: 3Xe8WJhgsiUrgOQifgrzXccJINtiBI1h
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

Commit 40cdc509877bacb438213b83c7541c5e24a1d9ec upstream

After the recent changes made by commit c2e39305299f01 ("btrfs: clear
extent buffer uptodate when we fail to write it") and its followup fix,
commit 651740a5024117 ("btrfs: check WRITE_ERR when trying to read an
extent buffer"), we can now end up not cleaning up space reservations of
log tree extent buffers after a transaction abort happens, as well as not
cleaning up still dirty extent buffers.

This happens because if writeback for a log tree extent buffer failed,
then we have cleared the bit EXTENT_BUFFER_UPTODATE from the extent buffer
and we have also set the bit EXTENT_BUFFER_WRITE_ERR on it. Later on,
when trying to free the log tree with free_log_tree(), which iterates
over the tree, we can end up getting an -EIO error when trying to read
a node or a leaf, since read_extent_buffer_pages() returns -EIO if an
extent buffer does not have EXTENT_BUFFER_UPTODATE set and has the
EXTENT_BUFFER_WRITE_ERR bit set. Getting that -EIO means that we return
immediately as we can not iterate over the entire tree.

In that case we never update the reserved space for an extent buffer in
the respective block group and space_info object.

When this happens we get the following traces when unmounting the fs:

[174957.284509] BTRFS: error (device dm-0) in cleanup_transaction:1913: errno=-5 IO failure
[174957.286497] BTRFS: error (device dm-0) in free_log_tree:3420: errno=-5 IO failure
[174957.399379] ------------[ cut here ]------------
[174957.402497] WARNING: CPU: 2 PID: 3206883 at fs/btrfs/block-group.c:127 btrfs_put_block_group+0x77/0xb0 [btrfs]
[174957.407523] Modules linked in: btrfs overlay dm_zero (...)
[174957.424917] CPU: 2 PID: 3206883 Comm: umount Tainted: G        W         5.16.0-rc5-btrfs-next-109 #1
[174957.426689] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[174957.428716] RIP: 0010:btrfs_put_block_group+0x77/0xb0 [btrfs]
[174957.429717] Code: 21 48 8b bd (...)
[174957.432867] RSP: 0018:ffffb70d41cffdd0 EFLAGS: 00010206
[174957.433632] RAX: 0000000000000001 RBX: ffff8b09c3848000 RCX: ffff8b0758edd1c8
[174957.434689] RDX: 0000000000000001 RSI: ffffffffc0b467e7 RDI: ffff8b0758edd000
[174957.436068] RBP: ffff8b0758edd000 R08: 0000000000000000 R09: 0000000000000000
[174957.437114] R10: 0000000000000246 R11: 0000000000000000 R12: ffff8b09c3848148
[174957.438140] R13: ffff8b09c3848198 R14: ffff8b0758edd188 R15: dead000000000100
[174957.439317] FS:  00007f328fb82800(0000) GS:ffff8b0a2d200000(0000) knlGS:0000000000000000
[174957.440402] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[174957.441164] CR2: 00007fff13563e98 CR3: 0000000404f4e005 CR4: 0000000000370ee0
[174957.442117] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[174957.443076] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[174957.443948] Call Trace:
[174957.444264]  <TASK>
[174957.444538]  btrfs_free_block_groups+0x255/0x3c0 [btrfs]
[174957.445238]  close_ctree+0x301/0x357 [btrfs]
[174957.445803]  ? call_rcu+0x16c/0x290
[174957.446250]  generic_shutdown_super+0x74/0x120
[174957.446832]  kill_anon_super+0x14/0x30
[174957.447305]  btrfs_kill_super+0x12/0x20 [btrfs]
[174957.447890]  deactivate_locked_super+0x31/0xa0
[174957.448440]  cleanup_mnt+0x147/0x1c0
[174957.448888]  task_work_run+0x5c/0xa0
[174957.449336]  exit_to_user_mode_prepare+0x1e5/0x1f0
[174957.449934]  syscall_exit_to_user_mode+0x16/0x40
[174957.450512]  do_syscall_64+0x48/0xc0
[174957.450980]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[174957.451605] RIP: 0033:0x7f328fdc4a97
[174957.452059] Code: 03 0c 00 f7 (...)
[174957.454320] RSP: 002b:00007fff13564ec8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[174957.455262] RAX: 0000000000000000 RBX: 00007f328feea264 RCX: 00007f328fdc4a97
[174957.456131] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000560b8ae51dd0
[174957.457118] RBP: 0000560b8ae51ba0 R08: 0000000000000000 R09: 00007fff13563c40
[174957.458005] R10: 00007f328fe49fc0 R11: 0000000000000246 R12: 0000000000000000
[174957.459113] R13: 0000560b8ae51dd0 R14: 0000560b8ae51cb0 R15: 0000000000000000
[174957.460193]  </TASK>
[174957.460534] irq event stamp: 0
[174957.461003] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[174957.461947] hardirqs last disabled at (0): [<ffffffffb0e94214>] copy_process+0x934/0x2040
[174957.463147] softirqs last  enabled at (0): [<ffffffffb0e94214>] copy_process+0x934/0x2040
[174957.465116] softirqs last disabled at (0): [<0000000000000000>] 0x0
[174957.466323] ---[ end trace bc7ee0c490bce3af ]---
[174957.467282] ------------[ cut here ]------------
[174957.468184] WARNING: CPU: 2 PID: 3206883 at fs/btrfs/block-group.c:3976 btrfs_free_block_groups+0x330/0x3c0 [btrfs]
[174957.470066] Modules linked in: btrfs overlay dm_zero (...)
[174957.483137] CPU: 2 PID: 3206883 Comm: umount Tainted: G        W         5.16.0-rc5-btrfs-next-109 #1
[174957.484691] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[174957.486853] RIP: 0010:btrfs_free_block_groups+0x330/0x3c0 [btrfs]
[174957.488050] Code: 00 00 00 ad de (...)
[174957.491479] RSP: 0018:ffffb70d41cffde0 EFLAGS: 00010206
[174957.492520] RAX: ffff8b08d79310b0 RBX: ffff8b09c3848000 RCX: 0000000000000000
[174957.493868] RDX: 0000000000000001 RSI: fffff443055ee600 RDI: ffffffffb1131846
[174957.495183] RBP: ffff8b08d79310b0 R08: 0000000000000000 R09: 0000000000000000
[174957.496580] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8b08d7931000
[174957.498027] R13: ffff8b09c38492b0 R14: dead000000000122 R15: dead000000000100
[174957.499438] FS:  00007f328fb82800(0000) GS:ffff8b0a2d200000(0000) knlGS:0000000000000000
[174957.500990] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[174957.502117] CR2: 00007fff13563e98 CR3: 0000000404f4e005 CR4: 0000000000370ee0
[174957.503513] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[174957.504864] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[174957.506167] Call Trace:
[174957.506654]  <TASK>
[174957.507047]  close_ctree+0x301/0x357 [btrfs]
[174957.507867]  ? call_rcu+0x16c/0x290
[174957.508567]  generic_shutdown_super+0x74/0x120
[174957.509447]  kill_anon_super+0x14/0x30
[174957.510194]  btrfs_kill_super+0x12/0x20 [btrfs]
[174957.511123]  deactivate_locked_super+0x31/0xa0
[174957.511976]  cleanup_mnt+0x147/0x1c0
[174957.512610]  task_work_run+0x5c/0xa0
[174957.513309]  exit_to_user_mode_prepare+0x1e5/0x1f0
[174957.514231]  syscall_exit_to_user_mode+0x16/0x40
[174957.515069]  do_syscall_64+0x48/0xc0
[174957.515718]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[174957.516688] RIP: 0033:0x7f328fdc4a97
[174957.517413] Code: 03 0c 00 f7 d8 (...)
[174957.521052] RSP: 002b:00007fff13564ec8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[174957.522514] RAX: 0000000000000000 RBX: 00007f328feea264 RCX: 00007f328fdc4a97
[174957.523950] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000560b8ae51dd0
[174957.525375] RBP: 0000560b8ae51ba0 R08: 0000000000000000 R09: 00007fff13563c40
[174957.526763] R10: 00007f328fe49fc0 R11: 0000000000000246 R12: 0000000000000000
[174957.528058] R13: 0000560b8ae51dd0 R14: 0000560b8ae51cb0 R15: 0000000000000000
[174957.529404]  </TASK>
[174957.529843] irq event stamp: 0
[174957.530256] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[174957.531061] hardirqs last disabled at (0): [<ffffffffb0e94214>] copy_process+0x934/0x2040
[174957.532075] softirqs last  enabled at (0): [<ffffffffb0e94214>] copy_process+0x934/0x2040
[174957.533083] softirqs last disabled at (0): [<0000000000000000>] 0x0
[174957.533865] ---[ end trace bc7ee0c490bce3b0 ]---
[174957.534452] BTRFS info (device dm-0): space_info 4 has 1070841856 free, is not full
[174957.535404] BTRFS info (device dm-0): space_info total=1073741824, used=2785280, pinned=0, reserved=49152, may_use=0, readonly=65536 zone_unusable=0
[174957.537029] BTRFS info (device dm-0): global_block_rsv: size 0 reserved 0
[174957.537859] BTRFS info (device dm-0): trans_block_rsv: size 0 reserved 0
[174957.538697] BTRFS info (device dm-0): chunk_block_rsv: size 0 reserved 0
[174957.539552] BTRFS info (device dm-0): delayed_block_rsv: size 0 reserved 0
[174957.540403] BTRFS info (device dm-0): delayed_refs_rsv: size 0 reserved 0

This also means that in case we have log tree extent buffers that are
still dirty, we can end up not cleaning them up in case we find an
extent buffer with EXTENT_BUFFER_WRITE_ERR set on it, as in that case
we have no way for iterating over the rest of the tree.

This issue is very often triggered with test cases generic/475 and
generic/648 from fstests.

The issue could almost be fixed by iterating over the io tree attached to
each log root which keeps tracks of the range of allocated extent buffers,
log_root->dirty_log_pages, however that does not work and has some
inconveniences:

1) After we sync the log, we clear the range of the extent buffers from
   the io tree, so we can't find them after writeback. We could keep the
   ranges in the io tree, with a separate bit to signal they represent
   extent buffers already written, but that means we need to hold into
   more memory until the transaction commits.

   How much more memory is used depends a lot on whether we are able to
   allocate contiguous extent buffers on disk (and how often) for a log
   tree - if we are able to, then a single extent state record can
   represent multiple extent buffers, otherwise we need multiple extent
   state record structures to track each extent buffer.
   In fact, my earlier approach did that:

   https://lore.kernel.org/linux-btrfs/3aae7c6728257c7ce2279d6660ee2797e5e34bbd.1641300250.git.fdmanana@suse.com/

   However that can cause a very significant negative impact on
   performance, not only due to the extra memory usage but also because
   we get a larger and deeper dirty_log_pages io tree.
   We got a report that, on beefy machines at least, we can get such
   performance drop with fsmark for example:

   https://lore.kernel.org/linux-btrfs/20220117082426.GE32491@xsang-OptiPlex-9020/

2) We would be doing it only to deal with an unexpected and exceptional
   case, which is basically failure to read an extent buffer from disk
   due to IO failures. On a healthy system we don't expect transaction
   aborts to happen after all;

3) Instead of relying on iterating the log tree or tracking the ranges
   of extent buffers in the dirty_log_pages io tree, using the radix
   tree that tracks extent buffers (fs_info->buffer_radix) to find all
   log tree extent buffers is not reliable either, because after writeback
   of an extent buffer it can be evicted from memory by the release page
   callback of the btree inode (btree_releasepage()).

Since there's no way to be able to properly cleanup a log tree without
being able to read its extent buffers from disk and without using more
memory to track the logical ranges of the allocated extent buffers do
the following:

1) When we fail to cleanup a log tree, setup a flag that indicates that
   failure;

2) Trigger writeback of all log tree extent buffers that are still dirty,
   and wait for the writeback to complete. This is just to cleanup their
   state, page states, page leaks, etc;

3) When unmounting the fs, ignore if the number of bytes reserved in a
   block group and in a space_info is not 0 if, and only if, we failed to
   cleanup a log tree. Also ignore only for metadata block groups and the
   metadata space_info object.

This is far from a perfect solution, but it serves to silence test
failures such as those from generic/475 and generic/648. However having
a non-zero value for the reserved bytes counters on unmount after a
transaction abort, is not such a terrible thing and it's completely
harmless, it does not affect the filesystem integrity in any way.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Unrelated conflict fix in
  fs/btrfs/ctree.h

 fs/btrfs/block-group.c | 26 ++++++++++++++++++++++++--
 fs/btrfs/ctree.h       |  7 +++++++
 fs/btrfs/tree-log.c    | 23 +++++++++++++++++++++++
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 5edd07e0232d..e1c5c2114edf 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -123,7 +123,16 @@ void btrfs_put_block_group(struct btrfs_block_group *cache)
 {
 	if (refcount_dec_and_test(&cache->refs)) {
 		WARN_ON(cache->pinned > 0);
-		WARN_ON(cache->reserved > 0);
+		/*
+		 * If there was a failure to cleanup a log tree, very likely due
+		 * to an IO failure on a writeback attempt of one or more of its
+		 * extent buffers, we could not do proper (and cheap) unaccounting
+		 * of their reserved space, so don't warn on reserved > 0 in that
+		 * case.
+		 */
+		if (!(cache->flags & BTRFS_BLOCK_GROUP_METADATA) ||
+		    !BTRFS_FS_LOG_CLEANUP_ERROR(cache->fs_info))
+			WARN_ON(cache->reserved > 0);
 
 		/*
 		 * A block_group shouldn't be on the discard_list anymore.
@@ -3888,9 +3897,22 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		 * important and indicates a real bug if this happens.
 		 */
 		if (WARN_ON(space_info->bytes_pinned > 0 ||
-			    space_info->bytes_reserved > 0 ||
 			    space_info->bytes_may_use > 0))
 			btrfs_dump_space_info(info, space_info, 0, 0);
+
+		/*
+		 * If there was a failure to cleanup a log tree, very likely due
+		 * to an IO failure on a writeback attempt of one or more of its
+		 * extent buffers, we could not do proper (and cheap) unaccounting
+		 * of their reserved space, so don't warn on bytes_reserved > 0 in
+		 * that case.
+		 */
+		if (!(space_info->flags & BTRFS_BLOCK_GROUP_METADATA) ||
+		    !BTRFS_FS_LOG_CLEANUP_ERROR(info)) {
+			if (WARN_ON(space_info->bytes_reserved > 0))
+				btrfs_dump_space_info(info, space_info, 0, 0);
+		}
+
 		WARN_ON(space_info->reclaim_size > 0);
 		list_del(&space_info->list);
 		btrfs_sysfs_remove_space_info(space_info);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e89f814cc8f5..21c44846b002 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -142,6 +142,9 @@ enum {
 	BTRFS_FS_STATE_DEV_REPLACING,
 	/* The btrfs_fs_info created for self-tests */
 	BTRFS_FS_STATE_DUMMY_FS_INFO,
+
+	/* Indicates there was an error cleaning up a log tree. */
+	BTRFS_FS_STATE_LOG_CLEANUP_ERROR,
 };
 
 #define BTRFS_BACKREF_REV_MAX		256
@@ -3578,6 +3581,10 @@ do {								\
 			  (errno), fmt, ##args);		\
 } while (0)
 
+#define BTRFS_FS_LOG_CLEANUP_ERROR(fs_info)				\
+	(unlikely(test_bit(BTRFS_FS_STATE_LOG_CLEANUP_ERROR,		\
+			   &(fs_info)->fs_state)))
+
 __printf(5, 6)
 __cold
 void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8ef65073ce8c..e90d80a8a9e3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3423,6 +3423,29 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 	if (log->node) {
 		ret = walk_log_tree(trans, log, &wc);
 		if (ret) {
+			/*
+			 * We weren't able to traverse the entire log tree, the
+			 * typical scenario is getting an -EIO when reading an
+			 * extent buffer of the tree, due to a previous writeback
+			 * failure of it.
+			 */
+			set_bit(BTRFS_FS_STATE_LOG_CLEANUP_ERROR,
+				&log->fs_info->fs_state);
+
+			/*
+			 * Some extent buffers of the log tree may still be dirty
+			 * and not yet written back to storage, because we may
+			 * have updates to a log tree without syncing a log tree,
+			 * such as during rename and link operations. So flush
+			 * them out and wait for their writeback to complete, so
+			 * that we properly cleanup their state and pages.
+			 */
+			btrfs_write_marked_extents(log->fs_info,
+						   &log->dirty_log_pages,
+						   EXTENT_DIRTY | EXTENT_NEW);
+			btrfs_wait_tree_log_extents(log,
+						    EXTENT_DIRTY | EXTENT_NEW);
+
 			if (trans)
 				btrfs_abort_transaction(trans, ret);
 			else
-- 
2.33.1

