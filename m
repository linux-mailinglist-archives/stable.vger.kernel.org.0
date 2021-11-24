Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2858745B7EB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 11:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbhKXKDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 05:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240618AbhKXKDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 05:03:33 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930E0C061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 02:00:23 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r11so7746189edd.9
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 02:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=wv08yLz4zrdREkk9Z+j0+m1UWGNKOKoiKeinivXDeCk=;
        b=OJJwsLaIgQnbJdIAvLKO6GpXiRo2em76pWFJyNBHQ00r++WiPqCKZtLi80cNFwoZmt
         +cOzNRVf+Gh4UkrNZQLo5JVB4DZncUoo/rYEY7OxG8PrJnZcVqGGUtOrpp/HgErpuUbk
         kZ1ALpkb5S8B2Yf/icfn/RnSabztBIkzxmP9eT0ATT3gKPGvqfzircWP3Q1sTuwmaSiI
         9LJfdvBeuX9AXEAw3XjVz0Vo0sKMyVcvCVsRUkZQibfPhyH0h22B7zKzkpZDTiJPhrEj
         HuJcJ5AxR08IpF9OTng7Skz2XgHtLKlK3g2nWtG8kiXu2A0nXMKbOsFJq2RKTGfU3c7B
         E7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=wv08yLz4zrdREkk9Z+j0+m1UWGNKOKoiKeinivXDeCk=;
        b=g+cNKR4OEDP0se+sHMIaf66KxoDTYNAj3pqd489yUJFwtyrVKV1G+6j4QquQLLaBJn
         D+gTjk7eZ5Mt9QD9Qu60NYG6NwR7bLGsPLVXhzs7zlH35en4p1dBF42G2ZU43TAHNESB
         VoqifOcy1l5e59JdhZqy6gm+XSoJiDXa9rUX6stYIvAM5Q2Xl0cXUsAAFqc7WaHomwYg
         UMcSpBExOGQuMsydrt69YDtR1TU45OVbk4hmHZRQy1588GFZ8rJn2VdG/ntISDdjqFk1
         PYvpqAr+l724zl4NyGmsQPY+L50GuFY43INl2RjAR0XqbrJeyokwHQKvC8/UgqLA8BF2
         WdjA==
X-Gm-Message-State: AOAM530Y8Gdjuz/PKdgqxBuGVBBAHTCT5raNr8tAXqqnkURXp5AKcDTn
        KWFVl6FT9lAcNbKlvN8CLgCRD3RCTunWZp04WITl3p+ZTydpTw==
X-Google-Smtp-Source: ABdhPJwuCKafaSGt1xUrGrxJj4GYEcW1UQxBcP2oFYfZ4sO0JTWHJr2zv8ieqzDYVLYM6+S8rfvLlsf2Invoi/zulCU=
X-Received: by 2002:a17:906:7955:: with SMTP id l21mr19350893ejo.6.1637748020910;
 Wed, 24 Nov 2021 02:00:20 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 15:30:09 +0530
Message-ID: <CA+G9fYv5fnntoa1vzXp52=TSxCK=U8fV8J-AbE+WmKH1w4ebwg@mail.gmail.com>
Subject: qcom :apq8016-sbc.dtsi:412.21-414.5: ERROR (duplicate_label):
 /soc/codec: Duplicate label 'lpass_codec' on /soc/codec and /soc@0/codec
To:     linux-stable <stable@vger.kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Stephen Boyd <swboyd@chromium.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Regression found on arm64 gcc-11 builds
Following build warnings / errors reported on stable-rc 5.4.

metadata:
    git_describe: v5.4.161-99-g60345e6d23ca
    git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
    git_short_log: 60345e6d23ca (\"Linux 5.4.162-rc1\")
    target_arch: arm64
    toolchain: gcc-11

build error :
--------------
builds/linux/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5:
ERROR (duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on
/soc/codec and /soc@0/codec
ERROR: Input tree has errors, aborting (use -f to force output)
make[3]: *** [scripts/Makefile.lib:285:
arch/arm64/boot/dts/qcom/apq8016-sbc.dtb] Error 2


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link:
-----------
https://builds.tuxbuild.com//21MKqVm5LdLI4FQGooFsnEUB3jO/build.log

build config:
-------------
https://builds.tuxbuild.com//21MKqVm5LdLI4FQGooFsnEUB3jO/config

# To install tuxmake on your system globally
# sudo pip3 install -U tuxmake
tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig defconfig \
      --kconfig-add
https://builds.tuxbuild.com//21MKqVm5LdLI4FQGooFsnEUB3jO/config

--
Linaro LKFT
https://lkft.linaro.org
