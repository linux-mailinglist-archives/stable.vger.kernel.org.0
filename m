Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49EE717A3
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbfGWMBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:01:16 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48375 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728418AbfGWMBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:01:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 32D55220A7;
        Tue, 23 Jul 2019 08:01:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=H9H8ra
        635Vb6doX7H6E5Ri76n/gYQQVV56150huAi28=; b=GzFaYK7lZ4WtZXPHirFZw4
        9a6fYz9Jb0iGtR6MtFuagAyA5BYmhAvS1gs9N3doEW+/VJa5NpUaCpQX+CjV7Uqu
        sd3EKw8seFUEBShqGHAnE3tszo6A7mFTwpvt/pL6E1dOXv98TafpF/v/nHLzyAGO
        u917/PpApM/bxwa+f877Se5VVLayw4LmMw2roWaeBpYSI3ytNtQo9hl8ZyQCxOSD
        Wp3NNY9kWtBxa1uvYCFO3eaZ9G6i5U9j53YnABsTdNvUxZRSaj7uSiXjpAvGiJGP
        mkv7rUL1B9RgNb7mXOdsJ6qqQ2fACfPyLfZ0GzJUS8Kp3HeMjnHvhdgGX8hhVKGg
        ==
X-ME-Sender: <xms:C_c2XW5_8WNEiocNwZ2u5KDGF1ZtH3dcoBb8gJbEc9R4jV6Nl74DgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:C_c2XXTWpLH0Oq93Jxf3szkpvK-ifeKoP_wWrkkuZswq0b3SmycZoQ>
    <xmx:C_c2Xfyuuy0pbxvUU0iNK1RAz9s-BEXSRwrLCfz-7TxrHWBvHZcsTw>
    <xmx:C_c2XZIm3A1MAmzneSApfr_uLL6yOUYA8uLxXGAxLJChbuJK9O1Gow>
    <xmx:C_c2XaPw-4wAb0mpRXKTkPyVH-F6N1nUr1eo1YM9tbca1y3HEbM5JA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C44E80061;
        Tue, 23 Jul 2019 08:01:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: qcom: Ensure that PERST is asserted for at least 100 ms" failed to apply to 4.9-stable tree
To:     niklas.cassel@linaro.org, lorenzo.pieralisi@arm.com,
        svarbanov@mm-sol.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:01:05 +0200
Message-ID: <156388326512864@kroah.com>
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

From 64adde31c8e996a6db6f7a1a4131180e363aa9f2 Mon Sep 17 00:00:00 2001
From: Niklas Cassel <niklas.cassel@linaro.org>
Date: Wed, 29 May 2019 11:43:52 +0200
Subject: [PATCH] PCI: qcom: Ensure that PERST is asserted for at least 100 ms

Currently, there is only a 1 ms sleep after asserting PERST.

Reading the datasheets for different endpoints, some require PERST to be
asserted for 10 ms in order for the endpoint to perform a reset, others
require it to be asserted for 50 ms.

Several SoCs using this driver uses PCIe Mini Card, where we don't know
what endpoint will be plugged in.

The PCI Express Card Electromechanical Specification r2.0, section
2.2, "PERST# Signal" specifies:

"On power up, the deassertion of PERST# is delayed 100 ms (TPVPERL) from
the power rails achieving specified operating limits."

Add a sleep of 100 ms before deasserting PERST, in order to ensure that
we are compliant with the spec.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org # 4.5+

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index da5dd3639a49..7e581748ee9f 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -178,6 +178,8 @@ static void qcom_ep_reset_assert(struct qcom_pcie *pcie)
 
 static void qcom_ep_reset_deassert(struct qcom_pcie *pcie)
 {
+	/* Ensure that PERST has been asserted for at least 100 ms */
+	msleep(100);
 	gpiod_set_value_cansleep(pcie->reset, 0);
 	usleep_range(PERST_DELAY_US, PERST_DELAY_US + 500);
 }

