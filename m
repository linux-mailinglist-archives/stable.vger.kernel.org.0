Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C81462057
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 20:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhK2TZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 14:25:26 -0500
Received: from mail-bn1nam07on2107.outbound.protection.outlook.com ([40.107.212.107]:50149
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235981AbhK2TXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 14:23:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOGp9AkF53oua5/zG7t4aoyCLYu2xJKRXQkWgFP4IfTX+w8PNAtBstHmCM+BosJri8vt/UDehkuwCqetwELLTYhZWsjaQrmSu2YEHYUYGEGQjbA38lOO+60ucpXul+dq9ZCWl9Jxde2aaPeI0OTMx5mmp7rKDZ3PZsZYcJPDb65Ub4s+fFXSg5CfEs2Sq6eg4FWs1NUZ7gF+2JnI/f0DZm9URj/gbRF//fsRHOoZa6UnCicKrdik8ubLDcMu5j+BQxQM9o9ElYiY7oZdAwTAqCUVgQoSHCwXdlPMOLZlbHqTMsylTfhijD/H/281mHX06Ty0D3aD3ExMlVUVtPghXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBdNusOiFvUVppXFtGgvFYMvx1bUKIN7+urXkQa9CgY=;
 b=Iz6QTI7f/luuGUqqK960SIdlvvMaNySlS0Xz7NiZkE5Nzsu2Fka+BxakhjYUAXgLe8B55BbBYKf+Fhc++12nxk9pcgE6ZtyrQUzxPQFzY+bC8YL9HX32f6zHtAQERC6fUPYttOJo1yVCNXRqdJZx9SEvvE+UusNAYJGqsU3O+QHOyPWRfnNBUChALXiVM9chOchbktOKPH78mizzOjb1wwZsF7kE1x9rrxB2tYTGgWD8UUKpVOwOD8KJ8eBf5BIXqdt2o03YgfcehZUGHnmWwJPd/ES0DKKToLvOuvccrdTVwlgf0rd7hOGTI4mEnZnsH0HP2hTfodqGEaboW0BVOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBdNusOiFvUVppXFtGgvFYMvx1bUKIN7+urXkQa9CgY=;
 b=EJNjE404pVzuX+aKJuvoEr4LupEHmlgve8D7cNAT8D6Ds1bt01P4maZhGH8LjKs73m86p590fODxrzplzx5bBiTcaQj/E4YL9jvGZ6WVLkmgEYjBiyCT/jWdyRGbHL7POvv2G40Vxj+wvmnNQwoHjmOpSDAELxIqTafZQhJU6JLaWSaK96dBxU2olopOePXQHpKYRVPWsbTqsCLuWO8XApm6K38+S1F0UJ5OozGnI9J8mCRwdrdLZ/9xiDEPUMlRzL6rYBvDCV47+Ck54fYwjJi2ycD0TAhf5VKq2wynQK43JENx4tNTvL8qXyeqPZYAJk4ZxWvo8d2UVz7V5VsB/A==
Received: from DM5PR21CA0006.namprd21.prod.outlook.com (2603:10b6:3:ac::16) by
 BYAPR01MB5558.prod.exchangelabs.com (2603:10b6:a03:123::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Mon, 29 Nov 2021 19:20:04 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::9f) by DM5PR21CA0006.outlook.office365.com
 (2603:10b6:3:ac::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.2 via Frontend
 Transport; Mon, 29 Nov 2021 19:20:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none
 header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=awfm-01.cornelisnetworks.com;
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 19:20:03 +0000
Received: from awfm-01.cornelisnetworks.com (localhost [127.0.0.1])
        by awfm-01.cornelisnetworks.com (8.14.7/8.14.7) with ESMTP id 1ATJK3H2118300;
        Mon, 29 Nov 2021 14:20:03 -0500
Subject: [PATCH for-rc 3/4] IB/hfi1: Fix early init panic
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To:     jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Date:   Mon, 29 Nov 2021 14:20:03 -0500
Message-ID: <20211129192003.101968.33612.stgit@awfm-01.cornelisnetworks.com>
In-Reply-To: <20211129191510.101968.6259.stgit@awfm-01.cornelisnetworks.com>
References: <20211129191510.101968.6259.stgit@awfm-01.cornelisnetworks.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31d154c0-da1a-4aa8-3883-08d9b36d3f15
X-MS-TrafficTypeDiagnostic: BYAPR01MB5558:
X-Microsoft-Antispam-PRVS: <BYAPR01MB55587FCD2D4DFF44FD34E756F4669@BYAPR01MB5558.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpaqRpHOEEvtNLO/x3njTsRHE1sTpLUTL4xaHTSx84aq45bk+UYF30X1eD/nslBJCps9RbUIcek+MRYpFQV6AaItdYe9e8zyjpEjD9nDOUFg5W2GpkT5oClC5EFAP7SkXeJkwaAm86y/+lvpD5GunpIYJpXK0GPXrF4CsXoPTRqalmki+b42ikDgmiPb6rukRVPXUKEL6uC7uieq3qyemm5X0wTngStN6nrdNs3W+TYX6/PdxOurVN7A+LMNmEK9QG7/jrAQuEPenDm3pn72bhqsCtI+Xjy9kzE4t7Vb7V9MtKClWHjxgVKNUNqvm4+T0rjbIAABecusbHcUmLTD0ooy86xHz2smFTtCdSsCFZs51c+ky/8A4ozcep2b/tbctzrEu+YHan4NHQYEzLlMvde6AkusMQvCbq9ySASVuHjsyHtSeMSrU4+hy5FQ5F1zS2aqU4lvBlkCvuW9A4JV4OzEPpjNCWTqTbUeiqaIJfivLeuu0VhC/WUmTRKTjAx+MxGUdc9P0fvZO640W9eTKQ27NgF74lkLtabweAg7PUTR7nH7kyNv6EKCcngC/z6zidpurq1Fst3H+4gu2xsUL0BGrzWYOSIpZMTmW34V0aTig/Dzf2Vr2lFlx9BDqTxMHz8jyLRJ25O4pQnerrWhEkNK2fmpGVKJnCohfLnfsPcNQ4rosOeSRwUp2S99YMkB23qKwgOt26kYm0lm0Kxg7ennYOiZk8mI9hdlmYyKvNA=
X-Forefront-Antispam-Report: CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:awfm-01.cornelisnetworks.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(39840400004)(346002)(376002)(136003)(46966006)(36840700001)(44832011)(186003)(336012)(8676002)(8936002)(1076003)(103116003)(81166007)(86362001)(36860700001)(70586007)(426003)(26005)(7126003)(83380400001)(82310400004)(4326008)(5660300002)(508600001)(7696005)(2906002)(356005)(316002)(47076005)(70206006)(6916009)(55016003)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 19:20:03.9988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d154c0-da1a-4aa8-3883-08d9b36d3f15
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[awfm-01.cornelisnetworks.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5558
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

The following trace can be observed with an init failure
such as firmware load failures:

[   18.421033] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[   18.430189] PGD 0 P4D 0
[   18.433435] Oops: 0010 [#1] SMP PTI
[   18.437715] CPU: 0 PID: 537 Comm: kworker/0:3 Tainted: G           OE    --------- -  - 4.18.0-240.el8.x86_64 #1
[   18.461788] Workqueue: events work_for_cpu_fn
[   18.467104] RIP: 0010:0x0
[   18.470493] Code: Bad RIP value.
[   18.474549] RSP: 0000:ffffae5f878a3c98 EFLAGS: 00010046
[   18.480819] RAX: 0000000000000000 RBX: ffff95e48e025c00 RCX: 0000000000000000
[   18.489243] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff95e48e025c00
[   18.497655] RBP: ffff95e4bf3660a4 R08: 0000000000000000 R09: ffffffff86d5e100
[   18.506069] R10: ffff95e49e1de600 R11: 0000000000000001 R12: ffff95e4bf366180
[   18.514478] R13: ffff95e48e025c00 R14: ffff95e4bf366028 R15: ffff95e4bf366000
[   18.522869] FS:  0000000000000000(0000) GS:ffff95e4df200000(0000) knlGS:0000000000000000
[   18.532369] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.539238] CR2: ffffffffffffffd6 CR3: 0000000f86a0a003 CR4: 00000000001606f0
[   18.547660] Call Trace:
[   18.550862]  receive_context_interrupt+0x1f/0x40 [hfi1]
[   18.557165]  __free_irq+0x201/0x300
[   18.561528]  free_irq+0x2e/0x60
[   18.565497]  pci_free_irq+0x18/0x30
[   18.569846]  msix_free_irq.part.2+0x46/0x80 [hfi1]
[   18.575662]  msix_clean_up_interrupts+0x2b/0x70 [hfi1]
[   18.581846]  hfi1_init_dd+0x640/0x1a90 [hfi1]
[   18.587170]  do_init_one.isra.19+0x34d/0x680 [hfi1]
[   18.593058]  local_pci_probe+0x41/0x90
[   18.597684]  work_for_cpu_fn+0x16/0x20
[   18.602332]  process_one_work+0x1a7/0x360
[   18.607256]  worker_thread+0x1cf/0x390
[   18.611872]  ? create_worker+0x1a0/0x1a0
[   18.616694]  kthread+0x112/0x130
[   18.620737]  ? kthread_flush_work_fn+0x10/0x10
[   18.626147]  ret_from_fork+0x35/0x40
[   18.655466] CR2: 0000000000000000
[   18.659703] ---[ end trace 40218ba9776cac37 ]---

The free_irq() results in a callback to the registered
interrupt handler, and rcd->do_interrupt is NULL because
the receive context data structures are not fully
initialized.

Fix by ensuring that the do_interrupt is always assigned and adding
a guards in the slow path handler to detect and handle a partially
initialized receive context and noop the receive.

Cc: stable@vger.kernel.org
Fixes: b0ba3c18d6bf ("IB/hfi1: Move normal functions from hfi1_devdata to const array")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/chip.c   |    2 ++
 drivers/infiniband/hw/hfi1/driver.c |    2 ++
 drivers/infiniband/hw/hfi1/init.c   |    5 ++---
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index ec37f4f..f1245c9 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8415,6 +8415,8 @@ static void receive_interrupt_common(struct hfi1_ctxtdata *rcd)
  */
 static void __hfi1_rcd_eoi_intr(struct hfi1_ctxtdata *rcd)
 {
+	if (!rcd->rcvhdrq)
+		return;
 	clear_recv_intr(rcd);
 	if (check_packet_present(rcd))
 		force_recv_intr(rcd);
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 61f341c..e2c634a 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1012,6 +1012,8 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 	struct hfi1_packet packet;
 	int skip_pkt = 0;
 
+	if (!rcd->rcvhdrq)
+		return RCV_PKT_OK;
 	/* Control context will always use the slow path interrupt handler */
 	needset = (rcd->ctxt == HFI1_CTRL_CTXT) ? 0 : 1;
 
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 8e1236b..6422dd6 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -113,7 +113,6 @@ static int hfi1_create_kctxt(struct hfi1_devdata *dd,
 	rcd->fast_handler = get_dma_rtail_setting(rcd) ?
 				handle_receive_interrupt_dma_rtail :
 				handle_receive_interrupt_nodma_rtail;
-	rcd->slow_handler = handle_receive_interrupt;
 
 	hfi1_set_seq_cnt(rcd, 1);
 
@@ -334,6 +333,8 @@ int hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, int numa,
 		rcd->numa_id = numa;
 		rcd->rcv_array_groups = dd->rcv_entries.ngroups;
 		rcd->rhf_rcv_function_map = normal_rhf_rcv_functions;
+		rcd->slow_handler = handle_receive_interrupt;
+		rcd->do_interrupt = rcd->slow_handler;
 		rcd->msix_intr = CCE_NUM_MSIX_VECTORS;
 
 		mutex_init(&rcd->exp_mutex);
@@ -898,8 +899,6 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 		if (!rcd)
 			continue;
 
-		rcd->do_interrupt = &handle_receive_interrupt;
-
 		lastfail = hfi1_create_rcvhdrq(dd, rcd);
 		if (!lastfail)
 			lastfail = hfi1_setup_eagerbufs(rcd);

