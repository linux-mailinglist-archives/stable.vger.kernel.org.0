Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29F02463F2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgHQKF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:05:28 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:43071 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbgHQKF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:05:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 93E1B1941E5A;
        Mon, 17 Aug 2020 06:05:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:05:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2+Ph/N
        2ko0nbSm+fbkKGOsjATK5wTwwXSBT8AmdZc5k=; b=UXtNkUE8y6oABTnWqWT1U8
        TZER53n91Po0d8D48OShEpP64bP8RZoslRV28LwMy2MAwnWoIbtqdbMkfInNHIB4
        gCnhoagpE3OQA6DCqpX9EuvDzX0CZrah165Ruy8doDQQis1cVmBLslduJZxtLpBn
        xq9JT51fjIzh2m+1rfi31QG1u3fhQNIBP5is5MKObvZktMVSKPLwJL+oGTYfZBaf
        vbQDVNbKUsE4hnYV+mOR1NSD2UXrYprMrqoiPncWGUp+ox9kXdPZQByECn2P+DxM
        CxAgdUjwqeqeV9B/l5vU4rvy+o6XN7ATgiTtYg8K0rAF252wZCiu37lShWo9mG0w
        ==
X-ME-Sender: <xms:ZlY6X4s8vu2NiO195-MuX8i0J_0KTNoADi3iLI3jHvmEbKiU8yEhxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZlY6X1fFfsZrtgQfQI_-tcpENbgu0GWKj_2TqzbTlRNgKHmUYlzz3A>
    <xmx:ZlY6XzyI2r4UUDHUuFbofSm4ByT_OfY9bWanF908pIF-k5vxc46nZw>
    <xmx:ZlY6X7NVpX2IYDR7uHVVLlJaoJy2MrlNDkM3mqKhLCPC79XYUPXuBA>
    <xmx:ZlY6X7KNh26tmx3QHqZWXviVGuvO4Q692eKtEmPnenVhUycCBzzheg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D12030600A6;
        Mon, 17 Aug 2020 06:05:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thunderbolt: Fix path indices used in USB3 tunnel discovery" failed to apply to 5.7-stable tree
To:     mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:05:38 +0200
Message-ID: <159765873831138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
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

