Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D024475406
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 09:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbhLOIDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 03:03:53 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:46881
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240690AbhLOIDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 03:03:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFSVZFD6OfCVxlXQ67e6NXOmbPFSwI4aE/hTKGeFdgK1zkrMfNpd/UiEfCQqQH1yAKtrTuSACQ+7G8MwLYvsWYjb1KtnIBhm/mzJMROdkDkpqrFxiSWRsmUVmdr38JrhSfzJ7Ro7BTaN2tf6VgpFSZxg2/Rcb/bR007lxumne/MavM7lGfUxqKS/rXLzYmPZvdI70YCXmJaaegJskPnfcfoieuKBm4tDD6t62l8iAVfXL4sjd45BFDkJIxLqGjcCbXsdsqbwBGle+PhBxwq9ZAv0IkHmBLK3z84ObCIN3iXTirEl8BRjuJ/VQf7jPjXYU6mYqw73S7kbXH5Hd8/y5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1AaKzTPYROdFEng2TsbW8CUTYZkleJUCcK6fmBHdgHo=;
 b=hh6qmWYTxnGkpxEYep3soFi6jw/AD8hBcio6KYCjvHrvLAPBqv54lqshFWSSvCgwyac8Bdf6kQ05938m1EGRoyE0WuQSX57v0S333jNy1YeJKlOTRvNA7CpQglUSjKtJa6AdGPlUG8BoXRtYkQGpSTQxl6p85VrlfuveTN+Uk0RGVGG+YgSWnUqOZNvR5CQLuxiH0namTSSmMZuwkGgYYh7KUy6qOIvIyNCBN0qB43x3VBUEVGv1zVmpN2qkuAP5oXOiChgWM6p5CKFpwyN1MxcYHI7PpfPb2hyyXcgTrskkIxApapfET3/4ibdhOO8e13lQK3bTY+jrwquNlB8Ndg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AaKzTPYROdFEng2TsbW8CUTYZkleJUCcK6fmBHdgHo=;
 b=U71MMpgfnzcJ4wvFBygWkXgWlYniDjzQ26Zc5fsKNW7y7YFvzyKlyyeR8v1s6Z8+vQk2lzRliIK87W9DHMfCKcwHVIIgtMjcLSn3aTZyZAv9tgsbopt+okbpEgv/yGeyfPm9euw+zbPs3qQfZp12llq+Z58aJGwgzwxc/WnHxqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by DB9PR04MB9355.eurprd04.prod.outlook.com (2603:10a6:10:36b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 08:03:50 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 08:03:50 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, dongas86@gmail.com,
        linux-arm-kernel@lists.infradead.org, jason.hui.liu@nxp.com,
        leoyang.li@nxp.com, abel.vesa@nxp.com, shawnguo@kernel.org,
        linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        david@redhat.com, vbabka@suse.cz, stable@vger.kernel.org,
        shijie.qin@nxp.com, Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH 0/2] mm: fix cma allocation fail sometimes
Date:   Wed, 15 Dec 2021 16:02:40 +0800
Message-Id: <20211215080242.3034856-1-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::16)
 To DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7767e2c-e483-466d-215d-08d9bfa16dad
