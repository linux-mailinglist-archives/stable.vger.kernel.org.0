Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2846E44B2
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 12:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjDQKDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 06:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjDQKDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 06:03:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695927DB6
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 03:02:01 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mq14-20020a17090b380e00b002472a2d9d6aso11020892pjb.5
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 03:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681725713; x=1684317713;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Jw69RLGeTrvRy8MQcyS1IrxEqCR5ZkiAaK3kR3VtyUQ=;
        b=25BTNOzD76aMRdjfpRWRP1B0wsvWhk8ga3DR/V9dvr4O02LItrP7L9W0HDrSNzrMvF
         EvFqYxaqDiir5ghw5CEyjMx8n6fb6J529PlgIK+fh9yZ13Z16N9WLowjRw8GFzbrRy6b
         Wm3XKHK26gDXZ6pUULZOJzEk9sI6Dfg4QojixkEOpHiJCnU28egLAugdXcPGA4b9zT/w
         rU+19yrgIMF32BsdoP8/pxVwqptGFn4RFQH4bRSDGkOwUtWV0PV5LaEgPclIzl3chSFy
         0swGDiN+fGmo1u9w74fktn4U/6YTo8TLcmSAqLn3ZrFDdQ9THIFlA0bvhLWrZUbH3o8x
         SFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681725713; x=1684317713;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jw69RLGeTrvRy8MQcyS1IrxEqCR5ZkiAaK3kR3VtyUQ=;
        b=bRKzkZmxFvCnoCD6iOjX15HDdADi+qx/ZSYA4wpFfOA2FW42uZpWi4/7kAfOKO7E75
         hWmZ5NhEDInuOMnM6VOYNWKgHCcT+Xoce5WoCnr3bVLIhMCD9AltSwtUJMl0c4gsbfg3
         q9yDfuhwKGjb+mDjPgH62NY7Op02FeaNupbglv1x3oDD14w+tQZ8EgvjB49q2ikQc+DF
         CbeFUaDTuh95yuUjOrkpMhrrNMatvowzTQIwSBn2qI22qUBSON+wPdq4wUNM0wrc2IEt
         0NYtm7jAq48otUOvu+w4BYnygMie1NRxjoHxYfA63nUx5JOnVDnXo01R8NFDGmsjBzma
         zKdA==
X-Gm-Message-State: AAQBX9eIo+pzN46+RCXxen261QgldW82SMpAHy7D1gB+qGtCDlO5EzcE
        yvYbkIYN2NI/My3P+CAGVufZvOORBMBRonRee2FjYJdV
X-Google-Smtp-Source: AKy350a68WBjyyQ2+mT8b3oYXAHo9egquHP/cAmyYWu8huiMSo4R8BXeOQGKv7g5BKac0YLmbVR7GA==
X-Received: by 2002:a05:6a20:8e08:b0:ee:c920:73dd with SMTP id y8-20020a056a208e0800b000eec92073ddmr10429432pzj.41.1681725713166;
        Mon, 17 Apr 2023 03:01:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9-20020a62b409000000b0062dd1c0cbe7sm7174170pfn.71.2023.04.17.03.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 03:01:52 -0700 (PDT)
Message-ID: <643d1910.620a0220.52e74.efa2@mx.google.com>
Date:   Mon, 17 Apr 2023 03:01:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-446-gccec7b96e5e7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 183 runs,
 8 regressions (v6.1.22-446-gccec7b96e5e7)
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

stable-rc/queue/6.1 baseline: 183 runs, 8 regressions (v6.1.22-446-gccec7b9=
6e5e7)

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

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-446-gccec7b96e5e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-446-gccec7b96e5e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ccec7b96e5e7035c213be6717ed97764d6cf4e56 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce24437f4a1e8eb2e8624

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce24437f4a1e8eb2e8629
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T06:07:43.831444  <8>[   10.482558] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10015214_1.4.2.3.1>

    2023-04-17T06:07:43.834882  + set +x

    2023-04-17T06:07:43.940985  #

    2023-04-17T06:07:43.942808  =


    2023-04-17T06:07:44.045869  / # #export SHELL=3D/bin/sh

    2023-04-17T06:07:44.046978  =


    2023-04-17T06:07:44.149071  / # export SHELL=3D/bin/sh. /lava-10015214/=
environment

    2023-04-17T06:07:44.149845  =


    2023-04-17T06:07:44.251731  / # . /lava-10015214/environment/lava-10015=
214/bin/lava-test-runner /lava-10015214/1

    2023-04-17T06:07:44.253551  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce24c5c9788c8932e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce24c5c9788c8932e85eb
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T06:07:49.899563  + set<8>[   11.042042] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10015231_1.4.2.3.1>

    2023-04-17T06:07:49.900037   +x

    2023-04-17T06:07:50.008486  / # #

    2023-04-17T06:07:50.111356  export SHELL=3D/bin/sh

    2023-04-17T06:07:50.112132  #

    2023-04-17T06:07:50.214296  / # export SHELL=3D/bin/sh. /lava-10015231/=
environment

    2023-04-17T06:07:50.215091  =


    2023-04-17T06:07:50.317295  / # . /lava-10015231/environment/lava-10015=
