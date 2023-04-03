Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B896D4BA4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 17:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjDCPTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 11:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbjDCPTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 11:19:03 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A48F192
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:19:01 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id y19so17702287pgk.5
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 08:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680535140;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kATiqr3scIJJfW/adThP2zwsiHJpjMXe8MJVeNNKDIM=;
        b=fBNpa0+V66HOmFaJPjsuAkZavM0T+D+r/bOhKZwyqfi8Y9CtxjlvLZPMD9Bz/Ca5it
         waqOyzps0LoBFHqFV4/sQyb4M0vz8tIvb0yn4Z5OuPJ6HnwgzkjCyQ8I8nmWTjP4Q7CH
         UdZLRxepYj3pJSr9a9CZNB9Y6rTMQRf0JZzTQ7Fa568BzGe1hBBiEQ8IouARC3VCl7oG
         7cYeT3gjEpqsNQgtbZOP7bNM51UjjOe7KrSZmNl1m4VitNMKifUi3zLSRN+GEpvFgvFJ
         AzFMBywZcrcjuwLnR1Kbl0eosvhk5FZfneYAzNKxUs9JF65v3mgnw/OXywE2WVYYiR9H
         wQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680535140;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kATiqr3scIJJfW/adThP2zwsiHJpjMXe8MJVeNNKDIM=;
        b=YBANZZpk4pYJlxLMKxPiz4U6QkBhDki+1OshDYdnmtbRBPFklUQ6V3pme2tj/gIe87
         8jB3ji+dZnvy3p1fLQRyKlve55oFULAVqeFiPY8nFTl/65y7icDhymoS6jSdPCoR8f7c
         gKa/9qZisl9VX1+TIZYq5PSrh+bJBOCYow9PZUh4V9uzInLcNP4kNlopf62vnQs5tUro
         R5KaflCdWrqqvOuV+uA3D0+hZMnzgW1IIq3unIhqcD1ECnYXD/RPLuBMMAmMGepuwsl+
         OWDqEBuVU+yyHo4bxqvMxhN1PMRNS5C8/pW7oKPT9WbtLVwnvNlYssWXjYe4hZymoDGu
         UyCQ==
X-Gm-Message-State: AAQBX9eBZl7usE8ts5+b5/an/Usme8bvcx90y3MBu76tugzRCB3aSbto
        gBqwOe/41E/rrk3dpmp+cLqFv6KElwECW7cZL+GDZw==
X-Google-Smtp-Source: AKy350axzu0cIzbcAYixVczAv8ua4sJKeN8W8xOaX+TEtEPC7wRpv4LwODktfaG7mINEl3zmpZJLuA==
X-Received: by 2002:a62:524b:0:b0:62d:e95d:51a0 with SMTP id g72-20020a62524b000000b0062de95d51a0mr10941621pfb.13.1680535140250;
        Mon, 03 Apr 2023 08:19:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s21-20020a056a00195500b0062dd8809d67sm7245883pfk.141.2023.04.03.08.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 08:18:59 -0700 (PDT)
