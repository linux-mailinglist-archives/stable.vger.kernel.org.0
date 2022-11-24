Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B28637560
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 10:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKXJmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 04:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiKXJmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 04:42:00 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603D412296C
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 01:41:58 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO9AFHR018907;
        Thu, 24 Nov 2022 09:41:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=j0WGJaxiSL85qH5w7enOkdwD/ZE18QqCvIf5utogPDM=;
 b=COr6sYtLGcGc/iWepazT9/DH7LaMJ+ApxNd/TdW8SEoUeBb6X+xZgLdcz/11vHrutrXI
 hCO/juIy0URE0R9yG5kJMqxa+yxo5RnIFDpFWXYjOZM+UTXTmJs7RON1d8enVGilCQVo
 phWEnBr47ZEAYFBg8W57ZsMIkGpWG5mu15xOg7nZU89O/2jxpWq0I6HLIxAFTkr5TQkd
 bE73wZYZxwtjEiBqF2RvjKDvxug8dQD1lpZlwoVqBLGWMbLIJ0QImbCAIguzs0piBX9P
 05xnPdBQ732k25HMpaW9PSCmK+I84DUNSHy3jyZkDS82msfqzx1cj35DoLUQBD3GG77C RQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxnxj44k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 09:41:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqZg3UGY+ukj4zY/QQmS1SlSytjNuItVrU6u6P0qWoV7zaofhqsfEWDtKM1IHj1BiCZ8CzMugOXnU0T6kfc++4+pWJpqW5Drp8HdktQRBHm2iDjjIf1JhWCOrshPJBZX4uS7ZCEU7Rw5LtqdaJMdDsMed/1y9NWV7/ua8nD7k1jyJlv3/0JLknT4yiiXZ+DpwLUe81FQhE/RT9lRI4m7erYr4kYaXXmYMXfYqgOHWypaAVd34F/ic1B+wgfIo2XxzTr8F46TeFJcF5ZVpSb05RTF6Ke3ayVaiNtgR0t4j5Z/PzeVQVmwIlLGr1sjsjaSbohOP8VXEmmlA60V/iP1UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0WGJaxiSL85qH5w7enOkdwD/ZE18QqCvIf5utogPDM=;
 b=EQklxS88IxymedAvw77g69BwPY2F/7edC65gukklS6gVO4UIvvMiHIbMzTg5guQq6qdBSYm9+EITrun9y7j1dOjcjWYxjZBxo9rvFmj4Ddht9GWjd1Hr++A7w/N4TGkrjeN7fxlwaV0IJVoMFk5QaeOYEOsbcQvYoOJ998/Cu6lcaahswlFsKHM7X5ijWIYWl8kr37TaThnyajpphdyXXmSGtfrB/l1eLbbuifVRXxrGct3ig9FvHSBmhxig8ZPuhFAkMpavQr2talR15ZQVh3GkcAy+Fetb+OLCQdQ2GEDtMnH4fS+Voh7v9+E+IIFuadKAmMpeJNO44DpoTrXQSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by PH7PR11MB6403.namprd11.prod.outlook.com (2603:10b6:510:1f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Thu, 24 Nov
 2022 09:41:44 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%7]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 09:41:43 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/1] tcp/udp: Fix memory leak in ipv6_renew_options().
Date:   Thu, 24 Nov 2022 11:41:15 +0200
Message-Id: <20221124094115.2537378-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0036.eurprd09.prod.outlook.com
 (2603:10a6:802:1::25) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|PH7PR11MB6403:EE_
