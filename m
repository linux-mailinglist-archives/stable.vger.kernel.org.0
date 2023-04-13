Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDB46E0996
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 11:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjDMJC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 05:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjDMJCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 05:02:38 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE536E8D
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 02:02:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id pm7-20020a17090b3c4700b00246f00dace2so6662458pjb.2
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 02:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681376538; x=1683968538;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Yk54PM3u8NPGC6RxYWn3DWPwXGfKEmqTYUxTJKR3QEc=;
        b=qSBThe+S04EiztGfrCPGIFjvnyAETkzYlVi/87aXt55HdwphqtHPV1cuG0WFMc2tkb
         F9/VguyxnWItGBT2A0rUI2GxtLlwHjyrFeUoFrrZNTTcwZACllnImDhCbO6jRJqw7hXq
         12ty0mfdEigHy4wVNdAGKF6e44MVl5u3IWQgFc2AtQS3COBskTABzn7sUQ9/fvGYLVm2
         4ZWYCTFgSs89JhLtHOhZdhf+0o5CxNOqdTGeK4YE6bSzwv9tscdWSZOJq+m/s83twtR4
         qVOw0qVzM65xuaryobTtYo8yohdWbTcwl0Yguz2T+Qx9zCMPq44N2MRNYw/qDHz8vjx5
         Rc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681376538; x=1683968538;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yk54PM3u8NPGC6RxYWn3DWPwXGfKEmqTYUxTJKR3QEc=;
        b=NNKxGQFhcFhMM6n5nJLylYbCq9mGZj0OjAZaOiOlpvfCNB0+GzdCKkvcmX8mZKOe2M
         SBzXy4njB60h1s3dF+ifB5bOV+Pm88QlKVXZiYdxP6cVYeSLdIkg71JyYvHHHbf2L0+F
         Duca4LrITU8MsrGhGDTkYHogUeSmvIYOp+z6UIRuYOnqOGLmI1+Wxg9EYoCYTbRhY9tZ
         tnLxiOktc6H6cmukexMIPGvyMZXxXRsuPVweO/HKj7iGNW9NQXn1YDTYBDQYOcJ3Euyn
         byQ2IG2fYqkNJTG8cE6aTaoIu66Lpx4ydakYu2zb1aMMwz2039gp58WUr9/+FYuWLHxr
         lhnA==
X-Gm-Message-State: AAQBX9dflTQxKK1MdjbJfWw20raos5RkThGhI3grOnwxa5oXJYeYFb4T
        A6zl3NYlpyZ/IMDs5cKgg9ZM5trg3YwgIW8Por615OUq
X-Google-Smtp-Source: AKy350aQkMraWrK6TFR7X5CgRQXvvTRnwbfMkdYXtgjbjgzQHVuIz1or/SbTBFQn1f1n33Ak4HwaWg==
X-Received: by 2002:a17:903:230f:b0:1a0:7584:f468 with SMTP id d15-20020a170903230f00b001a07584f468mr1711089plh.0.1681376537749;
        Thu, 13 Apr 2023 02:02:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5-20020a1709027e8500b001a6527f6ad7sm989725pla.85.2023.04.13.02.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 02:02:17 -0700 (PDT)
Message-ID: <6437c519.170a0220.9ffe7.1e72@mx.google.com>
Date:   Thu, 13 Apr 2023 02:02:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-225-gbe2c0b5d8969
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 183 runs,
 7 regressions (v5.10.176-225-gbe2c0b5d8969)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 183 runs, 7 regressions (v5.10.176-225-gbe2c=
0b5d8969)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-225-gbe2c0b5d8969/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-225-gbe2c0b5d8969
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be2c0b5d896971720a99c6efc6b3f7303a0c66c9 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6437926dbb0a5a802e2e8602

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6437926dbb0a5a802e2e8630
        failing since 58 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-13T05:25:29.620911  <8>[   19.998510] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 321842_1.5.2.4.1>
    2023-04-13T05:25:29.787792  / # #
    2023-04-13T05:25:29.912393  export SHELL=3D/bin/sh
    2023-04-13T05:25:29.921459  #
    2023-04-13T05:25:30.034040  / # export SHELL=3D/bin/sh. /lava-321842/en=
vironment
    2023-04-13T05:25:30.041796  =

    2023-04-13T05:25:30.154179  / # . /lava-321842/environment/lava-321842/=
