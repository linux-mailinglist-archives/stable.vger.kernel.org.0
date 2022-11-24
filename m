Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D457637575
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 10:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiKXJor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 04:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiKXJoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 04:44:46 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066476D4B8
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 01:44:44 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO8RNZG024933;
        Thu, 24 Nov 2022 09:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=7ykormMEI3k+AeEI74IfnAE/a1NNdhV64C9RqHsrsco=;
 b=LFDVfpVpV6thIUOGYQUHJN/LXLq5QDCodvHL4G/leRwQY+f4TRiCN+NTrVTbD/ADCQ64
 qw6Vod9dQpU5DWUIMT63kcXuNuadAT6ddrNjsTLC+faJIUI+pwm70359rpxICaNawEw4
 U7RYFMrrCZvgfKwBDe4HhTQ3YgAJc6yInntKJRo+pSM6sqGZe2fI0/xLhbZpQo/Uh+M1
 5QKPz/qcZ+VKm4JHpy0+XehAOHIOyMdZO2axyLZn50yModiEJrQrnndqXPAmOaglOOZj
 T0WNaEw04psQoBWlsHpZt1oH1je+opIfhp3TD6SdyadSAIIJjJbeBdNTNBC6c4xQr2JJ 7Q== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxnxj44m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 09:44:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSmQrTtbuKGYiAHnXijFKKAgVL9TMvAqylQRoH4TjHm6IOAIvX+R5gLgNRKDITy41XsPSKFOoGHvPmR610S4hQ3UZhPVsibCW7YXWDYQh5yPjCVvlBt+jQuN+MJ8H+spKEbXWLxWKNE4JsSvvhRPvFeGaCxhp7C9uys5PWE1Hpxav9ViYUYBd3L8cU24du9aZfPGSEE5de3JYs4U5nzwqKuqs8N+enty3mzYU6qv11Q3FP1QykhY7Kv2clE7Ry2dY6QRJV58ygoWUJmrpZoOsJNiCYuP1gfiUJniPdUO3g3WPyLRto1YFDnoQiU1Z6LyAiRWmFNrB5qjFDnPWErZrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ykormMEI3k+AeEI74IfnAE/a1NNdhV64C9RqHsrsco=;
 b=JQ6i9ZZBGInupfeeSZf8+4D7LpMj2448YzgiI3VcahcLmY65IdwUFQo59yXlGxj8df2U/3YM2twF4+0jnbcuQ4cYU6YlKIjV6s6cXJ6UyB3xgdVZMlXtCa6B8dcBz7LiGYmrhxnV/XVyCdQCcKSebCjGSe5wBFO/HxaCDWJOWrcXYnGuXrZ9KiRaq7CTD8QZrQozA0nWyxSkd0KB5dozIvXK5W0x0LLSWn7xiz4VcAFt4RXstTt7qbXrJkRwm3sKHLN6O27iqyMvXVPlIC8+4i7EbpIXy8N6gyD4XFQOW0CLdoiXxv8etWA2Q+Tlg0JG+Qrr2naJ4rnoXIGFtdUsKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN0PR11MB6110.namprd11.prod.outlook.com (2603:10b6:208:3ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Thu, 24 Nov
 2022 09:44:33 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%7]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 09:44:33 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 1/1] tcp/udp: Fix memory leak in ipv6_renew_options().
