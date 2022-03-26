Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8B74E80CD
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 13:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiCZM2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 08:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiCZM2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 08:28:22 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBF2292BB2
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 05:26:45 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2e5e31c34bfso106965477b3.10
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 05:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OdubKKvS/+X0BvpWnZIvBTVXh6dxmTwBC2Wu9k+snYg=;
        b=jBgNXZZx6q9gdohsCwdJ4HBLS6sr0rP60NUIa7V3mjojEaA/2kDjYWtqg81greawOj
         ZsrpSX1UwCsj5J2r0rAvtT7+7tJm8jmWrl56rbr/+7ieIusSwJ0H6Gqhh+eFj2aRwl/L
         BYny4ibB/edCt7Q9pyKAJbS8ddRZlHEChfQu86kbsaqKa09WQeJQmrJzHruwd/tnqys+
         2HoZYE/GE1TY1E8jN1xcNoxZL5LQM0N1kX7BijxwK9S7X+7DwW3+62eogPed+5kdFoDo
         yOcSmYG458boaJqkqvkvLumal9UHHD9Euf+wrihRti8pboTYsayU6SdqnPltv0L/JrOj
         XYgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OdubKKvS/+X0BvpWnZIvBTVXh6dxmTwBC2Wu9k+snYg=;
        b=cm6zmdstC8WFcEiW5ASJazt8y2FjOJZkgthjZDGPwZRr+BJdZhWz2SPwzCrti3Su1B
         H8T/SOGf3dnCyTi5cOLslwAHh7TtVzOo9RvhSPHFMkTULsQLMlHgWgqOEM0ODG99JKgC
         qSL5k81FD+SxNjkpeHtWdTqt1p6CFsxBdDYok0sYc5BiIwAEQn4Hgn1zOMSAoQaSDONu
         J7kDMZ0CavDDrhHxLtPQG/8U/aO35tUst2A72pj2dhty2Kmc5mGurtEB4U395nKLwwNC
         Bb1xNGmndoz/65sAAEu3cS5x/Wtq04pIQd265dSb4B3dh3hQAB3l4u9ApJSFYxTiZA7n
         Ky0Q==
X-Gm-Message-State: AOAM533UUBemf4JmlneNtzbFidW77Ne1Jnpqlf6nnJXLFfpjM6uXDB6J
        WpZC42rS9wXWvisKsucDueBkLjrVejH8pDJ6iHyFLQ==
X-Google-Smtp-Source: ABdhPJxJPXfPKtL3qIa8/Z/N1nIFDO7fGX3OlnFLcDsUZA88jJu9u2HRZgihQXw8nh4aVVyeBKwcWFnNn3sosQuPbac=
X-Received: by 2002:a81:591:0:b0:2e5:cdb0:9363 with SMTP id
 139-20020a810591000000b002e5cdb09363mr15970162ywf.265.1648297604618; Sat, 26
 Mar 2022 05:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150420.245733653@linuxfoundation.org> <CA+G9fYtayz_X5tjiCT4gWZNNG=O-zx6-GTLgtqH855RoYw_5xw@mail.gmail.com>
 <Yj7jI6uEtZDC5mQS@kroah.com>
In-Reply-To: <Yj7jI6uEtZDC5mQS@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Mar 2022 17:56:32 +0530
Message-ID: <CA+G9fYuPJyH4V1tJEt5P8FrF5w-NF470ZKOBM01nDeHczATqDA@mail.gmail.com>
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Rob Clark <robdclark@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 26 Mar 2022 at 15:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Mar 26, 2022 at 10:24:39AM +0530, Naresh Kamboju wrote:
> > On Fri, 25 Mar 2022 at 20:50, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.17.1 release.
> > > There are 39 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.1-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > arm64 qcom db410c device crashed [1]
> >
> > [   10.823905] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> > [   10.876029] CPU: 1 PID: 193 Comm: kworker/1:2 Not tainted 5.17.1-rc1 #1
> > [   10.876047] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> > [   10.876054] Workqueue: pm pm_runtime_work
> > [   10.876076] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [   10.876087] pc : hrtimer_active+0x14/0x80
> > [   10.876102] lr : hrtimer_cancel+0x28/0x70
> >
> >
> > The following patch fixes the problem.
> >
> > >From 05afd57f4d34602a652fdaf58e0a2756b3c20fd4 Mon Sep 17 00:00:00 2001
> > From: Rob Clark <robdclark@chromium.org>
> > Date: Tue, 8 Mar 2022 10:48:44 -0800
> > Subject: drm/msm/gpu: Fix crash on devices without devfreq support (v2)
> >
> > Avoid going down devfreq paths on devices where devfreq is not
> > initialized.
> >
> > v2: Change has_devfreq() logic [Dmitry]
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > Reported-by: Anders Roxell <anders.roxell@linaro.org>
> > Signed-off-by: Rob Clark <robdclark@chromium.org>
> > Fixes: 6aa89ae1fb04 ("drm/msm/gpu: Cancel idle/boost work on suspend")
> > Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > Link: https://lore.kernel.org/r/20220308184844.1121029-1-robdclark@gmail.com
> > ---
> >  drivers/gpu/drm/msm/msm_gpu_devfreq.c | 30 +++++++++++++++++++++++++-----
> >  1 file changed, 25 insertions(+), 5 deletions(-)
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
>
> Now queued up, but note, this problem was already present in 5.17.0,
> right?

Yeah.
This problem was there and then later it got fixed.

- Naresh
