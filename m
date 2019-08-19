Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FEA920B1
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 11:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfHSJuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 05:50:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34172 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfHSJuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 05:50:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id s18so8025231wrn.1
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 02:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gB+vX5IiKJzJqupSQJvoMR6O2f5JFcOD4UMP9IxKwno=;
        b=rJAf5OhLYjS+3kphUkrlur0L5MJAavUwcodmONBxzDP9J52q/SEprEeQg3PwovjWsM
         7CbaAzhitJCsbGaf5K3ctEAmaN6Lh7RjdwTiMGh4nLFCIXogS8OaPZT1KE5ntCzO/sRS
         s4zwRf3ZXHK3Ip0Yx5bUCazc65AlfJKCItXrt0kkEui08LMsREwo38YTJ+/ltI/JkUSq
         VPyJbVrk2zHmr5LBe7jJ7w7T1zuY7PSZApCunrB7n1FwNsHnzuJPWz415RBgttui45cj
         bN6EO4cU3rKUJYrDCZnhSUlCEjlMs9aDUwAHNhVYCTR75UdtavN7hYudFIcX6Weg3yZX
         kx2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gB+vX5IiKJzJqupSQJvoMR6O2f5JFcOD4UMP9IxKwno=;
        b=J1f7Cdt+iGSH1N9ju517vFXl6LVtFNmM6Lp3zCdENC9jDQnd1bDk3kanJIN2p0fVLW
         MGbmDcfKS+aayUq7m3yuSVbXBmkEdFkqsj5lHmC62HieubP7NexhSSW6rMzV2x9LMrek
         ecL4qNY+tsAuY5MJYXPiUWzudv661xmse9Q0c+vltQcFZDCpzP9nW15hRYvdztNNzitt
         KYjHOe9KwxYnSHmzDhk29wolFGBZjo7n21A+2x0ivYMbZBfJbyARs9KgsTvyHu2OZjE2
         15CFx2hJFJTZzX8hSphptbxOPVAAnxBkgZK3f/cDcOcT8phQiOIUbqCvmil8reKSLQnS
         cKtg==
X-Gm-Message-State: APjAAAXUzy/gJeFCG6SgQGPNQCq0+TTO/aJlTmeJFcZcK+5F1M5uIEFs
        SUx8IMB5CHgfa17wmtl3WbGEIjlR5Dc=
X-Google-Smtp-Source: APXvYqw7opU1qOjmDYOoWc3W8SXNRKSNpclhJ9M4/nBVsT1NDmx7fri7Y0c8HA65+P2IYq5wR8syVA==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr3241892wre.44.1566208212399;
        Mon, 19 Aug 2019 02:50:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p9sm12384163wru.61.2019.08.19.02.50.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 02:50:11 -0700 (PDT)
Message-ID: <5d5a70d3.1c69fb81.e13e5.a65c@mx.google.com>
Date:   Mon, 19 Aug 2019 02:50:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138-125-gdf2e0978aad0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 122 boots: 2 failed,
 105 passed with 15 offline (v4.14.138-125-gdf2e0978aad0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 2 failed, 105 passed with 15 offlin=
e (v4.14.138-125-gdf2e0978aad0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138-125-gdf2e0978aad0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138-125-gdf2e0978aad0/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138-125-gdf2e0978aad0
Git Commit: df2e0978aad0ad8e67906f94cb8625e53c42cc08
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-73-g1a4682459a61 - first fail: v4.14.138-91-g248e04a69071)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-73-g1a4682459a61 - first fail: v4.14.138-91-g248e04a69071)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

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
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
