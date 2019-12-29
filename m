Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C5A12CAF9
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 22:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfL2VWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 16:22:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46316 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfL2VWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 16:22:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so31084114wrl.13
        for <stable@vger.kernel.org>; Sun, 29 Dec 2019 13:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VMgSMC/0RgRN4WvUkrRReY2Mc7RjC9b93H7BeJVMVH0=;
        b=LaeTtfyemfaqCebEXnXqdaBNCx4hC81RdgtEHwBldoQtsJB/MqQBmdD6sy5Kx4K1A1
         4SH45aFv2hmtagGXE6iISwjOJZdemlyJjfwbvbWkSwBO8EL8J5HtyBjbN5fIe8oXbQDu
         /xeGkV3xTH0bbmiAH9xw86uWsKKlUUbyszLlzv5LNmAmyicWmZNH5U3a5pWVslapNDK9
         pCMCReAgtdM96H72guvuERXkXuFru//vjmhb1yp6lpr1kGCzXU6FF+qfMnogKtcKSqlU
         m6472iu2W0pFe8wDepl8oM7Z6/SnTtNGuAIbADHU5jK5zsZ/9qS07l0zNHJmHpviT25W
         dvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VMgSMC/0RgRN4WvUkrRReY2Mc7RjC9b93H7BeJVMVH0=;
        b=NrelQ61lsK9/RuEW6eK8lf/9tdDzdr97WbYkioV/x0tRCw0edGUdUs8TtWKX4liflY
         +98hwGCSrF/+EwrITRfacg3+UarRTYyC7HiQ23q6ob53IWt2eh58S2TdZfXSYQvXubKR
         Km0StVU6t2uTEwOE6W2xUyXhbt+ncakKEb+486VlhViD9mA3IyibaApa4YlSFHU+XI97
         C70vzQ7ZHv5vOjH4qHtBmcWy/sPhFuBS/T9PHtREkukP4FvboQb3uliKQ3M86KRdK8vf
         KPVcJg3+nCA8ETxN7rScgVoyo53DIYemNB3eT6GEpfkk41vpfND5nWGzCiF/Qq34pDnD
         w12A==
X-Gm-Message-State: APjAAAWgrXixaMsaFziRPpn55cmAZPDkzSMn2w4iCbFFSzLH19hdkeCT
        Yr3b8rkdi+YpqhusyrpMm0D8ZWJtIR7Ecw==
X-Google-Smtp-Source: APXvYqwGb2boVizIxPTRaAz8/QvrDv/7AVIpJkQ6y1V8oqfjv0gvRkbPWfcdPfCuiE5QSOxdrXnbrQ==
X-Received: by 2002:adf:fe4d:: with SMTP id m13mr57915914wrs.179.1577654542541;
        Sun, 29 Dec 2019 13:22:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e18sm43058458wrr.95.2019.12.29.13.22.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 13:22:22 -0800 (PST)
Message-ID: <5e09190e.1c69fb81.f720d.7b35@mx.google.com>
Date:   Sun, 29 Dec 2019 13:22:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-86-g789721385a38
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 59 boots: 0 failed,
 49 passed with 10 offline (v4.4.207-86-g789721385a38)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 59 boots: 0 failed, 49 passed with 10 offline (=
v4.4.207-86-g789721385a38)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-86-g789721385a38/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-86-g789721385a38/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-86-g789721385a38
Git Commit: 789721385a384fd2c31d441d92e035a620cb1640
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 13 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.4.207)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.207)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.207)

Offline Platforms:

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
