Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D596D3D0E73
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 14:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbhGULWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 07:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236844AbhGULT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 07:19:29 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8106C0613DF
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 04:59:04 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t9so1648017pgn.4
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 04:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/HBxDFSieVwPRLmP54v2TDOe78Pb0xOjr+VZWcWlHPs=;
        b=yMIRGsAnjEwWLty5NDJu5jb6lniHSqgoMrhU4d9tLMnEdm3HJkOsbXrKvM6VOx70K1
         Q21RnG+fVfgJB3Aa99LtxXk2ROv+6xo1RF9w/nWIPXW6R9NejFCg80uTQoD5/ubxT1mD
         Dk7m/Tgs6k35+ELfKcHYEp0VBTvM/jyhTupX4vpYmAfrgSmDdV9UqTzVwyxTwJulmFh7
         lkOynMQBw4PoU4TqFsbEYNAoje1qxnPRdVmUZg1I+jrNml5+L6INbwfqpvX4gUxx/BYn
         Hi4CcnO+fsMhztJqwyR3w1OsNksq5llVrLR2a8/soDGaN1oX58fdHwlBXnakS4z5KhA5
         SpCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/HBxDFSieVwPRLmP54v2TDOe78Pb0xOjr+VZWcWlHPs=;
        b=CAqEHVqsvZ7hoc8+mEWc6854YJ7q+Lv80G3+hqnmYnJPmVXXY/86VYlG322fQWffHa
         2lxJ2lGSxkY0A+K0rCvFf7ek61VMaZhZOHmqw8CO22wOMk9Yuqb35Q1XgtW/yVJDB0fd
         EIJNjKF7XDNV9WhGFubFUpijtdiA2QaaiJUFOpPJ842KdQMHrfYfQQ7w3rqAmBHm7Tug
         dLbYklqTZSaY081On1aV7xk0RIDm8Nx+72qsU63OxaVZDLl69LdqJ7+oD/Z6fN9j5WCQ
         J0aUYb62d4wbX8Xe2VTnXLph6MT6LoV/qkljx5JsJAAyO6K1+HXbdnbr2q1I1oCoLJPv
         tKvQ==
X-Gm-Message-State: AOAM5322r1Ht+xNFN2sVflfZVNMjso/PAboHE8Klrl+9re81CHOKbdXs
        ryJguScUWnPgjkx/hFo2N3H1MgDufSP3wcS6
X-Google-Smtp-Source: ABdhPJylXpUwLpzetx0/iuZfcvAQU41JPLUsWZ7qv/w5DYvbbl9yUlWWDe6LD3LPMd7e9W9JJPhI3Q==
X-Received: by 2002:aa7:81cd:0:b029:329:fcb0:1b44 with SMTP id c13-20020aa781cd0000b0290329fcb01b44mr36257717pfn.5.1626868744184;
        Wed, 21 Jul 2021 04:59:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k20sm5520266pji.3.2021.07.21.04.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 04:59:03 -0700 (PDT)
