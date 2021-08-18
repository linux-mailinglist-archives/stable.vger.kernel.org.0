Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F443F0745
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhHRO7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 10:59:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32954 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238483AbhHRO7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 10:59:36 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IEuJCE002568;
        Wed, 18 Aug 2021 14:58:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=AvwWt+haSqijJ92YK3xYkxaHiq1Kl/6r9Q2eIHDZLEI=;
 b=dVxNz/7ZimIa/zEmX2uTr/M6uX5T5p2XQe8sKy+nnmA25u8KVPoQjmQzch1FuNKJ1S5N
 6JwQYbyrEeKqc7wbC8baTqjslXleq8JOlxMPT/V1G/kBRC+w4+zDMBWqDoY/i0zWKmdR
 pmGwjbVTDQw2XUglKrMTeDokZl8FnPg2Zizb+nMBVYBtRnZDZnl8cAI8oFrtkc9p7mSH
 61ciLoaYQhO9N9xSqB6CBQ91y+4RPkistjJeFGaGr8SZdX+v4V0ZDJwxqhejT5gbWdu/
 uOqLQhUHLRWBvGE+2vlHNdb6XkyJvSd/urxDESsMOC4KkxsERu3xu8aF3OqGD5gWSjEa Vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=AvwWt+haSqijJ92YK3xYkxaHiq1Kl/6r9Q2eIHDZLEI=;
 b=OKEit06iCZ3v1EnpIqRYZpFWdMtaUc8ZkXzzS/5WnO4ugqQGS10ovcgxPxhnt65n759P
 qwEpAwQOPh0b8A5DYJNhTHy7/FYyHR+uZyuhjy6xhlnAHgrJ7Xxhb4uDKTfddPpt7KDP
 vjV6+KFri1h9d2IYbcKDWAGMWZcflQXtzpIq4GnWcC09/hUZbEHhCCQaFUmC5X5PyAXW
 n9bryOSDwajdbRQLN1EjSngKfJ4Dxcn2OH4YikR+wwpowUwS3vM9aRX00HJABr48IDwu
 j+ZMMnAoHPi5XsAPVi/9yNrYXwVXdRlJNI8B+Gm+ni6VlIAFjkw6QE40Y/GYMyVTyEpj fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3agu24hbqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 14:58:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17IEp5c7116198;
        Wed, 18 Aug 2021 14:58:51 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by userp3020.oracle.com with ESMTP id 3aeqkwdtqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 14:58:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrcWR4ZkE8p4Bfwp+ohsIzz+I0Su6TP4u7MANemqGSadakc91T86zpWm1WHNRn+cXHMpczrh06LLMwNFGxFsW5Ewi3Kx8kpd/G0ifjQdY1978xBem8W72sZa0vCf7M2IAUvHkR/Xx2Nee2Ijqd8kUsKyTCiARqfGh5j5y+FcxYKu7oZi42384AL/x8hYAgQLzR+PphMgrVebJq4Aj9r0fkvRqmBluZpDYFOHJN4uEf0Utv0unC5TUfLQyHAqx3IdKIRV7zX3icJdiSPHNnszSk+qB7mKdSvVWNV6qEZA0uSXc7n6YqHgOvYuDwsZygWz8n3eR0Az+eA4y5XZMgvSDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvwWt+haSqijJ92YK3xYkxaHiq1Kl/6r9Q2eIHDZLEI=;
 b=TbsvJb15w9GeMFEG4akpzvC88hYKBhPOzsAgUP/IroPJ7l6yHpfbNL3yusBqDGHDQjVj0wMNh+esh0HSUrdnAcF1cPxa6E0m+xli90BhiWUBOeM92NnPGhsspJwS4KXRF47F8HjZO39bjMtraomytG2nOjligmYgIYEtt4KZ9DF6fwih2VTacpmvVmG/J+QOAu84yy3Hr46NG+yTvSbzM5c+TDYKtj0s7QTWNKKNlhrNYNxLfigNm25SVHVCN1+QRzK/zLRZQayIHDqGe+M6eez8NRpcSLtCilecuwnZavvaAgcQWPdXuCG6Aha5nlR5zBx5dij0chNkrPl0Y5RZqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvwWt+haSqijJ92YK3xYkxaHiq1Kl/6r9Q2eIHDZLEI=;
 b=HonxsRrCSeDbrz3IXW2xHQsW2kcXY7eF5Sn8FIGbd+8ZCFZzjsbonugk7M2HYcX4YvQc2eYErZM3nWAeFiT3v9Y1+MyHamQ6khKB8EmjzhycASKyQnsh41uJ9PxhVbYrweRZYoOXGe7U+zm2sqccCJ3bUgyC/JwQtcKYyLFi9OU=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5382.namprd10.prod.outlook.com (2603:10b6:408:117::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 14:58:49 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf%7]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 14:58:49 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, laoar.shao@gmail.com
