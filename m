Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC1421D921
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 16:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgGMOu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 10:50:59 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60503 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730335AbgGMOu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 10:50:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 86324D21;
        Mon, 13 Jul 2020 10:50:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 13 Jul 2020 10:50:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kryZVq
        nK2q75pdih1qEhyeDoY1FEgm0CcfROLUNYZdc=; b=o71ljvjKDhEQeyuT5kLOBv
        TMO9RU4ZuPb/4Z1ySYdjCdsEiEnQPm5QU5Gsd/wS4rB54opq3tlJBqjDI9duXefN
        K2fToLHJkEjaSkQPShLNkdiumrvFv1/tpqhNcl2zrF44pNef43MP/zz7wMxUHezg
        PZrQm7517y451rp96lKtdpOY/ktKjMQfJGWFKOvn5vfz2SfOYRgrYNrKMl9sogTY
        FnhJSuPKxwu7juPnwfmtFaX63GXFBQb56t6yn3ad5WqYeEqFzc81MwurTTZbeoeT
        foG8oGL7cZL+6lzlF5kqLuPqb2bp0FVKFDhnFK4RDpkTHxdQVba3/ugAN1tnhyVA
        ==
X-ME-Sender: <xms:0HQMX6nUXxzcNE1_aseUWtbBksuHbWU_HCEGYv6x9Tc4KQVGDpjH7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvdekgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0HQMXx1-nw_0KadOwR9VCgSoTcNtdPLD2Xq8BJs_393RJBFS09TurQ>
    <xmx:0HQMX4oYU1IiHVVUCgg-nEplCAACehRPE6JdhIwtRkbvJ0N24RF81A>
    <xmx:0HQMX-naiEXBRpUTVwr_1xb2VPNRRh2HdbNGgD7v2PJzt23nyepiGg>
    <xmx:0XQMX1_6nmwXpp82RmJzWeoLDLpud-ehvWSNRRFKsRjMp3uhgajJkazTXF8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 565A83280064;
        Mon, 13 Jul 2020 10:50:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Do not destroy hfi1_wq when the device is shut down" failed to apply to 4.19-stable tree
To:     kaike.wan@intel.com, dennis.dalessandro@intel.com, jgg@nvidia.com,
        mike.marciniszyn@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jul 2020 16:50:56 +0200
Message-ID: <1594651856245132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 28b70cd9236563e1a88a6094673fef3c08db0d51 Mon Sep 17 00:00:00 2001
From: Kaike Wan <kaike.wan@intel.com>
Date: Tue, 23 Jun 2020 16:40:47 -0400
Subject: [PATCH] IB/hfi1: Do not destroy hfi1_wq when the device is shut down

