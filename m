Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB357282A84
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 13:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgJDL6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 07:58:35 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:55097 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbgJDL6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 07:58:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A3C831940E6D;
        Sun,  4 Oct 2020 07:58:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 04 Oct 2020 07:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qMiBLj
        rcRprgqgJdo33b9+nTL6+4/Ep1ekoopcxetPA=; b=Dbk7vtggIANVVpDF660X3Z
        +P014lS2BYWHtcDfidO81O1RFAVTWBcaRj18y1hagwWXQMyT/eiFCliJrwfQKtDM
        P3u2gLj4LcL7Rh3UsyAIuTgN1CKlXdUGOdECjclf3s+xJd0EKjEUff3Yq3nqeTs/
        3fBqRQTtnKu24/CVCcxxYqbEBpn+vc20SGK1SyqpsF7Hd6IrIYHu/5xDHrhJsEY4
        dkm9hBSLujqGJyAoAGSu1tVoDt4+PkGccJVkEt+LseZvtHotvoK/fzR+/r7qHNta
        dEcDGrAyrqJYN5yrRJYQzw0a3DS0l9R4UjqFKjJbhXSVotvbKH5WDrt+BefL+6Vw
        ==
X-ME-Sender: <xms:6rh5X1gMKo2znGkzd8jLvqQQ1_uoxzjby0kKsrXEWp-9Q2CQn2-stQ>
    <xme:6rh5X6BtFNuvuLy80zH6w6YStDGKdDxsUz4Domuq8GAg6zqQTMJcZgIrZzMPrEHNd
    q8FATTK_b--ZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedtgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:6rh5X1HFEGkTUh704CsD1Cts05BiqzebMslWSb_ZwWd2UM98ZLChCg>
    <xmx:6rh5X6Q1-jZkO1-yQi9CjkrExpmg-9KnOltvwYwPvWQTBsUwB6YsFQ>
    <xmx:6rh5XyzzLRzIoPEQoqDfbf4dTpaFmJSjR9XEniAPoyv-COgM0Ne_dw>
    <xmx:6rh5X3rRnDXc7J-w73ZUyAN0sW3SFfaVriNFNKK0fpgDU7LCMEWRZg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F3713064610;
        Sun,  4 Oct 2020 07:58:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i2c: i801: Exclude device from suspend direct complete" failed to apply to 5.4-stable tree
To:     jdelvare@suse.de, volker.ruemelin@googlemail.com, wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 04 Oct 2020 13:59:13 +0200
Message-ID: <1601812753201172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

From 845b89127bc5458d0152a4d63f165c62a22fcb70 Mon Sep 17 00:00:00 2001
From: Jean Delvare <jdelvare@suse.de>
Date: Thu, 10 Sep 2020 11:57:08 +0200
Subject: [PATCH] i2c: i801: Exclude device from suspend direct complete
 optimization
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

By default, PCI drivers with runtime PM enabled will skip the calls
to suspend and resume on system PM. For this driver, we don't want
that, as we need to perform additional steps for system PM to work
properly on all systems. So instruct the PM core to not skip these
calls.

Fixes: a9c8088c7988 ("i2c: i801: Don't restore config registers on runtime PM")
Reported-by: Volker Rümelin <volker.ruemelin@googlemail.com>
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Wolfram Sang <wsa@kernel.org>

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index ebb4c0b03057..bffca729e1c7 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1917,6 +1917,7 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pci_set_drvdata(dev, priv);
 
+	dev_pm_set_driver_flags(&dev->dev, DPM_FLAG_NO_DIRECT_COMPLETE);
 	pm_runtime_set_autosuspend_delay(&dev->dev, 1000);
 	pm_runtime_use_autosuspend(&dev->dev);
 	pm_runtime_put_autosuspend(&dev->dev);

