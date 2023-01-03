Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B5765C6FB
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 20:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjACTJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 14:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjACTJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 14:09:55 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79E213F0D
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 11:09:53 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id p17-20020a9d6951000000b00678306ceb94so19620255oto.5
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 11:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C08OceEXw18iUGGiRS1+CrnOaGSBY8Ykajf+8A9hXvc=;
        b=kYD3G6UzTOkhCT7szVoyh5/v+2TIehuj/B8XGShsIbzhGPau8MXrHebfzJpslSxwdE
         aCuer2gXgiyk6lIm3Vp9fh0cu5rxdFdujtRUixA2gOwi3HRrWroXjpcLJX7D8lJs5JJW
         OlWxKzEEvl04KM62QncHE+dl2oYp6ZB46V9NU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C08OceEXw18iUGGiRS1+CrnOaGSBY8Ykajf+8A9hXvc=;
        b=B1L46OIWq6stfIDvBm1pu9xqcYrKsBnpT85/NTNMeaBsZLrPcFxy9F+wom92Airi4v
         y3qRAgiMwJ7CGgOhJrygsmDWyLKc59V5ANgNX1npamCCbEOh8TEIghmDIggVJDhuSqhd
         VdpktJzchLWt+EEzZIKz+fEjgegSl4meTQw9DPK8HE7ED+bvzbYJR0f4UTuL+Jwxb+Dy
         /WzXLxg690YNFVdtbKHRWViuThTt2KqhFUuT0EIqmAnVCro46Gc6PWPHNQ3QAQyZY4Zh
         JlSj+TDxrse1ZCqFTJuzc1AyrjXQr/8YHSHq2Lxxsizcbzsj7z4nWGyvGjresdrUZdAU
         BBuQ==
X-Gm-Message-State: AFqh2kpFVW7jcy+YAI0JZxc+KcYqEh3mmN9X+RiOTis0riZepLbv5lAF
        EEUX3gMHMwJAnV9Jo9x68POTbVgvA2BCAGUcanjtag==
X-Google-Smtp-Source: AMrXdXthw5dKhojJxrUcr3e0JejicQ9XapnRXcqB2mBfdyuH37vcqnRI/Qf2oo1aqqCbWTWVxwFKdNXKtxVzvdNCU7g=
X-Received: by 2002:a05:6830:3747:b0:66a:8bca:86d9 with SMTP id
 bm7-20020a056830374700b0066a8bca86d9mr2572880otb.358.1672772992979; Tue, 03
 Jan 2023 11:09:52 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
 <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info> <87zgb0q7x4.wl-tiwai@suse.de>
 <CAC2975K24Gt3rGieAToHjb7FEHv84aqiRSQx7EOuR2Q7KByUXw@mail.gmail.com>
 <87sfgrrb5f.wl-tiwai@suse.de> <CAC2975+cUqiFC0LO-D-fi0swH+x=_FMuG+==mhg6HH4pc_YDRA@mail.gmail.com>
 <87bknfr6rd.wl-tiwai@suse.de> <CAC2975+CP0WKmXouX_8TffT1+VpU3EuOzyGHMv+VsAOBjCyhnA@mail.gmail.com>
 <878rijr6dz.wl-tiwai@suse.de> <CAC2975+Ybz2-jyJAwAUEu5S1XKfp0B-p4s-gAsMPfZdD61uNfQ@mail.gmail.com>
 <87zgazppuc.wl-tiwai@suse.de>
In-Reply-To: <87zgazppuc.wl-tiwai@suse.de>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Wed, 4 Jan 2023 06:09:16 +1100
Message-ID: <CAC2975+476CHDL3YM=uExHu96UB2rodAng9PVYHX+vGnSCppGA@mail.gmail.com>
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

On Wed, 4 Jan 2023 at 03:03, Takashi Iwai <tiwai@suse.de> wrote:
>
> OK, thanks.  Then it's not about the USB interface reset.
> It must be subtle and nasty difference.
>
> Could you apply the change below on the top?
> It essentially reverts the hw_params/prepare split again.
>

Very sorry to say this still hasn't fixed the problem :(

