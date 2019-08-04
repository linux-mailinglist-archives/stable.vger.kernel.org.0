Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAEB80C32
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 21:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHDTfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 15:35:10 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41129 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfHDTfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 15:35:09 -0400
Received: by mail-wr1-f52.google.com with SMTP id c2so79034895wrm.8
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 12:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ztH2GsDa8MqcDazPLVbRvmmtdIQgoH59KRVRHgLTTW0=;
        b=TmcbbsDQX9clFyCg48YgvbG7xBIZNFf7yEbraeAOSAmz0OoNd5YfpqRBTNdleW/HFx
         UJY3WogAcLCLN/gTcKTiR52IEtFZs5Yg+iq6HUMbKj3q1zrbqbvtrWSYqBHLsRQvgpDc
         cjVmbE9tisxnrdQzK04KxkXmW4MlCVy/fKTdSd/2Mp7GQ+WRGtDg6rlHNvlEt4gGEyt2
         QaC/IdvRL3BHISqokK0Uc0SmNmE7OEYX8ivllTOGvPjkVt0Jjw6dSsVb7jr7EuwG78yv
         5Jxni4m7Af5JyEUJ4wdke37lg89m3SkXOtg1PvhRjZ9Nwx2N4afRyBpoAjNT7+Rmrmq1
         cdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ztH2GsDa8MqcDazPLVbRvmmtdIQgoH59KRVRHgLTTW0=;
        b=dR/i038Tw0qGaD7RccrwREYXi0FyKzeysPRrH0l/ixFXP8rWpA/0UDIgbx596rSMGv
         dzvKC8fZOEGwoClIl8btVQBfOHRmOyh7O0wJCYR799Heu6IU2AEsVrAgWoTYEKC8oew5
         2kuCvUCeJWC0pPVF1kGI+0lY2bYOofW6TJX4tXZICZrx7XfEgPWJ05Y9G4c3UMGUiC5p
         T6eSHUhRlUWVwbR8G6lGWC9+7kjjZDmUcaeYRI4mUifd7pQDBX2aoruHUlTFLJUIStMD
         EK8jJ12YPQ/fSQrsmdj6IQ8lo5dSB3Fycms4uivsm3R1XZaXqAUq8qyBGzmwmzRyKZUh
         EgbQ==
X-Gm-Message-State: APjAAAWqOnz767TVhLRYhBNCFCvcPrvxRMfg7IcJq78ziqi0UImlDcZX
        0gVgY0svOysMGctlWG7ZdO/smeOc
X-Google-Smtp-Source: APXvYqzes0OwQeyp6W7YNdPzY3WN2WQbTRnVee5iYe1i1eI6Yy1Xnc0usLgc8K0xwpZLoRtLCUkDNA==
X-Received: by 2002:a5d:518d:: with SMTP id k13mr62733148wrv.40.1564947307270;
        Sun, 04 Aug 2019 12:35:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i66sm146412627wmi.11.2019.08.04.12.35.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 12:35:06 -0700 (PDT)
Message-ID: <5d47336a.1c69fb81.a5d88.a34d@mx.google.com>
Date:   Sun, 04 Aug 2019 12:35:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.187
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 91 boots: 2 failed,
 51 passed with 38 offline (v4.4.187)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 2 failed, 51 passed with 38 offline (=
v4.4.187)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.187/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.187/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.187
Git Commit: dc16a7e5f36d65b25a1b66ade14356773ed52875
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.186-157-gd=
9815060e3ec)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.4.186-157-gd=
9815060e3ec)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.4.186-157-gd=
9815060e3ec)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    exynos_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

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
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
