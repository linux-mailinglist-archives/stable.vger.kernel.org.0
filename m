Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294612E36BE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgL1Lqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:46:42 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:57519 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbgL1Lqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:46:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E93CF7EC;
        Mon, 28 Dec 2020 06:45:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:45:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Im6ZJ0
        YdNjlt/qOYwofU1gtXf6E+/rmYm8ekWGpd1B8=; b=n+BaL7NggGFbRELhSZQy0N
        xph4xqSmq8LQjkGuvnjkkyLzlC12maPnznp/4042fy5iOr8Rg0Gzb0SENqHLFocV
        yzxLaTSf2F77aB0ZZ2J2kTxLuik9Ni35Ww7tEqfHYK5TejGxI7qBLG5gucBsQJEi
        uF8qGkcclBo+h4Q2ch9dI9stlkSVCjXyv2MwyqF4oIdUuMyT6HHsBjjeM1WTN9U2
        NVZXF+/2teuuR62se10YZF2odgRMOIzDemK+0yfbRdRbj8oXWYx20uJmn6lrUD68
        856D574DCTTOcjqSO63/Q44aZVEvqC1YQM6m8EmSJvi17BNyPameE19y/vHt9A5A
        ==
X-ME-Sender: <xms:X8XpX79NyNI2B6XTzT7dUGNZvoTW_gZs768B4YI1c2auCZXF5H3VgQ>
    <xme:X8XpX3vQLEsWzRyT6zwRFCfkmMyD14kTZBqFsShuAQYnQ-ezu9AdwRIyutvfo-9RI
    bKSy0HWg7GA8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:X8XpX5CeJxg4pxxSKs33VsrwcJX8LnvXqmb55ZaA9qsyb-0VR3c3DA>
    <xmx:X8XpX3dP9zJIAO4PyZboC_FEADnJJ5srUGEpEYNUZ0jCl-EBGNIAzg>
    <xmx:X8XpXwOEqZQxu513LpRsrMuVK15MQarvScDkwNiGE3Oe-u_qJidkdQ>
    <xmx:X8XpX6X9szt_xdgCJP2YMaeL_c5n5nvdaOrqp6HDgXRDNmIfZI4TBfQ66M0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD635108005C;
        Mon, 28 Dec 2020 06:45:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] of: fix linker-section match-table corruption" failed to apply to 4.14-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:46:56 +0100
Message-ID: <16091560165183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

