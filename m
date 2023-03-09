Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D01E6B18F9
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 03:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjCICCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 21:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCICCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 21:02:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8892594744
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 18:02:42 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so707378pjg.4
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 18:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678327362;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vjm/E//vkdp60lQSA6DQahKlYYDMbPGTLGZXLypc5S4=;
        b=2YTrTc5MIp5ytdkb4eUCEK5XX//A1e6AfDDdZLItgqk6nV3CL3kpT6wPV7KT1J2WMq
         eIpZCBWYfr5nvKSW5WadjZ+mBaj/9FzsAW5CUp1db+/tOuJ35eZIxUQzkeyspr7XE3Fh
         zNbjpYf9gQOjQqG7s/Uxl3cO+sPu45OjBCWh3/IcFSzGixgNbKokk2oCYQT2OcAzGw8F
         z/AL1WpC5CgwVx3j1sud+XjHCcBDoO+YNKjGUnCbhrtcsZcD2BKJGrDvxUNPDjCvZmpG
         3FK64Ujnw1JBTVNtVFWx1UMB9e47R27fnNEFPoQ/rMs9PCXLQmpTxPioy0jyE5X63eRS
         55/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678327362;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vjm/E//vkdp60lQSA6DQahKlYYDMbPGTLGZXLypc5S4=;
        b=6aQO07DZKUhldPH1LMsG5YznmJt92SziAX1LfguNaQ2Zx0yvhh0xlTQIEUfVuRcGzM
         HWt0dIVhzeLlzpfQPTVvZByLT1aSvAN4vb5dUvw90xNeV3bnpo+9pLu7675lh8bJnjbQ
         G8jeNWImUjA/FeG4AssjQEOhPuQnBz5kqsUnzv0g6JG3UzBSo1t97BP6O+vUQJ/vZwib
         pDdq6Z/ykFWjWFIZZji/Iw/FdVTCEvfEhUDQw0SGQtm2dMTXxJvBYF2CnbR76N+iW0i3
         IATMVxrLKIJn0HXRTKBCVFYoGw+/KUY+/zW4Ar6tBhfxdxY1noSGPz9cySuaNtXuGKTk
         O9mA==
X-Gm-Message-State: AO0yUKXiyLtuf54fKZyvRa6jwvuO4JtJPCqo0rMJBCOgftSChyqE8bD/
        WcByeyEfwf1NA0gqdfaG64BPUC8FOTsmVf/m/31A4cOR
X-Google-Smtp-Source: AK7set8vR/Y8lzFA2UFa2Geqbi7E1ybcYA4qhYUMVmYBAgWsv0BRAZyclb+/DDTYI73Q7XAHn3GOAQ==
X-Received: by 2002:a05:6a20:12ce:b0:cc:c304:8d82 with SMTP id v14-20020a056a2012ce00b000ccc3048d82mr21788034pzg.7.1678327361758;
        Wed, 08 Mar 2023 18:02:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c26-20020aa78c1a000000b005a8f1187112sm9994913pfd.58.2023.03.08.18.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 18:02:41 -0800 (PST)
Message-ID: <64093e41.a70a0220.d8b45.2b6f@mx.google.com>
Date:   Wed, 08 Mar 2023 18:02:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-888-g401964048e543
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 184 runs,
 5 regressions (v6.1.15-888-g401964048e543)
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

stable-rc/queue/6.1 baseline: 184 runs, 5 regressions (v6.1.15-888-g4019640=
48e543)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
kontron-pitx-imx8m     | arm64  | lab-kontron   | gcc-10   | defconfig     =
   | 1          =

qemu_mips-malta        | mips   | lab-collabora | gcc-10   | malta_defconfi=
g  | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.15-888-g401964048e543/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.15-888-g401964048e543
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      401964048e5439fd497142357c5ff30956c50b25 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
kontron-pitx-imx8m     | arm64  | lab-kontron   | gcc-10   | defconfig     =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/64090e4dd1ab53895f8c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64090e4dd1ab53895f8c8=
64a
        new failure (last pass: v6.1.15-885-gb76254894610) =

 =



platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
qemu_mips-malta        | mips   | lab-collabora | gcc-10   | malta_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/64090933e802a250ae8c863d

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64090933e802a25=
0ae8c8641
        failing since 2 days (last pass: v6.1.15-650-g40afe6d834bf, first f=
ail: v6.1.15-660-g430daf603d29)
        1 lines

    2023-03-08T22:15:57.971319  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 20e603cc, epc =3D=3D 80201dd4, ra =3D=
=3D 80204724
    2023-03-08T22:15:57.971503  =


    2023-03-08T22:15:57.999799  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-08T22:15:57.999981  =

   =

 =



platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/640909e9db65815b1c8c864b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640909e9db65815b1c8c8=
64c
        failing since 3 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/64090a1ce789de44928c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64090a1ce789de44928c8=
641
        failing since 3 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/640909d4db65815b1c8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-88=
8-g401964048e543/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640909d4db65815b1c8c8=
631
        failing since 3 days (last pass: v6.1.15-4-gf9fbed52efb7, first fai=
l: v6.1.15-651-g1da2ded14cbf3) =

 =20