X-MS-TrafficTypeDiagnostic: DB9PR04MB9355:EE_
X-Microsoft-Antispam-PRVS: <DB9PR04MB935547BE3146F6C66401500C80769@DB9PR04MB9355.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zP6WNdm+Q37dDlIXnkWkaSpIZ4ES2iDseQH0FTlA88Wr0GXWE4g9rMcg+Wd6XU0HPi9iQkR6Jy+9fjI22zv1MswVAAySQk3Dn9tUjOQ2AWsjRzjDZ1SHYf6kCnOreKACVN4F39iXQ+B4odewtV5gWOnI0z9CfHZM6Q28AYY7gZTDeK5bogpZEqmn6P7o1mX+9M7DM6zglwDz9da+MRwt/aaBUCqmOvo0dlc35pFCzVe902RZwpiF7Xj+UI3TJWSJ4/Mu0T+UtzAt4wIlA05PJi7erQ4jb9vAK+IduZNIcayev4WLSrY89cPQsVGDSbREvYGO4OY9JgPLEY+aYRChvBT0zEAgSVzHPZmcqCyquoXYBQvf2U2jNs0gF4CYFw9bvOi5BlmSRfWf9fAwvrP4eyaOEL7ENi1HBVBBYiK2tFlp3SzcJdbCi7vF7Nje8mLcW4Sxxaw5lTm/WBbcIdT4wcDqhNV3BbxLNa71n2EymriRxJwkWLksn9/hiv5dCHsSLPOs+BDFO4R6c4+8R7acOOV/bfDtJKosFer3qUfsH7A4GXLBXqb4hG0DmPx+4hnTKeHwH+hKRiOrvoq12OtcFCKZnPGnSn7zgdwojZQMD7qm9cQIeMkvRykyvzN8ZaUNUDy0TN52pvEuwTYE0BcN+aPCtUuoNzrY088djkSlAn8QizA7kGost+U7ylDn37u5X0JHsi21QeE+B/333Q9vMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6512007)(6486002)(2906002)(66556008)(1076003)(7416002)(8936002)(4326008)(66476007)(2616005)(6666004)(83380400001)(26005)(66946007)(6916009)(316002)(38350700002)(38100700002)(36756003)(5660300002)(508600001)(86362001)(52116002)(186003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FfYuL8F5lYL1HyuOlqw5oM+WiWPrfqv1Chc1RodMgRva9YYS7JJD0YFdGuPV?=
 =?us-ascii?Q?e2ocvuigNyqUUtOlCuLuyQdG1ebLE4+SBGlLYSgcylX+rME1QkrF6I9lvfsf?=
 =?us-ascii?Q?fg5aNKX0o6lAvWfk9rUymw89cBZCbQ+ITNCyVu7DieHVvnev2PUIXlP7P9Tf?=
 =?us-ascii?Q?w4lHk9baFjMPgsReufrKX1m1tAtZ4uSARShaJtivlXOjjlDCQoczMR0/l3yu?=
 =?us-ascii?Q?GNSOjweA4cmpRsRWwHZ4K547WPQeHzZ+EQLN4y5ZkrMB+KnSvuJF5SJm2nK5?=
 =?us-ascii?Q?kfNemIv/qu/87FycWy0A0UdJ8fCUx8eSI7CY+HlKV0RDut+9at4CU+633gYD?=
 =?us-ascii?Q?3v+KNL/hr/A0JS3h+4cd3mGFqOJDBW+x/9nvWkXyiv+6v09t2u9i0D55YYjQ?=
 =?us-ascii?Q?qkWsei7Uz5IrBkngVhshiqF2n6Yo1CoQ78LrBttQRZzliTrdS5R+u8KQYxAy?=
 =?us-ascii?Q?Llc72YloZ+kNJYFEg9ePCuxuJ+acfHVJ/EvOIA/w6yWhUGaVcGFAkY3stzwy?=
 =?us-ascii?Q?0bMD1STWNvWLT8Gq+PcROxrpYJ5DpSup/0yPvJa8gjRG2rxiorZbttT89NDF?=
 =?us-ascii?Q?09UrW414x4MPaH6ZrH25FfdJTf3IQJ7q4mQ1kVkpKf5gXXmJFwc8DkBYR9zg?=
 =?us-ascii?Q?tXJ322Kt3l2YIuYL85gFIeZ4IE9BrNR4W90rk8ffIVcxl0xdICQIKP6zRguc?=
 =?us-ascii?Q?ncWff4zTT9W41YV4/tUxOLYUwC0OUxUIUbOdWxzkHIza4yO9EmGzaTEmQpgb?=
 =?us-ascii?Q?g62if7gDAicWpBedEK9tzuhpzwstANlXPmhCjBabD7UKzP5xSPaJ9Zz5tmL2?=
 =?us-ascii?Q?j21D78cmp3yq38+86OAeOCSMhr0fv6Gcsi0aw8hjev1dyPsQlXnfdYmUwTj+?=
 =?us-ascii?Q?SwjBUs7HaD+qbncgjkbhtRp2fu8NsHqF6z23CrSUVaTC4J5A8ob+PEFA5VUa?=
 =?us-ascii?Q?tcRF9H5Pyv5y3EJtOcZXknSVMuefLyONOw9THHEzNQCOO55+OaXGNBlO8zMU?=
 =?us-ascii?Q?BdazOoBROVRQohILbEinDUdcCCeuE5F/lsh+Np5z/WIuxQ7R6IHAQg72ydNF?=
 =?us-ascii?Q?GxrNzquAr5Y6W1ArtXAeZ2WDglH541s68as2pGBhGRo9tq3qcPeKdTCyRYgU?=
 =?us-ascii?Q?k/jy1Y29bMu+L+fvU9s33ROWhLK6P0UNCGNzQwIwpUKyvZbZTWobJKZ8Z/zN?=
 =?us-ascii?Q?Qa9Dc9nnOXVJyH+EPx5YPf2iKXf2p6uRwqvO7VBwFR61jGvHCOh7YvqqA8Uj?=
 =?us-ascii?Q?rS4CsjHbqfHSrFSrn4yWABO4nctH5QxyvbheFE3h97U3C6oqbN4CbPVwKMfB?=
 =?us-ascii?Q?RhW9Z0lPM1RH0m7pTKtC055GZ/xATU9+7jCoser+g4BB/gyIecTBP9ZuEbq1?=
 =?us-ascii?Q?me21KS0g2IZx3aM/rkdEvVuzWKoThuGxs3et0rf3jBBq5L1KUefn8/qydgTV?=
 =?us-ascii?Q?g8PQtG7gtZLSfrdAI9AV2NmoUHyVuyayDGk8vPptDxnfzdEI3bYPugnpIyxe?=
 =?us-ascii?Q?Z0qM01rzolgrzlwQ+3P8kxVXwVoIJuceo0YHHLDVqS6IWSVlmaDsVW9cW7F8?=
 =?us-ascii?Q?TmcYXsAURu7f+Amgk1hmJZc9t5yoRyKUTKANftwMadUhhyYgOcI3iRoB17Ei?=
 =?us-ascii?Q?36XLLe/bdjkxokXfbmpQxkM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7767e2c-e483-466d-215d-08d9bfa16dad
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 08:03:50.3484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +X+xMo4Ft9Ymmhwun68nJX8XL+4Ulf0auxs96tXsBxMR+kPP4VqYWQYjPb6M+hZVqCe16CtM8oJuJ7ATzNYcNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9355
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We observed an issue with NXP 5.15 LTS kernel that dma_alloc_coherent()
may fail sometimes when there're multiple processes trying to allocate
CMA memory.

This issue can be very easily reproduced on MX6Q SDB board with latest
linux-next kernel by writing a test module creating 16 or 32 threads
allocating random size of CMA memory in parallel at the background.
Or simply enabling CONFIG_CMA_DEBUG, you can see endless of CMA alloc
retries during booting:
[    1.452124] cma: cma_alloc(): memory range at (ptrval) is busy,retrying
....
(thousands of reties)
NOTE: MX6 has CONFIG_FORCE_MAX_ZONEORDER=14 which means MAX_ORDER is
13 (32M).

The root cause of this issue is that since commit a4efc174b382
("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
memory allocation.
It's possible that the pageblock process A try to alloc has already
been isolated by the allocation of process B during memory migration.

When there're multi process allocating CMA memory in parallel, it's
likely that other the remain pageblocks may have also been isolated,
then CMA alloc fail finally during the first round of scanning of the
whole available CMA bitmap.

This patchset introduces a retry mechanism to rescan CMA bitmap for -EBUSY
error in case the target pageblock may has been temporarily isolated
by others and released later.
It also improves the CMA allocation performance by trying the next
pageblock during reties rather than looping in the same pageblock
which is in -EBUSY state.

Theoretically, this issue can be easily reproduced on ARMv7 platforms
with big MAX_ORDER/pageblock 
e.g. 1G RAM(320M reserved CMA) and 32M pageblock ARM platform:
Page block order: 13
Pages per block:  8192

The following test is based on linux-next: next-20211213.

Without the fix, it's easily fail.
# insmod cma_alloc.ko pnum=16
[  274.322369] CMA alloc test enter: thread number: 16
[  274.329948] cpu: 0, pid: 692, index 4 pages 144
[  274.330143] cpu: 1, pid: 694, index 2 pages 44
[  274.330359] cpu: 2, pid: 695, index 7 pages 757
[  274.330760] cpu: 2, pid: 696, index 4 pages 144
[  274.330974] cpu: 2, pid: 697, index 6 pages 512
[  274.331223] cpu: 2, pid: 698, index 6 pages 512
[  274.331499] cpu: 2, pid: 699, index 2 pages 44
[  274.332228] cpu: 2, pid: 700, index 0 pages 7
[  274.337421] cpu: 0, pid: 701, index 1 pages 38
[  274.337618] cpu: 2, pid: 702, index 0 pages 7
[  274.344669] cpu: 1, pid: 703, index 0 pages 7
[  274.344807] cpu: 3, pid: 704, index 6 pages 512
[  274.348269] cpu: 2, pid: 705, index 5 pages 148
[  274.349490] cma: cma_alloc: reserved: alloc failed, req-size: 38 pages, ret: -16
[  274.366292] cpu: 1, pid: 706, index 4 pages 144
[  274.366562] cpu: 0, pid: 707, index 3 pages 128
[  274.367356] cma: cma_alloc: reserved: alloc failed, req-size: 128 pages, ret: -16
[  274.367370] cpu: 0, pid: 707, index 3 pages 128 failed
[  274.371148] cma: cma_alloc: reserved: alloc failed, req-size: 148 pages, ret: -16
[  274.375348] cma: cma_alloc: reserved: alloc failed, req-size: 144 pages, ret: -16
[  274.384256] cpu: 2, pid: 708, index 0 pages 7
....

With the fix, 32 threads allocating in parallel can pass overnight
stress test.

root@imx6qpdlsolox:~# insmod cma_alloc.ko pnum=32
[  112.976809] cma_alloc: loading out-of-tree module taints kernel.
[  112.984128] CMA alloc test enter: thread number: 32
[  112.989748] cpu: 2, pid: 707, index 6 pages 512
[  112.994342] cpu: 1, pid: 708, index 6 pages 512
[  112.995162] cpu: 0, pid: 709, index 3 pages 128
[  112.995867] cpu: 2, pid: 710, index 0 pages 7
[  112.995910] cpu: 3, pid: 711, index 2 pages 44
[  112.996005] cpu: 3, pid: 712, index 7 pages 757
[  112.996098] cpu: 3, pid: 713, index 7 pages 757
...
[41877.368163] cpu: 1, pid: 737, index 2 pages 44
[41877.369388] cpu: 1, pid: 736, index 3 pages 128
[41878.486516] cpu: 0, pid: 737, index 2 pages 44
[41878.486515] cpu: 2, pid: 739, index 4 pages 144
[41878.486622] cpu: 1, pid: 736, index 3 pages 128
[41878.486948] cpu: 2, pid: 735, index 7 pages 757
[41878.487279] cpu: 2, pid: 738, index 4 pages 144
[41879.526603] cpu: 1, pid: 739, index 3 pages 128
[41879.606491] cpu: 2, pid: 737, index 3 pages 128
[41879.606550] cpu: 0, pid: 736, index 0 pages 7
[41879.612271] cpu: 2, pid: 738, index 4 pages 144
...

Dong Aisheng (2):
  mm: cma: fix allocation may fail sometimes
  mm: cma: try next pageblock during retry

 mm/cma.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

-- 
2.25.1