Jan 04 06:05:12 leatherback kernel: mc: Linux media interface: v0.10
Jan 04 06:05:12 leatherback kernel: usb 1-3: Found last interface = 1
Jan 04 06:05:12 leatherback kernel: usb 1-4: Set quirk_flags 0x20010
for device 1397:0509
Jan 04 06:05:12 leatherback kernel: usb 1-4: Found last interface = 4
Jan 04 06:05:12 leatherback kernel: usb 1-4: 1:1: added playback
implicit_fb sync_ep 88, iface 2:1
Jan 04 06:05:12 leatherback kernel: usb 1-4: 1:1: add audio endpoint 0x8
Jan 04 06:05:12 leatherback kernel: usb 1-4: Creating new data endpoint #8
Jan 04 06:05:12 leatherback kernel: usb 1-4: Creating new data endpoint #88
Jan 04 06:05:12 leatherback kernel: usb 1-4: 2:1: add audio endpoint 0x88
Jan 04 06:05:12 leatherback kernel: usb 1-4: [10] FU [PCM Playback
Switch] ch = 4, val = 0/1/1
Jan 04 06:05:12 leatherback kernel: usb 1-4: [10] FU [PCM Playback
Switch] ch = 1, val = 0/1/1
Jan 04 06:05:12 leatherback kernel: usb 1-4: [10] FU [PCM Playback
Volume] ch = 4, val = -32512/0/256
Jan 04 06:05:12 leatherback kernel: usb 1-4: [10] FU [PCM Playback
Volume] ch = 1, val = -32512/0/256
Jan 04 06:05:12 leatherback kernel: usb 1-4: [11] FU [Mic Capture
Switch] ch = 4, val = 0/1/1
Jan 04 06:05:12 leatherback kernel: usb 1-4: [11] FU [Mic Capture
Switch] ch = 1, val = 0/1/1
Jan 04 06:05:12 leatherback kernel: usb 1-4: [11] FU [Mic Capture
Volume] ch = 4, val = -32512/0/256
Jan 04 06:05:12 leatherback kernel: usb 1-4: [11] FU [Mic Capture
Volume] ch = 1, val = -32512/0/256
Jan 04 06:05:12 leatherback kernel: usbcore: registered new interface
driver snd-usb-audio
Jan 04 06:06:07 leatherback kernel: usb 1-4: Open EP 0x8, iface=1:1, idx=0
Jan 04 06:06:07 leatherback kernel: usb 1-4:   channels=4, rate=48000,
format=S32_LE, period_bytes=96000, periods=4, implicit_fb=1
Jan 04 06:06:07 leatherback kernel: usb 1-4: Open EP 0x88, iface=2:1, idx=0
Jan 04 06:06:07 leatherback kernel: usb 1-4:   channels=4, rate=48000,
format=S32_LE, period_bytes=96000, periods=4, implicit_fb=0
Jan 04 06:06:07 leatherback kernel: usb 1-4: Setting params for data
EP 0x88, pipe 0x40580
Jan 04 06:06:07 leatherback kernel: usb 1-4: Set up 12 URBS, ret=0
Jan 04 06:06:07 leatherback kernel: usb 1-4: Setting params for data
EP 0x8, pipe 0x40500
Jan 04 06:06:07 leatherback kernel: usb 1-4: Set up 12 URBS, ret=0
Jan 04 06:06:07 leatherback kernel: usb 1-4: Setting usb interface 2:0
for EP 0x88
Jan 04 06:06:07 leatherback kernel: usb 1-4: 2:1 Set sample rate 48000, clock 40
Jan 04 06:06:07 leatherback kernel: usb 1-4: Setting usb interface 2:1
for EP 0x88
Jan 04 06:06:07 leatherback kernel: usb 1-4: Setting usb interface 1:0
for EP 0x8
Jan 04 06:06:07 leatherback kernel: usb 1-4: Setting usb interface 1:1
for EP 0x8
Jan 04 06:06:07 leatherback kernel: usb 1-4: Starting data EP 0x8 (running 0)
Jan 04 06:06:07 leatherback kernel: usb 1-4: 12 URBs submitted for EP 0x8
Jan 04 06:06:07 leatherback kernel: usb 1-4: Starting data EP 0x88 (running 0)
Jan 04 06:06:07 leatherback kernel: usb 1-4: 12 URBs submitted for EP 0x88
Jan 04 06:06:07 leatherback kernel: usb 1-4: 1:1 Start Playback PCM
Jan 04 06:06:30 leatherback kernel: usb 1-4: Stopping data EP 0x88 (running 1)
Jan 04 06:06:30 leatherback kernel: usb 1-4: Stopping data EP 0x8 (running 1)
Jan 04 06:06:30 leatherback kernel: usb 1-4: 1:1 Stop Playback PCM
Jan 04 06:06:30 leatherback kernel: usb 1-4: Closing EP 0x8 (count 1)
Jan 04 06:06:30 leatherback kernel: usb 1-4: Setting usb interface 1:0
for EP 0x8
Jan 04 06:06:30 leatherback kernel: usb 1-4: EP 0x8 closed
Jan 04 06:06:30 leatherback kernel: usb 1-4: Closing EP 0x88 (count 1)
Jan 04 06:06:30 leatherback kernel: usb 1-4: Setting usb interface 2:0
for EP 0x88
Jan 04 06:06:30 leatherback kernel: usb 1-4: EP 0x88 closed
