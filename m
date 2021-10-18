Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7E8431F54
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhJROUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhJROUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 10:20:00 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378DEC06176E
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 07:14:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w19so71493110edd.2
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 07:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gfY30mrzkB8EYmJe8E/WnPNZJiWGvRlD38ny+9lSaX8=;
        b=jLs1PzXszpxhN4Hgo1mxcvdZcIHVN1gMn10TqswZuPn1sVdYVH/WnatG2hPEQtBjAN
         8pTk4lNPqvOrDmlBVqBRHsOzM10BS3Dj2ZdifeCT9BmH6b1pItgVDp9xWamQCN3Pxyw/
         cfAHSMhcOFVATPEjN5vmq2IMKSVt7gjpoUdB8BSEzAB7km2uzyUSEzkqoOe4co6mrYfo
         NHPMPv7TbHsAeaMUjmu6N1IKQp3uV19frCEGyGBLSU9XHhYyN8m2jdb2/i2qnFD+ON5b
         nHx+NYfdJ+rqGJnz1LO0v+vLBvpxcPncFB5TORiRWNR1Cg1ueeNSkVUlIPkFxykNBUMc
         HanQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gfY30mrzkB8EYmJe8E/WnPNZJiWGvRlD38ny+9lSaX8=;
        b=qNWWxunjcPIS1isqdJXJY+f9fQrUdC2slz2bwGu+xJ80+jHaJLj5TjiegbRUMyVXyP
         +A5rDvHG55fqfVs+y0aAcl+Sp+x/PNq1S+TVRgx6+9SLbfnt+vpcmGRzqIef2Jtr+97P
         TItPjqblMPKEfAlAgv+hx1cULHoB9FH84esdOuPdofPyOWwaIIL7qWFkc1KNTBYqjq20
         Rti3sc7R3r5T2XVm9BB0HcmFexP0KLf4VcbVdtZQHzXNoyVNAh35Gk8ztQ7eE0s9Gbhs
         mBcNbvRmdsyXLCX9mqAtKBOebtmWmLUNok73a5GkNdBLurY0we44IOFfxO1gcn/wfaoE
         +mLQ==
X-Gm-Message-State: AOAM532t5muJGioJxGMJVSCJo8/7mkjHgNyDLYGjOXrtUQI1JwAp2O46
        hr43dLi/85NW1OtKUwKin9iVEsnGjZLEdkLkeQjWxg==
X-Google-Smtp-Source: ABdhPJzd7rvNdB/D+PBaeEELwmyK5O6ELXrEeoM/eDkQdv5qxjZjjpAtOcRU3Z3E7gAnJrDBzc8k4xOzwmvpkDI2BnM=
X-Received: by 2002:a17:907:8a27:: with SMTP id sc39mr29573252ejc.567.1634566319834;
 Mon, 18 Oct 2021 07:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211018132329.453964125@linuxfoundation.org>
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 18 Oct 2021 19:41:47 +0530
Message-ID: <CA+G9fYvnv0vYb3cL0i_71SaLoJ5FOUQh3BCTMXkD3rEmjny_+A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/69] 5.4.155-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 at 19:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.155 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.155-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following patch breaks builds on arm and arm64 for 5.4 and 4.19.

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

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
