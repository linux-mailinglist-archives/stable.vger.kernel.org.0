Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF954FF1C
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 23:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiFQVGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 17:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbiFQVGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 17:06:22 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F305E152
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 14:06:20 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m39-20020a05600c3b2700b0039c511ebbacso4907643wms.3
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 14:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mmlbcYP/9LG71zia9W3NKeAu3bqJii8tfQz/YlUpZ8I=;
        b=S6HSNRqyeJnFCNYJEMXDEtnRLrmgm/SDH9DNyGxpH57Z6oCq5jEJxyP9YhTtYtmieF
         9jcOUmMq62aLPlPetZ/gklHVZja7ajTwS8u368jSmsUHFp9SmjyWgbLj4fTLZHaKIN+a
         MIsmCHAww8o3UywxSglML62jSNcD+BFLXS52mHcGvhaURKbkmXAeLah3NL61aU5XGvyT
         R8iwI37EK0AF8hk4um73JaYqTe3FL/wZu7FDz1q7EiUfY/D7LXvl/hxS7IhY8KS7csGV
         qEaIGJXr0MuOtb3XDEXEs5BFrC1KPEiv2XmX11Bm1OkjO2wmGguK5dJ2ba0inl/Sx34d
         Wv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mmlbcYP/9LG71zia9W3NKeAu3bqJii8tfQz/YlUpZ8I=;
        b=21YRJs4NgBZoZKb4GIy4lGMHwnaU13aksGQ5YT/+q5eUtyyY/9ti7dzyd7F/s1Jh5F
         uIyj1RfD6mH2dOGuv107l01mw85N5xe+Pd5wdt1TK8LDAtHvmstZXWuMrvMDm1eSM98R
         D5yStTfNwvcxdJgaN32DBXRT95Fc3KsmyLpay55ommK6OamYC/7xLF2RUX31TcMtb9E1
         kNSRx9oDLBg/7GjmIFTVyxj7bkM1+x+/kI4YElnWayhm629hs9vBrD9zzNh3ff70ajl+
         pEMPSIf8/VsdZ1okQoEML+2Bb+8pOYa7YCwf+YOaDZpP7p/Vqt1ju9oo1/k64x47BnZa
         nKYw==
X-Gm-Message-State: AOAM532SAVa8hmh0mQrpM2X/bpneT7FvXG4hn+4HKKOGqHABCpDZJK/x
        +9k1Mg18iMiYaWtS7sL5Q38=
X-Google-Smtp-Source: ABdhPJxL72uuqeuHvHwoNsmF7ZKQXgUwfOQ4E8bNwj1gX9IiedIuz4PjcrtculyPkT6a2ZvZli0GMQ==
X-Received: by 2002:a05:600c:4e88:b0:39c:7c53:d7ff with SMTP id f8-20020a05600c4e8800b0039c7c53d7ffmr23500536wmq.176.1655499978947;
        Fri, 17 Jun 2022 14:06:18 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id t19-20020a05600c129300b0039c8a22554bsm7032231wmd.27.2022.06.17.14.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 14:06:18 -0700 (PDT)
Date:   Fri, 17 Jun 2022 22:06:16 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     andy.chi@canonical.com, stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/realtek: fix right sounds and
 mute/micmute LEDs for" failed to apply to 5.10-stable tree
Message-ID: <YqzsyBPmXIPqRJn0@debian>
References: <1652970570224114@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bqzZKfu5yVw9+OFg"
Content-Disposition: inline
In-Reply-To: <1652970570224114@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bqzZKfu5yVw9+OFg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Thu, May 19, 2022 at 04:29:30PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.


--
Regards
Sudip

--bqzZKfu5yVw9+OFg
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-ALSA-hda-realtek-fix-right-sounds-and-mute-micmute-L.patch"

From 17e1db9020e8f7d04870a3ec195c8d45eeab5bfe Mon Sep 17 00:00:00 2001
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
index cf3b1133b7850..721b73137b3c0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8781,6 +8781,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x888d, "HP ZBook Power 15.6 inch G8 Mobile Workstation PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.30.2


--bqzZKfu5yVw9+OFg--
