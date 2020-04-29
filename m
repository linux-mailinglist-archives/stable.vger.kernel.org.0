Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCCC1BD34B
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 05:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgD2D6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 23:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726548AbgD2D6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 23:58:12 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96014C03C1AC
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 20:58:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so231984pjt.4
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 20:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1zB4dXLM7md3PkEI7+NFXcsN1kOd3eOGftOVSve8VoA=;
        b=gZWVkysq9Rgpd1pmnxzSVQPVP/SuyTwUWmE7fJEBmNWF82p18jPoQhEYw0nehGDhbn
         jMG7pd/JPXZsNT6OQSVdRzKH4JdMjABQZEvkHVf+DHT0J/ExQb8pGbH06K9Y5guGXoCq
         mjqHzJM6OeTIw50x74wCrB6InFOjZf55kNVgJvcKUpvpYmilWPWS/hizdExee3SpC8ZM
         GNxG8hpvV8R1ZGKYbRCLFY3PkU42EfcXyz3mHnTDOjYyaNYgnpy1oqjN01I/3bI3oF0T
         +W6a1FjM2R28DNbjOlvARVTR8MImEjjFS4uhPFeFVlg8yQZ5W5pf7GqHUyuMiR1t2JFv
         YBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1zB4dXLM7md3PkEI7+NFXcsN1kOd3eOGftOVSve8VoA=;
        b=NVIs9RA5z6yV63nO0GbnWEinL+IzKl39URCxp0tJ34+zBnUzic5CNiVV9BJ2sTbxyf
         jtMcNjB9KC5vqpayVaHULix5PEXhSsiU2M9vQKY7Wsx7f0Qs4WuKKAskoL7ZmKT1KUfS
         UQFyH1l74teApRC4j9DP9SkLatJNho4/u6sMcupHCP0CZlA2GqiY2adHyWFUpUR9wB3k
         EfVObP2YIRDybEfJTF/+gjjcs5YCbUvkCrSteimwE4FSvF8S50SK0zyXWHwhwBv8TQyN
         Jpe8LkTszibjdEwieOhWXmX6fJqbZh2CzGzNtjYWAr8Aj8ZU5GGv/eBLmTQ/BsIX2rgT
         50hg==
X-Gm-Message-State: AGi0PubIpcPB+z+GVgbWxniBEJ79QtoPzGXIUNkYdZ1uTR3x9Zoaejhc
        /lW+H/nHUq6B2Fey/ZfL3iBXk5EJ+as=
X-Google-Smtp-Source: APiQypK6dg9SiRaRsVPXpLYyT4F6QhU3jpCiodGMn9wGSOU97n3kE4KZtZQ67/zIRQS9JY4W7FWC4w==
X-Received: by 2002:a17:90a:6488:: with SMTP id h8mr813499pjj.51.1588132691544;
        Tue, 28 Apr 2020 20:58:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o6sm9368486pfp.172.2020.04.28.20.58.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 20:58:10 -0700 (PDT)
Message-ID: <5ea8fb52.1c69fb81.e6bba.8c62@mx.google.com>
Date:   Tue, 28 Apr 2020 20:58:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.7-168-g853ae83af7cc
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 171 boots: 5 failed,
 153 passed with 4 offline, 7 untried/unknown,
 2 conflicts (v5.6.7-168-g853ae83af7cc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 171 boots: 5 failed, 153 passed with 4 offline,=
 7 untried/unknown, 2 conflicts (v5.6.7-168-g853ae83af7cc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.7-168-g853ae83af7cc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.7-168-g853ae83af7cc/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.7-168-g853ae83af7cc
Git Commit: 853ae83af7cc63bd4dc0a44370e4f0b3c9fa57f9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 105 unique boards, 26 SoC families, 22 builds out of 190

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v5.6.7-167-g9a37d69c81=
70)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.7-167-g9a3=
7d69c8170)
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.6.7-167-g9a37d69c817=
0)
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v5.6.7-167-g9a37d69c817=
0)
          sun50i-h6-orangepi-3:
              lab-clabbe: new failure (last pass: v5.6.7-167-g9a37d69c8170)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab
            sun50i-a64-pine64-plus: 1 failed lab

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
