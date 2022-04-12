Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE704FCED1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347729AbiDLFTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiDLFTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:19:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93253466D;
        Mon, 11 Apr 2022 22:17:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C2Qjdn029058;
        Tue, 12 Apr 2022 05:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8Ct0seMaWqqoEdaNRFLwwYNLam8EXfh3cGOja5tWS8Q=;
 b=RDVYnSKELkEXrTXFq99Ywfr2iWZTyxAcTBqVCsNIQ4CHItP/iLqS4mKZDqNA1UMHf0dY
 cJOmZevcxK/zKaI6WBoeTvVFrvLNFzjmUIfDkHUNdOdsRxlrbuWr6AGZt6W+6t52o2X2
 EKHUIwKV78jCE6652Vyvp3bNFR/1uF4z9B9aycD+SZHDLGjgp8GrcMiK3jb2aHutKRzt
 tOAcdlLIO0kiCMZLRGE21xprhfwd8fnu4fW23qMMSQkzShmGCtCZIx1UBAg0WLRBSWzc
 XlRXj2JyMKGmWUSf8QIpb2cZTce46o4Ii37+RCHPlVdxeMNZrhID59f3gbOBgHDQ+6xS XQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rs5nj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5GM4u039629;
        Tue, 12 Apr 2022 05:17:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck129fat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bI/OJ+3BrrUUwdZ2wFfTpR5//jyPHEJ8eronJJ38R/ATzGJneROn3odd4WtKtj5jn9zjWCJ1LAvY71HxcrZGuweJNM99aOdEd71Deqpv9uZ5EAZzMoBsIENc2OMvvXBTYAd22j2JdihkbPVDc8WUI8B1nlgKYB+64Vv4+1fJcOqj3K/bPu8aJCfIwW2iwVP07XSFICCNb70m/+QiZuxlLLGIetF/GZKap5a6Dvi7cw5y6X5Dx8USocz+3CJmDnVI3gCeBG891tdfLT7G8adYn6um3iejPltwf1gwO+rXzovI+WShtGLs+7lYyWO9KlUPh01OewzV6A1KHYfnCN+P9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ct0seMaWqqoEdaNRFLwwYNLam8EXfh3cGOja5tWS8Q=;
 b=SFUwBIz6Q1OOpLDA4hnnD8gOj7Xo6w4kBdoknAZeoL1aQM6yJOXGp5toKoDSPB4erBgtxRWiQMB5vQ87nRCb69ZLWa9aryHZqznkNCC7JoTmZSO4rnU7tp8R7YcM9hz5iCzEXmAYzwXbrH04VDupGtTOqfphE4hAT/SNjSNLDjqhIKYFiAr2e4ZQLVQqEdAjS0U8OYH1mB/fmuiQS+6IM9v1Vk6aVJpHaV+w5MxLHWrZEcc23GJCvGYNQA4sWAYFWUR2rlPMeczBo32mmKomtNyrWvyVDyRJtU4sdD9dxane38T1r+RYgO2hfFichXwB54GSBmOcaKljaKjSqirhtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ct0seMaWqqoEdaNRFLwwYNLam8EXfh3cGOja5tWS8Q=;
 b=T4uoa5s+TEuf2U5w0biaZluNGijKiILL/6Cg7YXygljwHY1ge9mRIDpLizESKn87FbcNMYLZDDosZtdcHq5/S5amN8jcG4BAM//JFy+0ceFsijDmWMYB0FmGTf7gmqp7BQvH6zVYkiSKcpAyA+UbM7Kq4veZdjWavspqK61gO4s=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BYAPR10MB3256.namprd10.prod.outlook.com (2603:10b6:a03:152::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:17:25 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:17:25 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 16/18 stable-5.15.y] btrfs: fix deadlock due to page faults during direct IO reads and writes
