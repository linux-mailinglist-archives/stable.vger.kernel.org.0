Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134163D41E6
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 23:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhGWUWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 16:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWUWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 16:22:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20F6C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 14:02:36 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mt6so3986162pjb.1
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 14:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mHwrZdd7d8//DLXwmT/baM27vxdEdkTo5zBaZ1lo95o=;
        b=pHiUvjdQRiGyo68urPovhbCm5EZ6X55p877MVKtuj8urd+AhE5/RaV1Qgn6X2mLUUO
         p8a6ARXWZyJc+2PbauVUT52LEN7YSZoyiMuDdf9D8b1u6PDWBxcAcrRHimP67JqY8Mab
         mux+FvxfAk2sxSBQk8VYZuj/rcaozAEIu5KHjeuqTC3V+dpQ8dUpeonia34poemUIQmq
         WfqPrHQxguy3e/X5hZ5foWwKJAwChv6m1jEUOMMHVl9Ot19fjA+8I+UuW7/HG0bYpUGv
         JpUJy1sDT5yHXx2u7YtHETNyYxgNPZ0z/UwLmnZyt8178gMYW6vE8Fp4pZF2anst6u7t
         efXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mHwrZdd7d8//DLXwmT/baM27vxdEdkTo5zBaZ1lo95o=;
        b=i8yMTaXhVa40mTJNjG3lDOH3tr5PWGBtutlOsknSvDThnaaoUxhsix7UpDKXgCFhg3
         Iy+uSQIQcHyFTR0u4Unuu6f3M/3ItrsiE27fKLO7KsNEKFPksa4zWS2bXhoNStZ4K1pC
         Go+h4iwL4ssYebfrM7r+tg58kaXELOKFyO45gR3ZJ1gpuXrR8wIohZixVpGSONsbI9Na
         aY8qmOb9CB+RVggCf1D3jYAbUYTjW2Ex0IlFKElNIH8EE9NRhC1mW8BZTYlO1X9uSkET
         7QYnfsFHpOWTkLhS7aQl+pofAfFks8ZMGH92gDzEP/vekTvadh3bkHYJeyosw+OQaU/3
         rX3Q==
X-Gm-Message-State: AOAM530UzfoDByPlCALrXsc8sYDAqXjMNE1Pidu5tMmicutKxhqeyf0r
        kvJZ9a4KAVfQra5iodFB8v8WgswZREEZsQhn
X-Google-Smtp-Source: ABdhPJw3cYg0Z4EBZZuCLcDkmthhmcZyv09vUmH1/PTLb6Zw+GKFhmZa7bOeorGZxgxSyXPktU+wJg==
X-Received: by 2002:a17:90b:4acf:: with SMTP id mh15mr6257658pjb.196.1627074156198;
        Fri, 23 Jul 2021 14:02:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r15sm29696669pje.12.2021.07.23.14.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:02:35 -0700 (PDT)
Message-ID: <60fb2e6b.1c69fb81.2aaae.a96c@mx.google.com>
Date:   Fri, 23 Jul 2021 14:02:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.3-507-ge3b5bf0956ed
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 183 runs,
 5 regressions (v5.13.3-507-ge3b5bf0956ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 183 runs, 5 regressions (v5.13.3-507-ge3b5bf=
0956ed)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig   | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

meson-gxm-q200          | arm64 | lab-baylibre | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.3-507-ge3b5bf0956ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.3-507-ge3b5bf0956ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3b5bf0956ede2ac276b13b7fd1bf17a5a760924 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig   | 1          =


  Details:     https://kernelci.org/test/plan/id/60faf71ab1a85f62b43a2f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faf71ab1a85f62b43a2=
f23
        new failure (last pass: v5.13.3-507-g9f06663c91b85) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60faf95318e9fdd35e3a2f55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faf95318e9fdd35e3a2=
f56
        failing since 2 days (last pass: v5.13.3-349-g948be23c1d3d3, first =
fail: v5.13.3-350-g04f08469f404) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60faf88ce5dc0ab14b3a2fce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faf88ce5dc0ab14b3a2=
fcf
        failing since 8 days (last pass: v5.13.1-804-gbeca113be88f, first f=
ail: v5.13.1-802-gbf2d96d8a7b0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
meson-gxm-q200          | arm64 | lab-baylibre | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60fafeb7baa027403d3a2f44

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fafeb7baa027403d3a2=
f45
        new failure (last pass: v5.13.3-507-g9f06663c91b85) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60faf417c4d6c8c1523a306c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
07-ge3b5bf0956ed/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faf417c4d6c8c1523a3=
06d
        failing since 3 days (last pass: v5.13.2-253-g45582c2691e0, first f=
ail: v5.13.3-349-g948be23c1d3d3) =

 =20
