Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF87409BA0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 20:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345985AbhIMSCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 14:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345961AbhIMSCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 14:02:03 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09829C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:00:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id c22so14240310edn.12
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DHniLUit0TO1fpRb8u2zaQ03tSwIk8vmaFLMCJHl5Cc=;
        b=KvMorzevM9iFkGuwdH3TXkYjG6oxzPm7EjhikWixq8iOmn27OImseEWW7A+gVnZM2y
         n+Br/+bPNqoZABjxljng1+EwPC5UMUTURMHtVON/cqbjPFISAeLuxa36A7tuCWuNAD8I
         XwUUhXeudKpJBAFwiIv8Ln6Zc1zqbvXfMQ2XTJEDHJAMdHZzNY8CvCz+ZlN/FWTKJCu3
         eoV9gUZuOUhyv/2NCcLURxTL76FFVvrE0H8cclCQmcAIwqSQliS6gMnWOi4isuj/r3wW
         DUnGPGy80YKuKlIy2McojLu1vtII2+7iud88cqdx98Hc7n462orClCSViNb+4u0HQOuJ
         C4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DHniLUit0TO1fpRb8u2zaQ03tSwIk8vmaFLMCJHl5Cc=;
        b=zYmi1O7A9+yFOMc3iStEJ7oX+GOgs3f4o0TfppNnSSevGa0bdDdPrbQmCMKCSGzPG9
         tM0ayKIC/b1KSyJ0cuh/wdOhdZkLcyXVgOIASIHBWCTecHh+/iaOqzsxjfYB1LfJRjjR
         m9CrP148mL4SLsEDT9Glb58e5PEmhEMUlu0XuNe5se3yZJ/nUzbWzL6axAMAhTN6uoj/
         /QVExpdJvrIGthONdHCE06PnqjFZGmRYWM/dhrntaTrgpo1AoM6FuFnksstwJ0s2h4Qr
         KG3Mldq5aB+lpWp6yQD2di2WDflXs/3E/a0F2hDMND0J2XLCI/Qsk+MGAROn/t0hBE9p
         wPRQ==
X-Gm-Message-State: AOAM532UBABdR+ReuXeK61vPwzi59nsJPq6n1U68knL3dsgQrRwy49Bs
        YDhsDFeMaYT2+O+t90WUC8Q+EUvXeREyuWlyWJIKarPeXRALOw==
X-Google-Smtp-Source: ABdhPJx5nH/HEHzRtp0MK/myEqTSYmPy/C9zI1z8EKFCO0HlLcLly/dbEMpI49W1i/rpeDNRIm0lxgKtGl6BbYvX7C8=
X-Received: by 2002:aa7:c617:: with SMTP id h23mr13036515edq.357.1631556045428;
 Mon, 13 Sep 2021 11:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org>
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 13 Sep 2021 23:30:32 +0530
Message-ID: <CA+G9fYsPUuJFiY92VEqvdMYMA9rNFXAftZNsHka0QZSJngh1sQ@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/334] 5.14.4-rc1 review
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

On Mon, 13 Sept 2021 at 19:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.4 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

FYI,

arm clang-10, clang-11, clang-12 and clang-13 builds failed.
due to this commit on 5.14 and 5.13 on following configs,
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