231/bin/lava-test-runner /lava-10015231/1

    2023-04-17T06:07:50.318633  =


    2023-04-17T06:07:50.323702  / # /lava-10015231/bin/lava-test-runner /la=
va-10015231/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce238f867d9da0a2e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce238f867d9da0a2e85ec
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T06:07:33.199245  <8>[    7.660696] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10015177_1.4.2.3.1>

    2023-04-17T06:07:33.202900  + set +x

    2023-04-17T06:07:33.309589  =


    2023-04-17T06:07:33.411644  / # #export SHELL=3D/bin/sh

    2023-04-17T06:07:33.412422  =


    2023-04-17T06:07:33.514250  / # export SHELL=3D/bin/sh. /lava-10015177/=
environment

    2023-04-17T06:07:33.514973  =


    2023-04-17T06:07:33.616761  / # . /lava-10015177/environment/lava-10015=
177/bin/lava-test-runner /lava-10015177/1

    2023-04-17T06:07:33.617863  =


    2023-04-17T06:07:33.622694  / # /lava-10015177/bin/lava-test-runner /la=
va-10015177/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce23cf867d9da0a2e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce23cf867d9da0a2e85f9
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T06:07:39.403198  + set +x

    2023-04-17T06:07:39.409858  <8>[   10.334433] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10015198_1.4.2.3.1>

    2023-04-17T06:07:39.514680  / # #

    2023-04-17T06:07:39.615688  export SHELL=3D/bin/sh

    2023-04-17T06:07:39.615890  #

    2023-04-17T06:07:39.716831  / # export SHELL=3D/bin/sh. /lava-10015198/=
environment

    2023-04-17T06:07:39.717009  =


    2023-04-17T06:07:39.817887  / # . /lava-10015198/environment/lava-10015=
198/bin/lava-test-runner /lava-10015198/1

    2023-04-17T06:07:39.818152  =


    2023-04-17T06:07:39.823023  / # /lava-10015198/bin/lava-test-runner /la=
va-10015198/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce22f690910e74d2e8600

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce22f690910e74d2e8605
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T06:07:26.647492  + set +x

    2023-04-17T06:07:26.653279  <8>[    9.880631] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10015192_1.4.2.3.1>

    2023-04-17T06:07:26.761767  / # #

    2023-04-17T06:07:26.864834  export SHELL=3D/bin/sh

    2023-04-17T06:07:26.865502  #

    2023-04-17T06:07:26.967216  / # export SHELL=3D/bin/sh. /lava-10015192/=
environment

    2023-04-17T06:07:26.967871  =


    2023-04-17T06:07:27.069702  / # . /lava-10015192/environment/lava-10015=
192/bin/lava-test-runner /lava-10015192/1

    2023-04-17T06:07:27.070766  =


    2023-04-17T06:07:27.076241  / # /lava-10015192/bin/lava-test-runner /la=
va-10015192/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce2334eda97b6ed2e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce2334eda97b6ed2e85ed
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T06:07:32.969548  + <8>[   11.055187] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10015185_1.4.2.3.1>

    2023-04-17T06:07:32.969632  set +x

    2023-04-17T06:07:33.073619  / # #

    2023-04-17T06:07:33.174565  export SHELL=3D/bin/sh

    2023-04-17T06:07:33.174715  #

    2023-04-17T06:07:33.275633  / # export SHELL=3D/bin/sh. /lava-10015185/=
environment

    2023-04-17T06:07:33.275792  =


    2023-04-17T06:07:33.376859  / # . /lava-10015185/environment/lava-10015=
185/bin/lava-test-runner /lava-10015185/1

    2023-04-17T06:07:33.377132  =


    2023-04-17T06:07:33.382299  / # /lava-10015185/bin/lava-test-runner /la=
va-10015185/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce2325bfd5fd0432e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce2325bfd5fd0432e85eb
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T06:07:29.560291  + set<8>[   12.156316] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10015220_1.4.2.3.1>

    2023-04-17T06:07:29.560375   +x

    2023-04-17T06:07:29.664453  / # #

    2023-04-17T06:07:29.765512  export SHELL=3D/bin/sh

    2023-04-17T06:07:29.765714  #

    2023-04-17T06:07:29.866725  / # export SHELL=3D/bin/sh. /lava-10015220/=
environment

    2023-04-17T06:07:29.867384  =


    2023-04-17T06:07:29.969198  / # . /lava-10015220/environment/lava-10015=
220/bin/lava-test-runner /lava-10015220/1

    2023-04-17T06:07:29.970252  =


    2023-04-17T06:07:29.975433  / # /lava-10015220/bin/lava-test-runner /la=
va-10015220/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce3558fadc7d0e42e85ed

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-44=
6-gccec7b96e5e7/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/643ce3558fadc7d=
0e42e85f5
        new failure (last pass: v6.1.22-438-gda4a613e2013)
        1 lines

    2023-04-17T06:12:16.867174  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 00000000, epc =3D=3D 00000000, ra =3D=
=3D 8023f81c
    2023-04-17T06:12:16.867434  =


    2023-04-17T06:12:16.926459  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-17T06:12:16.926683  =

   =

 =20
