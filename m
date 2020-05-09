Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59131CC16B
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgEIMvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 08:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgEIMvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 08:51:07 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FDCC061A0C
        for <stable@vger.kernel.org>; Sat,  9 May 2020 05:51:07 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q24so5500354pjd.1
        for <stable@vger.kernel.org>; Sat, 09 May 2020 05:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3X2ybUpSgwcmrPrNr7N034mEDBcsWccPUPS7CcImdL8=;
        b=eX+UI0eI8pIGAXHmfDcrwklGyaUI/CPMPtSFCpu0LHYTHTZzWnjVYQysHEDwgPCk7v
         VZJ5x9PaGRvTE+H5LfTvG3lg7GNdCeWmZHk36st10X67LdSrAHGpN9V2XjqkqFkoUtr9
         d6OoQtMlToTTTEYEuEtDGMaDzFTvvtkSFN2NxomL+6uIwEHIZRFO1Pyb28uFV7Yy21zs
         ngD1FA8pvq8G2E2YYDe1/fBBxr0o7OMTkCaAPqK50YfSzNjefm7TaYBBAMj8npVcFeP2
         3MGG7x99dn6bK2XR5vgUVDTvA9thhntIOcx2eisqTSxqfhscRBqcHuFLz8Ve7Le+HLb5
         0uNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3X2ybUpSgwcmrPrNr7N034mEDBcsWccPUPS7CcImdL8=;
        b=A9hIneD8X6epr28GfX1H4NskZ1WN291YBH1sjYoNO9UhTj6uwiWBkaflD0OxVqJERx
         FQgWLLHthH5FNWGTevREGMEX6nP1b+IX9hH7Y9ot930b4gZZKbh/+yep2aaq86VWJ/FC
         TwEqsL3C6M1iTDPJCPsqVdKvqEJMb2ydsLnFOf+79KN9du209awz6K1GNbvfmiv/wwNm
         uc6sHdig1uOMaP95n1aS6O4x9RjgubiNTQwWdlcqIQG8uXaAHF1OJU5C16Z+3qJa+PCu
         CJAy1MPQJWhyAE54lqIuY1g853kdFG2kfXTFcirygMVoeYcjFomKHTPeVVILwA8xXZVM
         7P0w==
X-Gm-Message-State: AGi0PuZ3aGni46DRTslfFqa56nKvs/q4hjaE5j6/4nWdIyQ6T/yrffCV
        fWD2rNAPaK4/u7lb3yFsbOTQEzA3sOU=
X-Google-Smtp-Source: APiQypJa6ubGBDMcUFZ/nsFxGriiKDHoqFz2c1b0G9KsPNNNcbWDbOTYlpUeZ1XsNztHsVdtQXV90w==
X-Received: by 2002:a17:90a:24a7:: with SMTP id i36mr11462176pje.32.1589028666448;
        Sat, 09 May 2020 05:51:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5sm3637517pgv.67.2020.05.09.05.51.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 05:51:05 -0700 (PDT)
Message-ID: <5eb6a739.1c69fb81.9f6e9.c60a@mx.google.com>
Date:   Sat, 09 May 2020 05:51:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.222-307-g211c2a20b085
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 91 boots: 4 failed,
 79 passed with 4 offline, 4 untried/unknown (v4.4.222-307-g211c2a20b085)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 4 failed, 79 passed with 4 offline, 4=
 untried/unknown (v4.4.222-307-g211c2a20b085)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.222-307-g211c2a20b085/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.222-307-g211c2a20b085/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.222-307-g211c2a20b085
Git Commit: 211c2a20b085f3c5c4092afea4c10dd2bccaf96d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 16 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 1 day (last pass: v4.4.222 - firs=
t fail: v4.4.222-309-g1a571d63aabc)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 90 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 44 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

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

    multi_v7_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
