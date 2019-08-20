Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B58C95BFB
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 12:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfHTKGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 06:06:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35294 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfHTKGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 06:06:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so2123168wmg.0
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 03:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KJsLUdhfSUgZw25Ht/vnTFBjknJgv/xndjuYHBummMo=;
        b=pSUdI7Gkq82Ua6D4PR+mBXBiTWCnLBvDD8S81bzN7oRTaaS943qvU/i73kyXWB7ngm
         G+uv2c4/XewrpQaHR9kzP79xAGdMNKttOTixyLua9SxSPANFoSMDovvdtYlKO+n1sshv
         D0k0zZcb9AfXKr/GjICe1x6INqjNdXiFLGbR3+mV+zMnwX/5Cn0j07YEoUh60urZHSrl
         q6lgwDoZtNASVc3RWjdR4IxhnpY1fZbEwKtYeicUynE/HHQd/i4B0XOsdJfRK8OYovKe
         Pf2MLUL1DRkIuFuKvpjeHtuJn88YWcjBtKQcimGaImfYIS9oe1/QCMa7XB6zBfplDlbE
         AEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KJsLUdhfSUgZw25Ht/vnTFBjknJgv/xndjuYHBummMo=;
        b=ub3t1gKweJIAXux0cuTGnvKXBMtmcJ/o39scBp8x1KA2gMEft1f0O0LDeDLxCgQdsr
         YDTxfQPK0mZDwBbitluq9/CzHdu92mh4h4xE8vlacU9qi4oW5DmwidHxK4dqxJYB+0Bd
         HVQ3GWGbWPk2/lPSU/z8L0ZSjeuEPbibH0gQSw7DtvVXE9C1d4S4ijZXZlA5dILS0/CO
         U1xNF1bUe826dQL611sZdAS2PuQ3MXqG8nbyRRp8Qr0YWLjM8cEXEyWSfJRJgoU4pJSl
         JNZPRlmBqq32jxnBSrX/rSUT6LmdAPyNZEojMkzWcpCJYR1oHE8SFfZJ/MxtJWhOQMD0
         Pa/w==
X-Gm-Message-State: APjAAAWg2rCW3NLbIc0T/G3pzFFgrFioBnv6a48r424ebAFpmYUQng9e
        2Sg0UPnIR+NJysmle84DYIBMuMWnXCpG6A==
X-Google-Smtp-Source: APXvYqx9ranEmxTaHODBTMspcujnnEiQ/Gk4BR2FmxVzePDqWi1S7irQJXcrIXFGwDuY3t9za6egHQ==
X-Received: by 2002:a05:600c:22c6:: with SMTP id 6mr25066302wmg.5.1566295597476;
        Tue, 20 Aug 2019 03:06:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o17sm16025275wrx.60.2019.08.20.03.06.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 03:06:36 -0700 (PDT)
Message-ID: <5d5bc62c.1c69fb81.f9f86.bc8a@mx.google.com>
Date:   Tue, 20 Aug 2019 03:06:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-94-gd852cd0dd1ab
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 104 boots: 0 failed,
 88 passed with 16 offline (v4.9.189-94-gd852cd0dd1ab)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 0 failed, 88 passed with 16 offline =
(v4.9.189-94-gd852cd0dd1ab)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-94-gd852cd0dd1ab/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-94-gd852cd0dd1ab/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-94-gd852cd0dd1ab
Git Commit: d852cd0dd1ab87fdd250b94a766a99b991adeb9f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 21 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
