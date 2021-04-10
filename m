Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AB135ADF2
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 16:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhDJODr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 10:03:47 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:37165 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234536AbhDJODp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 10:03:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id BDAF619411F0;
        Sat, 10 Apr 2021 10:03:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QPKJin
        uPN3hLdi1Y2rXy8dRKuItZAEKPi+kFovlj5Ug=; b=jH3JD64qBon9Tm2CFEOnFe
        o5FYmwKRiD+PMnwRUJM3rij2LqOURi/jPMX1qLb5xRO3L68ZPowefgGl9b0Ejhx1
        2GePhtSFCPmsvQlK0XcKqm8ZsJQn6EXWWU4YJXK0SPOp7MRUcARrMv7NXeoq/5gP
        Idp8XRPavdwmzxzLfVGLDsH1Fh99ZoZT+1ysWeTurj0uGX4OpQ90nhRAt8C/WJhK
        bBjwCpVs/U4xcqxw0xqQrMwv4dqqWQ8Qir1CPOq0EisUStk7Ok9T6jpriK99Acjb
        4rZVCM6a9Ym2bm4p0ZgBD0YFStPCxV0UBqU3DmYbv9ryZrZuZ3kSdd3VuxhPsFTA
        ==
X-ME-Sender: <xms:MbBxYEqajuDo9jVNrgqP_RifDM1z0AvmDeb0aU0OnUY0LTh9WWWKrg>
    <xme:MbBxYKpJhGuWaS0lWSWnQhBq5EyTA01Vq6-thFd3zz_fpUP8ZHKhRPfysUV1w63o1
    fbZMmRDm-3WQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MbBxYJNxmu1kS0kXE20CzYnZvsgvWvYr5b4XAD9vae4gwaak6RjjRw>
    <xmx:MbBxYL7ZM1-3nd0vsV0Y2uDGbJ5P3-GhxmXcVU8UZ6pOFWwy3-ZI3Q>
    <xmx:MbBxYD4uINrMrAzZfP5FQ61fHGv_58pNbCnpM5loNF9RL8KHIvjfJw>
    <xmx:MbBxYAgO_2xz1RmOh1XOSYuLSMx5CwD9EezcMTFTxB1tMLAxJDt32w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 084241080066;
        Sat, 10 Apr 2021 10:03:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libbpf: Only create rx and tx XDP rings when necessary" failed to apply to 5.4-stable tree
To:     ciara.loftus@intel.com, ast@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 16:03:27 +0200
Message-ID: <161806340778184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca7a83e2487ad0bc9a3e0e7a8645354aa1782f13 Mon Sep 17 00:00:00 2001
From: Ciara Loftus <ciara.loftus@intel.com>
Date: Wed, 31 Mar 2021 06:12:18 +0000
Subject: [PATCH] libbpf: Only create rx and tx XDP rings when necessary

Prior to this commit xsk_socket__create(_shared) always attempted to create
the rx and tx rings for the socket. However this causes an issue when the
socket being setup is that which shares the fd with the UMEM. If a
previous call to this function failed with this socket after the rings were
set up, a subsequent call would always fail because the rings are not torn
down after the first call and when we try to set them up again we encounter
an error because they already exist. Solve this by remembering whether the
rings were set up by introducing new bools to struct xsk_umem which
represent the ring setup status and using them to determine whether or
not to set up the rings.

Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210331061218.1647-4-ciara.loftus@intel.com

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 5098d9e3b55a..d24b5cc720ec 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -59,6 +59,8 @@ struct xsk_umem {
 	int fd;
 	int refcount;
 	struct list_head ctx_list;
+	bool rx_ring_setup_done;
+	bool tx_ring_setup_done;
 };
 
 struct xsk_ctx {
@@ -857,6 +859,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	struct xsk_ctx *ctx;
 	int err, ifindex;
 	bool unmap = umem->fill_save != fill;
+	bool rx_setup_done = false, tx_setup_done = false;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
@@ -884,6 +887,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		}
 	} else {
 		xsk->fd = umem->fd;
+		rx_setup_done = umem->rx_ring_setup_done;
+		tx_setup_done = umem->tx_ring_setup_done;
 	}
 
 	ctx = xsk_get_ctx(umem, ifindex, queue_id);
@@ -902,7 +907,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	}
 	xsk->ctx = ctx;
 
-	if (rx) {
+	if (rx && !rx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
 				 &xsk->config.rx_size,
 				 sizeof(xsk->config.rx_size));
@@ -910,8 +915,10 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			err = -errno;
 			goto out_put_ctx;
 		}
+		if (xsk->fd == umem->fd)
+			umem->rx_ring_setup_done = true;
 	}
-	if (tx) {
+	if (tx && !tx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
 				 &xsk->config.tx_size,
 				 sizeof(xsk->config.tx_size));
@@ -919,6 +926,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			err = -errno;
 			goto out_put_ctx;
 		}
+		if (xsk->fd == umem->fd)
+			umem->rx_ring_setup_done = true;
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);

