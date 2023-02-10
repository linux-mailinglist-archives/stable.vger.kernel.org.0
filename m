Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AA5692443
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 18:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbjBJRQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 12:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjBJRQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 12:16:20 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8767A7F3
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:15:54 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-16a7f5b6882so7453341fac.10
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VyClQMBbQSWGWc4JTvsot/ddJnBNqXgJaoxlAlfJUYc=;
        b=qP3hvHkVmsSu2m+AvbBjbuSblc/NmW2KRlb8cEeoUiKXcfold8wugj4Ub/khySHNDb
         amNnJhtcd/dcyLR51N1buQ6VfInOVsmMJpshdTHMLh4lgU7U/l9bn6UBb0ZrFJR2pNP8
         BQQthYqpswGzGt93f3elk9R/4ef1taU2ymBSEbVRy3QAAeVCRL6R6gFVsGsyOY9m4FXQ
         Kmw752dfQTIV3zNGD0/4Bg/bV5RNuRMOH8pxvtSTtBatyDy6vWlgs70daMwG17jwkheE
         GOElaDQ7mp+yGxkmMycec1PxbqW7KiCCtxORjUiYvVjtmS8WncFPKOP7bSrZT+GPpCKc
         oXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VyClQMBbQSWGWc4JTvsot/ddJnBNqXgJaoxlAlfJUYc=;
        b=oIdLBKESHwEE4deWWXUicXptUux71INqelAvAC24HVtBNDdyCtEK1uLXn4b9xqz6e1
         dSwGFVn+GsBqfVPGfkg9gcbv++V1v8zU9j4YhbtHSEtSEoFJrGukiVJMurFrrOE8SJV+
         dmctmxEukzqe9BX+a3hl0nR8NpbaJFiN9asRaZ9DLXczyFPyCHZJ04HaGeTQChFhj+GI
         VeI5yHKCPfk7AmOiCdSqV9YBYdzdDiPKDgQDnqoLHSKxq9AE1a2I7oeYbsw6Gx1x7p6M
         DhWfmz1HlAPM9lFFenkHzY1+LQZT3aTMPyiT+TjilX8ds10ggnxmxvBg/AhhFVCvqaWM
         vNvw==
X-Gm-Message-State: AO0yUKVQeDvhylCPuSzZyW2cH49Tfn71DhQtMgJu8QIkXcTpWjZKjN0f
        pvrOFS0bNi5TQMLp+PcG3wz8pMdacdZVni0C0IA=
X-Google-Smtp-Source: AK7set/UldITBOBZ+cyBJFNaNTS5LVTVZE/3N21gRU/Dw+DyR/S8ykULYKMamzCdziX3znAZDoqSa60uGshuTh/Es98=
X-Received: by 2002:a05:6870:10cf:b0:16a:839d:8ce5 with SMTP id
 15-20020a05687010cf00b0016a839d8ce5mr2404384oar.298.1676049353681; Fri, 10
 Feb 2023 09:15:53 -0800 (PST)
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
 <CAJD_bPLHPfLO=192Ohrxvg5OGtAfAgTim0O+fdmxo753VS83iQ@mail.gmail.com>
 <478bb609-8615-31b4-e6f3-8eaaf95b84d6@intel.com> <CAJD_bPKiT91yx9FJNS3VEU2JemJvBtUW-4idWXBSy1hzfz8bsQ@mail.gmail.com>
In-Reply-To: <CAJD_bPKiT91yx9FJNS3VEU2JemJvBtUW-4idWXBSy1hzfz8bsQ@mail.gmail.com>
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Fri, 10 Feb 2023 18:15:42 +0100
Message-ID: <CALFERdwana-T7zL-Hsx=sdSjcNmxG9FfJTnaB+X10u+ngUmdjQ@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Jason Montleon <jmontleo@redhat.com>
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?B?QW1hZGV1c3ogU8WCYXdpxYRza2k=?= 
        <amadeuszx.slawinski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 10, 2023 at 3:57 PM Jason Montleon <jmontleo@redhat.com> wrote:
>
> On Fri, Feb 10, 2023 at 8:10 AM Cezary Rojewski
> <cezary.rojewski@intel.com> wrote:
> >
> > On 2023-02-09 5:13 PM, Jason Montleon wrote:
> > > I've done some more digging. The only line that needs to be reverted
> > > from f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338, moving from
> > > snd_hda_codec_device_init back to snd_hda_codec_device_new is:
> > > codec->core.exec_verb = codec_exec_verb;
> > > (https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/sound/pci/hda/hda_codec.c?h=v6.1.11#n931)
> > >
> > > I added a bunch of debug statements and all the code in
> > > codec_exec_verb runs at boot with this in snd_hda_codec_device_init,
> > > whereas it does not when in snd_hda_codec_device_new.
> > >
> > >  From what I can tell we end up in snd_hda_power_up_pm and then get
> > > hung up at snd_hdac_power_up.
> > >
> > > There are a bunch of pin port messages that show up from
> > > hdac_hdmi_query_port_connlist when things are working, that never
> > > appear when broken:
> > > [   14.618805] HDMI HDA Codec ehdaudio0D2: No connections found for pin:port 5:0
> > > [   14.619242] HDMI HDA Codec ehdaudio0D2: No connections found for pin:port 5:1
> > > [   14.619703] HDMI HDA Codec ehdaudio0D2: No connections found for pin:port 5:2
> > > ...
> > >
> > > I do see hdac_hdmi_runtime_suspend run a moment before things go bad,
> > > but I have no idea if it is related.
> > >
> > > Without patching anything and CONFIG_PM unset everything works.
> > >
> > > I don't know if that helps anyone see where the problem is. If not
> > > I'll keep plugging away.
> > >
> > > Incidentally, commit 3fd63658caed9494cca1d4789a66d3d2def2a0ab, pointed
> > > to by my second bisect, starts making using of skl_codec_device_init
> > > where I believe snd_hda_codec_device_init is called and starts the
> > > problem. I believe this is why reverting either of the two works
> > > around the problem.
> >
> >
> > This is some exceptional debugging, Jason.
> >
> > I believe this finding reveals a long standing problem that was covered
> > by a very specific codec-fields initialization order:
> >
> > During initial part of codec-device initialization, VERBs execution
> > follows different flow than one happening once the device is fully
> > initialized. This comes down to the if-statement preset in
> > snd_hdac_exec_verb() and the fact codec_exec_verb() differs from
> > snd_hdac_bus_exec_verb() in PM-handling - the latter is devoid of it.
> >
>
> Thank you for the explanation! I was not following this well, but it
> makes sense to me now.
>
> > That is until ->exec_verb gets initialized and codec_exec_verb() becomes
> > the sole handler of VERB execution process. As PM is not yet configured
> > at the time - snd_hda_codec_device_init() happens early, whereas PM
> > configuration is done later with snd_hda_set_power_save() during
> > skl_hda_audio_probe() in sound/soc/intel/boards/skl_hda_dsp_generic.c -
> > it should not be touched yet.
> >
> > I'm up for reverting this single line to where it was before the
> > offending patch. We still want to avoid the page fault the very patch is
> > addressing.
> >
> > Does the proposed change address both problems? i.e. no sound and hang
> > during shutdown?
>
> Yes, moving the one line back fixes both the no sound and shutdown hang.
>
> Thank you!
> Jason Montleon
>
> >
> > Kind regards,
> > Czarek
> >
>
>
>
> --
> Jason Montleon        | email: jmontleo@redhat.com
> Red Hat, Inc.         | gpg key: 0x069E3022
> Cell: 508-496-0663    | irc: jmontleo / jmontleon
>
Congrats to all of you people !! Thanks for the fix.
Sasa
