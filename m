Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DB126CA97
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgIPUJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgIPReN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 13:34:13 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7331C0A893B
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 06:08:53 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a17so6858414wrn.6
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 06:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=boqFmJSvqYexxLobLNyh9qTrVnM8InJDrYRAbGJcCho=;
        b=PmsES2SARiy3RNMai1PKHwmsW52gv1/E88+yqUQ9Tv0jC62ZlRhBcsmzE3b4ti/83J
         r967Z58Yh8Cq5xasJ5umEjNwsnfDwjz2P6JpvpSZxUi5Hpu8xv08QlwTCltKOHoDtSZR
         of5GhwBlvKJLkJX0yM3FjWHxODmE3o+/AWfrJFfAlwuoIa+cZjjbbAB2S77mUnpl/nzz
         IEARN45BnQqyfl3YrVY+FFSj3o2L5Kwft3L6/7+JH5t6W08YP+9B9PvrfNUDcxhXqwhK
         bGp+rdUw4xXROyTT7ev5ufpUQ5a1W57gboULd52Ki4ZQQ8vQ/nGMbr8yEOkW5K8bmwXY
         JvBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=boqFmJSvqYexxLobLNyh9qTrVnM8InJDrYRAbGJcCho=;
        b=F1JFJuCBuvwypGwtPENumgbWaaCZygTQ3e53tANIz3CS97S25AALw8YzTf/FEhpPS2
         qZlhbc8kCalpZ2AH8YGWay3E+7zzmkktCDvFqnoRUOFHdGutx/TO7ojpuItc9FfKKvLE
         70tC9CbtplYkB9bHqbBw+imA/4gX76b306h0HgJCax4zYFBbZ21F7AkhZdJ+uT90MmS1
         Sidlw9Bvpc4bQ5o6SbsinWdDVLAiHygkIUQDT7aeFezoOI+j/zwhX9Vm3D0IRMHzTUf0
         I9h+Xezt20U0mKg0ImfA0/tmPDmQoLmQ7za1OprbauszdQdA57JbBvzc++YyW83M5foi
         4aNg==
X-Gm-Message-State: AOAM5329p+ufqKm9V1w8Y3Za3Hc70p0AqTZV5tsRRShvYwJgqI/p8qua
        MGk2j6CkgALr9KXYRPHFtLjhYVOzEQCsunWZ7qXcymMrBRE=
X-Google-Smtp-Source: ABdhPJyn/PJ7xHU8ZYPwNfmhW+wrz8y3cokw/6HfKfyVIclqmJYVI81DT7pBaNF79qcayK5F8vAfGKFPbwm8P2+ByXQ=
X-Received: by 2002:adf:dd82:: with SMTP id x2mr28315368wrl.419.1600261731057;
 Wed, 16 Sep 2020 06:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200915184607.84435-1-alexander.deucher@amd.com> <20200916063300.GJ142621@kroah.com>
In-Reply-To: <20200916063300.GJ142621@kroah.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 16 Sep 2020 09:08:39 -0400
Message-ID: <CADnq5_ObvQ9sT_p=mdEk1m_o_LPHx6zwiEP5qFvX9YxveOBOZA@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/radeon: handle PCIe root ports with
 addressing limitations"
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        "for 3.8" <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Christian Koenig <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 2:32 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Sep 15, 2020 at 02:46:07PM -0400, Alex Deucher wrote:
> > This change breaks tons of systems.
>
> Very vague :(

Screen corruption making the system unusable.

>
> This commit has also been merged for over a year, why the sudden
> problem now?
>

It was noticed by several people closer to when the change went in as
well.  If you notice, most of the bugs date back quite a while.  We
looked into it a bit at the time but couldn't determine the problem.
It only seems to affect really old chips (like 15-20 years old) which
makes it hard to reproduce if you don't have an old system.  There
were a couple of threads at the time, but nothing was resolved.  I was
able to find one of them:
https://lkml.org/lkml/2019/12/14/263

There were several new bugs filed which brought the issue back to my
attention recently.

> > This reverts commit 33b3ad3788aba846fc8b9a065fe2685a0b64f713.
>
> You mean "33b3ad3788ab ("drm/radeon: handle PCIe root ports with
> addressing limitations")"?
>
> That's the proper way to reference commits in changelogs please.  It's
> even documented that way...

When you revert a patch with git, that is what it does.  Maybe we
should fix git to change the formatting.

>
> >
> > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206973
> > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206697
> > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=207763
> > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1140
> > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1287
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: stable@vger.kernel.org
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: christian.koenig@amd.com
>
> Fixes: 33b3ad3788ab ("drm/radeon: handle PCIe root ports with addressing limitations")
>

Sure, I can add that, but it doesn't really fix it, it reverts it.
But point taken, it does fix the commit by removing it.

Alex

> as well?
>
> thanks,
>
> greg k-h
