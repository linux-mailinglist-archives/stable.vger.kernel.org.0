Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139433EDBD9
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhHPQ5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 12:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhHPQ5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 12:57:39 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D03C0613C1;
        Mon, 16 Aug 2021 09:57:07 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso33460478pjb.2;
        Mon, 16 Aug 2021 09:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=hZVwvco17xJQW8JuzB/Vd+7RglaFyjm9hY3oZ9ogtbc=;
        b=B+ISxVf2tKmzTbG77fe9qHZXwf+NyiwzderZmBtHiDhCGlgO42KJGkNqnVLxKcWLvw
         93A9djoJSZCEOAP9QQxDfMNkdRWJ3D3GB2n0GJhtYF8izRHHQaDEvHu0azF8E9kI9JAQ
         qHcpWnq6TjGKat4q52u0iP5Y8w9tMxMAsMTcyqv71R4g00H22hM969Am1ROJGTSTS2lG
         KnxFH5u35ofCHlZhm1du09C/CfmYzyoT88Jw0t5rF+AQIkRCx81FrTHM/17NM70oV3xR
         me/zhydDoJ85nlQfQH9h+l2XTYnyRdLYJY2AKWF1ws+FF+ckDywR0uiSeO+FbBTht7uj
         I3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hZVwvco17xJQW8JuzB/Vd+7RglaFyjm9hY3oZ9ogtbc=;
        b=rXSfq+NORi0VGNlDFVhHjq5JW4Q69tHZih+xaQqcW8JagpCcZZM7O8Cwrph4il0szi
         9450J7vjfWzt5D5mawDuChUy9c8ViYOYMZsX0ec0kVujQIkyFizMyTauluzda4DwBxKb
         OO38ln0blehqEkoO3qjF+ZoRuRqI5Co32+Og44mgik3ZtCCpyt6+cvAjVAoeRZEYoLxZ
         xWE9PYN2NKGHVoHAO0X1G/cVOAD3IZkfx9TKLpz1XVF6sxT1ygbk12YLP9xYNY071J9F
         CO4ocKc/JWJ1VNvJ5BHKDoHB1kPpDvOkNnZIsURAibUbXzpDXpX4Nk5rj1c0Z7Z/HeTS
         O+Xg==
X-Gm-Message-State: AOAM530teJPstlY6rounurOh15WIrg49OuHsu2XPcGEuuUpOaMWGi0tZ
        6xKdx5k9s/0IRvHXRx/MFfs=
X-Google-Smtp-Source: ABdhPJy7arED7cIXm+rQ0s1P6Aq+JwCyVr8obt7+l7wa44V3KJxVuB/gYExwyyHGR71G/txvvWKa/A==
X-Received: by 2002:a65:4001:: with SMTP id f1mr10594018pgp.209.1629133027322;
        Mon, 16 Aug 2021 09:57:07 -0700 (PDT)
Received: from [192.168.1.92] ([106.104.151.171])
        by smtp.gmail.com with ESMTPSA id z16sm13290338pgu.21.2021.08.16.09.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:57:06 -0700 (PDT)
Message-ID: <54f729b54ffa6226a97c9eac897d5f08f6636e31.camel@gmail.com>
Subject: Re: [REGRESSION] "ALSA: HDA: Early Forbid of runtime PM" broke my
 laptop's internal audio
From:   =?Big5?Q?=C2=C5=AE=BC=DE=B3?= <lantw44@gmail.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, harshapriya.n@intel.com,
        kai.vehmanen@intel.com, linux-kernel@vger.kernel.org,
        mcatanzaro@redhat.com, perex@perex.cz, stable@vger.kernel.org,
        tiwai@suse.com
Date:   Tue, 17 Aug 2021 00:57:03 +0800
In-Reply-To: <s5hy293gj3j.wl-tiwai@suse.de>
References: <s5h7dnvlgg8.wl-tiwai@suse.de>
         <ac2232f142efcd67fe6ac38897f704f7176bd200.camel@gmail.com>
         <s5hy293gj3j.wl-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.41.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

於 星期日，2021-08-15 於 11:20 +0200，Takashi Iwai 提到：
> On Sat, 14 Aug 2021 16:02:36 +0200,
> 藍挺瑋 wrote:
> > 
> > I am not sure if I should join this old thread, but it seems that I saw the
> > same
> > issue on my ASUS B23E laptop. It couldn't produce any sound after upgrading
> > to
> > Linux 5.10, and 'git bisect' shows it was broken by the same commit
> > a0645daf16101bb9a6d87598c17e9a8b7bd60ea7.
> > 
> > I have tested the latest master branch (v5.14-rc4-322-gcceb634774ef) last
> > week.
> > It still had no sound. If I reverted the broken commit, sound worked.
> 
> > 
> > alsa-info from the broken kernel:
> > https://gist.github.com/lantw44/0660e059c488e3ff3d841bb03b371866
> > 
> > alsa-info from the working kernel:
> > https://gist.github.com/lantw44/9367f425e4f5ba98cf12343cb90f3301
> 
> Thanks for the report.  A quick workaround be a patch like below.
> Could you verify whether it fixes the problem?

Yes, it fixes the problem.

> 
> 
> Takashi
> 
> --- a/sound/pci/hda/patch_via.c
> +++ b/sound/pci/hda/patch_via.c
> @@ -1041,6 +1041,7 @@ static const struct hda_fixup via_fixups[] = {
>  };
>  
>  static const struct snd_pci_quirk vt2002p_fixups[] = {
> +       SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
>         SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
>         SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
>         SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),

