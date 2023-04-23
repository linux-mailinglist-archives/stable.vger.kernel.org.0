Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035D36EC21D
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 21:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDWTwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 15:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWTwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 15:52:16 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33169FE
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 12:52:14 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a8097c1ccfso42526915ad.1
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 12:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682279533; x=1684871533;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aO1d+at2FImBvUkg/KtrlFfqG7XYcbjA64Plwdsoi3g=;
        b=vXAlJ2GFVHIMK/nOrEpzC3E7+G+5445tsXpcnHcGqnaJBjCj1eRnjPDtKozai6tH+q
         l0HKpjWjjnq14bAck7Z6m3ltHsaEI6loFn3EcYjFHGAqniK6nc+Crs4/o5VS5bFsoo3P
         k3w3Gpw926XgIipyld+FBryehbmpai4nXPwNvGDesZCP3Zi5hqlkpKhJO3N+QR32s7fJ
         LGvN+gbmYW+x1/pF/oJV7z9hpGrqjznrn8uTJWBJ4wHbL2nFUy6y/C8tWcJ61gRDeAhR
         ULs5RUVUg2bF+tfVrP8A3IkfmLBupWFYjdXakpS8nC46h0rzreRIfnjGZA/3q34hlWJ7
         OAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682279533; x=1684871533;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aO1d+at2FImBvUkg/KtrlFfqG7XYcbjA64Plwdsoi3g=;
        b=Q6bZY9u5SnfGP7aKq8XdRe5XBrIxxQ1TqdGVmhnKduHi4a1xCDCpeMdZTynyQM2Fim
         fK2w+dvEhikfecvGNIJfhLjYgi1YzrE82aGjFOJwmkLrv+3AnXg6cAFAT6vlQjPibDgW
         xa/EE1GZ1ZAFW16qPw1qWcWSXXsT6rR1WW14xmKi3+d14HP0y+pZ+5YebmkwScTPJy55
         DtLJ+/P5nnSf9BdLYdpVZHp3JZn+7ktLP7XxVPL+AO29sap9+7vNpPM+mNyuiHcqfZ9+
         tOcDDobpmAsRqQn0DuJk8T4lNYYigrpqTV/gDEECyvgilzzDdPqhEVi/aDQHuTnwfxI1
         abvg==
X-Gm-Message-State: AAQBX9c7lZC0HQ2fu9n1cB+fzlliXPamLEEhb37oEXMDrtpjqLQ6+JRb
        b5581vvFbkKBX5CENi3fI41Ot6gs7uGi84nE5wM8rw==
X-Google-Smtp-Source: AKy350ZVWYZAAm5f/BZkahDVm2WBcsDZWCC649f39TYwFB8IVSLUTssGZ5dh8tvjUMwMcmF87KhKoQ==
X-Received: by 2002:a17:902:d504:b0:1a9:6f1f:18b with SMTP id b4-20020a170902d50400b001a96f1f018bmr3291785plg.21.1682279533278;
        Sun, 23 Apr 2023 12:52:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z10-20020a630a4a000000b0051b93103665sm5249866pgk.63.2023.04.23.12.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 12:52:12 -0700 (PDT)
Message-ID: <64458c6c.630a0220.607b.a1ff@mx.google.com>
Date:   Sun, 23 Apr 2023 12:52:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-335-gdcaf21fa73a73
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 137 runs,
 10 regressions (v5.15.105-335-gdcaf21fa73a73)
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

stable-rc/queue/5.15 baseline: 137 runs, 10 regressions (v5.15.105-335-gdca=
f21fa73a73)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-335-gdcaf21fa73a73/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-335-gdcaf21fa73a73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dcaf21fa73a7395e15f0857616e4a4352cb735ac =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644555dc1ccc9209e42e8645

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644555dc1ccc9209e42e864a
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T15:59:01.292972  <8>[   10.416863] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10094459_1.4.2.3.1>

    2023-04-23T15:59:01.296260  + set +x

    2023-04-23T15:59:01.401062  #

    2023-04-23T15:59:01.401879  =


    2023-04-23T15:59:01.503576  / # #export SHELL=3D/bin/sh

    2023-04-23T15:59:01.504471  =


    2023-04-23T15:59:01.606331  / # export SHELL=3D/bin/sh. /lava-10094459/=
