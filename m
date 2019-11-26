Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FEA10994D
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 07:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbfKZGi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 01:38:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39864 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfKZGi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 01:38:59 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so17881338wrt.6
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 22:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SJbArH445e+Mra/TyVohd+nynu/QmBl0e8ZuzCNgl74=;
        b=JE9/xDIKDJet8PTIHDCk4qjm3aCV1yOCh/lMfLoM1GVwWZr5vd9HrjqQlSYVwsyFsR
         8pT7h08o1A3ur8UcPCkk5Al8sujeIxS+ZdsjI5hUDJcUHo7w2xNZuCR1pDBohrJRhlUg
         KKRlEKKUwvxWrbUhGzBtjSYBMSIfk9UhaxPksAVFiOgTYOVrs0jJE6Qj70c+2e5Ou1rs
         qqy9wEXGkEL6v8n2PJBNwIHXMAHS2Ga2D3cOT95Kkq2KsexhQ+yfNH5RrGOaZKWq+MD6
         lkq99nTjKl7MbfY5WbhdMrxQLxBFYm4nR86HQh8KTs53ixpdCCgNVV4bGMlGdwtWssoG
         bPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SJbArH445e+Mra/TyVohd+nynu/QmBl0e8ZuzCNgl74=;
        b=aM0hvKmiiwq2EiIL5SQYyCCnkLrI9Qp24/PPDat6A7ALVitUaympyc03Y7CHRosDTH
         9SiXdAt/xRVR5qqPH20ZCyEZB1jhwoIoMKGeB5m2aIvUXsysxlrFw2XjCf0SWXvVZjNa
         56h4L4HywnxrWLOji/xdBuCaGjV0qmx1K10k/CzuJVE0P1ot/BKQ+CYAFMmg8FU00BM0
         ZgotDQizYT7MVEDfBTvNRf7EeTcaHCnVGSX8+CZnTYI0Eh+bJKKcm2vNE8UkiSraaXi8
         +I/ApLymKX/2UWgbgDzTXzzXbhyD/nAFH/0rK24EXVhA6FpNRWS1OeaQOG7d+YL0MND5
         SJqw==
X-Gm-Message-State: APjAAAWMRqYTWILoTak4wi2i1O3Fm+7K+ychsg3bkElkZciVpNf+5RQ5
        KU4VVhtqrPSFqQpeB/U+Dm+nVntwj+J9ew==
X-Google-Smtp-Source: APXvYqxLCUSRCluMoXzZab9rP8vlz9RmL+K2ECMSKB+SZQE+HrtewnLFnP3sVvQNB6aBDzjmJC9WxQ==
X-Received: by 2002:adf:db01:: with SMTP id s1mr33141744wri.372.1574750336331;
        Mon, 25 Nov 2019 22:38:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s8sm13601620wrt.57.2019.11.25.22.38.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 22:38:55 -0800 (PST)
Message-ID: <5ddcc87f.1c69fb81.46d46.52ab@mx.google.com>
Date:   Mon, 25 Nov 2019 22:38:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.203
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 78 boots: 27 failed,
 44 passed with 5 offline, 2 conflicts (v4.9.203)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 78 boots: 27 failed, 44 passed with 5 offline, =
2 conflicts (v4.9.203)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.203/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.203/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.203
Git Commit: a777e9dd40fe85dfd0cc5cb2b6c22a9cd1d08c0d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 18 SoC families, 14 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.9.202-223-gc2ff777d9=
ae8)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 2 failed labs
            imx6q-sabrelite: 1 failed lab
            meson8b-odroidc1: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            qemu_arm-virt-gicv2: 1 failed lab
            qemu_arm-virt-gicv3: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-h3-orangepi-pc: 1 failed lab
            tegra124-jetson-tk1: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 2 failed labs
            omap3-beagle-xm: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-lcdk: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-h3-orangepi-pc: 1 failed lab

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre-seattle: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre-seattle: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
