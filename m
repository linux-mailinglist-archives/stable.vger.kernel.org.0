Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81AE186A20
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbgCPLdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:33:25 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:38765 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730783AbgCPLdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:33:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id AC440628;
        Mon, 16 Mar 2020 07:33:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:33:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LKRZ5+
        jr7L1H4Tx3PFyMVPytfK8hpOHmw+UOxi+JozM=; b=QtbmTjd24iVsOpIwvtR+FZ
        IBbZDsLiLjwGUqONBN580xtWFQzajxMalYrfcyDLGi9IbELwBf3AVS8bstz87x4d
        S39LYGQdtCFrsAIEEo3yw1lqFabvB1DKUeDE8mJ7oaPSrOm1FzPWNYRzSnn/T3B9
        JgCw3fsoKnOnNZMkyT5g5HTOAB252HR7geHhtvthlzVMocJ76hR0khu/lQwDAH7r
        jh9zM3Hzb1GI/VuyVcgrjBOKs+qg+mQJRN4YaJbEIm1hDxHJbSMYearg7G7AjMU+
        PpZMd7U8oirzFQrYjJAyJ0lJrAJ62vwDSk6Mgj0xZ65XdH9p6O492QdRsUJD+4iA
        ==
X-ME-Sender: <xms:BGRvXuvVF0TKOioFUD9IAO0D-EzXVFxg5m40QdE0ZQo80XbQ9Om_Ag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:BGRvXlGWCqsmqSLnBjFjrY-tKu-iBBsW1fUu9gEIRyQcOEuSvOkqoQ>
    <xmx:BGRvXodwLMvek7kf1XnDLAqbWb8LPyS2JwAcxPBjtgAP5iRzf7B5TQ>
    <xmx:BGRvXhuLcPWbk6hU5RLaSqHLWpiwn3SBzSDzdgO8rX4BT-gpIXFD3g>
    <xmx:BGRvXmIp6BTWBOnTnYCkdgGEFra84bddBdNRRQxBXErcIZEgT_339Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6DA23061856;
        Mon, 16 Mar 2020 07:33:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for" failed to apply to 5.4-stable tree
To:     ulf.hansson@linaro.org, anders.roxell@linaro.org,
        faiz_abbas@ti.com, pgwipeout@gmail.com, skomatineni@nvidia.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:33:22 +0100
Message-ID: <1584358402118182@kroah.com>
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

From 43cc64e5221cc6741252b64bc4531dd1eefb733d Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 10 Mar 2020 14:43:00 +0100
Subject: [PATCH] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for
 erase/trim/discard

The busy timeout that is computed for each erase/trim/discard operation,
can become quite long and may thus exceed the host->max_busy_timeout. If
that becomes the case, mmc_do_erase() converts from using an R1B response
to an R1 response, as to prevent the host from doing HW busy detection.

However, it has turned out that some hosts requires an R1B response no
matter what, so let's respect that via checking MMC_CAP_NEED_RSP_BUSY. Note
that, if the R1B gets enforced, the host becomes fully responsible of
managing the needed busy timeout, in one way or the other.

Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Tested-by: Faiz Abbas <faiz_abbas@ti.com>
Tested-By: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index aa54d359dab7..a971c4bcc442 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1732,8 +1732,11 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	 * the erase operation does not exceed the max_busy_timeout, we should
 	 * use R1B response. Or we need to prevent the host from doing hw busy
 	 * detection, which is done by converting to a R1 response instead.
+	 * Note, some hosts requires R1B, which also means they are on their own
+	 * when it comes to deal with the busy timeout.
 	 */
-	if (card->host->max_busy_timeout &&
+	if (!(card->host->caps & MMC_CAP_NEED_RSP_BUSY) &&
+	    card->host->max_busy_timeout &&
 	    busy_timeout > card->host->max_busy_timeout) {
 		cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
 	} else {

