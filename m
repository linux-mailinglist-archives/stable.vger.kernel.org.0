Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DED431F5B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhJROWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbhJROV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 10:21:59 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99502C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 07:19:48 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y12so74130875eda.4
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 07:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4kzpTT/6tMfUQMXH1wztV9MJS5+YGPyX5BmUdJCkav4=;
        b=Jgqy1qoKOY7Ka3R/KvTSh6OItX6AdF8TObbqtYACqaHvTlP8Kyp+k+E7AvvJmTpnrE
         5+SRp2lpY/feSGIZh7GYeQ1Me8hd0xL4h0e+zhOdOCfVxZ7birPC5ZE5FcSeAsFYMgZp
         rnpsHV4cg+31atAGMVz8KWpf4iZLetEWe8mvi4+1856uD1rs8tqFrnxhnY3Z3u4gT8aY
         eBE+JMTaQ1Nho7elaFtyXpQlP5YvGuaRQ9W9nIRWe7+NnweUGEiED2j3Cem0gJRH6MsX
         iVwXd1sgtpdR+a1vjrOQC09TzESMUiOUgQ5M7xGYCpx8KOaWdwnGauiA0WUPq+TH0P4y
         +gDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4kzpTT/6tMfUQMXH1wztV9MJS5+YGPyX5BmUdJCkav4=;
        b=lF/fAbyvBNDzvPXEbjYyqGylg3DtAjQEdDeDjuONrHgH2krYlpGEW14fcNNpyGvpGH
         BTNG8bHa2Jpt2y2fchLc6yoVpux+yn8qP8JrMNTf+KRHQN+E1BXqoT2GH8iDGqitXzc5
         GQf0Y4ZHeMZu+oNp9+o8xxxX1E4WSb6hn3Y4xsj3xAheq9P3DE8XdTNqzHOam1ICtyw6
         UmidPov95a7FAT4OoCnknznRbS5awiO8sr28kxFCK/wEe9MChmhdomfIjR5nJXi2sshz
         Ri4X2FxEaCasQ/MYwNDeaUbtypayxBCL0xf+/PJUwkfsQSPKF/R2JrdH6qRPkvdFSOHZ
         Ez0Q==
X-Gm-Message-State: AOAM530Foqf/SIz5JjTlkrrs4dx23+qIrzTM8gFW9DHmolzJ8EYmdYAC
        7gjDfKlMpEhIZitWjsy2XnvoJN8PV8y4XWqIZIXrgw==
X-Google-Smtp-Source: ABdhPJxBlZDy8o5CRAKec/1c+qblX1HV3WbpKyNVu8UD/q7oq6DTGd38JCETez9w12f/WtR90Uwv1Rh92R8AljxNtn8=
X-Received: by 2002:a50:9993:: with SMTP id m19mr43940380edb.357.1634566670741;
 Mon, 18 Oct 2021 07:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211018132326.529486647@linuxfoundation.org>
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 18 Oct 2021 19:47:38 +0530
Message-ID: <CA+G9fYt2KddbTHMTe1WmvSg8v04UpdTKJOM5xvS2m0FiBo3-=A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/50] 4.19.213-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 at 18:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.213 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.213-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build errors noticed while building Linux stable rc
with gcc-11 for arm and arm64 architecture.

> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/mdp5: fix cursor-related warnings

  - 5.4.154 gcc-11 arm FAILED
  - 5.4.154 gcc-11 arm64 FAILED
  - 4.19.212 gcc-11 arm FAILED
  - 4.19.212 gcc-11 arm64 FAILED

drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1058:31: error:
'mdp5_crtc_get_vblank_counter' undeclared here (not in a function);
did you mean 'mdp5_crtc_vblank_on'?
 1058 |         .get_vblank_counter = mdp5_crtc_get_vblank_counter,
      |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                               mdp5_crtc_vblank_on
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1059:27: error:
'msm_crtc_enable_vblank' undeclared here (not in a function); did you
mean 'drm_crtc_handle_vblank'?
 1059 |         .enable_vblank  = msm_crtc_enable_vblank,
      |                           ^~~~~~~~~~~~~~~~~~~~~~
      |                           drm_crtc_handle_vblank
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1060:27: error:
'msm_crtc_disable_vblank' undeclared here (not in a function); did you
mean 'mdp5_disable_vblank'?
 1060 |         .disable_vblank = msm_crtc_disable_vblank,
      |                           ^~~~~~~~~~~~~~~~~~~~~~~
      |                           mdp5_disable_vblank
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1061:10: error: 'const
struct drm_crtc_funcs' has no member named 'get_vblank_timestamp'
 1061 |         .get_vblank_timestamp =
drm_crtc_vblank_helper_get_vblank_timestamp,
      |          ^~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1061:33: error:
'drm_crtc_vblank_helper_get_vblank_timestamp' undeclared here (not in
a function)
 1061 |         .get_vblank_timestamp =
drm_crtc_vblank_helper_get_vblank_timestamp,
      |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1061:33: warning: excess
elements in struct initializer
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1061:33: note: (near
initialization for 'mdp5_crtc_no_lm_cursor_funcs')
make[5]: *** [scripts/Makefile.build:262:
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.o] Error 1
make[5]: Target '__build' not remade because of errors.
make[4]: *** [scripts/Makefile.build:497: drivers/gpu/drm/msm] Error 2
make[4]: Target '__build' not remade because of errors.
make[3]: *** [scripts/Makefile.build:497: drivers/gpu/drm] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [scripts/Makefile.build:497: drivers/gpu] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [Makefile:1734: drivers] Error 2
make[1]: Target '_all' not remade because of errors.
make: *** [Makefile:179: sub-make] Error 2


Build config:
https://builds.tuxbuild.com/1zgK0LewhdaH7jb2PYiEaTFPgT9/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


steps to reproduce:
https://builds.tuxbuild.com/1zgK0LewhdaH7jb2PYiEaTFPgT9/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