environment

    2023-04-23T15:59:01.607174  =


    2023-04-23T15:59:01.709059  / # . /lava-10094459/environment/lava-10094=
459/bin/lava-test-runner /lava-10094459/1

    2023-04-23T15:59:01.709327  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644555d067227192ea2e85f3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644555d067227192ea2e85f8
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T15:58:47.612016  + set<8>[   11.416744] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10094489_1.4.2.3.1>

    2023-04-23T15:58:47.612110   +x

    2023-04-23T15:58:47.717046  / # #

    2023-04-23T15:58:47.818787  export SHELL=3D/bin/sh

    2023-04-23T15:58:47.819041  #

    2023-04-23T15:58:47.920240  / # export SHELL=3D/bin/sh. /lava-10094489/=
environment

    2023-04-23T15:58:47.921002  =


    2023-04-23T15:58:48.022639  / # . /lava-10094489/environment/lava-10094=
489/bin/lava-test-runner /lava-10094489/1

    2023-04-23T15:58:48.023971  =


    2023-04-23T15:58:48.028491  / # /lava-10094489/bin/lava-test-runner /la=
va-10094489/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644555d21ccc9209e42e8620

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644555d21ccc9209e42e8625
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T15:58:53.146851  <8>[   10.743453] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10094466_1.4.2.3.1>

    2023-04-23T15:58:53.150034  + set +x

    2023-04-23T15:58:53.251624  #

    2023-04-23T15:58:53.352922  / # #export SHELL=3D/bin/sh

    2023-04-23T15:58:53.353144  =


    2023-04-23T15:58:53.454049  / # export SHELL=3D/bin/sh. /lava-10094466/=
environment

    2023-04-23T15:58:53.454277  =


    2023-04-23T15:58:53.555112  / # . /lava-10094466/environment/lava-10094=
466/bin/lava-test-runner /lava-10094466/1

    2023-04-23T15:58:53.555444  =


    2023-04-23T15:58:53.560292  / # /lava-10094466/bin/lava-test-runner /la=
va-10094466/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/644557dd0e47a50d5a2e85f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644557dd0e47a50d5a2e8=
5f7
        failing since 79 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6445582a4ff80aaec92e860c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445582a4ff80aaec92e8611
        failing since 96 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-23T16:08:56.508850  + set +x<8>[    9.935471] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3524744_1.5.2.4.1>
    2023-04-23T16:08:56.509502  =

    2023-04-23T16:08:56.618108  / # #
    2023-04-23T16:08:56.720498  export SHELL=3D/bin/sh
    2023-04-23T16:08:56.721334  #
    2023-04-23T16:08:56.823322  / # export SHELL=3D/bin/sh. /lava-3524744/e=
nvironment
    2023-04-23T16:08:56.824158  =

    2023-04-23T16:08:56.926007  / # . /lava-3524744/environment/lava-352474=
4/bin/lava-test-runner /lava-3524744/1
    2023-04-23T16:08:56.927383  =

    2023-04-23T16:08:56.927803  / # <3>[   10.272806] Bluetooth: hci0: comm=
and 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644555c478a58978332e85f9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644555c478a58978332e85fe
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T15:58:49.604239  + set +x

    2023-04-23T15:58:49.611082  <8>[   10.823415] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10094476_1.4.2.3.1>

    2023-04-23T15:58:49.715687  / # #

    2023-04-23T15:58:49.816711  export SHELL=3D/bin/sh

    2023-04-23T15:58:49.816886  #

    2023-04-23T15:58:49.917638  / # export SHELL=3D/bin/sh. /lava-10094476/=
environment

    2023-04-23T15:58:49.917837  =


    2023-04-23T15:58:50.018775  / # . /lava-10094476/environment/lava-10094=
