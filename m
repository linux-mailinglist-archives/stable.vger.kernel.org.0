Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F7C77F9E
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 15:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfG1Ncr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 09:32:47 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:54289 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfG1Ncr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jul 2019 09:32:47 -0400
Received: by mail-wm1-f48.google.com with SMTP id p74so51534464wme.4
        for <stable@vger.kernel.org>; Sun, 28 Jul 2019 06:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2kxkwEYCpDUpeQFdcpRUngdMvGEBJ0dBoadMOcCFZZA=;
        b=pvNZfL+Gb4FeVrSureHPbwfolFjKBYcd20sj/1o9QTYr2MeskzgB3MTelS2/CMN/8j
         9aqqdN125wBuEffnF3oeOK8LfpDYHhE/0HrmHTNj6YdxOPBIzLBGtHN9coiwiUTKDGjC
         pG035t/QA9vIwuhIiocjp7uG0AguX01zd2c1f9mIwWhKdiA4huPeyTZFhYNLrkHnK5O9
         oHJcoihgllbxZVIfzBRAX1F4V0FjZvlmytbhX+zcwig2Xxnq51BiIuvXLsRXFoWVxC5u
         jf50WOh1bMV7d2J9tFmjRRsJMo8/RkrRQiWzMZ4hHZKi4o/UNIGt3dULFXhM19VZHNlT
         nBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2kxkwEYCpDUpeQFdcpRUngdMvGEBJ0dBoadMOcCFZZA=;
        b=GheYaKpRnwADl+daNMCJp+uDvgB3jjdsP/JuqFBnr2pVctohfO4NAuaSdN/roR2vXf
         xC36uVN1tKM7Xr0tr2uUW5WfYsG4EYOdr1H/Qi9mi0uivSMvA+AcuNdOHs/StVwpi2jg
         MtkS/lY7rC5qsaa/xL4J/Ukfp8AK49ldNXFiAE6dbvKlYkVhwBJ+/+dja/C1MYuQZiPh
         7jsHd8hO59k3T54iD26ICkjBko6pRu5lvIslG40Cl6MiDNrUDApIuR9C8FvdgB6KuaHa
         WuKqpGTeXuKBFj4Pb37zFhbLc5rCXp8GTBX5TVxmA7nZtTvx4VZd99nl9NIgC72lq86b
         snNA==
X-Gm-Message-State: APjAAAXpLgtMWrfnOGqhsxN0zHF/LfS+EHOwbPrsDz60Pa+CGdAZKuwA
        pshK+nBYsBvUdNGDE9s6ldEXq8cY
X-Google-Smtp-Source: APXvYqwDRhD1/JekkkbgN6Br8x1MPaubQI20zHjsqF2Kkc4UcCexs+b29G32eZY85lHlboGn4KnoEA==
X-Received: by 2002:a1c:7ec7:: with SMTP id z190mr93031152wmc.17.1564320764938;
        Sun, 28 Jul 2019 06:32:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b8sm76059642wmh.46.2019.07.28.06.32.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 06:32:44 -0700 (PDT)
Message-ID: <5d3da3fc.1c69fb81.843ee.bfac@mx.google.com>
Date:   Sun, 28 Jul 2019 06:32:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.4
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 100 boots: 0 failed,
 55 passed with 45 offline (v5.2.4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 100 boots: 0 failed, 55 passed with 45 offline =
(v5.2.4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.4/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.4
Git Commit: fc89179bfa10dd243fce24af71cf622267f31f2f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 25 SoC families, 15 builds out of 209

Offline Platforms:

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            meson-gxl-s905d-p230: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            meson-gxl-s905x-nexbox-a95x: 1 offline lab
            meson-gxl-s905x-p212: 1 offline lab
            meson-gxm-nexbox-a1: 1 offline lab
            rk3399-firefly: 1 offline lab
            sun50i-a64-pine64-plus: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm:

    exynos_defconfig:
        gcc-8
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
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
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    qcom_defconfig:
        gcc-8
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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
