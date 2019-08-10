Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1695288832
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 06:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbfHJEe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 00:34:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35415 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfHJEe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 00:34:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so7268073wmg.0
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 21:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FFCR43iDYabD6B7uG0tELgjsZS2VQw0gVo5UAWbFMv8=;
        b=o4InC6DWH/j8gF+/ecmoI7P24VFRSWuO+TzAOJbaX/HwpZLbhb7yMXCJ6xLu00t28H
         uOMOJZaPCQ1/sCMRmBqQ3YEyx3hXNLel8j2ifcQ61may+yyYHDze9aSJnA05abybZCxT
         1vbxsLbGk7bB0RjJm6ff2SCCXgOC0nhelm/9voCbLoTcXb9UyrPCzLSh34NywI2BAcPv
         Fu4Es4AHRVdi8xJruHStyKcXXGFZNnS0UMdOtV/vG2CI4S3r4nXmUxBIa7+qJVlw6Y96
         6ukBI2uBkbIY0RUrdXsrnFMLlWfKxhd3vfBt1SmBRv7Er45rXvwwOKVIfYdG4qIOuHLm
         mf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FFCR43iDYabD6B7uG0tELgjsZS2VQw0gVo5UAWbFMv8=;
        b=VeiygnCniPUMfNjm1lDAcu38LvoAB0eiL9t2syk/adFrnYquJ8UtnNFUUTz5GXqRVg
         O0S/mlkeapXMwCxc/UHr7B05SreeyPZ0++TVN8KtXeGQDJtz+9Tt1jnWuoDMjrezRdTS
         7ZPmeLEl+kZeN2zjtk/UsuawtINAmGN6om2JOmEd09sbU2HPrQ/CfoQv564aYqY/WShl
         wdmlvCHdrx5vwtKeEzaAc8PsUKfiaPj4sb5aLTI1FN5aj0FA61ejeXsHlYjuutfu3+EF
         Nx+sIrbTjc8/VdKwtFb6WyO2su75yPdZ8A16epXTW/ot+lmCebo5SC95UxBWBxK4cZKg
         JiVw==
X-Gm-Message-State: APjAAAXVXFbRZ68ehHXlXqt+dh0qhFrHrAwSnkdp8LRCYSMGyVtWOaXR
        ecanx1FF9gOGDKH5qzyL7vm8bqgpTrs1Jg==
X-Google-Smtp-Source: APXvYqwPWs4q81A+x3T73nrT7IKOR8riDUn1GJHaFtTnj4oluqJ0ccnefGGU1dkjmFKqmV48DzWf3g==
X-Received: by 2002:a1c:9dc5:: with SMTP id g188mr14660003wme.93.1565411664491;
        Fri, 09 Aug 2019 21:34:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q124sm11407931wma.33.2019.08.09.21.34.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 21:34:23 -0700 (PDT)
Message-ID: <5d4e494f.1c69fb81.c5034.a84d@mx.google.com>
Date:   Fri, 09 Aug 2019 21:34:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 122 boots: 2 failed,
 108 passed with 11 offline, 1 untried/unknown (v4.14.138)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 2 failed, 108 passed with 11 offlin=
e, 1 untried/unknown (v4.14.138)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138
Git Commit: 3ffe1e79c174b2093f7ee3df589a7705572c9620
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 26 SoC families, 16 builds out of 201

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
