Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F54C991D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 09:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfJCHqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 03:46:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52615 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725907AbfJCHqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 03:46:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 07ED721C46;
        Thu,  3 Oct 2019 03:46:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 03:46:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=C9N2jx
        XoC4uRnn9D9oXGVP9oHmBOsdLzfh2h9pvaafU=; b=r/5b6TrR87edD97+TpyS7M
        9Lrcalq8+7NJ0GfuhddZ6Bss33tYuCaBVOO9QfuWBYtDXsveIFcRS5IvXNxOtzFr
        imucJ3hBd6ZrQBEJVui0dTyOTjEEm2aG2fwxBS+ME7QGKCwU7hnTPmBpMEKzDj+j
        7Q7nkxfzXSov4f1t2qn2Bm0SLVg/MAtrduKPflAVGdqXMrUioeR0TciABs36JGCj
        M2bj4OCuvpeOoZw5RWRonWgg4NE1yZBUZjPlNRUF5R+bNdAcINWWRtr9lduK9Gar
        49E1o5O/NZc3ldxcUBKCahZ/ahk++g+sF7TG4REy7zMKqUgxNEJQgcjjdTSqIMrA
        ==
X-ME-Sender: <xms:V6eVXVeZzmKzDH7ftJPLunHDDHApm2tAQCoUdUfes5E7fQdtUhPXlw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeejgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:V6eVXYd97oz6O0kZDlocnUxdUO5HD0vJ6rtNq4SZepUROdET0PmwKQ>
    <xmx:V6eVXQNcWul40ZaZYOkzp16V6v02hL88tP95owlBYMa1xS3lbBIhSg>
    <xmx:V6eVXXLVMCs-gkRvGTxX1MswrgzTk1CVyMYceq40zUVTpTOk3JZ34w>
    <xmx:WKeVXWYBtaU7jIjqji1-1zuagtJixi2LUzx_LNb4rgrDNEBTnFeDYw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 56E8BD6005D;
        Thu,  3 Oct 2019 03:46:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for" failed to apply to 4.19-stable tree
To:     stefanb@linux.ibm.com, jarkko.sakkinen@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 09:46:29 +0200
Message-ID: <157008878914315@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

