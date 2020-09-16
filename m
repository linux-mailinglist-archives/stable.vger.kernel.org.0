Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6971026CE7C
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 00:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgIPWQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 18:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIPWQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 18:16:38 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9F6C061221
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 15:16:37 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id m6so8490155wrn.0
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 15:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UZJbHM5GLEFqmZf5YDukzyyKsuKMxt478ZSZuSRvZkc=;
        b=YbgcezctoTpesK9Vn+Fu+mwCd3hsWbIDEU52IQdslrUb+Ap876SC5v6UMOP1IX8p5n
         iAUxfp7X/v8PzvUtRalX00PMuk3Bcazksi2CFRRHk9kTmBk1JQZM6E+AHFPV2669eoWK
         L2Q0lFNgaPncWusmuNe/EAQOdTa1svzqvQNf1Sfao/PNu1IanjU5D0WbQ8F7yZc5yM19
         GlKcc9JW0gYfjpK6/tBe8mR+Xlkenwd/ZxzdjS1ZTTR2tfcj/7LpixCAFfZkXr5fAPNe
         1xrHmhnLZ4866sEs+12id4RJbmrhNBfQ2JFLNnjMyiI7FmaLPlKvSdrKwqGxqSBrW1k/
         D+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UZJbHM5GLEFqmZf5YDukzyyKsuKMxt478ZSZuSRvZkc=;
        b=Wy+H68CCsow3wwJwnVzW/WhZo0Zan5YWpPMGcKHWdBIO+HhPPE9sXhKR6J5LJwmIMz
         P1/4TaNY1FkkN1MWvZfuKu84sPitfFQkUMzHmTd8dsH/Lfj0HYfs+dpHyzYv0/Pji/ic
         9qPMZT33ZjVPnanw+gM/lSzxkYKTAMrh1QJHArnvGjDOcySMGHqNJ79yKpn0DqO3n/qx
         sDeHLeMA1EV6uK33bsLf7vs6CACxRQ2QJqaLBw/LZ27pZqr6yGG/blNuXKkLBPf7ZKg2
         clKKi8t4wP0MSH1Xl83NoKFe0f6BrZuIcv+aUf2b0DQIupwnD+XTK5ReroUYULQAkgIA
         9Pgg==
X-Gm-Message-State: AOAM532pCKgs5iXY6wqL4DA1SH54K97hQDhClGr2jpRf0eneQzP/EPob
        zX3s/JWcayL9COXLHIYWyPe/AVq2rX7j2NttHKM=
X-Google-Smtp-Source: ABdhPJxHLm+4tK1Ak7NtwFEzBVza8jJx93jLiSVjLTLjmnzQSGAEncFXw7Q3jKCRhc1iUiswX6J9NJnhg4Nt9Tm43lU=
X-Received: by 2002:adf:ef0a:: with SMTP id e10mr28518162wro.362.1600294596003;
 Wed, 16 Sep 2020 15:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200915184607.84435-1-alexander.deucher@amd.com> <20200916070436.GA9392@lst.de>
In-Reply-To: <20200916070436.GA9392@lst.de>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 16 Sep 2020 18:16:25 -0400
Message-ID: <CADnq5_P9nEZDiB0Fx_tsK1GCB_NJ-AOnx7Fd=706tZ4aKrmPzA@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/radeon: handle PCIe root ports with
 addressing limitations"
To:     Christoph Hellwig <hch@lst.de>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        "for 3.8" <stable@vger.kernel.org>,
        Christian Koenig <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 3:04 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Sep 15, 2020 at 02:46:07PM -0400, Alex Deucher wrote:
> > This change breaks tons of systems.
>
> Did you do at least some basic root causing on why?  Do GPUs get
> fed address they can't deal with?  Any examples?
>
> Bug 1 doesn't seem to contain any analysis and was reported against
> a very old kernel that had all kind of fixes since.
>
> Bug 2 seems to imply a drm kthread is accessing some structure it
> shouldn't, which would imply a mismatch between pools used by radeon
> now and those actually provided by the core.  Something that should
> be pretty to trivial to fix for someone understanding the whole ttm
> pool maze.
>
> Bug 3: same as 1, but an even older kernel.
>
> Bug 4: looks like 1 and 3, and actually verified to work properly
> in 5.9-rc.  Did you try to get the other reporters test this as well?

It would appear that the change in 5.9 to disable AGP on radeon fixed
the issue.  I'm following up on the other tickets to see if I can get
confirmation.  On another thread[1], the user was able to avoid the
issue by disabling HIMEM.  Looks like some issue with HIMEM and/or
AGP.

Alex

[1] https://lkml.org/lkml/2019/12/14/263
