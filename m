Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A352E36BD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgL1LqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:46:20 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45751 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbgL1LqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:46:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2CFE1760;
        Mon, 28 Dec 2020 06:45:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:45:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=H6Ko+o
        Sh+7VbkbAr5fT/LEE3P5qQs1dDKIJY4CVH+Ww=; b=QkVS6xrjy7hAL1V4NAANsb
        ENQdYBsWx3PqIPwv8aka3iv+dL0n5ed8SUT76VmKESaXpoSsKm26lpXmZZXAe+np
        kM9JLKVSTD2+GWDBx8PlXZTe9+sLNWdqCoeBp5/QUfVIuRugVYXIxL8PLsvLZS6/
        20stK+Sql9OVLOggtd5uFJPkRLCJriNh9rhNGlZp77TI+5BLXXOvRoTQd9NLJPU9
        RLoz2Q7OwEnTTzQnfruHBnoeAjAk+jQqEVW5ISB6UncWBrh6WmWy1qvSidtiEleC
        da8rwAG0h1qjuYOhyV2eV6MIe74kTjCztFBItsrezdiGFHmiM/nY8misHkdlwXaQ
        ==
X-ME-Sender: <xms:XcXpX1_9MmtkOHfmW4u5Iuf1K6Al-CRip2IQ60OnRxDVGJ2AzSVtyw>
    <xme:XcXpX5tX47Fqnyu6HNU5gN6FXr4VbQfPn3gFMeEHhHQCwx1mh9nUA4TUpZ9i6c1j8
    rWfoZ7hpJ3OnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:XcXpXzDnxSIPJUmScY4aB2MvE1sdoAtsYh2Hy-sV08Y1FfPLhgQeJQ>
    <xmx:XcXpX5f7G6HGpD217HTSV-lHrbxF23Z2NeImRgBEantfXTAqNP6n4g>
    <xmx:XcXpX6ONa9o2OcgC61SqHAKWP7Te-2d9zPd2VF07ekOprYJNzLzIXQ>
    <xmx:XcXpX0W6VsgXM6t5BGx44BXWTMntVQUNoQ51pZ6IISVwErHGQSOvxfIwXf8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B3D324005C;
        Mon, 28 Dec 2020 06:45:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] of: fix linker-section match-table corruption" failed to apply to 4.9-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:46:55 +0100
Message-ID: <1609156015208202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 5812b32e01c6d86ba7a84110702b46d8a8531fe9 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 23 Nov 2020 11:23:12 +0100
Subject: [PATCH] of: fix linker-section match-table corruption

Specify type alignment when declaring linker-section match-table entries
to prevent gcc from increasing alignment and corrupting the various
tables with padding (e.g. timers, irqchips, clocks, reserved memory).

This is specifically needed on x86 where gcc (typically) aligns larger
objects like struct of_device_id with static extent on 32-byte
boundaries which at best prevents matching on anything but the first
entry. Specifying alignment when declaring variables suppresses this
optimisation.

Here's a 64-bit example where all entries are corrupt as 16 bytes of
padding has been inserted before the first entry:

	ffffffff8266b4b0 D __clk_of_table
	ffffffff8266b4c0 d __of_table_fixed_factor_clk
	ffffffff8266b5a0 d __of_table_fixed_clk
	ffffffff8266b680 d __clk_of_table_sentinel

And here's a 32-bit example where the 8-byte-aligned table happens to be
placed on a 32-byte boundary so that all but the first entry are corrupt
due to the 28 bytes of padding inserted between entries:

	812b3ec0 D __irqchip_of_table
	812b3ec0 d __of_table_irqchip1
	812b3fa0 d __of_table_irqchip2
	812b4080 d __of_table_irqchip3
	812b4160 d irqchip_of_match_end

Verified on x86 using gcc-9.3 and gcc-4.9 (which uses 64-byte
alignment), and on arm using gcc-7.2.

Note that there are no in-tree users of these tables on x86 currently
(even if they are included in the image).

Fixes: 54196ccbe0ba ("of: consolidate linker section OF match table declarations")
Fixes: f6e916b82022 ("irqchip: add basic infrastructure")
Cc: stable <stable@vger.kernel.org>     # 3.9
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20201123102319.8090-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/include/linux/of.h b/include/linux/of.h
index 5d51891cbf1a..af655d264f10 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1300,6 +1300,7 @@ static inline int of_get_available_child_count(const struct device_node *np)
 #define _OF_DECLARE(table, name, compat, fn, fn_type)			\
 	static const struct of_device_id __of_table_##name		\
 		__used __section("__" #table "_of_table")		\
+		__aligned(__alignof__(struct of_device_id))		\
 		 = { .compatible = compat,				\
 		     .data = (fn == (fn_type)NULL) ? fn : fn  }
 #else

