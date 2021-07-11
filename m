Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7295A3C3BFD
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhGKLut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:50:49 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38759 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232319AbhGKLut (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 07:50:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3F73D194079F;
        Sun, 11 Jul 2021 07:48:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 07:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qEkvpe
        fm9WE3Dp6YKO4UTIiM63y3bRyqjjZRj7RjK58=; b=O/WapmxJYrFqAp5lqLnzA3
        zX1H30cOJ4b/EXR3GhvjGa92YRc4D4q5M+j8d4mdf+xnVklZl+WqqIzHX5pviTn6
        cMwgBWebYZZ31Plo2SEdtWVtrBwlTBYmlM9cKEnhzKDTXPHMC3gqNW4desqVTnTI
        5owOOU2MvqUG0fBGkxIY7XsUlvLuoU8gGXpasQU2DXaa/YUEgSNuw+Qs9d/H/tIw
        RBFZ3D8WboM9PjTlmfx0MDYUaEiR+bbUEB8dYfmP4E16CN6V4KIbAx64lZ0Ep70J
        ea7Cu/vFlHQQUMsWysQLVScwaXmvR5h+Txp/KnUEt4J75/wp8JFBJQxOoYxB1WSw
        ==
X-ME-Sender: <xms:ctrqYH5-WEJ01aBEqURzavuB4JWO9kh3sp1d8xwzX1Bc17J7f9KDpw>
    <xme:ctrqYM4rcemJDWa_4ZsuNIA3KcNAdGARj_S1rjqxn_XfRafG6KUfCnY3HT8k9hqmY
    bZybY6_uIQ3NA>
X-ME-Received: <xmr:ctrqYOcS0w-bqeh4by5tlZ5u5-C8RzGDzyTdOsaKvT0nIJRmFYdUlTKvn6k-h1XG5lYQ7ot1v-1yFV_NQ8CzkO_Kvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:ctrqYIICsmMgPffdmXOlPBOWrwv2dUjJrTDcNeLPZ6lzK4zYxjj8sw>
    <xmx:ctrqYLKhJ6nNay05C65t4PzgCfmHhGdzu5oYok4K_c_YU144r4BlXA>
    <xmx:ctrqYBxhJI4mTxGZtBhPgD743tNxr1b5oyr0D7OQ8vkZAr7Zr-hotQ>
    <xmx:ctrqYBgcop_JDez36CkE05_DQmGa62A3R3lrhHq1Y0pI0yhw6iCMHA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 07:48:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: usb-audio: Fix OOB access at proc output" failed to apply to 4.14-stable tree
To:     tiwai@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 13:48:00 +0200
Message-ID: <162600408018652@kroah.com>
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

From 362372ceb6556f338e230f2d90af27b47f82365a Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Tue, 22 Jun 2021 11:06:47 +0200
Subject: [PATCH] ALSA: usb-audio: Fix OOB access at proc output

At extending the available mixer values for 32bit types, we forgot to
add the corresponding entries for the format dump in the proc output.
This may result in OOB access.  Here adds the missing entries.

Fixes: bc18e31c3042 ("ALSA: usb-audio: Fix parameter block size for UAC2 control requests")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210622090647.14021-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 428d581f988f..4ea4875abdf8 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3294,8 +3294,9 @@ static void snd_usb_mixer_dump_cval(struct snd_info_buffer *buffer,
 				    struct usb_mixer_elem_list *list)
 {
 	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
-	static const char * const val_types[] = {"BOOLEAN", "INV_BOOLEAN",
-				    "S8", "U8", "S16", "U16"};
+	static const char * const val_types[] = {
+		"BOOLEAN", "INV_BOOLEAN", "S8", "U8", "S16", "U16", "S32", "U32",
+	};
 	snd_iprintf(buffer, "    Info: id=%i, control=%i, cmask=0x%x, "
 			    "channels=%i, type=\"%s\"\n", cval->head.id,
 			    cval->control, cval->cmask, cval->channels,

