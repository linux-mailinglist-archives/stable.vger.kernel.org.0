Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45D26E3A55
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 18:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjDPQuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 12:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDPQuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 12:50:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C88C2136
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 09:50:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id f2so14663395pjs.3
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 09:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681663817; x=1684255817;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FFlFnjPmmLPQmVHPJTeNlzy/LwfUNR7khlTLmvjm2zc=;
        b=Q/yn8paExy46l6YWPld0z9j3jIf5EDITaEw67sANIrRwCw+DL5qRe2YkC+UdiDT0V9
         i4c4u1v9c9ztDp5n2pDbpApsOi5aM1FWuBbxZQycsFNkf7sAfDY9KKkAQ8dPVpgGYBqn
         5/FT1OGzJC9h7GLkBxpub+8BIydF/23qIzmyuBTkqOMGY2wkBOvXsgdvpxIvdB80fltn
         AhH5O3+GFuvBWW2D1NwNMysWXaHTfShAWKKvCaNnWangQrY2+gMgzuGy6SgxUxqIZeTz
         VVgt8HlC+EhxA6K8UgGd4XJL6Y6r0toOxsxkhDcUq24sDo8al79+h+SZT3bisaexmIDC
         bs/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681663817; x=1684255817;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FFlFnjPmmLPQmVHPJTeNlzy/LwfUNR7khlTLmvjm2zc=;
        b=XteFEeeEfzRc21sja4B41rk1OyPtPgyFt0bwjIGNXoFLzV7/RmZ6XKDlG6ec8tbySt
         hVUBpNSZ0taTLs9Je6wLnd8X0budwuWdxuCEfy8CoIZucEIjHaLW+tm1DkuKPdZehc2P
         TTxil6D7j04SuUhYclArSBUQcCjWa3a1qHrYMHmnjO+o6m5NwxXYjyv8EOi9B2Xd/JBY
         h1bvXrA0MVe8dGeigdXXMudwBI21lz7RJvDdLNz2BcKfN2Fi3gaV+ZQPS7z24PNzkOJy
         V1ihUcTOxoGY0D8ZRpi92wM2EdNPB9bYUFmKDW7J+fSBSG4BaG6RAK9sWDdLcVe59ZQ+
         wxAA==
X-Gm-Message-State: AAQBX9fdLXlDjn/7p68dCA7j9UuKPlcoga7gA6G38URSDqPF2jvGyjYm
        v1+xOqATYj1kItmsbLjttmufwjo2azu3RHfBFInwWojQ
X-Google-Smtp-Source: AKy350Z7G87ZQUUkfkv5v0A0N7oJy0fk8/r9RMmrRokZ1aHAGaiVuol55rH2UFtgzZeaBGGsD4STPQ==
X-Received: by 2002:a17:902:c70c:b0:1a6:95c3:74a with SMTP id p12-20020a170902c70c00b001a695c3074amr7735216plp.17.1681663816571;
        Sun, 16 Apr 2023 09:50:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b001a6ad899eaesm3053630plk.18.2023.04.16.09.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 09:50:16 -0700 (PDT)
Message-ID: <643c2748.170a0220.2bbd0.61d8@mx.google.com>
Date:   Sun, 16 Apr 2023 09:50:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-372-gb440657ec84e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 162 runs,
 8 regressions (v6.1.22-372-gb440657ec84e)
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

stable-rc/queue/6.1 baseline: 162 runs, 8 regressions (v6.1.22-372-gb440657=
ec84e)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-372-gb440657ec84e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-372-gb440657ec84e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b440657ec84e4888ffcb093c8cea4775022f8149 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf092d3d63b80682e8603

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf092d3d63b80682e8608
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T12:56:31.655617  <8>[   10.985920] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10004948_1.4.2.3.1>

    2023-04-16T12:56:31.659682  + set +x

    2023-04-16T12:56:31.767543  / # #

    2023-04-16T12:56:31.870595  export SHELL=3D/bin/sh

    2023-04-16T12:56:31.871434  #

    2023-04-16T12:56:31.973737  / # export SHELL=3D/bin/sh. /lava-10004948/=
environment

    2023-04-16T12:56:31.974562  =


    2023-04-16T12:56:32.076436  / # . /lava-10004948/environment/lava-10004=
948/bin/lava-test-runner /lava-10004948/1

    2023-04-16T12:56:32.077808  =


    2023-04-16T12:56:32.083902  / # /lava-10004948/bin/lava-test-runner /la=
va-10004948/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf097bb5a2236b12e8606

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf097bb5a2236b12e860b
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T12:56:38.567496  + set<8>[   11.208255] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10004993_1.4.2.3.1>

    2023-04-16T12:56:38.568106   +x

    2023-04-16T12:56:38.676450  / # #

    2023-04-16T12:56:38.779218  export SHELL=3D/bin/sh

    2023-04-16T12:56:38.779488  #

    2023-04-16T12:56:38.880846  / # export SHELL=3D/bin/sh. /lava-10004993/=
environment

    2023-04-16T12:56:38.881654  =


    2023-04-16T12:56:38.983647  / # . /lava-10004993/environment/lava-10004=
993/bin/lava-test-runner /lava-10004993/1

    2023-04-16T12:56:38.985019  =


    2023-04-16T12:56:38.990049  / # /lava-10004993/bin/lava-test-runner /la=
