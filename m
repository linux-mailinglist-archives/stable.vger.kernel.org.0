Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAC0354B6A
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 05:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbhDFD41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 23:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbhDFD41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 23:56:27 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58C3C061574
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 20:56:18 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s11so9501212pfm.1
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 20:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zLPECtnbJf2fgFwvPTn3ybKQRKRhy9To8Xbs14KIZdM=;
        b=otTGFgaU5KRH2Frjb74tjF1XG0uI4PZFle+SQhwFxha67D8X0jHT39wGZn1Sn+4zG5
         CY+bZFJoJVL2dCl0jBgZiE+tCKuCTztigAUhCEzDkRYOzYCSGFF1wXl9zcK9/66mbMbM
         y87aYcrJBDiUad0fv7G/hITKfLFPmTT0Sga5mOGoT0e8aDeqZqKOkz6FcAVhtD4Pbmxc
         eP8Nhqaw4F+JdRwDek3wBjByf6kAZU3foXitBI1R6NfcnsJsIX/rIPX0IcUnqKzPfbvd
         dHdW2/2XXFA4Nmlx5dFmpWKWY8cREWwGE3OWjPFvLkt3n5+bw8NVNuWqcKCwJ6CLPL5R
         srxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zLPECtnbJf2fgFwvPTn3ybKQRKRhy9To8Xbs14KIZdM=;
        b=h2f5b2PMBGchPkNSAn3T9BqTJX3VWT1cDEkdWk5L+YRiupaZ6iK51zqf7YZaHemFmn
         jsKq9HXCTxB5O9vNIX0WbrA/j0/YhRlV7lnArWxpd5lvNxKRNLWyAq+Mv1/L4Q7BQZQv
         96DohIDkIvOMW82HIiIhf/hgcSYC8PLXCj6Y0Qee+xhGFWLZC1IoFldtSQl0QOUbrGml
         bED0JIORwrXO3kqLzlMg5YND1oQMp4uVI3Z2sq8AjuRNUkL2i8ACOh+Baxlijo5kNKVw
         NFRVXXMBPk0T2ecgFLgbhLQ9e3fkTuH4FDLHOCu+8fkVF7HW1tr+KmE5sIc8BmN8FD1x
         3SVQ==
X-Gm-Message-State: AOAM530Pp7ohA/pCuyA/2dDN7pZNdm4qaSrCViYOpwnDcdt4F8rZvNeN
        FE232wqMLjZt0WlFsZ1e+8IBkXrD+rW/j479
X-Google-Smtp-Source: ABdhPJybNgLAD+51WuGkgXfWz3BUrjn6SbQ5o//6zvs/tanUB96UkymqzUOedSJb/HUYsJkMETS1nA==
X-Received: by 2002:a62:6451:0:b029:23f:6ea1:293f with SMTP id y78-20020a6264510000b029023f6ea1293fmr922737pfb.53.1617681378048;
        Mon, 05 Apr 2021 20:56:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e68sm781923pfa.78.2021.04.05.20.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 20:56:17 -0700 (PDT)
Message-ID: <606bdbe1.1c69fb81.df52e.358d@mx.google.com>
Date:   Mon, 05 Apr 2021 20:56:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.109-75-gc6f7c5a01d5a9
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 140 runs,
 5 regressions (v5.4.109-75-gc6f7c5a01d5a9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 140 runs, 5 regressions (v5.4.109-75-gc6f7c=
5a01d5a9)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.109-75-gc6f7c5a01d5a9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.109-75-gc6f7c5a01d5a9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c6f7c5a01d5a9e0d0cfb721249d5378de5f00310 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/606ba173ef34cbcb65dac6fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606ba173ef34cbcb65dac=
6fe
        failing since 136 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606b9f8af622ab60b5dac6c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b9f8af622ab60b5dac=
6c6
        failing since 142 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606b9f8c03e41951f1dac6db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b9f8c03e41951f1dac=
6dc
        failing since 142 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606b9f29512a921998dac6d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b9f29512a921998dac=
6d9
        failing since 142 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606b9f3245990e1a97dac6c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
-75-gc6f7c5a01d5a9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b9f3245990e1a97dac=
6c6
        failing since 142 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