Date:   Tue, 12 Apr 2022 13:15:13 +0800
Message-Id: <efe13b05a64942e2884c1e6b658261ca32ca7520.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0125.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::17) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81e35d29-75f9-4aad-48c8-08da1c43bb12
X-MS-TrafficTypeDiagnostic: BYAPR10MB3256:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB32562360AC56EB96B5398C55E5ED9@BYAPR10MB3256.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j8H8hPaaHGTeGZFB/QZiRewsTSmD3Hemvsc4rzYFfxtkRDumrspcE9TfhgkNoSgSuEwgeFDWdKOgTdMtirByIQw8Rg2UclHEhXUa2VBNqVlwCkB0+R7VVgY1R5stDxoy64ARj7N914L2mP0WyvtP+UPUM43iOqM58FA3tgumre3J4n9R3gswBSD01Fcc50TcfPb5YjPkgcSpsz8HcNn5Jkf9xG8BKVuHnYsoFLgtA7VeuKGVh3WHQdvth+GSRE8gGLgsYyHo8N+0+dYuuuYfiCP8L5PT5UcilKue/zseVh3nMhgT50/1GYug3uVqcu91aUqVTH2LcsN7qevWj0g1XuXUOlVxaQ8p/7hyARFlTeyDmtECAU2FBELKsU0BkC6ZiBxW2ftNJ9jDNV5EX+zpfsBzbuOF7Klyg/hnhFwMameldF3F4aVCkPt7w4cTajzgPpVtV9ZQ4ZFUWPHMKr0yPpZwJ4DiodCHSUIWjQB2CV+K5y5UWmDmI1cROkFqqXUPTqeYQUGQOeDGhY1XiK51vP+nTDHn06vcMATXEEck0qZlKkVGm0NIjFC8MNc11x786EHbGCmBtM/RIU/GlPP4vYk4VZgxMZ4py+J3lLqZGTwBkBFLrTDObFzIOHKab/hgwkDDL99a5hICnIq3IU5Wmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(5660300002)(30864003)(2906002)(83380400001)(6512007)(2616005)(66476007)(44832011)(107886003)(186003)(6506007)(6666004)(508600001)(66556008)(66946007)(6486002)(86362001)(54906003)(36756003)(8676002)(4326008)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gv51FG/VcDUKkl9Xr3ql6RXYiKigX5+/0ccdvCBYzNeQUiUl7qPpUJYTheyd?=
 =?us-ascii?Q?LTxue5Ro8SBG1aFTk8kdOSikF2eXQ/MuX+pwIubys8bUfGyBwUUFLQwxK45n?=
 =?us-ascii?Q?6q3lknF7XaMGVxKSoWGnPAKlNvPr9t3rL72dpw/NGu1yKle8j/VvGA0sswz4?=
 =?us-ascii?Q?wjaEJ7KDPt378y7f/SP+bzpRqVKPgmK3T8eQN6kwuySMNEUnKquCFpzRYmmu?=
 =?us-ascii?Q?+0AHJkZuinwk1g1gzSkL7vt75JAQrKbPtdDvrt2pHMy4eB1IVXZUmIvv+UTe?=
 =?us-ascii?Q?b1T0IE6ok4kpLj6cx5I2kFCZ8gZG/TvvN74TMz3OufnvmODpRYPpd1pZ55vL?=
 =?us-ascii?Q?Ke2KmUoXxe2nOT9Jl17+Nd3DqR3t99kuK6KFdCbONvh84zjzSCYudZhwYjYc?=
 =?us-ascii?Q?C4pggzB+BkXcJFFR/zUrSmirKyM+psL+otHBK52eCED0jWSPT6De6ImE2x92?=
 =?us-ascii?Q?dVAHNSTo3LecQNDQ/aNgYKA7PxJLYG/YXNvqrFjfPRTQNnYg48VQxY4uVFR/?=
 =?us-ascii?Q?B7L2dnlq/A65OQk43wTSGoS7/2JTPu+SycCrzbc/khprYo959wvtIxPB2hfq?=
 =?us-ascii?Q?dihcTZg7PtwmSfecfAzBWg5Ey44HK0Xf3yRhSItuoz+zfiXGa0tnIq1i9ooU?=
 =?us-ascii?Q?Ef5RUB4k9Re/AfKL3IHa04pWtNeNGTlsj4Ld/nLAmPiNfGXD9OQJxDULRxze?=
 =?us-ascii?Q?3DVzNYs6yzznTdVm0Y+7YA3Ps/3igr/1DIlInu8a+R8vjyFx4NvnO7b0lJrq?=
 =?us-ascii?Q?3oY3S33p2pRwOkMp6fKovYg0uuN5673yUWtsjxWknjUsjbTqb26b3D5t/Vlj?=
 =?us-ascii?Q?xN676qnpCrkzTLsnM3x7H02zOZ5UtR2Y1tNh9qVrYuPYQpjPo/lhMT4iTRA8?=
 =?us-ascii?Q?LDnIApwYo07lFJBYgwQqTpS8lAADPLZqID4oq6Rd3MfUKSRqc3bKAROpVw4a?=
 =?us-ascii?Q?ghLlUlJkQbHVwda4Q9QdDYb9SWV5EDR+3XPXZu8sJKfA3YEGBnK1Zapfbzcj?=
 =?us-ascii?Q?cUBAPjBBrWJduSkGqnOam752WOhgiWjvk7rL1Ecyc3/weBCP+I8rJm9gFHaR?=
 =?us-ascii?Q?rIUGwSO0tGyrSoYUbsQ3+qkPp/z3GSZ5SPJdICyX/zMIG/xPMD0bgEobVxiG?=
 =?us-ascii?Q?47kEiqP1NyTgn675WkcX9ZBnOR8txo6S02j0X6fBCrUZ9KnDrCk2d8vGdLzO?=
 =?us-ascii?Q?D4BYJDISeUVABsydrNTkVJ+ZE65Y8ABiSI9JSKlMlvE8YDoi6W9VFbsyxtgy?=
 =?us-ascii?Q?QahbAvb6KyjXzP3i1dThNXcDlDOyQqZeQHJur8h//WiR8728g4Lo95MbtMPt?=
 =?us-ascii?Q?gV5ywf9Kv+XWwCkmmfNw6U5/+tkuw/AIFVSP+j1x757QnSR9GnP2oKr/75gK?=
 =?us-ascii?Q?BU5yWR89ubWH8SYnNBt3MHu2IkMHZ9puxzKq6UHkV/tBSY7Ok1axYU6mWGLc?=
 =?us-ascii?Q?NokMITCoGPkgucmyWZsEuJmhmrBuKa0QI5s8xLTQ9FmWnEajBLt+eT/0RbTN?=
 =?us-ascii?Q?R1Tq8N1/gurno/GwvFb61aLv54Uexd0Ee9LFnbqJSozChHbfqA9+uD2zu2gk?=
 =?us-ascii?Q?VMPdr/2mtZruRmmC2PO5+f8zgFMRQQY/AfH1eHWQpdKYfacYNa6opMbgBcvy?=
 =?us-ascii?Q?AtWT5D50rPYBZ9BvaTHGN/h3yMXPpj6d227dUbhKuMJ+/wiT+gSAoNkdN7WH?=
 =?us-ascii?Q?7Fd/6TXFMvGG28ac6vIBgvdOrVrpu45AlifkvMR6jwTQf4emjWARae0K0CVf?=
 =?us-ascii?Q?7DiiAuG3foMv0c6qmP+DIMeyUhJltMTVDhfYHUXJgYb0+EOa+Y9n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e35d29-75f9-4aad-48c8-08da1c43bb12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:17:25.5145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruH7F6IgkQcchN+GO3CMW+QH1rAJiFLW36AvgMDp9uH8mjiMvqDp5m/0AfMUDGjqYD5XTZO21sFs1a77Uv4REA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3256
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: pN4o1xkEolYDO2TU3Satn0XNfw97UCzR
X-Proofpoint-GUID: pN4o1xkEolYDO2TU3Satn0XNfw97UCzR
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

