Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170EE8118F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfHEFZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:25:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32793 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbfHEFZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:25:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 313952102F;
        Mon,  5 Aug 2019 01:25:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:25:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JOvorV
        Bb6QurfOjhqBfoRMexUh51J7UuGw1qNikUizc=; b=POFCoOyTPbtrSa7Ho0Sawv
        +JvymN1vbdPeR3e0ms0/ixnEHcxLKQ75Iu0U8bgDNwvkZyMfhvW+jEj4msUO1qgE
        VOabZgzPRsagKBAeozigSnjcpVJF8mbM9l1Wy3UWDAdV0kZyQidJqKrY5z0EfNaN
        eXdGdx3Egoh4HBfZCL2wIkyJRbtDsYphY0jcm9Bw3cHtGrAB6yPYVKBJgk4oAUmg
        xqg3uVaK1HVNx7fXmlOX1ee2+jzj2fvwBOPK3O1RMRb+6wQyUsafagGzRvTGY9n3
        cTkZM0FB/vR5gkciOnxTBu7uZxyFwyWjdJsv9r3SrkJDle+MHI37aGjRN31chPtA
        ==
X-ME-Sender: <xms:3r1HXYhKGQyv7bHE9ZbUoTwIHgrLNW0YIaGTZNDlXrhjlY8_LWo1zQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:3r1HXZQ2mPP_a1WlIHdzgIHj1Ox7QZbWcAhT_qSA4QAAI-A9VqHBSg>
    <xmx:3r1HXV-FJR_oQjf62T_xZ3m52ZHFXPqJURuX5OR9C3u1MeiLGHQ8Yg>
    <xmx:3r1HXa8_u8mR2_XG9hBL5osgzMcAIQF5yKbr87iKfaZg1NsQiVjUTw>
    <xmx:4L1HXUnoslU-4LmIWU07p8-KbGAeSc1Txyi7JYnp6yqg0YcCoMs5Yg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D7148005A;
        Mon,  5 Aug 2019 01:25:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] eeprom: at24: make spd world-readable again" failed to apply to 4.19-stable tree
To:     jdelvare@suse.de, andrew@lunn.ch, arnd@arndb.de,
        bgolaszewski@baylibre.com, brgl@bgdev.pl,
        gregkh@linuxfoundation.org, srinivas.kandagatla@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:25:48 +0200
Message-ID: <1564982748230183@kroah.com>
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

From 25e5ef302c24a6fead369c0cfe88c073d7b97ca8 Mon Sep 17 00:00:00 2001
From: Jean Delvare <jdelvare@suse.de>
Date: Sun, 28 Jul 2019 18:41:38 +0200
Subject: [PATCH] eeprom: at24: make spd world-readable again

The integration of the at24 driver into the nvmem framework broke the
world-readability of spd EEPROMs. Fix it.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org
Fixes: 57d155506dd5 ("eeprom: at24: extend driver to plug into the NVMEM framework")
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 35bf2477693d..518945b2f737 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -685,7 +685,7 @@ static int at24_probe(struct i2c_client *client)
 	nvmem_config.name = dev_name(dev);
 	nvmem_config.dev = dev;
 	nvmem_config.read_only = !writable;
-	nvmem_config.root_only = true;
+	nvmem_config.root_only = !(flags & AT24_FLAG_IRUGO);
 	nvmem_config.owner = THIS_MODULE;
 	nvmem_config.compat = true;
 	nvmem_config.base_dev = dev;

