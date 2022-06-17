Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FD754FF2F
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 23:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245608AbiFQVLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 17:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbiFQVLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 17:11:19 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B163C6B
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 14:11:18 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id z9so2867769wmf.3
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 14:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s5R4dLx0zTRzfKtEc/EKgarYNUnjBGlLpOI4VpmW3/Q=;
        b=ikdPt/aodxNKrWPGYniaNwAKgkEBJ77U0AlBSWVRpobF37BQ+UeH+jrNndapO0faY1
         zvINVsoAGhiegkg7rNhb4BYH97obokmjWz9ULFVLmVMfeBgX1RW5HEw+Vnkl6vbTglhu
         0sQ43c+DEJF9n1aPPfMWYoYnbmXzz2a2gTFYHkAHZSO5N4cy7Dmv15PQJFBVARzYBbsf
         Lxj2rl1sEjLMhEx3LUr8gbGH/7JldFSlpwyrYbJjfKlFfz5WLxNrjCODym3LFb6v71eK
         5WjqWVMpYFvJyAlgBN5fOLkdtIFjSXNi3+vabJiU4Q8LTfKyBCjkY7D0cAAOMgqULFKl
         hrfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s5R4dLx0zTRzfKtEc/EKgarYNUnjBGlLpOI4VpmW3/Q=;
        b=0bx0s/a2lYsKsKET6L00Qu4QXn0OsxIMmMq58AJ2eYL9g8Xyc/Bh1vCQUmLWT59bxo
         eAoXUDalZuR88UC+6nHNN2ZUZcZE6AoeudTV3Jemfgtm1f6xCLTIV3VImX45kwA3grV9
         29pnldJyfnQI1RrI0da8H3GsoDfI1uTX38AkicRI4nDbvDPriItFdOIU3Qp2tfAaITyL
         wPZsBLd5sdGGe8A768cGnr3c+3YkgT6gfMdrL7z6iMUPfTJlo6lCja/UeDw86uHqgXUD
         3xJi4GwdgHngglMXi2ksXz/ncEmlIcaFlWPuInCPRFX2Zo+XhcgQMMco7YpOwn6tSByI
         32CQ==
X-Gm-Message-State: AJIora92aJlK3Kq3YDbzhOaC4PF5or15Wjg0iPnO6K1YSKVcZ1rigjxq
        CsVNkZIQAP4w33arrkfAncg=
X-Google-Smtp-Source: AGRyM1vLlFMeCpKTs+TJDO0y3hkWnLHXc9HL9gAxsD/pe45sFYDZ65PORtv9BgpdEUKiNYG6LSm9/A==
X-Received: by 2002:a7b:c758:0:b0:39c:44ce:f00f with SMTP id w24-20020a7bc758000000b0039c44cef00fmr11883173wmk.167.1655500277043;
        Fri, 17 Jun 2022 14:11:17 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id e18-20020adfe7d2000000b00219f9829b71sm5551715wrn.56.2022.06.17.14.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 14:11:16 -0700 (PDT)
Date:   Fri, 17 Jun 2022 22:11:14 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     andy.chi@canonical.com, stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/realtek: fix right sounds and
 mute/micmute LEDs for" failed to apply to 5.4-stable tree
Message-ID: <Yqzt8pYoRsesFB8o@debian>
References: <1652970571161147@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pnFGr+TN7heEyPOM"
Content-Disposition: inline
In-Reply-To: <1652970571161147@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pnFGr+TN7heEyPOM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Thu, May 19, 2022 at 04:29:31PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport which will also need e7d66cf79939 ("ALSA: hda/realtek:
fix mute/micmute LEDs for HP 440 G8").


--
Regards
Sudip

--pnFGr+TN7heEyPOM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-ALSA-hda-realtek-fix-mute-micmute-LEDs-for-HP-440-G8.patch"

From b5a4382b115f47232c2e7f996db1b2d8113a2ffa Mon Sep 17 00:00:00 2001
From: Jeremy Szu <jeremy.szu@canonical.com>
Date: Tue, 16 Mar 2021 15:46:24 +0800
Subject: [PATCH 1/2] ALSA: hda/realtek: fix mute/micmute LEDs for HP 440 G8

commit e7d66cf799390166e90f9a5715f2eede4fe06d51 upstream.

The HP EliteBook 840 G8 Notebook PC is using ALC236 codec which is
using 0x02 to control mute LED and 0x01 to control micmute LED.
Therefore, add a quirk to make it works.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210316074626.79895-1-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 sound/pci/hda/patch_realtek.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8a221866ab01b..bd32da5c5fec4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4292,6 +4292,12 @@ static void alc_fixup_hp_gpio_led(struct hda_codec *codec,
 	}
 }
 
+static void alc236_fixup_hp_gpio_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	alc_fixup_hp_gpio_led(codec, action, 0x02, 0x01);
+}
+
 static void alc269_fixup_hp_gpio_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -6465,6 +6471,7 @@ enum {
 	ALC294_FIXUP_ASUS_GU502_VERBS,
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
+	ALC236_FIXUP_HP_GPIO_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
 	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 	ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
@@ -7741,6 +7748,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_mute_led,
 	},
+	[ALC236_FIXUP_HP_GPIO_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc236_fixup_hp_gpio_led,
+	},
 	[ALC236_FIXUP_HP_MUTE_LED] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc236_fixup_hp_mute_led,
@@ -8162,6 +8173,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.30.2


--pnFGr+TN7heEyPOM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-ALSA-hda-realtek-fix-right-sounds-and-mute-micmute-L.patch"

From 7aadd367b5b51fb445b450bf1efb5b970de20434 Mon Sep 17 00:00:00 2001
From: Andy Chi <andy.chi@canonical.com>
Date: Fri, 13 May 2022 20:16:45 +0800
Subject: [PATCH 2/2] ALSA: hda/realtek: fix right sounds and mute/micmute LEDs
 for HP machine

commit 024a7ad9eb4df626ca8c77fef4f67fd0ebd559d2 upstream.

The HP EliteBook 630 is using ALC236 codec which used 0x02 to control mute LED
and 0x01 to control micmute LED. Therefore, add a quirk to make it works.

Signed-off-by: Andy Chi <andy.chi@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220513121648.28584-1-andy.chi@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index bd32da5c5fec4..128313a1ae13f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8174,6 +8174,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.30.2


--pnFGr+TN7heEyPOM--
