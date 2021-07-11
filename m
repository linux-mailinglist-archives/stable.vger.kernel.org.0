Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1083C3BFF
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbhGKLu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:50:59 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38831 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKLu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 07:50:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 727631940929;
        Sun, 11 Jul 2021 07:48:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 07:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ABDwN9
        x9mKQOj1YcZsNSYb/jbfqQSmRTN+5JZEKSg20=; b=rjaHUIaP/xAF1TBEvr41sk
        p8GrrMN3seTtuQCLh5y/dh6YnRhY6AiB8CDdEiyMpNsJdQaoVn4fH0S10E5NcKBV
        DB/oNkU+ygd1nzzBwe1CzhaZ/dQMLNC+DOONdcV5+5LFrMif5lRKU/uhhbBhhOvT
        jE15Tk/qqa/HJ6X/llWUJBJD3u2nwJlekV94HvGri5k7TzCel02oIOynf1bvqQfT
        Xp2dArW8OE1ZVYjYY/4jqAmlpygYpQP9Np0Gt62xr1Qs3KzeHmnMvlmJJjIXLAVV
        Klt5D5zhJ4hcA16KEQFNRfxSWc5nOKJESjjUhpvxcgooW7b+a5gqJRjzBYFAHw/A
        ==
X-ME-Sender: <xms:fNrqYN9DUclr-fBYQGzvonvuCJsv9CVge4UvQTRgeaev7JV3Tfv1DA>
    <xme:fNrqYBtcHvY4u9u_kgxe0CSuR48JxJ2W-20l6xVNeVL42hWJ5UQIp_BEu4vYip7IC
    6lSLfUcNU5Geg>
X-ME-Received: <xmr:fNrqYLDR8VvruG0dWPC_7PagB7nFmUMjZoA2H6reEiSywWvifyeiet6A0d09C-qEQ6y3kEB8Dt51SDNnfYMwPohoyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:fNrqYBfUfZvwAiKQPB8ICmEbR8E-mYRmGMr2GxxbSzlZlLb61WzoMw>
    <xmx:fNrqYCO8l_QORKpqLjcux7yyL9__1H_LzC7hzWMX8jFF9bBes0yudQ>
    <xmx:fNrqYDkpzcLph6K6eUn4DWYtTLrLqIIcAtZ4wgNATf0XPunesBYMwg>
    <xmx:fNrqYE2rnD223s5_-jtEM3FovN7QFaQR5zajrAkUbEfS9Dbxd9kGSA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 07:48:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: usb-audio: Fix OOB access at proc output" failed to apply to 4.9-stable tree
To:     tiwai@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 13:48:01 +0200
Message-ID: <162600408133141@kroah.com>
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

