Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4198D6E15B6
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 22:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjDMUVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 16:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDMUU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 16:20:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EED27683
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 13:20:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f2so7793658pjs.3
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 13:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681417256; x=1684009256;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xUQN8FawNva8nDidt7EUrj1BVbugpNQ7Y4kMHsGJAN4=;
        b=21chANAeXoAK4urwwuYzzqPEOKDQ+awqsAS/CXU9gEGgDtK1MZoeDZLOq59PRCdvIu
         EJ8+EznEdtG1bSE/WdnIjHtOxwMluzSKaxdLrT9opq67mRWfvh4RGy9hSxu6bZQTVILc
         HTnW6KfQfRsIDuryxKBLRWJaO+u3FKlb64N97LjVIdTrOnIJ4bJNADo49MPJnT8j9D4R
         bHaEG3awNboMAX2wwvkJzuCyOmOaspmTAWTgt6iInVeJM5iXWN2qLS0Z0XcqSPB9pRmc
         4PYDpbQqFzE5ztoc6ifZ/1uu+DTQ9RUvz7xp0qlCKyMnita4KkDBHQ3OGH8pmOfWyHGG
         XHrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681417256; x=1684009256;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xUQN8FawNva8nDidt7EUrj1BVbugpNQ7Y4kMHsGJAN4=;
        b=ct7V4NLQsQuwDBfykZLPmAv8paI3mu/HICacmoUpLzLcIKXaoR6p2636jyvAtC82b9
         CJoIPzT5QExos3ZS89b1THBezr+fh3psZwmhLxOUUUR7et/Vyg2RG++3LMP43CW4n7Co
         iZ1UNdsTKbdOn2DJoQ0Xa2TyFj2AcNRQCMj0b9c92dlLnqRgQmlBS6hNVrzGpcNR/FJl
         mN7dKuuVHrMS0DnogDVHTuD2KRTUjt5DTei13+Sj2ffQ6dCcTLp+K/y/UTWcW8gY+kUv
         xF80VdV/ISs+jQmhJ+cQoirmKPN7OZi3Q3ahA+DPbfIMwH5o5zYdHjayGgmLQydPROB6
         Yr2Q==
X-Gm-Message-State: AAQBX9dG+4AwMkW8Oo258E/uLLSQbiYG7EKH23L56Asm5q7PFjq5lf11
        XtdrYktvfkfwx4ACB2Afkz0ghWtVLJs0SNqBeMj9pi22
X-Google-Smtp-Source: AKy350ZNAOnkQwb2AXeNH+AZyAXQbH065zsLgb+4JMCKsiFGQbbM4fvT/vblq4HH0AN00edbEYfs8A==
X-Received: by 2002:a05:6a20:be09:b0:eb:c8dc:a565 with SMTP id ge9-20020a056a20be0900b000ebc8dca565mr3130012pzb.7.1681417256297;
        Thu, 13 Apr 2023 13:20:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23-20020aa78d17000000b00627ed4e23e0sm1754182pfe.101.2023.04.13.13.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 13:20:55 -0700 (PDT)
Message-ID: <64386427.a70a0220.2a1c.3dd5@mx.google.com>
Date:   Thu, 13 Apr 2023 13:20:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-344-g57630d5c105b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 190 runs,
 9 regressions (v6.1.22-344-g57630d5c105b)
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

stable-rc/queue/6.1 baseline: 190 runs, 9 regressions (v6.1.22-344-g57630d5=
c105b)

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

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-344-g57630d5c105b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-344-g57630d5c105b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      57630d5c105bede2edcd0e7016a22ffd992eaeac =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382fc6e4a58450f42e8659

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382fc6e4a58450f42e865d
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T16:37:12.374595  <8>[   10.668618] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9962142_1.4.2.3.1>

    2023-04-13T16:37:12.378041  + set +x

    2023-04-13T16:37:12.485661  / # #

    2023-04-13T16:37:12.588012  export SHELL=3D/bin/sh

    2023-04-13T16:37:12.588707  #

    2023-04-13T16:37:12.690522  / # export SHELL=3D/bin/sh. /lava-9962142/e=
nvironment

    2023-04-13T16:37:12.691258  =


    2023-04-13T16:37:12.793138  / # . /lava-9962142/environment/lava-996214=
2/bin/lava-test-runner /lava-9962142/1

    2023-04-13T16:37:12.794300  =


    2023-04-13T16:37:12.800737  / # /lava-9962142/bin/lava-test-runner /lav=
a-9962142/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382fb24da24caea22e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382fb24da24caea22e85fc
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T16:36:56.560268  + <8>[   10.964329] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9962154_1.4.2.3.1>

    2023-04-13T16:36:56.560364  set +x

    2023-04-13T16:36:56.664937  / # #

    2023-04-13T16:36:56.765917  export SHELL=3D/bin/sh

    2023-04-13T16:36:56.766110  #

    2023-04-13T16:36:56.866966  / # export SHELL=3D/bin/sh. /lava-9962154/e=
nvironment

    2023-04-13T16:36:56.867169  =


    2023-04-13T16:36:56.968039  / # . /lava-9962154/environment/lava-996215=
4/bin/lava-test-runner /lava-9962154/1

    2023-04-13T16:36:56.968311  =


    2023-04-13T16:36:56.973144  / # /lava-9962154/bin/lava-test-runner /lav=
a-9962154/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643832e60bc6f966072e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643832e60bc6f966072e85eb
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T16:50:23.252920  <8>[    9.829753] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9962149_1.4.2.3.1>

    2023-04-13T16:50:23.256472  + set +x

    2023-04-13T16:50:23.362116  #

    2023-04-13T16:50:23.363323  =


    2023-04-13T16:50:23.465196  / # #export SHELL=3D/bin/sh

    2023-04-13T16:50:23.465383  =


    2023-04-13T16:50:23.566533  / # export SHELL=3D/bin/sh. /lava-9962149/e=
