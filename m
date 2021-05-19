Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1158389228
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 17:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhESPGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 11:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhESPGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 11:06:06 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC4CC06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 08:04:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i7so2623043ejc.5
        for <stable@vger.kernel.org>; Wed, 19 May 2021 08:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AIh3LPxhFUPUIJHux8vcxGYsWFeEVlxPbplmJRkb4OU=;
        b=qrIa0Nm9V/t9pk6g1i6yexCNcwW//lGzLTXb4MCUaGrntJtk0iaY1IHYr9t3wpY5vI
         Qe3lFBH4xbWIwutLCRQ7VrCmX0P+SC/TuZYnJrVTtyKA5aqFpikfOBT+PdOmrHuSQ6Vd
         cfWJ/TvI0kv3WyryGyqgFGImvdiQh8jyIQtjsN44jsIyBH4RtSw7yCCBhV+3vo/34DEF
         d3pEYu3CnzYJB0q2xRIKlxYLayV/Z8QNMaxUqs0wRgafs3sVH6fFl10L3mtVOBX+qccp
         iWYanUUnfTwIUVS7WyEMjRxkD4Kp4xASvRzsTGQC8qDAmwEzdyXapOb3f6eGAnIFnUO2
         CxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AIh3LPxhFUPUIJHux8vcxGYsWFeEVlxPbplmJRkb4OU=;
        b=t1cg6Kc4btMc2YlJzIMvct9z6LpSp6LSvgzxaibCCw6DlRmd/xck7XlrPW6YlQfEhs
         n1v88ZdO1hLq+sYIvK0pZuXky5+NO3pE2pmI0gtCVQu84IAJeRhb1c9zAHxXV9dO5Vji
         jKO+IqMJGYnrsqbyDvb17oepPtuKf9aMzDvWtPboUTYeaU/eFOOc4cPvIjnnOynWN5/4
         2trCaTnK6p4pyHsrd0PIdTR+r1IfKPg9+YbH2t8E3tk3krzNEx6XXXDsNaTph7SGRLDr
         WBflCUfIy/cC1gKrqfWb2PKX219WtkhJFlyST/BFlIInOouBl3qIznOEUknrDuYOhMZM
         hfXQ==
X-Gm-Message-State: AOAM531DE48WRqUwLHmyJok5O93eRJ4kzUiOfvEniSINcq9JPdQpjT2Q
        od8ZdfJ7Wb0b1ep4DTc0JJB8s2oe+kqAVfiiwE1GnA==
X-Google-Smtp-Source: ABdhPJy4po16yJDUE4DJ+brqx3On5vbmYSffXxAApMOaW490uyvlp7No8jeNdKyh9YxrKjsAGiz8RqBgxQkalrV4rPg=
X-Received: by 2002:a17:907:781a:: with SMTP id la26mr13095156ejc.435.1621436684760;
 Wed, 19 May 2021 08:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210519074323.665872-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20210519074323.665872-1-daniel.vetter@ffwll.ch>
From:   Jason Ekstrand <jason@jlekstrand.net>
Date:   Wed, 19 May 2021 10:04:33 -0500
Message-ID: <CAOFGe971P6K5_dQyNQtnZK3vp-3ax97-6Z9O87+5BFR+kiKmjg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/i915/cmdparser: No-op failed batches on all platforms
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org, Jason Ekstrand <jason.ekstrand@intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 2:43 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> On gen9 for blt cmd parser we relied on the magic fence error
> propagation which:
> - doesn't work on gen7, because there's no scheduler with ringbuffers
>   there yet
> - fence error propagation can be weaponized to attack other things, so
>   not a good design idea
>
> Instead of magic, do the same thing on gen9 as on gen7.

I think the commit message could be improved.  Maybe something like this?