commit 51bd9563b6783de8315f38f7baed949e77c42311 upstream

If we do a direct IO read or write when the buffer given by the user is
memory mapped to the file range we are going to do IO, we end up ending
in a deadlock. This is triggered by the new test case generic/647 from
fstests.

For a direct IO read we get a trace like this:

  [967.872718] INFO: task mmap-rw-fault:12176 blocked for more than 120 seconds.
  [967.874161]       Not tainted 5.14.0-rc7-btrfs-next-95 #1
  [967.874909] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [967.875983] task:mmap-rw-fault   state:D stack:    0 pid:12176 ppid: 11884 flags:0x00000000
  [967.875992] Call Trace:
  [967.875999]  __schedule+0x3ca/0xe10
  [967.876015]  schedule+0x43/0xe0
  [967.876020]  wait_extent_bit.constprop.0+0x1eb/0x260 [btrfs]
  [967.876109]  ? do_wait_intr_irq+0xb0/0xb0
  [967.876118]  lock_extent_bits+0x37/0x90 [btrfs]
  [967.876150]  btrfs_lock_and_flush_ordered_range+0xa9/0x120 [btrfs]
  [967.876184]  ? extent_readahead+0xa7/0x530 [btrfs]
  [967.876214]  extent_readahead+0x32d/0x530 [btrfs]
  [967.876253]  ? lru_cache_add+0x104/0x220
  [967.876255]  ? kvm_sched_clock_read+0x14/0x40
  [967.876258]  ? sched_clock_cpu+0xd/0x110
  [967.876263]  ? lock_release+0x155/0x4a0
  [967.876271]  read_pages+0x86/0x270
  [967.876274]  ? lru_cache_add+0x125/0x220
  [967.876281]  page_cache_ra_unbounded+0x1a3/0x220
  [967.876291]  filemap_fault+0x626/0xa20
  [967.876303]  __do_fault+0x36/0xf0
  [967.876308]  __handle_mm_fault+0x83f/0x15f0
  [967.876322]  handle_mm_fault+0x9e/0x260
  [967.876327]  __get_user_pages+0x204/0x620
  [967.876332]  ? get_user_pages_unlocked+0x69/0x340
  [967.876340]  get_user_pages_unlocked+0xd3/0x340
  [967.876349]  internal_get_user_pages_fast+0xbca/0xdc0
  [967.876366]  iov_iter_get_pages+0x8d/0x3a0
  [967.876374]  bio_iov_iter_get_pages+0x82/0x4a0
  [967.876379]  ? lock_release+0x155/0x4a0
  [967.876387]  iomap_dio_bio_actor+0x232/0x410
  [967.876396]  iomap_apply+0x12a/0x4a0
  [967.876398]  ? iomap_dio_rw+0x30/0x30
  [967.876414]  __iomap_dio_rw+0x29f/0x5e0
  [967.876415]  ? iomap_dio_rw+0x30/0x30
  [967.876420]  ? lock_acquired+0xf3/0x420
  [967.876429]  iomap_dio_rw+0xa/0x30
  [967.876431]  btrfs_file_read_iter+0x10b/0x140 [btrfs]
  [967.876460]  new_sync_read+0x118/0x1a0
  [967.876472]  vfs_read+0x128/0x1b0
  [967.876477]  __x64_sys_pread64+0x90/0xc0
  [967.876483]  do_syscall_64+0x3b/0xc0
  [967.876487]  entry_SYSCALL_64_after_hwframe+0x44/0xae
  [967.876490] RIP: 0033:0x7fb6f2c038d6
  [967.876493] RSP: 002b:00007fffddf586b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
  [967.876496] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007fb6f2c038d6
  [967.876498] RDX: 0000000000001000 RSI: 00007fb6f2c17000 RDI: 0000000000000003
  [967.876499] RBP: 0000000000001000 R08: 0000000000000003 R09: 0000000000000000
  [967.876501] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000003
  [967.876502] R13: 0000000000000000 R14: 00007fb6f2c17000 R15: 0000000000000000

