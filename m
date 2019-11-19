Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83580102AF0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 18:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKSRpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 12:45:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35136 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSRpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 12:45:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id s5so24942172wrw.2
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 09:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G6x6+H2oEw1eRH8HVLW1lO0sr6ZCJLW7wV/bc8fc47Y=;
        b=HaRT1BTRB+zTWR+wsTQsKOXRctZCReoLhj97VZzdLAKZWia1jt8WEXeRE7awg+s7fg
         srMk1DNKFRJ/tELmq6RRSboSHmhW0Mq0HO+Ao2ddsVSuf4CRapQysiBYfXdg0fOU3XHA
         Igs4aFCODRCx10RXg/KAS5uITZiIfaLB8eELZQaoLH5naJNCUi0jnVWSLD/nvCcMEFGb
         hTsA++dQWNaHQphW13RoAfoVK5wEo1PyZgxoSUpULFWCnIK38en4qrmi0nUbA/eT2A0L
         WrQ07dYD6eGdP5t+6wQMAPis5n0AaQSBWlgkv2XW6GCUC502bjDrnkyF1wAGwhQBA6JL
         Lfsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G6x6+H2oEw1eRH8HVLW1lO0sr6ZCJLW7wV/bc8fc47Y=;
        b=cQgZcIyLGtW8/pN0FKDBx81dcxvHT3iZ4hTHD6LxJ7071ZWjZEaFC7TZLEdxp4nce3
         pgU+ogbM4cbIWCj1MD5ZklUfsuVz34SZhxmZGC2fGstb8ivlbJSVaxnSbkb41J/JfS/c
         34k3zfWkEuS59ScpdXcMlZZLBzV1o679yxud05vnEb7pRFrdWU1/J5+FatZbyT0F5hTK
         FHhuJGvkwE4tVHox6S/IGkHQE63iHvzJ8YaCMcsKHIDSO5zEqz9UNQVw5JnNvkqCizi8
         X6rzx+ZJ3DdeyfTZMF/lIvx14z99PDj3tOYt9h26sh9i6VK7k1hg0wqmaQb5UeUvhlbW
         nZ8A==
X-Gm-Message-State: APjAAAUcWXewEUDyrV+znM7WelISlq3buwl2v8YXDMUmTXhBJOvMe4Ot
        g2WFmZunDOy5Pegvv3+jX9XYjrrqHg0Sxw==
X-Google-Smtp-Source: APXvYqyBybWoSrk8twMRtRV/fNYMHqMCPWVmJpuATSZ698bEww4KN+va4NEy6YMXARpFYe/CrZziPg==
X-Received: by 2002:a5d:4247:: with SMTP id s7mr32280755wrr.381.1574185542657;
        Tue, 19 Nov 2019 09:45:42 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a26sm3822526wmm.14.2019.11.19.09.45.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 09:45:42 -0800 (PST)
Message-ID: <5dd42a46.1c69fb81.75bfb.2bb7@mx.google.com>
Date:   Tue, 19 Nov 2019 09:45:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.154-239-g086940936515
Subject: stable-rc/linux-4.14.y boot: 122 boots: 4 failed,
 106 passed with 12 offline (v4.14.154-239-g086940936515)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 4 failed, 106 passed with 12 offlin=
e (v4.14.154-239-g086940936515)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.154-239-g086940936515/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.154-239-g086940936515/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.154-239-g086940936515
Git Commit: 086940936515491724d7d237c38c1a85e6309ed5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 22 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
54 - first fail: v4.14.154-240-gab050cd3bb84)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.14.154 - fi=
rst fail: v4.14.154-240-g8dd59dbecd7d)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.14.154 - fir=
st fail: v4.14.154-240-gab050cd3bb84)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
