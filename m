Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E965D65BC
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 17:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733045AbfJNPBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 11:01:01 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:40399 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732566AbfJNPBB (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 14 Oct 2019 11:01:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 5811F8FC;
        Mon, 14 Oct 2019 11:01:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 11:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7E0Rai
        8IGgilErVYKXcTT3Aqbd0eRqTPKwk3F+xT4GQ=; b=ZHiTK+Kgr5GHU0iDyjFthX
        aw+ALa/f7+3+rOfxSN3kTcOU5U528zbGKz/PglxlVOZbumoC+5qLEtSOK7VOQv18
        ZVWImy9mA465GSriE+l93oHm7M8ipJcAIq0VxqJzfurNwrwIIsTAAvCNjn4UYUaY
        JQmqklEiwso28dAIdmCzVmBr0+gauvizut47kmc8tuK7oGRYBm4hc3HL3ptS0Pkm
        UjknKN7vETyq4IJ5X/rf2+/+gDpQhgylPTigoG6Kr1cOaXNrAQwPTa3Sg0VVXQHZ
        Rn1kXOcssezpAFt1MJPCaRqd3xLyycDEF5lK7Dt+eedL1Zt1THmIYzKJllYAUboQ
        ==
X-ME-Sender: <xms:q42kXToPXSOUGIk7XFEcdL3M5UwQy1gbA4DHct7UAniQFoAL21FI3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:q42kXZVuEpujHLPxYzkr7w5qua6KtK3ElvyzegoJPr8LpaygD9kFWA>
    <xmx:q42kXXHrAIpBe2FB7-52MVLhgUvOGUEeZjBkNMGx49PGx73LTe0Vyw>
    <xmx:q42kXbuFBO6tIc_wVrCXMD8GxlK2gwwk8BtLMqxZWYwuPJk2iZX1Cg>
    <xmx:q42kXXbpA_kFs1_gkY3tr5TlYsTL0dA1bPS8rIkU5AY4hvI5yzGzfQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 681DFD60066;
        Mon, 14 Oct 2019 11:00:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: Fix an undefied reference error in noa1305_probe" failed to apply to 5.3-stable tree
To:     zhongjiang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 17:00:58 +0200
Message-ID: <15710652585179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a26e0fbe06e20077afdaa40d1a90092f16b0bc67 Mon Sep 17 00:00:00 2001
From: zhong jiang <zhongjiang@huawei.com>
Date: Mon, 23 Sep 2019 10:04:32 +0800
Subject: [PATCH] iio: Fix an undefied reference error in noa1305_probe

I hit the following error when compile the kernel.

drivers/iio/light/noa1305.o: In function `noa1305_probe':
noa1305.c:(.text+0x65): undefined reference to `__devm_regmap_init_i2c'
make: *** [vmlinux] Error 1

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index 08d7e1ef2186..4a1a883dc061 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -314,6 +314,7 @@ config MAX44009
 config NOA1305
 	tristate "ON Semiconductor NOA1305 ambient light sensor"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	 Say Y here if you want to build support for the ON Semiconductor
 	 NOA1305 ambient light sensor.

