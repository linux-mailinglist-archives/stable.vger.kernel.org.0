Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EABA6AB15F
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 17:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjCEQZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 11:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjCEQZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 11:25:11 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE0719A3
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 08:25:08 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id l1so7426774pjt.2
        for <stable@vger.kernel.org>; Sun, 05 Mar 2023 08:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678033508;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XcAjfmNzVI400/3Sg7C+mSfkiMuwLlm708IMOpBViYk=;
        b=uju8Q5WrTxGTF89vbu/yiTrlpzq8vOs3qXvqjNvXyF4C55GFSPd6Q5e3oQSr2B36CL
         f9Ev6ZeebqDs/afLb+2HEvLqY3IhtZzm8GL/UTMdy3dH0HuPzqdAhW7JluKIeVCiQqE8
         f3+dc/xbigwfpPsgAWfrRPvJGezVhYDfbQKfp5pDPnfyuvS91vvc+1GdJhdyCM76WtmE
         CO0pyfRDGEcM5TZ3mvjurQeZPLqg5FZnEMbohy6LF2k4mE85KCruMor2O6OxMM/75Dxn
         xxIPDI9DLFz6SjbCxxeWPJwQTkB1tMAO4ixb58gvmbaguc+B4/5q1AxKTgd3FyJe1T5u
         xtrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678033508;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XcAjfmNzVI400/3Sg7C+mSfkiMuwLlm708IMOpBViYk=;
        b=KTzj4t2I60FzgOcfRriWRR0QnHG5Pc2taZnNgr3xoaq/nlFvZL1xeTQhk5al9QJX3K
         8J4+lrcmB5bORit/B+9KucbGpoQ5fjP3pgniEih5RJjBm4OXetr1i6zlR/97qhkoi//4
         70XpMCZuH1M8rz5158MwhLT7K1NLqLKXrq0rj4UFzHXPZq+fRjUuORYFShz4sAHYnt3p
         A7Y1wVQ+4tTwURLiXiBx1DPhsd86as5bd9llJ0J05SxPb5v7KCgEvtuLTWOcHeg7iNvO
         uegrO9ibPwtA+zZ+kf1130DqijeW5Sw93PqAJd4GFj1+leZIl0HffnNAS38G3lvingdG
         NTUg==
X-Gm-Message-State: AO0yUKX8cVr4cb//t+aAstoNWCBWevGTdydO2BwAqZRA/1h1iT728Rbs
        gyaR00J14YU+t4kJEjtNJyusncSlHfQFGsVPaLJGOXQE
X-Google-Smtp-Source: AK7set+uhcCgHuEzTIu9XpyJcLJLIB10SqRMbcFe2EH93TRPn/wBBwdf2UAKlX1ZPO9GUN+tR2UqBA==
X-Received: by 2002:a17:902:ec8d:b0:19e:7a2a:2ea9 with SMTP id x13-20020a170902ec8d00b0019e7a2a2ea9mr10191317plg.14.1678033507854;
        Sun, 05 Mar 2023 08:25:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11-20020a170902d54b00b0019c92f56983sm4922232plf.120.2023.03.05.08.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 08:25:07 -0800 (PST)
Message-ID: <6404c263.170a0220.20854.8f30@mx.google.com>
Date:   Sun, 05 Mar 2023 08:25:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.172-330-g3ab51ffc1c881
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 181 runs,
 18 regressions (v5.10.172-330-g3ab51ffc1c881)
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

stable-rc/queue/5.10 baseline: 181 runs, 18 regressions (v5.10.172-330-g3ab=
51ffc1c881)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

qemu_i386-uefi               | i386   | lab-baylibre    | gcc-10   | i386_d=
efconfig               | 1          =

qemu_i386-uefi               | i386   | lab-broonie     | gcc-10   | i386_d=
efconfig               | 1          =

qemu_i386-uefi               | i386   | lab-collabora   | gcc-10   | i386_d=
efconfig               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-10   | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-10   | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre    | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre    | gcc-10   | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie     | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie     | gcc-10   | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defconfig             | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.172-330-g3ab51ffc1c881/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.172-330-g3ab51ffc1c881
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3ab51ffc1c8818de17a1519a5cf844d7b3d4a0e4 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640490e643e32035398c8663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711=
-rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711=
-rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640490e643e32035398c8=
664
        new failure (last pass: v5.10.172-330-gc8a5f3ce86b1) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64048ab3def25ab85d8c8639

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64048ab3def25ab85d8c8642
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-05T12:27:10.782484  <8>[   18.815463] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 101117_1.5.2.4.1>
    2023-03-05T12:27:10.890498  / # #
    2023-03-05T12:27:10.993898  export SHELL=3D/bin/sh
    2023-03-05T12:27:10.994479  #
    2023-03-05T12:27:11.096222  / # export SHELL=3D/bin/sh. /lava-101117/en=
