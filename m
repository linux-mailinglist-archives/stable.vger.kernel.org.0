Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055CF811B4
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfHEFid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:38:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42671 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFid (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:38:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D25620D56;
        Mon,  5 Aug 2019 01:38:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:38:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9b7hp3
        +0nXQc6s19L7eXAAbj3j6lSzKgQonhRs0SeAQ=; b=G/jcL3GvgNOcJqaTiG+VMU
        WgujlNrNiTJHxUggRa8nJIzJ9IZj3/H0cgrkwrLjJIFIkva/jDhOFX+phdYgyeOr
        g1oASfdLTtCaMkKTF5ySEgUN2/cmHYf+EnalBajPcPz8SqG3yWKklm/lJSxoMWR8
        Oh3mUgOmnt4VeZa3qt5r4TUVNRnt/svJ1nnnaENRvt3Kq2unr2lHjlW6nzNeGkq9
        eFzXBrKX+/dQyDkH2Txzojozm58T0WcjO/cI/9IqzeD8ms5FMdhtblUlN3Ry3D5/
        yY+TybrZVc/1gvdTlexMkCKdKjXOqAWC99aqp074lHsgTqC1m9ZEPqLmpdvnIyeA
        ==
X-ME-Sender: <xms:18BHXffeuA7-Jd6tsNK0PyPi6ebSYcfgBhgG9luVwiCeNKUl0r34Zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeel
X-ME-Proxy: <xmx:18BHXbNQv_N2k-Y2bSACGGEhXoprRe2DkHwV9G9AmzMGxpdBFIL9UQ>
    <xmx:18BHXTWXut0bm9PBJStj7bMyU7nDye2bvjGHPMi-xvC1PkKTUAOIEw>
    <xmx:18BHXTwQmimfFhuszW8LzI0ao3tFuvtzCkmd4uV33Cxv49biqPqL9Q>
    <xmx:2MBHXeKOGVMWPEGnHzCTTHoeoMvv71F38ofVzF0WwirKFXXewBQIiA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E0AD8005B;
        Mon,  5 Aug 2019 01:38:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Unreserve a flushed OPFN request" failed to apply to 4.19-stable tree
To:     kaike.wan@intel.com, dennis.dalessandro@intel.com,
        jgg@mellanox.com, mike.marciniszyn@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:38:21 +0200
Message-ID: <15649835016938@kroah.com>
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

From 2b74c878b0eae4c32629c2d5ba69a29f69048313 Mon Sep 17 00:00:00 2001
From: Kaike Wan <kaike.wan@intel.com>
Date: Mon, 15 Jul 2019 12:45:28 -0400
Subject: [PATCH] IB/hfi1: Unreserve a flushed OPFN request

When an OPFN request is flushed, the request is completed without
unreserving itself from the send queue. Subsequently, when a new
request is post sent, the following warning will be triggered:

WARNING: CPU: 4 PID: 8130 at rdmavt/qp.c:1761 rvt_post_send+0x72a/0x880 [rdmavt]
Call Trace:
[<ffffffffbbb61e41>] dump_stack+0x19/0x1b
[<ffffffffbb497688>] __warn+0xd8/0x100
[<ffffffffbb4977cd>] warn_slowpath_null+0x1d/0x20
[<ffffffffc01c941a>] rvt_post_send+0x72a/0x880 [rdmavt]
[<ffffffffbb4dcabe>] ? account_entity_dequeue+0xae/0xd0
[<ffffffffbb61d645>] ? __kmalloc+0x55/0x230
[<ffffffffc04e1a4c>] ib_uverbs_post_send+0x37c/0x5d0 [ib_uverbs]
[<ffffffffc04e5e36>] ? rdma_lookup_put_uobject+0x26/0x60 [ib_uverbs]
[<ffffffffc04dbce6>] ib_uverbs_write+0x286/0x460 [ib_uverbs]
[<ffffffffbb6f9457>] ? security_file_permission+0x27/0xa0
[<ffffffffbb641650>] vfs_write+0xc0/0x1f0
[<ffffffffbb64246f>] SyS_write+0x7f/0xf0
[<ffffffffbbb74ddb>] system_call_fastpath+0x22/0x27

This patch fixes the problem by moving rvt_qp_wqe_unreserve() into
rvt_qp_complete_swqe() to simplify the code and make it less
error-prone.

Fixes: ca95f802ef51 ("IB/hfi1: Unreserve a reserved request when it is completed")
Link: https://lore.kernel.org/r/20190715164528.74174.31364.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 0477c14633ab..024a7c2b6124 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1835,7 +1835,6 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_opa_header *opah)
 		    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
 		trdma_clean_swqe(qp, wqe);
-		rvt_qp_wqe_unreserve(qp, wqe);
 		trace_hfi1_qp_send_completion(qp, wqe, qp->s_last);
 		rvt_qp_complete_swqe(qp,
 				     wqe,
@@ -1882,7 +1881,6 @@ struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 	if (cmp_psn(wqe->lpsn, qp->s_sending_psn) < 0 ||
 	    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
 		trdma_clean_swqe(qp, wqe);
-		rvt_qp_wqe_unreserve(qp, wqe);
 		trace_hfi1_qp_send_completion(qp, wqe, qp->s_last);
 		rvt_qp_complete_swqe(qp,
 				     wqe,
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 0eeea520a853..e06c77d76463 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -608,7 +608,7 @@ static inline void rvt_qp_wqe_reserve(
 /**
  * rvt_qp_wqe_unreserve - clean reserved operation
  * @qp - the rvt qp
- * @wqe - the send wqe
+ * @flags - send wqe flags
  *
  * This decrements the reserve use count.
  *
@@ -620,11 +620,9 @@ static inline void rvt_qp_wqe_reserve(
  * the compiler does not juggle the order of the s_last
  * ring index and the decrementing of s_reserved_used.
  */
-static inline void rvt_qp_wqe_unreserve(
-	struct rvt_qp *qp,
-	struct rvt_swqe *wqe)
+static inline void rvt_qp_wqe_unreserve(struct rvt_qp *qp, int flags)
 {
-	if (unlikely(wqe->wr.send_flags & RVT_SEND_RESERVE_USED)) {
+	if (unlikely(flags & RVT_SEND_RESERVE_USED)) {
 		atomic_dec(&qp->s_reserved_used);
 		/* insure no compiler re-order up to s_last change */
 		smp_mb__after_atomic();
@@ -853,6 +851,7 @@ rvt_qp_complete_swqe(struct rvt_qp *qp,
 	u32 byte_len, last;
 	int flags = wqe->wr.send_flags;
 
+	rvt_qp_wqe_unreserve(qp, flags);
 	rvt_put_qp_swqe(qp, wqe);
 
 	need_completion =