va-10004993/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf0961983e81f802e8653

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf0961983e81f802e8658
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T12:56:37.118158  <8>[   10.013203] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10004971_1.4.2.3.1>

    2023-04-16T12:56:37.121424  + set +x

    2023-04-16T12:56:37.226921  #

    2023-04-16T12:56:37.228528  =


    2023-04-16T12:56:37.330988  / # #export SHELL=3D/bin/sh

    2023-04-16T12:56:37.331811  =


    2023-04-16T12:56:37.434150  / # export SHELL=3D/bin/sh. /lava-10004971/=
environment

    2023-04-16T12:56:37.434956  =


    2023-04-16T12:56:37.537026  / # . /lava-10004971/environment/lava-10004=
971/bin/lava-test-runner /lava-10004971/1

    2023-04-16T12:56:37.538316  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf22901abad5f4f2e8624

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf22901abad5f4f2e8657
        failing since 0 day (last pass: v6.1.22-364-gf7dc7e601a2a, first fa=
il: v6.1.22-364-g39097b93e319)

    2023-04-16T13:03:11.266902  + set +x
    2023-04-16T13:03:11.270805  <8>[   16.780826] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 337033_1.5.2.4.1>
    2023-04-16T13:03:11.384498  / # #
    2023-04-16T13:03:11.486560  export SHELL=3D/bin/sh
    2023-04-16T13:03:11.487049  #
    2023-04-16T13:03:11.588598  / # export SHELL=3D/bin/sh. /lava-337033/en=
vironment
    2023-04-16T13:03:11.589073  =

    2023-04-16T13:03:11.690609  / # . /lava-337033/environment/lava-337033/=
bin/lava-test-runner /lava-337033/1
    2023-04-16T13:03:11.691439  =

    2023-04-16T13:03:11.697313  / # /lava-337033/bin/lava-test-runner /lava=
-337033/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf080118b6402cd2e8652

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf080118b6402cd2e8657
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T12:56:24.283704  + set +x

    2023-04-16T12:56:24.290394  <8>[   10.699862] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005009_1.4.2.3.1>

    2023-04-16T12:56:24.394929  / # #

    2023-04-16T12:56:24.495960  export SHELL=3D/bin/sh

    2023-04-16T12:56:24.496152  #

    2023-04-16T12:56:24.597073  / # export SHELL=3D/bin/sh. /lava-10005009/=
environment

    2023-04-16T12:56:24.597257  =


    2023-04-16T12:56:24.698306  / # . /lava-10005009/environment/lava-10005=
009/bin/lava-test-runner /lava-10005009/1

    2023-04-16T12:56:24.698590  =


    2023-04-16T12:56:24.703410  / # /lava-10005009/bin/lava-test-runner /la=
va-10005009/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf080118b6402cd2e8647

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf080118b6402cd2e864c
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T12:56:13.733728  + set<8>[   10.135281] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10005013_1.4.2.3.1>

    2023-04-16T12:56:13.733816   +x

    2023-04-16T12:56:13.835838  #

    2023-04-16T12:56:13.937134  / # #export SHELL=3D/bin/sh

    2023-04-16T12:56:13.937338  =


    2023-04-16T12:56:14.038414  / # export SHELL=3D/bin/sh. /lava-10005013/=
environment

    2023-04-16T12:56:14.038606  =


    2023-04-16T12:56:14.139564  / # . /lava-10005013/environment/lava-10005=
013/bin/lava-test-runner /lava-10005013/1

    2023-04-16T12:56:14.139861  =


    2023-04-16T12:56:14.145043  / # /lava-10005013/bin/lava-test-runner /la=
va-10005013/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf0961983e81f802e865e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf0961983e81f802e8663
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T12:56:26.570938  + set<8>[   11.066224] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10005014_1.4.2.3.1>

    2023-04-16T12:56:26.571552   +x

    2023-04-16T12:56:26.680224  / # #

    2023-04-16T12:56:26.782881  export SHELL=3D/bin/sh

    2023-04-16T12:56:26.783572  #

    2023-04-16T12:56:26.885497  / # export SHELL=3D/bin/sh. /lava-10005014/=
environment

    2023-04-16T12:56:26.886167  =


    2023-04-16T12:56:26.988149  / # . /lava-10005014/environment/lava-10005=
014/bin/lava-test-runner /lava-10005014/1

    2023-04-16T12:56:26.989317  =


    2023-04-16T12:56:26.994385  / # /lava-10005014/bin/lava-test-runner /la=
va-10005014/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf082118b6402cd2e8674

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-37=
2-gb440657ec84e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf082118b6402cd2e8679
        failing since 18 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-16T12:56:22.822934  + set +x<8>[   11.328623] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10004956_1.4.2.3.1>

    2023-04-16T12:56:22.823019  =


    2023-04-16T12:56:22.927638  / # #

    2023-04-16T12:56:23.029081  export SHELL=3D/bin/sh

    2023-04-16T12:56:23.029798  #

    2023-04-16T12:56:23.131605  / # export SHELL=3D/bin/sh. /lava-10004956/=
environment

    2023-04-16T12:56:23.132288  =


    2023-04-16T12:56:23.234042  / # . /lava-10004956/environment/lava-10004=
956/bin/lava-test-runner /lava-10004956/1

    2023-04-16T12:56:23.234283  =


    2023-04-16T12:56:23.239180  / # /lava-10004956/bin/lava-test-runner /la=
va-10004956/1
 =

    ... (12 line(s) more)  =

 =20
