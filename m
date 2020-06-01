Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED51EA37E
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 14:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgFAMHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 08:07:47 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:46779 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgFAMHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 08:07:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C09DD19408FF;
        Mon,  1 Jun 2020 08:07:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Jun 2020 08:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kosCmB
        Zqcg9vEyVcfPxOmCL+VzmcRxkvFax085lCri0=; b=ixBJMsiTkA73By4SinTKhc
        R1iLG7eVDvX4zfKoi0mtT1g7z5Gym7iS685tEnCYjT1w9xXgvvHg4fGzqnYThwCe
        xf8/o6orCb8W/zMjLf2e5iHzVXPPYG/NWiTzGpnfglAm4hYn47RpzXDEu3CSXIvn
        crIxvU21u7wwyAwM20DjUqIEwLVVD0ypbbrmcwvhW82PA0Az87azDepkDFGiZ8mN
        qwcipCBMlTYPTlqUIRVDUbrvKEM8fF6glwWrjF7oFFoK35fyx8gMnoF7i5qTJ1xD
        j7twTlAq2g/d0yiASgaUYLE2BDNe9NxM0HienfwbtFJSgHnP6vPoSxPWNlbuoh4A
        ==
X-ME-Sender: <xms:ke_UXtxHIn_jBqi7lgZkRc6MTG8RQ8XXZHCJiDqPaRWBKEwxR2W4yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefhedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ke_UXtRc7jx236Y-WckKioxrZ84RDVgHkG1uPt8qSi5-lLFzn0stlw>
    <xmx:ke_UXnVWtHvmeVnYnz6_Lqyzlk57u17FmVg7Kw0_6iX-48mFyFZxQA>
    <xmx:ke_UXvhZNSC-j-cBYtLrU-wemSvduwk5rApB7ew_v7Pb7JUZcLnoEA>
    <xmx:ke_UXk6s8G3yCb7mRs6hhzDfyam4eQWGx9EJftCL237FWGJTwfZ2hg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC4B630618C1;
        Mon,  1 Jun 2020 08:07:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] nvme-pci: avoid race between nvme_reap_pending_cqes() and" failed to apply to 5.6-stable tree
To:     dongli.zhang@oracle.com, hch@lst.de, kbusch@kernel.org,
        ming.lei@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jun 2020 14:07:43 +0200
Message-ID: <1591013263117114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
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

