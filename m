Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F190186A24
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbgCPLe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:34:28 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36845 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730783AbgCPLe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:34:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 0BE6880C;
        Mon, 16 Mar 2020 07:34:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:34:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qhbpM0
        r6uWHA4T/LkxqQKO0Qw1Hv797cFWOT4FY5HHw=; b=rkehr4ZEbAlSE4QSoQ3NT5
        I6fHi95leOtJTkmDXZZmnNq5hSQqoS5jKCBMnGc+ecbW5fFXTrb8XCsJa2ri/7M+
        ymJUaefnoK6Ixoh8bHIy0e4uIJcPDxTONhxApAbPHmNnnsxm9WC/Cbv+tR+ZcP6J
        hd8B9ttVZ6K+jiJcWZsjB1UJZV2KmSN5gyWp1JsCSyjBPtv505JHXmRSfkSKJVo7
        jv4o2QkFg3LYtHrUJlG55ILQXawr/61VnlSYobn7Pmx0ou8Y1tR19sxODvAoI6Jc
        zznaTRDTf4MqQxkNS1kH5+GUZlVFhqcFT5DmlRFJIj0BBmXYJZvgus6siDodNHNw
        ==
X-ME-Sender: <xms:QmRvXm7vwZp3Eh1EAI06gLiCU3FklASo6KC_YXJ0Ya0DnM-7uzK0dA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:QmRvXkK7POA-8ZTcXRYZf94xk5dtdo3AslY-DxZCmRAoXXSlKvdJ9w>
    <xmx:QmRvXgf0m6ig_2VGjCUbCk-vtrBgsmtNSmp2MsspR8368pTZ0LUrag>
    <xmx:QmRvXnc6GP8t1K86-ASZzWKbcGPYT4lBiHYLfuia1ER53urOrx0jAg>
    <xmx:QmRvXqL_Vb4BZ_WdC6kfmixJUtwQEeyNXQw0ZF8LxBRQTnNUHZ87Cg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 389293280065;
        Mon, 16 Mar 2020 07:34:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug" failed to apply to 5.5-stable tree
To:     linus.walleij@linaro.org, bjorn.andersson@linaro.org,
        masneyb@onstation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:34:23 +0100
Message-ID: <158435846351251@kroah.com>
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

From f98371476f36359da2285d1807b43e5b17fd18de Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 6 Mar 2020 15:34:15 +0100
Subject: [PATCH] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug

We are parsing SSBI gpios as fourcell fwspecs but they are
twocell. Probably a simple copy-and-paste bug.

Tested on the APQ8060 DragonBoard and after this ethernet
and MMC card detection works again.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Brian Masney <masneyb@onstation.org>
Fixes: ae436fe81053 ("pinctrl: ssbi-gpio: convert to hierarchical IRQ helpers in gpio core")
Link: https://lore.kernel.org/r/20200306143416.1476250-1-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
index fba1d41d20ec..338a15d08629 100644
--- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
@@ -794,7 +794,7 @@ static int pm8xxx_gpio_probe(struct platform_device *pdev)
 	girq->fwnode = of_node_to_fwnode(pctrl->dev->of_node);
 	girq->parent_domain = parent_domain;
 	girq->child_to_parent_hwirq = pm8xxx_child_to_parent_hwirq;
-	girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_fourcell;
+	girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_twocell;
 	girq->child_offset_to_irq = pm8xxx_child_offset_to_irq;
 	girq->child_irq_domain_ops.translate = pm8xxx_domain_translate;
 

