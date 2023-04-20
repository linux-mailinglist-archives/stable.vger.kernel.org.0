Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEF46E9A87
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 19:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjDTRUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 13:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjDTRUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 13:20:11 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B972C469A
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 10:19:36 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a667067275so12021615ad.1
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 10:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682011176; x=1684603176;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Gp6PboUWm7Kt/0lD59JHOnZocZ0rVESxggJKfUexoNo=;
        b=Jgbv+rDueHrLbx6j70+ou96Qbpa48HZTDGG06tjsw5zzZ8iWGaP9gzzshbVhPXaLWc
         4zHFA5l55FftxngBIEq81npn8/hLLHJ1w/NZvrsSZ//SRO2rMvB3sSeB8c7oSXZYmOHw
         A8BQCWgpxrQu15NtCZD91rHnz6Ma116FWkpo4s2yI5nAZL89+ydFygbOAElVrsHvtduc
         RC8ri9qDxytFpxooy6mmb1+B5dBZkpPXkEMMCpiZfUqFShWsgHd4IStEqz/pWM1o5494
         ANW5ajAQK+vyPx6vEQAkiiJSubbl2nHZ0jb5QVITTWC9z8SGZ5D6tI1bk8wC091L3+XC
         g15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682011176; x=1684603176;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gp6PboUWm7Kt/0lD59JHOnZocZ0rVESxggJKfUexoNo=;
        b=IKvIrAH+AMQuXbGAhBHmn6BxQy6XVsJmsVHqoGtMJn4nENode6ZDBYUYVVCTjOkeSL
         hD8b8B8ciu+6Ihm80HfIV32w4cd8jejmosKnRglCsraNt3VUKZVMfKqIvqPjBT+qvsOc
         kqKt13fa4gukhZ/j0nclIoKn1B9gufOThWA1Cl2ZtJG16UsCnOvBxaKqiWW7j+4PJbDT
         GrDglULY0ZMgoV2r0iJOo9hUTQmDsX9/YBhyv6d7mEM8HqqMMvo6X+R4VN2KcKYGHyQQ
         ejMTfHV8urtdKCTqGvQ3JjRSc1KTV7m6ZBySlnIceoa7Y12iCxxZO5hiGvP5kRmsYA0Y
         4IHA==
X-Gm-Message-State: AAQBX9fkB2KxTlcn1NTUZsXMPNEA6CwUcWqHXrJ+p4wA5ZxY5DHqW5tY
        YInSLitm6aoZqmgLUvq4SJYNtXpDczmdtdVDkBbULPI2
X-Google-Smtp-Source: AKy350aWyLxf5eKQRYK34pwFJXNyc7wvERWfrdZLCjnWICIN1BversysnDwt02OaTfzGZ+C0F88O8w==
X-Received: by 2002:a17:902:f543:b0:19c:da68:337a with SMTP id h3-20020a170902f54300b0019cda68337amr2528733plf.31.1682011175354;
        Thu, 20 Apr 2023 10:19:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jk13-20020a170903330d00b001a6f0e81ec9sm1413300plb.95.2023.04.20.10.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 10:19:34 -0700 (PDT)
Message-ID: <64417426.170a0220.3f5cd.3283@mx.google.com>
Date:   Thu, 20 Apr 2023 10:19:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.108
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 184 runs, 20 regressions (v5.15.108)
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

stable/linux-5.15.y baseline: 184 runs, 20 regressions (v5.15.108)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
am57xx-beagle-x15            | arm    | lab-linaro-lkft | gcc-10   | multi_=
v7_defconfig+kselftest | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

