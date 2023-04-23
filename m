Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A186EC1BB
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 21:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjDWTKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 15:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDWTKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 15:10:30 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08BD10D9
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 12:10:27 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b4e5fdb1eso4715186b3a.1
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 12:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682277027; x=1684869027;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NJlHTGQ4ip52+Ebwde0A48wT40gFqac4UQRc2jnRplE=;
        b=wE58+EQHNPbqbGfg27nOd+dCJ4FOvuRSRxXjcTAXWf5OwuVKYhHFdlaRMOfCyhVBBw
         5vB3QWeDY/LL49QU5CK6JH1T+Au3PUKNpjMm3t9sZgakd5TfxmIILlgiAV6CJ9bRvZzk
         nEzY+oR9VCeYQwCJyFMbgv58rrjCzi+Qg100z6s/207ifl5rSJyVDRufoQCqpifm1IWi
         V+TWV04gkvzCgktiBCX1ZBlcvoi8c+ZKeN7GvAKvnrigRZ5HDS5S1cSqXZgtqhnEuSBm
         syUuXV1fnFORBG4crznHeUcYRd31K8gC3k8/raVsQRyb9XQ5/JNEiMrbGuA7xO6FtUoM
         CEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682277027; x=1684869027;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJlHTGQ4ip52+Ebwde0A48wT40gFqac4UQRc2jnRplE=;
        b=U/ooi8BXT7cQU3J9TkZOczFGgN2qRHDCa2GtTHeeBGKJhkP7DiIBALh41ItP+9Y0RH
         PMsUi2Z8LbyKKZnq6nc2/NCVWMfLF1ZCisG6RzRMHubkANmGVF2Pb1sIpfTSTPeZDAB0
         hhm5HRZd74TqQRioGpyOcfUt7HGobyq7Ma0O+SejvzHkF13zGL8cgm9TcLylW+vDQOyG
         jfxHWroIQyEEVVJTUu6MJzD3VUgSghFlLp4/7iTAH+EN1JLN2D4VznVmCUay0oUwBZAF
         gvaftcLGKiRme55+DyOorIgWagyRPgSvCtR0uKec9Hn5WLOQzyhNVfnA16lc+6Iq9F5E
         nsRw==
X-Gm-Message-State: AAQBX9c5sO2MHMOP43fgsjFmYNli9sNJZvtHfNHt91Psm3bUcOegmEZH
        Pcre0vEGRjydoQdhm9tkzdPoFaBcKY7VZkR2SsmvUg==
X-Google-Smtp-Source: AKy350bMsTMXUI1DFUvv0YTWb/O2+TKEHmx4cwKPZZmkQVqit9v9eOByhm06P5Irc9G5GWu9IuRwYw==
X-Received: by 2002:a05:6a21:999b:b0:f2:b01b:af93 with SMTP id ve27-20020a056a21999b00b000f2b01baf93mr9805116pzb.27.1682277026924;
        Sun, 23 Apr 2023 12:10:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 125-20020a630283000000b005038291e5cbsm5348369pgc.35.2023.04.23.12.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 12:10:26 -0700 (PDT)
Message-ID: <644582a2.630a0220.5b53e.a5d3@mx.google.com>
Date:   Sun, 23 Apr 2023 12:10:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-564-g3588497f7ea83
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 140 runs,
 12 regressions (v6.1.22-564-g3588497f7ea83)
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

stable-rc/queue/6.1 baseline: 140 runs, 12 regressions (v6.1.22-564-g358849=
7f7ea83)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-564-g3588497f7ea83/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-564-g3588497f7ea83
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3588497f7ea83910183dcd1df4fc8acdfc68c871 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454dde1cc5a980242e85ea

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454dde1cc5a980242e85ef
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T15:24:54.006967  <8>[    8.012404] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10093948_1.4.2.3.1>

    2023-04-23T15:24:54.010322  + set +x

    2023-04-23T15:24:54.118469  / # #

    2023-04-23T15:24:54.220955  export SHELL=3D/bin/sh

    2023-04-23T15:24:54.221195  #

    2023-04-23T15:24:54.322223  / # export SHELL=3D/bin/sh. /lava-10093948/=
environment

    2023-04-23T15:24:54.322432  =


    2023-04-23T15:24:54.423402  / # . /lava-10093948/environment/lava-10093=
