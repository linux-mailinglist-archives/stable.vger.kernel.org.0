Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69E51CDDAD
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 16:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgEKOvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 10:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730279AbgEKOvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 10:51:20 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64E2C061A0C
        for <stable@vger.kernel.org>; Mon, 11 May 2020 07:51:20 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ms17so7914928pjb.0
        for <stable@vger.kernel.org>; Mon, 11 May 2020 07:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dMESF5KYNsQWF6VwVtZKuom8od4pU9A9jSjTDCY02AE=;
        b=JbYZW8dW8QOsSWQsJs5B6116FEkC7qAv9Ni8cVPEzTiuS4bs2IbZ1XYopr/5PDFjtr
         WHFNiiLYCqG+1cC567Z6eHV2If7IZ/jbugFOjiPKsBWXedF0BQSHMEf5t7ZOoKej7Ttu
         yPOTQUTfkwaAx1DHvZqHUPBHo3D/tR8B7rvYxVK/FOlUQ9pQ3gP+TTYsnYT1YeMz49B+
         peT4mbPezZYelsMOoKmSoV4qh1YiTClt0NC8A+5BH2BNVHMEy4pRK0iu25+qHufmMleS
         WDvQ0mF2nOwgn4Nfv6PVXxMAt/nCMjhMiF373YX++m8nw/m+nUqgcc/YcjsfMITk8eqd
         H8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dMESF5KYNsQWF6VwVtZKuom8od4pU9A9jSjTDCY02AE=;
        b=C0RIpKqSfpCRBEpiB61hn+r6JWhBJmlAy2UaUw2LGPpXN8f0k9tBJOWQVJHL3NiD0a
         GrS41cnyA4RMsRN8mZ/mFnJEuTRKOI2osAiQRdNCPlzGHrPZVr3emD+QFsXtdSMhJ91A
         C50gPXu+UzkO29IqkbsGZO0bHnK0inWmqHrRIhOrCbPIDuSpTSC5yYan600AVX1T+CoD
         FKSsHtmhMWnAkJyFH8YYDjV+m9vwsVOJb3gyiwzZam83nZehGT2rSDOAeitZUJTKj+Xw
         muFXfWLZR2azkuX0sPbyoP+DarVRx4RtsdpHOIbUdBe1g/mvhLFxAVMMPwrvp/hDx2lm
         Hsxw==
X-Gm-Message-State: AGi0PuZ24T8n2eEpFxaKf1rs9SDiWr2yhXOFPjg8qhmnp0QbG4VFKv2R
        vZGqyRqC7lfo4ObN5xvJi4qpQ6a//+E=
X-Google-Smtp-Source: APiQypLfKhRdP4g5r2KNZA2Z2AyZ5RYKzQT2PH3dUUtVUOv0FrMIMYDtrgmhipBqPBUI/rz28+cT7Q==
X-Received: by 2002:a17:90a:80c2:: with SMTP id k2mr22674547pjw.6.1589208679926;
        Mon, 11 May 2020 07:51:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i185sm9454241pfg.14.2020.05.11.07.51.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 07:51:19 -0700 (PDT)
Message-ID: <5eb96667.1c69fb81.272c7.3597@mx.google.com>
Date:   Mon, 11 May 2020 07:51:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.12
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 159 boots: 3 failed,
 138 passed with 13 offline, 5 untried/unknown (v5.6.12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 159 boots: 3 failed, 138 passed with 13 offline=
, 5 untried/unknown (v5.6.12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.12/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.12/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.12
Git Commit: c4bbda210077280030b01adf17d2a5fb39ace668
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 99 unique boards, 24 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v5.6.10-74-g6cd4bcd666=
cd)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v5.6.11-50-g277=
49cf494a8)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v5.6.11-50-g277=
49cf494a8)

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.6.11)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v5.6.11-50-g277=
49cf494a8)

    tegra_defconfig:
        gcc-8:
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v5.6.11-50-g277=
49cf494a8)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    qcom_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

Offline Platforms:

arm:

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            omap3-beagle: 1 offline lab
            stih410-b2120: 1 offline lab
            tegra30-beaver: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
