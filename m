Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408FB823F8
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbfHER2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:28:02 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:52008 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfHER2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 13:28:02 -0400
Received: by mail-wm1-f44.google.com with SMTP id 207so75547403wma.1
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 10:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RzHMiOnu0E/vzeqnz6OQSYCDgnQPYk0slkQPna4Gc9I=;
        b=IosCdmCYX6oNqQVMtUURYRhIGZ6jggwXJL+N8A9RJuViqmtWZjpa2NowqupqBrm8gm
         Xjhb8XwFUzeUahBvRLVnkf51nrBgnJeAEu4AxJFXqJPEUPN+TGW3/u20UmeNokLFu/L7
         oR4Qg2+f8TP7YbFyTLjde6eC2AWCIKAbO49VFvxYvzsE0pWu2x3RWOfA6OQj0mrpZuHH
         5GZrYrhHcS+SqCVpHi+06expvcgmiTq7ReKW6mVUH7dRYVyFwQoBDVePD2kigAo9LFFt
         4AGqnGRuJbJ6ZI7jlt5QX4BG/YtH2gc0ih1InSXQ9kdmQJve1oGMM1M6usQWCGRo6SPk
         9gPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RzHMiOnu0E/vzeqnz6OQSYCDgnQPYk0slkQPna4Gc9I=;
        b=gSxQ5Zn09mokyx46N9b9pyC0Gzaa2MyZZRxmm2QwQO3gRnPXzfSRjy9QeBqyY3FUFu
         6G1qmSxpUUznmYwUe3/Teb+A/+H7MhdhSwYWet560cnIzWxPfktSOYNsUFKdwr7u1epo
         W6/o7v6BKpTJlGH5/olK25b53fVAVbgvZ8FV9FouelUrJwd0Onej3PvPpQBDTBJKnAyM
         bp8RFOdFCNRSoBzvvQU27zLIeOZ525g/Zcbz4gSQi64RJ4ght8ajiPy4MqDowRGMUabQ
         rnoZyoK86YxWMRzdw0oh/TDDtmYwaM7I0Af3nrmPkWqJQUhSH3AAF8dligfAhfgk64Tp
         RfGg==
X-Gm-Message-State: APjAAAU24HJq5rtZ6UrroNL19BbtarkkxdAQe8T5O61bJ5CDlCN8oRZG
        0jZhaMh0adtmflHMGwBAPPuPiZjPHlVI2Q==
X-Google-Smtp-Source: APXvYqxt36M62NHt23eCC7q1Z38gm+okPhhQsyARcQhNEuKRIBlEHVOEOSGrTCZsPaCg3BXTKxT88A==
X-Received: by 2002:a7b:ce18:: with SMTP id m24mr19024632wmc.126.1565026079568;
        Mon, 05 Aug 2019 10:27:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e5sm79805989wro.41.2019.08.05.10.27.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:27:59 -0700 (PDT)
Message-ID: <5d48671f.1c69fb81.4bb98.806c@mx.google.com>
Date:   Mon, 05 Aug 2019 10:27:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.187-43-g78dd396df223
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 101 boots: 0 failed,
 60 passed with 41 offline (v4.9.187-43-g78dd396df223)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 101 boots: 0 failed, 60 passed with 41 offline =
(v4.9.187-43-g78dd396df223)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.187-43-g78dd396df223/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.187-43-g78dd396df223/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.187-43-g78dd396df223
Git Commit: 78dd396df223345521dd977f3974e6418c078296
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
6-224-g5380ded2525d - first fail: v4.9.187)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
6-224-g5380ded2525d - first fail: v4.9.187)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
6-224-g5380ded2525d - first fail: v4.9.187)

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