This happens because at btrfs_dio_iomap_begin() we lock the extent range
and return with it locked - we only unlock in the endio callback, at
end_bio_extent_readpage() -> endio_readpage_release_extent(). Then after
iomap called the btrfs_dio_iomap_begin() callback, it triggers the page
faults that resulting in reading the pages, through the readahead callback
btrfs_readahead(), and through there we end to attempt to lock again the
same extent range (or a subrange of what we locked before), resulting in
the deadlock.

For a direct IO write, the scenario is a bit different, and it results in
trace like this:

  [1132.442520] run fstests generic/647 at 2021-08-31 18:53:35
  [1330.349355] INFO: task mmap-rw-fault:184017 blocked for more than 120 seconds.
  [1330.350540]       Not tainted 5.14.0-rc7-btrfs-next-95 #1
  [1330.351158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [1330.351900] task:mmap-rw-fault   state:D stack:    0 pid:184017 ppid:183725 flags:0x00000000
  [1330.351906] Call Trace:
  [1330.351913]  __schedule+0x3ca/0xe10
  [1330.351930]  schedule+0x43/0xe0
  [1330.351935]  btrfs_start_ordered_extent+0x108/0x1c0 [btrfs]
  [1330.352020]  ? do_wait_intr_irq+0xb0/0xb0
  [1330.352028]  btrfs_lock_and_flush_ordered_range+0x8c/0x120 [btrfs]
  [1330.352064]  ? extent_readahead+0xa7/0x530 [btrfs]
  [1330.352094]  extent_readahead+0x32d/0x530 [btrfs]
  [1330.352133]  ? lru_cache_add+0x104/0x220
  [1330.352135]  ? kvm_sched_clock_read+0x14/0x40
  [1330.352138]  ? sched_clock_cpu+0xd/0x110
  [1330.352143]  ? lock_release+0x155/0x4a0
  [1330.352151]  read_pages+0x86/0x270
  [1330.352155]  ? lru_cache_add+0x125/0x220
  [1330.352162]  page_cache_ra_unbounded+0x1a3/0x220
  [1330.352172]  filemap_fault+0x626/0xa20
  [1330.352176]  ? filemap_map_pages+0x18b/0x660
  [1330.352184]  __do_fault+0x36/0xf0
  [1330.352189]  __handle_mm_fault+0x1253/0x15f0
  [1330.352203]  handle_mm_fault+0x9e/0x260
  [1330.352208]  __get_user_pages+0x204/0x620
  [1330.352212]  ? get_user_pages_unlocked+0x69/0x340
  [1330.352220]  get_user_pages_unlocked+0xd3/0x340
  [1330.352229]  internal_get_user_pages_fast+0xbca/0xdc0
  [1330.352246]  iov_iter_get_pages+0x8d/0x3a0
  [1330.352254]  bio_iov_iter_get_pages+0x82/0x4a0
  [1330.352259]  ? lock_release+0x155/0x4a0
  [1330.352266]  iomap_dio_bio_actor+0x232/0x410
  [1330.352275]  iomap_apply+0x12a/0x4a0
  [1330.352278]  ? iomap_dio_rw+0x30/0x30
  [1330.352292]  __iomap_dio_rw+0x29f/0x5e0
  [1330.352294]  ? iomap_dio_rw+0x30/0x30
  [1330.352306]  btrfs_file_write_iter+0x238/0x480 [btrfs]
  [1330.352339]  new_sync_write+0x11f/0x1b0
  [1330.352344]  ? NF_HOOK_LIST.constprop.0.cold+0x31/0x3e
  [1330.352354]  vfs_write+0x292/0x3c0
  [1330.352359]  __x64_sys_pwrite64+0x90/0xc0
  [1330.352365]  do_syscall_64+0x3b/0xc0
  [1330.352369]  entry_SYSCALL_64_after_hwframe+0x44/0xae
  [1330.352372] RIP: 0033:0x7f4b0a580986
  [1330.352379] RSP: 002b:00007ffd34d75418 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
  [1330.352382] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f4b0a580986
  [1330.352383] RDX: 0000000000001000 RSI: 00007f4b0a3a4000 RDI: 0000000000000003
  [1330.352385] RBP: 00007f4b0a3a4000 R08: 0000000000000003 R09: 0000000000000000
  [1330.352386] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
  [1330.352387] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Unlike for reads, at btrfs_dio_iomap_begin() we return with the extent
range unlocked, but later when the page faults are triggered and we try
to read the extents, we end up btrfs_lock_and_flush_ordered_range() where
we find the ordered extent for our write, created by the iomap callback
btrfs_dio_iomap_begin(), and we wait for it to complete, which makes us
deadlock since we can't complete the ordered extent without reading the
pages (the iomap code only submits the bio after the pages are faulted
in).

Fix this by setting the nofault attribute of the given iov_iter and retry
the direct IO read/write if we get an -EFAULT error returned from iomap.
For reads, also disable page faults completely, this is because when we
read from a hole or a prealloc extent, we can still trigger page faults
due to the call to iov_iter_zero() done by iomap - at the moment, it is
oblivious to the value of the ->nofault attribute of an iov_iter.
We also need to keep track of the number of bytes written or read, and
pass it to iomap_dio_rw(), as well as use the new flag IOMAP_DIO_PARTIAL.

This depends on the iov_iter and iomap changes introduced in commit
c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2").

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/file.c | 139 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 123 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cd4950476366..5ac6ec80b970 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1903,16 +1903,17 @@ static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
 
 static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
+	const bool is_sync_write = (iocb->ki_flags & IOCB_DSYNC);
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	loff_t pos;
 	ssize_t written = 0;
 	ssize_t written_buffered;
+	size_t prev_left = 0;
 	loff_t endbyte;
 	ssize_t err;
 	unsigned int ilock_flags = 0;
-	struct iomap_dio *dio = NULL;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -1955,23 +1956,80 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		goto buffered;
 	}
 
