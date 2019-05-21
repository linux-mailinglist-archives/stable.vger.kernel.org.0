Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D421025A18
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 23:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfEUVmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 17:42:18 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:38829 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbfEUVmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 17:42:18 -0400
Received: by mail-wm1-f51.google.com with SMTP id t5so111952wmh.3
        for <stable@vger.kernel.org>; Tue, 21 May 2019 14:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=COnYJpO6Ny5VHP5JXBDtkG26VUbHYYzwcH5eIlwzLPk=;
        b=N3tZ9U8zif9K3uMNJeYn6P1Jfbw465N9KCke053XMhujfWxZJCkIJ7MBmdFyB+o0fR
         r/YEMaT9nmN654leTfSuTlRPK31r9g8TXs4XcnkDv355X2RlNLBkA/Kg+BZHFknN/sh+
         SOeYxCGC+5UJK0ER97zZmm1IFPbf0b4BVFFDnS6RdayU3xDrFoEHfmXfBj/4qaW6b1VX
         bq+75fxMTZ5T81kQ1mxYYj8X57TYaHTM/K8oU3ZDSn6XgRVEP7FdNOGDrtv2O0BvLJ5k
         gHfWIBmjYQDOviujxFYdXoL8N46rWelomMbRnj1GHgftBd8VLTSkx3NVmSqqVqDCRgvh
         DJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=COnYJpO6Ny5VHP5JXBDtkG26VUbHYYzwcH5eIlwzLPk=;
        b=Bopxl4fLwHjYUf+0ImBSBA8e/xZOQZgetox4/0QSREk8nIgSH8s9MFpWk4iT+ol5rh
         hgU3KbIshszl5SwKJrfc7ntjhpDO73MH7YzQGAfVEPaO7ZBs0fed4Wy2ZkJ8EZK3YKc4
         4Gh5Woon7wQqYDD/Gl3YoCQf5LVXQ7txbp08szMjG0btSXc6vLMXK/mUhboAKA9A6vsX
         X2S2ZJE8n4s/xdkgIfbPxILIuLlwvlNbQEwlh/YtV8u/xOOQPRXD8gNRmjdZKOfqidE4
         Nl/5W3s38ybDItIMeZPU9TbyYSX+pFUbtgRertsviPbUIJ72x23/4ygx+28JQStvdiMs
         /WZQ==
X-Gm-Message-State: APjAAAXB4n2p+zHx5G3FgavCusLLA6MxRdO1sm/BgRtSwVBkf15TsvEN
        ar4QBEa9XahJVtNS/MIbQBnGxHTtccr/fQ==
X-Google-Smtp-Source: APXvYqzFw1wqmpDUbPZoCRcK0gSlAch7qszm1Wx7olsDCMmJGHTYiK2K8zZnMEVuYZupYA4QHvriYA==
X-Received: by 2002:a1c:4486:: with SMTP id r128mr5066296wma.90.1558474935997;
        Tue, 21 May 2019 14:42:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i185sm7978295wmg.32.2019.05.21.14.42.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 14:42:15 -0700 (PDT)
Message-ID: <5ce470b7.1c69fb81.2efd2.5b53@mx.google.com>
Date:   Tue, 21 May 2019 14:42:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.44-103-g84889965d346
Subject: stable-rc/linux-4.19.y boot: 118 boots: 2 failed,
 101 passed with 13 offline, 1 untried/unknown,
 1 conflict (v4.19.44-103-g84889965d346)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 118 boots: 2 failed, 101 passed with 13 offlin=
e, 1 untried/unknown, 1 conflict (v4.19.44-103-g84889965d346)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.44-103-g84889965d346/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.44-103-g84889965d346/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.44-103-g84889965d346
Git Commit: 84889965d346f29e8d1614f9c3cb35c389a40eec
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 24 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 4 days (last pass: v4.19.43-114-g=
b5001f5eab58 - first fail: v4.19.44)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: new failure (last pass: v4.19.44-106-g6b27ffd29c43)
          synquacer-dtb:
              lab-mhart: new failure (last pass: v4.19.44-106-g6b27ffd29c43)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            apq8016-sbc: 1 failed lab
            synquacer-dtb: 1 failed lab

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
