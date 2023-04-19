Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED326E8221
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 21:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjDSTt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 15:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjDSTtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 15:49:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DCB5FD5
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 12:49:47 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a52667955dso4004195ad.1
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 12:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681933787; x=1684525787;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ju6ths5CRODCyq5wmfmZmql5ofJtL9dmV4LNxa/pnT0=;
        b=YxaqFAUFJSuKvCvk7EFr85o6yiqLyK6NTQU7H8kaSZgZ78W3KWbA7PRubq0INbZrko
         K79yvSle4IVbykc7mq/Fn7YY6kJe8dt5WQ/1Qg0gvVzlnuY61OOJcrEWsbZ76qb/4e3p
         PdEGkbpXgqURLbJPWtWDxbMafU8+gg+RzN7dTYjttX6sOjWbyDCLqhDgAUhCbbxonrXU
         qym4Byrn3Plpwo7Sk+AVJNTKSSIAXBCRex/ko91HwQQa5IMiMp/WuqaikcjE4evrHQNC
         sM/6zuEFD0psDHQFxBQcYu0wnCXKZ60Gj3Je7+IVZiAdB/6bc2S2Vtj8SBDTIKByVDo+
         pOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681933787; x=1684525787;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ju6ths5CRODCyq5wmfmZmql5ofJtL9dmV4LNxa/pnT0=;
        b=bQf3kcotCUFGPZ1ieNE+eQQAyGMT41Wmdd2cMumUzjcRwm6pd/Oij/OwQ07wkdhvXt
         E1USqGStdjRUI9mNMYJf/yK5DmsrXFtvHodxUx2vG/shMELxmRkz69dAXVYZQhpmXxPT
         nByRHvNaCLjARTwTKZcJzfSCk9wU/2hvnXSpkC6c0WTiBjaKDfgr1yUbzfJq30Vxhpig
         4JUezi11MTzKkW0w1uh83TOsGprP03ZAyLHa7KPLanjzkwJHCrVFawxrUF/foo/4gS+z
         n3iPEfM00yFU8WjvNrFh1zsZBsGXcqbxNW04+sFKHKXe09gKYDg29OznmIj8xqK+IQ5I
         8cEg==
X-Gm-Message-State: AAQBX9e7PZpeSGaFuzsPgQFHeKPVumgzBCpO5at5N2zh+oO/JfY8uRDE
        M2i3EMB5HaijjFzjgBlwMmWehjq6QsYpny3L/jGkhJ4E
X-Google-Smtp-Source: AKy350ZiGHCjLGzscYMVAqsI3Jy1r0EGxteaQa+YuAnoEA6gxMi36EN259mAbgKKpW9ETIDfkFFh7A==
X-Received: by 2002:a17:903:24c:b0:1a6:ce48:5700 with SMTP id j12-20020a170903024c00b001a6ce485700mr7314710plh.33.1681933786941;
        Wed, 19 Apr 2023 12:49:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jw19-20020a170903279300b0019f3cc463absm11843123plb.0.2023.04.19.12.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 12:49:46 -0700 (PDT)
Message-ID: <644045da.170a0220.5ca0e.b938@mx.google.com>
Date:   Wed, 19 Apr 2023 12:49:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-273-gdf26c2ac7edab
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 174 runs,
 11 regressions (v5.15.105-273-gdf26c2ac7edab)
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

stable-rc/linux-5.15.y baseline: 174 runs, 11 regressions (v5.15.105-273-gd=
f26c2ac7edab)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105-273-gdf26c2ac7edab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105-273-gdf26c2ac7edab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df26c2ac7edab467aaa49544362100c86ab2759d =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6440128f26023860b12e8627

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6440128f26023860b12e862c
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T16:10:37.027091  + set +x

    2023-04-19T16:10:37.033490  <8>[   10.415839] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10049844_1.4.2.3.1>

    2023-04-19T16:10:37.141416  / # #

    2023-04-19T16:10:37.243812  export SHELL=3D/bin/sh

    2023-04-19T16:10:37.243980  #

    2023-04-19T16:10:37.345023  / # export SHELL=3D/bin/sh. /lava-10049844/=
environment

    2023-04-19T16:10:37.345858  =


    2023-04-19T16:10:37.447656  / # . /lava-10049844/environment/lava-10049=
