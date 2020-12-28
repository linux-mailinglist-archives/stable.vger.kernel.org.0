Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958442E3689
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgL1Let (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:34:49 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60905 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727296AbgL1Let (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:34:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DB3377F9;
        Mon, 28 Dec 2020 06:33:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ChBBNN
        HcaLkHW1gBoDBh3N8g5lDqRmcOxKWOw7XbAXw=; b=cker8uKrOCKe5nD+edpya3
        d3dhWQ/VGI2HUutVm9hCihyc64ZzDbL1J+3e/lpOuVtI9/5wPkyp0NLZLxnbI/xX
        9zual/NMPVMaARb78leRbj3rr6TsB9xZq9YePcAPvemcQTUvGIjslQGE8HfwOdFy
        UEqSqf2ErpNqPv3D1gA7CCCfN6f1bIbMaA27p5N7HQYFqn/gjk59scUSekE/gm5p
        E82ZPjTWY+pu9RfYHsQHQcY3eCvj2w45TbrnuxyTI0DeFHVR+QAWjRRglQoEi3vY
        ALX9giO3Qlq8mHDfsLUGeuDwOXp3f6IS6f2V5U57bYuZt2kwZQv9c4eo8GLZ1t6A
        ==
X-ME-Sender: <xms:gMLpX8btUiBcdt3N-pHBE4joY-tc3In5IoNLjFWvUpqcn-qv2kal_A>
    <xme:gMLpX3Y9bXOCGgm65x2-zEGTxaSNWUb4JeNZDwwpaBmU76gtNixRZIVonDgdXxv-8
    yhpIx17H-K9mA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:gMLpX2-H4z6yvFp1LT9v45iLcD9kjmHzPivROsZPp02oOm0KPIPrnw>
    <xmx:gMLpX2rQxZM2Fssz18u_x3t93zj-yabITAwF1S5x7eBa4jy6fP1jUQ>
    <xmx:gMLpX3q9dO5y0jCE-94ifPeK3gBXRJ_c2kAs2AN9rVRpLNfFN-GTzw>
    <xmx:gMLpX-0_KCSkWGEzETjqMNQFVkPobaXXnvtkt73Ytp5-dR_EGS8VhBasXrs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED9D9240057;
        Mon, 28 Dec 2020 06:33:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] xen-blkback: set ring->xenblkd to NULL after kthread_stop()" failed to apply to 4.4-stable tree
To:     wipawel@amazon.de, jgrall@amazon.com, jgross@suse.com,
        oliben@amazon.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:19:27 +0100
Message-ID: <160915436729164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 1c728719a4da6e654afb9cc047164755072ed7c9 Mon Sep 17 00:00:00 2001
From: Pawel Wieczorkiewicz <wipawel@amazon.de>
Date: Mon, 14 Dec 2020 10:25:57 +0100
Subject: [PATCH] xen-blkback: set ring->xenblkd to NULL after kthread_stop()

When xen_blkif_disconnect() is called, the kernel thread behind the
block interface is stopped by calling kthread_stop(ring->xenblkd).
The ring->xenblkd thread pointer being non-NULL determines if the
thread has been already stopped.
Normally, the thread's function xen_blkif_schedule() sets the
ring->xenblkd to NULL, when the thread's main loop ends.

However, when the thread has not been started yet (i.e.
wake_up_process() has not been called on it), the xen_blkif_schedule()
function would not be called yet.

In such case the kthread_stop() call returns -EINTR and the
ring->xenblkd remains dangling.
When this happens, any consecutive call to xen_blkif_disconnect (for
example in frontend_changed() callback) leads to a kernel crash in
kthread_stop() (e.g. NULL pointer dereference in exit_creds()).

This is XSA-350.

Cc: <stable@vger.kernel.org> # 4.12
Fixes: a24fa22ce22a ("xen/blkback: don't use xen_blkif_get() in xen-blkback kthread")
Reported-by: Olivier Benjamin <oliben@amazon.com>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Signed-off-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 1d8b8d24496c..9860d4842f36 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -274,6 +274,7 @@ static int xen_blkif_disconnect(struct xen_blkif *blkif)
 
 		if (ring->xenblkd) {
 			kthread_stop(ring->xenblkd);
+			ring->xenblkd = NULL;
 			wake_up(&ring->shutdown_wq);
 		}
 

