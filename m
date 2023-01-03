Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEAD65C2E4
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbjACPUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbjACPUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:20:19 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8058A1055E
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 07:20:18 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id i127so27335743oif.8
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 07:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z8vVarhYQXZ9Qhz5mKvhwtmR7SHZZ/LNj7oEL18OVmc=;
        b=hyeNGChJOIyeBdeAor9LyYJDIbYuztx7eQPHqVLU/cYmveo63Dounjfo3BQ16he9mC
         H2PBFm462b6aeUnMdHKBadoPpjesWMEruUkoYYlOuMKBK+5N+2CD3+Wr5xhnwXRMPl4c
         mMdw5sImTu+yhVbE1H9hYFjKdg7u/cJfIJmPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z8vVarhYQXZ9Qhz5mKvhwtmR7SHZZ/LNj7oEL18OVmc=;
        b=ir8akhwHZNOW5bRKmEVWL6ynxddf0Mw95ynrIBNPt4JykaBhlarEPZYjb3Zw61/fwQ
         wIQ1TelZHdQn9iQ0HjWx7UuZUTGuCBxhJHf7bxxE2BfCXc1jHK1VnmEqZbaz2z3nvmV2
         bbJ/U+sObrJu0FKD39bRlj/SUeXBP4WBMwANIfKjzuXsAkxn6b/eZpoxQBqwXUeWa6/s
         m5qgCgc66TVEzzJ8ST0+BqfuvmNaKUDP/g7HIw2YD7xzxNctQYH2X+ay+UywCVaMa2jZ
         +WGi0ehMmul7gtogn6ewrZlyQpgd6ZTas4Exxa+Lm0jpsWp+vwP0nSuDWZbxonYpqwUZ
         jfhw==
X-Gm-Message-State: AFqh2krhrtbK0t/S2z3Tc++nPECBsN0bIPTbvV2DfKnAjtfAAaEqll4R
        8so84bG3L91hmixQB/EiMH0WqUFNLAsXUekssMTWfWg5zSJMKCq1r00=
X-Google-Smtp-Source: AMrXdXu0SPE09PX79YJPOiZzyF40E/NRTrYM3mQEXId4MTVPUHDeIvG66xX/A8ZFkefsBYcMYb0vO3fCepWpRm7CMVI=
X-Received: by 2002:a05:6808:48d:b0:35c:3327:ecf0 with SMTP id
 z13-20020a056808048d00b0035c3327ecf0mr2266171oid.220.1672759217823; Tue, 03
 Jan 2023 07:20:17 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
 <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info> <87zgb0q7x4.wl-tiwai@suse.de>
 <CAC2975K24Gt3rGieAToHjb7FEHv84aqiRSQx7EOuR2Q7KByUXw@mail.gmail.com>
 <87sfgrrb5f.wl-tiwai@suse.de> <CAC2975+cUqiFC0LO-D-fi0swH+x=_FMuG+==mhg6HH4pc_YDRA@mail.gmail.com>
 <87bknfr6rd.wl-tiwai@suse.de> <CAC2975+CP0WKmXouX_8TffT1+VpU3EuOzyGHMv+VsAOBjCyhnA@mail.gmail.com>
In-Reply-To: <CAC2975+CP0WKmXouX_8TffT1+VpU3EuOzyGHMv+VsAOBjCyhnA@mail.gmail.com>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Wed, 4 Jan 2023 02:19:41 +1100
Message-ID: <CAC2975LNYcsW1zAohijLtziXLbUyBjxHY3grD5=HjHcWBH_LPA@mail.gmail.com>
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

On Wed, 4 Jan 2023 at 02:14, Michael Ralston <michael@ralston.id.au> wrote:
>
> On Wed, 4 Jan 2023 at 02:13, Takashi Iwai <tiwai@suse.de> wrote:
> >
> > That's weird.  Is snd_usb_audio driver bound with the device at all?
> > That is, does it appear in /proc/asound/cards?
> >
>
> Yes, it's there.
>
> 0 [V49            ]: USB-Audio - V49
>                      Alesis V49 at usb-0000:08:00.1-3, full speed
> 1 [NVidia         ]: HDA-Intel - HDA NVidia
>                      HDA NVidia at 0xfc080000 irq 154
> 2 [U192k          ]: USB-Audio - UMC404HD 192k
>                      BEHRINGER UMC404HD 192k at usb-0000:08:00.1-4, high speed
> 3 [Generic        ]: HDA-Intel - HD-Audio Generic
>                      HD-Audio Generic at 0xfca00000 irq 156

Also lsusb shows this...

    |__ Port 4: Dev 5, If 0, Class=Audio, Driver=snd-usb-audio, 480M
       ID 1397:0509 BEHRINGER International GmbH
       /sys/bus/usb/devices/1-4  /dev/bus/usb/001/005
   |__ Port 4: Dev 5, If 1, Class=Audio, Driver=snd-usb-audio, 480M
       ID 1397:0509 BEHRINGER International GmbH
       /sys/bus/usb/devices/1-4  /dev/bus/usb/001/005
   |__ Port 4: Dev 5, If 2, Class=Audio, Driver=snd-usb-audio, 480M
       ID 1397:0509 BEHRINGER International GmbH
       /sys/bus/usb/devices/1-4  /dev/bus/usb/001/005
   |__ Port 4: Dev 5, If 3, Class=Audio, Driver=snd-usb-audio, 480M
       ID 1397:0509 BEHRINGER International GmbH
       /sys/bus/usb/devices/1-4  /dev/bus/usb/001/005
   |__ Port 4: Dev 5, If 4, Class=Audio, Driver=snd-usb-audio, 480M
       ID 1397:0509 BEHRINGER International GmbH
       /sys/bus/usb/devices/1-4  /dev/bus/usb/001/005
   |__ Port 4: Dev 5, If 5, Class=Vendor Specific Class, Driver=, 480M
       ID 1397:0509 BEHRINGER International GmbH
       /sys/bus/usb/devices/1-4  /dev/bus/usb/001/005

--
Michael