948/bin/lava-test-runner /lava-10093948/1

    2023-04-23T15:24:54.424929  =


    2023-04-23T15:24:54.430507  / # /lava-10093948/bin/lava-test-runner /la=
va-10093948/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454dd13bdcedfcff2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454dd13bdcedfcff2e85eb
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T15:24:44.788278  + set<8>[   11.203152] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10093947_1.4.2.3.1>

    2023-04-23T15:24:44.788388   +x

    2023-04-23T15:24:44.893493  / # #

    2023-04-23T15:24:44.994655  export SHELL=3D/bin/sh

    2023-04-23T15:24:44.994860  #

    2023-04-23T15:24:45.095742  / # export SHELL=3D/bin/sh. /lava-10093947/=
environment

    2023-04-23T15:24:45.095984  =


    2023-04-23T15:24:45.196951  / # . /lava-10093947/environment/lava-10093=
947/bin/lava-test-runner /lava-10093947/1

    2023-04-23T15:24:45.197229  =


    2023-04-23T15:24:45.201493  / # /lava-10093947/bin/lava-test-runner /la=
va-10093947/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454dd34d15d988492e8677

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454dd34d15d988492e867c
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T15:24:41.439173  <8>[    9.897116] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10093938_1.4.2.3.1>

    2023-04-23T15:24:41.442593  + set +x

    2023-04-23T15:24:41.548094  =


    2023-04-23T15:24:41.649751  / # #export SHELL=3D/bin/sh

    2023-04-23T15:24:41.650714  =


    2023-04-23T15:24:41.753008  / # export SHELL=3D/bin/sh. /lava-10093938/=
environment

    2023-04-23T15:24:41.753716  =


    2023-04-23T15:24:41.855438  / # . /lava-10093938/environment/lava-10093=
938/bin/lava-test-runner /lava-10093938/1

    2023-04-23T15:24:41.856618  =


    2023-04-23T15:24:41.862154  / # /lava-10093938/bin/lava-test-runner /la=
va-10093938/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/64454f6bc5d5d083822e864f

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454f6bc5d5d083822e8681
        failing since 0 day (last pass: v6.1.22-556-g2944ac9cf90bf, first f=
ail: v6.1.22-556-g51522a0e29940)

    2023-04-23T15:31:33.792390  + set +x
    2023-04-23T15:31:33.796309  <8>[   16.463915] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 374447_1.5.2.4.1>
    2023-04-23T15:31:33.911981  / # #
    2023-04-23T15:31:34.013949  export SHELL=3D/bin/sh
    2023-04-23T15:31:34.014461  #
    2023-04-23T15:31:34.115877  / # export SHELL=3D/bin/sh. /lava-374447/en=
vironment
    2023-04-23T15:31:34.116190  =

    2023-04-23T15:31:34.217812  / # . /lava-374447/environment/lava-374447/=
bin/lava-test-runner /lava-374447/1
    2023-04-23T15:31:34.218643  =

    2023-04-23T15:31:34.225340  / # /lava-374447/bin/lava-test-runner /lava=
