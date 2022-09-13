Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553BB5B7A51
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 20:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiIMS5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 14:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiIMS5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 14:57:18 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7134DF31
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 11:48:41 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b75so7362301pfb.7
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 11:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=XodBC9OHXrdCpHrp+3T+bpktjsN7ns/R5IsYNc3QJDg=;
        b=YliWojcG9YmDkrQ/At9Gozt4m/lfthIiEbGzYrq7fkvhBB/Nb2JUJM98rX53Ulvuqq
         X5zywSockhiUjIs4oKc+h/ASo5dc20Eb32+q9c8WMQ/WKMR1L6K4rCCxZakEhmhl44Qj
         jhHmNqz8K6pBAsHhmCfdT84+f7RYOCsj8ILcuOhG9EOvZsjo4kxhru36qUr1loencLmf
         UPe4wlEaU8CPf+RiBKXZNApst6XWKqVxTCp5+pG/uT697R5JDEn5OSW0102DQAePcyUI
         41wWcrIVVyx4OBO1HrlhQecH+E8rjObgXb4bAHY+MP0ck4QsTFYPIwF7Ci/z4JFaTe46
         2woA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=XodBC9OHXrdCpHrp+3T+bpktjsN7ns/R5IsYNc3QJDg=;
        b=M1k4sHR1fhVpW1hja4Y4Q0lsfm+xpLpwWKTwNNS7CocN54I+uPdFsA+L4LdRDgt9LL
         g+OWal2rHrrWHJADjggWDLkxEpqCcQB40yIPvuoIqzZmMJTKT23jvz2skiDZxg/gvtex
         57ZorajjWGI9w1SMKglIEtzCgzlQL1PI2LttdvbT0qIXSCtzY46cg+xNcZz1IWkhyM98
         GcTGJ/LDu2XHg96mw7FzBX38HUnpmaN4DdW3UyiEFjoMxp4CJ8eB6HI+VYAh5rhvak4a
         cFP5R8HhmP5lO8rhKD3J/T446UxxDF7RihtpydRM7ph1srU8HyZUfIP/30Gk7MCEWGqu
         BPsw==
X-Gm-Message-State: ACgBeo3Kj8zkDNZxJyRAB8jVlQbJ/GgV1vtv4v7+iLquXsfgYLwS3o3f
        sJJWLuVBPYTBbDH2q4MRFgFWZ11Hd49B2mcy4yA=
X-Google-Smtp-Source: AA6agR5LgkNLnb/Ygdu3zRsRox0mUj2v97IzsG4XUC/ToTgejsbqTScO0y9ZgM8bGkCQG0j7YJV7sQ==
X-Received: by 2002:a05:6a00:15c1:b0:546:712d:4c99 with SMTP id o1-20020a056a0015c100b00546712d4c99mr3161433pfu.52.1663094921042;
        Tue, 13 Sep 2022 11:48:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ja18-20020a170902efd200b001715a939ac5sm8609876plb.295.2022.09.13.11.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 11:48:40 -0700 (PDT)
Message-ID: <6320d088.170a0220.3e300.efa4@mx.google.com>
Date:   Tue, 13 Sep 2022 11:48:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-g0e020e474faec
Subject: stable-rc/queue/5.18 baseline: 113 runs,
 7 regressions (v5.18.19-1-g0e020e474faec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 113 runs, 7 regressions (v5.18.19-1-g0e020e4=
74faec)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2835-rpi-b-rev2   | arm   | lab-broonie     | gcc-10   | bcm2835_defconf=
ig   | 1          =

bcm2836-rpi-2-b      | arm   | lab-collabora   | gcc-10   | bcm2835_defconf=
ig   | 1          =

beagle-xm            | arm   | lab-baylibre    | gcc-10   | omap2plus_defco=
nfig | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =

imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | multi_v7_defcon=
fig  | 1          =

odroid-xu3           | arm   | lab-collabora   | gcc-10   | exynos_defconfi=
g    | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-10   | multi_v7_defcon=
fig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-g0e020e474faec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-g0e020e474faec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e020e474faecd35cf22fe337b68942b134778cf =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2835-rpi-b-rev2   | arm   | lab-broonie     | gcc-10   | bcm2835_defconf=
ig   | 1          =


  Details:     https://kernelci.org/test/plan/id/63209c5fb51077ca57355683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63209c5fb51077ca57355=
684
        failing since 27 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2836-rpi-2-b      | arm   | lab-collabora   | gcc-10   | bcm2835_defconf=
ig   | 1          =


  Details:     https://kernelci.org/test/plan/id/6320a6f76f5f5f43b2355699

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm283=
6-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm283=
6-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320a6f76f5f5f43b2355=
69a
        failing since 29 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
beagle-xm            | arm   | lab-baylibre    | gcc-10   | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63209e0ace4d8ae9b835568d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63209e0ace4d8ae9b8355=
68e
        failing since 7 days (last pass: v5.18.18-6-gad8a0ac8e472, first fa=
il: v5.18.19-1-g1330c8c8f8f63) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/63209c25539a2b7650355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63209c25539a2b7650355=
655
        failing since 0 day (last pass: v5.18.19-1-g935d5e1a94dd, first fai=
l: v5.18.19-1-g05c6ce2df587) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6320ad6c08a653d2b1355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320ad6c08a653d2b1355=
648
        failing since 69 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
odroid-xu3           | arm   | lab-collabora   | gcc-10   | exynos_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/6320bc36b6f4668cb0355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320bc36b6f4668cb0355=
656
        failing since 30 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-10   | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6320cb7e9c420fd8df35564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g0e020e474faec/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320cb7e9c420fd8df355=
64c
        failing since 29 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =20
