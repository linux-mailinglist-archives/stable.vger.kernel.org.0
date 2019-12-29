Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5558E12CB5B
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 00:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfL2X10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 18:27:26 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54867 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfL2X1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 18:27:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id b19so12726001wmj.4
        for <stable@vger.kernel.org>; Sun, 29 Dec 2019 15:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VE8jPHqnos0Llo4pnu5d9yi04cDJSE4vFVP0ioAEIMo=;
        b=F1UgeZCH907I45kOT2OZCd2T4owkgUxxcMo873hp65gFqXXU1cZh9ScO7XYaTpVLxF
         J+s7uWKJkqO8tEE4ckuP+dpp4NT76LiL+sxipPZrPxuD0LsLlTMb6M9O2MCGl18M/zfI
         M1ExGlSzUlIluLR8DSt6HrgGkzEeDnewWu7hnZumPCh8xbIArFbWK/8wtmMArCOq17jr
         3MSL6rCu3ilLSWd9ygrfmPw2TwoCYiKZ6pefOqCUriK7JrCeF9bEo9YYYA34yH0PW1ji
         X76m1AGRkIXL4G6F2Jf34jda3u0LOWgj5BcZL3ZTxjr5y0wokQSyY0D0tytyRTCcxDkG
         hmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VE8jPHqnos0Llo4pnu5d9yi04cDJSE4vFVP0ioAEIMo=;
        b=KJgKiOU7xBiFhqFOz3G1kMJbab/k75gaoLhXZeb27PtRmUXOFwM0xAirz1TQVALul9
         rMLk8UNojQ41MlGg5t9dw/5dt8EzX6YJTQWgulnnEU6wp1/5MC7j687euD6g2ZYaGrfL
         i4E4ADKE5zfNMyMMHBvC9Xg1sEXi7k7I5tGaoPPIXODnbpnUxGWXf227QKyqOU8T/Aku
         gAD2ZD4650S/jdMnwSIiPQAVQFNy3ElPqi64MLCrfM9IZgUkKL4Cgo61I26c/rnC6+Ew
         csLb3uB+QMphliG610Sh/RlFNcaw7o8IR0Mtq6mAnJT0taVKBd8nJRwRxo0scUESpng7
         RZFg==
X-Gm-Message-State: APjAAAVSRbMIQpuMIgNzZyuRI/idgVw9pBMmjOKdCW8qW8PaTMGFkaem
        qacrukILkCZfvyaQjYrtLR10D6xNd598Vw==
X-Google-Smtp-Source: APXvYqzqTt2Beqqs3aVA13QVK+G+N6Cr7zasvdfOMWc/lWoSpIiHQqejfbizFYFKZL1a4GJJ4C/aNQ==
X-Received: by 2002:a7b:c847:: with SMTP id c7mr31144284wml.3.1577662043497;
        Sun, 29 Dec 2019 15:27:23 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u14sm43681850wrm.51.2019.12.29.15.27.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 15:27:22 -0800 (PST)
Message-ID: <5e09365a.1c69fb81.c9c42.a949@mx.google.com>
Date:   Sun, 29 Dec 2019 15:27:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-89-g5a02460e9487
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 59 boots: 1 failed,
 48 passed with 10 offline (v4.4.207-89-g5a02460e9487)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 59 boots: 1 failed, 48 passed with 10 offline (=
v4.4.207-89-g5a02460e9487)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-89-g5a02460e9487/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-89-g5a02460e9487/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-89-g5a02460e9487
Git Commit: 5a02460e948743bd660340b3c20a592fc0a82a08
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 13 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.20=
7 - first fail: v4.4.207-86-g789721385a38)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.20=
7 - first fail: v4.4.207-86-g789721385a38)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.20=
7 - first fail: v4.4.207-86-g789721385a38)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
