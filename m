Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108FB1AF8E5
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 11:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgDSJLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 05:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSJLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 05:11:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E614C061A0C
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 02:11:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id w11so3499399pga.12
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 02:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uhmib82e2cBOG4TeL7EmBgD66jgrbogOVdpkowhoOKY=;
        b=FFhs8PgpXRFkX/OmuaJyebwX1Ll5hlume8m80YRQLGyzjQqGjtbcRytmJD0bjQSoNU
         pDrrfCfuOKCf/+Nq1GgSPPwVH8HULfNb4e0akh+6rVhXyQ1qiXWRvMH6Mc0ROPkOp7aG
         7q+WsgO/GWxFLda7wQ7xSjMhdBlIqej1x/wsVDAvevM29nQpiZLHQ449ptuPhLT7wMYT
         tjFDVTG5DeUsEVE14731b6aaeJAVA3xt5vwP3j6g2JzYAcC4Kd5mGTxXBGyBzUHHX5dC
         SQ0rpX0MN56v6GyYqI8QgBOcHciPUKC5VzKvLoGvkDLLIAJctQKnFRJS8mp1OvIH5OLs
         /6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uhmib82e2cBOG4TeL7EmBgD66jgrbogOVdpkowhoOKY=;
        b=jAVHqr94vFQ1vDUBV3170jreaYGvWKEdJ9g6ksL7LYARwwkxH9ajz52weMW3ixbtrl
         0i1woXJWPykD2bSvYGdIfzmxkhkcJfT6VA/nxxrfqQPyxUD9c5W8WhwapGwBpUqcXv99
         Yzi9bpRMeaHSfyL9NRmcDVpAyzEqt/KC3O/qt45rzdiTVSU8WiJ3LaNmsKZNwroYY+Ye
         g9d2rPnv+SlK5538F5w1QpEpGrq2kq8VkgpE+aem4TaAksvTrh1VjBCJaVKRX6PFQ9aH
         AOPQ9EFLIXozt15L4KoZLKR3i/xYWvQ5HAujbQzlvoKBOjBhsdOndXbYAqw+bd43tWqM
         fz5A==
X-Gm-Message-State: AGi0PubvhWVy77Uz0YDLHueuev3aZWF+EoAcWnhg1x+q3HD+kAIlzzQ9
        67ElbPHD6Zr9ZzVXoHXRJ10ht+zu+YI=
X-Google-Smtp-Source: APiQypKQM/3Vb0u6lMxmWfqMrai3t20kMZYjB4H+ylES7nX49hm2ohfjEdTOPXpCrn+pgdx72Reo2A==
X-Received: by 2002:aa7:988e:: with SMTP id r14mr11768511pfl.146.1587287487648;
        Sun, 19 Apr 2020 02:11:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j16sm21679805pgi.40.2020.04.19.02.11.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 02:11:27 -0700 (PDT)
Message-ID: <5e9c15bf.1c69fb81.c92c5.c23e@mx.google.com>
Date:   Sun, 19 Apr 2020 02:11:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.116-25-ga501871d59fd
Subject: stable-rc/linux-4.19.y boot: 147 boots: 2 failed,
 134 passed with 5 offline, 5 untried/unknown,
 1 conflict (v4.19.116-25-ga501871d59fd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 147 boots: 2 failed, 134 passed with 5 offline=
, 5 untried/unknown, 1 conflict (v4.19.116-25-ga501871d59fd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.116-25-ga501871d59fd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.116-25-ga501871d59fd/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.116-25-ga501871d59fd
Git Commit: a501871d59fd4b3bc27b67f1d5eb3041f1fea9c0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 22 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.114-203-g287f80e0=
7bbc)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 70 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 37 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114-203-g287f80e=
07bbc)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.114-203-g=
287f80e07bbc)
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.114-203-g287f80e0=
7bbc)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.19.114-203-g287f80e0=
7bbc)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
