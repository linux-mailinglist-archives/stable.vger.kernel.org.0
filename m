Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D4F31E27F
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 23:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhBQWfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 17:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhBQWd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 17:33:27 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06BFC061574
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:32:46 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id a9so113286plh.8
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HwPtrO6fLBodWVO17oLEalRZq96dorN4u72bmqf8BLg=;
        b=XB1weNtdY+/yV46uB3uFtMNVBKCID6pN1/f8NnKSS4ieWsPDIo/UwFyLlzYzdVtxFt
         YbWgW2p7KsOBEygvI/mmH2Yad2nVfk9sb/yR9YPsciqhprHWCKVTRqeE+lqA1FC/BIHn
         hDARIGdBuYh6HWfMR01AoDdPm/RKINM7Uf/fhzhB6mMdOROGJBFiXkLWYTAcNGtlYimg
         Nui9G0sjZgEEH5W8vcMFtILd8507qjAEFV8vivdoazN86OR10/ESgZ7RLbpvROyypplb
         +C4N8w8qnMEOROy7vzz4q2mkokm7/iuwoGCfBZFEkZlz0RtjfF/mZI7+ON3H1q3SdmS/
         pY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HwPtrO6fLBodWVO17oLEalRZq96dorN4u72bmqf8BLg=;
        b=rKnrM5fF7gpxe92naZ5SRsvwLTa+8D/H/h8v92y4dn4a5tDSnxIJi0cWNlQPmh44OD
         4c1Yj3SAtfWPtMspAxA/e6mRUO2MMAmkotqL+Ny7r4GOGH0pMSnYrIwAFMhb5K7z1AJ+
         gi4++Eh1gfbTXJ0XP604ReRUNW2aTkOSVLs2zVIzIZJw6tHknqJwryfFxs2iurm7Gxqn
         ASZ2DsUgpE64Gy8KaFCjXsTHzhcLKHxDnOPysLnKZvob2mArcnffljh96lplSTupS/dJ
         vRgiUiawCGBSX5eZY3Pf4xSdh1lqMzZmg8W2KcRwpFtUjLExNoNcH3wsPescHN1pDu9Z
         s4vg==
X-Gm-Message-State: AOAM531CX9gXeq1ruAnzI+PcVPNfTR+B7c1d+a1nvsmW8GJCCZ0EkcuU
        rpDZu+65TaKWAJEx8LdttV6m2RgU6cyPUw==
X-Google-Smtp-Source: ABdhPJwYSklFA8sWYQHfwaDXV3B1j3IyRl6h7hTvvY1GZOazPzzx4rdQKKg9AEfLhVu8K6UOYBzyqQ==
X-Received: by 2002:a17:902:e989:b029:e2:8c9d:78ba with SMTP id f9-20020a170902e989b02900e28c9d78bamr1126408plb.81.1613601165894;
        Wed, 17 Feb 2021 14:32:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7sm3719970pgr.53.2021.02.17.14.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 14:32:45 -0800 (PST)
Message-ID: <602d998d.1c69fb81.b6f45.8b8f@mx.google.com>
Date:   Wed, 17 Feb 2021 14:32:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.99
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 107 runs, 2 regressions (v5.4.99)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 107 runs, 2 regressions (v5.4.99)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.99/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      850e6a95deb5a9e6e922ace64bf2dd0ed290ecb7 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602d65d36fc7374e44addcf9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.99/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.99/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602d65d36fc7374e44add=
cfa
        failing since 89 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602d68f172aa9471aeaddd31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.99/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.99/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602d68f172aa9471aeadd=
d32
        new failure (last pass: v5.4.98-61-gc65ed94f3071) =

 =20
