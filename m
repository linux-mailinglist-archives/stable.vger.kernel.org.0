Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AF36C0CD8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjCTJMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCTJM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:12:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41B41D90B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:12:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 555CAB80C9C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C289C4339B;
        Mon, 20 Mar 2023 09:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679303540;
        bh=VHMY6b40474zqNYAuq21e2cIrxh/HCLc/BQkgU8NAYQ=;
        h=Subject:To:Cc:From:Date:From;
        b=c7PixmVonZe0udoGk5rhGYzf8NKP6uSQVmIqSepO2Kb+6QCioj7upxZeBkm9Gk+nG
         h6Xdxx3EbYMuaeXFi9X1aidsvrPu+x6IRiMzoixe1ga6hXgqAs+BWvdNmztn2tF/Sd
         RrHzwbWl/RooBdQaDqMof+8PtN/s0Cm2zRgHNqmk=
Subject: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: fix race on RX DMA shutdown" failed to apply to 4.14-stable tree
To:     alexander.sverdlin@siemens.com, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:11:57 +0100
Message-ID: <167930351799217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 1be6f2b15f902c02e055ae0b419ca789200473c9
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930351799217@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

1be6f2b15f90 ("tty: serial: fsl_lpuart: fix race on RX DMA shutdown")
8682ab0eea89 ("tty: serial: fsl_lpuart: switch to new dmaengine_terminate_* API")
4f5cb8c5e915 ("tty: serial: fsl_lpuart: enable wakeup source for lpuart")
374e01fa1304 ("serial: fsl_lpuart: Fix comment typo")
b14109f302d0 ("tty: serial: fsl_lpuart: Use __maybe_unused instead of #if CONFIG_PM_SLEEP")
810bc0a5fafb ("tty: serial: fsl_lpuart: make coverity happy")
d0e7600b914c ("tty: serial: fsl_lpuart: move dma_request_chan()")
c2f448cff22a ("tty: serial: fsl_lpuart: add LS1028A support")
a092ab25fdaa ("tty: serial: fsl_lpuart: fix DMA mapping")
159381df1442 ("tty: serial: fsl_lpuart: fix DMA operation when using IOMMU")
487ee861de17 ("tty: serial: fsl_lpuart: use the sg count from dma_map_sg")
352bd55e5dce ("tty: serial: fsl_lpuart: Introduce lpuart*_setup_watermark_enable()")
4ff69041eccf ("tty: serial: fsl_lpuart: Introduce lpuart32_configure()")
fd60e8e4a701 ("tty: serial: fsl_lpuart: Introduce lpuart_rx_dma_startup()")
5982199ca071 ("tty: serial: fsl_lpuart: Introduce lpuart_tx_dma_startup()")
769d55c523f7 ("tty: serial: fsl_lpuart: Introduce lpuart_dma_shutdown()")
8a9b82422ff5 ("tty: serial: fsl_lpuart: Drop unnecessary lpuart*_stop_tx()")
bcfa46bfb9b7 ("tty: serial: fsl_lpuart: Drop unnecessary extra parenthesis")
d26454ee3c45 ("tty: serial: fsl_lpuart: Drop no-op bit opearation")
9bc19af9dacb ("tty: serial: fsl_lpuart: Flush HW FIFOs in .flush_buffer")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1be6f2b15f902c02e055ae0b419ca789200473c9 Mon Sep 17 00:00:00 2001
From: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Date: Thu, 9 Mar 2023 14:43:02 +0100
Subject: [PATCH] tty: serial: fsl_lpuart: fix race on RX DMA shutdown

From time to time DMA completion can come in the middle of DMA shutdown:

<process ctx>:				<IRQ>:
lpuart32_shutdown()
  lpuart_dma_shutdown()
    del_timer_sync()
					lpuart_dma_rx_complete()
					  lpuart_copy_rx_to_tty()
					    mod_timer()
    lpuart_dma_rx_free()

When the timer fires a bit later, sport->dma_rx_desc is NULL:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
pc : lpuart_copy_rx_to_tty+0xcc/0x5bc
lr : lpuart_timer_func+0x1c/0x2c
Call trace:
 lpuart_copy_rx_to_tty
 lpuart_timer_func
 call_timer_fn
 __run_timers.part.0
 run_timer_softirq
 __do_softirq
 __irq_exit_rcu
 irq_exit
 handle_domain_irq
 gic_handle_irq
 call_on_irq_stack
 do_interrupt_handler
 ...

To fix this fold del_timer_sync() into lpuart_dma_rx_free() after
dmaengine_terminate_sync() to make sure timer will not be re-started in
lpuart_copy_rx_to_tty() <= lpuart_dma_rx_complete().

Fixes: 4a8588a1cf86 ("serial: fsl_lpuart: delete timer on shutdown")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20230309134302.74940-2-alexander.sverdlin@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index f9e164abf920..56e6ba3250cd 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1354,6 +1354,7 @@ static void lpuart_dma_rx_free(struct uart_port *port)
 	struct dma_chan *chan = sport->dma_rx_chan;
 
 	dmaengine_terminate_sync(chan);
+	del_timer_sync(&sport->lpuart_timer);
 	dma_unmap_sg(chan->device->dev, &sport->rx_sgl, 1, DMA_FROM_DEVICE);
 	kfree(sport->rx_ring.buf);
 	sport->rx_ring.tail = 0;
@@ -1813,7 +1814,6 @@ static int lpuart32_startup(struct uart_port *port)
 static void lpuart_dma_shutdown(struct lpuart_port *sport)
 {
 	if (sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
 		lpuart_dma_rx_free(&sport->port);
 		sport->lpuart_dma_rx_use = false;
 	}
@@ -1973,10 +1973,8 @@ lpuart_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Since timer function acqures sport->port.lock, need to stop before
 	 * acquring same lock because otherwise del_timer_sync() can deadlock.
 	 */
-	if (old && sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
+	if (old && sport->lpuart_dma_rx_use)
 		lpuart_dma_rx_free(&sport->port);
-	}
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
@@ -2210,10 +2208,8 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Since timer function acqures sport->port.lock, need to stop before
 	 * acquring same lock because otherwise del_timer_sync() can deadlock.
 	 */
-	if (old && sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
+	if (old && sport->lpuart_dma_rx_use)
 		lpuart_dma_rx_free(&sport->port);
-	}
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
@@ -3020,7 +3016,6 @@ static int lpuart_suspend(struct device *dev)
 			 * cannot resume as expected, hence gracefully release the
 			 * Rx DMA path before suspend and start Rx DMA path on resume.
 			 */
-			del_timer_sync(&sport->lpuart_timer);
 			lpuart_dma_rx_free(&sport->port);
 
 			/* Disable Rx DMA to use UART port as wakeup source */