-	dio = __iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			     0, 0);
+	/*
+	 * We remove IOCB_DSYNC so that we don't deadlock when iomap_dio_rw()
+	 * calls generic_write_sync() (through iomap_dio_complete()), because
+	 * that results in calling fsync (btrfs_sync_file()) which will try to
+	 * lock the inode in exclusive/write mode.
+	 */
+	if (is_sync_write)
+		iocb->ki_flags &= ~IOCB_DSYNC;
 
-	btrfs_inode_unlock(inode, ilock_flags);
+	/*
+	 * The iov_iter can be mapped to the same file range we are writing to.
+	 * If that's the case, then we will deadlock in the iomap code, because
+	 * it first calls our callback btrfs_dio_iomap_begin(), which will create
+	 * an ordered extent, and after that it will fault in the pages that the
+	 * iov_iter refers to. During the fault in we end up in the readahead
+	 * pages code (starting at btrfs_readahead()), which will lock the range,
+	 * find that ordered extent and then wait for it to complete (at
+	 * btrfs_lock_and_flush_ordered_range()), resulting in a deadlock since
+	 * obviously the ordered extent can never complete as we didn't submit
+	 * yet the respective bio(s). This always happens when the buffer is
+	 * memory mapped to the same file range, since the iomap DIO code always
+	 * invalidates pages in the target file range (after starting and waiting
+	 * for any writeback).
+	 *
+	 * So here we disable page faults in the iov_iter and then retry if we
+	 * got -EFAULT, faulting in the pages before the retry.
+	 */
+again:
+	from->nofault = true;
+	err = iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
+			   IOMAP_DIO_PARTIAL, written);
+	from->nofault = false;
 
