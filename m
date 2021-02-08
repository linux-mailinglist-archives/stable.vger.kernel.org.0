Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6854B312E8C
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhBHKGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:06:23 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51367 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232094AbhBHKBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:01:39 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id F0736A68;
        Mon,  8 Feb 2021 05:00:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 08 Feb 2021 05:00:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ppixbI
        5dGw1RiK++g9l11zTnfeJvxiaGBZQfSaNqL4k=; b=JqSaylNEwSoPNXSM3D5Mg1
        SncaCQlxhJw1anUNsh6mXcF6s9ackMUa7Ge2DPv4ggRn/C/Ndzg/LfyJNmn0dVlm
        uZgGR1IDonGvJ9P6IoK3Eu7kFusSqc7fKlypYJ+8lDmPs8RxjVjPUGstrG0li2r+
        rN7zkhXCfz7/xohBSnbrVR559o5FI2C6UbIk2JI4YvZHPFgbgP7gFuBtaV3CYYGy
        nOpMNtOkjBQ4zgqxjBSsYJ2YsqCgOK8qzaAY7UPlSudakaZyhSv1bRjHaW2wZCrY
        5fVpafNgqkCyeowHJ1AAC0MBjb9k/vqaYSx6AG9QwPXNAIZ2+2CFJwCSd2PPpA3g
        ==
X-ME-Sender: <xms:vgshYM47dM0WpoqAfo2TeLjEsJ12E4EiUCOdfJDRZd9Cezx-BENKhQ>
    <xme:vgshYN0LlhaPJoYwz1iDLLTS5py2fuNJXwPxzYkOCrvFumeZTatWshRSJIDZQqj9w
    r021Olnyn_VNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vgshYIWQbKMtF7-q7_EafL0eJlJZ4i7shx9ns4AUNkiJpeS0hUSpeA>
    <xmx:vgshYI7zV3GF1pV5N8A890g7cWoC85mUUSoLnzUwWUu3YfJnSLp-sQ>
    <xmx:vgshYPJQKwEMQXDshOo6-1RhcvbBQu8Y7PoE4JNUWcMnyBKWtMhMcA>
    <xmx:vgshYAnJySlqWFgEYvisLbZmGnTu6P6Y5nJgrRIlOzXk7ekDWmxvJktoTBw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC1CF24005E;
        Mon,  8 Feb 2021 05:00:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: renesas_usbhs: Clear pipe running flag in" failed to apply to 4.14-stable tree
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tho.vu.wh@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:00:19 +0100
Message-ID: <161277841922126@kroah.com>
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