fsl-lx2160a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.108/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.108
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3299fb36854fdc288bddc2c4d265f8a2e5105944 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
am57xx-beagle-x15            | arm    | lab-linaro-lkft | gcc-10   | multi_=
v7_defconfig+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64413b0032699824142e866a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig+kselftest
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/multi_v7_defconfig+kselftest/gcc-10/lab-linaro-lkft/baseline-am57xx-bea=
gle-x15.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/multi_v7_defconfig+kselftest/gcc-10/lab-linaro-lkft/baseline-am57xx-bea=
gle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64413b0032699824142e8=
66b
        new failure (last pass: v5.15.107) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64413a160d1db6a63d2e85fe

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413a160d1db6a63d2e8603
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:11:39.846021  <8>[    9.228332] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061710_1.4.2.3.1>

    2023-04-20T13:11:39.848956  + set +x

    2023-04-20T13:11:39.950989  =


    2023-04-20T13:11:40.051891  / # #export SHELL=3D/bin/sh

    2023-04-20T13:11:40.052074  =


    2023-04-20T13:11:40.153017  / # export SHELL=3D/bin/sh. /lava-10061710/=
environment

    2023-04-20T13:11:40.153236  =


    2023-04-20T13:11:40.254211  / # . /lava-10061710/environment/lava-10061=
710/bin/lava-test-runner /lava-10061710/1

    2023-04-20T13:11:40.254490  =


    2023-04-20T13:11:40.301681  / # /lava-10061710/bin/lava-test-runner /la=
va-10061710/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64413d9963b0cf95a82e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413d9963b0cf95a82e85ec
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:26:25.176385  + set +x

    2023-04-20T13:26:25.182858  <8>[   10.200943] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061855_1.4.2.3.1>

    2023-04-20T13:26:25.287552  / # #

    2023-04-20T13:26:25.388739  export SHELL=3D/bin/sh

    2023-04-20T13:26:25.388935  #

    2023-04-20T13:26:25.489806  / # export SHELL=3D/bin/sh. /lava-10061855/=
environment

    2023-04-20T13:26:25.490058  =


    2023-04-20T13:26:25.590977  / # . /lava-10061855/environment/lava-10061=
855/bin/lava-test-runner /lava-10061855/1

    2023-04-20T13:26:25.591323  =


    2023-04-20T13:26:25.595765  / # /lava-10061855/bin/lava-test-runner /la=
va-10061855/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64413a33bcc90796c92e862b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413a33bcc90796c92e8630
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:11:54.385691  + <8>[   12.144048] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10061706_1.4.2.3.1>

    2023-04-20T13:11:54.385779  set +x

    2023-04-20T13:11:54.490871  / # #

    2023-04-20T13:11:54.592005  export SHELL=3D/bin/sh

    2023-04-20T13:11:54.592250  #

    2023-04-20T13:11:54.693292  / # export SHELL=3D/bin/sh. /lava-10061706/=
environment

    2023-04-20T13:11:54.693550  =


    2023-04-20T13:11:54.794748  / # . /lava-10061706/environment/lava-10061=
706/bin/lava-test-runner /lava-10061706/1

    2023-04-20T13:11:54.795508  =


    2023-04-20T13:11:54.800928  / # /lava-10061706/bin/lava-test-runner /la=
va-10061706/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64413da147c2d9344f2e8603

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413da147c2d9344f2e8608
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:26:36.504228  + set<8>[   11.043062] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10061853_1.4.2.3.1>

    2023-04-20T13:26:36.504313   +x

    2023-04-20T13:26:36.609633  / # #

    2023-04-20T13:26:36.710589  export SHELL=3D/bin/sh

    2023-04-20T13:26:36.710766  #

    2023-04-20T13:26:36.811689  / # export SHELL=3D/bin/sh. /lava-10061853/=
environment

    2023-04-20T13:26:36.811851  =


    2023-04-20T13:26:36.912777  / # . /lava-10061853/environment/lava-10061=
853/bin/lava-test-runner /lava-10061853/1

    2023-04-20T13:26:36.913015  =


    2023-04-20T13:26:36.917791  / # /lava-10061853/bin/lava-test-runner /la=
