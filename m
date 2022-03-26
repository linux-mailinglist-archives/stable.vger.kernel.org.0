Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6EE4E8036
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 10:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiCZJ53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 05:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiCZJ53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 05:57:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20B2D5;
        Sat, 26 Mar 2022 02:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1CCAB80171;
        Sat, 26 Mar 2022 09:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF376C340E8;
        Sat, 26 Mar 2022 09:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648288550;
        bh=9IneiZNLzEZanYVZtHa+eeAHI02Z5SLRz6bDCNPUHSU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XWuFHpykcaXFspA4hULJtVeAkD08kr9E2WTF3KdVoW8nGskkjJzhfDIjfnSNiY0Dk
         +5yl06dvJNF07RRTkc917veBwbW7/G4TFdN00pE5sFdi+q1ma8pA/uA1nSTVRKWo2t
         5RgwH0WqttYLMLM2zUpBbx9KOoxHIvHSnl/atDQo=
Date:   Sat, 26 Mar 2022 10:55:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Rob Clark <robdclark@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
Message-ID: <Yj7jI6uEtZDC5mQS@kroah.com>
References: <20220325150420.245733653@linuxfoundation.org>
 <CA+G9fYtayz_X5tjiCT4gWZNNG=O-zx6-GTLgtqH855RoYw_5xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtayz_X5tjiCT4gWZNNG=O-zx6-GTLgtqH855RoYw_5xw@mail.gmail.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 26, 2022 at 10:24:39AM +0530, Naresh Kamboju wrote:
> On Fri, 25 Mar 2022 at 20:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.17.1 release.
> > There are 39 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> arm64 qcom db410c device crashed [1]
> 
> [   10.823905] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [   10.876029] CPU: 1 PID: 193 Comm: kworker/1:2 Not tainted 5.17.1-rc1 #1
> [   10.876047] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> [   10.876054] Workqueue: pm pm_runtime_work
> [   10.876076] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   10.876087] pc : hrtimer_active+0x14/0x80
> [   10.876102] lr : hrtimer_cancel+0x28/0x70
> 
> 
> The following patch fixes the problem.
> 
> >From 05afd57f4d34602a652fdaf58e0a2756b3c20fd4 Mon Sep 17 00:00:00 2001
> From: Rob Clark <robdclark@chromium.org>
> Date: Tue, 8 Mar 2022 10:48:44 -0800
> Subject: drm/msm/gpu: Fix crash on devices without devfreq support (v2)
> 
> Avoid going down devfreq paths on devices where devfreq is not
> initialized.
> 
> v2: Change has_devfreq() logic [Dmitry]
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Reported-by: Anders Roxell <anders.roxell@linaro.org>
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> Fixes: 6aa89ae1fb04 ("drm/msm/gpu: Cancel idle/boost work on suspend")
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Link: https://lore.kernel.org/r/20220308184844.1121029-1-robdclark@gmail.com
> ---
>  drivers/gpu/drm/msm/msm_gpu_devfreq.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 

Now queued up, but note, this problem was already present in 5.17.0,
right?

thanks,

greg k-h
