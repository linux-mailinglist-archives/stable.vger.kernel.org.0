Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468FB3287F4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbhCARa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238388AbhCAR0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:26:20 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D5DC061788
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 09:25:07 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ci14so10694374ejc.7
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 09:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=GpEoM8XXlnlHwcOGysQ91LiTB61WO4r0bs0983YXWto=;
        b=VYuQmHEyerte3PnhH1vNwwvrPqh6VL2ebcEcfSmnYcPgkeskCB+2sPyARRbR+ir780
         ymBp9TrkZA6WeARXd/fCqjX80SNREteVmsruZ9wynYzCGvQKxGKJjndIyRGXL/5/xEfI
         AqzEXzZKM9RupyqKQfGeLUVINlEP3GO4RFZzhLf2vO+UHg9SDXEFHqjKMtzm34zOyfL+
         YCJCnKLsCgIg4DLYtU+3EyMoopbBNTDPmQpgGh7miYP4RCC2qSnDnh3TEAekFUG20CD7
         MctZTRfADVBsn48ESgiyAlUXS4R0O9lBFkfcdcVuyc9hpHnBBxrkIOVqfsynyb8O/srb
         OL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GpEoM8XXlnlHwcOGysQ91LiTB61WO4r0bs0983YXWto=;
        b=SGS4EhT78HEmIFQqCPcfeux6t5erxDE+gqaSN4kCsKEHy9mNLR/XbXIstzh3fCiqSZ
         CcARf9cYg+qderXNbiptC8XYAz/We52SkOZ8N8uAZDn28+cT1yH5fY1ZhXWvrmFkh5Yu
         2iFheDNsp0RQiqGjzr8NccGSphhYF4KkcW6wSLDxhLTCpFrXRGxBq47SXz7XrT2NfT57
         dboQQvo0QIBiMArTdlGzsJgCCCaAVd9rIyZq7U3ARXuVAseZiUPeYUIG3VlCUWOz93Vz
         iSa/2ydr3BVZHa71CBtwNK5xyBl7MwgKRdd13VAE95bPnDIU7WSEf+Q7R/Kj56n2DtcV
         o7cQ==
X-Gm-Message-State: AOAM531OzUXB8ovNUW9zaGSm4AzuOCKMP76IV19Djd5/tzsjE5Wuzfz6
        pHwhoPHBvKPnnVJQZtWut8ROnRh99aNUMpuaC80yUA==
X-Google-Smtp-Source: ABdhPJy2/fu9xyugRpxbHjUaenNq+oeZc8zhQcxyfobz9TKBVgNQu+vfv5TRaJJR7UjxZ2rmpCQXeCGsJkyBCHJXDeA=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr16848983eju.375.1614619505969;
 Mon, 01 Mar 2021 09:25:05 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Mar 2021 22:54:52 +0530
Message-ID: <CA+G9fYufUB394TpDuO5-m2GEi=1LDZvsVcHmp-HyWbWV1tYjkA@mail.gmail.com>
Subject: sun4i-ss-cipher.c:139:4: error: implicit declaration of function
 'kfree_sensitive'; did you mean 'kvfree_sensitive'?
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On stable rc 4.19 arm build failed due to below error.
the config file link provided.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In function 'sun4i_ss_opti_poll':
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:139:4: error: implicit
declaration of function 'kfree_sensitive'; did you mean
'kvfree_sensitive'? [-Werror=implicit-function-declaration]
  139 |    kfree_sensitive(backup_iv);
      |    ^~~~~~~~~~~~~~~
      |    kvfree_sensitive
cc1: some warnings being treated as errors
make[4]: *** [scripts/Makefile.build:304:
drivers/crypto/sunxi-ss/sun4i-ss-cipher.o] Error 1
make[4]: Target '__build' not remade because of errors.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

ref:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064179234#L462

confg:
https://builds.tuxbuild.com/1pAEVBwRxCDBXf85dL6Kki6o8Yf/config


steps to reproduce:

# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch arm --toolchain gcc-9 --kconfig
defconfig --kconfig-add
https://builds.tuxbuild.com/1pAEVBwRxCDBXf85dL6Kki6o8Yf/config

-- 
Linaro LKFT
https://lkft.linaro.org