844/bin/lava-test-runner /lava-10049844/1

    2023-04-19T16:10:37.448891  =


    2023-04-19T16:10:37.454067  / # /lava-10049844/bin/lava-test-runner /la=
va-10049844/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6440128e7febcd7fc02e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6440128e7febcd7fc02e85ed
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T16:10:33.550714  + set<8>[   11.717533] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10049828_1.4.2.3.1>

    2023-04-19T16:10:33.550793   +x

    2023-04-19T16:10:33.655138  / # #

    2023-04-19T16:10:33.756234  export SHELL=3D/bin/sh

    2023-04-19T16:10:33.756393  #

    2023-04-19T16:10:33.857286  / # export SHELL=3D/bin/sh. /lava-10049828/=
environment

    2023-04-19T16:10:33.857437  =


    2023-04-19T16:10:33.958310  / # . /lava-10049828/environment/lava-10049=
828/bin/lava-test-runner /lava-10049828/1

    2023-04-19T16:10:33.958601  =


    2023-04-19T16:10:33.963257  / # /lava-10049828/bin/lava-test-runner /la=
va-10049828/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6440128f26023860b12e861a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6440128f26023860b12e861f
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T16:10:30.730793  <8>[   10.433661] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10049843_1.4.2.3.1>

    2023-04-19T16:10:30.731260  + set +x

    2023-04-19T16:10:30.839189  / # #

    2023-04-19T16:10:30.941902  export SHELL=3D/bin/sh

    2023-04-19T16:10:30.942700  #

    2023-04-19T16:10:31.044589  / # export SHELL=3D/bin/sh. /lava-10049843/=
environment

    2023-04-19T16:10:31.045324  =


    2023-04-19T16:10:31.147390  / # . /lava-10049843/environment/lava-10049=
843/bin/lava-test-runner /lava-10049843/1

    2023-04-19T16:10:31.148595  =


    2023-04-19T16:10:31.153723  / # /lava-10049843/bin/lava-test-runner /la=
va-10049843/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/644013b2113b5d1d6d2e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644013b2113b5d1d6d2e8=
5e7
        failing since 342 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64401401c217c294c42e8604

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64401401c217c294c42e8609
        failing since 92 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-04-19T16:16:44.711014  <8>[    9.985700] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3512965_1.5.2.4.1>
    2023-04-19T16:16:44.822571  / # #
    2023-04-19T16:16:44.926432  export SHELL=3D/bin/sh
    2023-04-19T16:16:44.927501  <3>[   10.042791] Bluetooth: hci0: command =
0xfc18 tx timeout
    2023-04-19T16:16:44.928035  #
    2023-04-19T16:16:45.030277  / # export SHELL=3D/bin/sh. /lava-3512965/e=
nvironment
    2023-04-19T16:16:45.031427  =

    2023-04-19T16:16:45.133772  / # . /lava-3512965/environment/lava-351296=
5/bin/lava-test-runner /lava-3512965/1
    2023-04-19T16:16:45.134482  =

    2023-04-19T16:16:45.139174  / # /lava-3512965/bin/lava-test-runner /lav=
a-3512965/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6440151a87aee80d282e85fd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6440151a87aee80d282e8602
        failing since 46 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-04-19T16:21:17.364997  [   11.508062] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1203631_1.5.2.4.1>
    2023-04-19T16:21:17.470904  / # #
    2023-04-19T16:21:17.572932  export SHELL=3D/bin/sh
    2023-04-19T16:21:17.573547  #
    2023-04-19T16:21:17.674973  / # export SHELL=3D/bin/sh. /lava-1203631/e=
nvironment
    2023-04-19T16:21:17.675603  =

    2023-04-19T16:21:17.777238  / # . /lava-1203631/environment/lava-120363=
1/bin/lava-test-runner /lava-1203631/1
    2023-04-19T16:21:17.778640  =

    2023-04-19T16:21:17.780022  / # /lava-1203631/bin/lava-test-runner /lav=
a-1203631/1
    2023-04-19T16:21:17.797120  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6440127d26023860b12e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6440127d26023860b12e85eb
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T16:10:21.972138  + set +x

    2023-04-19T16:10:21.978522  <8>[    9.940738] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10049858_1.4.2.3.1>

    2023-04-19T16:10:22.083412  / # #

    2023-04-19T16:10:22.184419  export SHELL=3D/bin/sh

    2023-04-19T16:10:22.184616  #

    2023-04-19T16:10:22.285526  / # export SHELL=3D/bin/sh. /lava-10049858/=
