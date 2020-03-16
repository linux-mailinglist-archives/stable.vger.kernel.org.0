Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9A0186A1D
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgCPLdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:33:13 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40511 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730830AbgCPLdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:33:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B09747F7;
        Mon, 16 Mar 2020 07:33:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3dlYHp
        VzTUeYU7v0Wy9Ii69CAeIPAjGQgvA6EbQZ6lk=; b=TQoniRojzgFdsIwQ9lkcsi
        sZepSbASSaEr8cfcYCiIWy0YcX2QcBlSj3avWucSu/ewjeQIS8QLXZ/jvlh4nvE2
        5szfFn+hriGIDkC6TPaBzDlOjdw0ugb/+1cT8RB9U8DQsamRNZlAyApM4UyRR2mX
        nrbMN9Nt6SK6ncwVo6xvFepUmhIFOXtKN19ifBzBIGg1N/497OR9x9vWPPbtJPs5
        9FUBZOtuAQvigyCkbQ9PlsCHLnc1rK4hHz/UntcFTdD22tNLzNdkRVYVImlUY+nJ
        ol4kUSkUmR9cqLQ/cDbMBU2kDyvCFBRTuE0TLaPkC1YPmzA4yPHpEjBPrdLkUwfQ
        ==
X-ME-Sender: <xms:92NvXkLsKN_sywjPQESQhNRcqxu-mDnw_hrzJUHD_JfXYOtn577Qhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:92NvXtkZyX7ADcvEcNe1dRotkUkOGAzv5SpZGPVgELo72U9YYzzMAw>
    <xmx:92NvXkRFe_nIDLN1LF5xvVkOqL79bSBinbNbgUvYuKtr9QMqSksRoA>
    <xmx:92NvXnKpUlRguBsrLKE4hAtgrFMmhSGn3xffOC1Acw3psNnGZJU-jA>
    <xmx:-GNvXjyLCiHC7W6GeBj9W0WnLnZM8IA1Z_Tl42QYs6euchTxlh4SWQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F9CF328005D;
        Mon, 16 Mar 2020 07:33:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep" failed to apply to 5.5-stable tree
To:     ulf.hansson@linaro.org, skomatineni@nvidia.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:33:09 +0100
Message-ID: <1584358389270@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 18d200460cd73636d4f20674085c39e32b4e0097 Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 11 Mar 2020 10:20:36 +0100
Subject: [PATCH] mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep
 command

The busy timeout for the CMD5 to put the eMMC into sleep state, is specific
to the card. Potentially the timeout may exceed the host->max_busy_timeout.
If that becomes the case, mmc_sleep() converts from using an R1B response
to an R1 response, as to prevent the host from doing HW busy detection.

However, it has turned out that some hosts requires an R1B response no
matter what, so let's respect that via checking MMC_CAP_NEED_RSP_BUSY. Note
that, if the R1B gets enforced, the host becomes fully responsible of
managing the needed busy timeout, in one way or the other.

Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200311092036.16084-1-ulf.hansson@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index f6912ded652d..de14b5845f52 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1910,9 +1910,12 @@ static int mmc_sleep(struct mmc_host *host)
 	 * If the max_busy_timeout of the host is specified, validate it against
 	 * the sleep cmd timeout. A failure means we need to prevent the host
 	 * from doing hw busy detection, which is done by converting to a R1
-	 * response instead of a R1B.
+	 * response instead of a R1B. Note, some hosts requires R1B, which also
+	 * means they are on their own when it comes to deal with the busy
+	 * timeout.
 	 */
-	if (host->max_busy_timeout && (timeout_ms > host->max_busy_timeout)) {
+	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && host->max_busy_timeout &&
+	    (timeout_ms > host->max_busy_timeout)) {
 		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
 	} else {
 		cmd.flags = MMC_RSP_R1B | MMC_CMD_AC;

