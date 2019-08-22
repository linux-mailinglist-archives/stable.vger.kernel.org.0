Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C5D99EB5
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 20:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388749AbfHVSZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 14:25:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35475 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388743AbfHVSZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 14:25:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id k2so6335756wrq.2
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 11:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JXgFg85dZHZEnnD7WQXs9gXAOtdzngXWL4jdrsUNdbM=;
        b=GmX1AqBPet8r79jDjJi8hF5vQKrbbCbw5FMZ+8hp3/jXlP3GYuPptXMUNxQMe34TO+
         AyLOfC/h1y2mnMy5C/v98b7PTZcIQ30xKt96Bk7l5SgUYv/lSduMgsMvjtYEdz7RSUVC
         vYLzTxD0eW/+CmGdz1NedvyYZewbs/Tiv6/lbvXpT2KKbjpz1Sq5ANZ2SDEU7qio04f+
         NgzbHx8FdDHgOvK/gm5rO0sVGw22L5Yu+OAUkPwCriPFXJVcx9+ZT9jUUKGezw5CD4EQ
         zQ8hilJq47pjOAgiHCeVISkXd3aNHKDBUxzebNW02VzfwO+gqeS+wkiRvKlXWOnQTgmL
         6T0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JXgFg85dZHZEnnD7WQXs9gXAOtdzngXWL4jdrsUNdbM=;
        b=l+XsmtqHnrg7we2f1lRGwlo8SfWoT8ZGKusC24sCdyg8LYBL03QKo6/1kJo7C6OkLz
         /MLcGIDVm62aOOOTPawEl0jcHAdr+hPdfQeLbSFG6TqiAXcBnZVpKjnPOCiLKkdwW05/
         Q/2Ifk+iUI9BgDbLxGA3WuuR14lONXAS328bZAf+zxtekncp6mcxDi550IFLg5KaXyQz
         hz+qS3C7plCmqirmJO9aRTm5l2Z2TQ+vmgSgUJRVKl575vVQOXdqaAP9pdIRq8R1KlV7
         EXG66GCg6BTBA0PZ9/+P6HRTh3YHGlZ7h5uScbJCqDU7hp8Gk6tvNdeM+fQ2vK4YaZ7/
         92JQ==
X-Gm-Message-State: APjAAAWJ35PDrfgS42T7VFsH2pfV5gcWif/QfooF/auzVbqC0Ja8e4ab
        Jj//Yn3dWykeIU46n3ri6cogdpSCKbTGiA==
X-Google-Smtp-Source: APXvYqxPJyUjBrPbUQUgVbeRuGC/4xe5kpstyHaKa5tsNWe7wap/L2lRMV3H8ONj97FfDvq0NEnr9g==
X-Received: by 2002:adf:e8c3:: with SMTP id k3mr385016wrn.8.1566498300297;
        Thu, 22 Aug 2019 11:25:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p9sm828180wru.61.2019.08.22.11.24.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 11:24:58 -0700 (PDT)
Message-ID: <5d5eddfa.1c69fb81.bb131.456e@mx.google.com>
Date:   Thu, 22 Aug 2019 11:24:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-104-gfefc589434fc
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 110 boots: 0 failed,
 94 passed with 15 offline, 1 untried/unknown (v4.9.189-104-gfefc589434fc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 0 failed, 94 passed with 15 offline,=
 1 untried/unknown (v4.9.189-104-gfefc589434fc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-104-gfefc589434fc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-104-gfefc589434fc/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-104-gfefc589434fc
Git Commit: fefc589434fcd4cf95d9dc24271b21e7913ef6e4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 21 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v4.9.189-105-g9c965ba1a288)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
