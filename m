Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 931729816F
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 19:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbfHURhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 13:37:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40908 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbfHURhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 13:37:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so2822037wrd.7
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 10:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f10ppWvzWmAiSdC3xLYqfXuglgZ1MUmveUhhNNlJYBY=;
        b=ndrGyCcG9mksjbutephWmb1l4iX7BjUsosSnG+H1b3JtPfVF3bSWmQoP4J0FTuWSz6
         sS1tA4fFya1SWf9iIh5CVL1MeCfiJRMMhM4hBs6Orl1Fn02tUz29p53/boQsxFXPYFa/
         HYY5sqWEthyqPi5UbFedQoO9A79HZITQjckDu7qsCYaS09W4zye8SjJ6m7dogpaLtWh1
         iZqL81LDrm2nHDF7MxtqROTwNdHW7bPT2+7dtMWDGZGKFSFgAHIFUpQd79XMq0VD084j
         6chIvmculSm6KokRYo4mcH5PyMODBuGjjcmJU1iU2d+2H2TGoM1vLmLUdkIcXSYa3ZF7
         KhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f10ppWvzWmAiSdC3xLYqfXuglgZ1MUmveUhhNNlJYBY=;
        b=doEwQ2AaQ3XhgVmGxXqrd+nsEdW4jAXnDcAHAVsn6gDdeCVhBgZTcIrh58kdi/pgg3
         SkH10G24V2zcLT34TSfwc1aZrFp31A0ZnvLv3bRf72OcR0LuzBFI4OQgM51BMdyGE8iU
         jSthEMZnrcSaYzD4NO7EuEscIh5XnNKuasFJklJMa3OA7bESaYpJV0+M7fNA5aFzEvh7
         OrDa+Sl7pLGYqNYgLZ83RRMI7q5WCfwciSwPPdeVoeA8jtfXPr985HW+tkLWB09sDxTo
         trBBN/qBhKmlkXat4/IQBr2huDBoFk/IUaeBoYAPLhCpQSrb/RZFWgiNrAjnFsMzQgqL
         HHJw==
X-Gm-Message-State: APjAAAUklG9LENWwKpaRhVbxEwOnmRYqwEEvFmmwr6DSGJb/8jQgrOoI
        f+xiQZSW0+mEDNijfkBuKIgbiLiU+oiaTg==
X-Google-Smtp-Source: APXvYqyWb5o8ghZ05OvuNbv3KsFXsyzfDqlXlBllRknGUrPlTed+MY5cWR1l3gD2nxfwL2P3877vIA==
X-Received: by 2002:adf:ecc7:: with SMTP id s7mr43753254wro.215.1566409033353;
        Wed, 21 Aug 2019 10:37:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u130sm1448630wmg.28.2019.08.21.10.37.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 10:37:12 -0700 (PDT)
Message-ID: <5d5d8148.1c69fb81.c7cac.70ab@mx.google.com>
Date:   Wed, 21 Aug 2019 10:37:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-105-g9c965ba1a288
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 105 boots: 0 failed,
 90 passed with 15 offline (v4.9.189-105-g9c965ba1a288)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 105 boots: 0 failed, 90 passed with 15 offline =
(v4.9.189-105-g9c965ba1a288)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-105-g9c965ba1a288/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-105-g9c965ba1a288/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-105-g9c965ba1a288
Git Commit: 9c965ba1a28830bae31287b606dbb5479b7e4eed
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 21 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

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
