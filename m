Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21A63D9DD
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 16:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiK3Pto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 10:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiK3Pto (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 10:49:44 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FB61B7B4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:49:39 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e189so12581359iof.1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cITkc4ydx3t5/WaE8B5C64mzt1Dr4iTKfrMxsULtWPc=;
        b=Uy+DDhU4KWNCz4MeUi8ThR7KIclQ1LieLw0rWkPEBf4NX8Ph3SIGeBRdZGkwVg5BsC
         dfxDBeN3+ZPXROGSwwCjAOZVCHechH+KMEJcMGuBIsNdgi1fazzNt9MCXQpXaHrhEYqJ
         Bcq1QY0JVJr737F9dJ0qI9L6814xZjqjUJSNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cITkc4ydx3t5/WaE8B5C64mzt1Dr4iTKfrMxsULtWPc=;
        b=tYChdoQwSJQjv/oeH8n/B3BA9vIsa7HyrfCxhRvtbWrFJ1JByUAcVAmfRg9LuVVaRG
         8gT+0C2Wccl4W6Y8tlss5DWZBv/OXJeEG0VSUo0J7rEV3r2q4vA8/Kg2bNx+ksEqN73y
         oap4+Ontw5XsrVLNS/DAv3sqG7PRurSlt5ti04k98VAHUjqTjNywoCHjAEzfiEhbuCks
         0gJk/HrzyMpVxUkmU1P9Y9OfS977KfwexJJcWQcbI4LR1zziBTbEIgzxmtq/1MJjgtsX
         oyyjYFqz5jWISs4aPfWsyuWs4d7UvmHaE418XbfoZUH0uLvix1b5/DZFmdrsXvNUPQGj
         OQPw==
X-Gm-Message-State: ANoB5pkQ8nEYCclnlDND05TMav4CMr+LTzehJgaHpLSag4bY0IDWim+q
        LUGYN3TyHI+FKWSRHJ0LyUraHMnbj4a6ghW6
X-Google-Smtp-Source: AA0mqf6+an8jv+qwSBqekh1e8gKeYnz1ZvJ0j5rrBKdhltnvZ/z0HAcnXgdtkVbdb57CVyNMVDcgIw==
X-Received: by 2002:a02:b691:0:b0:389:af9:4860 with SMTP id i17-20020a02b691000000b003890af94860mr14797797jam.164.1669823378428;
        Wed, 30 Nov 2022 07:49:38 -0800 (PST)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com. [209.85.166.170])
        by smtp.gmail.com with ESMTPSA id i15-20020a056e021d0f00b00302b7bec907sm632341ila.41.2022.11.30.07.49.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 07:49:37 -0800 (PST)
Received: by mail-il1-f170.google.com with SMTP id q13so8286932ild.3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:49:37 -0800 (PST)
X-Received: by 2002:a92:ca8b:0:b0:303:19d2:9def with SMTP id
 t11-20020a92ca8b000000b0030319d29defmr6089993ilo.21.1669823377096; Wed, 30
 Nov 2022 07:49:37 -0800 (PST)
MIME-Version: 1.0
References: <20221127-snd-freeze-v4-0-51ca64b7f2ab@chromium.org>
 <5171929e-b750-d2f1-fec9-b34d76c18dcb@linux.intel.com> <87mt8bqaca.wl-tiwai@suse.de>
 <16ddcbb9-8afa-ff18-05f9-2e9e01baf3ea@linux.intel.com> <87edtmqjtd.wl-tiwai@suse.de>
 <alpine.DEB.2.22.394.2211291355350.3532114@eliteleevi.tm.intel.com>
In-Reply-To: <alpine.DEB.2.22.394.2211291355350.3532114@eliteleevi.tm.intel.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 30 Nov 2022 16:49:26 +0100
X-Gmail-Original-Message-ID: <CANiDSCsGZBo=C+Bep8TQp15mA+-4ZRCPwSJzyndFuwokt7Byyw@mail.gmail.com>
Message-ID: <CANiDSCsGZBo=C+Bep8TQp15mA+-4ZRCPwSJzyndFuwokt7Byyw@mail.gmail.com>
Subject: Re: [PATCH v4] ALSA: core: Fix deadlock when shutdown a frozen userspace
To:     Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc:     Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        linux-kernel@vger.kernel.org, sound-open-firmware@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

I just sent a v6 that only avoids unregistering the clients during
kexec... let me know if that works for you

Thanks!

On Tue, 29 Nov 2022 at 13:12, Kai Vehmanen <kai.vehmanen@linux.intel.com> wrote:
>
> Hi
>
> On Tue, 29 Nov 2022, Takashi Iwai wrote:
>
> > On Mon, 28 Nov 2022 18:26:03 +0100, Pierre-Louis Bossart wrote:
> > > As Kai mentioned it, this step helped with a S5 issue earlier in 2022.
> > > Removing this will mechanically bring the issue back and break other
> > > Chromebooks.
> >
> > Yeah I don't mean that this fix is right, either.  But the earlier fix
> > has apparently a problem and needs another fix.
> >
> > Though, it's not clear why the full unregister of clients is needed at
> > the first place; judging only from the patch description of commit
> > 83bfc7e793b5, what we want is only to shut up the further user space
> > action?  If so, just call snd_card_disconnect() would suffice?
>
> I think the snd_card_disconnect() is what we are looking after here, but
> it's just easiest to do via unregister in SOF as that will trigger will
> look up the platform device, unregister it, and it eventually the driver
> owning the card will do the disconnect. Possibility for sure to do a more
> direct implementation and not run the full unregister.
>
> On the other end of the solution spectrum, we had this alternative to let
> user-space stay connected and just have the DSP implementations handle
> any pending work in their respective shutdown handlers. I.e. we had
> "ASoC: SOF: Intel: pci-tgl: unblock S5 entry if DMA stop has failed"
> https://github.com/thesofproject/linux/pull/3388
>
> This was eventually dropped (and never sent upstream) as 83bfc7e793b5 got
> the same result, and covered all SOF platforms with a single code path.
> Bringing this back is of course one option, but then this might suprise
> other platforms (which might have got used to user-space getting
> disconnected at shutdown via 83bfc7e793b5).
>
> Br, Kai



-- 
Ricardo Ribalda