bin/lava-test-runner /lava-321842/1
    2023-04-13T05:25:30.165086  =

    2023-04-13T05:25:30.168793  / # /lava-321842/bin/lava-test-runner /lava=
-321842/1
    2023-04-13T05:25:30.262731  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6437938e465c5f132a2e8680

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6437938e465c5f132a2e8685
        failing since 76 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-13T05:30:18.095864  <8>[   11.109637] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3491502_1.5.2.4.1>
    2023-04-13T05:30:18.205887  / # #
    2023-04-13T05:30:18.308800  export SHELL=3D/bin/sh
    2023-04-13T05:30:18.309677  #
    2023-04-13T05:30:18.411637  / # export SHELL=3D/bin/sh. /lava-3491502/e=
nvironment
    2023-04-13T05:30:18.412480  =

    2023-04-13T05:30:18.514378  / # . /lava-3491502/environment/lava-349150=
2/bin/lava-test-runner /lava-3491502/1
    2023-04-13T05:30:18.515956  =

    2023-04-13T05:30:18.520839  / # /lava-3491502/bin/lava-test-runner /lav=
a-3491502/1
    2023-04-13T05:30:18.598976  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378f8e521721e8842e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378f8e521721e8842e85f0
        failing since 13 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-13T05:13:37.745297  + set +x

    2023-04-13T05:13:37.752012  <8>[   14.167937] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9957813_1.4.2.3.1>

    2023-04-13T05:13:37.856133  / # #

    2023-04-13T05:13:37.957217  export SHELL=3D/bin/sh

    2023-04-13T05:13:37.957429  #

    2023-04-13T05:13:38.058362  / # export SHELL=3D/bin/sh. /lava-9957813/e=
nvironment

    2023-04-13T05:13:38.058554  =


    2023-04-13T05:13:38.159583  / # . /lava-9957813/environment/lava-995781=
3/bin/lava-test-runner /lava-9957813/1

    2023-04-13T05:13:38.159931  =


    2023-04-13T05:13:38.164163  / # /lava-9957813/bin/lava-test-runner /lav=
a-9957813/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64378ea198d57877392e862a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64378ea198d57877392e862f
        failing since 13 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-13T05:09:36.519873  <8>[   11.693426] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9957830_1.4.2.3.1>

    2023-04-13T05:09:36.522987  + set +x

    2023-04-13T05:09:36.627778  / # #

    2023-04-13T05:09:36.728980  export SHELL=3D/bin/sh

    2023-04-13T05:09:36.729229  #

    2023-04-13T05:09:36.830194  / # export SHELL=3D/bin/sh. /lava-9957830/e=
nvironment

    2023-04-13T05:09:36.830455  =


    2023-04-13T05:09:36.931445  / # . /lava-9957830/environment/lava-995783=
0/bin/lava-test-runner /lava-9957830/1

    2023-04-13T05:09:36.931787  =


    2023-04-13T05:09:36.937125  / # /lava-9957830/bin/lava-test-runner /lav=
a-9957830/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643795083e473979792e8647

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643795083e473979792e864d
        failing since 30 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-13T05:36:55.992613  /lava-9958133/1/../bin/lava-test-case

    2023-04-13T05:36:56.003218  <8>[   34.827336] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643795083e473979792e864e
        failing since 30 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-13T05:36:54.956206  /lava-9958133/1/../bin/lava-test-case

    2023-04-13T05:36:54.967715  <8>[   33.791686] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643792cae868c715d62e8635

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gbe2c0b5d8969/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643792cae868c715d62e8638
        failing since 70 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-13T05:27:22.895498  / # #
    2023-04-13T05:27:22.998003  export SHELL=3D/bin/sh
    2023-04-13T05:27:22.998611  #
    2023-04-13T05:27:23.100070  / # export SHELL=3D/bin/sh. /lava-3491501/e=
nvironment
    2023-04-13T05:27:23.100607  =

    2023-04-13T05:27:23.202029  / # . /lava-3491501/environment/lava-349150=
1/bin/lava-test-runner /lava-3491501/1
    2023-04-13T05:27:23.202809  =

    2023-04-13T05:27:23.221010  / # /lava-3491501/bin/lava-test-runner /lav=
a-3491501/1
    2023-04-13T05:27:23.308918  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-13T05:27:23.309480  + cd /lava-3491501/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
