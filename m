Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A180C991E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 09:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfJCHqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 03:46:40 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38305 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725907AbfJCHqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 03:46:40 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A311B21E3E;
        Thu,  3 Oct 2019 03:46:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 03:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+FcONN
        nbqLtcaURp6zXcS4kClYTg8wpqMmAHL75YPfY=; b=pYLWxO5Ayrs3TAu9n+AUV6
        QUaosCgdiAmYoFCu0OiS6HN7h+pgSlYfrdoECfVOmXwcOwoTIe9JPilz5jAAeFZA
        F7/oL1D98GxrR5xi5BWgOeGTa5BS9MQ8MOITHindg1Vsy7WYn27atJM4vTbmFXji
        2z9lqckQeWOhHoI0Ie8L3To9XfhT5p3tmatPqKkWG8WjdwDU7v2aHSfGpyQYxIWy
        rdPxFYAShBaIJizHJsX0Cp5ViIOuAAxOXe1r6hPzKTogT4yu+G1tJAaKOXdpfQXH
        ywn1P/E2z/wQzX+6TN6aS0js6NL9tttmIgHiT0wwGJekRzze/dCsE7bSue9C5sSA
        ==
X-ME-Sender: <xms:X6eVXdlVPo4pOGAWheYmHFbT8KQXBmoQXf4kJU8TGMjcPm2OSHH1Og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeejgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:X6eVXWOUMUlBMA9LhdMRey263q-4f9hVgmrJA5pCAHzWAqdBvSBAUw>
    <xmx:X6eVXShs898k7gRy5X9JqpvTgWV7U3qIP7yD4V5pGFibwUSjnMKchw>
    <xmx:X6eVXWwORgpRGUfK3zwzTEui25PO9LjC2Kl27jZz7Z5ZwJbn_foJLQ>
    <xmx:X6eVXWAb2rz4sCMnczKvOLl7e3Knz4GJB8O_mgHd_ShQhky63KSWLw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19A8B80061;
        Thu,  3 Oct 2019 03:46:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for" failed to apply to 4.14-stable tree
To:     stefanb@linux.ibm.com, jarkko.sakkinen@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 09:46:29 +0200
Message-ID: <1570088789102227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 1ea32c83c699df32689d329b2415796b7bfc2f6e Mon Sep 17 00:00:00 2001
From: Stefan Berger <stefanb@linux.ibm.com>
Date: Thu, 29 Aug 2019 20:09:06 -0400
Subject: [PATCH] tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for
 interrupts

The tpm_tis_core has to set the TPM_CHIP_FLAG_IRQ before probing for
interrupts since there is no other place in the code that would set
it.

Cc: linux-stable@vger.kernel.org
Fixes: 570a36097f30 ("tpm: drop 'irq' from struct tpm_vendor_specific")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index ffa9048d8f6c..270f43acbb77 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -981,6 +981,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		}
 
 		tpm_chip_start(chip);
+		chip->flags |= TPM_CHIP_FLAG_IRQ;
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);

