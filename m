Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F2F4E85F1
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiC0FbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiC0FbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:31:22 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC8D46B27
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 22:29:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x34so13512128ede.8
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 22:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3AIrmmPfx/ZOrHBctYZwCCwGfAaK/1/IH4psZd3wsUE=;
        b=djCcgOaCULO1J4pux52MUZuwiPblxKGguZJ9FLwYib2dSNo188P6jyJlcS/Z3+Vjqp
         NuxHz+nULM3zYzdCDc/LCticaRTrzP6Eu8i5lYrUz9D+Qn4hFWHokDkpiq4ZgcyhM3fv
         2VMFEP6rvt3FcDITehwTGDWmAXZRTRWN+Beak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3AIrmmPfx/ZOrHBctYZwCCwGfAaK/1/IH4psZd3wsUE=;
        b=JGZzWUQe8fxfKwvyfHdPisFsulPckOBrmRToIAEnUa9CRs0FZwZMSAW7Cv+DbXJNe3
         gpPi1WZyMW/6QB8zZ0Dqbo7SaR0rs9UstSmac0HlR3C+Mi9K7LZytD/bLARdDQSgbt5Q
         il85hn7lboWE0Draj5PPLSnY/LnSbBsE5Xe0snusH99oehZrpdsAted/xraHCKTl4VlW
         Jwex+e5pVyBLHTfCqD4NHOI1xfexI2iBwC8u5LhH+nxRX4cH3XPTR6Enh+qTXdBGThzD
         eKHg40V42whkkyNsXFYuKCb85cric+HTsHJS8NUAeR22yotTQh5N0nNvNgxYBqiC3Y+Q
         4kyg==
X-Gm-Message-State: AOAM5309ODcCkaSc8ZOCO+M7owQCJ15Bv8MQJM8GNmGzhar7b9a7Wagm
        SJ3awGoOhsManUohf1u2Earirp6L16nRwNBFa8Y=
X-Google-Smtp-Source: ABdhPJwCvfpqEP9WLWCL7jVmq6xAUcxadZznzVZ7kvJ3IbnZAALjR30HadcefLMJpTDDKQ4IpdKUQA==
X-Received: by 2002:a05:6402:4391:b0:419:2f2d:a1da with SMTP id o17-20020a056402439100b004192f2da1damr8530354edc.298.1648358982454;
        Sat, 26 Mar 2022 22:29:42 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id sa32-20020a1709076d2000b006df935924c1sm4198506ejc.59.2022.03.26.22.29.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 22:29:41 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id g22so2427039edz.2
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 22:29:41 -0700 (PDT)
X-Received: by 2002:a2e:6f17:0:b0:248:124:9c08 with SMTP id
 k23-20020a2e6f17000000b0024801249c08mr14918936ljc.506.1648358479393; Sat, 26
 Mar 2022 22:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
 <871qyr9t4e.fsf@toke.dk> <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <20220327054848.1a545b12.pasic@linux.ibm.com> <CAHk-=whUJ=tMEgP3KiWwk0pzmHn+1QORUu50syE+zOGk4UnFog@mail.gmail.com>
In-Reply-To: <CAHk-=whUJ=tMEgP3KiWwk0pzmHn+1QORUu50syE+zOGk4UnFog@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 26 Mar 2022 22:21:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgUx5CVF_1aEkhhEiRGXHgKzUdKiyctBKcHAxkxPpbiaw@mail.gmail.com>
Message-ID: <CAHk-=wgUx5CVF_1aEkhhEiRGXHgKzUdKiyctBKcHAxkxPpbiaw@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 26, 2022 at 10:06 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Mar 26, 2022 at 8:49 PM Halil Pasic <pasic@linux.ibm.com> wrote:
> >
> > I agree it CPU modified buffers *concurrently* with DMA can never work,
> > and I believe the ownership model was conceived to prevent this
> > situation.
>
> But that just means that the "ownership" model is garbage, and cannot
> handle this REAL LIFE situation.

Just to clarify: I obviously agree that the "both sides modify
concurrently" obviously cannot work with bounce buffers.

People still do want to do that, but they'll limit themselves to
actual cache-coherent DMA when they do so (or do nasty uncached
accesses but at least no bounce buffering).

But the "bounce ownership back and forth" model comes up empty when
the CPU wants to read while the DMA is still going on. And that not
only can work, but *has* worked.

You could have a new "get me a non-ownership copy" operation of
course, but that hits the problem of "which existing drivers need it?"

We have no idea, outside of ath9k.

This is why I believe we have to keep the existing semantics in a way
that keep ath9k - and any number of unknown other drivers - happy.

And then for the cases where you want to introduce the zeroing because
you don't know how much data the DMA returned - those are the ones
you'll have to mark some way.

                  Linus
