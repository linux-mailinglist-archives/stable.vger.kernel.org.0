Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD4665C301
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbjACPb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237922AbjACPbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:31:51 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18DB1055B
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 07:31:49 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id h185so4835625oif.5
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 07:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lTt2HVuMFa2TLmTHW8vOAw3rFh8HzfGuBaR9NVmmAtM=;
        b=Fc6VGYbiL286Tp2aTPQ1Y4uy6LqcwL0sIPrVQvzVTfOG7G1huEiiKzAg3cTJAoyCPm
         fCHjO88ck0ApBg592ZP+eHdcqwWR1OLNOIfCwUu8pyOmz9Kp1H+vzmG20/Itr/jlq7sx
         yZHIYIREV1AoTOLSMt+owH2v8OetsWHuLKcOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lTt2HVuMFa2TLmTHW8vOAw3rFh8HzfGuBaR9NVmmAtM=;
        b=oSoXrUlomZXC11qY93OjpZ2gT2nrThC7CF7zcww5IMb+QkOGKCgpM8/xppAcGyD7/D
         X48GcX4jYqJ0nxwqD1cYsYmo1RswwcoNv+aWFNc4SzVbShCs0lxoWUp0rLEMFtpMCQmx
         JMoY5By8NSJ7EztMdWUT5t7fJw8pmgTlhqEdFVOMCY+2OC4oMy3FFFD3x6fTxW0MKYfb
         rODM+fVSuRlVZfdBwUQZG1N8O7ob0sLxdNe8olOVQ0irlsQFE8o8HfISsYvsU4raZI1u
         Fz2oEmQfWxJhpDEjW/gFWaR0hToW8MCNX5TQnnWMywcepAEpaIyKFbfFWz5UXqjzLWUc
         ZYdw==
X-Gm-Message-State: AFqh2krzfdaIZs2ggEhLBA5SPQ5R+2UxW9yhoWoRlFjbJON9DSKve2Ee
        UDekc3CfBtfLU4T8TSL+nhDGIPgJz929AueuIt+rag==
X-Google-Smtp-Source: AMrXdXugs7NnramkR5sSAo5zuOcfLDjrPK+0AmLNkuGRdZrUMmNgwV8uOgj669JUpvxLzg9XHbXkAGPI1+/F9sE2mMA=
X-Received: by 2002:a05:6808:609:b0:35c:dee:db96 with SMTP id
 y9-20020a056808060900b0035c0deedb96mr3117471oih.235.1672759909221; Tue, 03
 Jan 2023 07:31:49 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
 <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info> <87zgb0q7x4.wl-tiwai@suse.de>
 <CAC2975K24Gt3rGieAToHjb7FEHv84aqiRSQx7EOuR2Q7KByUXw@mail.gmail.com>
 <87sfgrrb5f.wl-tiwai@suse.de> <CAC2975+cUqiFC0LO-D-fi0swH+x=_FMuG+==mhg6HH4pc_YDRA@mail.gmail.com>
 <87bknfr6rd.wl-tiwai@suse.de> <CAC2975+CP0WKmXouX_8TffT1+VpU3EuOzyGHMv+VsAOBjCyhnA@mail.gmail.com>
 <878rijr6dz.wl-tiwai@suse.de>
In-Reply-To: <878rijr6dz.wl-tiwai@suse.de>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Wed, 4 Jan 2023 02:31:13 +1100
Message-ID: <CAC2975+Ybz2-jyJAwAUEu5S1XKfp0B-p4s-gAsMPfZdD61uNfQ@mail.gmail.com>
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

On Wed, 4 Jan 2023 at 02:21, Takashi Iwai <tiwai@suse.de> wrote:
>
> Hrm...  Try to reload snd_usb_audio module with the dyndbg=+p option,
> e.g.
>
>   # modprobe -r snd-usb-audio
>   # modprobe snd_usb_audio dyndbg=+p
>
> Or you can try to put your own debug printk(); we need to make sure
> whether it's really the right code you're testing at first.
>

Ok, it looks like it was ignoring the kernel command line for some
reason. modprobing it with the option brought up debug messages again.

I'm still running kernel 6.1.2 vanilla with the revert and the patches.

aplay hung again when I ran it, the kernel was stuck on:
Jan 04 02:25:59 leatherback kernel: usb 1-4: 1:1 Start Playback PCM

and didn't output another line until I ctrl+c aplay.

