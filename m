Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF0F1BCDA6
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 22:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgD1UpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 16:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgD1UpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 16:45:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6002CC03C1AC
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 13:45:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c21so8156250plz.4
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 13:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oDKGnr+fLpBZ+moigZPhdWJV97+RzLQhBl1V5z3LgUU=;
        b=Fe3c1Hpz1TalHeSz4p19urKru1zUBvYVUOlZrL7s4R7cVxl3URtRtafvFIU+Qd0Set
         m880W+VRcf/8gNgu/dEG/oui1JnnQnf8PAm+WWXm0usGrmrPy7oJM0qXJfYaRpKmZxBc
         +/gYYveiXKRhN6ny+n/yqtOqPrlrnJ3ED06jCScVJgAM9FI2pKZIOXioZCIxs7Wn9j4b
         QgEtt/zPhaX/bL1cGE1oraMFkjX7Szt11lN/rvWyLmXF5M49WUgv0ZLNOJTcAfUMo2Tw
         JUs54BVT1boYV0WEUMy0ngBabZBkcbbgmSsNiDgvSEJd7b3/7padqRI4bexie/zWY33f
         HdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oDKGnr+fLpBZ+moigZPhdWJV97+RzLQhBl1V5z3LgUU=;
        b=AuKmNqlvc3BwNLtbXTlzAPkJv/y8oLjkw54cScZlbeOLEeG0rwi2nQJe8o60C7Wji/
         9Mxjej1b/cdG527pMSc4djPV5TD1I1esVcVQ/MJpfOFSAE12/afwxjLz2jBL+uocEjXt
         D16/shzXyL9RUnCJAla4AQ2YLjHHNARRysVej/p2dsonV4iheTHZqDFkgqBfSGdUf07h
         XnSv4LaukmU9rfYPsByJh/3Yhr0DU07qOGcMDKNROL3HICHQOnhbRlM6T+4kphEicfh0
         P1qqj/OnEkaZohzevBEigbGG0yReIHYIFSi+MXhe0IE3v+b0MlRbFADdr9kNNQniEzD2
         WksA==
X-Gm-Message-State: AGi0PuatC/NGKaFlIwtyiyM8MfRCOoIxcWG7RQD4uTjzSTp2hVBnKADd
        VJUqcncUVco1f/okLMXBnaJdNbKDbw4=
X-Google-Smtp-Source: APiQypJryD2C23nfXxpGAqiwLhQpoLow2O4DZtBbBwXf60UuHYkVR3FsUUdQkJrtW0pMi1lnlmTSog==
X-Received: by 2002:a17:902:444:: with SMTP id 62mr30371399ple.301.1588106699521;
        Tue, 28 Apr 2020 13:44:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm16345370pfk.86.2020.04.28.13.44.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 13:44:58 -0700 (PDT)
Message-ID: <5ea895ca.1c69fb81.85caa.f17d@mx.google.com>
Date:   Tue, 28 Apr 2020 13:44:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.177-85-gd7d12b87f9ba
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 127 boots: 3 failed,
 113 passed with 7 offline, 3 untried/unknown,
 1 conflict (v4.14.177-85-gd7d12b87f9ba)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 127 boots: 3 failed, 113 passed with 7 offline=
, 3 untried/unknown, 1 conflict (v4.14.177-85-gd7d12b87f9ba)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.177-85-gd7d12b87f9ba/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.177-85-gd7d12b87f9ba/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.177-85-gd7d12b87f9ba
Git Commit: d7d12b87f9bad7e428c6421e99d26b5ce2bd4b21
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 21 SoC families, 15 builds out of 192

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.14.=
176-199-ga7097ef0ff82 - first fail: v4.14.177)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.14.=
176-199-ga7097ef0ff82 - first fail: v4.14.177)

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.14.177-83-gbbdd9c481=
dc2)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 80 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 68 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.177-83-gbbdd9c48=
1dc2)

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v4.14.177-83-gbbdd9c481=
dc2)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
