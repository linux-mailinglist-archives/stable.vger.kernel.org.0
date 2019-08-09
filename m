Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2502B87FBA
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 18:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437068AbfHIQWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 12:22:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46469 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436626AbfHIQWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 12:22:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so98778863wru.13
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 09:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AU9vZvu9KrO493IK2Hg6fvf/kCH0br7d9CdKBjTXtoM=;
        b=HQ3RD1OkTOAWVqGRaw+D0mimzyuBXmQm1oZZY9SK29tsZSE2NIQ2nHWjN5kuAs/W7m
         esH+8c9NrYU6dHzOMSWfmrMDq2Cib2RH7Vzx9ivp74hHxFD1cU4W+Q/7qLSnbu4e4FBP
         8F+aR09xPlPbVgpSVgwSKIsbQ6n0XMHC36f3whW5nB5m6/nxcRY0+F4wcyVHTIgQu5C9
         vAW3HE8ndAozizVr/r1NUNoGY0Gzd3iRzAUtftCpBbrw9QvPuY3H0N1Nyuoq2umHC4ju
         noUTsrpZ7hEDyZdsOEjKYYii8sKLA7x7/9AA1ezZP43wQ8HeSkdTTfFh1qyL6U5TZI5O
         0uNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AU9vZvu9KrO493IK2Hg6fvf/kCH0br7d9CdKBjTXtoM=;
        b=tfu/4P7EKH0uCajbZTlqEktYThq0PJFVzZn2qJQIRPI0AnxmusMtopDCSZyPgeke0l
         UbLDjTjq+n/oqnLk9oLZeMp7jxLtezwPq7dMk2VANn4Y3Up2EOwm9EdrqMO/K60t5b1O
         lpCvGeJAnCzadP1jab2i+kQoSPaPCkNCnV1xG5Bbm6Re2452Q48fUw21e3G824F+t/QS
         A0pUvQ4dtQ7crFfXSGgGhAIwkdtsGxasY5lTuaFXulLhg25uOBP4nXwBO1oh6tfC/d3U
         oX6Rdqwro/87ttXg/N640E0tqecD3zbFdVtKlS8GBPWpwKOiyqRXJ6eVb1JQ2stx+JD7
         WZ8A==
X-Gm-Message-State: APjAAAWIBfuYIWHEx9aJNETRTXRrDYc8Ov8ktN+YIHA+HOcLsrduKjay
        aXpKgGLqx7qMCP/kdghc6xw94MCcsRH/8g==
X-Google-Smtp-Source: APXvYqy1mBfoMZ+wxJnewTvnZLIqoQYQ679nfHSYuHGsK2cPiEXSTMk24N6YElGmvPyJKktqFYPoTA==
X-Received: by 2002:a5d:460a:: with SMTP id t10mr23975999wrq.83.1565367741743;
        Fri, 09 Aug 2019 09:22:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a84sm8579675wmf.29.2019.08.09.09.22.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 09:22:20 -0700 (PDT)
Message-ID: <5d4d9dbc.1c69fb81.f4831.c758@mx.google.com>
Date:   Fri, 09 Aug 2019 09:22:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.136-54-g33934fd98b51
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 119 boots: 2 failed,
 106 passed with 11 offline (v4.14.136-54-g33934fd98b51)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 119 boots: 2 failed, 106 passed with 11 offlin=
e (v4.14.136-54-g33934fd98b51)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.136-54-g33934fd98b51/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.136-54-g33934fd98b51/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.136-54-g33934fd98b51
Git Commit: 33934fd98b5139de6051ccdb4018a9bbeb475f58
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 25 SoC families, 16 builds out of 200

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
36-54-g20d3ec30650b - first fail: v4.14.136-94-g4ec3ef9505a3)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
36-54-g20d3ec30650b - first fail: v4.14.136-94-g4ec3ef9505a3)

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
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
