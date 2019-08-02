Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F67A7FFDF
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 19:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388134AbfHBRuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 13:50:03 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:39737 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388634AbfHBRuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 13:50:02 -0400
Received: by mail-wr1-f42.google.com with SMTP id x4so24858156wrt.6
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 10:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mTsP8u45s6yEGfk0nYr3to4FXJXYScRjLnVF5NOooAY=;
        b=DCgGUisMEeqmTtBkFZeVTSZzL9WpcVupb6k30mnNUSxkqeHGkxSPEPsXEYb31u2O6U
         WAZdfYwIf55wOUOU56NM3AM832XiAAwBZX3wMbPX1lAwf1NHGOxuCcvrykX0TAH3jDeR
         5sqvl7B3Qaew23hggxgLijYhDYk0/+EZSCAEq1aFNVFGkXekKGoThNYCkjR5ZOZ9G/YF
         LOtSVG7F44qSlLd6mBR1xblSGqMvPouoIWg5iY3CYS6wiT3DgFeS3uyyhhj3Quj8I/jC
         eOPPBReyWYEk3FK1PEPKcD1eaZlaSu8/kiYqYs1C6SVeh/fV44FKhyXrv+fMDuCM3LG7
         86cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mTsP8u45s6yEGfk0nYr3to4FXJXYScRjLnVF5NOooAY=;
        b=VJT6Cc8q4reX8hon4Xvmy1+pjdAO7ikzJTSJPtQ0mw6Uj/vhX5hngHpepQ/k+nnUbz
         Iy7mEcAU0WUOyhN1M9uz0myrQVKsjU1YF1m2xgD2l4qBPgUvTw0qB87f2rCc7DptFqMR
         yRsc/XvBZUJf7mKF3lFRe/d84rdKutLaMRG3iU8oY2MPCfKltvP2+CR26EoWXgdDl4XL
         542yguf9IVAHikFNrZjk1U1GJpn8vNYwtoongxg/aHwjakq1h4kFESaAt70/3/kuMsPg
         7SwgOq9iUkTQqi1wD/4hRXeecX/cHEmRsJYzTZ6eMCpPlH0NY3XPj4C/tuJUyaa18EPB
         31+g==
X-Gm-Message-State: APjAAAUTjgYdonWMO+NOjW4X7bhhA2uDtI2WBcWha2AEYOFhVR4DT8Yn
        pVoBEWkwFXO2buR7Q/VziMDcfqIrJ10=
X-Google-Smtp-Source: APXvYqz5E9miqyBkAFUG+iThL5AqSa8iq21FZBpEv8xQKn0PHOwnyCGLgi1/3pYS6bk15z4s31BbyQ==
X-Received: by 2002:a5d:5692:: with SMTP id f18mr102274372wrv.104.1564768200493;
        Fri, 02 Aug 2019 10:50:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b15sm94091546wrt.77.2019.08.02.10.49.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 10:49:59 -0700 (PDT)
Message-ID: <5d4477c7.1c69fb81.73527.6789@mx.google.com>
Date:   Fri, 02 Aug 2019 10:49:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.134-319-g0931704b8bef
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 119 boots: 1 failed,
 77 passed with 41 offline (v4.14.134-319-g0931704b8bef)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 119 boots: 1 failed, 77 passed with 41 offline=
 (v4.14.134-319-g0931704b8bef)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-319-g0931704b8bef/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-319-g0931704b8bef/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-319-g0931704b8bef
Git Commit: 0931704b8bef6a8df2c0b08bac6f77a17bab0711
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 26 SoC families, 16 builds out of 201

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
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
            tegra20-iris-512: 1 offline lab
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
