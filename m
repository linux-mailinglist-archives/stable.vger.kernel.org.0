Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93882E368C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgL1LfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:35:09 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56615 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727329AbgL1LfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:35:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 09874839;
        Mon, 28 Dec 2020 06:33:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ChBBNN
        HcaLkHW1gBoDBh3N8g5lDqRmcOxKWOw7XbAXw=; b=detV43L/ArmOM6quyMoBFl
        afELbG6dgX1OH5A/pYHfuYMFjYyfdqKDOGXDC5iJ/s4YfDSXmc+dXwNT4OsKE0To
        9X+3aksQYLP5SyjpyiOIJ7RWI9QsxuRcEJtyUsxN6ysv8DngJEC/z1ypZMoV/YMG
        lDBSC+dsg1ggtu5i9YCl40EzbX0eUt1o8As/fKl+lvEP+5rDbWwnSOptb1XjP/ZA
        tdnO/riC2DRwxqvaRG2Vm/zVdm3OMxRXr+hQIgGejV+HiP5L57ETYOM9eBBiWc4C
        BiDKjLOBr7YUt6MXqbm5VtnGFTRZr8YntQlvaY5xmR52NVOfJ3sz6JOIMwgxvvug
        ==
X-ME-Sender: <xms:gMLpX0-zdl7okMlVGICmOC1bkqXGhtgbUdjqdzfGVkLWU_MKQdRlGQ>
    <xme:gMLpX8tubfTPXPA7sR5tvRwizJJF2JPG1RBxAZ57C3GAvI0tuYiGk-JBOpTv-1K0J
    yZ9FWEJKSft1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:gMLpX6Dmpogs1YIMEG7fbVwWNAaCwm4JjzT-P5f7BIhK4soLChYUvQ>
    <xmx:gMLpX0dep8IgMzspcKIlL22SZC7nlE-ASp22GEqtafUUW2ud4t0gug>
    <xmx:gMLpX5OyrvfhG3n2lUbbC26x_oeh269ll7EHenc6Y1e2y_lM_IM95A>
    <xmx:gMLpXyZfeEcvSlbC823AM7snxex1J-jFCBkdcbx8mGPchoTW8--NtsEoehw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 558AC1080059;
        Mon, 28 Dec 2020 06:33:20 -0500 (EST)
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
 

