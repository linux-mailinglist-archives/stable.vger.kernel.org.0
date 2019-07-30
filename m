Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE7679F80
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 05:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfG3D0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 23:26:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46681 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfG3D0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 23:26:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so64008556wru.13
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 20:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ITAb9Kh+5Z6F0+NQKKVK/h+HGnJ9X+X1Youb5YG6uFA=;
        b=Ej1GadiGU3rUqWjRmYLT/GVYc+qF1cIlP1Ad6cIfgUPOeZsrngg6/6AiqJ3XeijvLr
         s8+uc+O8kJdpnmpFhc74y7O7NO8xgmmQAuwsaK31UUnqSeckI5WMCFVP4bQXyY7OljCh
         K5EhaTlFGBzaYnbEVBWIb3a1BQRJirP935g6Zs/SaSHEA8Lm4z9/RaEBJle8U59LkOi0
         RT9KMqiJs84+Yk5OVsZZWSjUocJGZj5IE2AN4RaZRQamR4keiGDB3y9vDnppvhpjnecu
         QHBuiYrv5jXgmL62kmCfn/fUQkCOZK28bFGTet9VTFbmP08YfNluqnnGg+cu+4GfLzCX
         GbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ITAb9Kh+5Z6F0+NQKKVK/h+HGnJ9X+X1Youb5YG6uFA=;
        b=OpeCKPwIKK4H6e+JjESJyH1Cd5ymQ1w7FaoGlKHEjVYrymlKhHPGznczeBhhJIJCrQ
         WEyVHehkSJjqoJJ4G7Qa0c+TZBvw+37XlfAtdF3zDilfQe3YJCq/mAqkjqToSroGNLD4
         YUTnp9uJJn/YU0NtSjuFoLJXYcbFG2/NWHomVfhG7ne1OvoAxENE0s7PQvRrgpSjHN7a
         9pS5lFzFyNBu0lHwW/N4yGwbi18hCvJc0qVa1WXiSsyVFvhSFV/VNJrpdwf5frGghZ+i
         zUICpRhc12oejAj6+hKhs49snypIo/b9oWHjL6UHKO+F/P5K7pKjOkJMs2sQoG/OJx2o
         cx5A==
X-Gm-Message-State: APjAAAXWwABAcSTtjQvd3StohZUwv6DGel8rJ5697suCjVmUhze2JAQM
        IzRCYTpgdRU6+TmLgVqklw+Ds4Ac+t0=
X-Google-Smtp-Source: APXvYqwj7iWAFmbpUAcGIxgTGRtOLGLlHTAGced0FYS2TCPmbjek6IwXHdCJl6/RpxGFbxgwsw+lxQ==
X-Received: by 2002:a5d:4212:: with SMTP id n18mr1871635wrq.261.1564457166039;
        Mon, 29 Jul 2019 20:26:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o20sm161397130wrh.8.2019.07.29.20.26.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 20:26:05 -0700 (PDT)
Message-ID: <5d3fb8cd.1c69fb81.af1d8.3627@mx.google.com>
Date:   Mon, 29 Jul 2019 20:26:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.4-216-g0c4d120e771a
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 122 boots: 0 failed,
 75 passed with 45 offline, 2 untried/unknown (v5.2.4-216-g0c4d120e771a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 122 boots: 0 failed, 75 passed with 45 offline,=
 2 untried/unknown (v5.2.4-216-g0c4d120e771a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.4-216-g0c4d120e771a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.4-216-g0c4d120e771a/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.4-216-g0c4d120e771a
Git Commit: 0c4d120e771a048ef7ae9a4130169b1cf03c36da
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 27 SoC families, 17 builds out of 209

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