Message-ID: <642aee63.050a0220.89c36.e0c5@mx.google.com>
Date:   Mon, 03 Apr 2023 08:18:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/6.1
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-170-g28bc452736b1
Subject: stable-rc/queue/6.1 baseline: 138 runs,
 8 regressions (v6.1.22-170-g28bc452736b1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 138 runs, 8 regressions (v6.1.22-170-g28bc452=
736b1)

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
el/v6.1.22-170-g28bc452736b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-170-g28bc452736b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      28bc452736b1f94e9f2137a073bfa07abe6115ab =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab86f4ecbb5a26962f771

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab86f4ecbb5a26962f776
        failing since 5 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-03T11:28:24.910962  <8>[   10.577934] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9849618_1.4.2.3.1>

    2023-04-03T11:28:24.914472  + set +x

    2023-04-03T11:28:25.023346  / # #

    2023-04-03T11:28:25.126124  export SHELL=3D/bin/sh

    2023-04-03T11:28:25.126937  #

    2023-04-03T11:28:25.228966  / # export SHELL=3D/bin/sh. /lava-9849618/e=
nvironment

    2023-04-03T11:28:25.229826  =


    2023-04-03T11:28:25.332004  / # . /lava-9849618/environment/lava-984961=
8/bin/lava-test-runner /lava-9849618/1

    2023-04-03T11:28:25.333193  =


    2023-04-03T11:28:25.337862  / # /lava-9849618/bin/lava-test-runner /lav=
a-9849618/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab86a4f69afdabc62f7b2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab86a4f69afdabc62f7b7
        failing since 5 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-03T11:28:24.229964  + <8>[   11.857864] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9849594_1.4.2.3.1>

    2023-04-03T11:28:24.230055  set +x

    2023-04-03T11:28:24.335350  / # #

    2023-04-03T11:28:24.436414  export SHELL=3D/bin/sh

    2023-04-03T11:28:24.436596  #

    2023-04-03T11:28:24.537518  / # export SHELL=3D/bin/sh. /lava-9849594/e=
nvironment

    2023-04-03T11:28:24.537759  =


    2023-04-03T11:28:24.638690  / # . /lava-9849594/environment/lava-984959=
4/bin/lava-test-runner /lava-9849594/1

    2023-04-03T11:28:24.638980  =


    2023-04-03T11:28:24.643567  / # /lava-9849594/bin/lava-test-runner /lav=
a-9849594/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab8694f69afdabc62f79c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab8694f69afdabc62f7a1
        failing since 5 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-03T11:28:19.112227  <8>[   10.705488] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9849627_1.4.2.3.1>

    2023-04-03T11:28:19.115494  + set +x

    2023-04-03T11:28:19.217439  =


    2023-04-03T11:28:19.318413  / # #export SHELL=3D/bin/sh

    2023-04-03T11:28:19.318646  =


    2023-04-03T11:28:19.419540  / # export SHELL=3D/bin/sh. /lava-9849627/e=
nvironment

    2023-04-03T11:28:19.419799  =


    2023-04-03T11:28:19.520626  / # . /lava-9849627/environment/lava-984962=
7/bin/lava-test-runner /lava-9849627/1

    2023-04-03T11:28:19.520963  =


    2023-04-03T11:28:19.526361  / # /lava-9849627/bin/lava-test-runner /lav=
a-9849627/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab41156ed5e15c762f790

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab41156ed5e15c762f7c2
        failing since 0 day (last pass: v6.1.22-65-g0f37ac1f7e1d4, first fa=
il: v6.1.22-119-g59b6cd554df0)

    2023-04-03T11:09:47.409767  + set +x
    2023-04-03T11:09:47.414585  <8>[   18.135693] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 268900_1.5.2.4.1>
    2023-04-03T11:09:47.545039  / # #
    2023-04-03T11:09:47.648945  export SHELL=3D/bin/sh
    2023-04-03T11:09:47.649510  #
    2023-04-03T11:09:47.751136  / # export SHELL=3D/bin/sh. /lava-268900/en=
vironment
    2023-04-03T11:09:47.751716  =

    2023-04-03T11:09:47.853681  / # . /lava-268900/environment/lava-268900/=
bin/lava-test-runner /lava-268900/1
    2023-04-03T11:09:47.854970  =

    2023-04-03T11:09:47.861270  / # /lava-268900/bin/lava-test-runner /lava=
-268900/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab858cde1db523c62f7a1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab858cde1db523c62f7a6
        failing since 5 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-03T11:28:10.221736  + set +x

    2023-04-03T11:28:10.228815  <8>[   11.021551] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9849631_1.4.2.3.1>

    2023-04-03T11:28:10.333211  / # #

    2023-04-03T11:28:10.434090  export SHELL=3D/bin/sh

    2023-04-03T11:28:10.434343  #

    2023-04-03T11:28:10.535124  / # export SHELL=3D/bin/sh. /lava-9849631/e=
nvironment

    2023-04-03T11:28:10.535340  =


    2023-04-03T11:28:10.636278  / # . /lava-9849631/environment/lava-984963=
1/bin/lava-test-runner /lava-9849631/1

    2023-04-03T11:28:10.636596  =


    2023-04-03T11:28:10.641061  / # /lava-9849631/bin/lava-test-runner /lav=
a-9849631/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab8624f69afdabc62f772

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab8624f69afdabc62f777
        failing since 5 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-03T11:28:20.300318  <8>[   10.714211] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9849629_1.4.2.3.1>

    2023-04-03T11:28:20.303678  + set +x

    2023-04-03T11:28:20.405691  =


    2023-04-03T11:28:20.506728  / # #export SHELL=3D/bin/sh

    2023-04-03T11:28:20.506968  =


    2023-04-03T11:28:20.607741  / # export SHELL=3D/bin/sh. /lava-9849629/e=
nvironment

    2023-04-03T11:28:20.607968  =


    2023-04-03T11:28:20.708918  / # . /lava-9849629/environment/lava-984962=
9/bin/lava-test-runner /lava-9849629/1

    2023-04-03T11:28:20.709247  =


    2023-04-03T11:28:20.714417  / # /lava-9849629/bin/lava-test-runner /lav=
a-9849629/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab86d4f69afdabc62f7d3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab86d4f69afdabc62f7d8
        failing since 5 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-03T11:28:26.575995  + <8>[   11.637885] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9849585_1.4.2.3.1>

    2023-04-03T11:28:26.576105  set +x

    2023-04-03T11:28:26.680911  / # #

    2023-04-03T11:28:26.781960  export SHELL=3D/bin/sh

    2023-04-03T11:28:26.782195  #

    2023-04-03T11:28:26.883114  / # export SHELL=3D/bin/sh. /lava-9849585/e=
nvironment

    2023-04-03T11:28:26.883360  =


    2023-04-03T11:28:26.984325  / # . /lava-9849585/environment/lava-984958=
5/bin/lava-test-runner /lava-9849585/1

    2023-04-03T11:28:26.984684  =


    2023-04-03T11:28:26.989506  / # /lava-9849585/bin/lava-test-runner /lav=
a-9849585/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab85cc55de80b2d62f788

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
0-g28bc452736b1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab85cc55de80b2d62f78d
        failing since 5 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-03T11:28:13.096709  + set +x<8>[   11.351012] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9849599_1.4.2.3.1>

    2023-04-03T11:28:13.096829  =


    2023-04-03T11:28:13.201427  / # #

    2023-04-03T11:28:13.302424  export SHELL=3D/bin/sh

    2023-04-03T11:28:13.302629  #

    2023-04-03T11:28:13.403543  / # export SHELL=3D/bin/sh. /lava-9849599/e=
nvironment

    2023-04-03T11:28:13.403759  =


    2023-04-03T11:28:13.504718  / # . /lava-9849599/environment/lava-984959=
9/bin/lava-test-runner /lava-9849599/1

    2023-04-03T11:28:13.505949  =


    2023-04-03T11:28:13.510640  / # /lava-9849599/bin/lava-test-runner /lav=
a-9849599/1
 =

    ... (12 line(s) more)  =

 =20
