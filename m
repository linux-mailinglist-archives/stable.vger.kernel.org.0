Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39E41ACFE1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 20:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgDPSnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 14:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgDPSnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 14:43:22 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664C3C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 11:43:21 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so1731155pjb.3
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 11:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xz1s1Uxqhb8c46iNTU/X1Dd0+JBjpvuN6VvRQATLKxE=;
        b=agGgaom+T7aVzuak3nJvT6U6YLxh5pBZz4vj9XYvxR2R7IDLDXWyR3vdzSLCu3qcbg
         0VUtG3TYbii/jdmIcRHwl3ERPJFmuducUm72IlwYqHaksSyoVGsplDotJTa4EF9xxsWD
         eAhvmJiEKgzTuJBr7xdwvodwikPS+/KjU1U5Bi06JGKZ6HJbWEHOcT6oPjOAiRzQQLWL
         oaxrPRBvUEHc6v01UYEaxQ9hveS+6Tw1qdccAc2EPSd8qpIt1mMFFnDwgao3KCh8Oxo4
         Vu/lNgG2w3T9K5KJFgen2eD5X3mcZif9tV4NkbzRKfB+Md9iZ25l9tDxyZK/IVxOT4xj
         hezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xz1s1Uxqhb8c46iNTU/X1Dd0+JBjpvuN6VvRQATLKxE=;
        b=CFA6UKDJPVCz4AYlwaivWFzQLyy4vQNJ6Lg9owD1RZ2SMklL1suTKra7t7c8lPjQ+e
         jmRt2yRkgKG/UJsFKSvavGPMvWrHjJPOQKjjEsjvUPQiHu75LMMUjccAQOCIzZrHsTWG
         eM93P+9Kf5ksjqhCWCsFdtXAXQAPnYGPRwqdymQH+SEz6mUjYByiwxPyPYVRLXVCzb/8
         PXAtZEcIFVqe1ux3/6oYZCZ6oEQfeDf7eNDXqqN6va5yLE8lW5O+Hla01vxu+e+fBIXm
         WUE1d5eaU+h5Nh42X3JIRPrgYtvZfA1IE7BgCs90W285vomnpz+VYZOY/e3F7NigymII
         reBA==
X-Gm-Message-State: AGi0PuYtispLqU9VOwV/IzH0Zj8GYgG+19OSH74kWkJlnEYjf1ZjrxgD
        nyKB6qUk0n+2g36/19DPmt0Rca+VQgM=
X-Google-Smtp-Source: APiQypLwWDVEpTpaMd8Zd840zOpz476gdu+Vgnft99T9UuW7v/zYutike4lnZug/qYU5fAdqaK8Z+A==
X-Received: by 2002:a17:902:ec03:: with SMTP id l3mr10818937pld.73.1587062600603;
        Thu, 16 Apr 2020 11:43:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g11sm3277406pjs.17.2020.04.16.11.43.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 11:43:20 -0700 (PDT)
Message-ID: <5e98a748.1c69fb81.da093.b0bb@mx.google.com>
Date:   Thu, 16 Apr 2020 11:43:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-203-g06906a122520
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 146 boots: 1 failed,
 137 passed with 3 offline, 5 untried/unknown (v4.19.114-203-g06906a122520)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 146 boots: 1 failed, 137 passed with 3 offline=
, 5 untried/unknown (v4.19.114-203-g06906a122520)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114-203-g06906a122520/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114-203-g06906a122520/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114-203-g06906a122520
Git Commit: 06906a122520142a26c296b21a9a2a31b1dbb40d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 23 SoC families, 20 builds out of 205

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 68 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 34 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114-185-g53a9f76=
066d0)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.114-185-g=
53a9f76066d0)

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
