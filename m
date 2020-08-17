Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D772463F1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgHQKFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:05:21 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:52109 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbgHQKFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:05:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 350431941E56;
        Mon, 17 Aug 2020 06:05:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:05:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ewaTn+
        3TEwO4uo+g9BclTRg4+lwNtF52p6+woqOtCAY=; b=qw0/QK/gHbylWyx5jk4LJ3
        Alm3e0XefnFhLs1r3qFQNvKCti8/kxeAhI5Z0qtwngRIH+H9nOO6DusC1JYNnNHM
        KTuF5eR9WgtKhZmkg7gkKH7L1iaLGO9Ub17jPT1oRD+6QKxAhKDNpF5ExYpFb7o7
        OYAy7IhQaDpxWhdc4HSGp6APkWLfAtIHjX6kZ0XWxaDaV5gkaqE72dI9zhLKzId3
        rxgDmhdXL1oCrcHl0m484ZFICxpTnYP4khU++GpDL5OARm0e9F7JGkw6qyWdwI2h
        Y1XvAjVqtymZdT1KrwfddU22H9sD3xngjC5fBpa1YdzCY4IPgqcmzWL19Gis9Mag
        ==
X-ME-Sender: <xms:XlY6X2nzwC9kK6BS0zO2n0WS8B47NeEG50wB_Yatu_nyxvowMao4EQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:XlY6X90Vmmr0ES1XHlgrTIIUmaaVxSirY3piJgBcYHJ2Ox1Si429aw>
    <xmx:XlY6X0o1XJjSL-T67zckaOWmqGQUHU8R1YhHPy5rpDD8ncrAjucy3g>
    <xmx:XlY6X6mYPkix9jUwq-IyfT-2mG55513uKIla4PzFRoxzXl5hamZzBg>
    <xmx:X1Y6X1ACi_A0uYxUpJ-GCvBZSy6v52jdtwnw12r0SeTbuAFt5TRtFQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C25A3280064;
        Mon, 17 Aug 2020 06:05:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thunderbolt: Fix path indices used in USB3 tunnel discovery" failed to apply to 5.8-stable tree
To:     mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:05:38 +0200
Message-ID: <1597658738241227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 783735f84fea6aad9b1e5931d6ea632796feaae3 Mon Sep 17 00:00:00 2001
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Thu, 2 Apr 2020 12:45:34 +0300
Subject: [PATCH] thunderbolt: Fix path indices used in USB3 tunnel discovery

The USB3 discovery used wrong indices when tunnel is discovered. It
should use TB_USB3_PATH_DOWN for path that flows downstream and
TB_USB3_PATH_UP when it flows upstream. This should not affect the
functionality but better to fix it.

Fixes: e6f818585713 ("thunderbolt: Add support for USB 3.x tunnels")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org # v5.6+

diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index dbe90bcf4ad4..c144ca9b032c 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -913,21 +913,21 @@ struct tb_tunnel *tb_tunnel_discover_usb3(struct tb *tb, struct tb_port *down)
 	 * case.
 	 */
 	path = tb_path_discover(down, TB_USB3_HOPID, NULL, -1,
-				&tunnel->dst_port, "USB3 Up");
+				&tunnel->dst_port, "USB3 Down");
 	if (!path) {
 		/* Just disable the downstream port */
 		tb_usb3_port_enable(down, false);
 		goto err_free;
 	}
-	tunnel->paths[TB_USB3_PATH_UP] = path;
-	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_UP]);
+	tunnel->paths[TB_USB3_PATH_DOWN] = path;
+	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_DOWN]);
 
 	path = tb_path_discover(tunnel->dst_port, -1, down, TB_USB3_HOPID, NULL,
-				"USB3 Down");
+				"USB3 Up");
 	if (!path)
 		goto err_deactivate;
-	tunnel->paths[TB_USB3_PATH_DOWN] = path;
-	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_DOWN]);
+	tunnel->paths[TB_USB3_PATH_UP] = path;
+	tb_usb3_init_path(tunnel->paths[TB_USB3_PATH_UP]);
 
 	/* Validate that the tunnel is complete */
 	if (!tb_port_is_usb3_up(tunnel->dst_port)) {

