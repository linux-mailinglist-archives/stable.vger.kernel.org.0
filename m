Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F56E6F6F
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 00:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjDRWir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 18:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDRWiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 18:38:46 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB84903E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 15:38:40 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a80d827179so6350445ad.3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 15:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681857520; x=1684449520;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FCjZOeLgLp/KQvHJ6d0pTnSOf+o5H81bpy8X2TD0NDY=;
        b=SqzF/k1QVEL1tU3Q0twM+mV8e6Ruh7sHACO0dV5OeVTwibDr/Q9XYRzi+N24jDBRTY
         im9D0Sf3zK25e4wbJHex7fzBZI6r+AQrTW0mSzq+YkxOpq5wv/8WmdPAVgiLp5CRIGmK
         TeWaiz69T06rren5plysS9+GXEytlJp1OFgJu6csz4Yb7h7GQrHztq1+sb+n70tbETjU
         hF/sHfnPwDKS4JomuheuMBpr1GtdpikwEu5eqwiajTulpUW3GwCcWM1QtxyNUULvg1kl
         JOq4K2FYlZDq296OHUiNeuA/hE1Rte627VnAZQTV1Ns+23YxcdtUiw5XAbkqLGhfQsRU
         kd4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681857520; x=1684449520;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FCjZOeLgLp/KQvHJ6d0pTnSOf+o5H81bpy8X2TD0NDY=;
        b=F1OvWVP7i68yEapAHYgPDCTleHjTgULKEPETNUmUAV+eCGzJOrOJuIDHPLvVagSA6m
         D8svttMlL9xLGdoh4Bt3VYlG06+SFVEfag7oz0W/MWvTcPPRTL9He93sMvOdXpXnbrYQ
         dagrzEOKHG3FTbBZw1Z3MSjxcD184CBBIf0fle1ejlDZDamL0KkeUq8CQGDV4IjKSzX4
         T80yMQ3jbPhNtnEFlcZD22sEugZk8dsOzCdjrEE8lEBlSWGpPzXUhng/HcHS4BsBGloZ
         GfknZkDuRrujUQk8HYzOWscQ7yl29F7HF43vlbgaB74PfwZ77DqPu1FK5Dfpu/KJKFm8
         xOtw==
X-Gm-Message-State: AAQBX9dRkYlS6If2fO3HwjmaKH9uKzynwVKUDiyBTDG65rkbZ0oV7Wpm
        ANyiKVC1QWQhU6flEWlJMZoWgBjK/4an81jddu9nJneY
X-Google-Smtp-Source: AKy350YgcRjGuL/qDeluAJv33chqNlIeAE1tqdc0iQxt6eYIqlVfA3Px/MdQZT40niBtU0EQ1p++wQ==
X-Received: by 2002:a17:902:c40f:b0:1a6:7ea8:9f47 with SMTP id k15-20020a170902c40f00b001a67ea89f47mr3769048plk.66.1681857519497;
        Tue, 18 Apr 2023 15:38:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a12-20020a1709027d8c00b001a6f773a23csm2539506plm.122.2023.04.18.15.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 15:38:39 -0700 (PDT)
Message-ID: <643f1bef.170a0220.8749e.6de8@mx.google.com>
Date:   Tue, 18 Apr 2023 15:38:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-480-g90c08f549ee7
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 179 runs,
 11 regressions (v6.1.22-480-g90c08f549ee7)
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

stable-rc/linux-6.1.y baseline: 179 runs, 11 regressions (v6.1.22-480-g90c0=
8f549ee7)

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

bcm2835-rpi-b-rev2           | arm    | lab-broonie     | gcc-10   | bcm283=
5_defconfig            | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx6dl-riotboard             | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

meson-gxl-s905d-p230         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_mips-malta              | mips   | lab-collabora   | gcc-10   | malta_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22-480-g90c08f549ee7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22-480-g90c08f549ee7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90c08f549ee77571625a1b42bbb3fcc956181801 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee8534617973f942e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee8534617973f942e85ee
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-18T18:58:09.057628  + set +x

    2023-04-18T18:58:09.064302  <8>[   10.887870] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10034312_1.4.2.3.1>

    2023-04-18T18:58:09.166680  =


    2023-04-18T18:58:09.267675  / # #export SHELL=3D/bin/sh

    2023-04-18T18:58:09.267895  =


    2023-04-18T18:58:09.368862  / # export SHELL=3D/bin/sh. /lava-10034312/=
