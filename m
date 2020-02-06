Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F86154C28
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgBFTYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:51 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47181 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:50 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B80A521B6A;
        Thu,  6 Feb 2020 14:24:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8wkHg3
        MjVfio/BgYqxxk5u0UsCmQs6yGwUhRT79mJlY=; b=OSBRAJGtzHmMXFpMVLioUl
        utCA6ncDafQIxYO5NkiHWnh7EQWHIxei7ubitLpeQuSbGOShknck/jTMVWhXVlCm
        NNBkOLlXAAsI5CkhxZHWfH9Bx2PqJbuaWN5Ilzos0kYtKRulTF6eMhzRyDGKE+xK
        z55JAPfE+h3nsRgxZCX7403SXKhbBfyOlrAyWmX1Mu6Gw2w5aSHt+OMz8dz11PyJ
        TtyFKV5osH4jFt4YXLzLGfiImaqhCiWCE4/1XwmX6XGuzBgHtfWCJsRFIB/iz57Q
        wYcNAhWfMCe1Q4/DDjLCcvsWEChZqtuB7IT9/9OIoAu2uV7fn2IHwlEreB9Tk6OA
        ==
X-ME-Sender: <xms:AWg8XvwoRp32GmtGS1Ygn6jdhCJod82tjGt-bOz18GsuhLa6iS1CqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AWg8Xt1fF6ii9wgzf3uR5-aYcmruxYJn1ojdqM32t32hZkPKlHqLkA>
    <xmx:AWg8Xmzo7D4cDdQUHhU0A52Ypl9F7fcewj4qk0LsTCb2T5FdU5R-wQ>
    <xmx:AWg8XpvhY8KVEdAEb1fKeLz0tGB50miimMrksiaBAAkWGzBEPW0GPw>
    <xmx:AWg8Xvz6YkCILYIcCB9tHpX-nnKw436w-occUAR09QoAFODfjfIsXA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BFDA30600DC;
        Thu,  6 Feb 2020 14:24:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug" failed to apply to 5.4-stable tree
To:     faiz_abbas@ti.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:08:25 +0100
Message-ID: <15810161055915@kroah.com>
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

From 811ba67632aae618985209cb9455f1d342426e6d Mon Sep 17 00:00:00 2001
From: Faiz Abbas <faiz_abbas@ti.com>
Date: Fri, 6 Dec 2019 17:13:26 +0530
Subject: [PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug
 level

Tuning support in DDR50 speed mode was added in SD Specifications Part1
Physical Layer Specification v3.01. Its not possible to distinguish
between v3.00 and v3.01 from the SCR and that is why since
commit 4324f6de6d2e ("mmc: core: enable CMD19 tuning for DDR50 mode")
tuning failures are ignored in DDR50 speed mode.

Cards compatible with v3.00 don't respond to CMD19 in DDR50 and this
error gets printed during enumeration and also if retune is triggered at
any time during operation. Update the printk level to pr_debug so that
these errors don't lead to false error reports.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Cc: stable@vger.kernel.org # v4.4+
Link: https://lore.kernel.org/r/20191206114326.15856-1-faiz_abbas@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 012b1d9145b9..d8f1d87c58c6 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2408,8 +2408,8 @@ static int __sdhci_execute_tuning(struct sdhci_host *host, u32 opcode)
 		sdhci_send_tuning(host, opcode);
 
 		if (!host->tuning_done) {
-			pr_info("%s: Tuning timeout, falling back to fixed sampling clock\n",
-				mmc_hostname(host->mmc));
+			pr_debug("%s: Tuning timeout, falling back to fixed sampling clock\n",
+				 mmc_hostname(host->mmc));
 			sdhci_abort_tuning(host, opcode);
 			return -ETIMEDOUT;
 		}

