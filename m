Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDCB10253A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 14:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbfKSNQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 08:16:29 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51307 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSNQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 08:16:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id q70so3149730wme.1
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 05:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WvVGNHN4yJf/H1wFmtDm0ycjEow+dvONWzcObxb+yHI=;
        b=rDAwNnEAlBT08zXV2YnKjAisl1RkQUkA2jI6t6EX/NWvVyi3uk9Cui4FYTKbS7wEXH
         ILhKbRXmkqj0QGxDM7P7DeY5o8/QQ8sfyJ9Ac1vOtqTAORwuF8W+2Tm/NCN39kbdybBg
         JuqFXLCX3vsBawSPsmw/HxJS4aLlGxyylt3t3FLkSuAdlzmA7HP0gwFz7vdHqqbzp1Nf
         CTkHGMDZOCEn+tDUFdJTpxiSxCqUXUjkf6+a4D5nBsK4WlMR2QXxA/kZ9elSoAsjdWDN
         MeAA+7hJMBBs9Me6bR/ywYfhV/f77xAh7i+AQSyFikOyiVhe8JqylsWK53uG5g6Cu6er
         cPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WvVGNHN4yJf/H1wFmtDm0ycjEow+dvONWzcObxb+yHI=;
        b=fl6YHyEr14ThQqogK9amc+mJ6IEtUP9Xm52wRjIET1lhX12Uuy+pNs8GNH79C+joYI
         4e+Yz+ainRvZ73WHfLH4du3EHBZGmO9n/YG595p7z6vC/FVO+CL0DovfPeW16ml0zHvM
         kGaMhsWyC6zQRxjthLPnPtgQKPPQkaLufY30IFWWJGE2OeSqeofKksX+/18PyG7rnkS8
         Mb/SqwJLSon729pFOUoc5rjG3dSt2aYaK5DhYZNIB6L6PFrBc4HUurPSr2iZgTRxLvgU
         pvhkqwF7Si9Iy1IKkFfSGJvRmiNF3rQy8K2MhFS6mgAyaUzkU0jJM0DKnVlkFfCDpUEP
         c4XQ==
X-Gm-Message-State: APjAAAUq9iv9svs57qBHRhGBTcI1JXxV8TuOJZ/DasbxxE+A27z6ezQu
        oEm8tG6MJBQxZw4sUC1e/Yx0+HU8iqMFYA==
X-Google-Smtp-Source: APXvYqyIfQxRH/StyV2AzVq+3NWDyQcgC0Vt85iGjL4/RWIzYrx4j4obK155qpUC+JaXbELoTSfC/A==
X-Received: by 2002:a1c:480a:: with SMTP id v10mr5751338wma.138.1574169386521;
        Tue, 19 Nov 2019 05:16:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q5sm2987318wmc.27.2019.11.19.05.16.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 05:16:25 -0800 (PST)
Message-ID: <5dd3eb29.1c69fb81.809a2.e5c3@mx.google.com>
Date:   Tue, 19 Nov 2019 05:16:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.84-423-g1b1960cc7ceb
Subject: stable-rc/linux-4.19.y boot: 79 boots: 3 failed,
 69 passed with 6 offline, 1 untried/unknown (v4.19.84-423-g1b1960cc7ceb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 79 boots: 3 failed, 69 passed with 6 offline, =
1 untried/unknown (v4.19.84-423-g1b1960cc7ceb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.84-423-g1b1960cc7ceb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.84-423-g1b1960cc7ceb/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.84-423-g1b1960cc7ceb
Git Commit: 1b1960cc7ceb6aaaa6ea2cd3a6c79c5f7ac9284a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 20 SoC families, 15 builds out of 205

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.8=
4 - first fail: v4.19.84-423-g1fd0ac6484bb)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.19.84)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.19.84 - firs=
t fail: v4.19.84-423-g1fd0ac6484bb)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.84-423-g1fd0ac648=
4bb)

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab

---
For more info write to <info@kernelci.org>
