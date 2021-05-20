Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C4438B95C
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhETWFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhETWFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:05:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEABC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 15:03:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cu11-20020a17090afa8bb029015d5d5d2175so6209442pjb.3
        for <stable@vger.kernel.org>; Thu, 20 May 2021 15:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f+RyPYU/0sEHSmhEqa2dfh0JQ1MtGE0/qASIuxxE7eM=;
        b=TDqVvPRlqS8d7CW89ZnEeJGoNheOo78HCIS9UTQcG2r8YCiBdxa9ughwU8sLuQ9AmO
         n+f3kxJjuC48Qg4w1PVqihCyjywIl0QDp/pL3eS2cuUPwbZ8+6U4IPBYveFBwMR3XLdb
         InpBW66UUzoksNmfKdaIoQm4M56xxG6oBOeDPaY3b5g8pqciuv9XH01nkI/PMSCkfFQX
         IzPDcSHTVaPP8LN5onW8YEuPUF0iwWljmrquD+tlLwqnVhcHDLCsIM/rEYf1l5IIeCUa
         FZIG71zkhyJNlcc91MuD5YW3wdUK0yoY5NoCJl2NbJjdzsfc0pVBGE45fYtcEaNZ6ypK
         6Nrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f+RyPYU/0sEHSmhEqa2dfh0JQ1MtGE0/qASIuxxE7eM=;
        b=s/ACyHbcr/aCsZCrLkPHFnE0X500xknMfES/MqKs35jiHmCGDIZpEEBbIdzn3rRck+
         kUZcqXyMIEsHTe0NxUfAVx7j2/N5BVl/Z6CY8bTpwx8UUX6xiTh2pw8k/8AR0Jo0wJ/6
         NSqUJzAzzrbeMgXyubwu6ddSYhhd5NBH1IXoBwTyCYijN3ftbyMaEPvrHGO/vMyIeLam
         uny75hBRMGygjRS5mSw+gLscmnJb3UOANSxWg0g6EP/gg/wg/ldGYyP7r6bA3gBDGyvV
         owUKW6DB2ygvWWDAYu+ZsTRZKU2gFARtVxNrbyAjF3EDsrGak4ZZ4U/y2v+vw1FkQ1pl
         rHyg==
X-Gm-Message-State: AOAM530hYXGuz3fzqsW7XnGN4oP/wHhfbAExsBm2N4RC1D3WgtAmanwj
        tKTqq+tE+Cn7LGIYoIzPsNTDeXNVznrEM71t
X-Google-Smtp-Source: ABdhPJydZkFNyKi/Sca38RV8wHxDiY0ACTiEFULhsF6RKBUybJSiQTeXtvu6YgG8UuvPWhIVM3fDlA==
X-Received: by 2002:a17:902:c3cd:b029:f1:57d0:4de5 with SMTP id j13-20020a170902c3cdb02900f157d04de5mr8371444plj.53.1621548232425;
        Thu, 20 May 2021 15:03:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 25sm2664998pfh.39.2021.05.20.15.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:03:52 -0700 (PDT)
Message-ID: <60a6dcc8.1c69fb81.fd61c.a15c@mx.google.com>
Date:   Thu, 20 May 2021 15:03:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.120-38-gd1968aee6ca9
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 152 runs,
 5 regressions (v5.4.120-38-gd1968aee6ca9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 152 runs, 5 regressions (v5.4.120-38-gd1968=
aee6ca9)

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

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.120-38-gd1968aee6ca9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.120-38-gd1968aee6ca9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1968aee6ca982be479b6584d449c4d9b749f244 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6a9d8cd86add669b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6a9d8cd86add669b3a=
fa5
        failing since 181 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6a70446d65af507b3afda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6a70446d65af507b3a=
fdb
        failing since 187 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6a71c75b2fe97a8b3afcb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6a71c75b2fe97a8b3a=
fcc
        failing since 187 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6a716f3036496a5b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6a716f3036496a5b3a=
fa6
        failing since 187 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6a6c0cb3b265625b3afd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.120=
-38-gd1968aee6ca9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6a6c0cb3b265625b3a=
fd8
        failing since 187 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