Cc:     george.kennedy@oracle.com, akpm@linux-foundation.org,
        surenb@google.com, stable@vger.kernel.org, christian@brauner.io,
        keescook@chromium.org, dhaval.giani@oracle.com
Subject: [PATCH 5.4.y 0/1] missing upstream commit 9066e5c causing: kernel panic: System is deadlocked on memory
Date:   Wed, 18 Aug 2021 09:59:06 -0500
Message-Id: <1629298747-19233-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0020.prod.exchangelabs.com (2603:10b6:804:2::30)
 To BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.42) by SN2PR01CA0020.prod.exchangelabs.com (2603:10b6:804:2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 14:58:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fbdce9a-b7ad-4869-ac90-08d96258af5d
X-MS-TrafficTypeDiagnostic: BN0PR10MB5382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5382B964D39DBB322B2D2E7EE6FF9@BN0PR10MB5382.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bhvcrI7rUPbLpmG2qDt38SRIqpzKtslK+SsEgMgIrxBnCbvNTSLFBx4GhqevK3DfIe1jIOBdwZcdbyaL7MRYBs9GkprKBsfNkqZ068srzqV4M/zV6MbSPTUrqGBdrHDLUj4yJbEvLlgRBjSK/zu01wK1xxahrY8GmN6hn7HzlaB/B+5Yk2MxWGN1JvrYmnWRCPzTug1aimrk/qWqrog7GPgynQrQG2848WHTDc3E8VJBDj+hTI/RYSpw9quwxANKZtI1r+cIVI72yT6+1oAy06cQHBJKL9RikDOUDpAD5y9f0F4wp7VV3u4mrqRaoQe6Ffzhr+vu9+XxKiZ/DyZRHffRjgMy8i54xf7GZCJpd0N5Oa3NwGpizhSmEHtJkO06UjMyljXcp0VlF1uWuka7ZrKjm2OhlvyHQYlFLY51OoxT6ZVWQmfdHI3voSMEj5iO1BInJT8usyNKGOWvFIs2DU5Y08jE29YWzfYD6zz2StF3sNBifbpziA5iXL0z03UF4PjyXqhypUHYVArqsTcNqzNgs74UieP6V910A+YKV6tVoaxY68nVt4m8mrK+ZgZN8O/rAnwrml1I71hWJa8d35YmDD2twyqBowzupzL8KwpgQnEu/TD7juU7RWdYu6kMzbK/lTSnMAN7kzwrQS4yrwP9ZZvagVXqb75dbLJbVurxo/4Lc4HeFYqQzY2UjwUJqImSF/8lrpOR7sIdbw1erQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(136003)(366004)(83380400001)(38100700002)(38350700002)(36756003)(107886003)(8676002)(8936002)(2616005)(86362001)(956004)(44832011)(2906002)(478600001)(4326008)(6486002)(186003)(6666004)(6512007)(66946007)(5660300002)(66556008)(52116002)(66476007)(26005)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ZJt+/uV6Hpu3pgpWU/lrz20INALTeLHZhEndXjL02GwTfotHuGJUj0UJJlp?=
 =?us-ascii?Q?auaw+85EZIy8rmYhMIbYfsQzqXpu7vZ0NloZvmu9xakE8edNroMqixRLiiO1?=
 =?us-ascii?Q?DRD9HBQrBQWckDYHXTnsVq09XcdRlvX3jn5uJIoVgrprfAvyhw/yx57fSyMh?=
 =?us-ascii?Q?4ETUnFYMRfPOV7J6ECAtF16XXaDRT1uz8Z40BUm85LXEnfDdegrz85RAdi/i?=
 =?us-ascii?Q?l7XFq14skAcyy18mOs1snmXMdRYfV1jLUCC8kKiJSRczpK2H2fWluANmpnOQ?=
 =?us-ascii?Q?gwipZtsVrQkjdWg5uOddVeFLFo1SiMblFVEJQRALq2SHJNM092urkHjtokWp?=
 =?us-ascii?Q?ZeFir8fJiooQySsE8hLB2LCYWdNcEwFA0I/hom9TaCQ2ba6rviKQqRcmWPri?=
 =?us-ascii?Q?MXF6a3SocKUijdweS8uTSJAroZSgOUk3zdEpZ/lXUVTYwvDEF+2ZiPLTv2Pt?=
 =?us-ascii?Q?FeBU8AroGahWRvmKrhKFqDF1zGwUSDPsRDwmVIYl079vWiD2ddctEGfxlAcO?=
 =?us-ascii?Q?ZTH3x1kJeKpODIumyZPHQjMs6CocUDneg5DVpKX1+kcLSybvtSgiFobULcO3?=
 =?us-ascii?Q?u/gE21R4cbwJlrq3NWd6VGbnvCxlk7Qep4T1hOw2330uLBqfmOL3ly69CTTe?=
 =?us-ascii?Q?d11sMuUszJ3o/eG/sgECPVMdKIy22h/EUfHiDGCqatatzZbOX0ZiJNPNv8QH?=
 =?us-ascii?Q?lbtP0sIVeH1DYbzwpApffUX0TXzPxST1BILNOSIv/rVgVJZJA4/ai0u2GKPb?=
 =?us-ascii?Q?hLxOQgx2BLXTcGngkQ4WoYlkfeGh2iKvldKCPpMB3IuHohRC1L/mWK+0tsyh?=
 =?us-ascii?Q?XIXTvTGLNgaSH7X91w+mXxPH15Pov0pJO9hPQUP6QhYkeS5gFTkkYMiq2CvW?=
 =?us-ascii?Q?mT2oML8vFNiPsChdTow3SQFpaNRkSnNEK5WC2EJOi9FxidIYpxki3/SZRt73?=
 =?us-ascii?Q?TUzAufFO3TgP0taaobzHnOqejrgS6qHQ2Wf761pZ/tk4DD24wAp+HX2q6GZD?=
 =?us-ascii?Q?eerkMpBZkIjAG1EhWZ/WjeRe8dOvgpIiJv8G3vSZxWaab4QzKpRig9B+WPOF?=
 =?us-ascii?Q?UZZnr1l5Ab7fp3/t8gULqF8MArk76OsNrFtKM9wiDuisORpJ2XaYCQ01EJbQ?=
 =?us-ascii?Q?fOJJqkJxxyvfHaZ8ANtfFOpE5x74vBwAl6oT6jLMlDoVgfdbpU1J1HOS9r6s?=
 =?us-ascii?Q?2DM7UX3gK3CGzsb6jndwS7tgT3fsZr/Lc9fOaFGWfBjQExPfckVyh+sIhKHP?=
 =?us-ascii?Q?ZRjfWJl7M9PBykpaWM06NjHmvDBKv6E+Y/NW5lXwp/EycuLg4O4Xtuurc37S?=
 =?us-ascii?Q?giUDgs91qfuuIzJ1MYJQpo3n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbdce9a-b7ad-4869-ac90-08d96258af5d
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 14:58:48.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78PJUbozsrIz9msv4PXFUcP+iVHNgz7ZEddZi9dVnHIHsMgmM1rPNW3rQ+/dK6dEXWUX4KDTEyfm3WkfDwsf0ni3v6LGXXs+NMGss9RCWfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5382
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180093
X-Proofpoint-GUID: B2kLAKd8D_1pKHp0YO4FT6OhEPKprMBr
X-Proofpoint-ORIG-GUID: B2kLAKd8D_1pKHp0YO4FT6OhEPKprMBr
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 9066e5c is missing from 5.4.y causing
kernel panic: System is deadlocked on memory
during 5.4.141-rc1 Syzkaller reproducer testing.

9066e5c 2020-08-11 Yafang Shao mm, oom: make the calculation of oom badness more accurate

Out of memory and no killable processes...
Kernel panic - not syncing: System is deadlocked on memory
CPU: 0 PID: 1 Comm: systemd Not tainted 5.4.141-rc1-syzk #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xd4/0x119 lib/dump_stack.c:118
 panic+0x28f/0x6ad kernel/panic.c:221
 out_of_memory mm/oom_kill.c:1110 [inline]
 out_of_memory.cold.36+0xf4/0x174 mm/oom_kill.c:1045
 __alloc_pages_may_oom mm/page_alloc.c:3879 [inline]
 __alloc_pages_slowpath+0x1b30/0x2240 mm/page_alloc.c:4623
 __alloc_pages_nodemask+0x515/0x760 mm/page_alloc.c:4793
 alloc_pages_vma+0xe2/0x560 mm/mempolicy.c:2155
 __read_swap_cache_async+0x40e/0x770 mm/swap_state.c:399
 read_swap_cache_async+0x96/0x100 mm/swap_state.c:454
 swap_cluster_readahead+0x448/0x860 mm/swap_state.c:597
 swapin_readahead+0xbf/0xd40 mm/swap_state.c:789
 do_swap_page+0x812/0x1dc0 mm/memory.c:2937
 handle_pte_fault mm/memory.c:4003 [inline]
 __handle_mm_fault+0x17ad/0x24b0 mm/memory.c:4123
 handle_mm_fault+0x1f0/0x700 mm/memory.c:4160
 do_user_addr_fault arch/x86/mm/fault.c:1463 [inline]
 __do_page_fault+0x59e/0xd20 arch/x86/mm/fault.c:1528
 do_page_fault+0x52/0x390 arch/x86/mm/fault.c:1552
 do_async_page_fault+0x64/0xf0 arch/x86/kernel/kvm.c:253
 async_page_fault+0x3e/0x50 arch/x86/entry/entry_64.S:1206
RIP: 0010:ep_send_events_proc+0x2db/0xad0 fs/eventpoll.c:1751
Code: ff e8 79 f5 ff ff 31 ff 41 89 c7 89 c6 e8 6d b1 a3 ff 45 85 ff 0f 84 08 01 00 00 e8 4f b0 a3 ff 66 66 90 48 8b 85 50 ff ff ff <44> 89 38 e8 3d b0 a3 ff 66 66 90 48 8d 7b 74 48 89 f8 48 89 fe 48
RSP: 0018:ffff8881079e7ab0 EFLAGS: 00010293
RAX: 00007ffe9db639a0 RBX: ffff8880b490e180 RCX: ffffffff81d19d23
RDX: 0000000000000000 RSI: ffffffff81d19d31 RDI: 0000000000000005
RBP: ffff8881079e7bb0 R08: ffff8881079d8000 R09: ffffed1020f3cf2d
R10: ffffed1020f3cf2d R11: 0000000000000003 R12: dffffc0000000000
R13: ffff8880b490e198 R14: ffff8881079e7c10 R15: 0000000000000001
 ep_scan_ready_list.constprop.20+0x265/0x920 fs/eventpoll.c:702
 ep_send_events fs/eventpoll.c:1791 [inline]
 ep_poll+0x166/0xd70 fs/eventpoll.c:1939
 do_epoll_wait+0x192/0x1d0 fs/eventpoll.c:2291
 __do_sys_epoll_wait fs/eventpoll.c:2301 [inline]
 __se_sys_epoll_wait fs/eventpoll.c:2298 [inline]
 __x64_sys_epoll_wait+0x9c/0x100 fs/eventpoll.c:2298
 do_syscall_64+0xe6/0x4d0 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f4f31aad543
Code: Bad RIP value.
RSP: 002b:00007ffe9db63990 EFLAGS: 00000293 ORIG_RAX: 00000000000000e8
RAX: ffffffffffffffda RBX: 00007ffe9db639a0 RCX: 00007f4f31aad543
RDX: 000000000000002a RSI: 00007ffe9db639a0 RDI: 0000000000000004
RBP: 00007ffe9db63c90 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000293 R12: 0000000000000001
R13: ffffffffffffffff R14: 0000000000007500 R15: 000055da3b5769c0


Yafang Shao (1):
  mm, oom: make the calculation of oom badness more accurate

 fs/proc/base.c      | 11 ++++++++++-
 include/linux/oom.h |  4 ++--
 mm/oom_kill.c       | 22 ++++++++++------------
 3 files changed, 22 insertions(+), 15 deletions(-)

-- 
1.8.3.1

