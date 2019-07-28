Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07ECF77FE3
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 16:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfG1OlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 10:41:11 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:33401 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfG1OlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jul 2019 10:41:10 -0400
Received: by mail-wr1-f49.google.com with SMTP id n9so59176025wru.0
        for <stable@vger.kernel.org>; Sun, 28 Jul 2019 07:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BkDJcNBpl5tVqh506tPOlL6KEnJUr8CKgiECzvqtXQ0=;
        b=UGPPKEf9m/pQGPcBkyh89JNwxf8Vm3/TirfuHCaf7heuUOMR9JhMlhreE8p1da/Wuu
         93LtV+cR8GXRR1KK+iN7mTfWukWlpOcrvHFW/PcZRgTXhzPM3vObsIxnWH5RADAXDKNK
         l1GrV15FWIb2gVtfWXymZLN0RhpRUDEMnTywxRjEMnHbkrRWwz+ka/yjYxbxYQf3uB18
         rkeuqFSw3skW3FCf+70RoH+rnRhu6vvO8QhrkaZif9vrJ/1eHwHYfmurgPVUpriPa8cz
         CB3ErxYqU1Ll6ztlUV0JTMtQGuWaxp6E9c6C3pT7PAN9XaS4ncMPkf0dw8Z2favPBlJ+
         6uOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BkDJcNBpl5tVqh506tPOlL6KEnJUr8CKgiECzvqtXQ0=;
        b=VLLUYiYe5LHdIaErctzI0wWspsCZuFtDh62s+xY/K0zsPg8lPEfgoB9DnO8ONxq17Z
         GUcYM74Is7kHLAtRT2TYo6ZMKUHpnwVuqByj/n7ciQFcCUsIu7jsZ+4TCiNR+iw6+WcV
         EGdsMz4cT3ZpweJU07mr7djr2aJizcpsYNXg+jGclYUt6GHK8fbFnLfpWLxjLPLmzgCn
         ePBn/zUgoxVwtRvdeKWWlglOcuEqpUmuZO8b9Uscijur9hybka+J15Reca90ksJfBEOD
         mMjP7CSrpcapkguktY+RFrYQEGXA9CNskGDvIYxlCs61zLKNslub8LRBXFO+St9lvxX0
         f6jg==
X-Gm-Message-State: APjAAAWVvVtwyiwE7LD1aEukAt2UiSMJ2MIfNlO6RDPM+vw2puDQaDM1
        hWqTHaeiuYsKV3c4kogBvihNSkiU
X-Google-Smtp-Source: APXvYqxHVUHEpaP8Pqk4nRnsE4X6byAF6XKto8sUotA/TvY/Uxz9bpIyAoM+akGE4S/AA+ngFeOMxA==
X-Received: by 2002:adf:cf0d:: with SMTP id o13mr69227646wrj.291.1564324868215;
        Sun, 28 Jul 2019 07:41:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v5sm66040468wre.50.2019.07.28.07.41.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 07:41:07 -0700 (PDT)
Message-ID: <5d3db403.1c69fb81.5beb3.c71d@mx.google.com>
Date:   Sun, 28 Jul 2019 07:41:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.62
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 91 boots: 0 failed,
 51 passed with 40 offline (v4.19.62)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 91 boots: 0 failed, 51 passed with 40 offline =
(v4.19.62)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.62/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.62/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.62
Git Commit: 64f4694072aa4ac23eb9ad2feeb0a178d2a054da
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 24 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
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
