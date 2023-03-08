Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8116AFF09
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 07:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjCHGon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 01:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCHGom (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 01:44:42 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379D47ED5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 22:44:41 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x34so15704014pjj.0
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 22:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678257880;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gwJLEPh8OfJ/r1iVm4BgauAQwdKohA/Va1fwSJWDd2Q=;
        b=X3qvoqVfxQuVyzHBFH2Gt86E8ojU5HXkGs0oG8RT4OFcdkll/s6/IiTcbFKw8yUn6Y
         yr+rYMbsGXAa7pDSaUNXo3NR8GFIOROdeRzVCV21e21CfNRDaoDWzBuw0DSR2rIIUTkh
         4bw7T2ni3SX7JNAABN6occo5168TZXIWuFFKcQXkcbKUxnw4OYS3UKA4PiHVL7ZFZ2LB
         +xWF+5NOy0mNV3P7lvISlUjuI+lWfbnUXrhYJMYjaHw3l3KaH6d1VJQitMEgSdRzzW3D
         gkEyw3oG4W1Yhlmw1ylTPucWoIV5ZSfEzSQS/1jMqnMUVZ66uY70kmP8LMvbFIo/YAe/
         +Xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678257880;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gwJLEPh8OfJ/r1iVm4BgauAQwdKohA/Va1fwSJWDd2Q=;
        b=LxxFRNV1F7fgSx4up3OHlwYGveFOB15iHX5adMvKD5fa3dESL2J8i57jQ1R4Su1oWW
         FtUMz+jh5O2Tx5QW/UBWYY8C6+SuPtdUsMG51UAILhP0sUWFhCe/XWeaJpAKzoppfnMd
         UrOmc4iSxLFkxkFeWAHE0Jix5GFPZAI7lYORP2BSDoy6UrEXnq87/NZxREFPyu4sYtTn
         ZDAiJJnWi2S564HHLrkGRTyM9Q63OYIOALZR86LK+KzX4ivF8y/s/tAVVsE8Stm+EQDc
         ywrg5OT77hrtOBTga8b+eZgR+n3sLXIr1g32CpwK4JInj5jE8BA4oLVFFY5WYbhkBoAZ
         TQ/g==
X-Gm-Message-State: AO0yUKWyal0lzC1CRqJKFzpDs1xWjRFPHmVr5jLicVtDJJdnNAuCWQDl
        dZKQBDRjC92ScHE0GVXNk4gVBcVGRxXEmJRagNE7eQ==
X-Google-Smtp-Source: AK7set9VTLF56BaecBjdlT5bzszghzD5SoetKjWdxnKOl5hGarDG1eg8hEiO8uSjB47YpMzXgs32QQ==
X-Received: by 2002:a17:902:dac3:b0:19a:a6ec:6721 with SMTP id q3-20020a170902dac300b0019aa6ec6721mr21433779plx.16.1678257880488;
        Tue, 07 Mar 2023 22:44:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902b59100b001991f07f41dsm9254186pls.297.2023.03.07.22.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 22:44:40 -0800 (PST)
Message-ID: <64082ed8.170a0220.282fe.1615@mx.google.com>
Date:   Tue, 07 Mar 2023 22:44:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-885-gb76254894610
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 178 runs,
 5 regressions (v6.1.15-885-gb76254894610)
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

stable-rc/queue/6.1 baseline: 178 runs, 5 regressions (v6.1.15-885-gb762548=
94610)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
       | regressions
-----------------------+--------+-----------------+----------+-------------=
-------+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie     | gcc-10   | bcm2835_defc=
onfig  | 1          =

imx6dl-riotboard       | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config | 1          =

qemu_mips-malta        | mips   | lab-collabora   | gcc-10   | malta_defcon=
fig    | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig   | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.15-885-gb76254894610/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.15-885-gb76254894610
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b76254894610f46c05879fdcf46e0a32afbfc482 =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
       | regressions
-----------------------+--------+-----------------+----------+-------------=
-------+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie     | gcc-10   | bcm2835_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6407faf17f04eca1c28c8652

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6407faf17f04eca1c28c865b
        failing since 1 day (last pass: v6.1.15-660-g430daf603d29, first fa=
il: v6.1.15-782-g0dcd2816cbbf)

    2023-03-08T03:02:44.019329  + set +x
    2023-03-08T03:02:44.022880  <8>[   16.368085] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 122746_1.5.2.4.1>
    2023-03-08T03:02:44.139316  / # #
    2023-03-08T03:02:44.241504  export SHELL=3D/bin/sh
    2023-03-08T03:02:44.242085  #
    2023-03-08T03:02:44.344125  / # export SHELL=3D/bin/sh. /lava-122746/en=
vironment
    2023-03-08T03:02:44.344954  =

    2023-03-08T03:02:44.447679  / # . /lava-122746/environment/lava-122746/=
bin/lava-test-runner /lava-122746/1
    2023-03-08T03:02:44.449819  =

    2023-03-08T03:02:44.455332  / # /lava-122746/bin/lava-test-runner /lava=
-122746/1 =

    ... (14 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
       | regressions
-----------------------+--------+-----------------+----------+-------------=
-------+------------
imx6dl-riotboard       | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/6407fdeaa717f339398c8663

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6407fdeaa717f339398c866c
        new failure (last pass: v6.1.15-852-g8c53975a36f6)

    2023-03-08T03:15:31.117475  + set[   14.903852] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 918325_1.5.2.3.1>
    2023-03-08T03:15:31.117681   +x
    2023-03-08T03:15:31.223953  / # #
    2023-03-08T03:15:31.325844  export SHELL=3D/bin/sh
    2023-03-08T03:15:31.326563  #
    2023-03-08T03:15:31.427908  / # export SHELL=3D/bin/sh. /lava-918325/en=
vironment
    2023-03-08T03:15:31.428363  =

    2023-03-08T03:15:31.529598  / # . /lava-918325/environment/lava-918325/=
bin/lava-test-runner /lava-918325/1
    2023-03-08T03:15:31.530340  =

    2023-03-08T03:15:31.533835  / # /lava-918325/bin/lava-test-runner /lava=
-918325/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
       | regressions
-----------------------+--------+-----------------+----------+-------------=
-------+------------
qemu_mips-malta        | mips   | lab-collabora   | gcc-10   | malta_defcon=
fig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6407fb7beebaaefe398c8649

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6407fb7beebaaef=
e398c864d
        failing since 1 day (last pass: v6.1.15-650-g40afe6d834bf, first fa=
il: v6.1.15-660-g430daf603d29)
        1 lines

    2023-03-08T03:05:24.517633  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 00000030, epc =3D=3D 80203a78, ra =3D=
=3D 80203a68
    2023-03-08T03:05:24.517792  =


    2023-03-08T03:05:24.539622  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-08T03:05:24.539789  =

   =

 =



platform               | arch   | lab             | compiler | defconfig   =
       | regressions
-----------------------+--------+-----------------+----------+-------------=
-------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/6407fae8f7eb12bbc58c868b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6407fae8f7eb12bbc58c8=
68c
        failing since 3 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab             | compiler | defconfig   =
       | regressions
-----------------------+--------+-----------------+----------+-------------=
-------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/64080e11e0c5e2c08c8c86b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
5-gb76254894610/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64080e11e0c5e2c08c8c8=
6ba
        failing since 3 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =20
