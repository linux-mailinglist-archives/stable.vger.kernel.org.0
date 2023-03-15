Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C826BBAC6
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 18:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjCORXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 13:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjCORXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 13:23:54 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467F71448D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 10:23:51 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id h12so3288853pfh.5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 10:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678901030;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=y90d19NXgf4J+oPn13jYO2ffzWnOjFe86xd+Ep5sbXw=;
        b=IKR/r/3KtikNj3xwSx1qcoT40QHU4wazW/sRnP1VHDiyiT9b/UPtWaeZFtZiRy9+/Y
         mnsenOPKmIfspDuUMy8GctgnrNirTdtOb5HSB8ryqhTUQhWC4BYdAdyaJaBnwtzzQQA9
         +j+OgNg+PnCoaBIxcevHnnmAVmKvkLG1IsUWygvPTyKz8WS7V79bo5F1Jf8d5DW15kHe
         5U6fjVH/rYkWGfKJkxg/NBEZZIV22gKraBko/Y78LnsN9Xc8NwUVOsFZdk0A4Ve3Ed2X
         9BW5WKPGupxIgmfTklqP0sq38OqFJcefpkBuj6FT5E+Q92muPTii6lSzkasprDQ33S13
         2EMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678901030;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y90d19NXgf4J+oPn13jYO2ffzWnOjFe86xd+Ep5sbXw=;
        b=nDq/tIruqOlTrn8lMOZTQNKIqYaCrsQMf3EqHKfoZ9bVbTDq8xVvpLx54vCvQo9lyc
         tZfXpCQ2Uuq0Es0zvbPOPHSWtF6tAGnkD0ZA4Z81wUFmyaBSYVyMi/NMZAtFAk0ooWB/
         N0frmLgfP4wQPfa1+VHU3Ci1S91xF3p+WB7KjP3UpbRDakuR3DAwmJ4yXlQdnvKJHSlh
         YvgMixnjw5olj+bEfjDeoGlbt1JIJscUNKKh5qzx3GjElTL3LU4AiXeQWpwzME3HLjLL
         ubMEmIz1ffWrHS/ULO0aVIRlR+Hfcs6doTB42I4S7vh9YXG9gKz9rlYHl/r6ry1JhW6J
         toIA==
X-Gm-Message-State: AO0yUKWRvv2PfxmC5HcuFYd4u0VRQxwOIV+HMTq+gwbcrQFHPK056r06
        I0N/1b9jnjtUP37hF6uSR6GfTuJj85a/TBQ2XaQdCn7o
X-Google-Smtp-Source: AK7set/ZuSwI3rHcc8ex5yb8n8MGvAkOzH/6VcgoGR2oa0Rwi1bwwyQGBhzXAi55l8TFwowx7iEAZQ==
X-Received: by 2002:aa7:9513:0:b0:5a8:b2bf:26ac with SMTP id b19-20020aa79513000000b005a8b2bf26acmr261348pfp.20.1678901030257;
        Wed, 15 Mar 2023 10:23:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 23-20020aa79217000000b005e0699464e3sm3753585pfo.206.2023.03.15.10.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:23:49 -0700 (PDT)
Message-ID: <6411ff25.a70a0220.bd15b.8629@mx.google.com>
Date:   Wed, 15 Mar 2023 10:23:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-108-ge3263528613b4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 159 runs,
 11 regressions (v5.10.173-108-ge3263528613b4)
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

stable-rc/queue/5.10 baseline: 159 runs, 11 regressions (v5.10.173-108-ge32=
63528613b4)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.173-108-ge3263528613b4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.173-108-ge3263528613b4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3263528613b4ecea8c6091c0c9e8d84dea6e05a =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411ca5edefbfd588a8c8656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411ca5edefbfd588a8c8=
657
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411ca5cdefbfd588a8c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411ca5cdefbfd588a8c8=
651
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411ca57c4f5917a988c865d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411ca57c4f5917a988c8=
65e
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6411c715ce40f71a098c8658

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411c715ce40f71a098c8691
        failing since 29 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-15T13:24:17.911096  <8>[   20.483187] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 167215_1.5.2.4.1>
    2023-03-15T13:24:18.019428  / # #
    2023-03-15T13:24:18.122790  export SHELL=3D/bin/sh
    2023-03-15T13:24:18.123530  #
    2023-03-15T13:24:18.225997  / # export SHELL=3D/bin/sh. /lava-167215/en=
vironment
    2023-03-15T13:24:18.226745  =

    2023-03-15T13:24:18.329234  / # . /lava-167215/environment/lava-167215/=
bin/lava-test-runner /lava-167215/1
    2023-03-15T13:24:18.330439  =

    2023-03-15T13:24:18.334352  / # /lava-167215/bin/lava-test-runner /lava=
-167215/1
    2023-03-15T13:24:18.438773  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6411c8b3dbab7fc0ec8c8711

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411c8b3dbab7fc0ec8c871a
        failing since 48 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-15T13:31:10.385138  <8>[   11.046411] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3413959_1.5.2.4.1>
    2023-03-15T13:31:10.499449  / # #
    2023-03-15T13:31:10.603202  export SHELL=3D/bin/sh
    2023-03-15T13:31:10.604362  #
    2023-03-15T13:31:10.706791  / # export SHELL=3D/bin/sh. /lava-3413959/e=
nvironment
    2023-03-15T13:31:10.707968  =

    2023-03-15T13:31:10.810365  / # . /lava-3413959/environment/lava-341395=
9/bin/lava-test-runner /lava-3413959/1
    2023-03-15T13:31:10.812167  =

    2023-03-15T13:31:10.812652  / # /lava-3413959/bin/lava-test-runner /lav=
a-3413959/1<3>[   11.451157] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-15T13:31:10.816690   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411ca5bc4f5917a988c8665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411ca5bc4f5917a988c8=
666
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411ca56defbfd588a8c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411ca56defbfd588a8c8=
637
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411cb876d20dd4e0b8c8689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411cb876d20dd4e0b8c8=
68a
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6411c8606ba886c8808c8799

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6411c8606ba886c8808c87ea
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T13:29:49.240220  /lava-9631525/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6411c8606ba886c8808c87eb
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T13:29:47.177285  <8>[   60.069924] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-15T13:29:48.203006  /lava-9631525/1/../bin/lava-test-case

    2023-03-15T13:29:48.214300  <8>[   61.108804] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6411c7b4b6800bb8f38c8665

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-108-ge3263528613b4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411c7b4b6800bb8f38c866e
        failing since 41 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-15T13:26:51.936165  / # #
    2023-03-15T13:26:52.038069  export SHELL=3D/bin/sh
    2023-03-15T13:26:52.038611  #
    2023-03-15T13:26:52.140000  / # export SHELL=3D/bin/sh. /lava-3413952/e=
nvironment
    2023-03-15T13:26:52.140633  =

    2023-03-15T13:26:52.242239  / # . /lava-3413952/environment/lava-341395=
2/bin/lava-test-runner /lava-3413952/1
    2023-03-15T13:26:52.243044  =

    2023-03-15T13:26:52.247052  / # /lava-3413952/bin/lava-test-runner /lav=
a-3413952/1
    2023-03-15T13:26:52.311251  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-15T13:26:52.358930  + cd /lava-3413952/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
