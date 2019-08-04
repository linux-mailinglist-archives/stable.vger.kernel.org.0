Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B380380C3C
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 21:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfHDTta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 15:49:30 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:36328 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfHDTta (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 15:49:30 -0400
Received: by mail-wr1-f44.google.com with SMTP id n4so82354555wrs.3
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 12:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NhTGRybWtuUPpfvNNWWl+JVeaxjYEr8I61DYHRBcUqw=;
        b=TH7rypCmE1q86Y9V1t8jNfK4fU2GK5EOj5bGshDTKeK7DsqJ6laz4XILPdfik2Z1jS
         QiQVz2Y58uLlSwu57pBUJZ/6VcP3GPllwtBuo0McJBFZ+KmFMnw3UN3SiwaHhm5EDV68
         PI/mBQlakPu89NsCpU1RB7fo1CQXMW1yfOD69aMK2gMzwEAZ011d0/tEHDIoBJrSfGBF
         E4RFUYj+dCcXV3zCE/n1xJJuPhs1e/MiGlabXflkmaSc1MNzc9BV2L0RzV1+3ar4gFtc
         +QOxjvexr1xq5IHd5v/bInLFTk/wyaEQGwS4iRMDuXv/QSeMi6HJVAI6XzBaAhDHxl2m
         enGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NhTGRybWtuUPpfvNNWWl+JVeaxjYEr8I61DYHRBcUqw=;
        b=mWz4OSP0ATSNOPp2I4iDcZWj3JeOtKh+88JeUIHc1i5qfC9NdwVj4ybPzZ50N4N9P4
         H9hqFDOxT3P3W+O938rnQOO1IvPHXG+udPeSIUy7hqSem9QT9iSTcMR1MDNjMH6BPUas
         INelZY1q6wLWRDB5G7bKssrdm0JA634fm1TkISiYD/VLSSFtxVIpn7uiBkcxi+0YF7b6
         jDiArcVbajK4FJmnPLtf8gDw/AZTtwFGDtpvGEzaPO54Og9iP7btHoMnGD1bxWtoq4Jx
         +tzUG9/W+SBGOXGv1AhGefO/s4K2A9rapgaSSoPQdmp+ojweHWft8Va4bx6MJ6iMrK+H
         Ip7w==
X-Gm-Message-State: APjAAAV0L4mv1tNti4h016hUTQnLbnMC/AlwdyaIKvrcSeE46eQc+DZb
        OddcC07vBCu9aw61BvkULxXD6mND
X-Google-Smtp-Source: APXvYqz2IvkiKA+mP/t1ypHYau9RtaXnf4KAE5ptE5vSUkSXfFpMla7ljFITctK7FAwM/2/DDYek9w==
X-Received: by 2002:adf:c003:: with SMTP id z3mr74784516wre.243.1564948168264;
        Sun, 04 Aug 2019 12:49:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o126sm81126835wmo.1.2019.08.04.12.49.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 12:49:27 -0700 (PDT)
Message-ID: <5d4736c7.1c69fb81.f48b6.3243@mx.google.com>
Date:   Sun, 04 Aug 2019 12:49:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.187
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 98 boots: 2 failed,
 55 passed with 41 offline (v4.9.187)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 98 boots: 2 failed, 55 passed with 41 offline (=
v4.9.187)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.187/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.187/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.187
Git Commit: 97d7530b83e3f515d5a3242019fdc2b5848d5a7f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.186-224-g5=
380ded2525d)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.9.186-224-g5=
380ded2525d)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.9.186-224-g5=
380ded2525d)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab
            rk3288-veyron-jaq: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            bcm4708-smartrg-sr400ac: 1 offline lab
            bcm72521-bcm97252sffe: 1 offline lab
            bcm7445-bcm97445c: 1 offline lab
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            meson8b-odroidc1: 1 offline lab
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra20-iris-512: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
