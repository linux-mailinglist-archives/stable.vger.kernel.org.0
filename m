Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8BD6EC2D5
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 00:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjDWWAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 18:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDWWAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 18:00:53 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759DEF0
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 15:00:50 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b60365f53so4988452b3a.0
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 15:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682287250; x=1684879250;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1UEsXbJiUzrm8arSDGT50A/nz2Sh3yTZtvAaxjDQUPI=;
        b=Thf/cXWNrTph2/R8qCYgaDNerIBUTci7v234SHnVJenmuqBDbGer4H2q1XwYM9fa27
         4wpMrDrrOYR8SJt08vksAdr5hp1bAvoXy1Zdo0elMN4GaEDssFBktlMxM++6ywCfLGSj
         CsZddLfwiGw7IKHIWCwsS9FbNCcVDOsjAHiqvCo/jSJg4d4SkRHfVQlFqYo49fl0veK3
         XEsYEl5s1PQoIqYCb3P6qOKqMYL7huT1scKXFtHPvr5dwIkWKWVopU+Tx2bxgLSOx/VK
         Jt2opGxNL5RXrMVzADYXJc5WAJhHO10I2OiR3sVWqnuZqWEfH3NdD50i/z5Q75eTFPLI
         ExzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682287250; x=1684879250;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1UEsXbJiUzrm8arSDGT50A/nz2Sh3yTZtvAaxjDQUPI=;
        b=N+tcivZXfiRp9NeR+B88LBhz7ilPFPd/WrIx7/sxJ0eL/NCWHHyxXXkrfZz21Rn190
         7D9xhjKu6ql+aYEjv2mkKIHfRwePs/wtZkGFYQrDg1W0Z2hnJfAhOjfkctnSVv8E6/br
         kHDtwkrShX7VFGxxuSXkPKnZDVOQHU3wDToueX1lYSBbSeqKCzXJilF5WMzZRno7Pynu
         BemF4I7d9XRaoKYFHN9JiqUhoS4tQCSK7mGorx6kFSKHlCScRj3rl7SXkUi0Q0qO+GkG
         UVusVTybEfNOZUs+exYAULBcYIL5K7zb+185WDcnLL96VetVBMTmwbIvZFOlkxNax1PU
         wKfg==
X-Gm-Message-State: AAQBX9elcgYG+HQev63rBHzCnea26vZtSKGdNZqz6Gw+oYTCYeUQWcn1
        SWkvLT0qzagUhiCzXoE5/OjR61m+szF/nueqLcwvUg==
X-Google-Smtp-Source: AKy350YPMKVFrxjiUHAxapEvSRUil2BWMbzTTOagWjENpW5QPiNoHMYZkSYOd8JL37+HkfrpaDpGmQ==
X-Received: by 2002:a05:6a00:1788:b0:63d:3f74:9df7 with SMTP id s8-20020a056a00178800b0063d3f749df7mr16559077pfg.34.1682287249119;
        Sun, 23 Apr 2023 15:00:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i134-20020a62878c000000b006328ee1e56csm6076252pfe.2.2023.04.23.15.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 15:00:48 -0700 (PDT)
Message-ID: <6445aa90.620a0220.1947b.bd32@mx.google.com>
Date:   Sun, 23 Apr 2023 15:00:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-336-g844f562dee962
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 135 runs,
 10 regressions (v5.15.105-336-g844f562dee962)
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

stable-rc/linux-5.15.y baseline: 135 runs, 10 regressions (v5.15.105-336-g8=
44f562dee962)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105-336-g844f562dee962/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105-336-g844f562dee962
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      844f562dee96257f442a9a18e52410742623d72f =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445748300911e2f242e862f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445748300911e2f242e8634
        failing since 25 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-23T18:09:53.112486  <8>[   10.966521] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10095703_1.4.2.3.1>

    2023-04-23T18:09:53.115541  + set +x

    2023-04-23T18:09:53.219603  / # #

    2023-04-23T18:09:53.320683  export SHELL=3D/bin/sh

    2023-04-23T18:09:53.320881  #

    2023-04-23T18:09:53.421805  / # export SHELL=3D/bin/sh. /lava-10095703/=