vironment
    2023-03-05T12:27:11.096890  =

    2023-03-05T12:27:11.198537  / # . /lava-101117/environment/lava-101117/=
bin/lava-test-runner /lava-101117/1
    2023-03-05T12:27:11.199738  =

    2023-03-05T12:27:11.204260  / # /lava-101117/bin/lava-test-runner /lava=
-101117/1
    2023-03-05T12:27:11.304917  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64048d547d2b5b28528c8637

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64048d547d2b5b28528c8640
        failing since 38 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-05T12:38:32.973000  <8>[   11.008441] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3387645_1.5.2.4.1>
    2023-03-05T12:38:33.084473  / # #
    2023-03-05T12:38:33.188032  export SHELL=3D/bin/sh
    2023-03-05T12:38:33.189412  #
    2023-03-05T12:38:33.295952  / # export SHELL=3D/bin/sh. /lava-3387645/e=
nvironment
    2023-03-05T12:38:33.297052  =

    2023-03-05T12:38:33.399526  / # . /lava-3387645/environment/lava-338764=
5/bin/lava-test-runner /lava-3387645/1
    2023-03-05T12:38:33.401314  =

    2023-03-05T12:38:33.406043  / # /lava-3387645/bin/lava-test-runner /lav=
a-3387645/1
    2023-03-05T12:38:33.490544  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre    | gcc-10   | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/64048d943aa0d3c7ea8c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i=
386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i=
386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048d943aa0d3c7ea8c8=
645
        failing since 19 days (last pass: v5.10.167-105-g33398e62147f, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-broonie     | gcc-10   | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/64048e49cef38ac0be8c8676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048e49cef38ac0be8c8=
677
        failing since 19 days (last pass: v5.10.167-105-g33398e62147f, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-collabora   | gcc-10   | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/64048d7344c02a91858c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_=
i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_=
i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048d7344c02a91858c8=
63d
        failing since 19 days (last pass: v5.10.167-105-g33398e62147f, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-10   | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64048ed371f84da4368c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048ed371f84da4368c8=
630
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64048d09a9332a9a998c865d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048d09a9332a9a998c8=
65e
        failing since 19 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-10   | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64048efeac6dffdb1f8c86d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048efeac6dffdb1f8c8=
6d4
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64048cf61526e2d1808c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048cf61526e2d1808c8=
632
        failing since 19 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64048e9ab757e715cb8c8665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-q=
emu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-q=
emu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048e9ab757e715cb8c8=
666
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre    | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64048d08a9332a9a998c865a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayli=
bre/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayli=
bre/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048d08a9332a9a998c8=
65b
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre    | gcc-10   | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64048ed4eb62fc65928c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qe=
mu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qe=
mu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048ed4eb62fc65928c8=
630
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie     | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64048d0aa9332a9a998c866b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048d0aa9332a9a998c8=
66c
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie     | gcc-10   | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64048f276c74f676d58c8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048f276c74f676d58c8=
654
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64048d0f0515feb1d68c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048d0f0515feb1d68c8=
63f
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64048eb3659968853b8c8703

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-q=
emu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-q=
emu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64048eb3659968853b8c8=
704
        failing since 19 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64048d0ba9332a9a998c866e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-330-g3ab51ffc1c881/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64048d0ba9332a9a998c8677
        failing since 31 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-05T12:37:17.986818  / # #
    2023-03-05T12:37:18.088506  export SHELL=3D/bin/sh
    2023-03-05T12:37:18.088926  #
    2023-03-05T12:37:18.190239  / # export SHELL=3D/bin/sh. /lava-3387649/e=
nvironment
    2023-03-05T12:37:18.190603  =

    2023-03-05T12:37:18.291942  / # . /lava-3387649/environment/lava-338764=
9/bin/lava-test-runner /lava-3387649/1
    2023-03-05T12:37:18.292566  =

    2023-03-05T12:37:18.298157  / # /lava-3387649/bin/lava-test-runner /lav=
a-3387649/1
    2023-03-05T12:37:18.396116  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-05T12:37:18.396596  + cd /lava-3387649/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
