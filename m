Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1396AA692
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 01:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCDAhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 19:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjCDAgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 19:36:45 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84ED65463
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 16:36:20 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id a9so4506721plh.11
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 16:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677890180;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6Ux2Dx0pebu3pgR7e2ny9WBHam0KqnjuXA2r2GIxKl8=;
        b=IOw42ubEaWJZGRWIOfFT3mJC7ti2kxBDC/kurj/nNnlaDK309rst/GhBhfbMoNIHLv
         sh9DsahQWSW48x3JlkFX28sHdqKnzEX+geoDIDTdrkCfM7kNwafS2zNeI5UeY80+TA9B
         Wj5l5KCdqouhXermI9ZUwPjKraSK1nolDxBzJYJMXmVABYyrQ/1a/IhzakPDHLmkPEJD
         Pxe+yHBJTcBmZhGBndCB7/CHhMzzA/W37WAtQ6vufgEChhONeCb+7yuD5//OMHQZFSNn
         Bsa1M2Hje9HfM7lmj4nm0UDhllQCUwi06rK67HUb9CUGs7b/Wn4t2dsqhm9VK5a5bElL
         6dEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890180;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Ux2Dx0pebu3pgR7e2ny9WBHam0KqnjuXA2r2GIxKl8=;
        b=xGeP118mU9xCEEfVvmZyqKbpRlqS8wew1ropDA5fLQsm+RNrjC6yx2PscJg6G1Y9cO
         /bH6XOcbX5JtAONB96AfvZYwMboqqvo5gw7YL56wvQYS7KoelMLcGvH/BCtGC+LL+DkO
         xb1m1KkYZ7UlruqTC2iltZ+0K9GzlGbgvxPpqlk/imMJtCVD8LD3cWJ7l0ggyxbEkQxs
         DuwlHsGeU1lkQobCrrFuUXlKrbAqKml5s9Ka4qa+uyDQCy1/akqndFbhr7CJ81hYH/1a
         ljZvkHuJO5/cBRfNBlTdWJKxXZDB1zoDcVbb4p+a65SAX4c3TkuNtKpELCPau7sH7Wp5
         xbcA==
X-Gm-Message-State: AO0yUKUDjYTygNC8yB8RflbffmASz4Wi0rYBuq+rPehN2YDxmsNun0t8
        Gs+vvQ5RPmksUimIM6K7MsioBDvOJkc2PLc7SViFgO0B
X-Google-Smtp-Source: AK7set/Z6c0rqBc4Ep2GqTWUXYHmIs9X0EM2BA9HYZZErRlwLI+EwPdkToXGrk+okOi5C/OY80waQg==
X-Received: by 2002:a17:902:720b:b0:19c:cf89:b7ee with SMTP id ba11-20020a170902720b00b0019ccf89b7eemr3037979plb.69.1677890179661;
        Fri, 03 Mar 2023 16:36:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w28-20020a63161c000000b00502ecc282e2sm2119654pgl.5.2023.03.03.16.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:36:19 -0800 (PST)
Message-ID: <64029283.630a0220.16de8.4fdc@mx.google.com>
Date:   Fri, 03 Mar 2023 16:36:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.172-4-g194b8cba79b0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 171 runs,
 14 regressions (v5.10.172-4-g194b8cba79b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 171 runs, 14 regressions (v5.10.172-4-g194b8=
cba79b0)

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

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.172-4-g194b8cba79b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.172-4-g194b8cba79b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      194b8cba79b0fb25845e5fb4ce32f895957588b9 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64025dd6a0989446178c863d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagle=
bone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagle=
bone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64025dd6a0989446178c8646
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-03T20:51:18.436261  <8>[   20.755306] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 93867_1.5.2.4.1>
    2023-03-03T20:51:18.545363  / # #
    2023-03-03T20:51:18.647547  export SHELL=3D/bin/sh
    2023-03-03T20:51:18.648353  #
    2023-03-03T20:51:18.750706  / # export SHELL=3D/bin/sh. /lava-93867/env=
ironment
    2023-03-03T20:51:18.751864  =

    2023-03-03T20:51:18.853859  / # . /lava-93867/environment/lava-93867/bi=
n/lava-test-runner /lava-93867/1
    2023-03-03T20:51:18.854798  =

    2023-03-03T20:51:18.858313  / # /lava-93867/bin/lava-test-runner /lava-=
93867/1
    2023-03-03T20:51:18.960048  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640261ce8c18b7e49e8c8641

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640261ce8c18b7e49e8c864a
        failing since 36 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-03T21:08:07.123882  <8>[   11.050696] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3383001_1.5.2.4.1>
    2023-03-03T21:08:07.233925  / # #
    2023-03-03T21:08:07.337309  export SHELL=3D/bin/sh
    2023-03-03T21:08:07.338391  #
    2023-03-03T21:08:07.442865  / # export SHELL=3D/bin/sh. /lava-3383001/e=
nvironment
    2023-03-03T21:08:07.443422  =

    2023-03-03T21:08:07.443611  / # . /lava-3383001/environment<3>[   11.37=
1614] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-03T21:08:07.545064  /lava-3383001/bin/lava-test-runner /lava-33=
83001/1
    2023-03-03T21:08:07.547676  =

    2023-03-03T21:08:07.552366  / # /lava-3383001/bin/lava-test-runner /lav=
a-3383001/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/64025ff4df2494cabf8c865e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64025ff4df2494cabf8c8=
65f
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/64026020d2910dbc4e8c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64026020d2910dbc4e8c8=
653
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64025f7e5eb169a6388c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64025f7e5eb169a6388c8=
63b
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64026030cddab205be8c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64026030cddab205be8c8=
641
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64025f80769dd01d758c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64025f80769dd01d758c8=
642
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64026098290861def88c8684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64026098290861def88c8=
685
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64025f7c620f4ec5fe8c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64025f7c620f4ec5fe8c8=
637
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640260084de705570d8c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640260084de705570d8c8=
642
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64025f6c620f4ec5fe8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64025f6c620f4ec5fe8c8=
631
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64026070805eed540c8c8693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64026070805eed540c8c8=
694
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64025f69769dd01d758c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64025f69769dd01d758c8=
634
        failing since 17 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6402618ee1be3dcf948c8667

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-4-g194b8cba79b0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6402618ee1be3dcf948c8670
        failing since 30 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-03T21:06:59.658968  / # #
    2023-03-03T21:06:59.762101  export SHELL=3D/bin/sh
    2023-03-03T21:06:59.763064  #
    2023-03-03T21:06:59.864976  / # export SHELL=3D/bin/sh. /lava-3382994/e=
nvironment
    2023-03-03T21:06:59.865897  =

    2023-03-03T21:06:59.967817  / # . /lava-3382994/environment/lava-338299=
4/bin/lava-test-runner /lava-3382994/1
    2023-03-03T21:06:59.968646  =

    2023-03-03T21:06:59.980601  / # /lava-3382994/bin/lava-test-runner /lav=
a-3382994/1
    2023-03-03T21:07:00.088563  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-03T21:07:00.089202  + cd /lava-3382994/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
