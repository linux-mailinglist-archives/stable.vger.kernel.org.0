Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB27282A83
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 13:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgJDL61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 07:58:27 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:35627 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbgJDL61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 07:58:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3A0311940E31;
        Sun,  4 Oct 2020 07:58:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 04 Oct 2020 07:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5upEM1
        hztfJ9m9e/Qhvd6ksfVYorYxKmTC2VVA0VTv8=; b=EGUH8eoDGNjf0GJCLsuzLg
        8FECgCbyWxTDPHVMoOoNNgQwfiEck0/A3sCnQFiVboUCHX/KlNdHyAaAt6U1lJj1
        VgKhyQAqJQEZE9tcJWirpXTdUt5qCSUYxWol2qyi7lVTZUCGmGkW+IkpMY4gJyVw
        xlmGXMrQ0loia/ln+mgLKq8Hdl0R8XuPpais0eBm+7s9PFZKKxL4wjMZefm0X3CU
        QCyFtngSoexmA37hKOdIvFP8mK/v7OIQ0VBQdcasEZXWOkyvTPTkSzPQdU6KnN4D
        pPWspnx4yrVHLre4s2ghdZ0Vqgb8ly0VmepdqZ5GrVG9j8wRKH7eIjHyvYCi8vWg
        ==
X-ME-Sender: <xms:4bh5Xx6-gPrfeNHig7iJDZzW_mSNQrI041fpXyBgY6PHup_usSNOng>
    <xme:4bh5X-4CPuP-sO13DhYMumPBku8YVrYETz7J3Zv71l_W6V1febOp14j4p-AmM6L9I
    VG47wCNuNpEeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedtgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:4bh5X4dr0Yb5UWbFnjamjAXrMVLWMqdZswCPOIEr4K5CWDLMdWEpfg>
    <xmx:4bh5X6J-HQVmMpjAR6zAgnDjjAliZSaDFnOtNoeokNWusifWAOK8KQ>
    <xmx:4bh5X1I78CJc7gsAWfo5ztdbbRdGQGZdflq7p09U0-bZHIGeRdmVxQ>
    <xmx:4rh5Xzj8NAHg0-ugs0HBYgIv1IJV7sR-PWdmt6r4WBj2am_wDvcnxw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B966328005A;
        Sun,  4 Oct 2020 07:58:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i2c: i801: Exclude device from suspend direct complete" failed to apply to 4.19-stable tree
To:     jdelvare@suse.de, volker.ruemelin@googlemail.com, wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 04 Oct 2020 13:59:13 +0200
Message-ID: <160181275362155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

