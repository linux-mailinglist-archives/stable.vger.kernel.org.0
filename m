Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE832B49BD
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 16:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbgKPPpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 10:45:17 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53355 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730024AbgKPPpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 10:45:17 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4A0C2B77;
        Mon, 16 Nov 2020 10:45:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 10:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mXUVFV
        gWFErSCJkFeA8dsZyIUhgLC6oedBhfDz1E+Wo=; b=KabGdxVVSNLh/N++XhJJ6m
        RoWilij0dFyIJpzZMjDAknhxyPUjKi/qnuKhrR+VuulyJ2sLT4IIOUkR9tGWk0CU
        kxoVhkxAVvMl7Salq9I1cyoS0AJTvmEIvForNKbvNtr9cIne+OBLryX9LQt+S6l9
        7zj/vny0G36WeIdGEHneZmYKUF5529HOnVyJNlDYcCX7OGSfHsnCmR9nSk9kIebp
        GGyTIIT7MeipLEAwaPrP4Hl5WuAJMQPnIQjRfVHoJjHOX+YQa9jeqU5ksQXHxhwI
        OVoRwPjzVaWvHOxT69FQN/UKmFcFNzOCiOB6SbA5S4ZoMBUMHhXt/GHBhh7WwLLQ
        ==
X-ME-Sender: <xms:i56yX2W6a66Lm9GQQRy7brFzSsbu8BWac0GPSNTiMUvfNUTiN5Wlwg>
    <xme:i56yXyk3Z8BUdljAXBQWa4uBGxZczwTkelwbSuCMG7QN9c8ec1yqaCpiZ0TbYpGqu
    Ub2mobPdOuUew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:i56yX6aqrQbz-9apJ1nJBR3Gw9zspfZ0LOPlF5VohcB9ONrcxXOdew>
    <xmx:i56yX9U4Lmkk4mG-fHbraYx5fWltSSiITzAd4F5AbHHmhv5L-_bjUA>
    <xmx:i56yXwlVXaYk8nFoScsTRdcuGVoB8Jq438Nk8IKTBpW42lY3LByBVg>
    <xmx:i56yX3s2q6VpHAEVf3_zvk2xIrXQmN3Hg4AWPImZsUKiUyn4tqm5_PNmFgQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C5A773064AAE;
        Mon, 16 Nov 2020 10:45:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] firmware: xilinx: fix out-of-bounds access" failed to apply to 5.4-stable tree
To:     arnd@arndb.de, gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 16:46:06 +0100
Message-ID: <160554156698234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From f3217d6f2f7a76b36a3326ad58c8897f4d5fbe31 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 26 Oct 2020 16:54:36 +0100
Subject: [PATCH] firmware: xilinx: fix out-of-bounds access

The zynqmp_pm_set_suspend_mode() and zynqmp_pm_get_trustzone_version()
functions pass values as api_id into zynqmp_pm_invoke_fn
that are beyond PM_API_MAX, resulting in an out-of-bounds access:

drivers/firmware/xilinx/zynqmp.c: In function 'zynqmp_pm_set_suspend_mode':
drivers/firmware/xilinx/zynqmp.c:150:24: warning: array subscript 2562 is above array bounds of 'u32[64]' {aka 'unsigned int[64]'} [-Warray-bounds]
  150 |  if (zynqmp_pm_features[api_id] != PM_FEATURE_UNCHECKED)
      |      ~~~~~~~~~~~~~~~~~~^~~~~~~~
drivers/firmware/xilinx/zynqmp.c:28:12: note: while referencing 'zynqmp_pm_features'
   28 | static u32 zynqmp_pm_features[PM_API_MAX];
      |            ^~~~~~~~~~~~~~~~~~

Replace the resulting undefined behavior with an error return.
This may break some things that happen to work at the moment
but seems better than randomly overwriting kernel data.

I assume we need additional fixes for the two functions that now
return an error.

Fixes: 76582671eb5d ("firmware: xilinx: Add Zynqmp firmware driver")
Fixes: e178df31cf41 ("firmware: xilinx: Implement ZynqMP power management APIs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20201026155449.3703142-1-arnd@kernel.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 8d1ff2454e2e..efb8a66efc68 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -147,6 +147,9 @@ static int zynqmp_pm_feature(u32 api_id)
 		return 0;
 
 	/* Return value if feature is already checked */
+	if (api_id > ARRAY_SIZE(zynqmp_pm_features))
+		return PM_FEATURE_INVALID;
+
 	if (zynqmp_pm_features[api_id] != PM_FEATURE_UNCHECKED)
 		return zynqmp_pm_features[api_id];
 

