Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF256EC1CA
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 21:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjDWTQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 15:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDWTQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 15:16:20 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36EF10E6
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 12:16:18 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b73203e0aso23328733b3a.1
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 12:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682277378; x=1684869378;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aDyXcW5a09pxYIAL3pPVJY/scFlL7aZTGMW0GkC54iY=;
        b=YsgN138rtJaKpW9DIfz/8zLVFhn9hGrndbR/SWog6SfZma9IkysPvEB/A5WFZgSZJK
         WaEh/ibAbAs7J+OF/7nuJ6nLf6k7kcvWISCCvb4Vz0q11y89aRTRQwP5b3g/shjjpPAC
         lVEmJwYDvVKn99kj1moawBRaf/IKnn/33+KU7461shB2G8axS9eBRs7WnqVofIMgwrjt
         g8TPLiqIVl64WYq5AfkVALAld8XDiQoce5eTpeDNw73VLvIY7gSSZlWw8zFcXsh7r0B6
         8+t8tcHQReypjW5Q0spIitexKP/NJYt+R295Om1LnUBZMwXMGCCM1AbWvbrlMqU4VcxB
         JaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682277378; x=1684869378;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aDyXcW5a09pxYIAL3pPVJY/scFlL7aZTGMW0GkC54iY=;
        b=Zhr8gEQyedSErDLHi8HhHi2xFx0zL3olr7XeJM7awF8+bk36ttGkMFJ0nLjI3V+sXX
         R3ZgyaMqE/fjzIhfjPI4GRgRW5jS0fF5fC+PfAFstCcHyVrocPtgYkvSB0phUyoBecSu
         kTmkWlfI3HnP+f/MQOjNEk7vx3B+chCsiOSYvyPOA7ylosxozwo7rG7NJCsNwcIDUEfy
         xXtvD4DMKZZZlDnk7TuLSMZxpIF9RZefk/3QbrNvEr9VNpRlVkvjpOp7fLAeYkFL5fOf
         Tj5Obm9/Z+8IRMmlQmUJG4VzQzc5Hj0/YAjcxiaV383NAf+jKoIQhBCpA+v3P+2s5bRM
         u+Bg==
X-Gm-Message-State: AAQBX9dMJgIOa1UTuFoxTaTU0utfxRK/oRHWBow1aq/3r/ecP81G7DeN
        StldIv0qrVGTgI9W1sFiuQCsITOJ1NRGC7Kx/aRJqA==
X-Google-Smtp-Source: AKy350arTofnXmrVCKkwR294Vlp7s7cZx4sBp5NfTRz6zAXbnHX4Giff5H8jyKnGBDXMvYFn2ZInwA==
X-Received: by 2002:a17:902:d509:b0:1a9:5674:281c with SMTP id b9-20020a170902d50900b001a95674281cmr8839040plg.23.1682277377975;
        Sun, 23 Apr 2023 12:16:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q19-20020a170902bd9300b001a5000ba26esm5322778pls.264.2023.04.23.12.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 12:16:17 -0700 (PDT)
Message-ID: <64458401.170a0220.eedab.ac83@mx.google.com>
Date:   Sun, 23 Apr 2023 12:16:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-356-g1b4cbb1058e2a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 121 runs,
 4 regressions (v5.10.176-356-g1b4cbb1058e2a)
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

stable-rc/queue/5.10 baseline: 121 runs, 4 regressions (v5.10.176-356-g1b4c=
bb1058e2a)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-356-g1b4cbb1058e2a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-356-g1b4cbb1058e2a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b4cbb1058e2ab48c60ab16ff0ea14ea75fd639a =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64454aee60071761d22e860a

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-356-g1b4cbb1058e2a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-356-g1b4cbb1058e2a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454aee60071761d22e863f
        failing since 68 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-23T15:12:28.179124  <8>[   20.908106] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 374314_1.5.2.4.1>
    2023-04-23T15:12:28.288906  / # #
    2023-04-23T15:12:28.390946  export SHELL=3D/bin/sh
    2023-04-23T15:12:28.391572  #
    2023-04-23T15:12:28.493175  / # export SHELL=3D/bin/sh. /lava-374314/en=
vironment
    2023-04-23T15:12:28.493913  =

    2023-04-23T15:12:28.595775  / # . /lava-374314/environment/lava-374314/=
bin/lava-test-runner /lava-374314/1
    2023-04-23T15:12:28.596776  =

    2023-04-23T15:12:28.601222  / # /lava-374314/bin/lava-test-runner /lava=
-374314/1
    2023-04-23T15:12:28.696455  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64454ede17133ec65e2e869e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-356-g1b4cbb1058e2a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-356-g1b4cbb1058e2a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454ede17133ec65e2e86a3
        failing since 87 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-23T15:29:08.681840  <8>[   11.061736] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3524465_1.5.2.4.1>
    2023-04-23T15:29:08.792608  / # #
    2023-04-23T15:29:08.895748  export SHELL=3D/bin/sh
    2023-04-23T15:29:08.896643  #
    2023-04-23T15:29:08.998427  / # export SHELL=3D/bin/sh. /lava-3524465/e=
nvironment
    2023-04-23T15:29:08.998929  =

    2023-04-23T15:29:08.999159  / # . /lava-3524465/environment<3>[   11.37=
1360] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-04-23T15:29:09.100534  /lava-3524465/bin/lava-test-runner /lava-35=
24465/1
    2023-04-23T15:29:09.102122  =

    2023-04-23T15:29:09.107108  / # /lava-3524465/bin/lava-test-runner /lav=
a-3524465/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454b8d75c6e55c812e85f8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-356-g1b4cbb1058e2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-356-g1b4cbb1058e2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454b8d75c6e55c812e85fd
        failing since 24 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-23T15:15:01.330313  + <8>[   10.829489] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10093817_1.4.2.3.1>

    2023-04-23T15:15:01.330407  set +x

    2023-04-23T15:15:01.431946  #

    2023-04-23T15:15:01.432229  =


    2023-04-23T15:15:01.533176  / # #export SHELL=3D/bin/sh

    2023-04-23T15:15:01.533381  =


    2023-04-23T15:15:01.634267  / # export SHELL=3D/bin/sh. /lava-10093817/=
environment

    2023-04-23T15:15:01.634484  =


    2023-04-23T15:15:01.735375  / # . /lava-10093817/environment/lava-10093=
817/bin/lava-test-runner /lava-10093817/1

    2023-04-23T15:15:01.735691  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454b7473b2670cf12e85ee

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-356-g1b4cbb1058e2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-356-g1b4cbb1058e2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454b7473b2670cf12e85f3
        failing since 24 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-23T15:14:43.773937  + set +x

    2023-04-23T15:14:43.780071  <8>[   12.329984] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10093784_1.4.2.3.1>

    2023-04-23T15:14:43.885090  / # #

    2023-04-23T15:14:43.986141  export SHELL=3D/bin/sh

    2023-04-23T15:14:43.986367  #

    2023-04-23T15:14:44.087332  / # export SHELL=3D/bin/sh. /lava-10093784/=
environment

    2023-04-23T15:14:44.087555  =


    2023-04-23T15:14:44.188514  / # . /lava-10093784/environment/lava-10093=
784/bin/lava-test-runner /lava-10093784/1

    2023-04-23T15:14:44.188789  =


    2023-04-23T15:14:44.193267  / # /lava-10093784/bin/lava-test-runner /la=
va-10093784/1
 =

    ... (12 line(s) more)  =

 =20
