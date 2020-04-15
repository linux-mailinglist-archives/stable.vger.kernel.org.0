Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8C01AB3B9
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 00:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbgDOWRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 18:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731098AbgDOWRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 18:17:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E287EC061A0F
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 15:17:37 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w65so658688pfc.12
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 15:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kdBZW0zEdYPTZlkASIL5Gdh8zXkKQ1ibMoqNa6lh824=;
        b=FrkgOZc44L0lsTcOYiAAezBo0t5Un16jgqOWUGr0hEKsYzGyMIbIDKC/LHQqUmaXCO
         fbFgiyGB5cPxFOPTW7Ej+spk54cJVfsC6lf8YNDCUn0yWpTagKLkKTz2BucV1+qdA5rK
         EGjFcl3gl8g+LPGkS70WmbHHYt57cd5mbuyu783e4VFn2p3o1gp2vA2s91MNDv6LgaXd
         onmkb3+T9p9FoqqvhW7O096rkA+jFUJRjJ8Cn05/i2/7X8YHEOlG/OrqF7/56yzrhmim
         3FiNaQ2A+cTORpr7Ykoa95x73ejnTSdtA/sW5+cvRKLnxP6nCbmCg8ZLkxPKFzuAIm+G
         vUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kdBZW0zEdYPTZlkASIL5Gdh8zXkKQ1ibMoqNa6lh824=;
        b=cC5u43Ugi2o1TMUrdgHMb8F/+LFdIYkG+0H6BVNJpSkZ0c8mfNrZrVd8ibmmbEB0Gm
         bm5TRHnM59k3fRsuahB/YWx0Mxky/D7cqK0UOnroKavMUGefJEfuSsIx+Tc5Y1SVP6Mz
         CJoYT2J3qd4xzMOLfanwQjhi5vrClcev8ErybHmu9Ej5Y3zjrLWld2Xu4Lnv4DgZVJCn
         FBxDpmsz5q4wWhuj3xhnWaFFAkGnLUseTERDhs+a4uYquyQ3NDtkFTe1sGouID2Umuva
         vdBQYMkVsJtlxI42bRnNBQ8vsy3tOpds7hU97fWZvVNC3y9PgJuCo4WX5AazYDyN0bvr
         iu/A==
X-Gm-Message-State: AGi0PuZLkMvmKlptCS0eDspPrF4IFrK70mLrOLJ4ad/A4FojnvSpSfxS
        HGqVWODjQH2nwllhZUIxJx8otygTRLk=
X-Google-Smtp-Source: APiQypJWOzO3VMXlLt3zsdueb7hVtCFogQZkqrfLJ/smKHWIcHHGG/vmQJQ3cd+Mu6GEmvmXWGSvzw==
X-Received: by 2002:a63:602:: with SMTP id 2mr28786814pgg.383.1586989056996;
        Wed, 15 Apr 2020 15:17:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y186sm2496819pfy.208.2020.04.15.15.17.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 15:17:36 -0700 (PDT)
Message-ID: <5e978800.1c69fb81.3ed88.8133@mx.google.com>
Date:   Wed, 15 Apr 2020 15:17:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.31-258-gd88fa8738f21
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 61 boots: 1 failed,
 51 passed with 4 offline, 5 untried/unknown (v5.4.31-258-gd88fa8738f21)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 61 boots: 1 failed, 51 passed with 4 offline, 5=
 untried/unknown (v5.4.31-258-gd88fa8738f21)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.31-258-gd88fa8738f21/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.31-258-gd88fa8738f21/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.31-258-gd88fa8738f21
Git Commit: d88fa8738f213ef4abf1b975c2bc4cad980c94fe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 15 SoC families, 19 builds out of 200

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.4.30-81-gf16=
3418797b9)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.4.30-81-gf16=
3418797b9)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 67 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 7 days (last pass: v5.4.30-37-g40=
da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
