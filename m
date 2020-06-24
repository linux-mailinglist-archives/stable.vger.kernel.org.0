Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9562207640
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbgFXPA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391192AbgFXPAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:00:23 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80A3C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:00:23 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 35so1171837ple.0
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=syvNOAN/P8j1NpOh5s+srO9cTyhHyR6dhpwYdlet0U4=;
        b=RTFF14rngUTqqIuv01bstB4kXNVfOaq7gVcsA35oerrVNT7UkgPcHbqVWCVjCzo3zo
         FDK53fkxBRhyGYkG4pEms3fI5aIpyJ/OyOesTwoyB+ZqTiJg2+S/zRWRcdMvPfcW1DQ5
         Cw4G1QZ0zGcSnNEbSkxbJD5yrP98SpHSq/gIkngzqEQTAEIu+lNaRsTUW6RYPrGGQNZO
         PKiNTdSkCVnnlZL1/eZEaDFxlCoXb7ueJJu2yfmfUuqCQetCRuUahat/JdvYUJJAGdQm
         j+IH829er7iDXYPgH3JeAusASH1Ifh0gWZNynTMliDamH7Ri5OcJh8FgtyfJoiPHC4lw
         1PvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=syvNOAN/P8j1NpOh5s+srO9cTyhHyR6dhpwYdlet0U4=;
        b=c9WlQr1ukn5NHqYnlRJOCDDaoYtIroVQ3TpnIHe/CpZRc59ZCRNjrWWzIYs7P5huyx
         giXehpiKT+kFLT4MprwEA5/gOTx68NCRetcRm0FdwIYm3M4FRqBgMFKXyn8E15T280m+
         328nNggHMM9PvaIiWJ/4ZAoHnPfdC7pimhShYHuS370iOpMiN/4z5hCjBfAIBulOA29P
         +Y1HDadU54NtDG9Cp9RNDE07uQR3L1a8cBGFSme+3iK7Yb9p0Y46xc80fysid0cTB3jT
         UIDCoQAu95jeb+0HEOfWEhjy+KvHo9ZPqUmIeFU9euLJqEzmoLuwXrQhpi8XPhPLE9yz
         UCIw==
X-Gm-Message-State: AOAM5314DFx2odMiQwT3+c8/hGPKl2lu0dHuQa7qvGM6p9NoZiHzeDqY
        znXjVwLl7WpZm54TIALo+FpHVkpcBJg=
X-Google-Smtp-Source: ABdhPJxi55kta++XbbDIHeb7j03do16WvtI0+qLk4BzSOn2oRZKTmyrP0m4j8RcwMj51TBnDlMkhtA==
X-Received: by 2002:a17:90a:1ae6:: with SMTP id p93mr27827577pjp.182.1593010822992;
        Wed, 24 Jun 2020 08:00:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j17sm17573122pgk.66.2020.06.24.08.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:00:22 -0700 (PDT)
Message-ID: <5ef36a86.1c69fb81.23d98.4ed7@mx.google.com>
Date:   Wed, 24 Jun 2020 08:00:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-374-g1c6114e25934
Subject: stable-rc/linux-4.14.y baseline: 33 runs,
 1 regressions (v4.14.183-374-g1c6114e25934)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 33 runs, 1 regressions (v4.14.183-374-g1c6=
114e25934)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-374-g1c6114e25934/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-374-g1c6114e25934
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c6114e2593492f39e02c775d117c95d86f9ae83 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef335d5451161405797bf10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-374-g1c6114e25934/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-374-g1c6114e25934/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef335d5451161405797b=
f11
      failing since 84 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20
