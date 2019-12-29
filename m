Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBB612C341
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 17:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfL2QF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 11:05:26 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:36859 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726455AbfL2QFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 11:05:25 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AEC0E461;
        Sun, 29 Dec 2019 11:05:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 11:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uwjXw6
        fCDHO+eSTqIjET7w/MKCumUPSvMe5162jUkTE=; b=QzuyTZJUkmkVNWZRwMGNb5
        Ey5qYbLTZMek9P/jix2QcvwGZaW7OWHf+wOHuyiWHZCaCmyKtwQoQTj4wzQnQxB0
        EvGLNccWAK2ptZfBZppQ+Op1lnEH/7N9dqEtMyiXcP0fUSLFvpDNvgMneybzHUsV
        x2mHKhB7wvvLJGKrDwQ2b4ZfaIokC3prUuoPN0KmwEQgLQyb9dUWqR5Mc6lXGTsI
        7Y2USH72QFbIGaqz5LgHK8lEwlKWHSCkkuZQFNniC+U8iX7fhVCGuKqIvejAQM97
        C8JIGVAosFbDAphoWWsTYRLjbidiuDsOON/CxiFzTcsEKDY6IQ0PFBhkfR5DxYIA
        ==
X-ME-Sender: <xms:xM4IXtfPZYJ6lf2kmkcr3iz20WPo5vzbIy616JYPldlcd6YkEUqFPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:xM4IXiR12osggqj0A9AwePVZZpYcMf31fD2tlKftewV66l2X9wWBZw>
    <xmx:xM4IXuiAp1Xye_K-rWtq2aOclYCiuPNCSSzygnvP40R4Ic1gFuFMVw>
    <xmx:xM4IXopfYnxS4_j9WDokNshQjdPUWG3E9-CUAOnHJHIJjMAbwnHSZw>
    <xmx:xM4IXttSE1Lzncqp2ar7ygPgxRAh-keJkvxF8pG5pnolvT7YGLgXTg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D552F3060AC7;
        Sun, 29 Dec 2019 11:05:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug" failed to apply to 4.9-stable tree
To:     faiz_abbas@ti.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 17:05:21 +0100
Message-ID: <1577635521151247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 2c92dd20304f505b6ef43d206fff21bda8f1f0ae Mon Sep 17 00:00:00 2001
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
index 296d955ede59..42a9c8179da7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2417,8 +2417,8 @@ static int __sdhci_execute_tuning(struct sdhci_host *host, u32 opcode)
 		sdhci_send_tuning(host, opcode);
 
 		if (!host->tuning_done) {
-			pr_info("%s: Tuning timeout, falling back to fixed sampling clock\n",
-				mmc_hostname(host->mmc));
+			pr_debug("%s: Tuning timeout, falling back to fixed sampling clock\n",
+				 mmc_hostname(host->mmc));
 			sdhci_abort_tuning(host, opcode);
 			return -ETIMEDOUT;
 		}

