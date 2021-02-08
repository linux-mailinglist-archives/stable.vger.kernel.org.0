Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1D7312E8A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhBHKGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:06:10 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50757 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232123AbhBHKB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:01:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 30BE0A5D;
        Mon,  8 Feb 2021 05:00:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:00:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tH0csB
        JjLMM4tbvNvtv4wQZ/aZfcPb1z7ReJkdgGEMY=; b=iq8vUtGMbradp9ZgeN9FZj
        ftMY8FxjI/6NE3g3Cxns1qFAmoacshofNPr0v2whomMbYPnNHQjtCWY3/jo4n7Hu
        k8ROVtbGwtppqEzL7t+eS6VSByZg2aY0mHY3x7FHO9iGlwn9x9PZmahXxnI07QNY
        TT2M0v62Ojf7YkeimOGbMdUw71TAN1dEdTmIsOzxJq3RvOLSsQulVhwUZ125YyBi
        y+Rc+3Mx7Po5mRo3tDD1fcPbAHbkPHzBE69seimEntSTKLrSlZvyEh2pkBCRRNtE
        z309qlDS5MoYPvdYQOaFw0CegnHHi4Mq0ZI63CmriupPBz4AnPwMmLroidb6CDfw
        ==
X-ME-Sender: <xms:vwshYAPE3EAIljTxzFnDStoQTyaLifpax2ZXcU1rRYc7GquIHWbr9A>
    <xme:vwshYG9D1IqSNrmhEVem4_AJu9Rul4rTMxfLeM_sMB8MVfaMZhFLoAwl8Z9VH3eAC
    6IeiT8Bmb5VQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vwshYHTIqjS1q1mmw2H-rrnFLVW4zH8BseXu90dN8qLCVaGEMOHPTw>
    <xmx:vwshYIv9ooQE_8T8iBSFhJMre9BarHama6d_hwFBPDI5chj73YwDbg>
    <xmx:vwshYIeamGuEO5UepxbGM_2BaogJ116LU65QjEMPWBswNEC0iI3tHA>
    <xmx:vwshYEEP6mllnjgTQ-bvKgGZop_YIxcfbq966nyz_llePFKXc2BxMkdo5Z8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62D0B108005B;
        Mon,  8 Feb 2021 05:00:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: renesas_usbhs: Clear pipe running flag in" failed to apply to 4.9-stable tree
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tho.vu.wh@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:00:19 +0100
Message-ID: <1612778419175243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9917f0e3cdba7b9f1a23f70e3f70b1a106be54a8 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Mon, 1 Feb 2021 21:47:20 +0900
Subject: [PATCH] usb: renesas_usbhs: Clear pipe running flag in
 usbhs_pkt_pop()

Should clear the pipe running flag in usbhs_pkt_pop(). Otherwise,
we cannot use this pipe after dequeue was called while the pipe was
running.

Fixes: 8355b2b3082d ("usb: renesas_usbhs: fix the behavior of some usbhs_pkt_handle")
Reported-by: Tho Vu <tho.vu.wh@renesas.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1612183640-8898-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index ac9a81ae8216..e6fa13701808 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -126,6 +126,7 @@ struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt)
 		}
 
 		usbhs_pipe_clear_without_sequence(pipe, 0, 0);
+		usbhs_pipe_running(pipe, 0);
 
 		__usbhsf_pkt_del(pkt);
 	}

