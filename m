Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2A079A87
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 23:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfG2VBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 17:01:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38026 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbfG2VBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 17:01:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id f5so20032037pgu.5
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 14:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B1pxBQK50aNcVoP8CcZn7ZUgislLWflfkS2yonacWrE=;
        b=VEo7UP9bT9B9nfOoYCkdJEM5gW2QD7xnTf1vczhfC1oEl45RhkdRC46U4pzWzAX4fZ
         7EVJd2cUG0Y/UHEUPD1NhDd5mBoYSgJN2UFG5M4G80NIocIsRGYeh+Mc4GE8wY0mLqj+
         Lkr1Y1cdJ1955081Hsczt/ZGmipz5Y4e76Y1TmPkuhSPQ80VFYjhbqo0ZrrPHCDfxood
         BY7qvupauFyEKOyDwAxZXzpiBpVAK+flBTmTwq6iFInQ6LlHUajlYhhd7MlTVlslRohN
         pcrVivF8AhgMYZcy+AnLj/ZoA9NBMV4xuhmGgnc/houMPrSF8NMxX8qAVUuPCQd54eeY
         fdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B1pxBQK50aNcVoP8CcZn7ZUgislLWflfkS2yonacWrE=;
        b=O/8v3T5zShfxr+GKd0/qYWUuNHbWONyNVsid9uwUAp+ovKBQ/+2nM5KGQtg0rl/31h
         K9I+FOWSwkahXRDtE9mU/eZ/utptqzNbX6hGim89GF+SomR/g7LTo1tDaobu0UysgI8s
         Oilt3n/19NVFYEawk1zCEIrirUWoPlCPw+2dQ9a1s7gBuHhesTnAen5/nUOJtVDjqibG
         zjswEpI45dJ/M54LuTmjUrN6ns98BeiYclQQlITTJv8FsyJPMYbBXDr5X8+FJKx44aTN
         nXYFYZtzauFj/f4O5UF5i99KLKsRV34GU4+jCGrzTZmKmaPBwkzpunnOdnDH3zV8E7rC
         XyDw==
X-Gm-Message-State: APjAAAWRCH4T1dnGUevjwTuQCaeZ2NHqhcAIeMbIS2O+/WJH0bkWg/zH
        ZnlYhDgPuLlATZ18Y9kWWbjHhpBKPlZiwJKv4PIYFQ==
X-Google-Smtp-Source: APXvYqw6mpG+SmS3TWiNIlzXGS9ZhffK0hsjP9aY7A1YJzXMBuhs8W5WALBAkp89RL519hINz64n4mpxrDvJtK8e6Vk=
X-Received: by 2002:a17:90a:bf02:: with SMTP id c2mr114790294pjs.73.1564434079710;
 Mon, 29 Jul 2019 14:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190729190739.971253303@linuxfoundation.org> <20190729190753.998851246@linuxfoundation.org>
 <20190729205422.GH250418@google.com> <20190729205746.GI250418@google.com>
In-Reply-To: <20190729205746.GI250418@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 29 Jul 2019 14:01:08 -0700
Message-ID: <CAKwvOdmwaUN70e8TLDS4ZXvge7j1a--kYPPO0dm9ycPKLRqfvA@mail.gmail.com>
Subject: Re: [PATCH 5.2 083/215] net/ipv4: fib_trie: Avoid cryptic ternary expressions
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 1:57 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> On Mon, Jul 29, 2019 at 01:54:22PM -0700, Matthias Kaehlcke wrote:
> > Hi Greg,
> >
> > Toralf just pointed out in another thread that the commit message and
> > the content of this patch don't match (https://lkml.org/lkml/2019/7/29/1475)
> >
> > I did some minor digging, the content of the queued patch is:
> >
> > commit 4df607cc6fe8e46b258ff2a53d0a60ca3008ffc7
> > Author: Nathan Huckleberry <nhuck@google.com>
> > Date:   Mon Jun 17 10:28:29 2019 -0700
> >
> >     kbuild: Remove unnecessary -Wno-unused-value
> >
> >
> > however the commit message is from:
> >
> > commit 25cec756891e8733433efea63b2254ddc93aa5cc
> > Author: Matthias Kaehlcke <mka@chromium.org>
> > Date:   Tue Jun 18 14:14:40 2019 -0700
> >
> >     net/ipv4: fib_trie: Avoid cryptic ternary expressions
> >
> >
> > It seems this hasn't been commited to -stable yet, so we are probably
> > in time to remove it from the queue before it becomes git history and
> > have Nathan re-spin the patch(es).
>
> s/Nathan/Sasha/
>
> For some reason I thought Nathan backported this and wondered that his
> SOB is missing. The correct SOB is actually there.

I don't think Nathan explicitly tried to backport anything.  This
looks to me like AUTOSEL maybe took a commit message from a different
commit, and applied it to this diff.

ie. I don't think this is a bug in a manual backport, I think AUTOSEL
did something funny and created a backport with commit message A but
commit diff B.

-- 
Thanks,
~Nick Desaulniers
