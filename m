Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9679354FF1A
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 23:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381517AbiFQVFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 17:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382313AbiFQVFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 17:05:11 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0483E5E152
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 14:05:10 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w17so7122800wrg.7
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 14:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oy7KluRBz9dpKVZdXRsf6/DXdpBfh0YbtZUGqozN2f0=;
        b=HP+eAOU6iof6hV5Fb1rvKh/utFDvNFQeYRcCTfpz5nL+X9jC6ir/a6cjSKlGY7s6ic
         0lqvmVYGQzDdYOG3/elbIO+fmztPI2/9/PMpLa01OQIVN9ZxzdcvjgB1bNVjN1MgJZKc
         v16UJ7k1zLXS8nOtc+GXlR7OmLXE3tTb3hQwi/9YNvDRklj5RF4J4NRj5cI0DItpm2+d
         mtu1n/C7TwTjsm+i3vauhLO3K614xzZ9Znc09A2GeBxbIlMalHpSJZNOI3es4YXmVYV6
         snfLkWJgG8WBc5SWqC0Zx5cBYP/YRrN6s8VxRTMapETBT1IqLmFBBz+zZPHe4fy1urxV
         Hr/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oy7KluRBz9dpKVZdXRsf6/DXdpBfh0YbtZUGqozN2f0=;
        b=w2eJrj3wjzgvvCUaRswhjm/LSl8p+ui2gKf7G4sWyfb7PsmoqsUKpof+LzTL6ozfB2
         MR5InHVZXiSDdVAxGSCvVeWarbvcsjqPd78Vy7/Q+Uzr024hd3hx66dS9B7LINlI775T
         1qN6ekI7T35wPCd0R3oRLhrWJ4wi8/ukOnsX3+PB7vsG3raWO8dUeRSoi+On2PAUmPDD
         ovHa2o2DGiKNeBPvrGNc/dvF2gLc+oQVcN2A+Zlrc5PL5qSubZsq1marVuWdVbOwbr1I
         vi2EcJcBHfSdsDzGrjGiKyeY7Mbp6ndZVqJPaRHbcKlG2ASNABiHkspMvS77CgumITMN
         pEtw==
X-Gm-Message-State: AJIora9rEshmxhAWzKZ4tp02Q13YstrSztA1vai2jpIrZG0rNSWXBpRJ
        Dxh6XsFHKmMnndCL0nPW69I=
X-Google-Smtp-Source: AGRyM1sE+50xHNFFNzUlY6BO7CroMrPzMVkwyWAq100/7pTKXDWTlaHUl9qT/9YxiEc8FjH9yEtQTg==
X-Received: by 2002:a05:6000:70e:b0:219:f67e:e4b with SMTP id bs14-20020a056000070e00b00219f67e0e4bmr10953972wrb.127.1655499908524;
        Fri, 17 Jun 2022 14:05:08 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id be8-20020a05600c1e8800b0039c235fb6a5sm6538420wmb.8.2022.06.17.14.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 14:05:07 -0700 (PDT)
Date:   Fri, 17 Jun 2022 22:05:06 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     andy.chi@canonical.com, stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/realtek: fix right sounds and
 mute/micmute LEDs for" failed to apply to 5.15-stable tree
Message-ID: <YqzsgnG5xtEela9L@debian>
References: <16529705705957@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/LTvVFK1YJJdncWK"
Content-Disposition: inline
In-Reply-To: <16529705705957@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/LTvVFK1YJJdncWK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Thu, May 19, 2022 at 04:29:30PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.


--
Regards
Sudip

--/LTvVFK1YJJdncWK
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-ALSA-hda-realtek-fix-right-sounds-and-mute-micmute-L.patch"

From 42d1758300ce8d08ed91cd135fafa71a5c8cf31f Mon Sep 17 00:00:00 2001
From: Andy Chi <andy.chi@canonical.com>
Date: Fri, 13 May 2022 20:16:45 +0800
Subject: [PATCH] ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for
 HP machine

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
index 0ff43964a9862..dedfb630b388e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8845,6 +8845,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89c3, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
-- 
2.30.2


--/LTvVFK1YJJdncWK--
