Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514EC983E0
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 21:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfHUS7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 14:59:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53132 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfHUS7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 14:59:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id o4so3193886wmh.2
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 11:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Tl2/TXQtNTaDtW4k+V57ocrASJdTn6tXhvANUGDEdBM=;
        b=joIjPFhC0oBb2/lNcLeTSGJJHXu8wkOZ4l93jukGts6ukU/frYkoYrfIZSuiHwQ/5l
         WTQ0+G1F7MAzkqnrcd8wVIh9lKyX+C1AzHu6mTGCBdHLeD1mWs96SOipyLITmoth82QE
         Z3sPohip4Jdr6dyCqzmVsIDOMs4Ktk1ORSol3SqSAbjkSLmFJCpTkeaW0tjuYApWpuBQ
         Db6zHbJ+7i+sqY4r+tO7y2PeaBb+w0ZXaDMZh+7ukyWFCA2rhHWpaJ0JSAsqGU5Z4Uyp
         QJVng39oDdcMkpCiLfIMJQJSQIXmWXDgAmobO6YgK1qDYvDBlvq8xX45YzMmKw3zRudX
         1cnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Tl2/TXQtNTaDtW4k+V57ocrASJdTn6tXhvANUGDEdBM=;
        b=EqzXMZym4PewEb1CnwZMNJRsy2usj7Y6ZZPdsHrug1WSKaK9BKfwgKUbvZjX9bpR45
         Quz70ImrXHMwhZaKuozvPPwFUM6PVNCxAqcbXzkpsEr/Mxg49G3L9E06ckgubStFILzC
         Tb6yha7evFcJELGeLwgqJPNjf2ueMcB9Genu6O64P2Di+/H9FQU15T72L8x5YFD36CUr
         fVwMgkZ9czNquWBJMP18wlmHSqLSBn/FOQiTnUvnONEMQdRL5GKDvFOL4zGlMMw1Y7BL
         krkwvOr1V7dFOM054bvdUPExrHZi2sxAGIMew7e/6j7j+uO3tm00P21c+srj1S7OZPpm
         OBSA==
X-Gm-Message-State: APjAAAXl+BSCv2JVVeOBl456D1P9dSceirLbMb6m+E0qaFnO0qWG9C8O
        eOf4y5Tn31vVwVUwypIxuZY6KSt828lkRg==
X-Google-Smtp-Source: APXvYqwZ4dSJ+vupHHjpCuIHiIyc8ydG5mnqrHA8TyygrLJZqZ4BvX4z50+nIoxmnDyixaVKt5tPDg==
X-Received: by 2002:a05:600c:254c:: with SMTP id e12mr1676341wma.72.1566413982654;
        Wed, 21 Aug 2019 11:59:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm1338909wmz.16.2019.08.21.11.59.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 11:59:41 -0700 (PDT)
Message-ID: <5d5d949d.1c69fb81.2b829.63b7@mx.google.com>
Date:   Wed, 21 Aug 2019 11:59:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.139-72-g6c641edcbe64
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 124 boots: 2 failed,
 106 passed with 16 offline (v4.14.139-72-g6c641edcbe64)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 124 boots: 2 failed, 106 passed with 16 offlin=
e (v4.14.139-72-g6c641edcbe64)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.139-72-g6c641edcbe64/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.139-72-g6c641edcbe64/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.139-72-g6c641edcbe64
Git Commit: 6c641edcbe649a2aa866356ffd24f595edb17bea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.14.139-62-g3=
f2d1f5446a4)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.14.139-62-g3=
f2d1f5446a4)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

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