va-10061853/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64413a31bcc90796c92e8620

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413a31bcc90796c92e8625
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:11:53.756415  <8>[   11.250184] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061680_1.4.2.3.1>

    2023-04-20T13:11:53.759921  + set +x

    2023-04-20T13:11:53.863304  #

    2023-04-20T13:11:53.864480  =


    2023-04-20T13:11:53.966841  / # #export SHELL=3D/bin/sh

    2023-04-20T13:11:53.967362  =


    2023-04-20T13:11:54.068882  / # export SHELL=3D/bin/sh. /lava-10061680/=
environment

    2023-04-20T13:11:54.069807  =


    2023-04-20T13:11:54.171868  / # . /lava-10061680/environment/lava-10061=
680/bin/lava-test-runner /lava-10061680/1

    2023-04-20T13:11:54.172349  =

 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64413d999e29c9b62c2e860f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413d999e29c9b62c2e8614
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:26:26.657032  <8>[   10.139800] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061810_1.4.2.3.1>

    2023-04-20T13:26:26.660360  + set +x

    2023-04-20T13:26:26.766155  =


    2023-04-20T13:26:26.868140  / # #export SHELL=3D/bin/sh

    2023-04-20T13:26:26.868933  =


    2023-04-20T13:26:26.970931  / # export SHELL=3D/bin/sh. /lava-10061810/=
environment

    2023-04-20T13:26:26.971817  =


    2023-04-20T13:26:27.073946  / # . /lava-10061810/environment/lava-10061=
810/bin/lava-test-runner /lava-10061810/1

    2023-04-20T13:26:27.075239  =


    2023-04-20T13:26:27.081003  / # /lava-10061810/bin/lava-test-runner /la=
va-10061810/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64413faa3d6572d9ef2e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64413faa3d6572d9ef2e8=
5e7
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64413d434b712af6d72e863c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413d434b712af6d72e8641
        failing since 91 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-04-20T13:25:14.397354  <8>[    9.953031] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3516315_1.5.2.4.1>
    2023-04-20T13:25:14.507548  / # #
    2023-04-20T13:25:14.611122  export SHELL=3D/bin/sh
    2023-04-20T13:25:14.611876  #
    2023-04-20T13:25:14.713849  / # export SHELL=3D/bin/sh. /lava-3516315/e=
nvironment
    2023-04-20T13:25:14.714828  =

    2023-04-20T13:25:14.817044  / # . /lava-3516315/environment/lava-351631=
5/bin/lava-test-runner /lava-3516315/1
    2023-04-20T13:25:14.818501  =

    2023-04-20T13:25:14.823146  / # /lava-3516315/bin/lava-test-runner /lav=
a-3516315/1
    2023-04-20T13:25:14.912892  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64413bff96719643b42e8634

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413bff96719643b42e8639
        failing since 48 days (last pass: v5.15.79, first fail: v5.15.97)

    2023-04-20T13:19:27.157021  [   10.786604] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1204630_1.5.2.4.1>
    2023-04-20T13:19:27.261512  / # #
    2023-04-20T13:19:27.362971  export SHELL=3D/bin/sh
    2023-04-20T13:19:27.363603  #
    2023-04-20T13:19:27.464951  / # export SHELL=3D/bin/sh. /lava-1204630/e=
nvironment
    2023-04-20T13:19:27.465322  =

    2023-04-20T13:19:27.566474  / # . /lava-1204630/environment/lava-120463=
0/bin/lava-test-runner /lava-1204630/1
    2023-04-20T13:19:27.567147  =

    2023-04-20T13:19:27.568833  / # /lava-1204630/bin/lava-test-runner /lav=
a-1204630/1
    2023-04-20T13:19:27.585383  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64413a240d1db6a63d2e8615

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413a240d1db6a63d2e861a
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:11:56.763031  + set +x

    2023-04-20T13:11:56.769578  <8>[   12.568159] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061714_1.4.2.3.1>

    2023-04-20T13:11:56.874172  / # #

    2023-04-20T13:11:56.975171  export SHELL=3D/bin/sh

    2023-04-20T13:11:56.975330  #

    2023-04-20T13:11:57.076240  / # export SHELL=3D/bin/sh. /lava-10061714/=
