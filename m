Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CB03F68B6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 20:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbhHXSE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 14:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239873AbhHXSEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 14:04:54 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C0BC061A27
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 11:01:41 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x27so47282868lfu.5
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 11:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YCxb+VTz4cjVjB3faY8PYmPDiDFElSaMqsPr/FfkL6c=;
        b=TTbBK+uOHncqHzTPlHlqLNwRCow/uI7O1xrUhx5q6yORLlE6bHsr+dhSaSuXcvPC8W
         sSo9+Ef3wIF2fxdpq/IxupzammVvj/ottvH7stUJfbMNmbqddK9z1dT8S9X+kA7WeC7B
         pddO/dstyV3iOaE17BwK+pzEa2wK9BhJlKORo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YCxb+VTz4cjVjB3faY8PYmPDiDFElSaMqsPr/FfkL6c=;
        b=eRx9xypjoyNcO1KggGE146TPvAoZHhYUQe+XTue9ojgy3l+e1AFDlCtSDywtP6Gxb6
         jIuBtWRdc+FbYHD5ErFlBXhlodkSz/eAKzMKdBb4HTUJBqB/jGXs59IFZ6RFyW68v4ZI
         G+OpbMoWF/2ee7yLmFlCSztKbNNW2h8LiDBGzxGhCwbyWEE7hpF4zo1wyQ0XtHs2hUMT
         VHjuSlvMHnLs/FadCNotiZMuRcFVNsgHpcXsKV89hqxxy92FEt0PwOL3klww+KLxxe0q
         F6y8YC8wudGb/hoX++OIY0P7nXxHsng5k1uJQXy6mASUQz7o6M9go4EK+NX46bOky0bz
         6gfA==
X-Gm-Message-State: AOAM532QiH5UV3rdJWEJSFaT8lLF3f0CDDlBQSMFGuthR0WtVKWtPxPM
        c0RST5UH/vtVgjXgUczyUh387ID8Hu8aL7WA
X-Google-Smtp-Source: ABdhPJzMe+M+K032MspSF7lgH7TDybtV24Kh+mbI1qXTLJDF10a6mzTBqduU17AiwBTZpKscrNv8wQ==
X-Received: by 2002:ac2:5fef:: with SMTP id s15mr30017538lfg.425.1629828099541;
        Tue, 24 Aug 2021 11:01:39 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id u20sm1862106ljl.76.2021.08.24.11.01.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 11:01:38 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id i28so47322847lfl.2
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 11:01:38 -0700 (PDT)
X-Received: by 2002:a19:500e:: with SMTP id e14mr28777692lfb.487.1629828098025;
 Tue, 24 Aug 2021 11:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210824165607.709387-1-sashal@kernel.org> <20210824165607.709387-74-sashal@kernel.org>
 <CAHk-=wiQhb689WEk__vLy-ET4rL69cjq39pGTmrKam=c_0LYGg@mail.gmail.com> <YSUt8NdA+5EPJIyD@sashalap>
In-Reply-To: <YSUt8NdA+5EPJIyD@sashalap>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 24 Aug 2021 11:01:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgftHEoWsxidkWD3YodMVJKGuRz1JYG5=75-Rj6wbBwwg@mail.gmail.com>
Message-ID: <CAHk-=wgftHEoWsxidkWD3YodMVJKGuRz1JYG5=75-Rj6wbBwwg@mail.gmail.com>
Subject: Re: [PATCH 5.13 073/127] pipe: avoid unnecessary EPOLLET wakeups
 under normal loads
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        Sandeep Patil <sspatil@android.com>,
        Mel Gorman <mgorman@techsingularity.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 10:35 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Aug 24, 2021 at 10:00:33AM -0700, Linus Torvalds wrote:
> >
> >Honestly, I don't understand the performance regression, but that's
> >likely on me, not on the kernel test robot.
>
> I'll drop it for now.
>
> Ideally we wouldn't take it at all, but I don't think any of us wants to
> field "my tests have regressed!" questions for the next 5 years or so.

I have a theory about what is going on, and it's not a new problem,
but it would explain how that test might be so bimodal in performance
if you happen to hit the exact right timing. And the test robot just
might not have hit the right timing previously.

See

    https://lore.kernel.org/lkml/CAHk-=wiKAg5QtrQOtvKNwkRUn0b2xufO54GPhUoTWxBgDzXWNA@mail.gmail.com/

with a test-patch in the next message in that thread.

So it looks like another case of an odd test, but it should be easy
enough to make that test happy too. Knock wood.

             Linus
