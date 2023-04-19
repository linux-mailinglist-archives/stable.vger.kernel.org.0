Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A265F6E7FBE
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 18:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjDSQgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjDSQgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 12:36:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0898194
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 09:36:36 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a52667955dso1870095ad.1
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 09:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681922195; x=1684514195;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2qowTZIEMRyLeS1pr4C86d9n54KJVqD/Z1lQ/usInjM=;
        b=c2JOITQibZWwbaW71YF5PhaCiOHpVdInQYgDM/C1yYAgT3HNhGkG011Jg7A9628Ksq
         1zMoA7TyCo7ptMZz4/6jQIBJcANhOlIV9eWP4IvwdRQLEFvRGqEYRveTeeNXjdv720iX
         bXeF5jfw0HnVECSkHfLP1/DZWfyMo5yrnnUhaYybIrkD/I41gYHFqviDSBDwp8blNqVA
         1Z6ky4sfVbu5IU1EhA5UkwLU0odyaA4VuKUpFLipJusxbcYc13AfUf9WoSDtk0IFcPhU
         +NVaFRYVGpLHgktBj8TFAutm12HZW80LhrhKkh4DierpXtNYCeHKUuYf2p2sGd78mlDl
         Oi3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681922195; x=1684514195;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2qowTZIEMRyLeS1pr4C86d9n54KJVqD/Z1lQ/usInjM=;
        b=kDDCPDaXrKhL3A68e/Ze0eU5r0x+PnLAn5MfAp5DEeMflS+rJIw765BNvUfcMCvNi7
         7nbMKmFq4nvr7cckDNQOcn6Qngg8vZFbuNPXTWUIj6qPSrYLCxeQLhvksAB5KPRUghVU
         h7NDQKxdZ6OeNU3DUAcAM3m9bI5vBMIT2zv8XlLnOXzd5Emrgqz9+KJvjOQYd0lRqpGJ
         xQpN/unFI7w0AXhpYtM6y/y3X0turB3zuZ36tU2DqA/Zp9HkAI0iHejOy/bHt02y7ktn
         IEntHKM9GNHbSNXPoOCREi2yv41/TcYdQl45LJMnn1ORGBwauxVkyJXKp9XJIQBHLMGy
         z/og==
X-Gm-Message-State: AAQBX9c8UWHhGoTMMPcipmo8mkt1ExGd/mQf1uwwHGnkxL9CIQrhbdKC
        ntKF1X2h3hHyLEGioX0LvrVZNscItJKpLak7QvUEPDpm
X-Google-Smtp-Source: AKy350ZxZr9YwwK/GVJQ7WYWUcubCq3rDf08+qml+F/X5QslM/v052QqGyKCGz0G4oMqVI+GcPz1wA==
X-Received: by 2002:a17:902:ce92:b0:1a8:1867:1f7c with SMTP id f18-20020a170902ce9200b001a818671f7cmr4138438plg.40.1681922195306;
        Wed, 19 Apr 2023 09:36:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3-20020a170902724300b0019cad2de86bsm11634262pll.156.2023.04.19.09.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:36:34 -0700 (PDT)
Message-ID: <64401892.170a0220.203c2.9c48@mx.google.com>
Date:   Wed, 19 Apr 2023 09:36:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-276-gd757a2e2b115
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 174 runs,
 13 regressions (v5.15.105-276-gd757a2e2b115)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 174 runs, 13 regressions (v5.15.105-276-gd=
757a2e2b115)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
acer-R721T-grunt             | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

fsl-lx2160a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

