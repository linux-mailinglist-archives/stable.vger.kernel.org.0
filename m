Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2111338DFF
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCLM6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:58:13 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:41427 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231434AbhCLM6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:58:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B84291940CFB;
        Fri, 12 Mar 2021 07:58:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fh3yEu
        eAoEZkzjACD8QFNslxdOTv3OFVKADKxHNnmNA=; b=inuo5Acp9MeEepN+zXRm+A
        J0GV8leJUsN0DtgCY201H7s7dnV2H8qSp+Qa9UJ3yGz9wCnGuRx5EymCnarDghM7
        wKInBSK1cBh9HV/cDdxZc9yImMm39L6wHbKCAFn8w6Kooip9bHVwnq6nSqfhDtJ6
        jwMzM9FRSMhgcbjsLVPlfPBt9ZGsM1AWjueaLlpVgFQgLjyxA+JD4+pfRglsI90F
        2IIYxNbDnaQ/JLwR4F9IoEf8uHnudqIuH4uV/NDgqb7yvdxKmQj+rKhVS1tC4C7O
        RV5Xu/x4ed8JWMd7Eci+ixIujyv7qTJlBOQ7ec5eqP40l8jfQRgNAwA2SJQP6pNA
        ==
X-ME-Sender: <xms:YWVLYIGRhPcv_N4iHwULDY4PPgZXtncFvFt8Fxtpkv_6pnb3KFMmuA>
    <xme:YWVLYBX2DccFUhheSBumxQLjh-maT87jLuWF5ak-tRSc7F0-vJuR_kzcK1Wz92cqh
    atQwKM5TSll4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:YWVLYCL9xFRcrcyGkxqXT2lfjPX9rdO2w4I7CyHL14nsPOhK91hrZg>
    <xmx:YWVLYKG_hy9WhTx4jcHu9ZavWx05FPTz3Jt2C8rrXgXvDr1t8RQ6Jw>
    <xmx:YWVLYOUBp7UYjSmFOLNwNETaXEDA78zaZu7L4eGpXZkVVCt4UfhzKg>
    <xmx:YWVLYHfc0yJmF3lDI7esARKnbEBfWyNNlsLiAmC87pephtnfxQ7hrw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA5FB108005C;
        Fri, 12 Mar 2021 07:58:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: stmmac: fix watchdog timeout during suspend/resume" failed to apply to 4.14-stable tree
To:     qiangqing.zhang@nxp.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:58:07 +0100
Message-ID: <1615553887150140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c511819d138de38e1637eedb645c207e09680d0f Mon Sep 17 00:00:00 2001
From: Joakim Zhang <qiangqing.zhang@nxp.com>
Date: Thu, 25 Feb 2021 17:01:11 +0800
Subject: [PATCH] net: stmmac: fix watchdog timeout during suspend/resume
 stress test

stmmac_xmit() call stmmac_tx_timer_arm() at the end to modify tx timer to
do the transmission cleanup work. Imagine such a situation, stmmac enters
suspend immediately after tx timer modified, it's expire callback
stmmac_tx_clean() would not be invoked. This could affect BQL, since
netdev_tx_sent_queue() has been called, but netdev_tx_completed_queue()
have not been involved, as a result, dql_avail(&dev_queue->dql) finally
always return a negative value.

__dev_queue_xmit->__dev_xmit_skb->qdisc_run->__qdisc_run->qdisc_restart->dequeue_skb:
	if ((q->flags & TCQ_F_ONETXQUEUE) &&
		netif_xmit_frozen_or_stopped(txq)) // __QUEUE_STATE_STACK_XOFF is set

Net core will stop transmitting any more. Finillay, net watchdong would timeout.
To fix this issue, we should call netdev_tx_reset_queue() in stmmac_resume().

Fixes: 54139cf3bb33 ("net: stmmac: adding multiple buffers for rx")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 26b971cd4da5..12ed337a239b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5257,6 +5257,8 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
 		tx_q->cur_tx = 0;
 		tx_q->dirty_tx = 0;
 		tx_q->mss = 0;
+
+		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 }
 

