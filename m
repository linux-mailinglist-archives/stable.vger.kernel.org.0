Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E186A68C865
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 22:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBFVPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 16:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBFVPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 16:15:47 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511436181
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 13:15:46 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-16a291b16bfso7233444fac.7
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 13:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8oDgISCPW6x83bsvwBH5kgHHQ9WrA3hry4JT2KUtJzk=;
        b=qptxXqLhJEtGrGycsjIoqKbIVdlGKsoLy86960FGzxIjJLOWdOZtQzAK47o8lgFmMt
         pr7V2yddUb+quD3dNFXd1D1hGmLY8uxZ+KJ2QUMp5FSI5Pzt73VRbnhfGr2qGl4XArKw
         Jg8jffjsaEThb+HWk8HCk+1mOxxZVJTsd/FZcLGni/eNUDjGCAQsfhFhf0sHP5BwVKbo
         6aRzAa9FHEvhf3eVf9XKzLHJv/c2LX9JTr+89q8hF+a8UN0dBT8jDXwsQzKMg7XQgPG1
         i25b8Vkel1gHgNMgeTseAtPgd9vC3PQaa/82Gr/UDqAyFue1RXSYUwqz2lDCion77cxX
         udRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oDgISCPW6x83bsvwBH5kgHHQ9WrA3hry4JT2KUtJzk=;
        b=fe5CbFbxH6tHx66BmpUUXzk30bKxOaofdRqslwz504veZjkuhs8sKfLwPNVs6l+m4Z
         JDuNi88p7wbN7wDy6+zGzNzIAQbu24ftDvr1TpUXyBfIzh+HHGzwJ3Yyb1YIjrqvBlPD
         R8OyUwyYTlN/x3jQbTa6G0ojl9JO5NS8FImUpYBCDurEXT8d3dEW7ozNxtON8V0O6Ef8
         eHYV8RhX5KVnby1QR4W7/MnbB5pM/O9ue60qWHWg9VKH5w+5F4AUaDpsZ/1QY3xdg23j
         o9ScqgckIC/Qt0f8kFMlRQcx1/qbzF1Wg9xe98Myn/hx5dEs0wYRac4IB2+8f3k9PNMz
         Ahhg==
X-Gm-Message-State: AO0yUKUoDg7UGZcV02iHPQEXzDze46DY3GyK4SsNGVeSZKEotk/URswO
        4zmLJFdWe/DN6tHoWOTG68/7cHiTwT78Xk0bPVI=
X-Google-Smtp-Source: AK7set+FRm/5TMw+EStPbGbawES+KslvzJbckPJmoHnCHQHFXxjwLZOU8+0mgM+po3tsyiG7IRXarQaUSrR4wlCxFyY=
X-Received: by 2002:a05:6870:63a9:b0:163:9ade:ea88 with SMTP id
 t41-20020a05687063a900b001639adeea88mr161278oap.298.1675718145575; Mon, 06
 Feb 2023 13:15:45 -0800 (PST)
MIME-Version: 1.0
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com> <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info> <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
 <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com>
 <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com> <CAJD_bP+Te5a=OfjN9YrjGOG2PzudQ87=5FEKj6YLFxfKyFe5bw@mail.gmail.com>
 <6262bd72-cc2b-9d2a-e8f0-55c2b2bb7861@linux.intel.com> <CAJD_bPKxbsDi10FGX2mrMeuxcphDOvO8Q87j+AvnnQpe5cvmSA@mail.gmail.com>
 <CAJD_bP+RUemsss_YiAZ5v08ak8aTzXCB0gk7q623zyF455bh7g@mail.gmail.com>
 <a423c627-d303-3b50-5f11-78c06ed3b985@linux.intel.com> <CAJD_bPKO+zCeRojkOr2uY+nXvhsjO3Um86Lh53ZCuCUm3Ci3PA@mail.gmail.com>
 <CAJD_bPJfT5DA8EdN+timzXa3-itnPD5epq552S=NQ6Spr7iTUw@mail.gmail.com>
