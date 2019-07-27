Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7112D7769F
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 06:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbfG0E2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 00:28:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33289 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfG0E2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 00:28:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so56419159wru.0
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 21:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2UWj+GMV4WCBuUk+SSM7g99VeptVxGXgBeelUd/E+ko=;
        b=r87BYYT58qp+GjWVA5mxxNz+rLeuyaihDjHMsplWvbSeyip/Rvtpzd2ESGwhpHlFc9
         x7laxEKDbvAfm8scGxYdQcLJrQ/0MfzSC43ZtHqIhox4Hm6dH3tpObQJPCh+F9nb074i
         0Inl2//L9oRDI6+LiMenL2W26sg4MebqRmY7qQRsko+UDIHcWeRVgWd2ocqweiC+ojUJ
         /pywhk4iGMRjUWMTDizzHpz/CrdnUiVo7S32VTQT+XAZgkfKXkEU569BrUtgF1kaX/ig
         KHHhFRC7wJYbnFljCMR3PS+zletGmSugtyelA1ZeodZKOR5pm0saYhDYz5+EfWUl5kQJ
         q3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2UWj+GMV4WCBuUk+SSM7g99VeptVxGXgBeelUd/E+ko=;
        b=j+8qPFVe/Uc3gdTaVVVWOvc1dSy98T/D59SWrpEtHyLT+VppfEOSOTA4rV54beYA3b
         lpZh2UFE4SP4i7iDIq+Hvs0lmALI68KV1YfeUFKgTvuNSnm+mKthY+bs4bEghmZCDsJW
         Cpm9bzsVf0yEsXZqUC6dNm8Ab6h0obDQzRxRZwZ6G7bRfsg9UpBROwB8Hp7AWeCI+3ZO
         /d8kHNjeGtG7QYTvieNuprlPGmoh/7ew/Qfrgael3hOdTTIFHq1zg7Oa8v6vO9k9eXiP
         Cq30njBEyRDpnbuIrIMTlC/A3ry/J8BtHllv8PDNdIumYVuA7HvzqZ6U+vqCeM2JV5l7
         llGA==
X-Gm-Message-State: APjAAAV0csV09iJWrzUKa8yxSK8n9OnbX7azbgPQayA9t8Spc3K5rGKC
        6aHL/40n9todgkxY0zBj+JT5PhjehhA=
X-Google-Smtp-Source: APXvYqxHA9GKnLBqC47e9oguHwiEsMeaG7cQAmcpS1voQAJ0a8q2lBool9ZHT1uzr28eXgQjpXh0og==
X-Received: by 2002:adf:ea82:: with SMTP id s2mr98441098wrm.91.1564201719602;
        Fri, 26 Jul 2019 21:28:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x20sm121326043wrg.10.2019.07.26.21.28.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 21:28:38 -0700 (PDT)
Message-ID: <5d3bd2f6.1c69fb81.73dc2.4158@mx.google.com>
Date:   Fri, 26 Jul 2019 21:28:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.186-86-g6bcb467c3f80
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 86 boots: 1 failed,
 51 passed with 32 offline, 1 untried/unknown,
 1 conflict (v4.4.186-86-g6bcb467c3f80)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 86 boots: 1 failed, 51 passed with 32 offline, =
1 untried/unknown, 1 conflict (v4.4.186-86-g6bcb467c3f80)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-86-g6bcb467c3f80/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-86-g6bcb467c3f80/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-86-g6bcb467c3f80
Git Commit: 6bcb467c3f801820f17b82a449a1bea2e4964ccf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 20 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

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
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