environment

    2023-04-19T16:10:22.285740  =


    2023-04-19T16:10:22.386656  / # . /lava-10049858/environment/lava-10049=
858/bin/lava-test-runner /lava-10049858/1

    2023-04-19T16:10:22.387024  =


    2023-04-19T16:10:22.392075  / # /lava-10049858/bin/lava-test-runner /la=
va-10049858/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644012750155ad8eae2e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644012750155ad8eae2e8606
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T16:10:14.825179  <8>[   10.751913] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10049872_1.4.2.3.1>

    2023-04-19T16:10:14.828764  + set +x

    2023-04-19T16:10:14.933525  / # #

    2023-04-19T16:10:15.034633  export SHELL=3D/bin/sh

    2023-04-19T16:10:15.034847  #

    2023-04-19T16:10:15.135787  / # export SHELL=3D/bin/sh. /lava-10049872/=
environment

    2023-04-19T16:10:15.135975  =


    2023-04-19T16:10:15.236929  / # . /lava-10049872/environment/lava-10049=
872/bin/lava-test-runner /lava-10049872/1

    2023-04-19T16:10:15.237218  =


    2023-04-19T16:10:15.242337  / # /lava-10049872/bin/lava-test-runner /la=
va-10049872/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64401296076da88f4b2e8616

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64401296076da88f4b2e861b
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T16:10:37.678151  + set<8>[   10.661559] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10049859_1.4.2.3.1>

    2023-04-19T16:10:37.678641   +x

    2023-04-19T16:10:37.787512  / # #

    2023-04-19T16:10:37.890226  export SHELL=3D/bin/sh

    2023-04-19T16:10:37.891114  #

    2023-04-19T16:10:37.993004  / # export SHELL=3D/bin/sh. /lava-10049859/=
environment

    2023-04-19T16:10:37.993759  =


    2023-04-19T16:10:38.095700  / # . /lava-10049859/environment/lava-10049=
859/bin/lava-test-runner /lava-10049859/1

    2023-04-19T16:10:38.096857  =


    2023-04-19T16:10:38.101848  / # /lava-10049859/bin/lava-test-runner /la=
va-10049859/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6440130b3285ca35e92e85e7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6440130b3285ca35e92e85ec
        failing since 79 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first=
 fail: v5.15.90-205-g5605d15db022)

    2023-04-19T16:12:52.956862  + set +x
    2023-04-19T16:12:52.957060  [    9.372933] <LAVA_SIGNAL_ENDRUN 0_dmesg =
931088_1.5.2.3.1>
    2023-04-19T16:12:53.064497  / # #
    2023-04-19T16:12:53.166344  export SHELL=3D/bin/sh
    2023-04-19T16:12:53.166877  #
    2023-04-19T16:12:53.268138  / # export SHELL=3D/bin/sh. /lava-931088/en=
vironment
    2023-04-19T16:12:53.268577  =

    2023-04-19T16:12:53.369828  / # . /lava-931088/environment/lava-931088/=
bin/lava-test-runner /lava-931088/1
    2023-04-19T16:12:53.370476  =

    2023-04-19T16:12:53.373197  / # /lava-931088/bin/lava-test-runner /lava=
-931088/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6440127a1af42bc7c12e8606

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-273-gdf26c2ac7edab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6440127a1af42bc7c12e860b
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T16:10:20.550177  + set +x<8>[   11.147691] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10049835_1.4.2.3.1>

    2023-04-19T16:10:20.550261  =


    2023-04-19T16:10:20.655003  / # #

    2023-04-19T16:10:20.756011  export SHELL=3D/bin/sh

    2023-04-19T16:10:20.756186  #

    2023-04-19T16:10:20.857247  / # export SHELL=3D/bin/sh. /lava-10049835/=
environment

    2023-04-19T16:10:20.857458  =


    2023-04-19T16:10:20.958308  / # . /lava-10049835/environment/lava-10049=
835/bin/lava-test-runner /lava-10049835/1

    2023-04-19T16:10:20.958569  =


    2023-04-19T16:10:20.963343  / # /lava-10049835/bin/lava-test-runner /la=
va-10049835/1
 =

    ... (12 line(s) more)  =

 =20
