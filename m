Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF0A334704
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhCJSoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 13:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhCJSny (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 13:43:54 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74B6C061760
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 10:43:53 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id k9so35219320lfo.12
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 10:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vM8NHkCKbLRErp+CLsLgIaN6Ah0sE04uwPW1iIQb3RQ=;
        b=LhHMVyE9AxYhSGJEFd4XxwBbmy35wlBI/mM/atTza9Ur7/XCAkFEXBMvb1Z4xsjyGg
         9B7d31RNquKNpI6EorukgOrKK0VGqJQCD2JeMCiLB33vJjzAYFb0bVCNwPuckqStWaoY
         RUUOQEWgTeszGaFAV0VmO9cpXrj/rJOCagzfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vM8NHkCKbLRErp+CLsLgIaN6Ah0sE04uwPW1iIQb3RQ=;
        b=i6OgYjmDZ06M7yZrh4KvXy3T+Jy7o+7u0ass5JGJFapo+M95JLCHS5ybCowXyDcrOe
         PMTqJm0PLhrDOIWhDAdv7sKCpl2+DE+XyBXJZL88Mu5uw+pyYB5YquieKAH6h68TJbAn
         JXKQwKy02qU2EaSdVIJQ+EtILyRir3f3mgM1kAiTttD9IJeaUTGP7Ea6RLm/c4UL7M31
         HE5au2aR6uYSRvwldXHPgl0E7nDehHa0i8brrEKdHOb8u/yPj2RuL+GSmJbNxIRugyJE
         v6p2LPdInYT5Oyd4b2Biky6INhcGFf1b49u/RhPpqmLKUzuVeAMuwRB8sXjh5KoHCyK7
         RgoA==
X-Gm-Message-State: AOAM531cN+ZZkd5oZ0Rpae15oRYx68RmLiU8q/UUX6o2/MqB3yZdizJ+
        QjEt/JYxxubhAnW02MH+vUmznjyAkw09bQ==
X-Google-Smtp-Source: ABdhPJxU/QKvZiZbmcsTcRXnvqWzb/L+z87U3pG8so6O+BBPFzPVUB3cNDKWHN/3RKJiWO3rx3MWNg==
X-Received: by 2002:a05:6512:1108:: with SMTP id l8mr2753080lfg.255.1615401831490;
        Wed, 10 Mar 2021 10:43:51 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id f28sm36648lfk.67.2021.03.10.10.43.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 10:43:50 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id q14so26931171ljp.4
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 10:43:49 -0800 (PST)
X-Received: by 2002:a05:651c:3c1:: with SMTP id f1mr2546489ljp.507.1615401829544;
 Wed, 10 Mar 2021 10:43:49 -0800 (PST)
MIME-Version: 1.0
References: <20210122135735.176469491@linuxfoundation.org> <20210122135736.291270624@linuxfoundation.org>
In-Reply-To: <20210122135736.291270624@linuxfoundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Mar 2021 10:43:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiAafgm4fu-+NNfd5MA_0v7o5Spma-KH82eyJzY_q8-9A@mail.gmail.com>
Message-ID: <CAHk-=wiAafgm4fu-+NNfd5MA_0v7o5Spma-KH82eyJzY_q8-9A@mail.gmail.com>
Subject: Re: [PATCH 4.14 27/50] mm, slub: consider rest of partial list if
 acquire_slab() fails
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Jann Horn <jannh@google.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just a note to the stable tree: this commit has been reverted
upstream, because it causes a huge performance drop (admittedly on a
load and setup that may not be all that relevant to most people).

It was applied to 4.4, 4.9 and 4.12, because the commit it was marked
as "fixing" is from 2012, but it turns out that the early exit from
the loop in that commit was very much intentional, and very much shows
up on scalability benchmarks.

I don't think this is likely to be a big deal for the stable kernels -
we're basically talking tuning for special cases, and while it is
reverted in my tree now, the "correct" thing to do is likely to be a
bit more flexible than either "exit loop immediately" or "loop for as
long as we have contention".

In practice, most machines probably won't see either case - or it will
at least be rare enough that you can't tell.

The machine that reports a huge performance drop was a multi-socket
machine under fairly extreme conditions, and these contention issues
are often close to exponential - a smaller machine (or a slighly less
extreme load) would never see the issue at all either way.

See

    https://lore.kernel.org/lkml/20210301080404.GF12822@xsang-OptiPlex-9020/

for details if you care. I don't think this has to necessarily be
undone in the stable trees, this email is more of an incidental note
just as a heads-up.

                Linus

On Fri, Jan 22, 2021 at 6:14 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Jann Horn <jannh@google.com>
>
> commit 8ff60eb052eeba95cfb3efe16b08c9199f8121cf upstream.
>
> acquire_slab() fails if there is contention on the freelist of the page [..]
