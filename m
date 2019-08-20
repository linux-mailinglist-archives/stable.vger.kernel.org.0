Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A9695BAB
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 11:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfHTJwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 05:52:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42588 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729194AbfHTJws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 05:52:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id b16so11694953wrq.9
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 02:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U+oSMuaqAzBUQsaKM8hCw5UOMG0ZrgM8omlZD+AaZ/4=;
        b=d2tarCOmwoanLamlo3fb9KCHz9pBYEAdwdMx5r39QbJz+kwXX30jmGGQWgcgPyajsp
         oa1gKwu0SWlpfGS3NcoRx8+4YA7UqaRbEWA13a6cj9rXZwbV9RzWB3fQdo3r1r1XmTMw
         AyKG2L8LKn9x3WEUWjF5BYe3e/dm5YmDPm4MY6evcz4GZLv8LCyEMlHmRx8tvaE3OzZJ
         +AeTY22fQXZJbo+ovKVFqFKlnUVRY06zLldIC5NAOjlJCiLYqN1Azp+H/QY5Kg7GX12D
         t7vfFiCuOg8F20AitZQZdWcBK0J5OaQKInaK8QPGs0em+aw7Yy2LFiVj9/gotbSYAJLQ
         TZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U+oSMuaqAzBUQsaKM8hCw5UOMG0ZrgM8omlZD+AaZ/4=;
        b=RE0uFEOX7BTtAfc5/GZ3SiFc8zYKHGTEIgmpX9dqEatukf/FEpOvoSIkxfWhkylHDy
         tb4bvC+Ff0Ls+kOXxFD1fThZJPNn4HM6DYxSG/oz5ZWPU8iy+dkU/QMNgimnMWUSZ7vc
         Iz9UoCL+cQ3X7QaGPKAnXU1x4PJCiCTAv7N03FOOS8TS3fnHSyPtOQ87YDNdt52oxzRW
         Pc75tPobaZ/bVhoU7wasxrOaCZs56z+DHKq5goyLfpPUmcns6BjF/MISa+nA4f04fnmP
         f2g8X2i7durycksW/MBKXZ30C4ISaEuA7Fw+Z62T5gvBuxujTW2G28OIW4Jr9QNSQhy8
         yISQ==
X-Gm-Message-State: APjAAAXYrnl2CIDljHOCnxTMDb720GgoG/9BW3s9Rm6A7cwtQGUuUWp/
        VV7bzohz7JVmY/UcVBAdBku5Jcy1Nfjl5Q==
X-Google-Smtp-Source: APXvYqxFcIZtPI0Q+pjuqdjnIguw7NODdAjhFB4kZdEi5Kz2/D0XvD1uV+IMZGJD9LkcHaqRYNy/ew==
X-Received: by 2002:adf:fc51:: with SMTP id e17mr32748406wrs.348.1566294766272;
        Tue, 20 Aug 2019 02:52:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x20sm38868256wrg.10.2019.08.20.02.52.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 02:52:45 -0700 (PDT)
Message-ID: <5d5bc2ed.1c69fb81.d5e3e.faf5@mx.google.com>
Date:   Tue, 20 Aug 2019 02:52:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138-126-g5b4b80e49b5f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 119 boots: 1 failed,
 103 passed with 15 offline (v4.14.138-126-g5b4b80e49b5f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 119 boots: 1 failed, 103 passed with 15 offlin=
e (v4.14.138-126-g5b4b80e49b5f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138-126-g5b4b80e49b5f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138-126-g5b4b80e49b5f/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138-126-g5b4b80e49b5f
Git Commit: 5b4b80e49b5f12b592581508c6b45ba7e1911a5b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 24 SoC families, 15 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-73-g1a4682459a61 - first fail: v4.14.138-91-g248e04a69071)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-73-g1a4682459a61 - first fail: v4.14.138-91-g248e04a69071)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
