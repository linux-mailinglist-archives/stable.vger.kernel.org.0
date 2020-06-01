Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD931EA37F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 14:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgFAMHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 08:07:54 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:59977 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgFAMHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 08:07:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8840C1940923;
        Mon,  1 Jun 2020 08:07:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Jun 2020 08:07:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ylhBmZ
        hG60QXcn5GhdPhx6ndCP+6Hr1V9xAqV3TXo90=; b=MPftMuuqlR02zakb/aE9NJ
        QxoxWG9KQGEUn4v6qc2xmT7wa8Trnhkd/a7mRZ4ZmnqK8BDJDbuFRTR0iSkTyWSd
        QkRr7lHNHpki+8GsR1uSz4DRPlsJ5RNKufoOB1QPfauW1G7EOdpKMizWWDMc8xoO
        E6udWRTnG45E02CtLmhuEigUZy7N4mBrI4C9VyPoczqv/6PshC49A8GN0xJcFYOT
        RsV0vcuyTBjKAJJbRrdkPeJeBTYZnFsAIioicbJ/9Ib2RJp45Q0vUPEJTDKCfPue
        39GpZWZOT+7wvN/94vBB0mRm7VruzUfrOgVx4pkVjOIUOj7AVuz0AGv2LDJwFXlQ
        ==
X-ME-Sender: <xms:me_UXjSe42pCVPWMRuFf3xUiPQF_paSOUYpMTyw2HYFvuQsl4Gc1Gw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefhedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:me_UXkww8zqzThwjSGvr2b_ROeEToLf-ZbEY66b23-J2epsjdmQEDQ>
    <xmx:me_UXo0wYPwPWKsx_cb3zKiIOFVzZYjH4OXVDHC1FyYj4jgfp67iTg>
    <xmx:me_UXjDGci3FLPDqzd6qNjz0DIOoGMUiu2jRlKChiwBtQSTKD7iL8Q>
    <xmx:me_UXoZnKrXZ0XCalXtkqy3aJtGAfpM-q2usGjgb2ScbKlJbD9_lBg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21AC83061DC5;
        Mon,  1 Jun 2020 08:07:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] nvme-pci: avoid race between nvme_reap_pending_cqes() and" failed to apply to 5.4-stable tree
To:     dongli.zhang@oracle.com, hch@lst.de, kbusch@kernel.org,
        ming.lei@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jun 2020 14:07:44 +0200
Message-ID: <159101326422945@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 9210c075cef29c1f764b4252f93105103bdfb292 Mon Sep 17 00:00:00 2001
From: Dongli Zhang <dongli.zhang@oracle.com>
Date: Wed, 27 May 2020 09:13:52 -0700
Subject: [PATCH] nvme-pci: avoid race between nvme_reap_pending_cqes() and
 nvme_poll()

There may be a race between nvme_reap_pending_cqes() and nvme_poll(), e.g.,
when doing live reset while polling the nvme device.

      CPU X                        CPU Y
                               nvme_poll()
nvme_dev_disable()
-> nvme_stop_queues()
-> nvme_suspend_io_queues()
-> nvme_suspend_queue()
                               -> spin_lock(&nvmeq->cq_poll_lock);
-> nvme_reap_pending_cqes()
   -> nvme_process_cq()        -> nvme_process_cq()

In the above scenario, the nvme_process_cq() for the same queue may be
running on both CPU X and CPU Y concurrently.

It is much more easier to reproduce the issue when CONFIG_PREEMPT is
enabled in kernel. When CONFIG_PREEMPT is disabled, it would take longer
time for nvme_stop_queues()-->blk_mq_quiesce_queue() to wait for grace
period.

This patch protects nvme_process_cq() with nvmeq->cq_poll_lock in
nvme_reap_pending_cqes().

Fixes: fa46c6fb5d61 ("nvme/pci: move cqe check after device shutdown")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3726dc780d15..cc46e250fcac 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1382,16 +1382,19 @@ static void nvme_disable_admin_queue(struct nvme_dev *dev, bool shutdown)
 
 /*
  * Called only on a device that has been disabled and after all other threads
- * that can check this device's completion queues have synced. This is the
- * last chance for the driver to see a natural completion before
- * nvme_cancel_request() terminates all incomplete requests.
+ * that can check this device's completion queues have synced, except
+ * nvme_poll(). This is the last chance for the driver to see a natural
+ * completion before nvme_cancel_request() terminates all incomplete requests.
  */
 static void nvme_reap_pending_cqes(struct nvme_dev *dev)
 {
 	int i;
 
-	for (i = dev->ctrl.queue_count - 1; i > 0; i--)
+	for (i = dev->ctrl.queue_count - 1; i > 0; i--) {
+		spin_lock(&dev->queues[i].cq_poll_lock);
 		nvme_process_cq(&dev->queues[i]);
+		spin_unlock(&dev->queues[i].cq_poll_lock);
+	}
 }
 
 static int nvme_cmb_qdepth(struct nvme_dev *dev, int nr_io_queues,