environment

    2023-04-20T13:11:57.076446  =


    2023-04-20T13:11:57.177282  / # . /lava-10061714/environment/lava-10061=
714/bin/lava-test-runner /lava-10061714/1

    2023-04-20T13:11:57.177608  =


    2023-04-20T13:11:57.182463  / # /lava-10061714/bin/lava-test-runner /la=
va-10061714/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64413d9b668523b5ea2e865e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413d9b668523b5ea2e8663
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:26:29.060296  + set +x

    2023-04-20T13:26:29.066857  <8>[   10.604679] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061862_1.4.2.3.1>

    2023-04-20T13:26:29.171804  / # #

    2023-04-20T13:26:29.272945  export SHELL=3D/bin/sh

    2023-04-20T13:26:29.273179  #

    2023-04-20T13:26:29.374126  / # export SHELL=3D/bin/sh. /lava-10061862/=
environment

    2023-04-20T13:26:29.374360  =


    2023-04-20T13:26:29.475327  / # . /lava-10061862/environment/lava-10061=
862/bin/lava-test-runner /lava-10061862/1

    2023-04-20T13:26:29.475678  =


    2023-04-20T13:26:29.479723  / # /lava-10061862/bin/lava-test-runner /la=
va-10061862/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64413a100d1db6a63d2e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413a100d1db6a63d2e85f0
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:11:36.610832  + <8>[   11.616275] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10061712_1.4.2.3.1>

    2023-04-20T13:11:36.610908  set +x

    2023-04-20T13:11:36.713644  =


    2023-04-20T13:11:36.815685  / # #export SHELL=3D/bin/sh

    2023-04-20T13:11:36.816427  =


    2023-04-20T13:11:36.918141  / # export SHELL=3D/bin/sh. /lava-10061712/=
environment

    2023-04-20T13:11:36.918841  =


    2023-04-20T13:11:37.020431  / # . /lava-10061712/environment/lava-10061=
712/bin/lava-test-runner /lava-10061712/1

    2023-04-20T13:11:37.020702  =


    2023-04-20T13:11:37.025754  / # /lava-10061712/bin/lava-test-runner /la=
va-10061712/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64413d7dbf3ee7eb362e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413d7dbf3ee7eb362e860d
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:26:06.436390  + set +x<8>[   10.651994] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10061846_1.4.2.3.1>

    2023-04-20T13:26:06.436482  =


    2023-04-20T13:26:06.538508  #

    2023-04-20T13:26:06.639709  / # #export SHELL=3D/bin/sh

    2023-04-20T13:26:06.639904  =


    2023-04-20T13:26:06.740836  / # export SHELL=3D/bin/sh. /lava-10061846/=
environment

    2023-04-20T13:26:06.741034  =


    2023-04-20T13:26:06.841945  / # . /lava-10061846/environment/lava-10061=
846/bin/lava-test-runner /lava-10061846/1

    2023-04-20T13:26:06.842219  =


    2023-04-20T13:26:06.847223  / # /lava-10061846/bin/lava-test-runner /la=
va-10061846/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64413a2ba143c7a7d92e85f5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413a2ba143c7a7d92e85fa
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:11:45.601451  + <8>[   12.075383] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10061722_1.4.2.3.1>

    2023-04-20T13:11:45.602019  set +x

    2023-04-20T13:11:45.709901  / # #

    2023-04-20T13:11:45.812905  export SHELL=3D/bin/sh

    2023-04-20T13:11:45.813622  #

    2023-04-20T13:11:45.915253  / # export SHELL=3D/bin/sh. /lava-10061722/=
environment

    2023-04-20T13:11:45.916034  =


    2023-04-20T13:11:46.018214  / # . /lava-10061722/environment/lava-10061=
722/bin/lava-test-runner /lava-10061722/1

    2023-04-20T13:11:46.019582  =


    2023-04-20T13:11:46.024482  / # /lava-10061722/bin/lava-test-runner /la=
