Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE7A4F009B
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347815AbiDBKa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242970AbiDBKa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:30:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D56E12AA8;
        Sat,  2 Apr 2022 03:28:36 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2323wTaW023293;
        Sat, 2 Apr 2022 10:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8Ct0seMaWqqoEdaNRFLwwYNLam8EXfh3cGOja5tWS8Q=;
 b=A7/uWP7pVyM/iFlEVBu4gEY5+c35GAnXy6Xu9Pgks7nnq8BADrbKas/OE+Jxxy3ziWdi
 m/0hUbG13zIfjyV/BMpU9HnoBBGAZ+ycg9vB2LKJM0qgiKqRBQCBDQDbAKfhHRu+4rHS
 gdZ/bkKQ7co981qRGLfoRl+5o+YCFFHxArZZ23+HE3Vcuqfpisppjs0u1mMhY4KcgqAc
 wqTRnVtNsffFwclRQ5GvGu/Fuqw2BmK4uwuoJl8aAKaLQTy5X+CZv8LnI7hGOZmbNMGP
 4/Z4a0pBLaJnYkNei+VYO5X7p+SQRigHy/+G8BiKVzG+9YFVCThI0xtYefyQGq6grE0r EQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t0b1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:28:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AKqPY001862;
        Sat, 2 Apr 2022 10:28:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx16jwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:28:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0WJDTazeCJl52IRSxzyT5IiHE5Am40bs8RU982s2SiaIfhADiiEikIY4shtbP4q1mfHgv+AgKYBGJkcwsL3Vm0E3h2HMU8gwc2dY3hA0r0L6JsNx4NpzpXrBNUahhL8U7drToHeT0NxiXSgSnFdhEIxXEhVjG9VIey6vXHGj9KFDsEVE0wAa0Rfup+rNnZo5+L4ECvqTO8TPuR+NvmTRAabsh6l12rN4ieRznove+GzUX2aYJSAiepU23o7rGcVeOtSMk6SFT/g2ElvarEEVSATwtLi/AUavjYaBQhGnNCQ6tTIcYbJ82aFaBJMYlYPgT1zhqI0bTXTGb+q6BL0hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ct0seMaWqqoEdaNRFLwwYNLam8EXfh3cGOja5tWS8Q=;
 b=kMgjZgns1y4GaFW72Z0G8an7Y3jn1jwOE0qQ+B+SC8wiFo6eEn486McZvFptv3zABKhPchVE+i9IqaVwtGr2/j9R7Fj85tqvva+0z+ciDTEc0PYOJq08+jhB8kpa+MX2hbPS3At53Fky1ueis3rbvOoW2SioRpUeYObQAXCilJdOT22WdoxWhmpSfhLxbNLakGRVcThmQaeGcTM3pq8mK7GRWMPPUcGzjifLut2+YJkol3mGG3d5ICLzzCR0Wak3HxdMYcm4PUCAGhVROeSwm8bnf7CLFWe13sqrN1LIA8MREi4wqXzRxPJFfh5q1nXjXNaNbTTX+RkSW2wI20J8TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ct0seMaWqqoEdaNRFLwwYNLam8EXfh3cGOja5tWS8Q=;
 b=bamTaHI/i4Jd/v3ypwI57Gm9qHuURqHfvTM4qbfgM3LECEaKoum8zPpHI0J7tPlo4tmcrZX7uy+nXAiYr9f0RhYU723ci1FOhIFd1hK9IcA7wIeem0BxnZE/xsdrVlUl63ZVcXuCUC5tyD4A91PYeyZlok1l2gHbLaNy2rmlYis=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:28:27 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:28:27 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 17/17 stable-5.15.y] btrfs: fix deadlock due to page faults during direct IO reads and writes
