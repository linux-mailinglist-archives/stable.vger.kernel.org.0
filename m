Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34C1A09E1
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 11:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDGJRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 05:17:42 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40853 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgDGJRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 05:17:42 -0400
Received: by mail-pj1-f67.google.com with SMTP id kx8so481521pjb.5
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 02:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GzYQHO3dOBXVmi7ok8kgG77XkQCXHqhkBDw4+j4Oz+4=;
        b=I7VWp4hRDCteKI+lN/nBW1Z4rrbyx/hwQxvZxL3dzXUEjKjGAWaGaEmvusPxuRgADp
         B+tlmzUTqJ2UMRbnHAd+WSLNL7DUBmUtQmM2BXk8cx5hscf5MLNR2rNSgx13DATbhLs4
         rrOcRkrqz7IL7sUYZ+iwOaQ/IDE8kiV2w6aMUL3DkrLAxxyMb/WjvJmuYIdsGpAyPztb
         RZ3r2PV3RX20FI9vz+jhhPBapqpRTqzdsqf0q1aHnPeZw+EQC8iXsH3ZkWoDuQwBKY7E
         w8PH/99xiJHKOA9VlFl512jJqM32fy2qngPwErnKrLhDzYN6R0UaCjYe+vR27Gae6x+X
         AGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GzYQHO3dOBXVmi7ok8kgG77XkQCXHqhkBDw4+j4Oz+4=;
        b=YPmVkZHTTQ+8VCUb4IXL8vtMYPaYtp76by6EW6uwKFaFfLQaHoaMznk+xP/as+jQaR
         /b2CHIcfhIn5KkC80pN9KxBPD6EPWophqPwdbrh1NiU2caIziYAFm//oifBU0AcDYPEL
         Ca7+aox7KwD1BRLzVpyCQg8ITj9e+RAhabUAVfITIzdnqslTsFNEjAuoVKpHErKFqsYA
         LmDUn3JEGS5AQyFCSeSIxu+a8lGv0CSh7pLLx3SgQWA4zEWzGmGc/Bx5AA/DDa6M5wWO
         n20lluX5ZI4XCFH6suVzlh/MunOXvDdi01uWqpyQjAxmeQyP9AVIYWd6AyWLeQ/JmCCb
         cSEA==
X-Gm-Message-State: AGi0PuYXYBdxw08tJNjQkSzvqi7wiTLPzBbzmakyyHlkoHfBJwi5eXPc
        QaHciAiiL1QPA1dYXoEqjQCHzNpwUYU=
X-Google-Smtp-Source: APiQypJy9E362MyQjHMrWdLxw/CDS5TLn6nBKiTm0vUZ1eJZF/i6DkZYuTp3TFngpATYo62h6qlKnA==
X-Received: by 2002:a17:902:8c94:: with SMTP id t20mr1551586plo.170.1586251060938;
        Tue, 07 Apr 2020 02:17:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m7sm1085784pjb.7.2020.04.07.02.17.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 02:17:40 -0700 (PDT)
Message-ID: <5e8c4534.1c69fb81.304e.40fa@mx.google.com>
Date:   Tue, 07 Apr 2020 02:17:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-22-g6e19c6f2d265
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 117 boots: 3 failed,
 108 passed with 3 offline, 2 untried/unknown,
 1 conflict (v4.19.114-22-g6e19c6f2d265)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 117 boots: 3 failed, 108 passed with 3 offline=
, 2 untried/unknown, 1 conflict (v4.19.114-22-g6e19c6f2d265)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114-22-g6e19c6f2d265/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114-22-g6e19c6f2d265/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114-22-g6e19c6f2d265
Git Commit: 6e19c6f2d2653aebd7d307ec43293f579e21604f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 21 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.114-13-gb06cec087=
43b)

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.114-13-gb06cec087=
43b)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 58 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 25 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.114-13-gb=
06cec08743b)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab
            stih410-b2120: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre-seattle: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
