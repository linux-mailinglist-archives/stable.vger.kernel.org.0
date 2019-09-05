Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D62A9817
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 03:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfIEBpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 21:45:01 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44742 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfIEBpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 21:45:01 -0400
Received: by mail-oi1-f194.google.com with SMTP id w6so432495oie.11
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 18:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kOF+ZPHpYR3Xq1yEKnmzXHsOmTQNpIQkThMXvnUhVnc=;
        b=L+wWW+zqfhvIK5s50CRQN9eMZcVRT3Jh5t+ZjUc2Wt5L7v0CeTyHEFh6irH8z7niKo
         JCq/2CckgEaRzgtT9BJ1H5qP0GBJ3HtrjQ5Ifn17S2utsp59l/WzQq5YSvZT5GHSBX2O
         KyQ1ybyjX5Yg9SmMRVFTrG5GzXWNkAzVOWFwSCKe53W9eK5VBIsYbCiWGp2XTHUI90BZ
         C0mWjQsrL07iTQ1XvMRKfg9eD8fDoX7qXRzIV56G7N9xhlDdHpBWTj2XPb8DxolG1VM3
         2wY09qTLZTJUmN22H6lJcH0dGsFCQdY0ThP6meYY8D+9zQgHjyJzLMG7xSnjaeD5lbTu
         YwKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kOF+ZPHpYR3Xq1yEKnmzXHsOmTQNpIQkThMXvnUhVnc=;
        b=MLY45P3M2VzkaFGFl+hmt64l1ZwezGjVQq5Cn9LtGYf2dEZDdkQpfRkq0PNbtznW1f
         wHAWI53DIaUucq5PGq2XFtxB80Y8rksGHpGBSe7PnN8BldL5FrOAQ2m/v5jh7es5Wyfe
         AL90BG7DQJbBdCVfiRJhbWEHHC6XHTklyyOQiUiHHn3f4Neq2zT24FdaRefIefoJemvQ
         fdnOTVSNZpW7u08+2hWBqno/yLKg12SUugcsBd7tTTndocl1j7pOSOJ4y8T71gSlHF2x
         XQ7wqdSZVX2pZvJyavsFYlanqTMGswcgL/Z9vD6TSSogx1CYmMaDUZodbYgcKtUX/HVh
         Df9Q==
X-Gm-Message-State: APjAAAURQdxxBXCYY4FencpIrQhj8a0k5TLB3Rwxvqbd2Roc3LyolfSw
        Ko0xy2DIJSlQVjW8G1wA8CvENEPAgiwtoyTKiTEltw==
X-Google-Smtp-Source: APXvYqzfiqJq/DMGiXcEwCOAMX5aRkF63SEJA1OgBe7uOUrr5rCBSNyt2Orw+TH4LR2eUQun3bC3KcwkSlZ/jlhrL7E=
X-Received: by 2002:aca:f48e:: with SMTP id s136mr746525oih.57.1567647899440;
 Wed, 04 Sep 2019 18:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1567492316.git.baolin.wang@linaro.org> <5723d9006de706582fb46f9e1e3eb8ce168c2126.1567492316.git.baolin.wang@linaro.org>
 <878sr442t8.fsf@intel.com>
In-Reply-To: <878sr442t8.fsf@intel.com>
From:   Baolin Wang <baolin.wang@linaro.org>
Date:   Thu, 5 Sep 2019 09:44:48 +0800
Message-ID: <CAMz4kuJVTaDnDEKD77G_X=iVZf98e3isgSt0w7Yvb+_KnSfc9Q@mail.gmail.com>
Subject: Re: [BACKPORT 4.14.y 1/8] drm/i915/fbdev: Actually configure untiled displays
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>, chris@chris-wilson.co.uk,
        airlied@linux.ie, Vincent Guittot <vincent.guittot@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Orson Zhai <orsonzhai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Sep 2019 at 21:19, Jani Nikula <jani.nikula@linux.intel.com> wrote:
