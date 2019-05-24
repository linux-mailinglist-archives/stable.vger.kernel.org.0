Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C977B28F67
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 05:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387622AbfEXDF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 23:05:59 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:37154 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387434AbfEXDF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 23:05:59 -0400
Received: by mail-wr1-f44.google.com with SMTP id e15so8343270wrs.4
        for <stable@vger.kernel.org>; Thu, 23 May 2019 20:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FrWVceI3LtR5FXxB8VcRvYsptOYTyMCHoGS31s3o9rQ=;
        b=JdKGBp+zq2PttV7t1y7nFnDxrS9VJ7Y0okkSEnwusqSsLw34+acafSSKvMrIVFcYMP
         ysshPDobaqu0bJJFS7V/P26EMxjT8h29QryDvDtFZz+R5OYxI+XZgCkS0leeMREm0XOi
         9YCHBgQFqGO5TsV8wxn21CIRPuiBPyqu9mt9W0zmYNl/rGoVjrnwzzGv7XAodYPgNjmP
         bNbslwzfCK0azxslG8refNN4eSsMrvmDoH00XQlme45Ps5AafQRUCeXFOlDUAhtwgGqN
         +xf5mW6VXqCMFCrMUp6QsJVO+ZVo1umJ0kNf3KHhs3cXYo1782tlg5vCLtMQABigw+LR
         FVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FrWVceI3LtR5FXxB8VcRvYsptOYTyMCHoGS31s3o9rQ=;
        b=QvT7xMUbOMSZTXgvgKFxDtvl2WsQviH7Sl8J4QRCqUmFb8yJEN8NS/eM/N+qcppd3b
         DBwnp4vpJ/VK3+4QmOTzy9FpoJZgoRrlOOOLxlPhujkwuDXkE4Rl8k7J+O94TNUmYEds
         Kk+I2PEa5nblmvNRCzW28ttOzIuUlBv+U97S6ttx+Lv3V97Tr9tgwCF8BEFDGYbwkL7c
         U39bQPzWafpW3CqgIis4O85knbRaDcGc/+xAJ5i3/NpkTWRjxSKZhZBFrH2fVM37pW3f
         d3MHkOoytGsHJXZzoL2646zP59mP9XxlQ98yvnwUXLT3Yu9YweE9nnkdeqCXEEtNB6P3
         jCtA==
X-Gm-Message-State: APjAAAUK1aMkfaoZwMcPaTzP1CliFw+csyKpoukO9ySL495RQ6QbOYz2
        rd00mBrQYrDslAEO1+MuCzVtEapbJyShXA==
X-Google-Smtp-Source: APXvYqyux+OcbUd1boa7BywY/UToaXBT7ctPV5Ad1EAMdtFLDDm10KeOeao9Fwx3G1sQnryCg1fEKQ==
X-Received: by 2002:a5d:6408:: with SMTP id z8mr3025666wru.238.1558667157914;
        Thu, 23 May 2019 20:05:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l6sm1024688wmi.24.2019.05.23.20.05.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 20:05:57 -0700 (PDT)
Message-ID: <5ce75f95.1c69fb81.f6056.56c0@mx.google.com>
Date:   Thu, 23 May 2019 20:05:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.121-78-g64cb9b0bb7de
Subject: stable-rc/linux-4.14.y boot: 125 boots: 2 failed,
 108 passed with 15 offline (v4.14.121-78-g64cb9b0bb7de)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 125 boots: 2 failed, 108 passed with 15 offlin=
e (v4.14.121-78-g64cb9b0bb7de)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.121-78-g64cb9b0bb7de/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.121-78-g64cb9b0bb7de/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.121-78-g64cb9b0bb7de
Git Commit: 64cb9b0bb7de34fd893ee96ecf613039130de9a6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.14.121)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

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
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

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

---
For more info write to <info@kernelci.org>