Date:   Sat,  2 Apr 2022 18:25:54 +0800
Message-Id: <ca8fc19f22aa7a4875ad309a82102fa8bc851085.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0165.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::21) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 192c61b4-5978-4a54-2102-08da1493865b
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30492818176D4B484D6CF249E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PEqhEcHtEGmEWdVZ3nLmEaGbOL4oUQLPafOQ0B8iW1kFOeCIUli+sGnmEUM4Wxx/VDoSkLnCeN0MGNIJEWGrNY6fw40K1vRjw7bO5UvzqT1n3teJ3WK6VZqcfVQf27aXQzu2BJ2S/sT1qwjyd1pYJP8BFN101VE79crU+KaOPJ2mq10KN2l+XNeMB1gFcaylbAH5Da+HPQBz4tAyNwOrFj/DvwnVnX/JJQBgZN8WoMmjDdPd1XsnnDBxa5pW3kYYxQy80e5FgUY1gD65QGRXQTWMARIf/yEondfbsxkgfxGWu9y+5QdBKo/VD4u3P8hql7sI563oh4BSDsoYe2NjONvXqYGbiYQjbPP02rnxdH3VpRrSLVm4p+t5Hc3CMjRoeM+RPudM4EcUnqInunsUUShBcHpoxfTke24sdMZeqTW2meSDMker8fiKl87OMeEFXB2pgo3Ycdh8/yTOFtPMjkZT7roUTwsuRBm/jvHgNvRZE82so1DfGaz2au8sYnWW4iM9HXgVi85Fdl9TJs2x+DcYv+XhWbTOrtRfcqWK/TSjlSQKEf10EUcd7ZRM4NQ7CyKaw7/Is4Yrog2VWYRLa3frrDnSx+iFAD3kpp9uQs2ZPrPJtyEsgipYfzqPYmrEqE01x2HldlWj5PysJhKY+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(83380400001)(30864003)(316002)(508600001)(6512007)(36756003)(86362001)(26005)(6486002)(44832011)(66476007)(6506007)(54906003)(2616005)(6666004)(4326008)(186003)(6916009)(66946007)(107886003)(66556008)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?95d8BCcX5qH4IQdDLS4UJ51SnCoOiT/AVGgVgiUoxo9SznzxqjlSM/jDn0+W?=
 =?us-ascii?Q?nqpfFekVRKLvJFOQzqcAQ5JRnJEVyLDqyNHIhmywyhWZFd9y2ommqbt9CWHg?=
 =?us-ascii?Q?0SvTbS7KfDqVFXGiAX9RqKbsPTEsMBJ/BNQxGTIcGy4QMVt1IAnezKQoFf8R?=
 =?us-ascii?Q?9NpkKstqoZb5PaBCsLPDyfNQTCOV2wU3m2GdiNgPTzRqO3/0Swh3mbK+3ZQf?=
 =?us-ascii?Q?x9K7vuuz0i3EQQdhb8zyKtmpyZaD9HM2ukIYFYG54G1T308F7/3/Vwit8Tpi?=
 =?us-ascii?Q?HJLSEQ6GHGo8wQgSizHRO6/gqhKCVsIuOhowK8jKu8uAyTW3KNzTYlMh76BZ?=
 =?us-ascii?Q?iJXXgGbycR/HYu8hlrHfRexIeSsuA8rLXK0MSbmQCxXAD7QAl1OLpLkv816E?=
 =?us-ascii?Q?T2TRvhXAtlyE7qjuBy4k/lfDw1KSK2IYKR84S5OWPi63v6vjElGKLzgnkui+?=
 =?us-ascii?Q?UEMTn5dGCNtXmJptN/is2iQ8z8BOpD8yK6mxfI0Iz/iDSa3LgWrIdk3K5fm9?=
 =?us-ascii?Q?wR/B7qhgFyMtUnjBLxPWfFanssaWX3MSoyCa4BPWDvEUhGYx9+vQbkEQnIZi?=
 =?us-ascii?Q?9S6I10oKy6yGV7B2LKNIIq3vuxsqY7csbM1PZa4n3mH9BcKsi0kuhdYPlLzT?=
 =?us-ascii?Q?8mZmluHw52aS6xTpZrSU0E2pnNheU+IXZ4ufm2V8vQQ3GMHswms1Q2dgaFU+?=
 =?us-ascii?Q?BiAG72MIcUDyVDUOLrBY4lOBiYhDeKy0E8SCb6eV3T0TMzwYc+jjawFUrUl7?=
 =?us-ascii?Q?vflrim7wZAMXcmajpeVF+6TY5o0g9TAMy3G/aglJDQkxq/L6l7tFzcw66IQy?=
 =?us-ascii?Q?IW+iqiC4ULdlswPjvjWQBYvKCrG+DcRa6vRPzQFbYNQ7xx3dG8ajjkvwpjC7?=
 =?us-ascii?Q?56JuIkTNgdbi3wvEX4n3bszZez+mNu35QRh6HrVMvAPiKY71TyI5LAz7lNZ6?=
 =?us-ascii?Q?M73AdRCN5BAw26tetZr0S8RxlvtekVan0C+n4IuBJiPfpGjKyvwgbF4aMmla?=
 =?us-ascii?Q?n1OATC8IbNMGnnNL8MZHsGGrkSkq72SRB1ZQNAxfmuFZCAKL50QOpnHpMZ36?=
 =?us-ascii?Q?5DVH65FwzpeYjlBJgNPPqO4qKpidrkvw2bLXnL7Q9WVFrpixrjwlteErrluT?=
 =?us-ascii?Q?p43qCQjk09QmFqOkDp+/kHMaupE41LudrTxjjYL0i/BycJo+daDNqjMkfEGt?=
 =?us-ascii?Q?emmMdg+nNuP+wHXAQEi7gF723ywK27B8447MMfHeDSBoIIxflFR+ijCh2L7S?=
 =?us-ascii?Q?NS+Vp3oShZWf26Y7ccnIpek6RO0Ql7xs3EDi6UY8z+CXSDYpU8t9RJuzmZdF?=
 =?us-ascii?Q?9OJI/Ibgvbigjxja6K+0KzmHUSXS2iURbosl1xABDQyYsaQ3Cxxh4w5u/6Cm?=
 =?us-ascii?Q?iotkKaV0LspRHnuWxPNhuFN94myHEBRcFbbOHpGMcHbyykBzlVnGT25ss5km?=
 =?us-ascii?Q?v6M4kcAg49tNoB2ujuMnXtDk5T9IGBsmQj2tvyQYDQ5gkvzs5ochoolCxWKm?=
 =?us-ascii?Q?hvW5RQCFfPzgxPn/OgcnBKe9SKxj76Xd8yneYPL1cL8kjN6TSw79T6kZh7nk?=
 =?us-ascii?Q?D/xON0ppipSTg8JuRd5AQMqJbiONh8eqHNY0exg2JYmk0/YjYn0zUJ57FOjS?=
 =?us-ascii?Q?D9y+L8qZIP01khLgYQraM7u3Ui4/29D6uFBZq1TtGaDhKWdpcsL628goyi9n?=
 =?us-ascii?Q?htxnU/1E9pfoJsYCQ79Er7RkcBov5w6wAfIX1WgyVAx4dT1uSUWw/hRpBnMk?=
 =?us-ascii?Q?ik8TiexWd4X/joFy48Thud7IED2XwWs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 192c61b4-5978-4a54-2102-08da1493865b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:28:27.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrUjtZy26r+d2A+CREEeHEs9+76stosJlNjCurd4gElYajYsE8VbnrqPI2UFWh9Ww3kXeh1boepei1fo+M/Xdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: __PSh1dJgOFE5CCfqQcFoqx_tTELE92e
X-Proofpoint-GUID: __PSh1dJgOFE5CCfqQcFoqx_tTELE92e
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

