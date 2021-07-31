Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA733DC6E7
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 18:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhGaQ1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 12:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhGaQ1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 12:27:17 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B54FC06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 09:27:10 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so25341034pjb.0
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 09:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EZ2SbmMcXKdB71s5DnpOKPq4VCy6pkMj8+YuyzPBNrQ=;
        b=tsd4DJ74eGRHRiJLcjprPRyI5gN6csi711ibgPKQLeMgGwf/Mqv96jw+3LYF5bPkTK
         P/Kt4Camv8WS25wb0Xiz/7tLxmYD6q0+55pjlUlBMTDmcu4bKDmp3Fs/u7Ba30pqu2Q3
         l1rYpjQXIzDisgr7bHPX/h3Sdq4xWoJVZ2kU1+yq64YWzZWkJnpAEJclFv3KNfvjhEoG
         j3NsGP45MDHZ3ZejeeywaFYLUBak50Q5FFgKN5Nwn2WfyW2Wy06nZaJ7bnT6RcxRV+0H
         niKyMpoOcPLAMIkuKeDY97EzQVO6TVO5DsXvuvfCw7Pd/lrZlRi6u0FYC1hTLg2Rxch9
         keJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EZ2SbmMcXKdB71s5DnpOKPq4VCy6pkMj8+YuyzPBNrQ=;
        b=jHt9dvVHLZRuTB3ROnCdCPfzDiGMLyQ21WbjnYRyUgjVbSF/42u7NVeR164LLfViN5
         FoVIxhIFNpESzfUsyMUgUUWPDzY69jyuzlzN5aJjgO9H0PoPcX0oqQbfO/bFnrrQWG0A
         kM66FXoYIyuJ2OV1AJgkAGZqZAEgIrKCe0D83HVARb16G9mAKOn+mBeT3x1Uay3zF4gY
         SNwjTsmaxTK/6EcdPbsvuww2AhvjnHWWd2Nc3TUmyw4JvqQFIWYDtjq7tbGJD7s9ARnd
         pKRKoPz6P99ZddSKs16R0prf0zueqio7o0MNs70XjsG5URrQptXhVV52IxOogaV3qmUv
         tDJQ==
X-Gm-Message-State: AOAM531UYUTuRzfIZ9bQRFtMFSM0IrHM2pUudzSLlxQ7tYBjzJCs5y0M
        yDxifRvZq1K043IioXomPizjfy6Hmc/1hMVw
X-Google-Smtp-Source: ABdhPJzNfvw7WMoZa0yRmjhXQwpuTrtJDozP/0Yp9rRVy/4D5f1btELqf4iLNxU8Gl4K/9bTQqUsUg==
X-Received: by 2002:a62:61c3:0:b029:35b:cb61:d2c3 with SMTP id v186-20020a6261c30000b029035bcb61d2c3mr8377899pfb.62.1627748829428;
        Sat, 31 Jul 2021 09:27:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n22sm6233349pfo.125.2021.07.31.09.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 09:27:09 -0700 (PDT)
Message-ID: <610579dd.1c69fb81.a8618.0cbe@mx.google.com>
Date:   Sat, 31 Jul 2021 09:27:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.137-19-g10fa8370b941
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 150 runs,
 4 regressions (v5.4.137-19-g10fa8370b941)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 150 runs, 4 regressions (v5.4.137-19-g10fa8=
370b941)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.137-19-g10fa8370b941/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.137-19-g10fa8370b941
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10fa8370b9412e397dbf2bdcf33dd7a3ffde449d =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/610540d6c43e21f15885f48d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.137=
-19-g10fa8370b941/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.137=
-19-g10fa8370b941/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610540d6c43e21f15885f=
48e
        failing since 253 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61053e95b43251745285f482

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.137=
-19-g10fa8370b941/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.137=
-19-g10fa8370b941/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61053e95b43251745285f=
483
        failing since 258 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61053e89ad45203c4e85f4c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.137=
-19-g10fa8370b941/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.137=
-19-g10fa8370b941/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61053e89ad45203c4e85f=
4c4
        failing since 258 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61053e43263b214df185f492

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.137=
-19-g10fa8370b941/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.137=
-19-g10fa8370b941/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61053e43263b214df185f=
493
        failing since 258 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