meson-g12b-odroid-n2         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105-276-gd757a2e2b115/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105-276-gd757a2e2b115
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d757a2e2b1152b32964045f01cff051d82081f6e =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
acer-R721T-grunt             | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe426efa68406ab2e85f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-acer-R721T-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-acer-R721T-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe426efa68406ab2e8=
5f5
        new failure (last pass: v5.15.105-277-g6405847d6038a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe341b07872edff2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe341b07872edff2e85eb
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T12:48:38.298982  + set +x

    2023-04-19T12:48:38.305525  <8>[   10.443547] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10046073_1.4.2.3.1>

    2023-04-19T12:48:38.413781  / # #

    2023-04-19T12:48:38.517437  export SHELL=3D/bin/sh

    2023-04-19T12:48:38.518079  #

    2023-04-19T12:48:38.619838  / # export SHELL=3D/bin/sh. /lava-10046073/=
environment

    2023-04-19T12:48:38.620630  =


    2023-04-19T12:48:38.722709  / # . /lava-10046073/environment/lava-10046=
073/bin/lava-test-runner /lava-10046073/1

    2023-04-19T12:48:38.723857  =


    2023-04-19T12:48:38.729320  / # /lava-10046073/bin/lava-test-runner /la=
va-10046073/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe332d3411b4c592e8619

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe332d3411b4c592e861e
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T12:48:28.331059  + set<8>[   11.346188] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10046047_1.4.2.3.1>

    2023-04-19T12:48:28.331146   +x

    2023-04-19T12:48:28.436028  / # #

    2023-04-19T12:48:28.537054  export SHELL=3D/bin/sh

    2023-04-19T12:48:28.537232  #

    2023-04-19T12:48:28.638116  / # export SHELL=3D/bin/sh. /lava-10046047/=
environment

    2023-04-19T12:48:28.638284  =


    2023-04-19T12:48:28.739163  / # . /lava-10046047/environment/lava-10046=
047/bin/lava-test-runner /lava-10046047/1

    2023-04-19T12:48:28.739483  =


    2023-04-19T12:48:28.743926  / # /lava-10046047/bin/lava-test-runner /la=
va-10046047/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe33199af64f4742e8616

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe33199af64f4742e861b
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T12:48:39.545980  <8>[    8.402254] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10046039_1.4.2.3.1>

    2023-04-19T12:48:39.549131  + set +x

    2023-04-19T12:48:39.653875  / # #

    2023-04-19T12:48:39.754974  export SHELL=3D/bin/sh

    2023-04-19T12:48:39.755169  #

    2023-04-19T12:48:39.856090  / # export SHELL=3D/bin/sh. /lava-10046039/=
environment

    2023-04-19T12:48:39.856280  =


    2023-04-19T12:48:39.957201  / # . /lava-10046039/environment/lava-10046=
039/bin/lava-test-runner /lava-10046039/1

    2023-04-19T12:48:39.957565  =


    2023-04-19T12:48:39.962373  / # /lava-10046039/bin/lava-test-runner /la=
va-10046039/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe598cd73b22f8c2e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe598cd73b22f8c2e8=
5e7
        failing since 341 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe55cbd86ba98f32e85ec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe55cbd86ba98f32e85f1
        failing since 92 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-04-19T12:57:48.630768  + set +x<8>[    9.925010] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3512021_1.5.2.4.1>
    2023-04-19T12:57:48.630983  =

    2023-04-19T12:57:48.737329  / # #
    2023-04-19T12:57:48.838952  export SHELL=3D/bin/sh
    2023-04-19T12:57:48.839335  #
    2023-04-19T12:57:48.940509  / # export SHELL=3D/bin/sh. /lava-3512021/e=
nvironment
    2023-04-19T12:57:48.940946  =

    2023-04-19T12:57:49.042109  / # . /lava-3512021/environment/lava-351202=
1/bin/lava-test-runner /lava-3512021/1
    2023-04-19T12:57:49.042668  =

    2023-04-19T12:57:49.047793  / # /lava-3512021/bin/lava-test-runner /lav=
a-3512021/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe5ea39cd7422142e85fa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe5ea39cd7422142e85fd
        failing since 46 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-04-19T13:00:07.924008  [   14.942353] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1203453_1.5.2.4.1>
    2023-04-19T13:00:08.029580  / # #
    2023-04-19T13:00:08.131406  export SHELL=3D/bin/sh
    2023-04-19T13:00:08.131999  #
    2023-04-19T13:00:08.233385  / # export SHELL=3D/bin/sh. /lava-1203453/e=
nvironment
    2023-04-19T13:00:08.233825  =

    2023-04-19T13:00:08.335191  / # . /lava-1203453/environment/lava-120345=
3/bin/lava-test-runner /lava-1203453/1
    2023-04-19T13:00:08.335907  =

    2023-04-19T13:00:08.337825  / # /lava-1203453/bin/lava-test-runner /lav=
a-1203453/1
    2023-04-19T13:00:08.354020  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe355b07872edff2e8612

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe355b07872edff2e8617
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T12:49:09.818755  + set +x

    2023-04-19T12:49:09.825238  <8>[   10.073335] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10046066_1.4.2.3.1>

    2023-04-19T12:49:09.929980  / # #

    2023-04-19T12:49:10.031237  export SHELL=3D/bin/sh

    2023-04-19T12:49:10.031465  #

    2023-04-19T12:49:10.132406  / # export SHELL=3D/bin/sh. /lava-10046066/=
environment

    2023-04-19T12:49:10.132679  =


    2023-04-19T12:49:10.233642  / # . /lava-10046066/environment/lava-10046=
066/bin/lava-test-runner /lava-10046066/1

    2023-04-19T12:49:10.234000  =


    2023-04-19T12:49:10.238600  / # /lava-10046066/bin/lava-test-runner /la=
va-10046066/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe31c2d8bf2a8462e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe31c2d8bf2a8462e8606
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T12:48:11.906156  + set +x

    2023-04-19T12:48:11.912819  <8>[   10.358248] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10046022_1.4.2.3.1>

    2023-04-19T12:48:12.015111  =


    2023-04-19T12:48:12.115898  / # #export SHELL=3D/bin/sh

    2023-04-19T12:48:12.116109  =


    2023-04-19T12:48:12.217130  / # export SHELL=3D/bin/sh. /lava-10046022/=
environment

    2023-04-19T12:48:12.217334  =


    2023-04-19T12:48:12.318241  / # . /lava-10046022/environment/lava-10046=
022/bin/lava-test-runner /lava-10046022/1

    2023-04-19T12:48:12.318501  =


    2023-04-19T12:48:12.323731  / # /lava-10046022/bin/lava-test-runner /la=
va-10046022/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe33471889e4c4f2e863b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe33471889e4c4f2e8640
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T12:48:36.430101  + set<8>[   10.974203] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10046011_1.4.2.3.1>

    2023-04-19T12:48:36.430607   +x

    2023-04-19T12:48:36.538808  / # #

    2023-04-19T12:48:36.642213  export SHELL=3D/bin/sh

    2023-04-19T12:48:36.642862  #

    2023-04-19T12:48:36.744565  / # export SHELL=3D/bin/sh. /lava-10046011/=
environment

    2023-04-19T12:48:36.745268  =


    2023-04-19T12:48:36.847050  / # . /lava-10046011/environment/lava-10046=
011/bin/lava-test-runner /lava-10046011/1

    2023-04-19T12:48:36.848263  =


    2023-04-19T12:48:36.852485  / # /lava-10046011/bin/lava-test-runner /la=
va-10046011/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe5929a03966c962e89aa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe5929a03966c962e89af
        failing since 78 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first=
 fail: v5.15.90-205-g5605d15db022)

    2023-04-19T12:58:35.367953  + set +x
    2023-04-19T12:58:35.368129  [    9.385320] <LAVA_SIGNAL_ENDRUN 0_dmesg =
