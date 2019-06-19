Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637F44C3F4
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 01:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfFSXHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 19:07:53 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:54962 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfFSXHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 19:07:53 -0400
Received: by mail-wm1-f48.google.com with SMTP id g135so1093654wme.4
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 16:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jlKmSmj7uzUXj4X78Rf4YjFcOflcjRjYyamShYRyagM=;
        b=lh9ucU1kXv0rz19dmXzwTYCI+RPGnt66wc5nr7npg1Pt+05m3iMYvLLPFE4yQagAoT
         gZd1zjlOZf8RHKab/qtqwRn48j3h0Tt+61pgU8rF7jNNYWWHEQPNHZjtDgFkoUgh/hoL
         pqvhkA32Sv85dQsPgAMN38VTWPvD3YsxsctNa9uBVrNqYk+Hw8OC+bmLdnT7v7EudIuV
         Eq8kjpg0olDWeQ22mDzKs5f4PgyIxnhUMCzBtAu+sTsW31cvLB4I97E4tdliQdzkldQl
         NlG++c7zo1C7fnT6vqxHqtJN2VppcrDy04l5CS8s12pCTgzQAeYfqbYDW32LgeO4qDnv
         0gOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jlKmSmj7uzUXj4X78Rf4YjFcOflcjRjYyamShYRyagM=;
        b=pTh+K3IMLtErmmsRPtXuiqzIoQq1kztupmfGTPrGVWwiZNScauEAZFsN7HmgauWIYz
         HWzz8DyaXRQmGLIBVJorUOhTAuG7uDxOPg4LqURLKPO89ydjABNwvVZv/XlWavSQwzsN
         m70RB7PPKlxOxhK8ZG9TaOnBzv8M/Zz/ZbinStNn3T2AJFT0WuBrp6kIFIhYLdYxhXE4
         +Q5AU3/9NxDPEGu2ChO0w3tE3NzCxNQxnygo5PFbHiHSUzBKjy06h6N7TqpKlTRiD9rA
         gwGEUi9FAxnmbHnaar3D20QGdKpFfBs0mlO0Kstd3xogeKzCCZFZZ0GppvHuGb9xd/Wo
         E8wQ==
X-Gm-Message-State: APjAAAXWSjRde/logjeSqzG72A+8rSY57f8LYt9GOhsYvzPH8SzwLcUQ
        QrFDFS36AVgBYG/xwuED6yvBbF2B1aexrg==
X-Google-Smtp-Source: APXvYqxq7Esy33bN/rUdduxth8tAuMS0k5D+L7secwLXOZ4M2Adz9hKDkzKo7Jb1i4qP91nYQpYs7w==
X-Received: by 2002:a7b:ce8a:: with SMTP id q10mr9408169wmj.109.1560985671147;
        Wed, 19 Jun 2019 16:07:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y6sm18635425wrp.12.2019.06.19.16.07.50
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 16:07:50 -0700 (PDT)
Message-ID: <5d0ac046.1c69fb81.86a34.59e5@mx.google.com>
Date:   Wed, 19 Jun 2019 16:07:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.128
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 118 boots: 0 failed,
 104 passed with 14 offline (v4.14.128)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 118 boots: 0 failed, 104 passed with 14 offlin=
e (v4.14.128)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.128/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.128/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.128
Git Commit: bb263a2a2d4380a56edab6dce5a2c064769676fb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 23 SoC families, 14 builds out of 201

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-ifc6410: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra30-beaver: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
