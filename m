Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1DCC3E25
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfJARGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 13:06:17 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57087 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbfJARGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 13:06:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 593E221B7C;
        Tue,  1 Oct 2019 13:06:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 13:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=utDfQM
        JnN32XEeS3REYcSd5ZYc0OW4ByJ78AcrRUbZY=; b=LHV8CbGiC4Fr9FScQg6TnE
        whb3YTDrPCUY9zaM1BMfwf2NZH8wlK7QeIpyWaNpHrOJE+DrPoYDlUiqt468ekNo
        pw3bej/C2nN9UV6JcIBMiZH1o4G2xLEv8Qu71dquvPiFr2PJf6wUE9oGV7jzX4bZ
        edmVlFjq7G9il5LXp8HIMVpI1T0HRn6/z+NmThOtn7Uu0b5cPUvxluckK/IstF/j
        sld75jN+wSBYuqF9CvH/nKJ6pj3w0ruLvC7G23GXvF7tU9D22s4Q1ppz7VTGPOu+
        /Lcj25Z8ZQZicygDSn+DSRoV0AJ1sTCwy1B4dsgwaJxFIw9t0K7r6netkd7bp+NQ
        ==
X-ME-Sender: <xms:hoeTXQYXaQcnjiy7QV6KCwDl38YljvCtnZ12qWAMAEeCKOUBlbuJ2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:h4eTXcdSWfEsD0FlgtMQaoMNpkKMF6Ti6Nq4FaaO9jCHgI2KGf1QvQ>
    <xmx:h4eTXScmn1a6ZAN0NNxUrHMvcWruI2YbeP9IHyvPXn7xpdOhkBvZSw>
    <xmx:h4eTXY4m7PKoZqadEYA7TabqDPb_fc1AozhYdN2ZyIW85Mwqwk2dbw>
    <xmx:h4eTXYLXX_1pgGBY2AUQ5U5lpsUCq5wUUPfdBj_slBSU_C6uGAff-g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9FC0780065;
        Tue,  1 Oct 2019 13:06:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Define variables as unsigned long to fix KASAN" failed to apply to 4.4-stable tree
To:     ira.weiny@intel.com, dennis.dalessandro@intel.com,
        jgg@mellanox.com, kaike.wan@intel.com, mike.marciniszyn@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 01 Oct 2019 19:06:13 +0200
Message-ID: <156994957335192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f8659d68e2bee5b86a1beaf7be42d942e1fc81f4 Mon Sep 17 00:00:00 2001
From: Ira Weiny <ira.weiny@intel.com>
Date: Wed, 11 Sep 2019 07:30:53 -0400
Subject: [PATCH] IB/hfi1: Define variables as unsigned long to fix KASAN
 warning

Define the working variables to be unsigned long to be compatible with
for_each_set_bit and change types as needed.

While we are at it remove unused variables from a couple of functions.