X-MS-Office365-Filtering-Correlation-Id: 076e5596-64e9-4576-e7f0-08dace0017f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xt4sVpZlfWmPe3kIVcxfACIdmj7tqsWhgJxnFwq30HuBhtt9nvyE1mxJNz9m1kzFCtG7sbIl4iDO5jROG6qH1Ws2zmBN7fR/MS/g/LT0SPvrjmFntr8RdchqgwseAw1s5E3kiG/Q5rs4z63O3DJmmkfAAJABHHAPWykZ1sVoOEpMNGNj5585JwM1yrL5LNevOw3/qnh6FmIuw1SRPOfaB6ei7GUzNrkSk5TUiScub0fNmSpmnyEcTbEGKypEJZF5JXt8i+x8NNvU7YxNZWeK4671WRYltzk1dT3OjfmfatCRN73iupkDN7FAI9r2sFrKtRKKcGaGG4fycwB9inCfzeKbg9MPNWYJQ46KhHGyGSJkTofFGxsSs8CMBdaZ2TIoJGfKuYqfxEGc0+b7LVhKY0Lb7KN/vwSRV/RavUt+D/C16/ioO2a2txpmJFVKI/YGgDbU9JmUWRfGhu4ZI5QhQ1rDcce+gM+vnN+YyZYFRS82mYnkOuSEEhM4fzh3vQu/xBsrj363ynvcoul1WWWe+KK6B2YzR7RJ/gybSSKTyIUmVa8Kv65sYzR5BV/FlwCaOR9OsOIhdVizp+7godBagZ2tHCW7pfnm42iVleZJbnc21N/qiaGQxetiJO3iZPnv9h85029u021ynL1ditT25YTS1QrtrVTIusBXho8sVH/lqlEiPBJyGBZeHK36twuO0kt1mRk1KSdgKgwP+s/0vthOCJVgaNXZyfpULyc/K1jqxQ4ZqKGaW2UYRuQTVF7G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(39850400004)(136003)(346002)(451199015)(41300700001)(8936002)(2616005)(186003)(52116002)(54906003)(6506007)(6916009)(36756003)(4326008)(1076003)(316002)(66556008)(6512007)(8676002)(66946007)(26005)(66476007)(86362001)(38100700002)(38350700002)(44832011)(5660300002)(2906002)(83380400001)(478600001)(6486002)(6666004)(107886003)(21314003)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2TE7T4jKCd1Eixw18n1rI4+g++qrygi7JGbf6+i7N2OfsU70nnFeRRYOME1f?=
 =?us-ascii?Q?z4n9rfxlkvFWqD/KS++EVtSHsGYYI3xpnB2TrjKk3N9SklN7Y4FLISEQ2dny?=
 =?us-ascii?Q?l41oJj893XnwmSHP3gm32ooK0lrQvQvk6YGtHGtCkKWVKK26PihFitBBI5Q0?=
 =?us-ascii?Q?Wyw5ynOOdixk33Ift+oNUBzkWiIamwkRaV03VuRzIUfHwxyXzYxOCdqvyUO6?=
 =?us-ascii?Q?YoRnq6SZePzKjuMUJg/J7ceIM0IgamFoMIKzx4xwmUPnqGGo0uYjgF8dsUkg?=
 =?us-ascii?Q?0OxBTbp8GkXjJtivrujsOH7ESTGN5IU0L5UDQrQq5ODSvAMqvV8XxBOTEjih?=
 =?us-ascii?Q?4kMuErfDRzFH+CLj0m9dQggov2WFuD//ZIoQ8rB98I+GRW15Oq2CcMeyABKp?=
 =?us-ascii?Q?3bTOK7BHXZpHxF23Cyy5GRJiPaKww7EsByE7Ead06tyW5IacAFZlgnL5qojO?=
 =?us-ascii?Q?2k3j2z5d2RqQe1KI1i4ieLr2ILDGy7FPT1530GYmTmLrr4Z/GCwQbjeoVh2R?=
 =?us-ascii?Q?RqkR0KWAN/dtIdCtw6rvssyIvA+2yJhjirkRFjPVoXE1qZvdj51Z5YYELmre?=
 =?us-ascii?Q?8YM3LbC89hZXBzMa+QAjpXXYgmwGanCtIqLXVhRUYgA0f5IRD5J/s8KOrD4k?=
 =?us-ascii?Q?3dxvBFq94780J10Iejv9U7VNEYmMD6nNzGoaoPp4yl5WKHmfGebEMKjtSdEB?=
 =?us-ascii?Q?RzNeTOpQeeB3TgVrzcrSeZBngxLqO99Go/Pl+hfCefcjQLsDmRtfP84FQsNn?=
 =?us-ascii?Q?G4fXG7S5Kv5Un+3nKNBycDf/W+1GSNSAeOQr2ayvdf5M7Wgi/wgx2rqNoyWT?=
 =?us-ascii?Q?hHIrr3wscPhQaL+ybVP5tmdNbnwumMbI3jzKAav3qt0fp1lFNBmTwnR6auSN?=
 =?us-ascii?Q?Nbaq8TLf9LfihLSyTtZhw3MjEdFmUCg/bNZsQqmnKIMXnIIt3MKiazgSFKae?=
 =?us-ascii?Q?IJzJqbszh25AtZMHv18toiovUgkx9fgqMujhtjUDEgqBqX0NwYK5VNIucAy9?=
 =?us-ascii?Q?5us1Vd7HoMJJNkevT3xC49MFtd8MPRkDJPXr+y9ei3FMbG1LCA1oVNqkAwsa?=
 =?us-ascii?Q?CdOOulFaFggwGzLQgK1I4XRQCp+jO0I6PckZ1B96WSXKX1I3fK7uX0B16OZY?=
 =?us-ascii?Q?lLC0CGv3InDPH95vsJcioY9cw3qFyJydQsNBlTB832W9yv0XtrBmLH9v7qM9?=
 =?us-ascii?Q?QwWw3lQPr5x/czEnFLss1r1pq6np9xhQWRY1NHDTmtOPj3UM0yKvUtd3cN3I?=
 =?us-ascii?Q?ZOMP6OFfTF7x4flgEVdabaCMe2WRNrfoL2Mp5Sj2c/uRV0VIK6r1YIUevCo6?=
 =?us-ascii?Q?7hik11RpTAAW7LoYwyrhmG1Ax5+fETxpukpl6lWjZkVT7FBSuiMrC4KHzaEl?=
 =?us-ascii?Q?scqfkk3axoSBy6WjaLKCO/tScmh70K4HCIM4IXwU2qu11TBi2rNAJlZn3Z4X?=
 =?us-ascii?Q?2052vCSWR+XLJsaCH/QJKU6ybQd36oHcleFP1TZqL6L2GtRmHfM7JivIrwzF?=
 =?us-ascii?Q?LXs2YlfoKxA2NddOQxZLWmbrXvJEI+ODR6nSdDes8KXclQucpdbCQ5Pu7PR1?=
 =?us-ascii?Q?bUsBINjPQwZv2ALGiCO7fKqOSaMh58oZqfDn+IUktOVgHxHxbiFSsRyg+qWl?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076e5596-64e9-4576-e7f0-08dace0017f4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 09:41:43.7489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9n4ZPO4wYW1dGXSApdfVRCBLmu98RsJf8vmFLfYFs2mU9ve65O6BhDQ0Rn0FNQksGTmIzZFNcCFlpeMbiInemwequ+RUgUvOdMpgzJsAOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6403
