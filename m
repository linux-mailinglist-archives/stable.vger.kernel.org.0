Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E39312DD15
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 02:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAABR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 20:17:28 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39921 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 20:17:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so36215963wrt.6
        for <stable@vger.kernel.org>; Tue, 31 Dec 2019 17:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sZAyjajKdWonOB+AHHnhfTbr1cue4HY3te7X+0EcfPM=;
        b=MGzUkvYx2eAE3aXaYdYBL5ah950fMpAzsoRJq3CqYtma9x+HPwjSMzhfd7TiNLAGey
         CVvkQjodB/NnXNMwhMBhCYEzSvL+dUqxq2zWBs8JzV/LirkN6KCYngEI4vvsfJ4lWqfE
         bUQISqurBcveqxWaB43y6zm/4Db19ZYV//vgVj8GZ9Gl0g8alrdx3c5gzaMRRWlRz2HH
         YSJstjDiRY/R47EpPLUTFeozCPHkgaQOtVMe2O2glJtt25AYuhZ/HzEqDdzX+uJYfx2i
         iB7n6887BshRXW3jXxP+m8y1+LmG8P0bQCuHSd8qfP2KcDc9ZqMqWc3khZ6wp7Y8vwiG
         7kQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sZAyjajKdWonOB+AHHnhfTbr1cue4HY3te7X+0EcfPM=;
        b=PwhqnUVZrdy1LQ1ZeK3QY9hEs2a7XaM/bySgsTOSMYB///BKioq9i1oih5lhxxFxOE
         N9nYP/NmoggBeNbVE8a+Yo3bhelZAGR10yX+8EDCura6/8SOq8UgraPJkQGZv13EXrPP
         3VMwfz4XDHmryJTLnIhuCaX27CCibkRYxQmY5dXt3+4yaGJQE+/Mr0PGhOj5/EqKdwjv
         P7O3y5QixIBzYL/zb68MjQyEfrJ+KOedG8QpypBkS135JsvIaHURIfEPmhA4lMgibuw2
         8OHwC1+/2VfX6bu4OGG2ZYYxLm+QTHRRK3T5k3i80uhOfInQh5AbT+aVA79FXtWDnYRz
         2rng==
X-Gm-Message-State: APjAAAWqb4zSX0Qns5SZ3OIXEkEBce99+544rvfi2grzur7xxee2J6PT
        CXg6HK51XZa/aUfoCCLdIFoox0GiPX05pA==
X-Google-Smtp-Source: APXvYqw+fQ3z9jXuojnjgdQ5Z07eK//TWV8XpNwpAMtudRhsZ5xb7lsr2tm6xUNVuUe13Z50vUuugQ==
X-Received: by 2002:adf:f58a:: with SMTP id f10mr77839095wro.105.1577841446429;
        Tue, 31 Dec 2019 17:17:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c17sm51949070wrr.87.2019.12.31.17.17.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2019 17:17:25 -0800 (PST)
Message-ID: <5e0bf325.1c69fb81.ba69a.03b5@mx.google.com>
Date:   Tue, 31 Dec 2019 17:17:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 121 boots: 0 failed,
 107 passed with 12 offline, 2 untried/unknown (v4.19.92)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 121 boots: 0 failed, 107 passed with 12 offlin=
e, 2 untried/unknown (v4.19.92)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92
Git Commit: c7ecf3e3a71c216327980f26b1e895ce9b07ad31
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 22 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.19.=
91 - first fail: v4.19.91-220-g798b10a6009d)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.19.=
91 - first fail: v4.19.91-220-g798b10a6009d)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.19.=
91 - first fail: v4.19.91-220-g798b10a6009d)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.19.91-219-gbd997e912=
93d)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.91-219-gbd997e91=
293d)

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

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