476/bin/lava-test-runner /lava-10094476/1

    2023-04-23T15:58:50.019141  =


    2023-04-23T15:58:50.023932  / # /lava-10094476/bin/lava-test-runner /la=
va-10094476/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644555c978a58978332e8620

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644555c978a58978332e8625
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T15:58:51.590381  <8>[   10.788170] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10094411_1.4.2.3.1>

    2023-04-23T15:58:51.593345  + set +x

    2023-04-23T15:58:51.698743  / # #

    2023-04-23T15:58:51.799779  export SHELL=3D/bin/sh

    2023-04-23T15:58:51.799984  #

    2023-04-23T15:58:51.900927  / # export SHELL=3D/bin/sh. /lava-10094411/=
environment

    2023-04-23T15:58:51.901134  =


    2023-04-23T15:58:52.002202  / # . /lava-10094411/environment/lava-10094=
411/bin/lava-test-runner /lava-10094411/1

    2023-04-23T15:58:52.003539  =


    2023-04-23T15:58:52.008883  / # /lava-10094411/bin/lava-test-runner /la=
va-10094411/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644555cda71b1313802e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644555cda71b1313802e85eb
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T15:58:45.716858  + set<8>[   11.209208] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10094445_1.4.2.3.1>

    2023-04-23T15:58:45.716936   +x

    2023-04-23T15:58:45.822107  / # #

    2023-04-23T15:58:45.923272  export SHELL=3D/bin/sh

    2023-04-23T15:58:45.923981  #

    2023-04-23T15:58:46.025593  / # export SHELL=3D/bin/sh. /lava-10094445/=
environment

    2023-04-23T15:58:46.025775  =


    2023-04-23T15:58:46.126824  / # . /lava-10094445/environment/lava-10094=
445/bin/lava-test-runner /lava-10094445/1

    2023-04-23T15:58:46.128106  =


    2023-04-23T15:58:46.132541  / # /lava-10094445/bin/lava-test-runner /la=
va-10094445/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644557bdae9248fb3c2e85e6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644557bdae9248fb3c2e85eb
        failing since 86 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-23T16:07:17.652909  + set +x
    2023-04-23T16:07:17.653075  [    9.410831] <LAVA_SIGNAL_ENDRUN 0_dmesg =
934921_1.5.2.3.1>
    2023-04-23T16:07:17.760099  / # #
    2023-04-23T16:07:17.861645  export SHELL=3D/bin/sh
    2023-04-23T16:07:17.862120  #
    2023-04-23T16:07:17.963399  / # export SHELL=3D/bin/sh. /lava-934921/en=
vironment
    2023-04-23T16:07:17.963979  =

    2023-04-23T16:07:18.065265  / # . /lava-934921/environment/lava-934921/=
bin/lava-test-runner /lava-934921/1
    2023-04-23T16:07:18.065814  =

    2023-04-23T16:07:18.068323  / # /lava-934921/bin/lava-test-runner /lava=
-934921/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644555cde6e2838e312e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-335-gdcaf21fa73a73/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644555cde6e2838e312e85eb
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T15:58:53.481893  + set +x<8>[   11.664683] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10094424_1.4.2.3.1>

    2023-04-23T15:58:53.481987  =


    2023-04-23T15:58:53.586658  / # #

    2023-04-23T15:58:53.687627  export SHELL=3D/bin/sh

    2023-04-23T15:58:53.687849  #

    2023-04-23T15:58:53.788743  / # export SHELL=3D/bin/sh. /lava-10094424/=
environment

    2023-04-23T15:58:53.788952  =


    2023-04-23T15:58:53.889835  / # . /lava-10094424/environment/lava-10094=
424/bin/lava-test-runner /lava-10094424/1

    2023-04-23T15:58:53.890118  =


    2023-04-23T15:58:53.894650  / # /lava-10094424/bin/lava-test-runner /la=
va-10094424/1
 =

    ... (12 line(s) more)  =

 =20
