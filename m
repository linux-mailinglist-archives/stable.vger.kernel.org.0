Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE46B409BA5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346178AbhIMSDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 14:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346243AbhIMSDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 14:03:24 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26AAC061760
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:02:05 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g8so15644841edt.7
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Qkth7woyLAVIJdWp+l8uz/eF+3cl4KMIagT6yeHJcs=;
        b=MinFidCnrduDGXC5mBb+NPraRLlqsfI93t+fXxh+y6N8rd5/K0E9dCbG3uPEvo/082
         MDOc7fv4v0jfyxuOs9yWH30VaV0kdU9/QcwetUalRgD7YtKHUgfUIp4ELNAnI4PO/Shz
         vgOHB26JzTKIjDYug0X3DNXr7p5e+9K4NmnWQ3qwUh9fEbN8U3ltnImWJLhyAjF0GsXI
         ABvaPbIDdzjjmrwD+q9yppJRrKEPKbiAPnSsJdDPdiUfsEHYznF5piBISZ6sciRh/itM
         0xvUbYt5pDNCROZxNUh9WvisFk8JHQ/iP0P0D4wv8v+utv2BR2uLaO7fHhZ41OwCAy8k
         B5Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Qkth7woyLAVIJdWp+l8uz/eF+3cl4KMIagT6yeHJcs=;
        b=Eir6hrXRoFI1qSZj9H6FtEleHxIpSEnbQFO1cf5+mN78MzMNbMPoheadNre+apNK8M
         rpDZZbsIlj+rR3nr8S4Nl0LvE3tdjBorVNd4PklQeeSgChOlayaNf6CpOS7wghOK0rSk
         2sjDKASWftodpGUWaaCKQl5JYCqCqytSNzItO59EqXSfq49IEdb3hZnd95oG29DyLFo0
         q4vy7gDk+A9EMFhhWGOcAIlrBQZ1yLXeV5jCBnxZCN8eCNjSpT+G/seQC5xegOjWpGqP
         KZ1ZxAtkAA1pv94/KCcNze0na29eEjD9FZG4KDzkg7FYiDLJ3sZLU4hL4rAHKrGkhQ8o
         pJiA==
X-Gm-Message-State: AOAM533q5zUNJidzPW01/er1IvAQXX60SFlVez5ojwhYjwyjr5foRFXT
        9FhPFX/HLYIRMwcIAbfVfs77OwIfpqRhdQj9/1EUDg==
X-Google-Smtp-Source: ABdhPJyLWma6j5HJ2oNefPP9FqgeO0QHxx6F012Rn57fMjXDf02G3TY8321grWfexwEtUaVC7ICAvi0xc2L12iQcFa8=
X-Received: by 2002:a05:6402:2695:: with SMTP id w21mr14486313edd.182.1631556124338;
 Mon, 13 Sep 2021 11:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131109.253835823@linuxfoundation.org>
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 13 Sep 2021 23:31:52 +0530
Message-ID: <CA+G9fYuhgknV+hEpeyEN8xCEbY_dspFsTU=-XpH4vKEMqMiRmg@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/300] 5.13.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Sept 2021 at 19:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.17 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


arm clang-10, clang-11, clang-12 and clang-13 builds failed.
on 5.14 and 5.13 on following configs,
  - footbridge_defconfig
  - mini2440_defconfig
  - s3c2410_defconfig

This was already reported on the mailing list.

ERROR: modpost: "__mulodi4" [drivers/block/nbd.ko] undefined! #1438
https://github.com/ClangBuiltLinux/linux/issues/1438

[PATCH 00/10] raise minimum GCC version to 5.1
https://lore.kernel.org/lkml/20210910234047.1019925-1-ndesaulniers@google.com/

linux-next: build failure while building Linus' tree
https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/

Full build log,
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1585407346#L1111

--
Linaro LKFT
https://lkft.linaro.org