environment

    2023-04-18T18:58:09.369091  =


    2023-04-18T18:58:09.470065  / # . /lava-10034312/environment/lava-10034=
312/bin/lava-test-runner /lava-10034312/1

    2023-04-18T18:58:09.470347  =


    2023-04-18T18:58:09.475022  / # /lava-10034312/bin/lava-test-runner /la=
va-10034312/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee8434084a733bf2e860d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee8444084a733bf2e8612
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-18T18:58:01.741121  + <8>[    8.959586] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10034294_1.4.2.3.1>

    2023-04-18T18:58:01.741268  set +x

    2023-04-18T18:58:01.846133  / # #

    2023-04-18T18:58:01.947329  export SHELL=3D/bin/sh

    2023-04-18T18:58:01.947602  #

    2023-04-18T18:58:02.048589  / # export SHELL=3D/bin/sh. /lava-10034294/=
environment

    2023-04-18T18:58:02.048861  =


    2023-04-18T18:58:02.149649  / # . /lava-10034294/environment/lava-10034=
294/bin/lava-test-runner /lava-10034294/1

    2023-04-18T18:58:02.150026  =


    2023-04-18T18:58:02.154710  / # /lava-10034294/bin/lava-test-runner /la=
va-10034294/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee85540e9ecbe2c2e862d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee85540e9ecbe2c2e8632
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-18T18:58:04.634543  <8>[   10.708017] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10034346_1.4.2.3.1>

    2023-04-18T18:58:04.637368  + set +x

    2023-04-18T18:58:04.739561  =


    2023-04-18T18:58:04.840583  / # #export SHELL=3D/bin/sh

    2023-04-18T18:58:04.840782  =


    2023-04-18T18:58:04.941723  / # export SHELL=3D/bin/sh. /lava-10034346/=
environment

    2023-04-18T18:58:04.941949  =


    2023-04-18T18:58:05.042838  / # . /lava-10034346/environment/lava-10034=
346/bin/lava-test-runner /lava-10034346/1

    2023-04-18T18:58:05.043161  =


    2023-04-18T18:58:05.048652  / # /lava-10034346/bin/lava-test-runner /la=
va-10034346/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie     | gcc-10   | bcm283=
5_defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee72e03a5f886812e85e6

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee72e03a5f886812e8619
        new failure (last pass: v6.1.22-178-gf8a7fa4a96bb)

    2023-04-18T18:53:12.250831  + set +x
    2023-04-18T18:53:12.254677  <8>[   17.808073] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 349078_1.5.2.4.1>
    2023-04-18T18:53:12.371290  / # #
    2023-04-18T18:53:12.473389  export SHELL=3D/bin/sh
    2023-04-18T18:53:12.473928  #
    2023-04-18T18:53:12.575424  / # export SHELL=3D/bin/sh. /lava-349078/en=
vironment
    2023-04-18T18:53:12.576042  =

    2023-04-18T18:53:12.677657  / # . /lava-349078/environment/lava-349078/=
bin/lava-test-runner /lava-349078/1
    2023-04-18T18:53:12.678609  =

    2023-04-18T18:53:12.684739  / # /lava-349078/bin/lava-test-runner /lava=
-349078/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643eed799ce27f6bb62e861a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643eed799ce27f6bb62e861f
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-18T19:20:09.534138  + set +x

    2023-04-18T19:20:09.540651  <8>[   10.195461] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10034323_1.4.2.3.1>

    2023-04-18T19:20:09.649244  / # #

    2023-04-18T19:20:09.751882  export SHELL=3D/bin/sh

    2023-04-18T19:20:09.752676  #

    2023-04-18T19:20:09.854513  / # export SHELL=3D/bin/sh. /lava-10034323/=
environment

    2023-04-18T19:20:09.855295  =


    2023-04-18T19:20:09.957158  / # . /lava-10034323/environment/lava-10034=
323/bin/lava-test-runner /lava-10034323/1

    2023-04-18T19:20:09.958353  =


    2023-04-18T19:20:09.962853  / # /lava-10034323/bin/lava-test-runner /la=
