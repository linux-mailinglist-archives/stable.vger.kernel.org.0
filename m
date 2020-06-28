Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C8D20C8B7
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 17:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgF1PbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 11:31:17 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:46669 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbgF1PbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 11:31:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C8B8E194078E;
        Sun, 28 Jun 2020 11:31:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 28 Jun 2020 11:31:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OcbJKQ
        Dr8/ZJRBwDBZAy9QCQizz+xTTjbhr1fSBFf/g=; b=RIuFLcvB2sSrtwc4xbt+YC
        DqGsdMajfv6ATJp0UCwVugJgKPVF1ui8wSCb2w6bx5CocPVleCnrNWdGSx4N0EoY
        CZK95+DItV4OuaZ+IV4uAAWmhMQUUx2JedLCoOb9gLFupnSYy7DkfK8kVBuYVGaB
        gy/p/nsOXg+DMYDltpMtcr5zZjCzoH/0iPLpKGX5RGhVAXbOzpzVmERL8aT+82ch
        15KV/XRwnDT0qX6t3/Mqh/eJ7QXb5Skxw+djaTh/Aza41CMjVe1Zy3y6oteMZgFI
        +AqDoKNIJuhfJ14zaSGMhoj6bSV9osv8+rffZT1yljkqATwp8Eqo9YVNiQMEXTAw
        ==
X-ME-Sender: <xms:w7f4XsYF8ArAkLLg6As_njzfyh5z71P5JJj3xLMAqylCCXYB9xpGGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeliedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:w7f4XnZ14JsCkhypwg6lw4kDFVZtz9lSa_oc7hCLeiCR0q-YWmIDdQ>
    <xmx:w7f4Xm9fQpzCGVOtXfjn43l7XBqLRsN5rT6nbeajxC5Qzq5wwnWzoQ>
    <xmx:w7f4XmrIN6suaE-ejT8GNomzIy30FSy78kQVsgS0Pnv3cbnLDODc4Q>
    <xmx:w7f4Xk0jddiBvzdFbVcynDOuAEgwvE6Qbq7jeA_sJl4jJVZ01vGx_Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5ED65328005A;
        Sun, 28 Jun 2020 11:31:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: usb-audio: Fix OOB access of mixer element list" failed to apply to 4.9-stable tree
To:     tiwai@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Jun 2020 17:30:59 +0200
Message-ID: <1593358259629@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 220345e98f1cdc768eeb6e3364a0fa7ab9647fe7 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 24 Jun 2020 14:23:40 +0200
Subject: [PATCH] ALSA: usb-audio: Fix OOB access of mixer element list

The USB-audio mixer code holds a linked list of usb_mixer_elem_list,
and several operations are performed for each mixer element.  A few of
them (snd_usb_mixer_notify_id() and snd_usb_mixer_interrupt_v2())
assume each mixer element being a usb_mixer_elem_info object that is a
subclass of usb_mixer_elem_list, cast via container_of() and access it
members.  This may result in an out-of-bound access when a
non-standard list element has been added, as spotted by syzkaller
recently.

This patch adds a new field, is_std_info, in usb_mixer_elem_list to
indicate that the element is the usb_mixer_elem_info type or not, and
skip the access to such an element if needed.

Reported-by: syzbot+fb14314433463ad51625@syzkaller.appspotmail.com
Reported-by: syzbot+2405ca3401e943c538b5@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200624122340.9615-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 15769f266790..eab0fd4fd7c3 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -581,8 +581,9 @@ static int check_matrix_bitmap(unsigned char *bmap,
  * if failed, give up and free the control instance.
  */
 
-int snd_usb_mixer_add_control(struct usb_mixer_elem_list *list,
-			      struct snd_kcontrol *kctl)
+int snd_usb_mixer_add_list(struct usb_mixer_elem_list *list,
+			   struct snd_kcontrol *kctl,
+			   bool is_std_info)
 {
 	struct usb_mixer_interface *mixer = list->mixer;
 	int err;
@@ -596,6 +597,7 @@ int snd_usb_mixer_add_control(struct usb_mixer_elem_list *list,
 		return err;
 	}
 	list->kctl = kctl;
+	list->is_std_info = is_std_info;
 	list->next_id_elem = mixer->id_elems[list->id];
 	mixer->id_elems[list->id] = list;
 	return 0;
@@ -3234,8 +3236,11 @@ void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid)
 	unitid = delegate_notify(mixer, unitid, NULL, NULL);
 
 	for_each_mixer_elem(list, mixer, unitid) {
-		struct usb_mixer_elem_info *info =
-			mixer_elem_list_to_info(list);
+		struct usb_mixer_elem_info *info;
+
+		if (!list->is_std_info)
+			continue;
+		info = mixer_elem_list_to_info(list);
 		/* invalidate cache, so the value is read from the device */
 		info->cached = 0;
 		snd_ctl_notify(mixer->chip->card, SNDRV_CTL_EVENT_MASK_VALUE,
@@ -3315,6 +3320,8 @@ static void snd_usb_mixer_interrupt_v2(struct usb_mixer_interface *mixer,
 
 		if (!list->kctl)
 			continue;
+		if (!list->is_std_info)
+			continue;
 
 		info = mixer_elem_list_to_info(list);
 		if (count > 1 && info->control != control)
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index 41ec9dc4139b..c29e27ac43a7 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -66,6 +66,7 @@ struct usb_mixer_elem_list {
 	struct usb_mixer_elem_list *next_id_elem; /* list of controls with same id */
 	struct snd_kcontrol *kctl;
 	unsigned int id;
+	bool is_std_info;
 	usb_mixer_elem_dump_func_t dump;
 	usb_mixer_elem_resume_func_t resume;
 };
@@ -103,8 +104,12 @@ void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid);
 int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 				int request, int validx, int value_set);
 
-int snd_usb_mixer_add_control(struct usb_mixer_elem_list *list,
-			      struct snd_kcontrol *kctl);
+int snd_usb_mixer_add_list(struct usb_mixer_elem_list *list,
+			   struct snd_kcontrol *kctl,
+			   bool is_std_info);
+
+#define snd_usb_mixer_add_control(list, kctl) \
+	snd_usb_mixer_add_list(list, kctl, true)
 
 void snd_usb_mixer_elem_init_std(struct usb_mixer_elem_list *list,
 				 struct usb_mixer_interface *mixer,
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index b6bcf2f92383..cec1cfd7edb7 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -158,7 +158,8 @@ static int add_single_ctl_with_resume(struct usb_mixer_interface *mixer,
 		return -ENOMEM;
 	}
 	kctl->private_free = snd_usb_mixer_elem_free;
-	return snd_usb_mixer_add_control(list, kctl);
+	/* don't use snd_usb_mixer_add_control() here, this is a special list element */
+	return snd_usb_mixer_add_list(list, kctl, false);
 }
 
 /*

