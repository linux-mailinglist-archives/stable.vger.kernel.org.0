Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A476E7D17E
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 00:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfGaWqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 18:46:53 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:38963 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfGaWqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 18:46:53 -0400
Received: by mail-wr1-f51.google.com with SMTP id x4so18259480wrt.6
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 15:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=90y9fQiZrgQfZKgNids37kRMslVdPsWVmxja+D6r1qU=;
        b=sPsNtxq6PnVom5ECXeSYr1ke8mN8pjQZpB+qXVRCUNXRJ6AnltXJ3V81fSDfY243jY
         nm8MOqZ5banBMBEUZpVJULiR0xZl/54TAn5MjID9sazzbOPRL1iiaWGABT/Jbo906CHn
         YGD93iAsrMu4YS55PEHmCG+aNo1sb7k1qQzDyVcatiATxb3kQ4xCh6Nxz0YgEM/hEkcW
         +5VygulF3cNJVjLjg3QlfYz0XquNzzhKS4wJmQcQ0EhLHSc+CdkrCe/lV6adeVjY/BAg
         9FvK22lODFju/ZILbRuHIEX/6dn+9cLBh3eoQW2tV5u7enljcbJBHoRs6VF37Uh7kZkk
         Q/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=90y9fQiZrgQfZKgNids37kRMslVdPsWVmxja+D6r1qU=;
        b=gF9BVzYKBK7yuK5a5nxa5wsOvkJF+E9fNZfZGJ9q89QDy1HTdfNZTXkWVb/p6+dSLP
         GQvfw+7oofkdYaW8tz5RZj2a5GESChqr9iHleSRV+K7a7TpidnRid8uHBuclhaelLOtf
         z078brNeTpLlQWqcULRopZcpev7ljEcm9l/l0wrDnZfgSwCEnrL0eIfwdylX54SltyFH
         Iggkg6JDC0Ukvr4gIZ29AnZ7dMHp9It3VcLynu1d4Gty6R0dMjfF//7k0ScwGmRGcilt
         XRTISQVvU1LteRAMiISDdzhx5q008I4NBdkGLyILTdo8B967w3tL+8EBqpCd7Yxv9/rG
         Zouw==
X-Gm-Message-State: APjAAAV8cyYgqfhxv2XbQNv7ptpaugz5Sd4voQA7p+C9iBc3EtbQVkpx
        Vo3I3Op53moEmiL4zV2MB/zjrwB+SgI=
X-Google-Smtp-Source: APXvYqwbxuSIEEA/aYJn2cDzGk1IMecCvfiROAwCo5KMKaKw8BnqlnDPNXnjXd6TZ503Dvbm+h7Z+w==
X-Received: by 2002:a5d:470e:: with SMTP id y14mr111528852wrq.308.1564613210950;
        Wed, 31 Jul 2019 15:46:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n14sm134019012wra.75.2019.07.31.15.46.50
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 15:46:50 -0700 (PDT)
Message-ID: <5d421a5a.1c69fb81.71575.fdb2@mx.google.com>
Date:   Wed, 31 Jul 2019 15:46:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.4-227-gd8fbf65cb203
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 129 boots: 0 failed,
 83 passed with 45 offline, 1 untried/unknown (v5.2.4-227-gd8fbf65cb203)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 129 boots: 0 failed, 83 passed with 45 offline,=
 1 untried/unknown (v5.2.4-227-gd8fbf65cb203)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.4-227-gd8fbf65cb203/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.4-227-gd8fbf65cb203/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.4-227-gd8fbf65cb203
Git Commit: d8fbf65cb2034e342262118312a197257568cb6e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 28 SoC families, 17 builds out of 209

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