environment

    2023-04-23T18:09:53.421975  =


    2023-04-23T18:09:53.522848  / # . /lava-10095703/environment/lava-10095=
703/bin/lava-test-runner /lava-10095703/1

    2023-04-23T18:09:53.523110  =


    2023-04-23T18:09:53.528512  / # /lava-10095703/bin/lava-test-runner /la=
va-10095703/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445748307da6a21222e863f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445748307da6a21222e8644
        failing since 25 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-23T18:10:02.810044  + <8>[   11.292248] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10095702_1.4.2.3.1>

    2023-04-23T18:10:02.810651  set +x

    2023-04-23T18:10:02.918833  / # #

    2023-04-23T18:10:03.021586  export SHELL=3D/bin/sh

    2023-04-23T18:10:03.022390  #

    2023-04-23T18:10:03.124324  / # export SHELL=3D/bin/sh. /lava-10095702/=
environment

    2023-04-23T18:10:03.125150  =


    2023-04-23T18:10:03.227274  / # . /lava-10095702/environment/lava-10095=
702/bin/lava-test-runner /lava-10095702/1

    2023-04-23T18:10:03.228518  =


    2023-04-23T18:10:03.233655  / # /lava-10095702/bin/lava-test-runner /la=
va-10095702/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445747607da6a21222e8613

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445747607da6a21222e8618
        failing since 25 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-23T18:09:49.933202  <8>[   11.418216] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10095677_1.4.2.3.1>

    2023-04-23T18:09:49.936469  + set +x

    2023-04-23T18:09:50.038366  =


    2023-04-23T18:09:50.139376  / # #export SHELL=3D/bin/sh

    2023-04-23T18:09:50.139555  =


    2023-04-23T18:09:50.240461  / # export SHELL=3D/bin/sh. /lava-10095677/=
environment

    2023-04-23T18:09:50.240641  =


    2023-04-23T18:09:50.341631  / # . /lava-10095677/environment/lava-10095=
677/bin/lava-test-runner /lava-10095677/1

    2023-04-23T18:09:50.341893  =


    2023-04-23T18:09:50.346734  / # /lava-10095677/bin/lava-test-runner /la=
va-10095677/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6445793d03f9b0ba8d2e8612

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6445793d03f9b0ba8d2e8=
613
        failing since 346 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6445775bd4d0799ed02e85e6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445775bd4d0799ed02e85eb
        failing since 96 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-04-23T18:21:56.997336  <8>[    9.834721] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3525237_1.5.2.4.1>
    2023-04-23T18:21:57.108159  / # #
    2023-04-23T18:21:57.210649  export SHELL=3D/bin/sh
    2023-04-23T18:21:57.211574  #
    2023-04-23T18:21:57.313833  / # export SHELL=3D/bin/sh. /lava-3525237/e=
nvironment
    2023-04-23T18:21:57.314800  =

    2023-04-23T18:21:57.417033  / # . /lava-3525237/environment/lava-352523=
7/bin/lava-test-runner /lava-3525237/1
    2023-04-23T18:21:57.418385  =

    2023-04-23T18:21:57.423220  / # /lava-3525237/bin/lava-test-runner /lav=
a-3525237/1
    2023-04-23T18:21:57.513660  <3>[   10.352620] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445746d073c0bcb812e863a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445746d073c0bcb812e863f
        failing since 25 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-23T18:09:39.648948  + <8>[   10.308673] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10095686_1.4.2.3.1>

    2023-04-23T18:09:39.649413  set +x

    2023-04-23T18:09:39.755959  #

    2023-04-23T18:09:39.757089  =


    2023-04-23T18:09:39.859536  / # #export SHELL=3D/bin/sh

    2023-04-23T18:09:39.860285  =


    2023-04-23T18:09:39.962051  / # export SHELL=3D/bin/sh. /lava-10095686/=
