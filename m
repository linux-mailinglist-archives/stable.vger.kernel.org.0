Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25791BCCA5
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgD1Tpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 15:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728620AbgD1Tpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 15:45:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AD7C03C1AB
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 12:45:42 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s10so8893951plr.1
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 12:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nKl6qPaH3ROSWYUUIwefXQkp7AUlWYs/orARPhiFyeQ=;
        b=e9euKHP1iIvIM6/27/4ui43wEWw646aIclHjSUSeZETwMe56htXV4TMZ7HyjNXUmu9
         hShV0FYch0qdx4sdDgfquRlSGeuohTqVrUI6mhe1s8+tOBrl2q6rKiwpq4rmXdgCv4/9
         2kRZVoAvmFDosk7UG/bGkQdcp5a1vFHWfR+EH37sTFJIbCLc6uOadf65khQinmdQBU+s
         3YU+NOMKBswjvXJi9NzpvynDt/JaDuubEP/jO6H88T80S65IVmrVRtmFBKPYO5gE7yni
         yKsu9BmVDdUqUTnRsQbKkrHFwpzA37tO9v/ubjShoM/+gkgGwHYFV45EAhswqVQGn4T1
         cgwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nKl6qPaH3ROSWYUUIwefXQkp7AUlWYs/orARPhiFyeQ=;
        b=Vln/2rxMQ233zhP51cC1K1sXn+OnEuquwXe4M4fZGAG3HtlWgfD455e86up6rnXCZY
         KP7kk7w5u25A0cUGCo2ye11xQ8ga2dWpXKV/ewZD5TvTOTVLyQW6HO19TI7hqolsmz/7
         QZErQUBtphv7vY4tIcO8kvjd+1C19zyGEN4Ced3IHzR60NxUgjkuiVWWP7C42uGPTC4f
         zcyDLS+In/dJ0GUAj/+WIV2so036ySND5Y7+uqwa6IMvzvETT/PjwTBtIAMvPSIe3dnN
         wteWei2SkDzXgqSDhz6BtFXSVMhsfFNOgwPfpCM+BRErUgtUy3kdb3ucawPG6+7/iabS
         aNVQ==
X-Gm-Message-State: AGi0PuZXA2S2lRqAINmrzEzp+0VIs6VJ8U0lRWifLNhxENeJGhjh6vu7
        twh7Zzr5nRkExwYpgwVhnCId3Q7GAMQ=
X-Google-Smtp-Source: APiQypJzFPSPeYJMqtvAxMQIMBUSS2hVvzR3yONilQRsex9ybkGXnTV6ZSPS3wlQ219KyZg3/7+x5A==
X-Received: by 2002:a17:90a:17ed:: with SMTP id q100mr7424455pja.80.1588103141974;
        Tue, 28 Apr 2020 12:45:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 28sm2834425pjh.43.2020.04.28.12.45.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 12:45:41 -0700 (PDT)
Message-ID: <5ea887e5.1c69fb81.950d9.9855@mx.google.com>
Date:   Tue, 28 Apr 2020 12:45:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.118-131-g9815485cf882
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 150 boots: 2 failed,
 134 passed with 8 offline, 5 untried/unknown,
 1 conflict (v4.19.118-131-g9815485cf882)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 150 boots: 2 failed, 134 passed with 8 offline=
, 5 untried/unknown, 1 conflict (v4.19.118-131-g9815485cf882)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.118-131-g9815485cf882/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.118-131-g9815485cf882/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.118-131-g9815485cf882
Git Commit: 9815485cf8825f5da61798e68863f5ae90539afe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 87 unique boards, 23 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.19.118-130-g=
0678d3f5eea0)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.118-130-g=
0678d3f5eea0)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 80 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 46 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.118-130-g=
0678d3f5eea0)
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.19.118-130-g0678d3f5=
eea0)
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.118-130-g0678d3f5=
eea0)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-p241: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