930853_1.5.2.3.1>
    2023-04-19T12:58:35.476076  / # #
    2023-04-19T12:58:35.577724  export SHELL=3D/bin/sh
    2023-04-19T12:58:35.578163  #
    2023-04-19T12:58:35.679379  / # export SHELL=3D/bin/sh. /lava-930853/en=
vironment
    2023-04-19T12:58:35.679794  =

    2023-04-19T12:58:35.781102  / # . /lava-930853/environment/lava-930853/=
bin/lava-test-runner /lava-930853/1
    2023-04-19T12:58:35.781819  =

    2023-04-19T12:58:35.784328  / # /lava-930853/bin/lava-test-runner /lava=
-930853/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe315c2d772465d2e8628

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe315c2d772465d2e862d
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T12:48:09.118861  + set +x<8>[   12.466363] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10046072_1.4.2.3.1>

    2023-04-19T12:48:09.118952  =


    2023-04-19T12:48:09.224210  / # #

    2023-04-19T12:48:09.325404  export SHELL=3D/bin/sh

    2023-04-19T12:48:09.325654  #

    2023-04-19T12:48:09.426643  / # export SHELL=3D/bin/sh. /lava-10046072/=
environment

    2023-04-19T12:48:09.426894  =


    2023-04-19T12:48:09.527883  / # . /lava-10046072/environment/lava-10046=
072/bin/lava-test-runner /lava-10046072/1

    2023-04-19T12:48:09.528236  =


    2023-04-19T12:48:09.532785  / # /lava-10046072/bin/lava-test-runner /la=
va-10046072/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12b-odroid-n2         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe63ad49260d2f92e8a49

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-276-gd757a2e2b115/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe63ad49260d2f92e8a4e
        new failure (last pass: v5.15.105-277-g6405847d6038a)

    2023-04-19T13:01:32.021020  / # #
    2023-04-19T13:01:32.123804  export SHELL=3D/bin/sh
    2023-04-19T13:01:32.124328  #
    2023-04-19T13:01:32.225911  / # export SHELL=3D/bin/sh. /lava-3512007/e=
nvironment
    2023-04-19T13:01:32.226647  =

    2023-04-19T13:01:32.328079  / # . /lava-3512007/environment/lava-351200=
7/bin/lava-test-runner /lava-3512007/1
    2023-04-19T13:01:32.329290  =

    2023-04-19T13:01:32.333360  / # /lava-3512007/bin/lava-test-runner /lav=
a-3512007/1
    2023-04-19T13:01:32.375194  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-19T13:01:32.394146  + cd /lava-3512007/1/tests/1_bootrr =

    ... (13 line(s) more)  =

 =20
