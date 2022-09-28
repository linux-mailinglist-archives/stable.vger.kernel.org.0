Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CBE5EE6E7
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 22:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiI1U60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 16:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiI1U6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 16:58:25 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43465AA32
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 13:58:24 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q35-20020a17090a752600b002038d8a68fbso3941234pjk.0
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 13:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=MFhJUbUPU3qnBZ4HAVjbiiQix4Xj+qeVzwCT3ieYl6g=;
        b=MADUhjxUaD366wOBqZRhkox+ss0JfUyGYkbGRHWQu5fL46ZuFvr/iwMCACvNhmk4/i
         LRKEp7dnS68S7g8j4bSRR49kp8FIFzCQF++Yax+E3qakMUzDFc9qhDIbVC1KLf0/4dOX
         2rUvXYiklxOVT16W/IbkVcTIrzzRUqDNqZOxoB25bx1p7BFqFMDHE9EpJkUYRW0eWAQ2
         gUgEbAUXkj6rZb6TnDmZzUX2CLixNVjgCwUS3ySab6dk3km9tPNXVolE0Qi8wX7jKaEN
         AaRWIiw+u5sXbHffbvOykqoCEKDDXYyqpx/0iJuuj0rJPVlHvHesX/AJUCE41Pmw18ir
         AYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=MFhJUbUPU3qnBZ4HAVjbiiQix4Xj+qeVzwCT3ieYl6g=;
        b=tFFW/HjukZpPNauX9IHLFD3EsXs0iSLqyB9azZzsR98GHOxjk4l/dUGnH0YuZHoT4w
         URbIE4edfmJ8VAg6QgJOWWuO44mxlaqwWF4T/AlUCsgO7P8xwycS1l9mfO5FYEzhteJh
         IamNGUQQg8eZPG859jdMtOCtggE2+6iPL917PXhT/tcQnP3VVcFD3qOn2RuceJdBNG+3
         wzx/Ei/gixO2JpxyHmVyAUCGE0VUCFpKegi/6Kyx4YuDXiTEkf+U9jtk3Q2aQV/elB8x
         ms8IMUhTFXNVConTa4z6I0g2tou4ygYHUFKtAsm4XIs2BRSPEQQ2juXLwYNj0SYs1/dl
         PHvg==
X-Gm-Message-State: ACrzQf0Hs8HiuEY/aPey15qS8CPXRERC2BvSQ4dJdxSnh/hOjVnjRAA/
        h61o9asLFUCLhwgpa5eqoEVWeE3hIkC4TUA0
X-Google-Smtp-Source: AMsMyM5vNsr7azS7YtCOn+17CYq8zSqtzhNfHT8H9BkOOr7hpTn79BvF0L8BxIZAl8rBlD/oyg154w==
X-Received: by 2002:a17:90b:164a:b0:202:5f0f:290e with SMTP id il10-20020a17090b164a00b002025f0f290emr12427886pjb.27.1664398704031;
        Wed, 28 Sep 2022 13:58:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902f35200b001782aab6318sm4148289ple.68.2022.09.28.13.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 13:58:23 -0700 (PDT)
Message-ID: <6334b56f.170a0220.3ee90.779e@mx.google.com>
Date:   Wed, 28 Sep 2022 13:58:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.71
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 198 runs, 7 regressions (v5.15.71)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 198 runs, 7 regressions (v5.15.71)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
beagle-xm          | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =

hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

imx7ulp-evk        | arm    | lab-nxp       | gcc-10   | imx_v6_v7_defconfi=
g          | 1          =

imx7ulp-evk        | arm    | lab-nxp       | gcc-10   | multi_v7_defconfig=
           | 1          =

panda              | arm    | lab-baylibre  | gcc-10   | multi_v7_defconfig=
           | 1          =

panda              | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =

rk3399-gru-kevin   | arm64  | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.71/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90c7e9b400c751dbd73885f494f421f90ca69721 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
beagle-xm          | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =


  Details:     https://kernelci.org/test/plan/id/633485178e96e826ffec4ef4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633485178e96e826ffec4=
ef5
        failing since 139 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63348d8abea67ae9afec4eab

  Results:     18 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-1=
1A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-1=
1A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63348d8abea67ae=
9afec4eae
        new failure (last pass: v5.15.70-144-g0b09b5df445f9)
        1 lines

    2022-09-28T18:07:44.137636  kern  :emerg : __common_interrupt: 1.55 No =
irq handler for vector
    2022-09-28T18:07:44.147159  <8>[    9.553607] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
imx7ulp-evk        | arm    | lab-nxp       | gcc-10   | imx_v6_v7_defconfi=
g          | 1          =


  Details:     https://kernelci.org/test/plan/id/633480c0067ed0e081ec4eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633480c0067ed0e081ec4=
ebb
        failing since 1 day (last pass: v5.15.70, first fail: v5.15.70-144-=
g0b09b5df445f9) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
imx7ulp-evk        | arm    | lab-nxp       | gcc-10   | multi_v7_defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6334823fe42763d77aec4ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6334823fe42763d77aec4=
ed5
        failing since 1 day (last pass: v5.15.70, first fail: v5.15.70-144-=
g0b09b5df445f9) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
panda              | arm    | lab-baylibre  | gcc-10   | multi_v7_defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6334816658edbd077eec4eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6334816658edbd077eec4=
eba
        failing since 43 days (last pass: v5.15.59, first fail: v5.15.60-78=
0-ge0aee0aca52e6) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
panda              | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =


  Details:     https://kernelci.org/test/plan/id/633485626d08cc86adec4eb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633485626d08cc86adec4=
eb4
        failing since 35 days (last pass: v5.15.60-779-g8c2db2eab58f3, firs=
t fail: v5.15.62-245-g1450c8b12181) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
rk3399-gru-kevin   | arm64  | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63348734118f7f4788ec4f0d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63348734118f7f4788ec4f33
        failing since 204 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-09-28T17:41:00.894132  <8>[   32.603411] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-09-28T17:41:01.917897  /lava-7440248/1/../bin/lava-test-case
    2022-09-28T17:41:01.928552  <8>[   33.637942] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
