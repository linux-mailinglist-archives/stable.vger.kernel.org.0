Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61177892FE
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 19:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfHKRyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 13:54:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44552 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfHKRyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 13:54:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so102687513wrf.11
        for <stable@vger.kernel.org>; Sun, 11 Aug 2019 10:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vls+8xpwJ6rkHBnXBPTwZ9dQ/58Z5GAQqofa9PXPPIQ=;
        b=tppguAmIIMkZRWz9Xn4C9iX7uhQw1/oVvOjpN+e2fpfnYLM9NNXcdxJmz6SmzH/+Cl
         reJlOILr5Cw+Ln6ua1gxA+vUO+q8r6lgCCO3f38o5sWu1AVWM28MAkihak/nnX8wzed7
         gObxFCPdKxEQ7ujmLlWeYp39nZB9cYT5/KeBEeW22T0zA45pxcUByhwwx0iq1EI37TlB
         QWubQ+ZJgKGFmbVD2c7JDSeoMTenIvZZE70pClQzLL+RLWKp92+3R0Aba+A20wghDBxL
         XYnP5VEJSoQPFc4Ecw1d19Tkgsh8kiovxdKpyS/zk5pkYZ0wn/M4kYYGqUcuHmxUjHKq
         ciRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vls+8xpwJ6rkHBnXBPTwZ9dQ/58Z5GAQqofa9PXPPIQ=;
        b=k9cVahVdERxUsqUZxlDVkcgb2PTQGOY6Wb5hZeJRysSCty8dLIcYR/42EdO2FbLaof
         Y+dnTUKR6hGObxnedh7sHmOl4z5tuadrc608A4cX1wZTqO7qywkC9vQzjkgPnqZb3drD
         htZq42sOMWgn2DCZy/pGPqHt44SVCP3p1D5tQ5XOQN6s7KohkeGaSwh/0BL+/L2gtbQH
         5P8wKkx2c3rlwo4T11+yltQwzun9WiCEPqv3JcTygrZUD7QXFynn68TX0n1Kyyx6HLBe
         8V8vvB7nJA+v5z0ZF7KK5aqeubwywyOtWt6G3Z4nzuQY6yUTL9iI5eP0GPbg8f5xxCPC
         eC5Q==
X-Gm-Message-State: APjAAAULL189om0ndWs8W3JvtrOcqn0OkZNH5NI9ZowXrBEJCy3u+Sgm
        2E5WpVX9aKaYgsZFJOe/6Z4G/bjQ5b0=
X-Google-Smtp-Source: APXvYqyAOVRR1LMsjL/QpqyNLE9GvG/07iea9Wlqx2NmsYDhcBBOPWlOpYgj4gJUqPuIzeZL6f3o5Q==
X-Received: by 2002:adf:dc52:: with SMTP id m18mr37944385wrj.117.1565546061267;
        Sun, 11 Aug 2019 10:54:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r4sm68505105wrq.82.2019.08.11.10.54.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 10:54:20 -0700 (PDT)
Message-ID: <5d50564c.1c69fb81.a181d.dea4@mx.google.com>
Date:   Sun, 11 Aug 2019 10:54:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 94 boots: 3 failed,
 81 passed with 9 offline, 1 conflict (v4.4.189)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 3 failed, 81 passed with 9 offline, 1=
 conflict (v4.4.189)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189
Git Commit: 3904234bd04fa7c40467e5d8b3301893fae16e87
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.4.1=
87-23-g462a4b2bd3bf - first fail: v4.4.187-40-geae076a61a51)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.4.1=
87-23-g462a4b2bd3bf - first fail: v4.4.187-40-geae076a61a51)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.4.1=
87-23-g462a4b2bd3bf - first fail: v4.4.187-40-geae076a61a51)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
