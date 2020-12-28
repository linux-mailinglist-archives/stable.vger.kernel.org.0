Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C832E3628
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgL1LGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:06:52 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34723 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727163AbgL1LGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:06:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1F25A316;
        Mon, 28 Dec 2020 06:05:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GLLJvc
        HnMF4iiQf/TYqhtrGbZpdyQ7gOGLEkMUTXDGc=; b=S2VJAl62JAyAR2a42fjCaK
        aTD1m4+e4ojHoxzPPa5m6ZZXO0xDlt/SQ/Wn07lCZtx/JwBm0pjmnpiRRlD3cdWx
        V8Mk5w6JIK109NGTySXrhdCuiHnaHnEOX4m0f9dEMf3/fuH/B8nTaoBtD6XgvDLH
        zHfCHD23RGgXwDE2+x+/antN2MZKBK0EMlhNxXt7mNNgHffxxs7kFWBLWOJVDXha
        iStySt62z9yXolkIamIxzm+3CugyVFN/zthaQrsnPet4h+Qk4iX4eU23pSfqM1/8
        +Ad1ZbrEf07lgy8WfYGC2ohfBpqXKaamFhxHkFl9YDkRT9WdmwR+G10c2D3Wk2lw
        ==
X-ME-Sender: <xms:CbzpX8G_VSQPAxkgXe3EfPCXV4oGTAPCA5TTyAXh4WnYO1MrSC7-bA>
    <xme:CbzpX1UnrO4SpSIJSJJ0ghy70-TAlIs1XDNk2AEM3hE2DRsCkagewTZx-EdT7MhjR
    9wa1SWEfhyINQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:CbzpX2J1XzomyA9JMztq-VWRXjhO0obKVv_6Q20_U0r7NA7xs1VlFw>
    <xmx:CbzpX-FyVhWuiraOLD2Q0d6zuVNcIzqaD1lB4wstYl0obyGuRMAbSg>
    <xmx:CbzpXyXUtAKyBDmlSFveOk8rjVW6vWHbaPUTIRwch8Cr-mYkUqFBcA>
    <xmx:CbzpX1eZWuYTeMM4beEJIkfnB-RDhryeAJNaV7enp36lArT2bT2bi_tHR24>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0B8F240057;
        Mon, 28 Dec 2020 06:05:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: mt7621: Disable clock in probe error path" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, broonie@kernel.org, miaoqinglang@huawei.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:07:08 +0100
Message-ID: <1609153628110242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 24f7033405abe195224ec793dbc3d7a27dec0b98 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:13 +0100
Subject: [PATCH] spi: mt7621: Disable clock in probe error path

Commit 702b15cb9712 ("spi: mt7621: fix missing clk_disable_unprepare()
on error in mt7621_spi_probe") sought to disable the SYS clock on probe
errors, but only did so for 2 of 3 potentially failing calls:  The clock
needs to be disabled on failure of devm_spi_register_controller() as
well.

Moreover, the commit purports to fix a bug in commit cbd66c626e16 ("spi:
mt7621: Move SPI driver out of staging") but in reality the bug has
existed since the driver was first introduced.

Fixes: 1ab7f2a43558 ("staging: mt7621-spi: add mt7621 support")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.17+: 702b15cb9712: spi: mt7621: fix missing clk_disable_unprepare() on error in mt7621_spi_probe
Cc: <stable@vger.kernel.org> # v4.17+
Cc: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/36ad42760087952fb7c10aae7d2628547c26a7ec.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-mt7621.c b/drivers/spi/spi-mt7621.c
index 2cdae7994e2a..e227700808cb 100644
--- a/drivers/spi/spi-mt7621.c
+++ b/drivers/spi/spi-mt7621.c
@@ -382,7 +382,11 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	return devm_spi_register_controller(&pdev->dev, master);
+	ret = devm_spi_register_controller(&pdev->dev, master);
+	if (ret)
+		clk_disable_unprepare(clk);
+
+	return ret;
 }
 
 static int mt7621_spi_remove(struct platform_device *pdev)