X-Proofpoint-GUID: 6KMDqNy6EBzk-KBjY3nXsYdBpXFy93oA
X-Proofpoint-ORIG-GUID: 6KMDqNy6EBzk-KBjY3nXsYdBpXFy93oA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=758
 priorityscore=1501 clxscore=1011 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 3c52c6bb831f6335c176a0fc7214e26f43adbd11 upstream.

syzbot reported a memory leak [0] related to IPV6_ADDRFORM.

The scenario is that while one thread is converting an IPv6 socket into
IPv4 with IPV6_ADDRFORM, another thread calls do_ipv6_setsockopt() and
allocates memory to inet6_sk(sk)->XXX after conversion.

Then, the converted sk with (tcp|udp)_prot never frees the IPv6 resources,
which inet6_destroy_sock() should have cleaned up.

setsockopt(IPV6_ADDRFORM)                 setsockopt(IPV6_DSTOPTS)
+-----------------------+                 +----------------------+
- do_ipv6_setsockopt(sk, ...)
  - sockopt_lock_sock(sk)                 - do_ipv6_setsockopt(sk, ...)
    - lock_sock(sk)                         ^._ called via tcpv6_prot
  - WRITE_ONCE(sk->sk_prot, &tcp_prot)          before WRITE_ONCE()
  - xchg(&np->opt, NULL)
  - txopt_put(opt)
  - sockopt_release_sock(sk)
    - release_sock(sk)                      - sockopt_lock_sock(sk)
                                              - lock_sock(sk)
                                            - ipv6_set_opt_hdr(sk, ...)
                                              - ipv6_update_options(sk, opt)
                                                - xchg(&inet6_sk(sk)->opt, opt)
                                                  ^._ opt is never freed.

                                            - sockopt_release_sock(sk)
                                              - release_sock(sk)