-	if (IS_ERR_OR_NULL(dio)) {
-		err = PTR_ERR_OR_ZERO(dio);
-		if (err < 0 && err != -ENOTBLK)
-			goto out;
-	} else {
-		written = iomap_dio_complete(dio);
+	/* No increment (+=) because iomap returns a cumulative value. */
+	if (err > 0)
+		written = err;
+
+	if (iov_iter_count(from) > 0 && (err == -EFAULT || err > 0)) {
+		const size_t left = iov_iter_count(from);
+		/*
+		 * We have more data left to write. Try to fault in as many as
+		 * possible of the remainder pages and retry. We do this without
+		 * releasing and locking again the inode, to prevent races with
+		 * truncate.
+		 *
+		 * Also, in case the iov refers to pages in the file range of the
+		 * file we want to write to (due to a mmap), we could enter an
+		 * infinite loop if we retry after faulting the pages in, since
+		 * iomap will invalidate any pages in the range early on, before
+		 * it tries to fault in the pages of the iov. So we keep track of
+		 * how much was left of iov in the previous EFAULT and fallback
+		 * to buffered IO in case we haven't made any progress.
+		 */
+		if (left == prev_left) {
+			err = -ENOTBLK;
+		} else {
+			fault_in_iov_iter_readable(from, left);
+			prev_left = left;
+			goto again;
+		}
 	}
 
-	if (written < 0 || !iov_iter_count(from)) {
-		err = written;
+	btrfs_inode_unlock(inode, ilock_flags);
+
+	/*
+	 * Add back IOCB_DSYNC. Our caller, btrfs_file_write_iter(), will do
+	 * the fsync (call generic_write_sync()).
+	 */
+	if (is_sync_write)
+		iocb->ki_flags |= IOCB_DSYNC;
+
+	/* If 'err' is -ENOTBLK then it means we must fallback to buffered IO. */
+	if ((err < 0 && err != -ENOTBLK) || !iov_iter_count(from))
 		goto out;
-	}
 
 buffered:
 	pos = iocb->ki_pos;
@@ -1996,7 +2054,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
 				 endbyte >> PAGE_SHIFT);
 out:
