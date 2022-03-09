Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E7F4D2921
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 07:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiCIGth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 01:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiCIGth (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 01:49:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9182C14EF44
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 22:48:38 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22942nkj010476;
        Wed, 9 Mar 2022 06:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=PiUsk9sP+3nuoDi3olPCpoMmBBXvQzpAD5RC/tmGYLI=;
 b=uiQISApD1fBheGgPR+n/wzIaCkLv0MoD74xIoMPNqV+jxfoMhunOINUYQ4+BYKJggC92
 R6nMvJN8v4qU6hVabvl5rlH7V9yR519S2QUzSx29Hw8u2k5Hwg/Fqy82V/6V83DsgZsm
 Uxci1LdbGO5X8MGni0QooonzklkuriHW+gGaHedFWmB4gQfhnedeKbIcChr80Oqm5C53
 lYkhC0ADWA9hkPzbP4fI/U94KzFb6TeVAce74SwF6G0eFFU3SbYejsMADRL01RSrBHXT
 BOJZH65Mvgj30xKLN4mDey0eppoJmAsYrTUPKC4I71WI7w1vFWLWd0bY6jZjjuB/qtzE 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0s5xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 06:48:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2296ZGsQ187471;
        Wed, 9 Mar 2022 06:48:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 3ekyp2sejm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 06:48:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajlYuhJ8GZ+fGb2sM0NScgYoOkXG5iPkIroG7mQIOQMFgdknZY6W9tscbskg1KjOcIHmXNfyVbJi7GlM7bWaG7f4C66L3kuNmfHHTOqKEstdgSgrwY5H+UGVLTTDuPHL4N0bjDUAMMF9tXH1CZRRAe2bU66e8A17xRwQpwy4J287ibcxPc7PSwSCiia9bQfJUw1Kbel5BRi1erp5A7nrTnkoWYOHJJ9p7/uO/nIdNSV2/8SIHfzyBeTL/m0S1rc7gx0MD4CW2zM5LIW3P2PWW3/ku8iuMXmsMwJP3gGW2lLxx8kyHUKBmgTFJTpyuXb33Q5I4qFUEh85oF0dWXBlcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PiUsk9sP+3nuoDi3olPCpoMmBBXvQzpAD5RC/tmGYLI=;
 b=draJSAQ2PiLZwRQQ4hJdrMfLzlBJeHc44u1aY1KSlwfa4RhvQawnKgsBIKVNH6XaAlDG92tdaxFZ7i8MwZAXnElfOd1wraFq5f0HKCLil7yXKJnxvCP85lWglt4n0160gE8+gNuAqkPLJP85bvD3UpbigOg53Yy75BXN5haB23MXdd3+JETTTJXJm3cagoihiqqkrW7PyKMlmcGVwNyq2j3cNcnODBWkW6gMIU97FgZNM5obiLD3YORSXnqk7gWqrsGE/rO/t0wo8nml9ayJtddIcVJ/NYS07RIJbO04vn+Aqnl3on2iGEIsbFDQPCOkLY8lS69Z6dm+ii+MUGJCzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiUsk9sP+3nuoDi3olPCpoMmBBXvQzpAD5RC/tmGYLI=;
 b=I0L5JIhFMuIfZRtIbavI3IKHC3nT9J/Lf+I3xbxlA58G5wd+Gwv/8zOKooAmxazUwxOvbsBl6NfYRewp9O0o4Cwv9w6xDSIQzgfe0RuqTnamCc+NBA6HJ11QSSTBM+v3Pmnua5eIrdUiXWg8qB31kW16/hQkDVsacbfBNrAgO4k=
Received: from SJ0PR10MB4638.namprd10.prod.outlook.com (2603:10b6:a03:2d8::18)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 06:48:30 +0000
Received: from SJ0PR10MB4638.namprd10.prod.outlook.com
 ([fe80::902e:3a5f:8ec1:9d10]) by SJ0PR10MB4638.namprd10.prod.outlook.com
 ([fe80::902e:3a5f:8ec1:9d10%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 06:48:30 +0000
From:   Denis Efremov <denis.e.efremov@oracle.com>
Cc:     Qu Wenruo <wqu@suse.com>, Hao Sun <sunhao.th@gmail.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Denis Efremov <denis.e.efremov@oracle.com>
Subject: [PATCH] btrfs: unlock newly allocated extent buffer after error
Date:   Wed,  9 Mar 2022 09:47:48 +0300
Message-Id: <20220309064748.160978-1-denis.e.efremov@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <d1a3f31f-2205-6dce-0f33-6611972e48cd@gmx.com>
References: <d1a3f31f-2205-6dce-0f33-6611972e48cd@gmx.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0007.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:b::10) To SJ0PR10MB4638.namprd10.prod.outlook.com
 (2603:10b6:a03:2d8::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 916d9259-6f02-4fec-3587-08da0198d122
X-MS-TrafficTypeDiagnostic: SA2PR10MB4732:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB47327C217D33DF3924E2D11CD30A9@SA2PR10MB4732.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FTR+pKIQyIQak9FaItC53N50dIC+QEa/J1nleFAMrsi+Pjjoa43QgPCTpBSsaYLQUOXcmiqZWqcnx7oMp7vkXAYr/5JSOZnYd/hcaAMAFOuPd7B2QwlNKrTZ0IDXEZ6pJ2un0p/lyFkYIGxV3OUDJCLaRZnDtLVBK3TdIW/2jpd0H1KqRGf9W/pD0rVBqUhO5YmLuyBtbtrZNG18GUyJjrRMcS1afaAaOp3oQXu6sI5N6kPk1SSWVv0IHnip+1MGTDvbGFfef4b1ol1DdUeTK0eRw9ZOUacQMw38S6nuuk9bF8RMFGkOxSXFOVqr9ARGn+nK5EjqYr7oRoe+txAOtErzLiX6u8G7tZuOF13LlukPewkWX1rFmEjOIOS6hyt54I3+EimsW8mSq/zcWcE/m2GHeva+sQOhJ5zoQyhjG0h6Uc9V2+xocrboe1czoSBMymfXMUsbyyEvEOY97bCubTBLBuJH8hINPeaeYFSx7K7gztF73JC0u+Ik4cViiAMUynQGEs7PRpNWhIJsEQ0cpkuqgNXQpeiY6HDYVHdSdrJy69bq0bIyiwVaTZFxFgALMaLAXIZiMVMARnv84AmwCGw2AYh8SK8FB2a+uMXuaVUFyhpPvnEuG2tdm5qFZbk0q0FzCOwwl71z1n5hKJSOb41ScTLQAsw2x9CTYrm9d+nc97voI6oxUpDW+TjnXOj//MBYScjyT5aVXxTmzYciwL/MmDOipiWizTkxxlqIQl927gYsDEzvodkydspUBEUd0tdFSbd7oGJ2P2uKwUMOiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4638.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(5660300002)(6512007)(966005)(54906003)(316002)(66556008)(6506007)(4326008)(8676002)(86362001)(66476007)(66946007)(6666004)(83380400001)(8936002)(508600001)(36756003)(26005)(186003)(103116003)(2906002)(107886003)(109986005)(1076003)(2616005)(38100700002)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XR6+asqddds0R9RLNrtwUTs1w7/6LP4bxCz6BSVsrFNpmyZOZAgT/IUS9dwO?=
 =?us-ascii?Q?YUVO1WQgWfjo+VwRHYcjB3ak5uYUqWf08+B1j581KmmtgLIjtrYKmbHPhBhz?=
 =?us-ascii?Q?XAgKhee1qxCtQuJ7LP0mkPaskMLQqgPcPnU4yZOdabPbeM9Ovj6Dx7d+CPPU?=
 =?us-ascii?Q?mGueeH7vO3sUsrdYxFk1J7Jhw9mVW0aHvg6m+iqqBuaEhxUMug7QpxGcqYhc?=
 =?us-ascii?Q?Jzgw3ANKAh59EEDq7ckaGq1JUJViGqQWLNeU/Icp6GkgxYCTsXuTOpWvZyug?=
 =?us-ascii?Q?PI7qg+DJM7Q9AsN6w+EvCm72y0M2m8DFcuxHeri2nSWqwc5N0HmazQzXJOwt?=
 =?us-ascii?Q?on+C5vzYdWYILTVrMwC5vh7/yrc86HI8cBbLHuIxZZ6jGyEMlbTogmRYqagG?=
 =?us-ascii?Q?x801p8uViM1SJdBJrjd8YahLCcqsBR/DxQbL0o01xWiW7aCDz3bBGfzt/Lgv?=
 =?us-ascii?Q?LUzn2iUKF0nGXmqAZwRpj60hU6DT1vLuQv29HRHy1EjRzNYsRUY1BE2evC1z?=
 =?us-ascii?Q?HaZX9U++DUyPA1RojerNyxoKY8NX6ULDdbpDz0k8hGa999EihB5pJG/7RJ1P?=
 =?us-ascii?Q?5mkhPMG9aba1JZNJv5jD8ZW+KlQ7IUdKJcvBzDA/6fpKI77Hit1gAk/bzWDz?=
 =?us-ascii?Q?khh/eOciyoSF2UGlwIvtYh7jNC6u7ZS5npxz+b4k5abKu3hjc6sC7WTr65I+?=
 =?us-ascii?Q?/I6+N1aMEVTY7ezd2DnBSpeBgv6hwq7siKC+48ILvbXUxv1pQRrz5+WuhKWD?=
 =?us-ascii?Q?DT582WPbDxy47PR84NtTz4T5WxK8l3y5+jFHO+6KhReSDGhFlb0uLm3kJqrf?=
 =?us-ascii?Q?Kz3fP9GoJvZn2csEq6nLGczzGTrUWEHvUEN/AtwPtG/cgvnGi9/DUXJ7rQYx?=
 =?us-ascii?Q?9k5fVU0oytsY36wWYEHldirScoBJxFgOdLuE70meiiVy/HFikFWI5WOIdeS5?=
 =?us-ascii?Q?ux48vRDpi0hcyG0PLlJwWNSRb1vXYpDhNz6y9A/Z+Cn8IuVrlCMeNyDmnS9b?=
 =?us-ascii?Q?gKTKSmaHbV9bDdT9YvvvhdzBWvIez+bmAGY6ibAWfR+gch7h1w1xdTCmVMur?=
 =?us-ascii?Q?A3u+i1AzuUHcf+jQMfpPzbDJ2NIUEFvH+o0dpnL3AmYwFfnUtxbUeycMNQ1f?=
 =?us-ascii?Q?O4hcimNfKnzM0yCyDYT9jIiqLjDQKXVTUiHt/H9350JtQDd9htfvv8ciAW5+?=
 =?us-ascii?Q?kg6Tvv3PIMIn2e2+fwSv0p34bOVAUQZsAJvSHA4wS4zzQIF+AGPePbYWV6IY?=
 =?us-ascii?Q?LohkqZYqcYRSfPLcj5DJvOBYWH+UwEBR/JPLUs/qo8OOYh865rNSpQCLLNBo?=
 =?us-ascii?Q?cTqILC+zD2AOfbgQB6M62EQtkVLSc9O+ybv0D2FGIGdwHfGBZC/bdkP4+4/X?=
 =?us-ascii?Q?X2t6l6wx3oJRHfzs2ewknyj2cLJSIa+3+xXjm8FESh61CPAyFwzGfqvVHNQi?=
 =?us-ascii?Q?J9GyzKAB3AoUve6WQBXNUUkWuqKikUpjH70Cn0c5GMy7bWNcMyIxzHKctLG3?=
 =?us-ascii?Q?WX9jcJrE12eoM/4BK3Pxu33asb8b2QadixSPstxHC1WXarVO9RQsy5hO8Pp+?=
 =?us-ascii?Q?EhwjCa2Vkp7UKFEXPaSxUdlGlTOGU4ftcR8qGx8kzg2BYWWiCd1Gbmtx6I9s?=
 =?us-ascii?Q?9j3UAZcDDtL56Ffq4TOlrMgn9zCuCgqyfbxJrzzVzNbBuNzWDycOukiE4LJ7?=
 =?us-ascii?Q?U/TN6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 916d9259-6f02-4fec-3587-08da0198d122
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4638.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 06:48:30.0480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qiLDXAMRH3a2hKoX1ePWdVF/iqaW5sFfcwt1LXd/N0U90atw3qw+GgGg+Fnq0D4s6EwFQA6OCxAQlD1BfR01GYb6FqU75VGXOMZMreDpgqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203090036
X-Proofpoint-ORIG-GUID: FKIrbzoOUn0W9ApL9xZ5jNS1PgrEIk1S
X-Proofpoint-GUID: FKIrbzoOUn0W9ApL9xZ5jNS1PgrEIk1S
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 19ea40dddf1833db868533958ca066f368862211 upstream.

[BUG]
There is a bug report that injected ENOMEM error could leave a tree
block locked while we return to user-space:

  BTRFS info (device loop0): enabling ssd optimizations
  FAULT_INJECTION: forcing a failure.
  name failslab, interval 1, probability 0, space 0, times 0
  CPU: 0 PID: 7579 Comm: syz-executor Not tainted 5.15.0-rc1 #16
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
  Call Trace:
   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0x8d/0xcf lib/dump_stack.c:106
   fail_dump lib/fault-inject.c:52 [inline]
   should_fail+0x13c/0x160 lib/fault-inject.c:146
   should_failslab+0x5/0x10 mm/slab_common.c:1328
   slab_pre_alloc_hook.constprop.99+0x4e/0xc0 mm/slab.h:494
   slab_alloc_node mm/slub.c:3120 [inline]
   slab_alloc mm/slub.c:3214 [inline]
   kmem_cache_alloc+0x44/0x280 mm/slub.c:3219
   btrfs_alloc_delayed_extent_op fs/btrfs/delayed-ref.h:299 [inline]
   btrfs_alloc_tree_block+0x38c/0x670 fs/btrfs/extent-tree.c:4833
   __btrfs_cow_block+0x16f/0x7d0 fs/btrfs/ctree.c:415
   btrfs_cow_block+0x12a/0x300 fs/btrfs/ctree.c:570
   btrfs_search_slot+0x6b0/0xee0 fs/btrfs/ctree.c:1768
   btrfs_insert_empty_items+0x80/0xf0 fs/btrfs/ctree.c:3905
   btrfs_new_inode+0x311/0xa60 fs/btrfs/inode.c:6530
   btrfs_create+0x12b/0x270 fs/btrfs/inode.c:6783
   lookup_open+0x660/0x780 fs/namei.c:3282
   open_last_lookups fs/namei.c:3352 [inline]
   path_openat+0x465/0xe20 fs/namei.c:3557
   do_filp_open+0xe3/0x170 fs/namei.c:3588
   do_sys_openat2+0x357/0x4a0 fs/open.c:1200
   do_sys_open+0x87/0xd0 fs/open.c:1216
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x46ae99
  Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
  89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
  01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007f46711b9c48 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
  RAX: ffffffffffffffda RBX: 000000000078c0a0 RCX: 000000000046ae99
  RDX: 0000000000000000 RSI: 00000000000000a1 RDI: 0000000020005800
  RBP: 00007f46711b9c80 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000017
  R13: 0000000000000000 R14: 000000000078c0a0 R15: 00007ffc129da6e0

  ================================================
  WARNING: lock held when returning to user space!
  5.15.0-rc1 #16 Not tainted
  ------------------------------------------------
  syz-executor/7579 is leaving the kernel with locks still held!
  1 lock held by syz-executor/7579:
   #0: ffff888104b73da8 (btrfs-tree-01/1){+.+.}-{3:3}, at:
  __btrfs_tree_lock+0x2e/0x1a0 fs/btrfs/locking.c:112

[CAUSE]
In btrfs_alloc_tree_block(), after btrfs_init_new_buffer(), the new
extent buffer @buf is locked, but if later operations like adding
delayed tree ref fail, we just free @buf without unlocking it,
resulting above warning.

[FIX]
Unlock @buf in out_free_buf: label.

Reported-by: Hao Sun <sunhao.th@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CACkBjsZ9O6Zr0KK1yGn=1rQi6Crh1yeCRdTSBxx9R99L4xdn-Q@mail.gmail.com/
CC: stable@vger.kernel.org # 4.1+
Fixes: 67b7859e9bfa ("btrfs: handle ENOMEM in btrfs_alloc_tree_block")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
---
I added Fixes tag and changed kernel version in "CC: stable@..." line.

 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bf46ed74eae6..d71f800e8bf6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8327,6 +8327,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 out_free_delayed:
 	btrfs_free_delayed_extent_op(extent_op);
 out_free_buf:
+	btrfs_tree_unlock(buf);
 	free_extent_buffer(buf);
 out_free_reserved:
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 0);
-- 
2.35.1