Since IPV6_DSTOPTS allocates options under lock_sock(), we can avoid this
memory leak by testing whether sk_family is changed by IPV6_ADDRFORM after
acquiring the lock.

This issue exists from the initial commit between IPV6_ADDRFORM and
IPV6_PKTOPTIONS.

[0]:
BUG: memory leak
unreferenced object 0xffff888009ab9f80 (size 96):
  comm "syz-executor583", pid 328, jiffies 4294916198 (age 13.034s)
  hex dump (first 32 bytes):
    01 00 00 00 48 00 00 00 08 00 00 00 00 00 00 00  ....H...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002ee98ae1>] kmalloc include/linux/slab.h:605 [inline]
    [<000000002ee98ae1>] sock_kmalloc+0xb3/0x100 net/core/sock.c:2566
    [<0000000065d7b698>] ipv6_renew_options+0x21e/0x10b0 net/ipv6/exthdrs.c:1318
    [<00000000a8c756d7>] ipv6_set_opt_hdr net/ipv6/ipv6_sockglue.c:354 [inline]
    [<00000000a8c756d7>] do_ipv6_setsockopt.constprop.0+0x28b7/0x4350 net/ipv6/ipv6_sockglue.c:668
    [<000000002854d204>] ipv6_setsockopt+0xdf/0x190 net/ipv6/ipv6_sockglue.c:1021
    [<00000000e69fdcf8>] tcp_setsockopt+0x13b/0x2620 net/ipv4/tcp.c:3789
    [<0000000090da4b9b>] __sys_setsockopt+0x239/0x620 net/socket.c:2252
    [<00000000b10d192f>] __do_sys_setsockopt net/socket.c:2263 [inline]
    [<00000000b10d192f>] __se_sys_setsockopt net/socket.c:2260 [inline]
    [<00000000b10d192f>] __x64_sys_setsockopt+0xbe/0x160 net/socket.c:2260
    [<000000000a80d7aa>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<000000000a80d7aa>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
    [<000000004562b5c6>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ipv6/ipv6_sockglue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 4e1da6cb9ed7..4f958d24f9e4 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -166,6 +166,12 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		rtnl_lock();
 	lock_sock(sk);
 
+	/* Another thread has converted the socket into IPv4 with
+	 * IPV6_ADDRFORM concurrently.
+	 */
+	if (unlikely(sk->sk_family != AF_INET6))
+		goto unlock;
+
 	switch (optname) {
 
 	case IPV6_ADDRFORM:
@@ -913,6 +919,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	}
 
+unlock:
 	release_sock(sk);
 	if (needs_rtnl)
 		rtnl_unlock();
-- 
2.38.1

