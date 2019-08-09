Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3187024
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 05:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbfHIDTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 23:19:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39630 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729065AbfHIDTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 23:19:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id u25so4242757wmc.4
        for <stable@vger.kernel.org>; Thu, 08 Aug 2019 20:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w7WHbE3TXaO3fRQPoYUq/s+5oXO/LZJmHFH+S8XglJY=;
        b=n7XqcAx/2WBZN4dRhKnzUNR1Oj/BywdfoWGAd2ko34r4IvLKtZTR8fQ3YIq0eHEdK2
         2DdT+uECnGYR0B26/xrzLfy37FGOGApxvq0aDwOHDq3gFXEPCdYSb6s58oSYL152ZnSQ
         4frQViT+jXg3tbWYmp6+l4kq2IFXRjtZooYe2wEUNkMHxZAjktkm7+yliV9Q79lx6Q33
         MMSuJoAKVTPe2lDlbydOZhMeQ0fHKI3/0DzY/iQIUsLvRpQxrq4rbE7Sf21HKZiNVo1F
         t8w76tWAfNeHN3/XhOCyoDkUabdKlg4yFGKgddoMnm2mU4GnhyKzRCecBJmDLBld7sYE
         2PNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w7WHbE3TXaO3fRQPoYUq/s+5oXO/LZJmHFH+S8XglJY=;
        b=tvzEwdVbpcrJWvW5eVzA/B2T5mJDhKLB7XyzRI8RrXKTXosJdOtXzQpAsJ/5qWztLz
         WsNzg7FFvNtLIbivN117mWQZS0Lqs2J9+F6ELAILAiCqAtS13GM88U6fhLBgPIr/Y419
         H9xMnV8K2rR8r6DWSadZDhTaLcVLpx77l9hFAYeRMzcdhJ1ZbXK/zBBx1o138VQU2Ksf
         4VIkn71jUERVl0IUIeocujiWHivz6XpwgFOFvovULoBFi8YXOyubloXlgCC6XSzLph0T
         X41K+ZFW7t/RLcnuH9bqo2JS5K6Fb8O/LlUheYvkKxxXK/9zpyQSGRSpwUGG6T531emh
         SxcA==
X-Gm-Message-State: APjAAAUw1Ujg/8KAWOe4ej0Ckyyga8L9QQ4ErYn7YfsqrGfhot5IoWvO
        ggGFAxoE5eTUrP+LwFf4sPOQraNuxg9cjA==
X-Google-Smtp-Source: APXvYqyymz/THsReHJK/ld6AOxkchMTDSNR1kpfpDXHgu+JK4uOYZZIGMcBBq9Z2FB+uhxBpWhYmKQ==
X-Received: by 2002:a7b:c212:: with SMTP id x18mr7607463wmi.77.1565320747323;
        Thu, 08 Aug 2019 20:19:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v124sm6936357wmf.23.2019.08.08.20.19.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 20:19:06 -0700 (PDT)
Message-ID: <5d4ce62a.1c69fb81.d90d3.22c8@mx.google.com>
Date:   Thu, 08 Aug 2019 20:19:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.187-71-g399cf2b4ebf0
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 103 boots: 0 failed,
 91 passed with 12 offline (v4.9.187-71-g399cf2b4ebf0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 103 boots: 0 failed, 91 passed with 12 offline =
(v4.9.187-71-g399cf2b4ebf0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.187-71-g399cf2b4ebf0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.187-71-g399cf2b4ebf0/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.187-71-g399cf2b4ebf0
Git Commit: 399cf2b4ebf0ba9383aa5fd99e9110c38553bd11
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.9.187-43-g22=
8fba508ff1)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.9.187-43-g22=
8fba508ff1)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.9.187-43-g22=
8fba508ff1)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: new failure (last pass: v4.9.187-43-g22=
8fba508ff1)
          juno-r2:
              lab-baylibre-seattle: new failure (last pass: v4.9.187-43-g22=
8fba508ff1)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: new failure (last pass: v4.9.187-43-g22=
8fba508ff1)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
