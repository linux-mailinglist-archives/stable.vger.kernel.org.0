Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929F42E36BA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgL1LqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:46:18 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:44831 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbgL1LqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:46:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6A2797DB;
        Mon, 28 Dec 2020 06:45:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:45:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=athII7
        ILOZ9Fyw1LjXVnKnwtLsvPLHMtplNtHes+tF0=; b=F2Y5QxWIWbtQ+hcUTxrw5a
        ypNETchyfgEcvMX+Ic9F416n8JyjMsVAS5FCl7sATLm0zY3gRGoREOYMN3otFjFn
        32spPc2TtDQORjwgz3U/DL5/KDx3/k6chXF7iqKScj4J6dutSusALNJW5D2KbYlP
        /i+b8wRFlKAEvVHmGcB+P+N1GdJ9/9uipf2eRqojV11XrHa2NpVTcpo6gsIZwM0a
        zrw1J9UFzStr0c+ivR3YLO5bZ5zL+3zgkTQSZ9VHpZTUPRhVks8DpCdOYkgcI6cO
        muSpuDcuj0VtINF7ukocZx1Gfg5yBhJ/4ouVIPOP5BXjvosBRF75WSbgc9BrzuvA
        ==
X-ME-Sender: <xms:W8XpXxHMpckfiXFQpL65zsB1FjNPmaokFESfaYYOsYfxNcs2KG4-ew>
    <xme:W8XpX2VFkfZYfyjz1_S2qxNLR2O1qek_4EwPsWNMwYoOMULGX6r-8PsVPQKVPhNpC
    MvI96tekV5ffg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:W8XpXzKirwZfv50TcvRUldtRI4hyRAuP5rMJQ7FkUuBrMRFahH7Gbg>
    <xmx:W8XpX3FnfMuUiXgQqw2u4MCDv_iNrfA12qMGSDbtIDuOROWiTH9wZA>
    <xmx:W8XpX3VVV_-GdLZsBuj5eRg5HUD5cDT3StQXsfuQkKOGUIIoQpN-LQ>
    <xmx:XMXpX4cT6Jms81MJCK4hJL6zd4DZ1e0NEn9NP0ksOt0udJL0u64JNP8xsB8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 208B81080057;
        Mon, 28 Dec 2020 06:45:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] of: fix linker-section match-table corruption" failed to apply to 4.4-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:46:54 +0100
Message-ID: <1609156014198158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

