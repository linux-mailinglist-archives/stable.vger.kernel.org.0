Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5934BACF64
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfIHPD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 11:03:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54917 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfIHPD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 11:03:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id k2so11033779wmj.4
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 08:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S0kAixsv5Ss9XN3UyIhqxUQ8a9FRU1URaKsRKak3iyc=;
        b=jEAbd1DzSecX2qoe1O1utvAlMdfXidIvxHaJ/4Cf4/lzdFZ7loQhzfPnh0Wpqlm7f4
         m/2KT2XfCS6+Jkz+KmBiqbhxDskt6RpkQq8wrzVQg2Qt6ivNS6RfhrewqXgNogl2NS+f
         5VPLfBdJ3P3vTuJl9nR4Azq6968ttH4hG0pyGaxaHo4W1CakDGJZAMpVtO8gMUP4vak2
         j6zcCCycDlkYt84ybZNJltJ2x5oaAShTrVsQzYYhHt+rELqjZL5GiHJW4J3CvUTi2yYu
         D0mUmnQDwLHLbQmCn7bh+0lpeGWYEYHOu1L04eonh6h6sC/SJkOpEV+LjAZyzKc+CmFQ
         twxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S0kAixsv5Ss9XN3UyIhqxUQ8a9FRU1URaKsRKak3iyc=;
        b=hU3Eg+Npbgi4gSz+faSROC+8oogtomK9m9E9eXrKMjKLhLXg9ihM1JQhJL37GxDzql
         4Fths5MIqHmJeXBoe6Lmdnc0eswdasUjKn7tkSA+/Rg9WRgkmGNXKD9z2sPC2j3yHqpQ
         2XLKefz4ldRq4sqZn2vYfqnUTbhoi6UDMfPiH/0zTD6dIF0VHrJQCX96zxYtciT5bY7N
         vRXU1t3TvXprC2Bn+2QCI08pvHvbqqU2DVXRrxCIr+NY7Rd95IhFnaNsIRIlWM2nTaYw
         BPVL9MNu8MNrAWMSTO1BBl5GT650J7eQggwEu/ZRh/nYjVWLrqoX3Rs2UyCACRXKoamR
         /35g==
X-Gm-Message-State: APjAAAU0OAl6ru6w6rBUdham9tG3JyeQC//Vuc+A8cmW9F7nvqQreZzU
        HTFka1bgNX1tbB+NK/8jOBaIyu4xd1A=
X-Google-Smtp-Source: APXvYqy28yQZN0AR0ig/VdN2qvZj6jMglUFlN9pd2N42RDX5+yf5zlvZQFWMlrA/d1kXbxlueLcy3g==
X-Received: by 2002:a1c:1f44:: with SMTP id f65mr14849160wmf.11.1567955004975;
        Sun, 08 Sep 2019 08:03:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g73sm19525171wme.10.2019.09.08.08.03.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 08:03:24 -0700 (PDT)
Message-ID: <5d75183c.1c69fb81.e9c25.b478@mx.google.com>
Date:   Sun, 08 Sep 2019 08:03:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.191-24-g6128caa0e308
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 106 boots: 3 failed,
 93 passed with 8 offline, 2 conflicts (v4.4.191-24-g6128caa0e308)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 106 boots: 3 failed, 93 passed with 8 offline, =
2 conflicts (v4.4.191-24-g6128caa0e308)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.191-24-g6128caa0e308/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.191-24-g6128caa0e308/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.191-24-g6128caa0e308
Git Commit: 6128caa0e3089f1c7c5ca695cb9e4737f77ad413
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 13 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-linaro-lkft: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

arm:
    multi_v7_defconfig:
        imx6q-sabrelite:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
