Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87AF16E6395
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjDRMly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjDRMlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:41:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62986146F6
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:30 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1a50cb65c92so24035925ad.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681821689; x=1684413689;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tHtiWZ2mfh4gheT1QqNdn236zoH4K/BIauoJt1uSJko=;
        b=NXWxscixnNuKDN53eJUUbDfWO0PmFv+FGtjX7dliKvqLTILRxOedbkLn/CnjPQCNgO
         koKZHb1s1UUkhWiCFN6rNAT8ySDo00nTth9b3K2m6uV+GSxET8QK848o90da9il9IY02
         RxehwBl6mbJPIUnd9w5An87flKK/Mdxftpb9zeiqDEVp4olzoh3k0+aCD2XLUWVdYozu
         zZzCOqpQYP9giwwoL/9LNAp0L9+x9Uak05NIMpGqMlx9tkKsMds18S9xNrcUGjwmkMES
         hiO8HmjcOw0EwQBuVLgLt+jRZqpopKtc0vBaiWK46jVtZvKDKrmlqjstKjDwENr3lNbf
         qRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681821689; x=1684413689;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tHtiWZ2mfh4gheT1QqNdn236zoH4K/BIauoJt1uSJko=;
        b=G5AlVJS9jWywIOAewvaMxNWYbnNV7sUEDw62CUOh/FWxeNFMjs/FM9Z2aIorX2Kre/
         LEq3x6/6Xe1Es1JD99zVyR5DKndRSlBRD6Ep6h0nIxdZouxJoq2I0W81Yu334Hz9oPo5
         pXjqhXJXGzdmF6ooewTxxpH0V+HizW7YYOcxIJIIvdNJJnDkf50IeuPyVPqv3phcc2Se
         L+/lqvy1T0uhhrv8GSjDucgcmA0t8lvLgM4WQt54uKr1dz1nsPL3KRpk+b5iMdJ5fjjK
         hNazLpsM6WZHZotlAeIijuihtOLqCywYdPKaE/aPFXWL1N9JWuayXAQPtsIboe27w46q
         NGPw==
X-Gm-Message-State: AAQBX9em66hlLQ/fnNNfHgN9TOr00LRIzOtJnEAQzn3fhc2uysUJZl3N
        pjJQfoJViwPkpiuX/j6RMa08udrMOiEa6YsPQIEp2GeP
X-Google-Smtp-Source: AKy350aAKl6uR/zc4pSiXRaiecdKjs83NYaDjPAKCXdqUCxB7Zx6QKGIGt8mTrFL4UXQeJPr5RpR4w==
X-Received: by 2002:a17:903:1107:b0:1a6:9ec6:6a92 with SMTP id n7-20020a170903110700b001a69ec66a92mr2147328plh.55.1681821688951;
        Tue, 18 Apr 2023 05:41:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b001a5240aa535sm9511420pls.37.2023.04.18.05.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 05:41:28 -0700 (PDT)
Message-ID: <643e8ff8.170a0220.30e96.4f23@mx.google.com>
Date:   Tue, 18 Apr 2023 05:41:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-273-g830df8f2357a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 170 runs,
 19 regressions (v5.15.105-273-g830df8f2357a)
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

stable-rc/queue/5.15 baseline: 170 runs, 19 regressions (v5.15.105-273-g830=
df8f2357a)

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

dell-latitude...4305U-sarien | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
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

qemu_riscv64                 | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_riscv64                 | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_riscv64                 | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-273-g830df8f2357a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-273-g830df8f2357a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      830df8f2357a324dce0f201cb3a7f6fb6eba5be1 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5d1291424a20d12e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e5d1291424a20d12e85fc
        failing since 20 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-18T09:03:11.225780  <8>[   10.145117] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024855_1.4.2.3.1>

    2023-04-18T09:03:11.229298  + set +x

    2023-04-18T09:03:11.337934  / # #

    2023-04-18T09:03:11.440738  export SHELL=3D/bin/sh

    2023-04-18T09:03:11.441617  #

    2023-04-18T09:03:11.543656  / # export SHELL=3D/bin/sh. /lava-10024855/=
environment

    2023-04-18T09:03:11.544466  =


    2023-04-18T09:03:11.646555  / # . /lava-10024855/environment/lava-10024=
855/bin/lava-test-runner /lava-10024855/1

    2023-04-18T09:03:11.647795  =


    2023-04-18T09:03:11.654628  / # /lava-10024855/bin/lava-test-runner /la=
