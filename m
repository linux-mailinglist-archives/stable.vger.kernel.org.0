Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CC46BD22B
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 15:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjCPORt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 10:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCPORs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 10:17:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A148AB329B
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 07:17:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o11so1919987ple.1
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 07:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678976222;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=g3lJ2PledGuzUnGQBKAMyP8xOk6x8PvjGkWxhKCgEdo=;
        b=r3RJyeJuW6SBWawFEVdmrQI0OsFSb8+sYOcgxEQ0xELAy7o5zBcLiCsg2JsNHwVpyT
         xsGjpSAeoFoHE80wWqI2KHh17wp/IK6uQR8KWAR1Xn8ebHVHAVMvpX8hugcxiGSFn5NT
         IsYNrKoAEIrZr52bBW1SB//RMK8pYtrsW35OK1DMXIsfv67BXt0mxVIL9owU/SJKks8M
         GilMUcmu07PewbiJ6PVElsZD9PZY7zqxvBiFvcSD3rsaoj2EVH4QgJzj0BNVZky1GRHg
         fuCk5KwFUlEEH4dANhZ7UKByvU9nNNipbOYQ9SPCSIj1jRFwkOzCZ4tPsWfQ+ZhM+a+4
         K5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678976222;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g3lJ2PledGuzUnGQBKAMyP8xOk6x8PvjGkWxhKCgEdo=;
        b=3xIAVnAh/btw+XFlUEfmbYOyi5sRV7SdtMw9ZEv9/SN9MFn3lQu29xgSOt6Veb9Iqy
         GXyeLVSh8ukRaxdMM/09ZqVYu0hE7qpX4VrjSVuw3DrDiBWdl4gotPAV9Z5Hm6VbiEiY
         Y5vE8BaeQxmN8ulftHjuC/O0p6zsbmliTe2AY6yitlb6RtMuDd3cPnECegcpDakxCJyM
         tRfzgdwEe3cjbC/c2gdcUiiGyN40TsKMz4XplfoNYm8KqRPPccgYqmJnlFOlFDTG8W0i
         P6pc5++whrCNozXwgVfWNJxBzy3tgU7TrXkVVwvaK4LSvc9cgG+FqIWOh/CVpFYiSalk
         XBrg==
X-Gm-Message-State: AO0yUKVi2N/Wa7qbyvK14LpZYht94Y55/JGmtVp2plcOoQq7YmKDcAjI
        We9CsGcMjIsRisJf5rhFpz2te4mzApUjKWAEZ83JxHMl
X-Google-Smtp-Source: AK7set8ZzuDAo/n6Hecyutqv9ZrewGOyV+SIewZ5oFyRZVJY886pDZyqsTB9yRM+TK0qJv6o/W6O/A==
X-Received: by 2002:a17:903:187:b0:19a:b4a9:9ddb with SMTP id z7-20020a170903018700b0019ab4a99ddbmr4083938plg.49.1678976221772;
        Thu, 16 Mar 2023 07:17:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11-20020a170902ee0b00b0019a723a831dsm2506084plb.158.2023.03.16.07.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 07:17:01 -0700 (PDT)
Message-ID: <641324dd.170a0220.e2bf3.50ce@mx.google.com>
Date:   Thu, 16 Mar 2023 07:17:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-96-gba6c29f68bb2c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 194 runs,
 12 regressions (v5.10.173-96-gba6c29f68bb2c)
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

stable-rc/linux-5.10.y baseline: 194 runs, 12 regressions (v5.10.173-96-gba=
6c29f68bb2c)

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

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

odroid-xu3                   | arm    | lab-collabora | gcc-10   | exynos_d=
efconfig             | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.173-96-gba6c29f68bb2c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.173-96-gba6c29f68bb2c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba6c29f68bb2cc2c8bf9fbffe4856db450c9447f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6412ef1d072c9492708c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6412ef1d072c9492708c8=
636
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6412ef09323cb5de6a8c8683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6412ef09323cb5de6a8c8=
684
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6412ef1c763e4dbad98c877a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6412ef1c763e4dbad98c8=
77b
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6412f0552aa3fafa6b8c8682

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6412f0552aa3fafa6b8c868b
        failing since 57 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-16T10:32:15.080256  <8>[   11.135305] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-03-16T10:32:15.080414  + set +x
    2023-03-16T10:32:15.086169  <8>[   11.146138] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3416407_1.5.2.4.1>
    2023-03-16T10:32:15.194003  / # #
    2023-03-16T10:32:15.296418  export SHELL=3D/bin/sh
    2023-03-16T10:32:15.296960  #
    2023-03-16T10:32:15.298140  / # <3>[   11.291213] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-16T10:32:15.399488  export SHELL=3D/bin/sh. /lava-3416407/envir=
onment
    2023-03-16T10:32:15.399884  =

    2023-03-16T10:32:15.501182  / # . /lava-3416407/environment/lava-341640=
7/bin/lava-test-runner /lava-3416407/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6412ef1d921842a4968c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6412ef1d921842a4968c8=
637
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6412f05d48929f59388c8656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6412f05d48929f59388c8=
657
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6412f294983be22c0b8c865e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6412f294983be22c0b8c8665
        failing since 12 days (last pass: v5.10.155, first fail: v5.10.172)

    2023-03-16T10:42:16.275366  [    9.485459] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1174909_1.5.2.4.1>
    2023-03-16T10:42:16.379957  / # #
    2023-03-16T10:42:16.481264  export SHELL=3D/bin/sh
    2023-03-16T10:42:16.481634  #
    2023-03-16T10:42:16.582695  / # export SHELL=3D/bin/sh. /lava-1174909/e=
nvironment
    2023-03-16T10:42:16.583329  =

    2023-03-16T10:42:16.684800  / # . /lava-1174909/environment/lava-117490=
9/bin/lava-test-runner /lava-1174909/1
    2023-03-16T10:42:16.685292  =

    2023-03-16T10:42:16.687201  / # /lava-1174909/bin/lava-test-runner /lav=
a-1174909/1
    2023-03-16T10:42:16.704087  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6412f0323ce5a492ca8c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6412f0323ce5a492ca8c8=
641
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
odroid-xu3                   | arm    | lab-collabora | gcc-10   | exynos_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6412f1509d3bc6c94f8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6412f1509d3bc6c94f8c8=
630
        new failure (last pass: v5.10.173-109-g420b6d10bae3) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6412ef9e86fa757aea8c875c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6412ef9e86fa757aea8c8=
75d
        failing since 2 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6412f0322eced4db578c8730

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-96-gba6c29f68bb2c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6412f0322eced4db578c873a
        failing since 2 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-16T10:31:54.966862  <8>[   34.094219] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-03-16T10:31:55.990679  /lava-9649031/1/../bin/lava-test-case

    2023-03-16T10:31:56.002207  <8>[   35.129671] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6412f0322eced4db578c873b
        failing since 2 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-16T10:31:53.932282  <8>[   33.057761] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-16T10:31:54.955664  /lava-9649031/1/../bin/lava-test-case
   =

 =20
