Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FF8102AC9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 18:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfKSR3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 12:29:14 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:38319 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbfKSR3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 12:29:13 -0500
Received: by mail-wm1-f46.google.com with SMTP id z19so4701429wmk.3
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 09:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ztkRPVeXCjyK+z9G3RgQFhJ0koO04fUHKbk2SqUEHBA=;
        b=sYC+nUYFiFO0P/F08GUOyS+E4mZ9z1LdU1b7aFKzblehGzvXbWk2FFcSW/9ht75rRo
         9fUqvmy0hCoLDfXiuT4THveYh4TMn0xwHVDraIEBWTE3592LP63e9Lv/KUtqRnJYeXJj
         IrMG7hM8JvovuhEiKGIO4QgFUh++nOn02GphW2fWq3QuiF+GdqgNwJ2hgUQHPcdkAF84
         jYBYDQAbcDeXKbTv7m3AbK7JrYQY/dI9oDrfMNBURJyiE52ljSCP1kqrHFuTKYq02JPV
         UTzmneZBc6kq3jL32x5NIcwRd7foqXmAH0x+OWfJIe4Av4WkNW7d/MGFVkYC50/vKxHT
         tcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ztkRPVeXCjyK+z9G3RgQFhJ0koO04fUHKbk2SqUEHBA=;
        b=gHe9kqvRQsDjrRoaMNnVffjRt8WD56TNbKEpXuyj2QkJ0C1VN+c+DowIaR2bL/BT3X
         d8sjvnsDTUDebvUTvNSBVDlkBFGivMCVUlPixfxy+FiJAyCBf7B9fHk/ZHhUq8lD604j
         iS5V4LRtLehJDyHgXRzAkj3+jtNZXaX+8/murcYGhUa12/Nsbw6BHuUSUjgKkCgPaM83
         UtjaVUcmLacoGJ82vdgkC6pWBHcnqZyXn6Zy+RyDkgRPqwDzKucjJkS8s3n2CoukBGOV
         48JdKi67Tiq42rMoB+ZfOpCRaRwYd65//0BLfyE9RtSJzXqjJ0AA12NgO8dvyiSriVSk
         pBSA==
X-Gm-Message-State: APjAAAUHOwwI7DLllAzixM4MS5GNtVoQqEEfoqvZXRT00iyhqVmok9ji
        w7u+s3j3GTA24ub7t9c1UdSVK0tOZlQYUA==
X-Google-Smtp-Source: APXvYqw0hpjF9wFWMU3lUYaycciTDP7DCS2OeX2aUZVdb1qJJiBmoElfP/unKXRlR1740Bx1Wdp9Gw==
X-Received: by 2002:a7b:c445:: with SMTP id l5mr6972705wmi.140.1574184551182;
        Tue, 19 Nov 2019 09:29:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l4sm3783871wml.33.2019.11.19.09.29.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 09:29:09 -0800 (PST)
Message-ID: <5dd42665.1c69fb81.47f86.22b1@mx.google.com>
Date:   Tue, 19 Nov 2019 09:29:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.84-422-gaf1bb7db3102
Subject: stable-rc/linux-4.19.y boot: 132 boots: 4 failed,
 115 passed with 12 offline, 1 untried/unknown (v4.19.84-422-gaf1bb7db3102)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 132 boots: 4 failed, 115 passed with 12 offlin=
e, 1 untried/unknown (v4.19.84-422-gaf1bb7db3102)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.84-422-gaf1bb7db3102/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.84-422-gaf1bb7db3102/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.84-422-gaf1bb7db3102
Git Commit: af1bb7db3102c89730b610b827df0e429c061337
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.8=
4 - first fail: v4.19.84-423-g1fd0ac6484bb)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.19.84 - fir=
st fail: v4.19.84-423-g1b1960cc7ceb)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

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