In-Reply-To: <CAJD_bPJfT5DA8EdN+timzXa3-itnPD5epq552S=NQ6Spr7iTUw@mail.gmail.com>
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Mon, 6 Feb 2023 22:15:34 +0100
Message-ID: <CALFERdwqwEzw7Wc_mTuM94+oscQ6iLFwcXS30pXioYpvmZ+2kA@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Jason Montleon <jmontleo@redhat.com>
Cc:     =?UTF-8?B?QW1hZGV1c3ogU8WCYXdpxYRza2k=?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 6, 2023 at 8:57 PM Jason Montleon <jmontleo@redhat.com> wrote:
>
> On Mon, Feb 6, 2023 at 8:51 AM Jason Montleon <jmontleo@redhat.com> wrote=
:
> >
> > On Mon, Feb 6, 2023 at 4:04 AM Amadeusz S=C5=82awi=C5=84ski
> > <amadeuszx.slawinski@linux.intel.com> wrote:
> > >
> > > On 2/4/2023 4:16 PM, Jason Montleon wrote:
> > > > I have built kernels for 6.0.19 (I don't think anyone confirmed
> > > > whether or not it worked), plus every 6.1 tag from 6.1-rc1 up to
> > > > 6.1.7. 6.0.19 worked. No 6.1 kernels worked. For rc1 to rc5 I built
> > > > with and without the legacy dai renaming patch added in rc6 that I
> > > > believe would be necessary, but it made no difference either way.
> > >
> > > Hi,
> > >
> > > thank you for trying to narrow it down, if I understand correctly -rc=
1
> > > doesn't work, which means that problem was introduced somewhere betwe=
en
> > > 6.0 and 6.1-rc1 (just for the sake of being sure, can you test 6.0
> > > instead of 6.0.19?) There is one commit which I'm bit suspicious abou=
t:
> > > ef6f5494faf6a37c74990689a3bb3cee76d2544c it changes how HDMI are
> > > assigned and as a machine board present on EVE makes use of HDMI, it =
may
> > > potentially cause some problems. Can you try reverting it?
> > > (If reverting on top of v6.1.8 you need to revert both
> > > f9aafff5448b1d8d457052271cd9a11b24e4d0bd and
> > > ef6f5494faf6a37c74990689a3bb3cee76d2544c which has minor conflict,
> > > easily resolved with just adding both lines.
> > >
> >
> > Yes, happy to give that a shot and will report back.
> >
>
> Removing f9aafff5448b1d8d457052271cd9a11b24e4d0bd and
> ef6f5494faf6a37c74990689a3bb3cee76d2544c did not make things work.
>
> You may be onto something with pulseaudio and/or HDMI, however.
> When setting up Slackware I saw an interesting aplay hang.
> Normally aplay -l will list like this with working audio:
> $ aplay -l
> **** List of PLAYBACK Hardware Devices ****
> card 0: kblr55145663max [kbl-r5514-5663-max], device 0: Audio (*) []
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 0: kblr55145663max [kbl-r5514-5663-max], device 2: Headset Audio (*)=
 []
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 0: kblr55145663max [kbl-r5514-5663-max], device 6: Hdmi1 (*) []
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 0: kblr55145663max [kbl-r5514-5663-max], device 7: Hdmi2 (*) []
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
>
> Both on Slackware and Fedora with broken audio it hangs like so
> (haven't tried on Arch):
> $ aplay -l
> **** List of PLAYBACK Hardware Devices ****
> card 0: kblr55145663max [kbl-r5514-5663-max], device 0: Audio (*) []
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 0: kblr55145663max [kbl-r5514-5663-max], device 2: Headset Audio (*)=
 []
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 0: kblr55145663max [kbl-r5514-5663-max], device 6: Hdmi1 (*) []
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
>
> If I remove or disable pulseaudio it lists without hanging, but it's
> difficult for me to tell whether it's working since aplay, etc. seem
> to want pulseaudio to play anything. Shutdown hangs persist
> regardless.
>
> Also, Slackware with 6.1.9 behaves as badly for me as everything else.
> If Sasa has working audio I do not know how he has managed to
> configure it. On each distro, as soon as I add topology and firmware
> files everything goes bad, regardless of whether I add ucm
> configuration or not, etc.
>
As already said, Jason, my slackware install still have a working
audio after all updates.
I have installed slackware the common way, makeing it use BTRFS,
installed by booting
it , run setup on slackware64-15.0 installed all packages except KDE
as I use XCFE or GNOME.
Since gnome is not part of Slackware I am on XFCE right now. After I
installed slackware64-15.0
I boot into it, and then followed the steps in your AUDIO section from
step 1 to step 5.
So basically copied firmware into /lib/firmware, /lib/firmware/intel
and opt/google/dsm
After that I have reboot and sound was working already on kernel 5.15.80 .
Then I run slackpkg update and upgrade-all to update everything to
slackware64-current,
which at the time had a 6.1.8 kernel.
Slackware usually ships an unpatched kernel supplied as it is from Linus tr=
ee.

Thats it, and initially I know sound was hanging sometimes. But today
I do not experience any hangs
anymore.

Only thing I had to do was to enable the kbl-r5514-5663-max profile in
pavucontrol. As by default it was at
off position.

But if needed any file or log from Slackware instsall let me know.

Rgds
Sasa