va-10034323/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee8414084a733bf2e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee8414084a733bf2e85fb
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-18T18:57:44.068476  <8>[    7.805121] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10034298_1.4.2.3.1>

    2023-04-18T18:57:44.071714  + set +x

    2023-04-18T18:57:44.173330  #

    2023-04-18T18:57:44.173580  =


    2023-04-18T18:57:44.274571  / # #export SHELL=3D/bin/sh

    2023-04-18T18:57:44.274810  =


    2023-04-18T18:57:44.375728  / # export SHELL=3D/bin/sh. /lava-10034298/=
environment

    2023-04-18T18:57:44.375897  =


    2023-04-18T18:57:44.476774  / # . /lava-10034298/environment/lava-10034=
298/bin/lava-test-runner /lava-10034298/1

    2023-04-18T18:57:44.477094  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee8444084a733bf2e8618

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee8444084a733bf2e861d
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-18T18:57:52.811913  + <8>[   11.209274] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10034291_1.4.2.3.1>

    2023-04-18T18:57:52.812098  set +x

    2023-04-18T18:57:52.917267  / # #

    2023-04-18T18:57:53.018304  export SHELL=3D/bin/sh

    2023-04-18T18:57:53.018583  #

    2023-04-18T18:57:53.119592  / # export SHELL=3D/bin/sh. /lava-10034291/=
environment

    2023-04-18T18:57:53.119822  =


    2023-04-18T18:57:53.220738  / # . /lava-10034291/environment/lava-10034=
291/bin/lava-test-runner /lava-10034291/1

    2023-04-18T18:57:53.221136  =


    2023-04-18T18:57:53.226042  / # /lava-10034291/bin/lava-test-runner /la=
va-10034291/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6dl-riotboard             | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643eea4ffa6310b9362e85fd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643eea4ffa6310b9362e8602
        new failure (last pass: v6.1.15-886-g7ff82f8ebd2b)

    2023-04-18T19:06:31.311797  + set[   14.882246] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 929877_1.5.2.3.1>
    2023-04-18T19:06:31.311982   +x
    2023-04-18T19:06:31.418036  / # #
    2023-04-18T19:06:31.519774  export SHELL=3D/bin/sh
    2023-04-18T19:06:31.520315  #
    2023-04-18T19:06:31.621670  / # export SHELL=3D/bin/sh. /lava-929877/en=
vironment
    2023-04-18T19:06:31.622151  =

    2023-04-18T19:06:31.723476  / # . /lava-929877/environment/lava-929877/=
bin/lava-test-runner /lava-929877/1
    2023-04-18T19:06:31.724202  =

    2023-04-18T19:06:31.727417  / # /lava-929877/bin/lava-test-runner /lava=
-929877/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee83e088c3a271b2e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee83e088c3a271b2e860d
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-18T18:57:47.209064  + set<8>[   12.045857] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10034317_1.4.2.3.1>

    2023-04-18T18:57:47.209268   +x

    2023-04-18T18:57:47.314283  / # #

    2023-04-18T18:57:47.415457  export SHELL=3D/bin/sh

    2023-04-18T18:57:47.415738  #

    2023-04-18T18:57:47.516738  / # export SHELL=3D/bin/sh. /lava-10034317/=
environment

    2023-04-18T18:57:47.517021  =


    2023-04-18T18:57:47.618000  / # . /lava-10034317/environment/lava-10034=
317/bin/lava-test-runner /lava-10034317/1

    2023-04-18T18:57:47.618379  =


    2023-04-18T18:57:47.622603  / # /lava-10034317/bin/lava-test-runner /la=
va-10034317/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxl-s905d-p230         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee8ea6fbffd7fb02e8667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ee8ea6fbffd7fb02e8=
668
        new failure (last pass: v6.1.22-182-g01cd0041b7a5a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_mips-malta              | mips   | lab-collabora   | gcc-10   | malta_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee5e7fd4fb2b8e72e8629

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
480-g90c08f549ee7/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/643ee5e7fd4fb2b=
8e72e8631
        new failure (last pass: v6.1.22-178-gf8a7fa4a96bb)
        1 lines

    2023-04-18T18:47:44.298885  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eebb0ee8, epc =3D=3D 80202014, ra =3D=
=3D 80204964
    2023-04-18T18:47:44.299099  =


    2023-04-18T18:47:44.333946  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-18T18:47:44.334155  =

   =

 =20