nvironment

    2023-04-13T16:50:23.567290  =


    2023-04-13T16:50:23.669011  / # . /lava-9962149/environment/lava-996214=
9/bin/lava-test-runner /lava-9962149/1

    2023-04-13T16:50:23.670284  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/64382fd22df484f3c02e85f1

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382fd22df484f3c02e8624
        new failure (last pass: v6.1.22-344-g85401f7f457f)

    2023-04-13T16:37:17.372583  + set +x
    2023-04-13T16:37:17.376540  <8>[   17.033134] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 323308_1.5.2.4.1>
    2023-04-13T16:37:17.490922  / # #
    2023-04-13T16:37:17.594328  export SHELL=3D/bin/sh
    2023-04-13T16:37:17.595091  #
    2023-04-13T16:37:17.697241  / # export SHELL=3D/bin/sh. /lava-323308/en=
vironment
    2023-04-13T16:37:17.697987  =

    2023-04-13T16:37:17.800373  / # . /lava-323308/environment/lava-323308/=
bin/lava-test-runner /lava-323308/1
    2023-04-13T16:37:17.801615  =

    2023-04-13T16:37:17.808109  / # /lava-323308/bin/lava-test-runner /lava=
-323308/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64383265557b9850b12e8672

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64383265557b9850b12e8677
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T16:48:23.048048  + set +x

    2023-04-13T16:48:23.054862  <8>[   10.788822] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9962173_1.4.2.3.1>

    2023-04-13T16:48:23.159716  / # #

    2023-04-13T16:48:23.260765  export SHELL=3D/bin/sh

    2023-04-13T16:48:23.260970  #

    2023-04-13T16:48:23.361891  / # export SHELL=3D/bin/sh. /lava-9962173/e=
nvironment

    2023-04-13T16:48:23.362090  =


    2023-04-13T16:48:23.463022  / # . /lava-9962173/environment/lava-996217=
3/bin/lava-test-runner /lava-9962173/1

    2023-04-13T16:48:23.463314  =


    2023-04-13T16:48:23.468061  / # /lava-9962173/bin/lava-test-runner /lav=
a-9962173/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643831e12528ed5f4b2e870c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643831e12528ed5f4b2e8711
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T16:46:17.501132  + set<8>[   10.592984] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9962137_1.4.2.3.1>

    2023-04-13T16:46:17.501953   +x

    2023-04-13T16:46:17.609708  /#

    2023-04-13T16:46:17.712847   # #export SHELL=3D/bin/sh

    2023-04-13T16:46:17.713573  =


    2023-04-13T16:46:17.815368  / # export SHELL=3D/bin/sh. /lava-9962137/e=
nvironment

    2023-04-13T16:46:17.816135  =


    2023-04-13T16:46:17.918191  / # . /lava-9962137/environment/lava-996213=
7/bin/lava-test-runner /lava-9962137/1

    2023-04-13T16:46:17.919319  =


    2023-04-13T16:46:17.924514  / # /lava-9962137/bin/lava-test-runner /lav=
a-9962137/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382fd12df484f3c02e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382fd12df484f3c02e85eb
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T16:37:18.577885  + set<8>[   11.164871] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9962141_1.4.2.3.1>

    2023-04-13T16:37:18.578323   +x

    2023-04-13T16:37:18.686884  / # #

    2023-04-13T16:37:18.789826  export SHELL=3D/bin/sh

    2023-04-13T16:37:18.790557  #

    2023-04-13T16:37:18.892482  / # export SHELL=3D/bin/sh. /lava-9962141/e=
nvironment

    2023-04-13T16:37:18.893317  =


    2023-04-13T16:37:18.995142  / # . /lava-9962141/environment/lava-996214=
1/bin/lava-test-runner /lava-9962141/1

    2023-04-13T16:37:18.997037  =


    2023-04-13T16:37:19.001437  / # /lava-9962141/bin/lava-test-runner /lav=
a-9962141/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6438324520ff338a882e8628

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438324520ff338a882e862d
        failing since 15 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-13T16:47:48.187684  + set<8>[   11.920587] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9962139_1.4.2.3.1>

    2023-04-13T16:47:48.187783   +x

    2023-04-13T16:47:48.292913  / # #

    2023-04-13T16:47:48.393976  export SHELL=3D/bin/sh

    2023-04-13T16:47:48.394197  #

    2023-04-13T16:47:48.495183  / # export SHELL=3D/bin/sh. /lava-9962139/e=
nvironment

    2023-04-13T16:47:48.495416  =


    2023-04-13T16:47:48.596402  / # . /lava-9962139/environment/lava-996213=
9/bin/lava-test-runner /lava-9962139/1

    2023-04-13T16:47:48.596728  =


    2023-04-13T16:47:48.601183  / # /lava-9962139/bin/lava-test-runner /lav=
a-9962139/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64382c066561bfdfa32e8635

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-34=
4-g57630d5c105b/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64382c066561bfd=
fa32e863d
        failing since 1 day (last pass: v6.1.22-327-g5d6cb90df983, first fa=
il: v6.1.22-343-gd99c3fff7381)
        1 lines

    2023-04-13T16:21:19.672009  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eb673308, epc =3D=3D 80201ff4, ra =3D=
=3D 80204944
    2023-04-13T16:21:19.672141  =


    2023-04-13T16:21:19.699961  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-13T16:21:19.700127  =

   =

 =20
