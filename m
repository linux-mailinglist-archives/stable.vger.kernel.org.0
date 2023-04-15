Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D314E6E339B
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 22:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDOUkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 16:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjDOUke (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 16:40:34 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63484C9
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 13:40:31 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id kh6so20185191plb.0
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 13:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681591230; x=1684183230;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XvloRTLR+RHWHPrLeY0vPz0lE6Qt+h173lksvfqah38=;
        b=t4ehtxgsTBo2brz8qi34TUN5xlHw+p/MxTHmQ8zq0Pwj42ZvGhhHfQNfWEZaXKyPER
         eA/DQVsqvuNJ84mKWnwVBm68xeqlO8186AeiRxVwYIZVIul+v7uNGRKkr4VYhAZKHtxq
         /cC88DC9FwEA+sXMTuc8XdbaCVHihKpTKpTSvVRCn5lYkpbN7ngRZGMwUdRtjGSL89Zm
         ESeBGaeI313u4lyeGwL+rcvG1Vg7B1yUyfrnwrzS8/Y5vetR+0n7XkFFR30MfGgiXw3U
         F92ULTIWlrrTueLatnVFsCjcjwWj/1ShEr5IDP2pbtuJwWIV7YOWJXy9+2R6UUw5gRn1
         EluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681591230; x=1684183230;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XvloRTLR+RHWHPrLeY0vPz0lE6Qt+h173lksvfqah38=;
        b=Lk93ttV7lmojmy6olll2fLFhW8V256ryA4Z2mfaoXMH5cYgaFluaoLMKmG4HceIHIb
         OYEnh6prw951La+ldsJB2wkT6WFUdWLmgD+/nQ1TM0zfI9ATDig9rOKQO8+lhrftPGcw
         mJGjQgH40yYVW7RwR5E+jClRUvrdquzwdOMHGBlI3jY4R5hKtTBud+yOfBVv0GZE4WNS
         dkoAGbMAyPOkeGfUSBpV7l24cgWIx9EtU1xkxMt7WJvswe5Wn7EQQNQzjyBFwVM7X/X5
         LWEmAB2x3kmJhVGiS10aMo6oqH2t4IpqyGfpD4YZsMsRqPrx8/lY2qQpHKKn6HrUk3XJ
         VIKQ==
X-Gm-Message-State: AAQBX9fflxiJuufxjRtP4tX0wnn21dm9rbv0CC8VdCILXBXf+U5beEmg
        HsjRhKmglm0whqxqoz8Ej4cYx77kDIep+i9c2o6vbRJD
X-Google-Smtp-Source: AKy350ZTSSglAsbTftJbhVTaAU2S1Tu2CDsxRml2Cm/Q99iKSyxDphlKlALvYdd/HSpEvsEiuQNrCg==
X-Received: by 2002:a17:90a:de92:b0:23f:a4da:1208 with SMTP id n18-20020a17090ade9200b0023fa4da1208mr10214612pjv.39.1681591230328;
        Sat, 15 Apr 2023 13:40:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k2-20020a17090a3e8200b00246b5a609d2sm4700590pjc.27.2023.04.15.13.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 13:40:30 -0700 (PDT)
Message-ID: <643b0bbe.170a0220.35675.b209@mx.google.com>
Date:   Sat, 15 Apr 2023 13:40:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-200-gd0fa0a038a68
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 195 runs,
 13 regressions (v5.15.105-200-gd0fa0a038a68)
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

stable-rc/queue/5.15 baseline: 195 runs, 13 regressions (v5.15.105-200-gd0f=
a0a038a68)

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

kontron-pitx-imx8m           | arm64  | lab-kontron     | gcc-10   | defcon=
fig                    | 2          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-200-gd0fa0a038a68/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-200-gd0fa0a038a68
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d0fa0a038a688eee026a664a9c1e9d0abb6d991c =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad82c3e831ddc242e85ff

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad82c3e831ddc242e8604
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T17:00:19.475393  + set +x

    2023-04-15T17:00:19.481699  <8>[   10.704705] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9993621_1.4.2.3.1>

    2023-04-15T17:00:19.584184  =


    2023-04-15T17:00:19.685193  / # #export SHELL=3D/bin/sh

    2023-04-15T17:00:19.685431  =


    2023-04-15T17:00:19.786364  / # export SHELL=3D/bin/sh. /lava-9993621/e=
nvironment

    2023-04-15T17:00:19.786594  =


    2023-04-15T17:00:19.887629  / # . /lava-9993621/environment/lava-999362=
1/bin/lava-test-runner /lava-9993621/1

    2023-04-15T17:00:19.887964  =


    2023-04-15T17:00:19.893925  / # /lava-9993621/bin/lava-test-runner /lav=
a-9993621/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad82f3e831ddc242e864f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad82f3e831ddc242e8654
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T17:00:06.528954  + set +x<8>[   11.719946] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9993603_1.4.2.3.1>

    2023-04-15T17:00:06.529059  =


    2023-04-15T17:00:06.634222  / # #

    2023-04-15T17:00:06.735269  export SHELL=3D/bin/sh

    2023-04-15T17:00:06.735475  #

    2023-04-15T17:00:06.836445  / # export SHELL=3D/bin/sh. /lava-9993603/e=
nvironment

    2023-04-15T17:00:06.836655  =


    2023-04-15T17:00:06.937597  / # . /lava-9993603/environment/lava-999360=
3/bin/lava-test-runner /lava-9993603/1

    2023-04-15T17:00:06.937902  =


    2023-04-15T17:00:06.942452  / # /lava-9993603/bin/lava-test-runner /lav=
a-9993603/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad83fc86549ab4f2e860b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad83fc86549ab4f2e8610
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T17:00:21.985451  <8>[   10.974326] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9993660_1.4.2.3.1>

    2023-04-15T17:00:21.988811  + set +x

    2023-04-15T17:00:22.090748  #

    2023-04-15T17:00:22.194070  / # #export SHELL=3D/bin/sh

    2023-04-15T17:00:22.194892  =


    2023-04-15T17:00:22.296467  / # export SHELL=3D/bin/sh. /lava-9993660/e=
nvironment

    2023-04-15T17:00:22.296662  =


    2023-04-15T17:00:22.397813  / # . /lava-9993660/environment/lava-999366=
0/bin/lava-test-runner /lava-9993660/1

    2023-04-15T17:00:22.399083  =


    2023-04-15T17:00:22.404313  / # /lava-9993660/bin/lava-test-runner /lav=
a-9993660/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643adb1855ba68e9a92e861e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643adb1855ba68e9a92e8=
61f
        failing since 71 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad829a8c00bb1d62e85eb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad829a8c00bb1d62e85f0
        failing since 88 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-15T17:00:11.174111  <8>[   10.063598] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-04-15T17:00:11.174322  + set +x
    2023-04-15T17:00:11.180817  <8>[   10.074522] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3498450_1.5.2.4.1>
    2023-04-15T17:00:11.287406  / # #
    2023-04-15T17:00:11.388967  export SHELL=3D/bin/sh
    2023-04-15T17:00:11.389320  #
    2023-04-15T17:00:11.490303  / # export SHELL=3D/bin/sh. /lava-3498450/e=
nvironment
    2023-04-15T17:00:11.490690  =

    2023-04-15T17:00:11.591958  / # . /lava-3498450/environment/lava-349845=
0/bin/lava-test-runner /lava-3498450/1
    2023-04-15T17:00:11.592544   =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad87904bf50d13b2e860e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad87904bf50d13b2e8613
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T17:01:29.017137  + set +x

    2023-04-15T17:01:29.023353  <8>[   10.137020] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9993639_1.4.2.3.1>

    2023-04-15T17:01:29.128252  / # #

    2023-04-15T17:01:29.229223  export SHELL=3D/bin/sh

    2023-04-15T17:01:29.229452  #

    2023-04-15T17:01:29.330368  / # export SHELL=3D/bin/sh. /lava-9993639/e=
nvironment

    2023-04-15T17:01:29.330602  =


    2023-04-15T17:01:29.431525  / # . /lava-9993639/environment/lava-999363=
9/bin/lava-test-runner /lava-9993639/1

    2023-04-15T17:01:29.431894  =


    2023-04-15T17:01:29.436789  / # /lava-9993639/bin/lava-test-runner /lav=
a-9993639/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad817701b00c4772e8656

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad817701b00c4772e865b
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T16:59:52.387061  <8>[   10.580491] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9993614_1.4.2.3.1>

    2023-04-15T16:59:52.390404  + set +x

    2023-04-15T16:59:52.496251  =


    2023-04-15T16:59:52.598359  / # #export SHELL=3D/bin/sh

    2023-04-15T16:59:52.599021  =


    2023-04-15T16:59:52.701263  / # export SHELL=3D/bin/sh. /lava-9993614/e=
nvironment

    2023-04-15T16:59:52.701904  =


    2023-04-15T16:59:52.803713  / # . /lava-9993614/environment/lava-999361=
4/bin/lava-test-runner /lava-9993614/1

    2023-04-15T16:59:52.804931  =


    2023-04-15T16:59:52.809599  / # /lava-9993614/bin/lava-test-runner /lav=
a-9993614/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad829e0f42f2a902e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad829e0f42f2a902e85eb
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T17:00:01.438193  + <8>[   11.634937] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9993622_1.4.2.3.1>

    2023-04-15T17:00:01.438271  set +x

    2023-04-15T17:00:01.542606  / # #

    2023-04-15T17:00:01.643665  export SHELL=3D/bin/sh

    2023-04-15T17:00:01.643896  #

    2023-04-15T17:00:01.744795  / # export SHELL=3D/bin/sh. /lava-9993622/e=
nvironment

    2023-04-15T17:00:01.744987  =


    2023-04-15T17:00:01.845971  / # . /lava-9993622/environment/lava-999362=
2/bin/lava-test-runner /lava-9993622/1

    2023-04-15T17:00:01.846261  =


    2023-04-15T17:00:01.850863  / # /lava-9993622/bin/lava-test-runner /lav=
a-9993622/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad7f6f95e2858fb2e8603

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad7f6f95e2858fb2e8608
        failing since 78 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-15T16:59:10.655553  + set +x
    2023-04-15T16:59:10.655705  [    9.369791] <LAVA_SIGNAL_ENDRUN 0_dmesg =
926987_1.5.2.3.1>
    2023-04-15T16:59:10.762586  / # #
    2023-04-15T16:59:10.864249  export SHELL=3D/bin/sh
    2023-04-15T16:59:10.864724  #
    2023-04-15T16:59:10.965938  / # export SHELL=3D/bin/sh. /lava-926987/en=
vironment
    2023-04-15T16:59:10.966394  =

    2023-04-15T16:59:11.067909  / # . /lava-926987/environment/lava-926987/=
bin/lava-test-runner /lava-926987/1
    2023-04-15T16:59:11.068554  =

    2023-04-15T16:59:11.071579  / # /lava-926987/bin/lava-test-runner /lava=
-926987/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
kontron-pitx-imx8m           | arm64  | lab-kontron     | gcc-10   | defcon=
fig                    | 2          =


  Details:     https://kernelci.org/test/plan/id/643ada05d9559eca5a2e866f

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ada05d9559eca5a2e8672
        new failure (last pass: v5.15.105-189-g165b92fad56a)

    2023-04-15T17:08:13.602148  / # #
    2023-04-15T17:08:13.704627  export SHELL=3D/bin/sh
    2023-04-15T17:08:13.705398  #
    2023-04-15T17:08:13.806922  / # export SHELL=3D/bin/sh. /lava-319480/en=
vironment
    2023-04-15T17:08:13.807272  =

    2023-04-15T17:08:13.908838  / # . /lava-319480/environment/lava-319480/=
bin/lava-test-runner /lava-319480/1
    2023-04-15T17:08:13.910161  =

    2023-04-15T17:08:13.929734  / # /lava-319480/bin/lava-test-runner /lava=
-319480/1
    2023-04-15T17:08:13.975416  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-15T17:08:13.975881  + cd /l<8>[   12.210640] <LAVA_SIGNAL_START=
RUN 1_bootrr 319480_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/643=
ada05d9559eca5a2e8682
        new failure (last pass: v5.15.105-189-g165b92fad56a)

    2023-04-15T17:08:16.297868  /lava-319480/1/../bin/lava-test-case
    2023-04-15T17:08:16.298364  <8>[   14.627215] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad823b6e899ee012e8654

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad823b6e899ee012e8658
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T17:00:03.072771  + set<8>[   11.831286] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9993591_1.4.2.3.1>

    2023-04-15T17:00:03.072860   +x

    2023-04-15T17:00:03.177913  / # #

    2023-04-15T17:00:03.278651  export SHELL=3D/bin/sh

    2023-04-15T17:00:03.278873  #

    2023-04-15T17:00:03.379754  / # export SHELL=3D/bin/sh. /lava-9993591/e=
nvironment

    2023-04-15T17:00:03.379978  =


    2023-04-15T17:00:03.480931  / # . /lava-9993591/environment/lava-999359=
1/bin/lava-test-runner /lava-9993591/1

    2023-04-15T17:00:03.481204  =


    2023-04-15T17:00:03.485622  / # /lava-9993591/bin/lava-test-runner /lav=
a-9993591/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643ad97b9a91b70f3f2e8625

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-gd0fa0a038a68/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ad97b9a91b70f3f2e862a
        failing since 74 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-15T17:05:53.545107  <8>[    5.747241] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3498454_1.5.2.4.1>
    2023-04-15T17:05:53.667726  / # #
    2023-04-15T17:05:53.774130  export SHELL=3D/bin/sh
    2023-04-15T17:05:53.775827  #
    2023-04-15T17:05:53.879577  / # export SHELL=3D/bin/sh. /lava-3498454/e=
nvironment
    2023-04-15T17:05:53.881369  =

    2023-04-15T17:05:53.985230  / # . /lava-3498454/environment/lava-349845=
4/bin/lava-test-runner /lava-3498454/1
    2023-04-15T17:05:53.988469  =

    2023-04-15T17:05:54.003734  / # /lava-3498454/bin/lava-test-runner /lav=
a-3498454/1
    2023-04-15T17:05:54.129337  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