Date:   Thu, 24 Nov 2022 11:42:26 +0200
Message-Id: <20221124094226.2537476-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0098.eurprd09.prod.outlook.com
 (2603:10a6:803:78::21) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|MN0PR11MB6110:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c5ce9c3-69df-4f13-6f0b-08dace007dec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /KUgcz5rai3YR7v42e20sxfYfPHK3Spjn5ruoRS+iyCixybNzzw29tmzRbr44DQG1k+F6DolnPg+eM1HpFj6MYF4RLQDrOUP4QfpmpzSQcTowGCGg/vuCN6Jy1yUJOFhdcXqTWG7hPj7ModuaBt9jghZK+7ste46T91DAXAlgk0g7nxdMtARsLYcYxLL8Pa3cA7NrWjDSRC7QuvL5yzqCE+uay3m0fsQOgHCLT53htfhqwTnYaOyx+RcdNxGX2fC9mnn4Ynk1y4KA6KoPXGP0iUt4LjZDOKnvEdJCR8kLiD5FMrjvWPk6MLP/NPsy386mz+ryqzlsIEZbiNbJnvChUdzb/azxvx5Aa4XJ+gtP9wH4S1vxymU6H+li52ngBgt2toccIyv8eqgCK8B1an/9/bnUJ2uQYLc2osvmDdq0SFiSRPl93HEuK8bQrmh33OMn2Pjx90DYuXZc0n0qxjqWVKkbV1Kr0Csm74nSpogfF945ZQyjInENgSdpzfdJ2JKMuZ0juYOR27CR/6iVmxE7dNgGyXt2DsJIcxeE+BnT+5kZKTOiNJv3qAowpg8kgarB+Y4pWzrcN6O7mIWphnrE05DrQfPBIHffrCTKSqu9suWahdoEv9IvP+pp848C7d0sc2yAm3tQQcol666oeKrwaLqWdlh2oZg5C0Sd9OgJz/YwdE9VebKiN50Sucuol+CPN7riTpsFohSn1D6EBOTth3BzVbXfxgkyi25LqNb1yP0PHzo7UkdJd7DU0B1vL04
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39850400004)(366004)(346002)(396003)(451199015)(44832011)(86362001)(54906003)(8936002)(36756003)(5660300002)(6666004)(2616005)(83380400001)(186003)(2906002)(38350700002)(6506007)(52116002)(8676002)(4326008)(26005)(478600001)(107886003)(66476007)(38100700002)(6512007)(316002)(41300700001)(6486002)(6916009)(66556008)(66946007)(1076003)(21314003)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZDGG8cW49+NiVvZD4Lzx7b7e1NR/4g4vzQ9nrBQ0QLWXibkNKTqMBql/BHW6?=
 =?us-ascii?Q?BLXutAtiOjPWpDFsm7EYASLrbz0+zPcB85QeoadJdDyY5IFijvz5RUBaJn2R?=
 =?us-ascii?Q?BDIBVCv8wdu5evEV5gajoyt+rKh+3qgQUlzBWCDkpSm00jtzzBQtEBf6TGIM?=
 =?us-ascii?Q?mcI/edGZV2XNeEPsKmAv/cV2JOc8XSLiGPpMx7I/cFkoNYGO9PYaNonEGSxJ?=
 =?us-ascii?Q?JFNG5N7dHitQB5TOnEzCE6pJdQPlxuSvYVn8Xw7eb3ASguOHZnn1atSlv2VI?=
 =?us-ascii?Q?ezu4oQgrzOlXLYvN40m+QMNtmfsn7bV6Y79h8ZzphD081Buz6acxQ4Sw3QAS?=
 =?us-ascii?Q?gJ2oHkW/Zm2L/o50bXI7ouT3HVH7OHDDqEPhEM1wv+L6ffrMR0dmp/KOd/Zi?=
 =?us-ascii?Q?P8blgPuPnPTWiQaQm2d3bxYRGp3Oo+ZKFGkKF2Ea/VtqaLNbN5jgTd36sD+B?=
 =?us-ascii?Q?sg6mASl0ZyrFjDFbQTqsJKFlrZlemnMqY6sV9Q6ribqU7jdG9+yrejrokzse?=
 =?us-ascii?Q?AAYgBh2BCghgd0p9qovP3vE+0AMp671KfgSQGr7FGsUjHjozxzwd6AhSHiws?=
 =?us-ascii?Q?jYeGgg4lEe/Z2b2WbF9rt9Q+N9fD33j8Hryhqc+DGF7bTerFkwinaIH+JhwP?=
 =?us-ascii?Q?/EWJ82bwAd46ed92w1j6J8+bLidDSXDTE90wmV/Bk/NWBtTT/6A+DInoaRss?=
 =?us-ascii?Q?R5nWFGhjxxNZ9/+XjQrhqcup0Nb+zan5KDb7O6rlbiYsRgGyPptUqeM1/rbB?=
 =?us-ascii?Q?qPZCMpMyuuMPKPiF9vS3oH0Qh7hc8bejL2rIONpWBBYt/XcwhMYC0Cbr/9e3?=
 =?us-ascii?Q?AJ055HK1ewcQ98RWqL3qNvAEjAOs1F/3wrW/ZIuPUQ+Z0xeCQbdxYUtYzt26?=
 =?us-ascii?Q?DiZGt/zIOYvntyMu4ocgl+lnK3nKMQVE8a10oDgAc5syCppokRdmRzzAdaT1?=
 =?us-ascii?Q?YOGZjVoIIaI65kPZzTt74ThJKldZLolvJHPQGQAZSmbm1MOW0rv8dkn0MMmJ?=
 =?us-ascii?Q?Nl0vAlXy7mFy/kUwc3BOc0pZz/gGsAnke7m2VKFjj+RGGfXtAZRLokyD/0ym?=
 =?us-ascii?Q?vnYrgqpNfrdXRmh/dpA5rvSM3J9XxReUKDn3mII1IhUQX5BJomhK+Pg7YZad?=
 =?us-ascii?Q?HsWmCAK/V6+T7PzmjywdZUYZmTyczfaAY1zEwVLrCIdWhsUMe6U3gKwftETV?=
 =?us-ascii?Q?wL6g4LpSS3RDp5Wk7WplmY//m386J51Yi0IShLnxF9DjtoD9EX0Nx/cBZTvt?=
 =?us-ascii?Q?QPm+P1QcghZE/iUiLi2c2UWhaa6tI1fufyLzXO9tcvtun6cxk3qjnIxYWe9e?=
 =?us-ascii?Q?1nodEOGwRWRCr1IOd8wG+88vH/zrZaWvwKPNjUEn92GZInwMX9zAbCD89U45?=
 =?us-ascii?Q?iKXVdpuWJD0WbnKhpE5aq+/34rAV9qfoB7wFL0xxDbOND+sQIG2WmLClCf7+?=
 =?us-ascii?Q?wrgUrTtW/3YMDh/oxUMWPKueBROpE8M1/WO+GFkYqQkNdswRJWuMArPYGRsJ?=
 =?us-ascii?Q?KQcuQhvR/ztM7cdFuDnOdWFna+8Idc5s+VYCdxOOwxz16Q4npqZWmoHG+7D6?=
 =?us-ascii?Q?1dyYpRPFvs6V0VkkI/MBMFmY3wwQNfdIStYoryPXxH/b1gQgzgQ27soGjTD3?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5ce9c3-69df-4f13-6f0b-08dace007dec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 09:44:33.5877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7u3ck0Bi8PGbK2uTXcfXrcPMh5An1vUIH8W2Kp6wR7McleSjezngVggdltOuR/ZA3L8T5bGAUZlsE5+CIXsT+4+CnGMmesiEsD4M6/tiOF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6110
X-Proofpoint-GUID: ICuwvBlKuejgrEdqg259HCiwTntiv-xG
X-Proofpoint-ORIG-GUID: ICuwvBlKuejgrEdqg259HCiwTntiv-xG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=758
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
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
index 3f44316db51b..3c099742c58e 100644
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
@@ -905,6 +911,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	}
 
+unlock:
 	release_sock(sk);
 	if (needs_rtnl)
 		rtnl_unlock();
-- 
2.38.1