va-10024855/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5cf8c36c69085a2e85f0

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e5cf8c36c69085a2e85f5
        failing since 20 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-18T09:03:01.839794  + set<8>[   10.867021] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10024878_1.4.2.3.1>

    2023-04-18T09:03:01.840383   +x

    2023-04-18T09:03:01.948791  / # #

    2023-04-18T09:03:02.051920  export SHELL=3D/bin/sh

    2023-04-18T09:03:02.052742  #

    2023-04-18T09:03:02.154936  / # export SHELL=3D/bin/sh. /lava-10024878/=
environment

    2023-04-18T09:03:02.155754  =


    2023-04-18T09:03:02.257994  / # . /lava-10024878/environment/lava-10024=
878/bin/lava-test-runner /lava-10024878/1

    2023-04-18T09:03:02.259259  =


    2023-04-18T09:03:02.263790  / # /lava-10024878/bin/lava-test-runner /la=
va-10024878/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5cf372fbe7a38a2e85fd

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e5cf372fbe7a38a2e8602
        failing since 20 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-18T09:02:49.840274  <8>[   10.067599] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024879_1.4.2.3.1>

    2023-04-18T09:02:49.843006  + set +x

    2023-04-18T09:02:49.946246  =


    2023-04-18T09:02:50.048356  / # #export SHELL=3D/bin/sh

    2023-04-18T09:02:50.049107  =


    2023-04-18T09:02:50.150962  / # export SHELL=3D/bin/sh. /lava-10024879/=
environment

    2023-04-18T09:02:50.151720  =


    2023-04-18T09:02:50.253644  / # . /lava-10024879/environment/lava-10024=
879/bin/lava-test-runner /lava-10024879/1

    2023-04-18T09:02:50.254916  =


    2023-04-18T09:02:50.259762  / # /lava-10024879/bin/lava-test-runner /la=
va-10024879/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5e0c2a37c50c792e85fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5e0d2a37c50c792e8=
5ff
        failing since 73 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5f4eefe42acf832e85e6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e5f4eefe42acf832e85eb
        failing since 91 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-18T09:13:23.402372  + set +x<8>[    9.975497] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3506126_1.5.2.4.1>
    2023-04-18T09:13:23.403127  =

    2023-04-18T09:13:23.512925  / # #
    2023-04-18T09:13:23.616573  export SHELL=3D/bin/sh
    2023-04-18T09:13:23.617635  #
    2023-04-18T09:13:23.720201  / # export SHELL=3D/bin/sh. /lava-3506126/e=
nvironment
    2023-04-18T09:13:23.721493  =

    2023-04-18T09:13:23.823974  / # . /lava-3506126/environment/lava-350612=
6/bin/lava-test-runner /lava-3506126/1
    2023-04-18T09:13:23.825893  =

    2023-04-18T09:13:23.830546  / # /lava-3506126/bin/lava-test-runner /lav=
a-3506126/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5de141117ec5f02e8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5de141117ec5f02e8=
632
        new failure (last pass: v5.15.105-254-g9b84e4a2f259) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5b64d58f9d6b162e85ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5b64d58f9d6b162e8=
5f0
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5d48ee46b096932e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e5d48ee46b096932e85ee
        failing since 20 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-18T09:03:26.373461  + set +x

    2023-04-18T09:03:26.380275  <8>[   10.221671] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024909_1.4.2.3.1>

    2023-04-18T09:03:26.489051  / # #

    2023-04-18T09:03:26.592317  export SHELL=3D/bin/sh

    2023-04-18T09:03:26.593186  #

    2023-04-18T09:03:26.695231  / # export SHELL=3D/bin/sh. /lava-10024909/=
environment

    2023-04-18T09:03:26.696101  =


    2023-04-18T09:03:26.798072  / # . /lava-10024909/environment/lava-10024=
909/bin/lava-test-runner /lava-10024909/1

    2023-04-18T09:03:26.799529  =


    2023-04-18T09:03:26.804396  / # /lava-10024909/bin/lava-test-runner /la=
va-10024909/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5ce3525d59b61e2e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e5ce3525d59b61e2e85f0
        failing since 20 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-18T09:02:49.265479  + set +x

    2023-04-18T09:02:49.272509  <8>[   10.115307] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024892_1.4.2.3.1>

    2023-04-18T09:02:49.380025  / # #

    2023-04-18T09:02:49.482042  export SHELL=3D/bin/sh

    2023-04-18T09:02:49.482724  #

    2023-04-18T09:02:49.584449  / # export SHELL=3D/bin/sh. /lava-10024892/=
