Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8589F12CAF0
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 21:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfL2U5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 15:57:22 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53780 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfL2U5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 15:57:22 -0500
Received: by mail-wm1-f67.google.com with SMTP id m24so12557729wmc.3
        for <stable@vger.kernel.org>; Sun, 29 Dec 2019 12:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bK46uJKoPkAACXyPn1GTUEFQJbFAD9Zk8gLuDeaqRnc=;
        b=NPola/h8yLFu3epSPo0FEfRblAFKuVeoESboN+yglyNX4mQvLPljzm4Pz34yesY2kn
         msZPrNnwH7xbFmWoxtq7lNAKClXvPklHklC5Vjx7YDErlQe35gRXtKOuZIanB1pKImxy
         9ITPDyf/NzSRiLBgwES3jFlVS/jyD+AjjOo/ZSs7tIQGkFaFzUQ9FMxe/XiGZ/1o34Lh
         CQHVv6QkKXDwFzWFPX6LoRpR2fIVxrmZwWnm7AhbUcgG/HQLwYSVTqUoDY51B8YlKvFk
         r4g5vFvy5GeALqhbHZTrWs7QVGJmxaHyhepcTq8NyiOVtpAb7IjnCRqoLeMeCsg3vSXR
         bbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bK46uJKoPkAACXyPn1GTUEFQJbFAD9Zk8gLuDeaqRnc=;
        b=QYwiaX/BGwFXZK+IecVuwjRs12MnaogC+walsybSWHmc/ooBHKngNtJFEqCbaGy2Zy
         X47AiPYxObgg1dSqTekKmKIn7eOQ1iVZ0jTzoiy920zBxKNXMf2ekxE6KC3ty8ytuYaZ
         Hii7ZCBk/yYvZ/xuM+UUxTjheq0w7JhsPVAzRgcKJfvfIZVbDIVAUHVFCGwW4JQ8eW3B
         8fPVDwM1eIs7X4a0QKFZI4QMYnH0aw7tKGBbeEY9vGvEQ09cY0AWGCYX4sb4rvcIReVh
         Rt4LC5V+jgCqQViuPpR8onXSz/O2YrxfMOiJk8jtGIqBoowgLbZcICAu2+YYw3z8YFX4
         qTDg==
X-Gm-Message-State: APjAAAW6dpP/RkIsyIaeJDCUHB8jW06xbn7V+puQnhdN35zD+h0Z3T/U
        komvqrRacyKCQmkNDAGmB/6BTU7E05+qXA==
X-Google-Smtp-Source: APXvYqxppEhNaf6WeHSZFyvsXl7j5M4NHRWZ75RPx6RHVh6kcLO0lJ35mHQV/W3qYqtI5oGWJPp7dw==
X-Received: by 2002:a7b:c30b:: with SMTP id k11mr31069766wmj.36.1577653040250;
        Sun, 29 Dec 2019 12:57:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z124sm19384484wmc.20.2019.12.29.12.57.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 12:57:19 -0800 (PST)
Message-ID: <5e09132f.1c69fb81.f500.48f0@mx.google.com>
Date:   Sun, 29 Dec 2019 12:57:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-106-g8425bd2da54f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 95 boots: 0 failed,
 82 passed with 12 offline, 1 untried/unknown (v4.9.207-106-g8425bd2da54f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 95 boots: 0 failed, 82 passed with 12 offline, =
1 untried/unknown (v4.9.207-106-g8425bd2da54f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-106-g8425bd2da54f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-106-g8425bd2da54f/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-106-g8425bd2da54f
Git Commit: 8425bd2da54f1899663af457069b7a627b84b260
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 18 SoC families, 16 builds out of 196

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.9.207)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.207)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.207)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.9.207)

arm64:

    defconfig:
        gcc-8:
          juno-r2:
              lab-baylibre-seattle: new failure (last pass: v4.9.207)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
