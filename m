Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392A8D6372
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 15:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfJNNLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 09:11:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56090 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfJNNLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 09:11:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id a6so17203558wma.5
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 06:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LT5OdYywKq3SQDyi45f1ttE/FNLec5sDVx5F8MyWSp4=;
        b=tV4pJIBI5xwwLEjivAMEpyycXsFbO1p1xP9MuPsRJo2AQeemetVHwBWA3WlhGNuHHD
         IflxWvQYftglaO05dorzXkVVOlY23zQzIjtKWyw/ih5UrmIp3ulnLFQsvu6NIE42l72T
         VeEQdneZGLXGl5v8G/Dl4D1dRvHW+GzhcEzqb8ip6f/pvxqJSEVrO6/SWlswvhwdwO2a
         x8PJL88430pnY0FGteVyDKD7LhCH4Xa1uA9Mn0SrNjxqGDeUSP3y5yC8cfVNByXZ68iG
         eUMhRYqgSCSz7WAll9TFOIqUKdcJLB9zljzeqxIKIg3FYEEArN4zuCLkwoy5EHy6itZZ
         29sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LT5OdYywKq3SQDyi45f1ttE/FNLec5sDVx5F8MyWSp4=;
        b=XyYV3FtgEkUbjnXNSIV9UFAYt+SID7qa6lCrU1Zv1PWkNL7dfQrq/0GcBVEK5zZJay
         tSlQ0A7aqpMB7chCJ17suBv94eoc60IJZVaKir5COOVjQ9tNgIo+Ggihliy+RaNDSvlG
         +wummyYG+E/s5xHHDG+smioviLqZecnUuJjh8DTJfD6t9rVmfbTBP6LsjvmL2Q3WBDdz
         6MJTfS24bANygnhWXQtCqE4pyeA55P6W9Lcgj+1icrRF6PibrewRK0LVSh91J0OHZQj9
         F8INlLaE16Ktq8OuRgHFvzGSQccE+Et3dkYupCnMaPw2UaqC3XTQ82RBKEZ0OhzXycum
         ERCw==
X-Gm-Message-State: APjAAAUdoRKKyQPvOSPUd2zw+hgO6s9sFNrqKLUrGL1s33gnIDW8o5qr
        7pjbBvpKkKozZWwAy1NHDjvD71VhQiY=
X-Google-Smtp-Source: APXvYqwHLFXJN/3srGq6aoRHxG7+BiFEA2h6Gin/VI9um0FBHzbYF2AEc0ep198EUHiCtZcqV1EK7w==
X-Received: by 2002:a1c:f210:: with SMTP id s16mr13745597wmc.24.1571058662179;
        Mon, 14 Oct 2019 06:11:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o4sm44829972wre.91.2019.10.14.06.11.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 06:11:01 -0700 (PDT)
Message-ID: <5da473e5.1c69fb81.9f348.b0b8@mx.google.com>
Date:   Mon, 14 Oct 2019 06:11:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.149
Subject: stable-rc/linux-4.14.y boot: 109 boots: 0 failed,
 97 passed with 10 offline, 2 untried/unknown (v4.14.149)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 109 boots: 0 failed, 97 passed with 10 offline=
, 2 untried/unknown (v4.14.149)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.149/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.149/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.149
Git Commit: e132c8d7b58d8dc2c1888f5768454550d1f3ea7b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 22 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.14.148-61-g6f45e0e87=
a75)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra20-iris-512: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
