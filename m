Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A750395694
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 09:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhEaH6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 03:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhEaH6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 03:58:09 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571D3C06174A
        for <stable@vger.kernel.org>; Mon, 31 May 2021 00:56:29 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g38so15406238ybi.12
        for <stable@vger.kernel.org>; Mon, 31 May 2021 00:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dilrtLr3zjphWdQrzku4NUDfByxzeEz4NkV/4/jNn9U=;
        b=yffH1s0WaZhngMYcrXxfxnt3A7z1WBk4rjqZuumP7o1Q1/7bKiZnWiBIuCh8AtBUbq
         sMURmU1EgtTC4N5iUTijnoR+cz0ePmHTu6bqXklpC1mjak+sWKsK+9ecd6C2tKqVv2XD
         gavr/X4u5fV1PKfdACvKQu0Jk5sqvtXeXQbInVvnwh1ilIERdtDQb9xbtjKvUWynGDDU
         QTOQbKr0J7Ac1zXRd/yeZg9RE/5QdVbenBrrkA6N1jp64Uk9uZUOfk2VQaTAPnugmU24
         ZzxDmmtG9uPyEPURrN1XVVolcfXhdj8aRJkeey/4AFFA79ju4VtMGg+Dgwcqa1piLXM3
         1yHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dilrtLr3zjphWdQrzku4NUDfByxzeEz4NkV/4/jNn9U=;
        b=fHgJswxlKjeHUFGPkiEQx9invocwiJCgzhkqCzi2gw//HSYYQPgEPYd1aiuQInp+Kh
         7b6guaLpaml9LjNFBIYZnArFNqEDEWr9elTC1+D/b1GJOVN/bgERXkrrH0jXWGDinpZf
         jtKUcCUlpwuA2csEcm3CqnUxYHR55KL93ZNQmiJzlNWjLs8gszIY1okNITK2qWu43P+8
         lpqDh4Y8M3/AIRNTfpXXgZs/bsHd+OkcWekKCf3mr0aZrUtQPS9h+MsKHtoAJAdyvgRw
         QlGrMLbbs6I+A+pwR9TRelHRLyD5YeEtXvApnF1GVIPlyNmsZ9+xsQWB7hj6L0JNbVXk
         +Nbw==
X-Gm-Message-State: AOAM5306LvwlDJZYwvgPjNxN+TOUQzJfbMJ0R7ykP3A1d0Tbcp5SFlOw
        C7xqgplY0IGrKvkZ8Mdg7SwLeClyHQwwB5WCRBGC0lxb9dA=
X-Google-Smtp-Source: ABdhPJzABZ3dI4p3+7NQhR2cykxqZeq7MfUrdg5tOUWxYw/7vn7Q9RdQkoQg/dZIgJx6uwSVpchb6v5rGaz0OdEu7rE=
X-Received: by 2002:a25:6c0a:: with SMTP id h10mr28630893ybc.167.1622447788582;
 Mon, 31 May 2021 00:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210528113102.655950-1-amit.pundir@linaro.org> <YLOD9+JjgfH9TB1T@kroah.com>
In-Reply-To: <YLOD9+JjgfH9TB1T@kroah.com>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Mon, 31 May 2021 13:25:52 +0530
Message-ID: <CAMi1Hd186U2HcUDJm2UjmCVnbfwYQ666cR9HZ7uiHQvDSXn0hg@mail.gmail.com>
Subject: Re: [PATCH for-5.10.y] drm/msm/dpu: always use mdp device to scale bandwidth
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 30 May 2021 at 17:54, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, May 28, 2021 at 05:01:02PM +0530, Amit Pundir wrote:
> > From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> >
> > [ Upstream commit a670ff578f1fb855fedc7931fa5bbc06b567af22 ]
> >
> > Currently DPU driver scales bandwidth and core clock for sc7180 only,
> > while the rest of chips get static bandwidth votes. Make all chipsets
> > scale bandwidth and clock per composition requirements like sc7180 does.
> > Drop old voting path completely.
> >
> > Tested on RB3 (SDM845) and RB5 (SM8250).
> >
> > Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > Link: https://lore.kernel.org/r/20210401020533.3956787-2-dmitry.baryshkov@linaro.org
> > Signed-off-by: Rob Clark <robdclark@chromium.org>
> > Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> > ---
> > Fixes dpu_runtime_resume() WARN_ON on db845c/RB3 (sdm845),
> > introduced by the backport of upstream commit 627dc55c273d
> > ("drm/msm/disp/dpu1: icc path needs to be set before dpu
> > runtime resume") on v5.10.y.
> >
> >  drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c  |  3 +-
> >  drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c | 51 +-----------------------
> >  2 files changed, 2 insertions(+), 52 deletions(-)
>
> What about a version of this for 5.12?  I can't take one for 5.10 and
> not a newer kernel, right?

My bad. I'll verify/smoke-test it on 5.12 as well and resubmit.

Regards,
Amit Pundir

>
> thanks,
>
> greg k-h