-	return written ? written : err;
+	return err < 0 ? err : written;
 }
 
 static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
@@ -3650,6 +3708,8 @@ static int check_direct_read(struct btrfs_fs_info *fs_info,
 static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
+	size_t prev_left = 0;
+	ssize_t read = 0;
 	ssize_t ret;
 
 	if (fsverity_active(inode))
@@ -3659,10 +3719,57 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 		return 0;
 
 	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
+again:
+	/*
+	 * This is similar to what we do for direct IO writes, see the comment
+	 * at btrfs_direct_write(), but we also disable page faults in addition
+	 * to disabling them only at the iov_iter level. This is because when
+	 * reading from a hole or prealloc extent, iomap calls iov_iter_zero(),
+	 * which can still trigger page fault ins despite having set ->nofault
+	 * to true of our 'to' iov_iter.
+	 *
+	 * The difference to direct IO writes is that we deadlock when trying
+	 * to lock the extent range in the inode's tree during he page reads
+	 * triggered by the fault in (while for writes it is due to waiting for
+	 * our own ordered extent). This is because for direct IO reads,
+	 * btrfs_dio_iomap_begin() returns with the extent range locked, which
+	 * is only unlocked in the endio callback (end_bio_extent_readpage()).
+	 */
+	pagefault_disable();
+	to->nofault = true;
 	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			   0, 0);
+			   IOMAP_DIO_PARTIAL, read);
+	to->nofault = false;
+	pagefault_enable();
+
+	/* No increment (+=) because iomap returns a cumulative value. */
+	if (ret > 0)
+		read = ret;
+
+	if (iov_iter_count(to) > 0 && (ret == -EFAULT || ret > 0)) {
+		const size_t left = iov_iter_count(to);
+
+		if (left == prev_left) {
+			/*
+			 * We didn't make any progress since the last attempt,
+			 * fallback to a buffered read for the remainder of the
+			 * range. This is just to avoid any possibility of looping
+			 * for too long.
+			 */
+			ret = read;
+		} else {
+			/*
+			 * We made some progress since the last retry or this is
+			 * the first time we are retrying. Fault in as many pages
+			 * as possible and retry.
+			 */
+			fault_in_iov_iter_writeable(to, left);
+			prev_left = left;
+			goto again;
+		}
+	}
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
-	return ret;
+	return ret < 0 ? ret : read;
 }
 
 static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
-- 
2.33.1