This was found because of the following KASAN warning:
 ==================================================================
   BUG: KASAN: stack-out-of-bounds in find_first_bit+0x19/0x70
   Read of size 8 at addr ffff888362d778d0 by task kworker/u308:2/1889

   CPU: 21 PID: 1889 Comm: kworker/u308:2 Tainted: G W         5.3.0-rc2-mm1+ #2
   Hardware name: Intel Corporation W2600CR/W2600CR, BIOS SE5C600.86B.02.04.0003.102320141138 10/23/2014
   Workqueue: ib-comp-unb-wq ib_cq_poll_work [ib_core]
   Call Trace:
    dump_stack+0x9a/0xf0
    ? find_first_bit+0x19/0x70
    print_address_description+0x6c/0x332
    ? find_first_bit+0x19/0x70
    ? find_first_bit+0x19/0x70
    __kasan_report.cold.6+0x1a/0x3b
    ? find_first_bit+0x19/0x70
    kasan_report+0xe/0x12
    find_first_bit+0x19/0x70
    pma_get_opa_portstatus+0x5cc/0xa80 [hfi1]
    ? ret_from_fork+0x3a/0x50
    ? pma_get_opa_port_ectrs+0x200/0x200 [hfi1]
    ? stack_trace_consume_entry+0x80/0x80
    hfi1_process_mad+0x39b/0x26c0 [hfi1]
    ? __lock_acquire+0x65e/0x21b0
    ? clear_linkup_counters+0xb0/0xb0 [hfi1]
    ? check_chain_key+0x1d7/0x2e0
    ? lock_downgrade+0x3a0/0x3a0
    ? match_held_lock+0x2e/0x250
    ib_mad_recv_done+0x698/0x15e0 [ib_core]
    ? clear_linkup_counters+0xb0/0xb0 [hfi1]
    ? ib_mad_send_done+0xc80/0xc80 [ib_core]
    ? mark_held_locks+0x79/0xa0
    ? _raw_spin_unlock_irqrestore+0x44/0x60
    ? rvt_poll_cq+0x1e1/0x340 [rdmavt]
    __ib_process_cq+0x97/0x100 [ib_core]
    ib_cq_poll_work+0x31/0xb0 [ib_core]
    process_one_work+0x4ee/0xa00
    ? pwq_dec_nr_in_flight+0x110/0x110
    ? do_raw_spin_lock+0x113/0x1d0
    worker_thread+0x57/0x5a0
    ? process_one_work+0xa00/0xa00
    kthread+0x1bb/0x1e0
    ? kthread_create_on_node+0xc0/0xc0
    ret_from_fork+0x3a/0x50

   The buggy address belongs to the page:
   page:ffffea000d8b5dc0 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
   flags: 0x17ffffc0000000()
   raw: 0017ffffc0000000 0000000000000000 ffffea000d8b5dc8 0000000000000000
   raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
   page dumped because: kasan: bad access detected

   addr ffff888362d778d0 is located in stack of task kworker/u308:2/1889 at offset 32 in frame:
    pma_get_opa_portstatus+0x0/0xa80 [hfi1]

   this frame has 1 object:
    [32, 36) 'vl_select_mask'

   Memory state around the buggy address:
    ffff888362d77780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    ffff888362d77800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   >ffff888362d77880: 00 00 00 00 00 00 f1 f1 f1 f1 04 f2 f2 f2 00 00
                                                    ^
    ffff888362d77900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    ffff888362d77980: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 04 f2 f2 f2

 ==================================================================

Cc: <stable@vger.kernel.org>
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20190911113053.126040.47327.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 184dba3c2828..d8ff063a5419 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2326,7 +2326,7 @@ struct opa_port_status_req {
 	__be32 vl_select_mask;
 };
 
