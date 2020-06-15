Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192811F9BDE
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgFOPVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:21:50 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:49713 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730158AbgFOPVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:21:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 48D917D4;
        Mon, 15 Jun 2020 11:21:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:21:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dlcAF/
        S24whyn7k4i/EehPa0K7kk7xyL1em33VQosH4=; b=LeXYJACubf7WFMKSnsjnMv
        6m9x3DjrmqZW0biTuuD3ZX9W8xvMat81/6nuVtq6WbzJezXXHjouL3lE6ykP+U6N
        mBw4Vd4DxR6NUyzBJdUs9zVIAu7LouXFTqmkKiFsKp4YZSTX54YIY2QYkLHlcNMg
        SoAjtC/ZjEjSwSJu+5iHJfVcpB7hMc9ALAz/lk6llDQa5n3l/TRuBRpxjBNWaY8A
        AJ124f0LMpEaqXcFefcB/czxpaL5K3Z6sVVm8/03rF3rZ4xIetNAQUyBnBh41nlh
        9pku1GRhqVRzT/d/qpBDmkqr16yXBaIUssYmnYS3qkQQvQ+2OuXXWsYebA/l+GjQ
        ==
X-ME-Sender: <xms:DJLnXjeEEHMJnUURc0gGd9NkIsqNqKEmjOAFW3sne-UdbOHaXOl6eA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:DJLnXpPRe7Er4gU6IwIaNfK7SP6TfndnooTm8fxLxZPYgPJXEczI7A>
    <xmx:DJLnXsil5nQl_crClonee1kKLHOVtjoQo4mRAW_SrpCpR3L5H0PI6w>
    <xmx:DJLnXk-yaYifSkuH4zk5wuRBVB5eRLqkYT04MFDmKE5VwSVa_pegTA>
    <xmx:DJLnXoUYIS3rrvZyKjomwGkj2yFdcKADypwLLipIjXgR889NfJutOjOUo8g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83C903280066;
        Mon, 15 Jun 2020 11:21:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: pxa2xx: Fix runtime PM ref imbalance on probe error" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, andriy.shevchenko@linux.intel.com,
        broonie@kernel.org, jarkko.nikula@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:21:37 +0200
Message-ID: <15922344972213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 65e318e17358a3fd4fcb5a69d89b14016dee2f06 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 25 May 2020 14:25:03 +0200
Subject: [PATCH] spi: pxa2xx: Fix runtime PM ref imbalance on probe error

The PXA2xx SPI driver releases a runtime PM ref in the probe error path
even though it hasn't acquired a ref earlier.

Apparently commit e2b714afee32 ("spi: pxa2xx: Disable runtime PM if
controller registration fails") sought to copy-paste the invocation of
pm_runtime_disable() from pxa2xx_spi_remove(), but erroneously copied
the call to pm_runtime_put_noidle() as well.  Drop it.

Fixes: e2b714afee32 ("spi: pxa2xx: Disable runtime PM if controller registration fails")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v4.17+
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/58b2ac6942ca1f91aaeeafe512144bc5343e1d84.1590408496.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index f456ce18f79e..f6e87344a36c 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1893,7 +1893,6 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	return status;
 
 out_error_pm_runtime_enabled:
-	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 out_error_clock_enabled:

