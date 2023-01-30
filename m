Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D02C680D87
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 13:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjA3MWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 07:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjA3MWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 07:22:50 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43649125BF
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 04:22:42 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id s124so9884552oif.1
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 04:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n8cbCglwHAcL5prmHxuFLmpiN5Psq3XwYbiERoq55tI=;
        b=i/JRzgzZiy1z9MybJRM1NpsJwMtAbgpMQRLckLJFr9+VlH6fPg//Mfk9DsjqYQocon
         UrD88pb7noOmDvAnv0BIglhe7BZBstgynNkNyMVbU+cdiAtSNtTSFSY5laEGpUShlPaC
         dm+C5RblNemLnxFGhxovNs24xIhuWKcwEcWvXk9sO/rpQfZbIRHclWl5uHoqa0X1khW7
         91cQPOoOoCS6plR7eDj1yzZXMvP2kS9lCCCCmCyP3nsluWShkZymPHG5+iEnldG3VWST
         tslyD3ZH6YX6eloRebkHl8XBseSuPRVhDDjc0bpbbdjC4/AwYnWFm+dUaQTQqlr+xt87
         OhwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n8cbCglwHAcL5prmHxuFLmpiN5Psq3XwYbiERoq55tI=;
        b=oDDQiGBjs0gmOVxA7N6JNbMSlxMBjZ0KYTUv98voQV0jiR8PhnWcGQuXniunOMgIDE
         PAZ5W3D+F/GABTq0ap6t3IYyK9jvkkqs+SreQjHiUA4fKpJb2U1JgvD84QVwhsPQUfrj
         qB5yrMCY/ReL5/2xsNyuBopkVefvfeZYdRSb0yFsSAQVbYDhfCzIYHe4aG2CexQWPFYw
         fsCN2zxq9TNRrhzwPMWYOqSxrRq7HDAN/gxgnZGg+HgvTymbPhRBNrdtJ1gDk/iPO0dQ
         AKajQR4b4iWpPLVNuQ3lX56IBRN7nGPDic8mbP3c/be7zFywSOJ6MqjTGf0f7CX5ym/i
         8amA==
X-Gm-Message-State: AO0yUKV+MUMDFpywkC5kGJpHMeO3k6zwaGKaRb4zG1HBrbU1EVASK9+M
        EZAtImLYs5XcRdjJobJIc9chokTnqc3QYTB1isehZpAUnPBRrg==
X-Google-Smtp-Source: AK7set+tiAOFfpxgEKn/8wIu+nDD8rbcUkkr3YWYSinED0/lsmCG4W9fI2MqhYmAKvvCkYI5ZHXuLz5zhet5DxARoqY=
X-Received: by 2002:a05:6808:d47:b0:378:15e:c61d with SMTP id
 w7-20020a0568080d4700b00378015ec61dmr718980oik.298.1675081361573; Mon, 30 Jan
 2023 04:22:41 -0800 (PST)
MIME-Version: 1.0
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com> <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info> <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
In-Reply-To: <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Mon, 30 Jan 2023 13:22:30 +0100
Message-ID: <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Cezary Rojewski <cezary.rojewski@intel.com>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Jason Montleon <jmontleo@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?B?YW1hZGV1c3ogU8WCYXdpxYRza2k=?= 
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

On Mon, Jan 30, 2023 at 1:15 PM Cezary Rojewski
<cezary.rojewski@intel.com> wrote:
>
> On 2023-01-30 12:27 PM, Linux kernel regression tracking (Thorsten
> Leemhuis) wrote:
> > On 30.01.23 07:33, Jason Montleon wrote:
> >> I ran a bisect back further while patching in
> >> f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338.
> >
> > Cezary Rojewski, you authored this change which appears to cause a
> > regression. Do you maybe have an idea what's wrong here?
>
>
> Hello,
>
> Sitting with Lukasz and debugging this.
>
> Please note that messages seen in the logs:
> [    8.538645] snd_soc_skl 0000:00:1f.3: ASoC: no sink widget found for
> AEC Capture
> [    8.538654] snd_soc_skl 0000:00:1f.3: ASoC: Failed to add route
> echo_ref_out cpr 7 -> direct -> AEC Capture
>
> and:
> [    8.614993] rt5663 i2c-10EC5663:00: sysclk < 384 x fs, disable i2s asrc
> [    8.617460] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense:
> disconnect for pin:port 5:0
> [    8.617581] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense:
> disconnect for pin:port 6:0
> [    8.617712] HDMI HDA Codec ehdaudio0D2: hdac_hdmi_present_sense:
> disconnect for pin:port 7:0
>
> seem to be just noise, these are present even in working configuration.
> Looks like topology and AudioDSP firmware loads fine. However, one or
> more of sound cards component is deferred when probing what results in
> no error in the logs but still lack of audio.
>
> We managed to reproduce the problem on Lukasz' Eve machine. If hardware
> cooperates, we should be able to narrow down the problem quickly from
> here. Our suspect - something (a patch or two) is missing in sound/soc
> in Fedora tree. Our CI which also covers upstream skylake-driver with
> HDAudio (e.g.: rt274/rt286/rt298) and I2S (same examples) configurations
> show no signs of regression. Thus, this is probably Chromebook-specific.
>
> My opinion stands at - none of the patches mentioned during the
> discussion is the real problem. All of these were in fact addressing
> real problems with audio stack stability/reloading.
>
> Will reply once more is known.
>
>
> Kind regards,
> Czarek

Dear Czarek, many thanks for the answer and taking care of it. If
needed something from my side please jest let me know
and I will try to do it.

Rgds
Sasa