-#define VL_MASK_ALL		0x000080ff
+#define VL_MASK_ALL		0x00000000000080ffUL
 
 struct opa_port_status_rsp {
 	__u8 port_num;
@@ -2625,15 +2625,14 @@ static int pma_get_opa_classportinfo(struct opa_pma_mad *pmp,
 }
 
 static void a0_portstatus(struct hfi1_pportdata *ppd,
-			  struct opa_port_status_rsp *rsp, u32 vl_select_mask)
+			  struct opa_port_status_rsp *rsp)
 {
 	if (!is_bx(ppd->dd)) {
 		unsigned long vl;
 		u64 sum_vl_xmit_wait = 0;
-		u32 vl_all_mask = VL_MASK_ALL;
+		unsigned long vl_all_mask = VL_MASK_ALL;
 
-		for_each_set_bit(vl, (unsigned long *)&(vl_all_mask),
-				 8 * sizeof(vl_all_mask)) {
+		for_each_set_bit(vl, &vl_all_mask, BITS_PER_LONG) {
 			u64 tmp = sum_vl_xmit_wait +
 				  read_port_cntr(ppd, C_TX_WAIT_VL,
 						 idx_from_vl(vl));
@@ -2730,12 +2729,12 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 		(struct opa_port_status_req *)pmp->data;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	struct opa_port_status_rsp *rsp;
-	u32 vl_select_mask = be32_to_cpu(req->vl_select_mask);
+	unsigned long vl_select_mask = be32_to_cpu(req->vl_select_mask);
 	unsigned long vl;
 	size_t response_data_size;
 	u32 nports = be32_to_cpu(pmp->mad_hdr.attr_mod) >> 24;
 	u8 port_num = req->port_num;
-	u8 num_vls = hweight32(vl_select_mask);
+	u8 num_vls = hweight64(vl_select_mask);
 	struct _vls_pctrs *vlinfo;
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
@@ -2770,7 +2769,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 
 	hfi1_read_link_quality(dd, &rsp->link_quality_indicator);
 
-	rsp->vl_select_mask = cpu_to_be32(vl_select_mask);
+	rsp->vl_select_mask = cpu_to_be32((u32)vl_select_mask);
 	rsp->port_xmit_data = cpu_to_be64(read_dev_cntr(dd, C_DC_XMIT_FLITS,
 					  CNTR_INVALID_VL));
 	rsp->port_rcv_data = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FLITS,
@@ -2841,8 +2840,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 	 * So in the for_each_set_bit() loop below, we don't need
 	 * any additional checks for vl.
 	 */
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 
 		tmp = read_dev_cntr(dd, C_DC_RX_FLIT_VL, idx_from_vl(vl));
@@ -2883,7 +2881,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 		vfi++;
 	}
 
-	a0_portstatus(ppd, rsp, vl_select_mask);
+	a0_portstatus(ppd, rsp);
 
 	if (resp_len)
 		*resp_len += response_data_size;
@@ -2930,16 +2928,14 @@ static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port,
 	return error_counter_summary;
 }
 
-static void a0_datacounters(struct hfi1_pportdata *ppd, struct _port_dctrs *rsp,
-			    u32 vl_select_mask)
+static void a0_datacounters(struct hfi1_pportdata *ppd, struct _port_dctrs *rsp)
 {
 	if (!is_bx(ppd->dd)) {
 		unsigned long vl;
 		u64 sum_vl_xmit_wait = 0;
-		u32 vl_all_mask = VL_MASK_ALL;
+		unsigned long vl_all_mask = VL_MASK_ALL;
 
-		for_each_set_bit(vl, (unsigned long *)&(vl_all_mask),
-				 8 * sizeof(vl_all_mask)) {
+		for_each_set_bit(vl, &vl_all_mask, BITS_PER_LONG) {
 			u64 tmp = sum_vl_xmit_wait +
 				  read_port_cntr(ppd, C_TX_WAIT_VL,
 						 idx_from_vl(vl));
@@ -2994,7 +2990,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	u64 port_mask;
 	u8 port_num;
 	unsigned long vl;
-	u32 vl_select_mask;
+	unsigned long vl_select_mask;
 	int vfi;
 	u16 link_width;
 	u16 link_speed;
@@ -3071,8 +3067,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	 * So in the for_each_set_bit() loop below, we don't need
 	 * any additional checks for vl.
 	 */
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(req->vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 
 		rsp->vls[vfi].port_vl_xmit_data =
@@ -3120,7 +3115,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 		vfi++;
 	}
 
-	a0_datacounters(ppd, rsp, vl_select_mask);
+	a0_datacounters(ppd, rsp);
 
 	if (resp_len)
 		*resp_len += response_data_size;
@@ -3215,7 +3210,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	struct _vls_ectrs *vlinfo;
 	unsigned long vl;
 	u64 port_mask, tmp;
-	u32 vl_select_mask;
+	unsigned long vl_select_mask;
 	int vfi;
 
 	req = (struct opa_port_error_counters64_msg *)pmp->data;
@@ -3273,8 +3268,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	vlinfo = &rsp->vls[0];
 	vfi = 0;
 	vl_select_mask = be32_to_cpu(req->vl_select_mask);
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(req->vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		memset(vlinfo, 0, sizeof(*vlinfo));
 		rsp->vls[vfi].port_vl_xmit_discards =
 			cpu_to_be64(read_port_cntr(ppd, C_SW_XMIT_DSCD_VL,
@@ -3485,7 +3479,7 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 	u32 nports = be32_to_cpu(pmp->mad_hdr.attr_mod) >> 24;
 	u64 portn = be64_to_cpu(req->port_select_mask[3]);
 	u32 counter_select = be32_to_cpu(req->counter_select_mask);
-	u32 vl_select_mask = VL_MASK_ALL; /* clear all per-vl cnts */
+	unsigned long vl_select_mask = VL_MASK_ALL; /* clear all per-vl cnts */
 	unsigned long vl;
 
 	if ((nports != 1) || (portn != 1 << port)) {
@@ -3579,8 +3573,7 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 	if (counter_select & CS_UNCORRECTABLE_ERRORS)
 		write_dev_cntr(dd, C_DC_UNC_ERR, CNTR_INVALID_VL, 0);
 
-	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-			 8 * sizeof(vl_select_mask)) {
+	for_each_set_bit(vl, &vl_select_mask, BITS_PER_LONG) {
 		if (counter_select & CS_PORT_XMIT_DATA)
 			write_port_cntr(ppd, C_TX_FLIT_VL, idx_from_vl(vl), 0);
 