Jan 04 02:25:27 leatherback kernel: mc: Linux media interface: v0.10
Jan 04 02:25:27 leatherback kernel: usb 1-3: Found last interface = 1
Jan 04 02:25:27 leatherback kernel: usb 1-4: Set quirk_flags 0x20010
for device 1397:0509
Jan 04 02:25:27 leatherback kernel: usb 1-4: Found last interface = 4
Jan 04 02:25:27 leatherback kernel: usb 1-4: 1:1: added playback
implicit_fb sync_ep 88, iface 2:1
Jan 04 02:25:27 leatherback kernel: usb 1-4: 1:1: add audio endpoint 0x8
Jan 04 02:25:27 leatherback kernel: usb 1-4: Creating new data endpoint #8
Jan 04 02:25:27 leatherback kernel: usb 1-4: Creating new data endpoint #88
Jan 04 02:25:27 leatherback kernel: usb 1-4: 2:1: add audio endpoint 0x88
Jan 04 02:25:27 leatherback kernel: usb 1-4: [10] FU [PCM Playback
Switch] ch = 4, val = 0/1/1
Jan 04 02:25:27 leatherback kernel: usb 1-4: [10] FU [PCM Playback
Switch] ch = 1, val = 0/1/1
Jan 04 02:25:27 leatherback kernel: usb 1-4: [10] FU [PCM Playback
Volume] ch = 4, val = -32512/0/256
Jan 04 02:25:27 leatherback kernel: usb 1-4: [10] FU [PCM Playback
Volume] ch = 1, val = -32512/0/256
Jan 04 02:25:27 leatherback kernel: usb 1-4: [11] FU [Mic Capture
Switch] ch = 4, val = 0/1/1
Jan 04 02:25:27 leatherback kernel: usb 1-4: [11] FU [Mic Capture
Switch] ch = 1, val = 0/1/1
Jan 04 02:25:27 leatherback kernel: usb 1-4: [11] FU [Mic Capture
Volume] ch = 4, val = -32512/0/256
Jan 04 02:25:27 leatherback kernel: usb 1-4: [11] FU [Mic Capture
Volume] ch = 1, val = -32512/0/256
Jan 04 02:25:27 leatherback kernel: usbcore: registered new interface
driver snd-usb-audio
Jan 04 02:25:59 leatherback kernel: usb 1-4: Open EP 0x8, iface=1:1, idx=0
Jan 04 02:25:59 leatherback kernel: usb 1-4:   channels=4, rate=48000,
format=S32_LE, period_bytes=96000, periods=4, implicit_fb=1
Jan 04 02:25:59 leatherback kernel: usb 1-4: Open EP 0x88, iface=2:1, idx=0
Jan 04 02:25:59 leatherback kernel: usb 1-4:   channels=4, rate=48000,
format=S32_LE, period_bytes=96000, periods=4, implicit_fb=0
Jan 04 02:25:59 leatherback kernel: usb 1-4: Setting params for data
EP 0x88, pipe 0x40580
Jan 04 02:25:59 leatherback kernel: usb 1-4: Set up 12 URBS, ret=0
Jan 04 02:25:59 leatherback kernel: usb 1-4: Setting params for data
EP 0x8, pipe 0x40500
Jan 04 02:25:59 leatherback kernel: usb 1-4: Set up 12 URBS, ret=0
Jan 04 02:25:59 leatherback kernel: usb 1-4: Setting usb interface 2:0
for EP 0x88
Jan 04 02:25:59 leatherback kernel: usb 1-4: 2:1 Set sample rate 48000, clock 40
Jan 04 02:25:59 leatherback kernel: usb 1-4: Setting usb interface 2:1
for EP 0x88
Jan 04 02:25:59 leatherback kernel: usb 1-4: Setting usb interface 1:0
for EP 0x8
Jan 04 02:25:59 leatherback kernel: usb 1-4: Setting usb interface 1:1
for EP 0x8
Jan 04 02:25:59 leatherback kernel: usb 1-4: Starting data EP 0x8 (running 0)
Jan 04 02:25:59 leatherback kernel: usb 1-4: 12 URBs submitted for EP 0x8
Jan 04 02:25:59 leatherback kernel: usb 1-4: Starting data EP 0x88 (running 0)
Jan 04 02:25:59 leatherback kernel: usb 1-4: 12 URBs submitted for EP 0x88
Jan 04 02:25:59 leatherback kernel: usb 1-4: 1:1 Start Playback PCM
Jan 04 02:26:20 leatherback kernel: usb 1-4: Stopping data EP 0x88 (running 1)
Jan 04 02:26:20 leatherback kernel: usb 1-4: Stopping data EP 0x8 (running 1)
Jan 04 02:26:20 leatherback kernel: usb 1-4: 1:1 Stop Playback PCM
Jan 04 02:26:20 leatherback kernel: usb 1-4: Closing EP 0x8 (count 1)
Jan 04 02:26:20 leatherback kernel: usb 1-4: Setting usb interface 1:0
for EP 0x8
Jan 04 02:26:20 leatherback kernel: usb 1-4: EP 0x8 closed
Jan 04 02:26:20 leatherback kernel: usb 1-4: Closing EP 0x88 (count 1)
Jan 04 02:26:20 leatherback kernel: usb 1-4: Setting usb interface 2:0
for EP 0x88
Jan 04 02:26:20 leatherback kernel: usb 1-4: EP 0x88 closed
