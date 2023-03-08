Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C37B6B1440
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 22:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjCHVkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 16:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCHVkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 16:40:11 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAA7B53FC
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 13:39:32 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id nn12so186092pjb.5
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 13:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678311512;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JPhdOHgGp6NfTlKwu6ZXg2WpN9lDINPctofs9kXJ70s=;
        b=1izPpIgNnJ//YVRQAkOpP/qhcsBe7InNks4aW7TQXc1jL3LDe6KHmxNSMkta1M39PK
         mMEfF3N2okvMaBeFsb0GNZju5IsGHiYeEV20E6KgMqYbVsW1NU43tdEU5792BzQvOnmg
         /RlRV0D815jxeHKlZGbpDOAys8qFW+82xqqqwkmaGzvLG5D7ArBSweTwVOuubjmbaFct
         VO7al8BJPu7S4L48mZVGUHhCpkdKtQ4XzIsvQPFBPGl6Onjk7BoX2r62Fxh2rcPaNkcL
         /dVY5Qp0Qtpw0g431xJAbQeZ87QJGXJtKrTR4+mpKpxGoYnBt1jvqdwsfTEBBbdquhfu
         0ipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678311512;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JPhdOHgGp6NfTlKwu6ZXg2WpN9lDINPctofs9kXJ70s=;
        b=3LhjL742k2RXOKYxks82Vco97r+MvGYEOiyQmAtb3Wx1EBgEseqLp98gw/JUg1he8j
         xVgtll4YLAnNP1r39EPWT1/OCQtjAch9TXtECkbAXLLpntA+DK3S7bbt/2PbLVaa7bhR
         WLUtaWzTJBhbQRHk6M0wkq7oGsuMNtPcZ24b1vJqlFbComvl92Hw/LC8poCVWSuwmCg5
         QZMOTlvoi8RLDiuGA5mJ2vrsxgZu8gjIkA6QOUlGN2tzOp2tYXu1ltPbmb7EC6kX0cRc
         tOdH2scLOhfPMHtE6Tt9gM0nhRhDYbaom+CEChFvV+geFmkx3UFieljJZ00U+6zzJMEd
         DWoA==
X-Gm-Message-State: AO0yUKWqFU9uSU1Z49ekgEUWZ/ywSvcrO1qNb4mr0Dc6pJSWwr+SgkQC
        C/bf8XpmnihTWRNxOfyauySdtQhMc5WL5mO36zzqjw==
X-Google-Smtp-Source: AK7set9a6EDcIrVDg4AEt10MVgbaD+RaopPVodX3zxLMLDaUTmXQ4q9nf9viDC7ZLqlaj4/1xu/HbQ==
X-Received: by 2002:a05:6a20:94:b0:cb:db9d:f78d with SMTP id 20-20020a056a20009400b000cbdb9df78dmr14750931pzg.47.1678311511935;
        Wed, 08 Mar 2023 13:38:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8-20020aa79208000000b005ccbe5346ebsm9795760pfo.163.2023.03.08.13.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 13:38:31 -0800 (PST)
Message-ID: <64090057.a70a0220.745ca.30db@mx.google.com>
Date:   Wed, 08 Mar 2023 13:38:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.172-433-ga1a87af47a802
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 189 runs,
 17 regressions (v5.10.172-433-ga1a87af47a802)
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

stable-rc/linux-5.10.y baseline: 189 runs, 17 regressions (v5.10.172-433-ga=
1a87af47a802)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
cubietruck             | arm    | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig           | 1          =

qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =

qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =

qemu_i386-uefi         | i386   | lab-collabora | gcc-10   | i386_defconfig=
               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =

r8a7743-iwg20d-q7      | arm    | lab-cip       | gcc-10   | shmobile_defco=
nfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.172-433-ga1a87af47a802/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.172-433-ga1a87af47a802
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1a87af47a80231d1737d23ea5f044cc99ac84c0 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
cubietruck             | arm    | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cd29c37747bf0f8c865a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6408cd29c37747bf0f8c8663
        failing since 49 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-08T17:59:39.385005  <8>[   11.063667] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3398281_1.5.2.4.1>
    2023-03-08T17:59:39.491980  / # #
    2023-03-08T17:59:39.596157  export SHELL=3D/bin/sh
    2023-03-08T17:59:39.596716  #
    2023-03-08T17:59:39.698338  / # export SHELL=3D/bin/sh. /lava-3398281/e=
nvironment
    2023-03-08T17:59:39.698819  =

    2023-03-08T17:59:39.800096  / # . /lava-3398281/environment/lava-339828=
1/bin/lava-test-runner /lava-3398281/1
    2023-03-08T17:59:39.800908  =

    2023-03-08T17:59:39.806449  / # /lava-3398281/bin/lava-test-runner /lav=
a-3398281/1
    2023-03-08T17:59:39.889769  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cc200846c8b8858c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cc200846c8b8858c8=
631
        failing since 22 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cc44b5caa06b008c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_=
i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_=
i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cc44b5caa06b008c8=
633
        failing since 22 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-collabora | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cc240846c8b8858c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qem=
u_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qem=
u_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cc240846c8b8858c8=
636
        failing since 22 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6408caf6fac50d8a1b8c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bay=
libre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bay=
libre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408caf6fac50d8a1b8c8=
65a
        failing since 22 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cceb0a97c4d97a8c864f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-=
qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-=
qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cceb0a97c4d97a8c8=
650
        failing since 21 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cb41543b8aacc38c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bro=
onie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bro=
onie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cb41543b8aacc38c8=
653
        failing since 22 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cd84fb8dd9c5f98c866d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-q=
emu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-q=
emu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cd84fb8dd9c5f98c8=
66e
        failing since 21 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cabc72c159c6a48c866b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cabc72c159c6a48c8=
66c
        failing since 22 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6408ccc4f2c36420368c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline=
-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline=
-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408ccc4f2c36420368c8=
635
        failing since 21 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6408caf420731475bb8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bay=
libre/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bay=
libre/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408caf420731475bb8c8=
631
        failing since 21 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cced0a97c4d97a8c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-=
qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-=
qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cced0a97c4d97a8c8=
653
        failing since 21 days (last pass: v5.10.166-100-ge9ce3cb0864d, firs=
t fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cb40fa0ae897b78c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bro=
onie/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bro=
onie/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cb40fa0ae897b78c8=
644
        failing since 21 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cd86fb8dd9c5f98c8670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-q=
emu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-q=
emu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cd86fb8dd9c5f98c8=
671
        failing since 21 days (last pass: v5.10.166-100-ge9ce3cb0864d, firs=
t fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6408cabad8d6e541298c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408cabad8d6e541298c8=
64a
        failing since 21 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6408ccda8fbdfbef0b8c8656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline=
-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline=
-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408ccda8fbdfbef0b8c8=
657
        failing since 21 days (last pass: v5.10.166-100-ge9ce3cb0864d, firs=
t fail: v5.10.167-135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
r8a7743-iwg20d-q7      | arm    | lab-cip       | gcc-10   | shmobile_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6408ca1f1a951c00658c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72-433-ga1a87af47a802/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6408ca1f1a951c00658c8=
649
        failing since 4 days (last pass: v5.10.170, first fail: v5.10.172) =

 =20
