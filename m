Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4940F766C3
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfGZNAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:00:35 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:35797 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfGZNAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 09:00:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0917356F;
        Fri, 26 Jul 2019 09:00:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 26 Jul 2019 09:00:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9rGhEb
        mA/yWQXl9vs75MYs3lUTmp84YL82X57Y79keg=; b=i69G/3FIzt+c46Kh+LRRWA
        yujIpEgQaP/b5EsdbqMm5oyd8FIRJa7h8JSWMSWJ21o2D11pcfozJaQZ+ej4KL0O
        1RtcR3LuUQouvHGSAcK38jIe0BIjIDsXkBIJKWHYZkdb75SHM4w92owIaCE006sL
        ruM2meGd3Cc+hc08+2IA4GDXJ1AEhsgiS7ya4J+6SsezQwano9DlStHgvAub8l/o
        onPnSt8pZm5ya0WNFz8auJShyZMpQZp7Wx/decK7IS6mm53aHA4vJuR7V7GeveFU
        CbSZ9j8G/drY6latsyvlr+ZbdqxlXMyDtBX4cfOV+eo7OjFnF+zvBT3RwuUYCOXA
        ==
X-ME-Sender: <xms:b_k6XZrqU4msDMX8nkVFad_r1N4VH_A8HWdlb44YoHae4dy9c8xL5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:cPk6XcGyI-Od1TV8Ev6KLCMgQ1Wkrk64KsQM9iipxq-XqZRV71DcHA>
    <xmx:cPk6XV_ym1G3D03H331-bkGWhOLLpz0NUrLU6rLt82cVaEWx91dY4w>
    <xmx:cPk6XRRcTQOPN37m0Hhb-TIRoBGwj4b3pIE7u1Qvi4Ab_sx6S7adxA>
    <xmx:cPk6XaOqYsvVLqwGda6RSnfA3XVRGjc6j-CBV7I6DocUqupXfR_wKQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 982C680063;
        Fri, 26 Jul 2019 09:00:31 -0400 (EDT)
Subject: WTF: patch "[PATCH] gpio: em: remove the gpiochip before removing the irq domain" was seriously submitted to be applied to the 5.2-stable tree?
To:     bgolaszewski@baylibre.com, geert+renesas@glider.be,
        geert@linux-m68k.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jul 2019 15:00:30 +0200
Message-ID: <1564146030179130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.2-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 19ec11a2233d24a7811836fa735203aaccf95a23 Mon Sep 17 00:00:00 2001
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Thu, 11 Jul 2019 10:29:35 +0200
Subject: [PATCH] gpio: em: remove the gpiochip before removing the irq domain

In commit 8764c4ca5049 ("gpio: em: use the managed version of
gpiochip_add_data()") we implicitly altered the ordering of resource
freeing: since gpiochip_remove() calls gpiochip_irqchip_remove()
internally, we now can potentially use the irq_domain after it was
destroyed in the remove() callback (as devm resources are freed after
remove() has returned).

Use devm_add_action_or_reset() to keep the ordering right and entirely
kill the remove() callback in the driver.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: 8764c4ca5049 ("gpio: em: use the managed version of gpiochip_add_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index b6af705a4e5f..a87951293aaa 100644
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -259,6 +259,13 @@ static const struct irq_domain_ops em_gio_irq_domain_ops = {
 	.xlate	= irq_domain_xlate_twocell,
 };
 
+static void em_gio_irq_domain_remove(void *data)
+{
+	struct irq_domain *domain = data;
+
+	irq_domain_remove(domain);
+}
+
 static int em_gio_probe(struct platform_device *pdev)
 {
 	struct em_gio_priv *p;
@@ -333,39 +340,30 @@ static int em_gio_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
+	ret = devm_add_action_or_reset(&pdev->dev, em_gio_irq_domain_remove,
+				       p->irq_domain);
+	if (ret)
+		return ret;
+
 	if (devm_request_irq(&pdev->dev, irq[0]->start,
 			     em_gio_irq_handler, 0, name, p)) {
 		dev_err(&pdev->dev, "failed to request low IRQ\n");
-		ret = -ENOENT;
-		goto err1;
+		return -ENOENT;
 	}
 
 	if (devm_request_irq(&pdev->dev, irq[1]->start,
 			     em_gio_irq_handler, 0, name, p)) {
 		dev_err(&pdev->dev, "failed to request high IRQ\n");
-		ret = -ENOENT;
-		goto err1;
+		return -ENOENT;
 	}
 
 	ret = devm_gpiochip_add_data(&pdev->dev, gpio_chip, p);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add GPIO controller\n");
-		goto err1;
+		return ret;
 	}
 
 	return 0;
-
-err1:
-	irq_domain_remove(p->irq_domain);
-	return ret;
-}
-
-static int em_gio_remove(struct platform_device *pdev)
-{
-	struct em_gio_priv *p = platform_get_drvdata(pdev);
-
-	irq_domain_remove(p->irq_domain);
-	return 0;
 }
 
 static const struct of_device_id em_gio_dt_ids[] = {
@@ -376,7 +374,6 @@ MODULE_DEVICE_TABLE(of, em_gio_dt_ids);
 
 static struct platform_driver em_gio_device_driver = {
 	.probe		= em_gio_probe,
-	.remove		= em_gio_remove,
 	.driver		= {
 		.name	= "em_gio",
 		.of_match_table = em_gio_dt_ids,

