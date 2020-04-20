Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6CB1B180D
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 23:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgDTVIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 17:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbgDTVIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 17:08:50 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E34C061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 14:08:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id k18so4412508pll.6
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 14:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pRkGLNTJ+0JYk3tgW851vyQXtegKkzS0R/H0eVWjJv0=;
        b=fWmw0rb2t3nf12rVL+jRWh8iDDBx+51RMv97ckYlJufYR2kWXdY7ddaZ08gnjPVRHL
         2s+KU1En6jtMhsU4BLk/HNWA2+aU60Fm+UlwvJ0updDNasqEYhpB8XgY5qIIe+I+VTxt
         Em94W9awPiDz4nJ45M5mVhVlJU1miy7VkaYmfaugRDMfZjNIKw0htC/xV23L7sZvQY4g
         LyW1yFUxmfZ4MoQ5pN8CaP45I5dusJbGQVt5aV0JwdNHawZR5JPcYi7Vk6OZnRLO3SDS
         4CqFZamyHdtuCzED+zHsdVmeM+I/yiVOSIIcgEYsD7PUOpNrssLYmfjs2XIzvHAIPei+
         EKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pRkGLNTJ+0JYk3tgW851vyQXtegKkzS0R/H0eVWjJv0=;
        b=WTyr881nett0denptQB7ppt9pAeW9HPpqFq5YTpD5A+2+84CzimzbOSskimfcvznf+
         2V0EJ1pE+4XbAeM2ZaJcynjZuUW3BIaTKQK8RF4wb82VsisEUAnuuDV5n1MZEL3RUUZg
         siXACPFM3m1Ibs0hssPofsuUuDEy1YLf2wk50/79XVOokq7JxCbCBltKlmDOBOsBUkHg
         CIsA6pfxTRD3w16Td2yr5AoATkAlhqTU8f+jvdPYX+jdVCkwTp0DtFHdGya4TpvA0Tjt
         ohpYOGko67c+pHv5GvMO++ZfJY4DaIiKP+J4+pjmDLPba26GRi1r+EsjTkLDl/Y2qr6+
         GoHg==
X-Gm-Message-State: AGi0PuaKhuoRdTGXSjShoGD28br98AzGusMqv3Uzmn6A0d8jxZ0Gu0mR
        sw1ngYp44wOkhTfco0a3hAAvmLXi+8E=
X-Google-Smtp-Source: APiQypJa5QZRjOKSC+XnFmwV8dU7bfXq6nUJYKAEhIjPbvli+Vi2O3rfg86v4ebv6JwBfANo4yxG8g==
X-Received: by 2002:a17:90a:e2c1:: with SMTP id fr1mr1563795pjb.124.1587416929215;
        Mon, 20 Apr 2020 14:08:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g22sm295625pju.21.2020.04.20.14.08.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 14:08:48 -0700 (PDT)
Message-ID: <5e9e0f60.1c69fb81.8a0f7.0f4f@mx.google.com>
Date:   Mon, 20 Apr 2020 14:08:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.5-72-g906ecc0031ed
Subject: stable-rc/linux-5.6.y boot: 156 boots: 4 failed,
 139 passed with 6 offline, 7 untried/unknown (v5.6.5-72-g906ecc0031ed)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 156 boots: 4 failed, 139 passed with 6 offline,=
 7 untried/unknown (v5.6.5-72-g906ecc0031ed)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.5-72-g906ecc0031ed/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.5-72-g906ecc0031ed/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.5-72-g906ecc0031ed
Git Commit: 906ecc0031ed5fb7b4dfddb2c990f975e114829d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 98 unique boards, 25 SoC families, 22 builds out of 200

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.6.5-55-g6caa=
d25c36fc)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.6.5-55-g6caa=
d25c36fc)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v5.6.5-55-g6caad25c36fc)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.5-55-g6caad25c36f=
c)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.5-55-g6caa=
d25c36fc)
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.6.5-55-g6caad25c36fc)
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.6.5-55-g6caad25c36fc)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-g12b-a311d-khadas-vim3: 1 failed lab
            meson-gxl-s805x-libretech-ac: 1 failed lab

Offline Platforms:

arm:

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

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
