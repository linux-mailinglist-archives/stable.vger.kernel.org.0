Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B445C1E11F8
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 17:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404040AbgEYPmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 11:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404002AbgEYPmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 11:42:38 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17443C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:42:38 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s10so8815285pgm.0
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OGk5pozyHIefNgLNvb4uF33qKNNKxqWTxhU/7jjEiUw=;
        b=bAti3pASVmWDsQkuBot/fl+ydzMKq1Ehdamdc3go3uwxMCZbW7RVV8S6muB+4tzu1U
         1KOPcaz9lUxxcmA4650r1kv0y0uTb/Fdo56c466fGshM76eKxCn92bnZuLu9bw0azDvu
         CIr7ngJNRYG8uiwu1ThNyERYrPh24iOftXrAXB4FFWc3NHPUbZFvpR8R4hMoNjPvjvc5
         Fvd6jga0+4EKLfKE1Fj6OH102XoBvN1jBuI2mnSWVwr6ySo57RaddHHuRxC49hyuNmiN
         RRMM4BJEbstFpZjIQfddRAiQVpCWkcKuOyHOXsEHpltWKrnHMLTycwri2KT8yMF0rWqo
         ZwqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OGk5pozyHIefNgLNvb4uF33qKNNKxqWTxhU/7jjEiUw=;
        b=uYx7osS5kwnkTw1+lWRe01TWC9z5bvAUJRPfF7OqDgCgpr5PyWPAUn8dWw+Ka4wAUg
         2ObE35+pAo0zmbHY3XfgZJYE4qhd7xliSGqaXkGqquG10XYzkd7lNyYy+9irb1gEVvBy
         M0nlklC5C3FoCX+rw6NA5sUXbVLtAK6S17Y4x/Xbq903GGt/MO+2H5mJtTO0wUkXI2GY
         KMjk7Snb1J7hVklZlq69UhBt08ZBG7VZ9QZ1+b+NPcU/6a6sVeqJwNlEv3/21Vc0CNtQ
         HCTud0z+LWGi4xgZgJOnqE6XmGKH3GfmB2s14G1K7oZ+wsQ1S8wh3dDoKjnK4owXM2Fu
         Zzug==
X-Gm-Message-State: AOAM530abHS5sL7wZDJjClD/FkDJQhnSd4KJuf7xL83Wta2HrVYx++ut
        s1NhPGgqWB78YmRaDUwr3K/yU1GATeY=
X-Google-Smtp-Source: ABdhPJwqurlj/tfhQkf9G05itk24GW+Du9Sr7Q/pWXxevzbjXkb90J8Qefl2vUwuFwhax4XdWFMS3Q==
X-Received: by 2002:a65:5285:: with SMTP id y5mr5326872pgp.271.1590421357213;
        Mon, 25 May 2020 08:42:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u73sm13725561pfc.0.2020.05.25.08.42.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:42:36 -0700 (PDT)
Message-ID: <5ecbe76c.1c69fb81.a2ca9.4c13@mx.google.com>
Date:   Mon, 25 May 2020 08:42:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v3.16.84
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-3.16.y
Subject: stable-rc/linux-3.16.y boot: 59 boots: 53 failed,
 0 passed with 3 offline, 3 untried/unknown (v3.16.84)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-3.16.y/kernel/v3.16.84=
/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-3.16.y boot: 59 boots: 53 failed, 0 passed with 3 offline, =
3 untried/unknown (v3.16.84)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.16.y/kernel/v3.16.84/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.16.=
y/kernel/v3.16.84/

Tree: stable-rc
Branch: linux-3.16.y
Git Describe: v3.16.84
Git Commit: babf7e4a11200d94219dcebd64f50e6304bbde2e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 11 SoC families, 15 builds out of 187

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          exynos5800-peach-pi:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          omap3-beagle:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          omap4-panda:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          tegra20-iris-512:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)
          zynq-zc702:
              lab-baylibre-seattle: failing since 25 days (last pass: v3.16=
.82 - first fail: v3.16.83)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu_x86_64: 1 failed lab

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 2 failed labs
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab

    mvebu_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab

    bcm2835_defconfig:
        gcc-8:
            bcm2835-rpi-b: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-evm: 1 failed lab
            dm365evm,legacy: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle: 1 failed lab
            omap4-panda: 3 failed labs

    multi_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx53-qsrb: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-sabrelite: 2 failed labs
            imx6q-wandboard: 1 failed lab
            omap3-beagle: 1 failed lab
            omap4-panda: 3 failed labs
            qemu_arm-virt-gicv2: 1 failed lab
            qemu_arm-virt-gicv3: 1 failed lab
            sun4i-a10-cubieboard: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            tegra124-jetson-tk1: 1 failed lab
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab
            zynq-zc702: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx53-qsrb: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qemu_arm64-virt-gicv2: 1 failed lab
            qemu_arm64-virt-gicv3: 1 failed lab

Offline Platforms:

arm:

    imx_v6_v7_defconfig:
        gcc-8
            imx6q-wandboard: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
