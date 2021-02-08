Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72F312E88
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhBHKF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:05:58 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48575 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230491AbhBHKBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:01:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 0637AA79;
        Mon,  8 Feb 2021 05:00:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 08 Feb 2021 05:00:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cB1kui
        I7wQKeEuWbaX3t8JLlU6tQUnZ2LwQn5ndI2bw=; b=Q3djiqb0pKvG1NaRSbyAA1
        TLcuw3XuW+vSEB1d00wCoGoj/ZS+0uN+ytsQgs/aUuIQhdpY1K/pqu0uvET+zDAZ
        Lb3a3zaYdqgxTbLM+7idQm1hSn/PVoocoxSuyKM1LsE1HTy545dAdnuklJ1K+hCc
        PmpK7eXfqRtcq1AkUfZclMfzz1/QtmF5tPyD2XCKO3Ogf3OXkYAxf+MZP2JHKT9n
        Ssxu8Ew1cNgwiC5GTzvr906msy8PaCJEX2lU6EpeAjY9b1bJXvy2ZB6scBcBj1sl
        KrNbyVBoMtTc5J9TYSlH+6SnY5hBVjxWHn+VJX4GumUZpobgCr7U701WAuxXlh8A
        ==
X-ME-Sender: <xms:tQshYPUXvVTO7CMj5WxMixuJSkrabIvz5cTRSyGVKKXnjHMLoU8moA>
    <xme:tQshYHjSWuwKXFG2Pu1kWMtsQBHyUQphRRpzTeJ1l2LpskBX54ENO5eGbpDt-E1x_
    giCmzfU6B3Jnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tQshYIRiiPPlWDx0Qfw8SI62csMsl7uaqdwMNIie0NpkDw46Fz25Nw>
    <xmx:tQshYCF370TflkjQDSLTLRSNuWCFt2KtXbYY6ntoWqKOd8vw3BF09g>
    <xmx:tQshYIloaP471ox8_ZyFe2NZbULl5lAW9K3IxGQM7qUq3w2vLv-P0g>
    <xmx:tQshYPwLSdxNH2d0dHlF-AXI9xfP2sRUPcMFWbNkcWcW8cB2IXOXtuPt-Nk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 12255108005C;
        Mon,  8 Feb 2021 05:00:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: renesas_usbhs: Clear pipe running flag in" failed to apply to 4.4-stable tree
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tho.vu.wh@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:00:18 +0100
Message-ID: <161277841817918@kroah.com>
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

