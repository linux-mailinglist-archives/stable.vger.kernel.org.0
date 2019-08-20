Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B0395C14
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 12:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfHTKQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 06:16:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45637 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbfHTKQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 06:16:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id q12so11759184wrj.12
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 03:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xcQBLqdUIAY9F4E1i+9xerhbV9sYiJuRreHHpE8xuhg=;
        b=vWRFYbKkRLmIlSHWGqTLozcIFu8RV1YA9Zq0iaV0Y0gOaoC4iGrWeuaylW6NqwnQpM
         VEjLUbR35UAzdQpWEq8m+h/TU8YUi76OB3VogDicgClMucANzbM6M39RjhLU5DyOGmKn
         DYZ5OE7zqkelLMrQ9JM0yHV/L5vpVfbnvEJcJ0a3y05vQ42ZKLz5vJ1YwBsiJf+6X8/q
         Qw8InnG53zkbGdC1oeAOX7STki43wg/ijlegeYFl/iNNh+EKRKeF/fPF8pzF1dIlWpZW
         wzAXE0LOcnbN7+fppf+cvbfsOK0uCZhRnfC+OkvXM70WpKnbePKtP1g1tBgqLBGD9BAl
         TStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xcQBLqdUIAY9F4E1i+9xerhbV9sYiJuRreHHpE8xuhg=;
        b=W7K3ZH90L7yA73mZqI5Eh4MMdfliRilPc4L9LhLyoef8bVMgfFi1szm2fuQLpacZ8m
         3vWa7I3iye4D1ip959WuI3PbZ97ZbCJFYM9kFbiVY7bCgpWNPQKxZjTRvpbRv4wVzmYc
         5aQCPx+ZZekHtvx8XEa8kFwjqfycho5+RXrNiaCMbwCGrlLmKAzA6dWBl/kj7AyLoOl+
         my1JUGMAkJKfLw2cxwnR8tIMH55l0nQ1wDmji3/ANNgZt5KuzWJCYAiASMqAWlXrPiJd
         fSXec3lwDhBXONGtfhfaHGc8twv43z260G0pTiEaRxihXzgHb4S2iCBbhjOjPcP/BF+l
         7YOg==
X-Gm-Message-State: APjAAAWbGQyUliuYQbOYhr7WjV3wVr+54aZNF/x2KFPwg4ITrZ+MGng2
        RMmC2eO/zgMG9nx/U7N1uJLtLgOkwZ24FA==
X-Google-Smtp-Source: APXvYqyNzOXiSf0Ujt8RxEZ85qe+fv+RwTh904jYgilt7XEST+2kdDhqLBruUpYldlwBeuGLvITzmA==
X-Received: by 2002:a5d:4211:: with SMTP id n17mr30306403wrq.137.1566296195646;
        Tue, 20 Aug 2019 03:16:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e9sm22690054wrm.43.2019.08.20.03.16.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 03:16:35 -0700 (PDT)
Message-ID: <5d5bc883.1c69fb81.fdef4.f141@mx.google.com>
Date:   Tue, 20 Aug 2019 03:16:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-67-g8d81180872f4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 97 boots: 2 failed,
 82 passed with 12 offline, 1 conflict (v4.4.189-67-g8d81180872f4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 97 boots: 2 failed, 82 passed with 12 offline, =
1 conflict (v4.4.189-67-g8d81180872f4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-67-g8d81180872f4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-67-g8d81180872f4/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-67-g8d81180872f4
Git Commit: 8d81180872f41da07988054d0f5393d33696270a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 19 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-35-ge6790d05646d - first fail: v4.4.189-45-g244e47df71ff)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-35-ge6790d05646d - first fail: v4.4.189-45-g244e47df71ff)

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
