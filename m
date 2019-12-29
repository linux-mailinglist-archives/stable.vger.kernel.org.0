Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4510A12CAFB
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 22:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfL2V1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 16:27:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37124 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfL2V1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 16:27:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so18534519wru.4
        for <stable@vger.kernel.org>; Sun, 29 Dec 2019 13:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=77fKPahAvSz9zp3Zy+8TSA6qqELbXtBR5M4GlUBiGkM=;
        b=Ib49h/yM0IwTTstVzb8uApjReO202QAWPAg0oMmZ9h89YaUAFsm2PrOUCF/7spWZZd
         pKOSgsTNd2i0la6hffVgMEBZ2EqYy9TobCI+hU8e7rBqzmH4u7Mu158OjLGoEMdolPbu
         TZAIf91/sgsWMhJ1gYMXuGYKjPyWIRC6ArmKrPdHh6bIScHf4sK9vU4QtkOz1rKtxwuf
         x/QjPrNnNRhchplSH3WgkJBIeqOvEAI9e2lqLEUoBzoI4NdO9h7Gu92Nxc72Utgk/l67
         x+XdEwnVQIS7lF3gMkSsRQ1DkPArDUk2zzxH7nWoB9qWxm5y+1wuJrgwCLTsRvSAOwfd
         uRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=77fKPahAvSz9zp3Zy+8TSA6qqELbXtBR5M4GlUBiGkM=;
        b=msaZZgX9Z3baOBnN03oE5loUDGIC4czUlO7fvLgP/DENiZqsZ+foHnpXkta0/bTeea
         AWzuP5tHKhTnixBNLEnrIZL1r7O0KpmGXrbgvHFklI1AH2++ZEopnJFtmbhEQz3MH407
         jtdoSFp0qYI8d4g6jtzCSFq258VEN+eQsbU20OOaxiivyQrjciqEztjkAkBsiMXkna72
         KIcc53GjsQedwJOLb8G1bdLCxY0cD8HAWm59XeX5eKyiyWUp/SAX+Z6cxM7F7YXQh0Z8
         mV6WoT8rNyKENts7y8hMSgz5X82sJfGYP5d1e09mdK9NiIFgRAD7owPQI+OEOIZuTfLZ
         /aeA==
X-Gm-Message-State: APjAAAVfA5BmYYTcPhS8MiHvfg39JUVhxEjr4DApA0YoWWOWszmSmC0f
        EphiK66Z9FPFAkWWqH99Uc3nbfscx33n9A==
X-Google-Smtp-Source: APXvYqyFWPMmpWaXOs1qIDM8OLY8Jxu4pRVs6sw+a5jseldgEMqMH6aC1oUgUj1xWbQqfNmBC3HXrQ==
X-Received: by 2002:adf:e40f:: with SMTP id g15mr66251934wrm.223.1577654861760;
        Sun, 29 Dec 2019 13:27:41 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c68sm18471228wme.13.2019.12.29.13.27.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 13:27:41 -0800 (PST)
Message-ID: <5e091a4d.1c69fb81.478ca.07b9@mx.google.com>
Date:   Sun, 29 Dec 2019 13:27:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.160-151-gb53246546618
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 110 boots: 1 failed,
 85 passed with 21 offline, 2 untried/unknown,
 1 conflict (v4.14.160-151-gb53246546618)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 110 boots: 1 failed, 85 passed with 21 offline=
, 2 untried/unknown, 1 conflict (v4.14.160-151-gb53246546618)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.160-151-gb53246546618/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.160-151-gb53246546618/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.160-151-gb53246546618
Git Commit: b5324654661876a7e932c98ff4f03ac51a9b62ef
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 20 SoC families, 15 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            omap3-beagle: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra30-beaver: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