-374447/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/644551c049e2cdf2872e865a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644551c049e2cdf2872e8=
65b
        failing since 3 days (last pass: v6.1.22-477-g2128d4458cbc, first f=
ail: v6.1.22-474-gecc61872327e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454ec117133ec65e2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454ec117133ec65e2e85eb
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T15:28:46.966867  + set +x

    2023-04-23T15:28:46.973272  <8>[    8.120266] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10093962_1.4.2.3.1>

    2023-04-23T15:28:47.081736  / # #

    2023-04-23T15:28:47.182715  export SHELL=3D/bin/sh

    2023-04-23T15:28:47.183035  #

    2023-04-23T15:28:47.284055  / # export SHELL=3D/bin/sh. /lava-10093962/=
environment

    2023-04-23T15:28:47.284269  =


    2023-04-23T15:28:47.385225  / # . /lava-10093962/environment/lava-10093=
962/bin/lava-test-runner /lava-10093962/1

    2023-04-23T15:28:47.385514  =


    2023-04-23T15:28:47.390080  / # /lava-10093962/bin/lava-test-runner /la=
va-10093962/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454dc30c6de6409f2e8613

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454dc30c6de6409f2e8618
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T15:24:36.642993  + set +x

    2023-04-23T15:24:36.649906  <8>[   10.503921] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10093969_1.4.2.3.1>

    2023-04-23T15:24:36.752503  =


    2023-04-23T15:24:36.853489  / # #export SHELL=3D/bin/sh

    2023-04-23T15:24:36.853713  =


    2023-04-23T15:24:36.954674  / # export SHELL=3D/bin/sh. /lava-10093969/=
environment

    2023-04-23T15:24:36.954883  =


    2023-04-23T15:24:37.055865  / # . /lava-10093969/environment/lava-10093=
969/bin/lava-test-runner /lava-10093969/1

    2023-04-23T15:24:37.056198  =


    2023-04-23T15:24:37.060972  / # /lava-10093969/bin/lava-test-runner /la=
va-10093969/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454ddd3db1f48cff2e8607

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454dde3db1f48cff2e860c
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T15:25:02.909981  + <8>[   11.547710] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10093977_1.4.2.3.1>

    2023-04-23T15:25:02.910085  set +x

    2023-04-23T15:25:03.015092  / # #

    2023-04-23T15:25:03.116146  export SHELL=3D/bin/sh

    2023-04-23T15:25:03.116355  #

    2023-04-23T15:25:03.217277  / # export SHELL=3D/bin/sh. /lava-10093977/=
environment

    2023-04-23T15:25:03.217490  =


    2023-04-23T15:25:03.318588  / # . /lava-10093977/environment/lava-10093=
977/bin/lava-test-runner /lava-10093977/1

    2023-04-23T15:25:03.320141  =


    2023-04-23T15:25:03.325108  / # /lava-10093977/bin/lava-test-runner /la=
va-10093977/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =


  Details:     https://kernelci.org/test/plan/id/644551a888cc9c14112e86b4

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644551a888cc9c14112e86b7
        new failure (last pass: v6.1.22-560-gc4a6f990f6a64)

    2023-04-23T15:41:17.827078  / # #
    2023-04-23T15:41:17.929677  export SHELL=3D/bin/sh
    2023-04-23T15:41:17.930489  #
    2023-04-23T15:41:18.032186  / # export SHELL=3D/bin/sh. /lava-324825/en=
vironment
    2023-04-23T15:41:18.032851  =

    2023-04-23T15:41:18.134658  / # . /lava-324825/environment/lava-324825/=
bin/lava-test-runner /lava-324825/1
    2023-04-23T15:41:18.135666  =

    2023-04-23T15:41:18.154377  / # /lava-324825/bin/lava-test-runner /lava=
-324825/1
    2023-04-23T15:41:18.170481  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-23T15:41:18.204337  + cd /l<8>[   14.476621] <LAVA_SIGNAL_START=
RUN 1_bootrr 324825_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/644=
551a888cc9c14112e86c7
        new failure (last pass: v6.1.22-560-gc4a6f990f6a64)

    2023-04-23T15:41:20.560388  /lava-324825/1/../bin/lava-test-case
    2023-04-23T15:41:20.560873  <8>[   16.925447] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-04-23T15:41:20.561308  /lava-324825/1/../bin/lava-test-case   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454dcb0f5c00ecd82e85fc

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454dcb0f5c00ecd82e8601
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T15:24:43.445345  <8>[    8.847063] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10093985_1.4.2.3.1>

    2023-04-23T15:24:43.550549  / # #

    2023-04-23T15:24:43.651599  export SHELL=3D/bin/sh

    2023-04-23T15:24:43.651841  #

    2023-04-23T15:24:43.752769  / # export SHELL=3D/bin/sh. /lava-10093985/=
environment

    2023-04-23T15:24:43.753013  =


    2023-04-23T15:24:43.854045  / # . /lava-10093985/environment/lava-10093=
985/bin/lava-test-runner /lava-10093985/1

    2023-04-23T15:24:43.854356  =


    2023-04-23T15:24:43.859251  / # /lava-10093985/bin/lava-test-runner /la=
va-10093985/1

    2023-04-23T15:24:43.865761  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64454e64798ddf46ec2e85f5

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
4-g3588497f7ea83/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64454e64798ddf4=
6ec2e85fd
        new failure (last pass: v6.1.22-560-gc4a6f990f6a64)
        1 lines

    2023-04-23T15:27:09.723975  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address de471c5c, epc =3D=3D 80202234, ra =3D=
=3D 80204b84
    2023-04-23T15:27:09.724192  =


    2023-04-23T15:27:09.754241  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-23T15:27:09.754482  =

   =

 =20