Message-ID: <60f80c07.1c69fb81.e022b.1cae@mx.google.com>
Date:   Wed, 21 Jul 2021 04:59:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.52
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 149 runs, 7 regressions (v5.10.52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 149 runs, 7 regressions (v5.10.52)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
d2500cc                  | x86_64 | lab-clabbe    | gcc-8    | x86_64_defco=
nfig             | 1          =

d2500cc                  | x86_64 | lab-clabbe    | gcc-8    | x86_64_defco=
n...6-chromebook | 1          =

imx6q-var-dt6customboard | arm    | lab-baylibre  | gcc-8    | multi_v7_def=
config           | 2          =

rk3288-veyron-jaq        | arm    | lab-collabora | gcc-8    | multi_v7_def=
config           | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.52/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2cd5fe24a7f025448f19d98c4f4c45ff79ce0784 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
d2500cc                  | x86_64 | lab-clabbe    | gcc-8    | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7d11ca313f9b1c785c28c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.52/x=
86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.52/x=
86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7d11ca313f9b1c785c=
28d
        failing since 1 day (last pass: v5.10.49, first fail: v5.10.51) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
d2500cc                  | x86_64 | lab-clabbe    | gcc-8    | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7d27071b45635c685c2b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.52/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.52/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7d27071b45635c685c=
2b1
        failing since 1 day (last pass: v5.10.49, first fail: v5.10.51) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
imx6q-var-dt6customboard | arm    | lab-baylibre  | gcc-8    | multi_v7_def=
config           | 2          =


  Details:     https://kernelci.org/test/plan/id/60f7d20d57ac81a23885c287

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.52/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.52/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60f7d20d57ac81a=
23885c28e
        new failure (last pass: v5.10.51)
        4 lines

    2021-07-21T07:51:12.682429  kern  :alert : 8<--- cut here ---
    2021-07-21T07:51:12.682950  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-07-21T07:51:12.683943  kern  :alert : pgd =3D (ptrval)<8>[   42.59=
7974] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-07-21T07:51:12.684238  =

    2021-07-21T07:51:12.684476  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60f7d20d57ac81a=
23885c28f
        new failure (last pass: v5.10.51)
        47 lines

    2021-07-21T07:51:12.735560  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-07-21T07:51:12.736074  kern  :emerg : Process kworker/0:5 (pid: 55=
, stack limit =3D 0x(ptrval))
    2021-07-21T07:51:12.736340  kern  :emerg : Stack: (0xc2407d58 to 0xc240=
8000)
    2021-07-21T07:51:12.736568  kern  :emerg : 7d40:                       =
                                c3b8e1b0 c3b8e1b4
    2021-07-21T07:51:12.736788  kern  :emerg : 7d60: c3b8e000 c3b8e014 c144=
a908 c09c6a84 c2406000 ef85e740 80200018 c3b8e000
    2021-07-21T07:51:12.737458  kern  :emerg : 7d80: 000002f3 95009e00 c19c=
7874 c2001d80 c3a62600 ef86cc40 c09d41dc c144a908
    2021-07-21T07:51:12.778679  kern  :emerg : 7da0: c19c7858 95009e00 c19c=
7874 c333ad80 c333b000 c3b8e000 c3b8e014 c144a908
    2021-07-21T07:51:12.779201  kern  :emerg : 7dc0: c19c7858 0000000c c19c=
7874 c09d41ac c1448630 00000000 c3b8e00c c3b8e000
    2021-07-21T07:51:12.779461  kern  :emerg : 7de0: fffffdfb c2298c10 c253=
0ec0 c09aa0cc c3b8e000 bf04a000 fffffdfb bf046138
    2021-07-21T07:51:12.779727  kern  :emerg : 7e00: c333a340 c39ab508 0000=
0120 c39ae040 c2530ec0 c0a03d28 c333a340 c333a340 =

    ... (35 line(s) more)  =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
rk3288-veyron-jaq        | arm    | lab-collabora | gcc-8    | multi_v7_def=
config           | 3          =


  Details:     https://kernelci.org/test/plan/id/60f7f5bb06a723510585c26b

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.52/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.52/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f7f5bb06a723510585c27f
        failing since 34 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-21T10:23:26.029221  /lava-4224305/1/../bin/lava-test-case
    2021-07-21T10:23:26.046008  <8>[   14.643567] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f7f5bb06a723510585c295
        failing since 34 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-21T10:23:24.619155  /lava-4224305/1/../bin/lava-test-case<8>[  =
 13.216286] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-21T10:23:24.619640  =

    2021-07-21T10:23:24.620192  /lava-4224305/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f7f5bb06a723510585c296
        failing since 34 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-21T10:23:23.581985  /lava-4224305/1/../bin/lava-test-case
    2021-07-21T10:23:23.587306  <8>[   12.196519] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
