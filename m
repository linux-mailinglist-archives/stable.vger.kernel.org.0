Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FF065C2B3
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbjACPGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238070AbjACPF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:05:58 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000F610B51
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 07:05:55 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-12c8312131fso37049042fac.4
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 07:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ln3Hpxj04whwiUwy38KPHvXsJPvtlkVMO14jhU5Bin8=;
        b=jbszDPxzVNpLIap5ukIi81Ulb4x816IiBtHv+NmuSI5aUvrk96T7sfkGGtc/K08duO
         O6awQPQiJQsqvt8/R0i3rhF9kea9HKjVhk0LjVC1gjrdPL3+WcBsCSOAD2W8i/Rxjnu3
         YXVr13F+O3Fr8Lxtjcka7BtJz1eJuxgYCUOFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ln3Hpxj04whwiUwy38KPHvXsJPvtlkVMO14jhU5Bin8=;
        b=XXWOp/qzXX2N4KhG0nlfN6gyVLUQQhfa9Qq0LWxPa7jxBN0UGpqEsMrZP1iDFWAOlB
         Fr6t2febHsMCTjUmMNFWVJcC5RdnTRPWujruVolEd0Qd+vb4lHzd0L7VaOMGiAPmHdNr
         YNTKE0SyTJyUrs+kTYJdd65yi7NvNfecVlK/oDjdg5wRe/NTY/hdQWoz9gUNGXrV3mSR
         uB8XZ4LF7Og7kYOAbM///VIS1a2F/8gpSPvz2jLz4cc2yg9JERNHtiG1Bm3PhveiLQYU
         MKQu0dQr36xd+9WbOtdjP+Lxck5MpDjTNOIKuXvuXhysidQnG9H0MaWfzZwQ2YFGxpiR
         4QTA==
X-Gm-Message-State: AFqh2kqcljD8zcKA6YKXmYSXksUnvpVgy/yEh+vfOSR35xaoKUPijQpO
        DX99KmXfJzz5A8k5X4YdcEaLIM7cM4UBiA4330WSrg==
X-Google-Smtp-Source: AMrXdXs7QoifFER29bfCAsB0Fub0McfhgnzUfkpUj9BvtbBuATd0zwtbAYjNm79RajNWkejZ1HwbX8j3KBol1iYbJp4=
X-Received: by 2002:a05:687c:189:b0:14f:a2ed:988f with SMTP id
 yo9-20020a05687c018900b0014fa2ed988fmr2107981oab.220.1672758355026; Tue, 03
 Jan 2023 07:05:55 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
 <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info> <87zgb0q7x4.wl-tiwai@suse.de>
 <CAC2975K24Gt3rGieAToHjb7FEHv84aqiRSQx7EOuR2Q7KByUXw@mail.gmail.com> <87sfgrrb5f.wl-tiwai@suse.de>
In-Reply-To: <87sfgrrb5f.wl-tiwai@suse.de>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Wed, 4 Jan 2023 02:05:18 +1100
Message-ID: <CAC2975+cUqiFC0LO-D-fi0swH+x=_FMuG+==mhg6HH4pc_YDRA@mail.gmail.com>
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

On Wed, 4 Jan 2023 at 00:38, Takashi Iwai <tiwai@suse.de> wrote:
>
> Thanks; that's helpful.
>
> Could you try to revert the commit
> 9902b303b5ade208b58f0dd38a09831813582211
>     ALSA: usb-audio: Avoid unnecessary interface change at EP close
as a blind shot?
>
> Also, there has been a series of fixes for other issues, and it might
> be worth to try as well:
>   https://lore.kernel.org/r/20230102170759.29610-1-tiwai@suse.de
>

I built 3 kernels: one with the reverted commit, one with the patches
you linked, and one with both. These builds were based on 6.1.2.

None of them worked. Also, even though I continued to boot with
snd_usb_audio.dyndbg=+p, none of the kernel logs showed the debug
messages that the other versions did. I'm baffled why this is.

I did notice that the order that the detected sound devices appeared
in alsa was varying. That's probably not relevant though.

Links to logs:

Revert only
https://hastebin.com/avinasiruj.apache

New patches only
https://hastebin.com/aqepesokam.apache

Both
https://hastebin.com/igilaqujus.apache

--
Michael