va-10061722/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64413d9a47c2d9344f2e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413d9a47c2d9344f2e85ed
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:26:25.134007  + set<8>[   10.584491] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10061818_1.4.2.3.1>

    2023-04-20T13:26:25.134594   +x

    2023-04-20T13:26:25.242937  / # #

    2023-04-20T13:26:25.345969  export SHELL=3D/bin/sh

    2023-04-20T13:26:25.346811  #

    2023-04-20T13:26:25.449083  / # export SHELL=3D/bin/sh. /lava-10061818/=
environment

    2023-04-20T13:26:25.449932  =


    2023-04-20T13:26:25.552106  / # . /lava-10061818/environment/lava-10061=
818/bin/lava-test-runner /lava-10061818/1

    2023-04-20T13:26:25.553362  =


    2023-04-20T13:26:25.559033  / # /lava-10061818/bin/lava-test-runner /la=
va-10061818/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64413bf396719643b42e8608

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413bf396719643b42e860d
        failing since 78 days (last pass: v5.15.81, first fail: v5.15.91)

    2023-04-20T13:19:38.042538  + set +x
    2023-04-20T13:19:38.042773  [    9.333883] <LAVA_SIGNAL_ENDRUN 0_dmesg =
932271_1.5.2.3.1>
    2023-04-20T13:19:38.151029  / # #
    2023-04-20T13:19:38.253077  export SHELL=3D/bin/sh
    2023-04-20T13:19:38.253678  #
    2023-04-20T13:19:38.354998  / # export SHELL=3D/bin/sh. /lava-932271/en=
vironment
    2023-04-20T13:19:38.355567  =

    2023-04-20T13:19:38.457004  / # . /lava-932271/environment/lava-932271/=
bin/lava-test-runner /lava-932271/1
    2023-04-20T13:19:38.457703  =

    2023-04-20T13:19:38.460513  / # /lava-932271/bin/lava-test-runner /lava=
-932271/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64413d1fcc8bb1880f2e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64413d1fcc8bb1880f2e8=
5e7
        new failure (last pass: v5.15.107) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64413a14bce2f153452e85ff

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413a14bce2f153452e8604
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:11:22.481911  <8>[   12.548277] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061689_1.4.2.3.1>

    2023-04-20T13:11:22.586443  / # #

    2023-04-20T13:11:22.687355  export SHELL=3D/bin/sh

    2023-04-20T13:11:22.687560  #

    2023-04-20T13:11:22.788417  / # export SHELL=3D/bin/sh. /lava-10061689/=
environment

    2023-04-20T13:11:22.788647  =


    2023-04-20T13:11:22.889617  / # . /lava-10061689/environment/lava-10061=
689/bin/lava-test-runner /lava-10061689/1

    2023-04-20T13:11:22.890023  =


    2023-04-20T13:11:22.895144  / # /lava-10061689/bin/lava-test-runner /la=
va-10061689/1

    2023-04-20T13:11:22.906567  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64413d97668523b5ea2e863c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64413d97668523b5ea2e8641
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T13:26:26.126561  + set<8>[   11.774328] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10061817_1.4.2.3.1>

    2023-04-20T13:26:26.126685   +x

    2023-04-20T13:26:26.231466  / # #

    2023-04-20T13:26:26.332374  export SHELL=3D/bin/sh

    2023-04-20T13:26:26.332557  #

    2023-04-20T13:26:26.433460  / # export SHELL=3D/bin/sh. /lava-10061817/=
environment

    2023-04-20T13:26:26.433688  =


    2023-04-20T13:26:26.534644  / # . /lava-10061817/environment/lava-10061=
817/bin/lava-test-runner /lava-10061817/1

    2023-04-20T13:26:26.534995  =


    2023-04-20T13:26:26.539590  / # /lava-10061817/bin/lava-test-runner /la=
va-10061817/1
 =

    ... (12 line(s) more)  =

 =20