The workqueue hfi1_wq is destroyed in function shutdown_device(), which is
called by either shutdown_one() or remove_one(). The function
shutdown_one() is called when the kernel is rebooted while remove_one() is
called when the hfi1 driver is unloaded. When the kernel is rebooted,
hfi1_wq is destroyed while all qps are still active, leading to a kernel
crash:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000102
  IP: [<ffffffff94cb7b02>] __queue_work+0x32/0x3e0
  PGD 0
  Oops: 0000 [#1] SMP
  Modules linked in: dm_round_robin nvme_rdma(OE) nvme_fabrics(OE) nvme_core(OE) ib_isert iscsi_target_mod target_core_mod ib_ucm mlx4_ib iTCO_wdt iTCO_vendor_support mxm_wmi sb_edac intel_powerclamp coretemp intel_rapl iosf_mbi kvm rpcrdma sunrpc irqbypass crc32_pclmul ghash_clmulni_intel rdma_ucm aesni_intel ib_uverbs lrw gf128mul opa_vnic glue_helper ablk_helper ib_iser cryptd ib_umad rdma_cm iw_cm ses enclosure libiscsi scsi_transport_sas pcspkr joydev ib_ipoib(OE) scsi_transport_iscsi ib_cm sg ipmi_ssif mei_me lpc_ich i2c_i801 mei ioatdma ipmi_si dm_multipath ipmi_devintf ipmi_msghandler wmi acpi_pad acpi_power_meter hangcheck_timer ip_tables ext4 mbcache jbd2 mlx4_en sd_mod crc_t10dif crct10dif_generic mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm hfi1(OE)
  crct10dif_pclmul crct10dif_common crc32c_intel drm ahci mlx4_core libahci rdmavt(OE) igb megaraid_sas ib_core libata drm_panel_orientation_quirks ptp pps_core devlink dca i2c_algo_bit dm_mirror dm_region_hash dm_log dm_mod
  CPU: 19 PID: 0 Comm: swapper/19 Kdump: loaded Tainted: G OE ------------ 3.10.0-957.el7.x86_64 #1
  Hardware name: Phegda X2226A/S2600CW, BIOS SE5C610.86B.01.01.0024.021320181901 02/13/2018
  task: ffff8a799ba0d140 ti: ffff8a799bad8000 task.ti: ffff8a799bad8000
  RIP: 0010:[<ffffffff94cb7b02>] [<ffffffff94cb7b02>] __queue_work+0x32/0x3e0
  RSP: 0018:ffff8a90dde43d80 EFLAGS: 00010046
  RAX: 0000000000000082 RBX: 0000000000000086 RCX: 0000000000000000
  RDX: ffff8a90b924fcb8 RSI: 0000000000000000 RDI: 000000000000001b
  RBP: ffff8a90dde43db8 R08: ffff8a799ba0d6d8 R09: ffff8a90dde53900
  R10: 0000000000000002 R11: ffff8a90dde43de8 R12: ffff8a90b924fcb8
  R13: 000000000000001b R14: 0000000000000000 R15: ffff8a90d2890000
  FS: 0000000000000000(0000) GS:ffff8a90dde40000(0000) knlGS:0000000000000000
  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000102 CR3: 0000001a70410000 CR4: 00000000001607e0
  Call Trace:
  [<ffffffff94cb8105>] queue_work_on+0x45/0x50
  [<ffffffffc03f781e>] _hfi1_schedule_send+0x6e/0xc0 [hfi1]
  [<ffffffffc03f78a2>] hfi1_schedule_send+0x32/0x70 [hfi1]
  [<ffffffffc02cf2d9>] rvt_rc_timeout+0xe9/0x130 [rdmavt]
  [<ffffffff94ce563a>] ? trigger_load_balance+0x6a/0x280
  [<ffffffffc02cf1f0>] ? rvt_free_qpn+0x40/0x40 [rdmavt]
  [<ffffffff94ca7f58>] call_timer_fn+0x38/0x110
  [<ffffffffc02cf1f0>] ? rvt_free_qpn+0x40/0x40 [rdmavt]
  [<ffffffff94caa3bd>] run_timer_softirq+0x24d/0x300
  [<ffffffff94ca0f05>] __do_softirq+0xf5/0x280
  [<ffffffff9537832c>] call_softirq+0x1c/0x30
  [<ffffffff94c2e675>] do_softirq+0x65/0xa0
  [<ffffffff94ca1285>] irq_exit+0x105/0x110
  [<ffffffff953796c8>] smp_apic_timer_interrupt+0x48/0x60
  [<ffffffff95375df2>] apic_timer_interrupt+0x162/0x170
  <EOI>
  [<ffffffff951adfb7>] ? cpuidle_enter_state+0x57/0xd0
  [<ffffffff951ae10e>] cpuidle_idle_call+0xde/0x230
  [<ffffffff94c366de>] arch_cpu_idle+0xe/0xc0
  [<ffffffff94cfc3ba>] cpu_startup_entry+0x14a/0x1e0
  [<ffffffff94c57db7>] start_secondary+0x1f7/0x270
  [<ffffffff94c000d5>] start_cpu+0x5/0x14

The solution is to destroy the workqueue only when the hfi1 driver is
unloaded, not when the device is shut down. In addition, when the device
is shut down, no more work should be scheduled on the workqueues and the
workqueues are flushed.

Fixes: 8d3e71136a08 ("IB/{hfi1, qib}: Add handling of kernel restart")
Link: https://lore.kernel.org/r/20200623204047.107638.77646.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 5eed4360695f..16d6788075f3 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -830,6 +830,25 @@ static int create_workqueues(struct hfi1_devdata *dd)
 	return -ENOMEM;
 }
 
+/**
+ * destroy_workqueues - destroy per port workqueues
+ * @dd: the hfi1_ib device
+ */
+static void destroy_workqueues(struct hfi1_devdata *dd)
+{
+	int pidx;
+	struct hfi1_pportdata *ppd;
+
+	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
+		ppd = dd->pport + pidx;
+
+		if (ppd->hfi1_wq) {
+			destroy_workqueue(ppd->hfi1_wq);
+			ppd->hfi1_wq = NULL;
+		}
+	}
+}
+
 /**
  * enable_general_intr() - Enable the IRQs that will be handled by the
  * general interrupt handler.
@@ -1104,11 +1123,10 @@ static void shutdown_device(struct hfi1_devdata *dd)
 		 */
 		hfi1_quiet_serdes(ppd);
 
-		if (ppd->hfi1_wq) {
-			destroy_workqueue(ppd->hfi1_wq);
-			ppd->hfi1_wq = NULL;
-		}
+		if (ppd->hfi1_wq)
+			flush_workqueue(ppd->hfi1_wq);
 		if (ppd->link_wq) {
+			flush_workqueue(ppd->link_wq);
 			destroy_workqueue(ppd->link_wq);
 			ppd->link_wq = NULL;
 		}
@@ -1756,6 +1774,7 @@ static void remove_one(struct pci_dev *pdev)
 	 * clear dma engines, etc.
 	 */
 	shutdown_device(dd);
+	destroy_workqueues(dd);
 
 	stop_timers(dd);
 
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 2f3d9ce077d3..be62284e42d9 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -367,7 +367,10 @@ bool _hfi1_schedule_send(struct rvt_qp *qp)
 	struct hfi1_ibport *ibp =
 		to_iport(qp->ibqp.device, qp->port_num);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+	struct hfi1_devdata *dd = ppd->dd;
+
+	if (dd->flags & HFI1_SHUTDOWN)
+		return true;
 
 	return iowait_schedule(&priv->s_iowait, ppd->hfi1_wq,
 			       priv->s_sde ?
diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index 243b4ba0b6f6..facff133139a 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -5406,7 +5406,10 @@ static bool _hfi1_schedule_tid_send(struct rvt_qp *qp)
 	struct hfi1_ibport *ibp =
 		to_iport(qp->ibqp.device, qp->port_num);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+	struct hfi1_devdata *dd = ppd->dd;
+
+	if ((dd->flags & HFI1_SHUTDOWN))
+		return true;
 
 	return iowait_tid_schedule(&priv->s_iowait, ppd->hfi1_wq,
 				   priv->s_sde ?