>
> On Tue, 03 Sep 2019, Baolin Wang <baolin.wang@linaro.org> wrote:
> > From: Chris Wilson <chris@chris-wilson.co.uk>
> >
> > If we skipped all the connectors that were not part of a tile, we would
> > leave conn_seq=0 and conn_configured=0, convincing ourselves that we
> > had stagnated in our configuration attempts. Avoid this situation by
> > starting conn_seq=ALL_CONNECTORS, and repeating until we find no more
> > connectors to configure.
> >
> > Fixes: 754a76591b12 ("drm/i915/fbdev: Stop repeating tile configuration on stagnation")
> > Reported-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20190215123019.32283-1-chris@chris-wilson.co.uk
> > Cc: <stable@vger.kernel.org> # v3.19+
> > Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
>
> Please look into the scripts to avoid picking up stuff that has
> subsequently been reverted:

I am very sorry, I missed this patch had been reverted, I will check
why this revert patch was not in our product kernel. Thanks for your
comments.

>
> commit 9fa246256e09dc30820524401cdbeeaadee94025
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Wed Apr 24 10:47:56 2019 +1000
>
>     Revert "drm/i915/fbdev: Actually configure untiled displays"
>
>     This reverts commit d179b88deb3bf6fed4991a31fd6f0f2cad21fab5.
>
>     This commit is documented to break userspace X.org modesetting driver in certain configurations.
>
>     The X.org modesetting userspace driver is broken. No fixes are available yet. In order for this patch to be applied it either needs a config option or a workaround developed.
>
>     This has been reported a few times, saying it's a userspace problem is clearly against the regression rules.
>
>     Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=109806
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
>     Cc: <stable@vger.kernel.org> # v3.19+
>
>
>
> BR,
> Jani.
>
>
> > ---
> >  drivers/gpu/drm/i915/intel_fbdev.c |   12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
> > index da2d309..14eb8a0 100644
> > --- a/drivers/gpu/drm/i915/intel_fbdev.c
> > +++ b/drivers/gpu/drm/i915/intel_fbdev.c
> > @@ -326,8 +326,8 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
> >                                   bool *enabled, int width, int height)
> >  {
> >       struct drm_i915_private *dev_priv = to_i915(fb_helper->dev);
> > -     unsigned long conn_configured, conn_seq, mask;
> >       unsigned int count = min(fb_helper->connector_count, BITS_PER_LONG);
> > +     unsigned long conn_configured, conn_seq;
> >       int i, j;
> >       bool *save_enabled;
> >       bool fallback = true, ret = true;
> > @@ -345,10 +345,9 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
> >               drm_modeset_backoff(&ctx);
> >
> >       memcpy(save_enabled, enabled, count);
> > -     mask = GENMASK(count - 1, 0);
> > +     conn_seq = GENMASK(count - 1, 0);
> >       conn_configured = 0;
> >  retry:
> > -     conn_seq = conn_configured;
> >       for (i = 0; i < count; i++) {
> >               struct drm_fb_helper_connector *fb_conn;
> >               struct drm_connector *connector;
> > @@ -361,7 +360,8 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
> >               if (conn_configured & BIT(i))
> >                       continue;
> >
> > -             if (conn_seq == 0 && !connector->has_tile)
> > +             /* First pass, only consider tiled connectors */
> > +             if (conn_seq == GENMASK(count - 1, 0) && !connector->has_tile)
> >                       continue;
> >
> >               if (connector->status == connector_status_connected)
> > @@ -465,8 +465,10 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
> >               conn_configured |= BIT(i);
> >       }
> >
> > -     if ((conn_configured & mask) != mask && conn_configured != conn_seq)
> > +     if (conn_configured != conn_seq) { /* repeat until no more are found */
> > +             conn_seq = conn_configured;
> >               goto retry;
> > +     }
> >
> >       /*
> >        * If the BIOS didn't enable everything it could, fall back to have the
>
> --
> Jani Nikula, Intel Open Source Graphics Center



-- 
Baolin Wang
Best Regards
