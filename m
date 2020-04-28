Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BBC1BB68D
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 08:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgD1GaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 02:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725917AbgD1GaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 02:30:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2AEC03C1A9
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 23:30:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x2so6484140pfx.7
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 23:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AvcaVQkcDIYD+BqJK3mUnHgR4/t05iSv8uJ7hCbbdt0=;
        b=pGI0xvgUSJ9sdaz71bLo7SWc3pDSbEL0fyaP15cYVv+r3h9duH2/z8nPo4EPFlLMbZ
         OCqmL48IwgrxvxdVmHQ7c/OyqnDLSOLnMWEdtie7MYQ/HsDbEXhgjCBBRt5aaYouwU5n
         PuJCv3/peBYPC8UnXe7/1djdGy5qDu4XOmMZE/Bv+KV4t8vCYAYfvDtlBYAmSerXqz9c
         sGZ4sgZjltK2Ts7sEo5m3q3DdfwCcPZIRUOnaSrdQQ2BRCUOFA251xu901fpTGMU7JzW
         h8USMyb8aYwY1Lmo1pWn0FtsIMXnqrabfpc0Y6A8DEtvxmPUw5vdYZgnlh+u53H6Joaf
         etdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AvcaVQkcDIYD+BqJK3mUnHgR4/t05iSv8uJ7hCbbdt0=;
        b=IWJpLPRica/MS3eu/Ae2Hu/6DB+Sm4DwJ5jFCpuOrOwtEEaENS0rHaU7OhMOll3I/b
         MLemFDipkiYM/I3Pd5uspq4B2848tZjTUyFwuk9tRYHS73kaZxImCT/+3Z4oRZodaBNl
         kcrttmUKVXuRQKMB4LyTzdegbfz3L6m/GZSd6A7k5QtJ3UfpmOp1acZUtp6vc30J22nW
         fUTgRqFUKBHYDlLs/UpYGJSntGPIbcUUr7a9bhlUum55v754q7CEHs+rNeNGaUCpmjph
         NWQTUyJGlkK5nadrWWcxUaGA6HWNCfaEng0Up1QMBFUz6hzgXRZ/oSoax6a+1eAWhzSG
         5Q2g==
X-Gm-Message-State: AGi0PuZ/XRpGe60AI9vEGGxNM8dCQUSLvzzHOt8iacgP+Y/1p67CSP1x
        p74Y8Buo8MVTQ+0wspSeiZ618+4DBKE=
X-Google-Smtp-Source: APiQypIraLbmeGiFzSucfLr7/EFVOM65HgtNBt+JVnbZFxgHXx+KAhHfDZ4Eog8BCackQqvWncj66Q==
X-Received: by 2002:a63:cc06:: with SMTP id x6mr26288495pgf.143.1588055421270;
        Mon, 27 Apr 2020 23:30:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w125sm12407993pgw.22.2020.04.27.23.30.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 23:30:20 -0700 (PDT)
Message-ID: <5ea7cd7c.1c69fb81.89e67.e1b4@mx.google.com>
Date:   Mon, 27 Apr 2020 23:30:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.220-54-gdd4d68bd0da3
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 95 boots: 3 failed,
 78 passed with 7 offline, 5 untried/unknown,
 2 conflicts (v4.4.220-54-gdd4d68bd0da3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 3 failed, 78 passed with 7 offline, 5=
 untried/unknown, 2 conflicts (v4.4.220-54-gdd4d68bd0da3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.220-54-gdd4d68bd0da3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.220-54-gdd4d68bd0da3/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.220-54-gdd4d68bd0da3
Git Commit: dd4d68bd0da3520f9cc70463501fd410e22dd2f6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 17 SoC families, 17 builds out of 185

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.4.2=
19-83-g20fbd20eb91a - first fail: v4.4.219-101-gacb152478366)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.4.2=
19-83-g20fbd20eb91a - first fail: v4.4.219-101-gacb152478366)

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.220)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 79 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 32 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.220)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.220)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.4.220)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.4.220)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

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
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
