Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1402968315F
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbjAaPWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbjAaPWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:22:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4CA5976F
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 07:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675178340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=57w4K6BuoaTjEUzcJkzqKflKFYan8jU60ULxR7+D950=;
        b=itRkAU92CqSVUpHFICs1A6aRKH+peHUXghZReKWJV/T35UkjWqVzzAdD2hQIFIPDHN6bs7
        jG7DGW7NZcAOXgZnw36EHr77iY9Z0mPQx2oGHba3Vpqvk0Yh09JbmnueYT6znjzYY7zAkk
        48l7/W4t5fjugq+h7iJ85EVk1sud8Cc=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-2-f7qjrF0wMbKqRzjqCoKWgw-1; Tue, 31 Jan 2023 10:16:54 -0500
X-MC-Unique: f7qjrF0wMbKqRzjqCoKWgw-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-507aac99fdfso169831407b3.11
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 07:16:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=57w4K6BuoaTjEUzcJkzqKflKFYan8jU60ULxR7+D950=;
        b=Mrk8oliztuRI3Vzr+z9YqP0mtMNXPQ01PYjX6Be0jb5QPVkZ8I/3NCyuZXWSiGf9nd
         UTlULn3ZeRbOYB/2wSMF40Uqk4eVTWaJwwmnUC4PiWlKFeVtXuIbeFEeioAeGnU0+DwQ
         V5S/vvLR+kMLpRAZEtlE5XJ8vj++SfwsfFvbNDA7QNXvwka8Vfy4xzTPwR0XTVLpGHez
         fKAYDgVoRCF3frY0sKWZyvcRcNc7+Yz6Mf1ZOfWFFW/2a4Q3NvjQnP4vwxKx9o0yJFpC
         775ZsP1vbaCnc9qH95i8KpJe1sGpICN/fcrV75ebc+h907MGNXC9OWHGSGyBpmNQTfM2
         aQlA==
X-Gm-Message-State: AO0yUKUZZsi5KOU0E37sx9a8V5P2Q8DL43r4boL4kH/CDCMxOGzR2Pzl
        IzMBuO1cxDcmqbpMOlcUBQCRZPP8AeO+f1Ommq+zjo1ontvLyHMkGrl3Jw/gXsbI1XtojQGwe9L
        jGfckBM4Lp3pJmvXG18OBsw50u+jNNuVE
X-Received: by 2002:a0d:eb0b:0:b0:506:5637:b000 with SMTP id u11-20020a0deb0b000000b005065637b000mr2939970ywe.461.1675178176361;
        Tue, 31 Jan 2023 07:16:16 -0800 (PST)
X-Google-Smtp-Source: AK7set96bt7gvSHvKjmhBDs2b3Z72rZLPfZYhNZB1VbavA7waxCuMzsdQ+eFFer/qZFTj9SUZxP9sdi+017tMaBMtnc=
X-Received: by 2002:a0d:eb0b:0:b0:506:5637:b000 with SMTP id
 u11-20020a0deb0b000000b005065637b000mr2939962ywe.461.1675178174889; Tue, 31
 Jan 2023 07:16:14 -0800 (PST)
MIME-Version: 1.0
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com> <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info> <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
 <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com> <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com>
In-Reply-To: <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com>
From:   Jason Montleon <jmontleo@redhat.com>
Date:   Tue, 31 Jan 2023 10:16:03 -0500
Message-ID: <CAJD_bP+Te5a=OfjN9YrjGOG2PzudQ87=5FEKj6YLFxfKyFe5bw@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Cezary Rojewski <cezary.rojewski@intel.com>
Cc:     Sasa Ostrouska <casaxa@gmail.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?B?YW1hZGV1c3ogU8WCYXdpxYRza2k=?= 
        <amadeuszx.slawinski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 31, 2023 at 7:37 AM Cezary Rojewski
<cezary.rojewski@intel.com> wrote:
>
> On 2023-01-30 1:22 PM, Sasa Ostrouska wrote:
>
> > Dear Czarek, many thanks for the answer and taking care of it. If
> > needed something from my side please jest let me know
> > and I will try to do it.
>
>
> Hello Sasa,
>
> Could you provide us with the topology and firmware binary present on
> your machine?
>
> Audio topology is located at /lib/firmware and named:
>
> 9d71-GOOGLE-EVEMAX-0-tplg.bin
> -or-
> dfw_sst.bin
>
> Firmware on the other hand is found in /lib/firmware/intel/.
> 'dsp_fw_kbl.bin' will lie there, it shall be a symlink pointing to an
> actual AudioDSP firmware binary.
>
Maybe this is the problem.

I think most of us are pulling the topology and firmware from the
chromeos recovery images for lack of any other known source, and it
looks a little different than this. Those can be downloaded like so:
https://gist.github.com/jmontleon/8899cb83138f2653f520fbbcc5b830a0

After placing the topology file you'll see these errors and audio will
not work until they're also copied in place.
snd_soc_skl 0000:00:1f.3: Direct firmware load for
dsp_lib_dsm_core_spt_release.bin failed with error -2
snd_soc_skl 0000:00:1f.3: Direct firmware load for
intel/dsp_fw_C75061F3-F2B2-4DCC-8F9F-82ABB4131E66.bin failed with
error -2

Once those were in place, up to 6.0.18 audio worked.

Is there a better source for the topology file?

> The reasoning for these asks is fact that problem stopped reproducing on
> our end once we started playing with kernel versions (moved away from
> status quo with Fedora). Neither on Lukasz EVE nor on my SKL RVP.
> However, we might be using newer configuration files when compared to
> equivalent of yours.
>
> Recent v6.2-rc5 broonie/sound/for-next - no repro
> Our internal tree based on Mark's for-next - no repro
> 6.1.7 stable [1] - no repro
>
> Of course we will continue with our attempts. Will notify about the
> progress.
>
>
> [1]:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v6.1.7&id=21e996306a6afaae88295858de0ffb8955173a15
>
>
> Kind regards,
> Czarek
>


-- 
Jason Montleon        | email: jmontleo@redhat.com
Red Hat, Inc.         | gpg key: 0x069E3022
Cell: 508-496-0663    | irc: jmontleo / jmontleon