environment

    2023-04-23T18:09:39.962829  =


    2023-04-23T18:09:40.064843  / # . /lava-10095686/environment/lava-10095=
686/bin/lava-test-runner /lava-10095686/1

    2023-04-23T18:09:40.065982  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64457468073c0bcb812e860b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64457468073c0bcb812e8610
        failing since 25 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-23T18:09:36.051014  + set +x

    2023-04-23T18:09:36.057663  <8>[   13.358284] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10095691_1.4.2.3.1>

    2023-04-23T18:09:36.162428  / # #

    2023-04-23T18:09:36.263540  export SHELL=3D/bin/sh

    2023-04-23T18:09:36.263754  #

    2023-04-23T18:09:36.364685  / # export SHELL=3D/bin/sh. /lava-10095691/=
environment

    2023-04-23T18:09:36.364903  =


    2023-04-23T18:09:36.465815  / # . /lava-10095691/environment/lava-10095=
691/bin/lava-test-runner /lava-10095691/1

    2023-04-23T18:09:36.466167  =


    2023-04-23T18:09:36.470651  / # /lava-10095691/bin/lava-test-runner /la=
va-10095691/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445747100911e2f242e85f3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445747100911e2f242e85f8
        failing since 25 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-23T18:09:46.666234  + set<8>[   11.401510] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10095721_1.4.2.3.1>

    2023-04-23T18:09:46.666346   +x

    2023-04-23T18:09:46.770971  / # #

    2023-04-23T18:09:46.872072  export SHELL=3D/bin/sh

    2023-04-23T18:09:46.872248  #

    2023-04-23T18:09:46.973139  / # export SHELL=3D/bin/sh. /lava-10095721/=
environment

    2023-04-23T18:09:46.973298  =


    2023-04-23T18:09:47.074239  / # . /lava-10095721/environment/lava-10095=
721/bin/lava-test-runner /lava-10095721/1

    2023-04-23T18:09:47.074548  =


    2023-04-23T18:09:47.078691  / # /lava-10095721/bin/lava-test-runner /la=
va-10095721/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644576fc26add7a29e2e85e9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644576fc26add7a29e2e85ee
        failing since 83 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first=
 fail: v5.15.90-205-g5605d15db022)

    2023-04-23T18:20:37.118012  + set +x
    2023-04-23T18:20:37.118192  [    9.409092] <LAVA_SIGNAL_ENDRUN 0_dmesg =
935028_1.5.2.3.1>
    2023-04-23T18:20:37.225012  / # #
    2023-04-23T18:20:37.327235  export SHELL=3D/bin/sh
    2023-04-23T18:20:37.327808  #
    2023-04-23T18:20:37.429270  / # export SHELL=3D/bin/sh. /lava-935028/en=
vironment
    2023-04-23T18:20:37.429855  =

    2023-04-23T18:20:37.531401  / # . /lava-935028/environment/lava-935028/=
bin/lava-test-runner /lava-935028/1
    2023-04-23T18:20:37.532178  =

    2023-04-23T18:20:37.534617  / # /lava-935028/bin/lava-test-runner /lava=
-935028/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445748100911e2f242e8610

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-336-g844f562dee962/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445748100911e2f242e8615
        failing since 25 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-23T18:09:49.117887  + set<8>[   11.883325] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10095687_1.4.2.3.1>

    2023-04-23T18:09:49.117970   +x

    2023-04-23T18:09:49.222661  / # #

    2023-04-23T18:09:49.323661  export SHELL=3D/bin/sh

    2023-04-23T18:09:49.323822  #

    2023-04-23T18:09:49.424799  / # export SHELL=3D/bin/sh. /lava-10095687/=
environment

    2023-04-23T18:09:49.424967  =


    2023-04-23T18:09:49.526227  / # . /lava-10095687/environment/lava-10095=
687/bin/lava-test-runner /lava-10095687/1

    2023-04-23T18:09:49.526480  =


    2023-04-23T18:09:49.531011  / # /lava-10095687/bin/lava-test-runner /la=
va-10095687/1
 =

    ... (12 line(s) more)  =

 =20
