Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF89CED408
	for <lists+stable@lfdr.de>; Sun,  3 Nov 2019 18:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfKCRll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 12:41:41 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59773 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727488AbfKCRlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 12:41:40 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D0495212BF;
        Sun,  3 Nov 2019 12:41:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 03 Nov 2019 12:41:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=X4qSCM
        UmeIV0jlp0CZLBIv+CLB/UigzksNHFjRM7Fuc=; b=apz2eFL9JusanhPzIeYuUh
        8+VOB4gCLO09xu48/0oK1V7g+vnI39QNCPPi3tXE4Q7fD/zKG0t+clsleWrDhI6g
        bjmpBgjQAgJ/FcehjXIQUWe4E1HxpHd5dD0SJ0IKk5js5wc6lqXVrNvQ654AtGm0
        Tywu3tTjo6l0usP39DXF+WWwQum7L11nHkzW1feN6ZL2RVXxxH8FqX8T6VaWsSLg
        EFQBReNK6VgaIUigF0WkkM7sjqs/LH5xIguHwEk0jrXZZRZtAD2zkF9eVO6xUsfW
        a0TaAjAKtoUYdFN28lMYZbcKPichR1lqJCgT8AUalvpR3XQRYdZLKn41LrkOoRuw
        ==
X-ME-Sender: <xms:UxG_Xb-aSf5nMq3qwhIGaBCSjgiZfLR1gTgbWhfiALKLMx0ZOeM-oA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduuddguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:UxG_XUBqHXKzKo8beWb-THAgIAbEzgEIfABU3w79jB417ZVcveupYQ>
    <xmx:UxG_XbzG-oXiqJ0ImwZf1soeJBIdrVnFJT0e4ezmNwtG2NUTxdizeA>
    <xmx:UxG_XZQlN3B4TaVyHriGtpfk-ZhZNLwhf9n7Nv4pbdi6si3BOc7OUQ>
    <xmx:UxG_XfujsJ0ebK5FKgokiLHvSfKQ3L5Omceot_r3qZ7FVv6O3dM0dQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F00C306005B;
        Sun,  3 Nov 2019 12:41:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] ALSA: usb-audio: Add DSD support for Gustard U16/X26 USB" failed to apply to 5.3-stable tree
To:     flyingecar@gmail.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Nov 2019 18:41:38 +0100
Message-ID: <1572802898108163@kroah.com>
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

From e2995b95a914bbc6b5352be27d5d5f33ec802d2c Mon Sep 17 00:00:00 2001
From: Justin Song <flyingecar@gmail.com>
Date: Thu, 24 Oct 2019 12:27:14 +0200
Subject: [PATCH] ALSA: usb-audio: Add DSD support for Gustard U16/X26 USB
 Interface

This patch adds native DSD support for Gustard U16/X26 USB Interface.
Tested using VID and fp->dsd_raw method.

Signed-off-by: Justin Song <flyingecar@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CA+9XP1ipsFn+r3bCBKRinQv-JrJ+EHOGBdZWZoMwxFv0R8Y1MQ@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index fbfde996fee7..0bbe1201a6ac 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1657,6 +1657,7 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	case 0x23ba:  /* Playback Designs */
 	case 0x25ce:  /* Mytek devices */
 	case 0x278b:  /* Rotel? */
+	case 0x292b:  /* Gustard/Ess based devices */
 	case 0x2ab6:  /* T+A devices */
 	case 0x3842:  /* EVGA */
 	case 0xc502:  /* HiBy devices */

