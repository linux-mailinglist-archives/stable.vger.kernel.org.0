Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AED91BEA23
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 23:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgD2Vqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 17:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726511AbgD2Vqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 17:46:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1364C03C1AE
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 14:46:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a31so1308470pje.1
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 14:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=89WfxPc9aLfKhd487qSESDBiYgxgg5OVgClklUfNRuI=;
        b=1UCYuhhdwRs1ncYpyFojczrmCdv0CMRSpEhFVBBm2sSZ5TmkuGbQqAYFErFwsaI32L
         45OS4jWcOmc4hwsRYgTXUs/ND7yJwPBRscZj7hgdYS/Wp4h+1Oi8CNpYrIEWMXdW0025
         eT8EeW1ehuj5xeS6osDSndNa3BlwWd5qIcg1gexIaB/Mpb2Ek+DJG4a/WpkNCj+pnwbX
         q/ja15tgkRAAaKlNVBWujQ6THucsVedYUNFyJby3sl8E7MFvhV3cPD2tX+su1dfS4w3X
         huyuLosvbLfbUZVe5wDpqatqEGqxbCPqMYppwCYcCeoIZoKGTneVU496gV5t0XZcmONv
         Rz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=89WfxPc9aLfKhd487qSESDBiYgxgg5OVgClklUfNRuI=;
        b=A3KCGYZyD1q2OHx2YnFuQ5DFCQhri5eTEIbg18wKeA9RqIwI3D7aKunrNHNqnqkpk3
         xGPO4cvB5+RclYlfSBbRJiWeOspoP0fpm7qaK3x4SY0nXaCH65+IuHX4zrKFq/vwVBGA
         0EsfByYjY4dyljMgyEhh9UdKx2jVBzMY+iohtMCksFp7QRHg8Gmhr5fKIdCmQjHgOKjf
         Lv4QU9PuSIa7SXNQprbCV3IBXkm2t+VjZgRFFwGlVS0SsBSGMR0J6JIrwrC/dyw33ysC
         hQ3cryTaV/joCxTeNwE0fR31W2fk7SKhzB39sqrGSJWU0wim+f0Pc7/wuJUV24zXqc3i
         kYzw==
X-Gm-Message-State: AGi0PuaOh2kmtTcGzsbfBhOxQ06D2GZGwn7nAHUXWoLc09SOizJocqi1
        D1FBs9me/Vn3ihEfD1E0QYMiwlvgweA=
X-Google-Smtp-Source: APiQypINZD2SjD2FYyTnVlhUAtHKWtoqBDZHdnbuKQJ+avbkpSBR0iNJWph5JCQr5/0C6aqE0QFSkA==
X-Received: by 2002:a17:90b:155:: with SMTP id em21mr560094pjb.59.1588196794763;
        Wed, 29 Apr 2020 14:46:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l64sm182104pjb.44.2020.04.29.14.46.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 14:46:33 -0700 (PDT)
Message-ID: <5ea9f5b9.1c69fb81.dba4a.0f2f@mx.google.com>
Date:   Wed, 29 Apr 2020 14:46:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-3.16.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v3.16.83
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-3.16.y boot: 71 boots: 64 failed,
 0 passed with 2 offline, 5 untried/unknown (v3.16.83)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.16.y boot: 71 boots: 64 failed, 0 passed with 2 offline, =
5 untried/unknown (v3.16.83)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.16.y/kernel/v3.16.83/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.16.=
y/kernel/v3.16.83/

Tree: stable-rc
Branch: linux-3.16.y
Git Describe: v3.16.83
Git Commit: 92f17c867833bbfdaced034629afb8e30a19e882
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 11 SoC families, 15 builds out of 187

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          exynos5800-peach-pi:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          omap4-panda:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)
          zynq-zc702:
              lab-baylibre-seattle: new failure (last pass: v3.16.82)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

arm64:
    defconfig:
        gcc-8:
            qemu_arm64-virt-gicv2: 2 failed labs
            qemu_arm64-virt-gicv3: 2 failed labs

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu_x86_64: 2 failed labs

arm:
    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            omap3-beagle: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 3 failed labs

    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            armada-xp-openblocks-ax3-4: 1 failed lab
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-sabrelite: 2 failed labs
            imx6q-wandboard: 1 failed lab
            omap3-beagle: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 3 failed labs
            qemu_arm-virt-gicv2: 2 failed labs
            qemu_arm-virt-gicv3: 2 failed labs
            sun4i-a10-cubieboard: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun7i-a20-cubietruck: 1 failed lab
            tegra124-jetson-tk1: 1 failed lab
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab
            zynq-zc702: 1 failed lab

    mvebu_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-wandboard: 1 failed lab

    bcm2835_defconfig:
        gcc-8:
            bcm2835-rpi-b: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-evm: 1 failed lab
            dm365evm,legacy: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 2 failed labs
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun7i-a20-cubietruck: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
