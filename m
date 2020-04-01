Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E0F19B640
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 21:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgDATKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 15:10:07 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:38848 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732148AbgDATKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 15:10:06 -0400
Received: by mail-pf1-f180.google.com with SMTP id c21so471916pfo.5
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 12:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OgQFVRmB4gWEr2YFbAgBZE1dNvfS63vm0RVyBZSEhtk=;
        b=elE2ARhCWHd4iLImT7Bjh5odhJh+8dffJCuS/oCLGZOdb7+l/ysMHB5bsWbc6uZO/J
         +PLjzUy5mvTq3YfqB4dOZtoTovStVbkQHe/O1ObDgRyZHjA6YdRp7jDDqZVeHzioIrFX
         /YvEeyxawrItlT0//IdK5RL3snwTeD5D8X/bFGGnDyAudkNLveFfFoheOITm+PFV5eOa
         ac1UsLMExUtW4OVQ/VXIa7vC4BDumLeXB9jdxqDGsZ2Gd53KKZwxEcq1/5p0BBstEOBJ
         g2FtTcPKMjqVqVCDrgpmiq8avK6Nb1nS4ixGpmTj3ZoHYjA3lE139AR0L8DlTR26x4pk
         ZeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OgQFVRmB4gWEr2YFbAgBZE1dNvfS63vm0RVyBZSEhtk=;
        b=dDFQ9JwaFRD8+P13tt8/2vr+T8z0RTk1Vtc6ZjCIMYxu3ozbku4iLPcG9g6NQeIJdR
         vXDg+3H4uZzcRWdsnBxKS614qntCAURZLlRk8mp1K5718QUKP0b4LM2Vt8wsav+osypp
         yxU5UeNs78RJNH4GLFmC4IeDTAg19AgB2xGl5lTGwzWWlIq1yxTToCgePFb2dA77IafM
         6b1tvlDkuIslROnsWoZ22d+JhbZpLPxbfWLrJFbSQV2jvtgPT+AEkd0EouWJA6QEAhRy
         RVIxKNs1DUHyn7980Ewt35bIBJryDWFyshbE2fN2kjhMOoCPQ692yicrZOkF/sJNb8Tc
         /EyA==
X-Gm-Message-State: AGi0Pua6LVAgRnN9gamPpakGwdUclLiZetB31JMemRJFtYTllDDV2my2
        Mhjy+OGDK1yK+aI8FHLjTX77Tzzifak=
X-Google-Smtp-Source: APiQypIayNwuIFKSrcMipnt+9i8jOh6bCqZoJigov/9fNtnX0OWJYlAEwXX+Wx0xNBN6D9/0QrovEw==
X-Received: by 2002:a63:c212:: with SMTP id b18mr9988167pgd.92.1585768203727;
        Wed, 01 Apr 2020 12:10:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t63sm1991149pgc.85.2020.04.01.12.10.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 12:10:02 -0700 (PDT)
Message-ID: <5e84e70a.1c69fb81.bc20d.8d14@mx.google.com>
Date:   Wed, 01 Apr 2020 12:10:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.113
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 147 boots: 1 failed,
 136 passed with 3 offline, 7 untried/unknown (v4.19.113)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 147 boots: 1 failed, 136 passed with 3 offline=
, 7 untried/unknown (v4.19.113)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.113/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.113/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.113
Git Commit: 54b4fa6d39551639cb10664f6ac78b01993a1d7e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 23 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 46 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 13 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.113)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.109-202-g=
69e7137de31c)
          meson-gxl-s905d-p230:
              lab-baylibre: failing since 1 day (last pass: v4.19.109-192-g=
bae09bf235a5 - first fail: v4.19.109-202-g69e7137de31c)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
