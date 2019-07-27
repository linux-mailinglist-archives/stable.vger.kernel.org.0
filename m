Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5447765C
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 05:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfG0D7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 23:59:33 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41918 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfG0D7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 23:59:33 -0400
Received: by mail-wr1-f52.google.com with SMTP id c2so53075882wrm.8
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 20:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WQE9aBDcrsxVIpgZLBb9nt4/rMxab+AMiWUCXr8Xjn4=;
        b=bg5W5DSE6cozdhDxUpQ2rSpCnKw7IbEeLV89joaoLoGJKZzpejYPpQaPq66nmG67zx
         4hkhAufVLQh40jDLrstAEyyzI+DbgjYMsL8lgBzO+IVbujEnQhSxhKWO/mVNQ0JO7sX7
         0oZZDl5fDNkrqG8c8Jst14P071a4CHxYnSOGL6gRACFQrG8IjOfdXUy/crO8HsqPqyHm
         QV/RX/qh0MprhNCk0Jf6o2SaHZRAJ0tq+Ztt0WniW4mPjDwIfIt0CTOEOVZ6Wn2acLru
         8Up/J6oS5qUL2+oKTUdoxw59EKOOUGwgfzkeDmdE76KYgwvPeRmp96Ssc9NDdSMmdvob
         ssaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WQE9aBDcrsxVIpgZLBb9nt4/rMxab+AMiWUCXr8Xjn4=;
        b=kMBliT4AhJ7CuiVcFkl/Wjs6ayQB70swnKaRkE/UW84D6M87495kyfcFboBurTWkZz
         25EdCsnUIf3iK8HQaxh25AMExP0adqFovabkKbpnrg0J/inWL+MAfzN4ualjmWgiS67l
         97RSVZasdewpyndyRkHTs0cZA3FWYO2OIEi1HSx64nu+Xaute6pejV5HSnGdh12YcfXQ
         vycwf/0CIwugpcEg1G3J6oGZuuIV+pvN+gvUDBW59h4Zk9Z/jB8uqXDFDLlhVkHcL11f
         +GbAGA5k1eDi6ej7J6q3ViHH1o50PHUi9Uqq973fh1aVPX94+WSUO5pxfc6WxvMzW573
         chEw==
X-Gm-Message-State: APjAAAX00r7ceuyZuko/0o/kXd9+343p999EGHsd/qKhRVqIG1uomJB8
        AKJQ8RcPkXxqZlPxBhxIVCMNpKCfEaU=
X-Google-Smtp-Source: APXvYqyVAi3vvuSYcNfJvFuEY1pKZodI7ZjPANiU7ttALpKlAKQTHgYQcvgxUkRrIYvNN34GbD6ukA==
X-Received: by 2002:a5d:4206:: with SMTP id n6mr38077709wrq.110.1564199970780;
        Fri, 26 Jul 2019 20:59:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f12sm60186350wrg.5.2019.07.26.20.59.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 20:59:29 -0700 (PDT)
Message-ID: <5d3bcc21.1c69fb81.b1ff5.038f@mx.google.com>
Date:   Fri, 26 Jul 2019 20:59:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.134-215-g6017dae7508b
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 113 boots: 1 failed,
 71 passed with 41 offline (v4.14.134-215-g6017dae7508b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 113 boots: 1 failed, 71 passed with 41 offline=
 (v4.14.134-215-g6017dae7508b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-215-g6017dae7508b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-215-g6017dae7508b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-215-g6017dae7508b
Git Commit: 6017dae7508baf2fb356258c1c34f948c5d70924
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 26 SoC families, 16 builds out of 201

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
