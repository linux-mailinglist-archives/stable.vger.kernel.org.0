Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F6045B84B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 11:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhKXKZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 05:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhKXKZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 05:25:47 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259BDC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 02:22:38 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id e3so8093648edu.4
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 02:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=bjAGJYLzKJfxoU7yIi2eukVwU706p+VzoTZIhqxP49c=;
        b=uwt+7WOSPtvNDm4avi3DiAuHpn4hSOdpWDUN/zQsL3SBMUG8FpBrwpmZYtTHCYfQ9k
         x66Fcc5/w+8W9MwM12vgbOCZniBVY+ZvRi4jmABC3Hq5MxOWfQwVyebOJCbIw6SDw/wl
         aUdefXgncQLJgnpRvIlUhA7NncdhCqUPw58NzKFlZDaClIjIrFWB0KNYmW9G7n4+M6WK
         DE5HFVHuF3LVELHF9Ni+rXnqEvULKr3pjKdzkiS88TrwvFgVNnOgGHZaugBTcilOGMvC
         WQTt5DtRnReuD+HPGroG5yIDLFgHJ4c797z3wGRz2GEL2MzTqF7X93zfFtHAX+2x84Ct
         6Qsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=bjAGJYLzKJfxoU7yIi2eukVwU706p+VzoTZIhqxP49c=;
        b=La7YnDxikZU/2KbIf94aOohbMmUBxivBjvwKhgFZ+zLd4lvMLzdbQGKfaIJ/i5cZUG
         ssrf6HW2an5e9oAl+qFa1G+xVDPcVBzM+8Qteb01SsoytdCbMCGSTSlzUGBuVx1xDsUA
         U+P+K7AlrmjGTle5cn+fTXd1gKH8pPuRoj6yo9evOBuKAgAEvmatydwtFWTCitSiwVpI
         pCPBxDdkuuxXCbJ/fsTnXRQsX+RBMKGStxJpbUkaQEnpWcJnYNWG/q2WeYUAw9140yx0
         s4GxKKQ1Kj1X5BzS+fwXsUa9IcbPtZeYbdQTJqCZwo0fHHJZJKQVH/34b7kPfzrdIV5e
         +E1Q==
X-Gm-Message-State: AOAM532LXcrzPwPP2/Qb2tWJL5OFhWXhrv3qqSTIAa0Iht6Pbe4Oz/MS
        b3oCaCQaM/ZKAvqHPjWpCSOCCaNbaQScuqgOLJI+VhXkv769/Q==
X-Google-Smtp-Source: ABdhPJxcI/bGSWP4a2OsIqyAgDHV3NE0dUCYS6tTlUMaeY8a6p+ILC4eiVbs2H3TP0fSqP1op6VO5eqr/3V43lxGADA=
X-Received: by 2002:a05:6402:4311:: with SMTP id m17mr22294310edc.103.1637749356025;
 Wed, 24 Nov 2021 02:22:36 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 15:52:24 +0530
Message-ID: <CA+G9fYuPTaOZ7Kbtvq=5gq7xrWdLsKRw_iBSxfmGORoRbesy_Q@mail.gmail.com>
Subject: ipa_endpoint: ipa_endpoint.c:723:49: error: 'IPA_VERSION_4_5' undeclared
To:     linux-stable <stable@vger.kernel.org>
Cc:     Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Regression found on arm64 gcc-11 builds
Following build warnings / errors reported on stable-rc 5.10.

metadata:
    git_describe: v5.10.81-156-g7f9de6888cf8
    git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
    git_short_log: 7f9de6888cf8 (\"Linux 5.10.82-rc1\")
    target_arch: arm64
    toolchain: gcc-11

build error :
--------------
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
drivers/net/ipa/ipa_endpoint.c: In function
'ipa_endpoint_init_hol_block_enable':
drivers/net/ipa/ipa_endpoint.c:723:49: error: 'IPA_VERSION_4_5'
undeclared (first use in this function); did you mean
'IPA_VERSION_4_2'?
  723 |         if (enable && endpoint->ipa->version >= IPA_VERSION_4_5)
      |                                                 ^~~~~~~~~~~~~~~
      |                                                 IPA_VERSION_4_2
drivers/net/ipa/ipa_endpoint.c:723:49: note: each undeclared
identifier is reported only once for each function it appears in
make[4]: *** [scripts/Makefile.build:280:
drivers/net/ipa/ipa_endpoint.o] Error 1
make[4]: Target '__build' not remade because of errors.
make[3]: *** [scripts/Makefile.build:497: drivers/net/ipa] Error 2


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link:
-----------
https://builds.tuxbuild.com//21MNrWsMVCZZPGZPpgMBMMYx2Kb/build.log

build config:
-------------
https://builds.tuxbuild.com//21MNrWsMVCZZPGZPpgMBMMYx2Kb/config

# To install tuxmake on your system globally
# sudo pip3 install -U tuxmake
tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig defconfig \
      --kconfig-add
https://builds.tuxbuild.com//21MNrWsMVCZZPGZPpgMBMMYx2Kb/config

--
Linaro LKFT
https://lkft.linaro.org