When we re-introduced the command parser on Gen9 platforms to protect
against BLT CS register writes, we did things a bit differently than
on previous platforms.  On Gen7 platforms, if a batch contains
unsupported commands, we smash the start of the shadow batch to
MI_BATCH_BUFFER_END to cancel the batch.  If it's mostly ok
(-EACCESS), we trampoline to run in unprivileged mode and let the
limited HW parser handle security.  On Gen9, we only care about
rejecting batches because we don't trust the HW parser for a few cases
so we don't need this second trampoline case.

However, instead of stopping there and avoiding the trampoline, we
chose to avoid executing the new batch all together on Gen9 by use of
dma-fence error propagation.  When the batch parser fails, it returns
a non-zero error and we would propgate that through the chain of
fences and trust the scheduler to know to cancel anything dependent on
a fence with an error.  However, fence error propagation is sketchy at
best and can be weaponized to attack other things so it's not really a
good design.  This commit restores a bit of the Gen7 functionality on
Gen9 (smashing the start of the shadow batch to MI_BB_END) so that
it's always safe to run the batch post-parser.  A later commit will
get rid of the error propagation nonsense.

>
> Kudos to Jason for figuring this out.
>
> Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
> Cc: <stable@vger.kernel.org> # v5.6+
> Cc: Jason Ekstrand <jason.ekstrand@intel.com>
> Cc: Marcin Slusarz <marcin.slusarz@intel.com>
> Cc: Jon Bloomfield <jon.bloomfield@intel.com>
> Relates: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_cmd_parser.c | 34 +++++++++++++-------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
> index 5b4b2bd46e7c..2d3336ab7ba3 100644
> --- a/drivers/gpu/drm/i915/i915_cmd_parser.c
> +++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
> @@ -1509,6 +1509,12 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
>                 }
>         }
>
> +       /* Batch unsafe to execute with privileges, cancel! */
> +       if (ret) {
> +               cmd = page_mask_bits(shadow->obj->mm.mapping);
> +               *cmd = MI_BATCH_BUFFER_END;
> +       }
> +
>         if (trampoline) {
>                 /*
>                  * With the trampoline, the shadow is executed twice.
> @@ -1524,26 +1530,20 @@ int intel_engine_cmd_parser(struct intel_engine_cs *engine,
>                  */
>                 *batch_end = MI_BATCH_BUFFER_END;

Bit of a bike shed but, given the new structure of the code, I think
it makes it more clear if we do

if (ret == -EACCESS) {
   /* stuff */
   __gen6_emit_bb_start(...);
} else {
   *batch_end = MI_BATCH_BUFFER_END;
}

That way it's clear that we're making a choice between firing off the
client batch in privileged mode and ending early.

>
> -               if (ret) {
> -                       /* Batch unsafe to execute with privileges, cancel! */
> -                       cmd = page_mask_bits(shadow->obj->mm.mapping);
> -                       *cmd = MI_BATCH_BUFFER_END;
> +               /* If batch is unsafe but valid, jump to the original */
> +               if (ret == -EACCES) {
> +                       unsigned int flags;
>
> -                       /* If batch is unsafe but valid, jump to the original */
> -                       if (ret == -EACCES) {
> -                               unsigned int flags;
> +                       flags = MI_BATCH_NON_SECURE_I965;
> +                       if (IS_HASWELL(engine->i915))
> +                               flags = MI_BATCH_NON_SECURE_HSW;
>
> -                               flags = MI_BATCH_NON_SECURE_I965;
> -                               if (IS_HASWELL(engine->i915))
> -                                       flags = MI_BATCH_NON_SECURE_HSW;
> +                       GEM_BUG_ON(!IS_GEN_RANGE(engine->i915, 6, 7));
> +                       __gen6_emit_bb_start(batch_end,
> +                                            batch_addr,
> +                                            flags);
>
> -                               GEM_BUG_ON(!IS_GEN_RANGE(engine->i915, 6, 7));
> -                               __gen6_emit_bb_start(batch_end,
> -                                                    batch_addr,
> -                                                    flags);
> -
> -                               ret = 0; /* allow execution */
> -                       }
> +                       ret = 0; /* allow execution */
>                 }
>         }
>
> --
> 2.31.0
>
