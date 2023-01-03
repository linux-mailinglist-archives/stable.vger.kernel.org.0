Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2929465C2D3
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjACPPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbjACPPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:15:34 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5001101D6
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 07:15:33 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-14455716674so37053609fac.7
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 07:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6mpKJos/FPMtqgzKryfkykw/TumKk6Lc1MADv4VNDaw=;
        b=JpRf7WA8CR1VvL1u9d7F0pRpDV7B/2mtiBVwj/uQ0vvHj51xLPBBHZbcmZ4FhLc53e
         7MTRjmhjlpBEDDMygvniKGDlSK7EAeThLiVnzoHmLMiFBvVDG35zBj1ZPNrInrrEJEd4
         aUv8/wdm1CjSSywI58kB+2yx49Vsuc4aIPo2w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6mpKJos/FPMtqgzKryfkykw/TumKk6Lc1MADv4VNDaw=;
        b=e1YqlU8fR2mD7kb9ON44nDgPHZW+vbDLiBGz1Bmgth3mvdcVweCt9YQRizPMOUsRjU
         ZW8k6Qc+1HwWVPC/KkZdqDn9ai8tGNoXO7LUMtWSX2Hy61790zh7JBfGsboa55Ntp13a
         ddi6l03S9sn+efN9N+CxVioyHWSD6Asr/xgeFM3YRvur3FiYomFOpzyogfvzfOThcfGC
         PZsspPf0h3fOSN/daqTg700vc2/OkRM9YYVo6wpL4ZSMgK49vspplTTrYw+BpgvtLiH9
         pmQ3IGrp1mKAUj9i946GnhwMenVOxRiKcfcpo1xFNfjMssGqmyu90J+RX/KuNw5n4Udj
         HUmg==
X-Gm-Message-State: AFqh2kqo6TWLZjzLx8jV8ruumbIhUOCOXGAlnq177St+Lq6HkKj9Y7Yw
        7QGu9QWdOlvPqTllfGl6U/Sgdkua+Bvicsr4b9GkwA==
X-Google-Smtp-Source: AMrXdXv3dQDnfdNBNw+MQp56Vjvne/Kn7e1ltujbhspbCMkGntbNdh9QTHMnc3OVzHwx4LzFX2C+gndhklK2kW3cefI=
X-Received: by 2002:a05:687c:189:b0:14f:a2ed:988f with SMTP id
 yo9-20020a05687c018900b0014fa2ed988fmr2110159oab.220.1672758933004; Tue, 03
 Jan 2023 07:15:33 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
 <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info> <87zgb0q7x4.wl-tiwai@suse.de>
 <CAC2975K24Gt3rGieAToHjb7FEHv84aqiRSQx7EOuR2Q7KByUXw@mail.gmail.com>
 <87sfgrrb5f.wl-tiwai@suse.de> <CAC2975+cUqiFC0LO-D-fi0swH+x=_FMuG+==mhg6HH4pc_YDRA@mail.gmail.com>
 <87bknfr6rd.wl-tiwai@suse.de>
In-Reply-To: <87bknfr6rd.wl-tiwai@suse.de>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Wed, 4 Jan 2023 02:14:57 +1100
Message-ID: <CAC2975+CP0WKmXouX_8TffT1+VpU3EuOzyGHMv+VsAOBjCyhnA@mail.gmail.com>
Subject: Re: USB-Audio regression on behringer UMC404HD
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        alsa-devel@alsa-project.org, regressions@lists.linux.dev,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Jan 2023 at 02:13, Takashi Iwai <tiwai@suse.de> wrote:
>
> That's weird.  Is snd_usb_audio driver bound with the device at all?
> That is, does it appear in /proc/asound/cards?
>

Yes, it's there.

0 [V49            ]: USB-Audio - V49
                     Alesis V49 at usb-0000:08:00.1-3, full speed
1 [NVidia         ]: HDA-Intel - HDA NVidia
                     HDA NVidia at 0xfc080000 irq 154
2 [U192k          ]: USB-Audio - UMC404HD 192k
                     BEHRINGER UMC404HD 192k at usb-0000:08:00.1-4, high speed
3 [Generic        ]: HDA-Intel - HD-Audio Generic
                     HD-Audio Generic at 0xfca00000 irq 156

--
Michael
