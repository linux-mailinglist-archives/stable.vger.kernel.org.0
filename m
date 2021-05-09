Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8353776D3
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 15:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhEINt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 09:49:28 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:43015 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhEINt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 09:49:28 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 41E571940CE6;
        Sun,  9 May 2021 09:48:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 09 May 2021 09:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B1T76n
        QyGGBprhVmn+vp2BD4nB3iWZX4IQYsXSIhJhg=; b=j+6Nps3Fukmyhn9K0J7Tol
        i05Yw6efYjPe/GTIOhBw4lg28+Fe9OmMLUEAzCM3eNrGPKAg8siYvPP/HeVrRgnS
        +Tg1PnJLPvkNztT04kyfu8trf0xKWThYid1rtM/DE9aE0vOepCOtgGCaFJHLkUjd
        mr/CaQEyKrapPYsy3z3sXeVedfwUsb0sR89tvAdvH14hlrMtEH2Nk9luZgxGLjR5
        hTUSCK2q529tpMKLHzCQ0IObK9YDZiHcd7nKlj51oWhDT5z2GnBZ1x3Wy6Sf8qwC
        CDziXnxoD76lTV/hRKqKkFr62mVdUJWmFTgtNIEp8tSRNThBeEdCXYSytzPj77eg
        ==
X-ME-Sender: <xms:KOiXYIeI9Qn8xFYJgC7ibycnHfpOs2DEyEpUOU6Cw-RqMa8QkaoL8Q>
    <xme:KOiXYKOHngwRd3gyNJ5AUt6pf368Z5a8VmKh8mkY7RGJQ61OI1pwuGvMNo4FhE1fM
    03cGApasgFTzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:KOiXYJiKACmNyB1hNw6NimR4lmgl862d8w__uz-Q2WsdyZWsARw4Pg>
    <xmx:KOiXYN_-wsohnBQBedhhEUJvGLmxfzmSu9P2Nh7fLdjv3XqetIQ2VQ>
    <xmx:KOiXYEuj2hnT9cOsatdT_9M8DrNPo6qbC_-UyG3dFJBCKWPd8lw8aw>
    <xmx:KeiXYK1iazdDxuKhgo1qY0USEfPpSgvNP8yb2sGP_RyqRIuXrnX2Zw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 09:48:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm: vtpm_proxy: Avoid reading host log when using a virtual" failed to apply to 4.14-stable tree
To:     stefanb@linux.ibm.com, jarkko@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 15:48:23 +0200
Message-ID: <162056810324887@kroah.com>
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

From 9716ac65efc8f780549b03bddf41e60c445d4709 Mon Sep 17 00:00:00 2001
From: Stefan Berger <stefanb@linux.ibm.com>
Date: Wed, 10 Mar 2021 17:19:16 -0500
Subject: [PATCH] tpm: vtpm_proxy: Avoid reading host log when using a virtual
 device

Avoid allocating memory and reading the host log when a virtual device
is used since this log is of no use to that driver. A virtual
device can be identified through the flag TPM_CHIP_FLAG_VIRTUAL, which
is only set for the tpm_vtpm_proxy driver.

Cc: stable@vger.kernel.org
Fixes: 6f99612e2500 ("tpm: Proxy driver for supporting multiple emulated TPMs")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

diff --git a/drivers/char/tpm/eventlog/common.c b/drivers/char/tpm/eventlog/common.c
index 7460f230bae4..8512ec76d526 100644
--- a/drivers/char/tpm/eventlog/common.c
+++ b/drivers/char/tpm/eventlog/common.c
@@ -107,6 +107,9 @@ void tpm_bios_log_setup(struct tpm_chip *chip)
 	int log_version;
 	int rc = 0;
 
+	if (chip->flags & TPM_CHIP_FLAG_VIRTUAL)
+		return;
+
 	rc = tpm_read_log(chip);
 	if (rc < 0)
 		return;