environment

    2023-04-18T09:02:49.585159  =


    2023-04-18T09:02:49.687168  / # . /lava-10024892/environment/lava-10024=
892/bin/lava-test-runner /lava-10024892/1

    2023-04-18T09:02:49.688276  =


    2023-04-18T09:02:49.693603  / # /lava-10024892/bin/lava-test-runner /la=
va-10024892/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5cedffd4156e432e85f1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e5cedffd4156e432e85f6
        failing since 20 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-18T09:02:54.374357  + <8>[   11.004555] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10024923_1.4.2.3.1>

    2023-04-18T09:02:54.374938  set +x

    2023-04-18T09:02:54.483448  / # #

    2023-04-18T09:02:54.586360  export SHELL=3D/bin/sh

    2023-04-18T09:02:54.587160  #

    2023-04-18T09:02:54.689249  / # export SHELL=3D/bin/sh. /lava-10024923/=
environment

    2023-04-18T09:02:54.690050  =


    2023-04-18T09:02:54.792005  / # . /lava-10024923/environment/lava-10024=
923/bin/lava-test-runner /lava-10024923/1

    2023-04-18T09:02:54.793261  =


    2023-04-18T09:02:54.798044  / # /lava-10024923/bin/lava-test-runner /la=
va-10024923/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5f2725271b11e92e85f1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e5f2725271b11e92e85f6
        failing since 80 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-18T09:13:03.951362  + set +x
    2023-04-18T09:13:03.951621  [    9.409378] <LAVA_SIGNAL_ENDRUN 0_dmesg =
928795_1.5.2.3.1>
    2023-04-18T09:13:04.058706  / # #
    2023-04-18T09:13:04.160609  export SHELL=3D/bin/sh
    2023-04-18T09:13:04.161129  #
    2023-04-18T09:13:04.262438  / # export SHELL=3D/bin/sh. /lava-928795/en=
vironment
    2023-04-18T09:13:04.263000  =

    2023-04-18T09:13:04.364348  / # . /lava-928795/environment/lava-928795/=
bin/lava-test-runner /lava-928795/1
    2023-04-18T09:13:04.364996  =

    2023-04-18T09:13:04.367495  / # /lava-928795/bin/lava-test-runner /lava=
-928795/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5d0e6e2648b2f12e85f5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e5d0e6e2648b2f12e85fa
        failing since 20 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-18T09:03:14.699969  <8>[   11.545668] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024935_1.4.2.3.1>

    2023-04-18T09:03:14.808621  / # #

    2023-04-18T09:03:14.911542  export SHELL=3D/bin/sh

    2023-04-18T09:03:14.912436  #

    2023-04-18T09:03:15.014209  / # export SHELL=3D/bin/sh. /lava-10024935/=
environment

    2023-04-18T09:03:15.015088  =


    2023-04-18T09:03:15.117421  / # . /lava-10024935/environment/lava-10024=
935/bin/lava-test-runner /lava-10024935/1

    2023-04-18T09:03:15.118848  =


    2023-04-18T09:03:15.123246  / # /lava-10024935/bin/lava-test-runner /la=
va-10024935/1

    2023-04-18T09:03:15.129253  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5b8d708641b5692e85f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5b8d708641b5692e8=
5f1
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5b9db23d0755872e85f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5b9db23d0755872e8=
5f7
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5ae958cd073ca62e85f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5ae958cd073ca62e8=
5f8
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5b880f46a4d1472e85e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5b880f46a4d1472e8=
5e9
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5b8885f58afca32e85eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5b8885f58afca32e8=
5ec
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643e5ae7cf7f9d89722e8620

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643e5ae7cf7f9d89722e8=
621
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643e579146380b8db72e85e6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-273-g830df8f2357a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e579146380b8db72e85eb
        failing since 76 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-18T08:40:25.959095  / # #
    2023-04-18T08:40:26.064734  export SHELL=3D/bin/sh
    2023-04-18T08:40:26.066535  #
    2023-04-18T08:40:26.170184  / # export SHELL=3D/bin/sh. /lava-3505958/e=
nvironment
    2023-04-18T08:40:26.171721  =

    2023-04-18T08:40:26.275274  / # . /lava-3505958/environment/lava-350595=
8/bin/lava-test-runner /lava-3505958/1
    2023-04-18T08:40:26.278005  =

    2023-04-18T08:40:26.285066  / # /lava-3505958/bin/lava-test-runner /lav=
a-3505958/1
    2023-04-18T08:40:26.414874  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-18T08:40:26.415937  + cd /lava-3505958/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
