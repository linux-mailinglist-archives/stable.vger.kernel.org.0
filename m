Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9BB65C078
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 14:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjACNL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 08:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjACNLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 08:11:24 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC19FEE37
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 05:11:22 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id x44-20020a05683040ac00b006707c74330eso19038270ott.10
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 05:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZBT8QGBM4TylsNBdJUfJE0UpwiJkpbSc92XFfa/BZbw=;
        b=S5uXlrqZ1UTZOKh9S0VWa+TJrjnr1xX00qWX1oZ2G/Qso/AUeU2XdRV8CuzJBn19RQ
         S8PUpZYTfTpZjW5xlrzgJepE/CwPmjpgb7b0RI+6PMUX7MlYhNbOqun0jKHnfOBil9Si
         9YqCLTcZiCzldnSbMlV8u/x1yZ9kAq3vTh0OY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZBT8QGBM4TylsNBdJUfJE0UpwiJkpbSc92XFfa/BZbw=;
        b=dh+ZPr9lAunVRqD572TXVQql8ZD3nAYhXzmcXBuN/fz12lnTkkzI0asVkErxxZP6wh
         3EDS20dxFN8LgesCSXtaDULzRY0qrEWgu0Q90b6mzKj+u/NYUrncB1Z/nceCoLTcJSQr
         5rpIeeHhDxU4oZevk40GYWWi/vZD76iTF3nON65jkGY/k8DF3m/UtcN+f3nTa6SSL9Vo
         m8X/jNTj6EZCgdvoiTS0juBGFxIlMy4GLCnPu2UuTvBBf2FW2h8biZc3qsbjjXKYYvfO
         o2HG8I/smS/ScVQHqXvqvty3HL2orVUs6xwM4CdOZQMRubewt54qUJr6cnxLxEgjQL2c
         OwUw==
X-Gm-Message-State: AFqh2koXKZku7uaRkVWKN8s/dGrLhZbpnrvXlK/dspsTsw0cNi7daPJo
        gTFPT2R7b4t50zM5iBzxEsvhrfI0x2q0hzgt3ljxhg==
X-Google-Smtp-Source: AMrXdXvMiRhkPudrVcodk+MiSXC0+Q1QXxeRXc6jXFUYRSTGQ3XazpqjMW5uF+w3LzN5kMlewpTk+W0So2OurVCx894=
X-Received: by 2002:a05:6830:1c8:b0:66e:b992:749f with SMTP id
 r8-20020a05683001c800b0066eb992749fmr2372045ota.52.1672751482203; Tue, 03 Jan
 2023 05:11:22 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
 <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info> <87zgb0q7x4.wl-tiwai@suse.de>
In-Reply-To: <87zgb0q7x4.wl-tiwai@suse.de>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Wed, 4 Jan 2023 00:10:46 +1100
Message-ID: <CAC2975K24Gt3rGieAToHjb7FEHv84aqiRSQx7EOuR2Q7KByUXw@mail.gmail.com>
Subject: Re: USB-Audio regression on behringer UMC404HD
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        alsa-devel@alsa-project.org, regressions@lists.linux.dev,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Working, 6.0.16-lqx1
https://hastebin.com/omoqasiqek.apache

Not working, 6.1.1-arch1-1.1
https://hastebin.com/itasefinaz.apache

I built the working kernel myself with patched sources. Let me know if
you'd like me to run a test with any particular kernel build or
version.

--
Michael

On Tue, 3 Jan 2023 at 20:33, Takashi Iwai <tiwai@suse.de> wrote:
>
> On Tue, 03 Jan 2023 10:07:42 +0100,
> Thorsten Leemhuis wrote:
> >
> > [TLDR: I'm adding this report to the list of tracked Linux kernel
> > regressions; all text you find below is based on a few templates
> > paragraphs you might have encountered already already in similar form.
> > See link in footer if these mails annoy you.]
> >
> > [CCing alsa maintainers]
> >
> > On 02.01.23 18:29, Michael Ralston wrote:
> > > I'm currently experiencing a regression with the audio on my Behringe=
r
> > > U-Phoria UMC404HD.
> > >
> > > Alsa info is at:
> > > http://alsa-project.org/db/?f=3Df453b8cd0248fb5fdfa38e1b770e774102f66=
135
> > >
> > > I get no audio in or out for this device with kernel versions 6.1.1 a=
nd 6.1.2.
> > >
> > > The versions I have tried that work correctly include 5.15.86 LTS,
> > > 5.19.12, and 6.0.13=E2=80=9316.
> > >
> > > When I run this on 6.1.1, it will just hang until I ctrl+c:
> > > aplay -D plughw:1,0 /usr/share/sounds/alsa/Front_Center.wav
> > >
> > > I've run strace on that command, and its output is at:
> > > https://pastebin.com/WaxJpTMe
> > >
> > > Nothing out of the ordinary occurs when aplay is run, according to th=
e
> > > kernel logs.
> > >
> > > Please let me know how I can provide additional debugging information
> > > if necessary.
>
> Please boot with snd_usb_audio.dyndbg=3D+p option, and get the kernel
> logs in both working and non-working cases.
>
> I guess it's a regression due to the hw_params/prepare split, but need
> to check more details.
>
>
> thanks,
>
> Takashi
