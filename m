Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D7C1C2229
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 03:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgEBBrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 21:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgEBBrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 21:47:18 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E15C061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 18:47:18 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f8so4288034plt.2
        for <stable@vger.kernel.org>; Fri, 01 May 2020 18:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2Ok54BVZlC2GxNlaRNh34dQ0LHU1S91WjATssOG4iPw=;
        b=ACEsX+ni3e/vL7R2m3s9cO4Z5EalIxL9u13j7LMLNzNftmIPcJZ44DSkTdEqg1SKhZ
         ULaL2DcgPB5eWVtoYj8CDaltZTXhM6E2a29115cE+pp6cRcxU9JIQAlttQ+f01hA5Ddu
         bhsd1cMGwtds88SCjCTfv0t0/hi3+2I1OOw3zzAHD8UC+qWJI8QjpCA0SqAWRP6frS9W
         l1+s4bnehtDz0n7d9Pc1kMhOnoz/Jhz3d7iKON93rT5TvfomVyPz6eJAM7lQv+CWCy99
         lgyu2iTS9QG/yYt+ZRoHxG/UpaMo7ZS+4wnejyK+q/yg+ZI5QF8q25+jX3IATSCjXLgw
         XRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2Ok54BVZlC2GxNlaRNh34dQ0LHU1S91WjATssOG4iPw=;
        b=n8/54+GxUNGFvFiYub2B/XzA7YDvOJXzifjKxB9oDVPhgE1ZJj2DreVW5cg8jwPwmD
         U+142BLASLDiUhcblaN2FDal3vJDj2WN5rn0jzRM060YZ9de7sYkg/yNo6C/YP4MM+oL
         BlW/AlMHHbIiU7jr0AI7hAwkzYklvWYW9gmISMN8O+1d3bSb5jl8pifxCfc3wZ3NdqnV
         6ivzsWej/224mw/nAkgdDhJdF/PNA0+Jb90kKcZT0WfRHuveL5s4oJOGiChcjTelLixn
         8mHkjCxIDrziym17FDq/MyH6wPAQWt9DFVWDUw/8GOStjDpQUQpa/Q8P9TZMzZ5idBoM
         aXdA==
X-Gm-Message-State: AGi0PuZ2PBzaFAAxWckvack5ycQLQkuYMDwZ6Y+TP5JrVKo2sMH/ybZN
        Em5bRQCvA8YO2pwoiuuaZEwQ/EPVb14=
X-Google-Smtp-Source: APiQypJoey0Ejry0BGWdYwAstVoKkJz3g+ot8iCPmxxgJ6+zMjDnABSY0e95EiWYiwJ8izLIyBQPtg==
X-Received: by 2002:a17:90a:7788:: with SMTP id v8mr3008637pjk.111.1588384036451;
        Fri, 01 May 2020 18:47:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm3272870pfo.67.2020.05.01.18.47.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 18:47:15 -0700 (PDT)
Message-ID: <5eacd123.1c69fb81.3ccf0.c72c@mx.google.com>
Date:   Fri, 01 May 2020 18:47:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.8-107-g96c73ff08986
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 165 boots: 3 failed,
 150 passed with 5 offline, 6 untried/unknown,
 1 conflict (v5.6.8-107-g96c73ff08986)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 165 boots: 3 failed, 150 passed with 5 offline,=
 6 untried/unknown, 1 conflict (v5.6.8-107-g96c73ff08986)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.8-107-g96c73ff08986/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.8-107-g96c73ff08986/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.8-107-g96c73ff08986
Git Commit: 96c73ff08986f85d4e1a21194ad522aa17e936a7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 102 unique boards, 25 SoC families, 21 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.6.8-68-g8fe1aeefcb6f)

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v5.6.8)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
