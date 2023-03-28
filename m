Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182956CCDB8
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 00:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjC1WzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 18:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjC1WzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 18:55:06 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C152697
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:55:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x15so12310050pjk.2
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680044101;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RaZb0mvp8SLJ6LGVi6z/SSXJGCt1LDFRhaQ+A6STt7s=;
        b=wgs/KbpTKOG+AN3ZiZ1aVvCR2mRx2tckYcYmDHLvaNU5hqJ4RSfinvKvvOxJSZzr4d
         xDeX5vC5Qu1UUPTXyqjJGOPJGsnDAJrqS16KYCcaFRul38YPZHeyIvLDLhEbf9KoXdul
         LGbe+e6z8VuurMpt/TCGmXuQIVb8AVRHGt3u3MbMYKOakbDe01px80zqy/ok3hIz1NRZ
         5biR0FPOfW4zGB6VLrgG1veGjsPq8pGuGN7LqqtyV8g7aUlruXa6zqDxnosFN7qkcE6Q
         Qdqg4UE5emWalwsCFLnRG4N5fn+bKlxFTZfJvFlZnEho6Uq85+W2pFjGfEHt285oRwax
         52AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680044101;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RaZb0mvp8SLJ6LGVi6z/SSXJGCt1LDFRhaQ+A6STt7s=;
        b=23p05Irw+PB5uEeWtSfPGyAfvaRW2P00e3TRDcFxfwYoeZW00uh6X8hJsybjnsbQr2
         dvZsRH1KXozPX1xadHALNFbNWozl470pmz3orMsBss/6NubJm/nQAlnL/v7l9hSuIJoR
         Mh8xT9wrafe7Bv9tX34PsCGjFrMnPMQuwhga1G9SYcupFy+MmwAw1cJAzg+CBWoLE/55
         q5vr1FY206LwyKWk+5Xsa1XxqBXVyZ21qp61fgTH+BqFQvEd9N6bRg/qbBSMuxCrW7Lw
         6CJtv1NbGLHlXHDrogsrHViOytdOvjJ3Zw79JGmbNw7bzw3IgxUqSMYReesQ93tjoQNO
         ybzw==
X-Gm-Message-State: AAQBX9fdle9d8jKlRlsPsJI6VDX4Q6n8dmQwk5ux98aSg1FAdcRacgdE
        H9PS/bsYIEbF2RYUndW6aaZ9cZ9ZJLKZn2sSJmW0Vg==
X-Google-Smtp-Source: AKy350ZrXnVcdg2mzckbAthQ9Ko7luYgQyuqtcg5pTszi//SV2WDEiciz7/pf0GnnN3VA4AfDx+wzg==
X-Received: by 2002:a17:902:fa10:b0:19f:2b42:5d01 with SMTP id la16-20020a170902fa1000b0019f2b425d01mr14873930plb.9.1680044100839;
        Tue, 28 Mar 2023 15:55:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9-20020a632309000000b0050be4ff460esm20100468pgj.4.2023.03.28.15.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 15:55:00 -0700 (PDT)
Message-ID: <64237044.630a0220.e91a2.36dc@mx.google.com>
Date:   Tue, 28 Mar 2023 15:55:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/6.1
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.21-224-g1abeb39fad59
Subject: stable-rc/queue/6.1 baseline: 79 runs,
 9 regressions (v6.1.21-224-g1abeb39fad59)
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

stable-rc/queue/6.1 baseline: 79 runs, 9 regressions (v6.1.21-224-g1abeb39f=
ad59)

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
el/v6.1.21-224-g1abeb39fad59/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.21-224-g1abeb39fad59
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1abeb39fad59322992c1f50f19cbfb9242d63e38 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6423369146ce71c38a62f7cc

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6423369146ce71c38a62f7d1
        new failure (last pass: v6.1.21-104-gd5eb32be5b26)

    2023-03-28T18:48:30.525551  <8>[   10.825303] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798273_1.4.2.3.1>

    2023-03-28T18:48:30.529140  + set +x

    2023-03-28T18:48:30.633515  / # #

    2023-03-28T18:48:30.734570  export SHELL=3D/bin/sh

    2023-03-28T18:48:30.734771  #

    2023-03-28T18:48:30.835674  / # export SHELL=3D/bin/sh. /lava-9798273/e=
nvironment

    2023-03-28T18:48:30.835887  =


    2023-03-28T18:48:30.936821  / # . /lava-9798273/environment/lava-979827=
3/bin/lava-test-runner /lava-9798273/1

    2023-03-28T18:48:30.937097  =


    2023-03-28T18:48:30.943252  / # /lava-9798273/bin/lava-test-runner /lav=
a-9798273/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642336903fe153bc8862f7bb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642336903fe153bc8862f7c0
        new failure (last pass: v6.1.21-104-gd5eb32be5b26)

    2023-03-28T18:48:28.928505  + set<8>[   11.759861] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9798313_1.4.2.3.1>

    2023-03-28T18:48:28.929118   +x

    2023-03-28T18:48:29.037891  / # #

    2023-03-28T18:48:29.141021  export SHELL=3D/bin/sh

    2023-03-28T18:48:29.141910  #

    2023-03-28T18:48:29.243979  / # export SHELL=3D/bin/sh. /lava-9798313/e=
nvironment

    2023-03-28T18:48:29.244899  =


    2023-03-28T18:48:29.346951  / # . /lava-9798313/environment/lava-979831=
3/bin/lava-test-runner /lava-9798313/1

    2023-03-28T18:48:29.348434  =


    2023-03-28T18:48:29.353659  / # /lava-9798313/bin/lava-test-runner /lav=
a-9798313/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64233673e18de25dbd62f79f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64233673e18de25dbd62f7a4
        new failure (last pass: v6.1.21-104-gd5eb32be5b26)

    2023-03-28T18:48:11.165453  <8>[    8.454086] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798307_1.4.2.3.1>

    2023-03-28T18:48:11.168965  + set +x

    2023-03-28T18:48:11.274607  /#

    2023-03-28T18:48:11.377607   # #export SHELL=3D/bin/sh

    2023-03-28T18:48:11.378443  =


    2023-03-28T18:48:11.480400  / # export SHELL=3D/bin/sh. /lava-9798307/e=
nvironment

    2023-03-28T18:48:11.481211  =


    2023-03-28T18:48:11.582788  / # . /lava-9798307/environment/lava-979830=
7/bin/lava-test-runner /lava-9798307/1

    2023-03-28T18:48:11.584486  =


    2023-03-28T18:48:11.589279  / # /lava-9798307/bin/lava-test-runner /lav=
a-9798307/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/6423367de18de25dbd62f7f2

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6423367de18de25dbd62f825
        failing since 1 day (last pass: v6.1.21-102-g4da819332d9b, first fa=
il: v6.1.21-104-gd5eb32be5b26)

    2023-03-28T18:48:04.827019  + set +x
    2023-03-28T18:48:04.831183  <8>[   17.967141] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 241111_1.5.2.4.1>
    2023-03-28T18:48:04.947452  / # #
    2023-03-28T18:48:05.050221  export SHELL=3D/bin/sh
    2023-03-28T18:48:05.050938  #
    2023-03-28T18:48:05.153016  / # export SHELL=3D/bin/sh. /lava-241111/en=
vironment
    2023-03-28T18:48:05.153925  =

    2023-03-28T18:48:05.256676  / # . /lava-241111/environment/lava-241111/=
bin/lava-test-runner /lava-241111/1
    2023-03-28T18:48:05.257661  =

    2023-03-28T18:48:05.264199  / # /lava-241111/bin/lava-test-runner /lava=
-241111/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6423366da9dc47180262f771

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6423366da9dc47180262f776
        new failure (last pass: v6.1.21-104-gd5eb32be5b26)

    2023-03-28T18:48:01.551287  + set +x

    2023-03-28T18:48:01.557594  <8>[   10.875685] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798300_1.4.2.3.1>

    2023-03-28T18:48:01.662442  / # #

    2023-03-28T18:48:01.763423  export SHELL=3D/bin/sh

    2023-03-28T18:48:01.763615  #

    2023-03-28T18:48:01.864474  / # export SHELL=3D/bin/sh. /lava-9798300/e=
nvironment

    2023-03-28T18:48:01.864675  =


    2023-03-28T18:48:01.965545  / # . /lava-9798300/environment/lava-979830=
0/bin/lava-test-runner /lava-9798300/1

    2023-03-28T18:48:01.965914  =


    2023-03-28T18:48:01.970232  / # /lava-9798300/bin/lava-test-runner /lav=
a-9798300/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64233673d468ac04e962f787

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64233673d468ac04e962f78c
        new failure (last pass: v6.1.21-104-gd5eb32be5b26)

    2023-03-28T18:48:02.510371  <8>[   10.449108] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798319_1.4.2.3.1>

    2023-03-28T18:48:02.513653  + set +x

    2023-03-28T18:48:02.619978  =


    2023-03-28T18:48:02.721757  / # #export SHELL=3D/bin/sh

    2023-03-28T18:48:02.722551  =


    2023-03-28T18:48:02.824318  / # export SHELL=3D/bin/sh. /lava-9798319/e=
nvironment

    2023-03-28T18:48:02.825115  =


    2023-03-28T18:48:02.926964  / # . /lava-9798319/environment/lava-979831=
9/bin/lava-test-runner /lava-9798319/1

    2023-03-28T18:48:02.928165  =


    2023-03-28T18:48:02.933251  / # /lava-9798319/bin/lava-test-runner /lav=
a-9798319/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6423368667f32ada7f62f77c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6423368667f32ada7f62f781
        new failure (last pass: v6.1.21-104-gd5eb32be5b26)

    2023-03-28T18:48:19.775133  + set<8>[   11.753524] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9798270_1.4.2.3.1>

    2023-03-28T18:48:19.775736   +x

    2023-03-28T18:48:19.884214  / # #

    2023-03-28T18:48:19.987252  export SHELL=3D/bin/sh

    2023-03-28T18:48:19.988152  #

    2023-03-28T18:48:20.090091  / # export SHELL=3D/bin/sh. /lava-9798270/e=
nvironment

    2023-03-28T18:48:20.091050  =


    2023-03-28T18:48:20.193237  / # . /lava-9798270/environment/lava-979827=
0/bin/lava-test-runner /lava-9798270/1

    2023-03-28T18:48:20.194676  =


    2023-03-28T18:48:20.200564  / # /lava-9798270/bin/lava-test-runner /lav=
a-9798270/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64233678e18de25dbd62f7ad

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64233678e18de25dbd62f7b2
        new failure (last pass: v6.1.21-104-gd5eb32be5b26)

    2023-03-28T18:48:09.771810  + set<8>[   11.890069] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9798263_1.4.2.3.1>

    2023-03-28T18:48:09.771951   +x

    2023-03-28T18:48:09.876516  / # #

    2023-03-28T18:48:09.977540  export SHELL=3D/bin/sh

    2023-03-28T18:48:09.977764  #

    2023-03-28T18:48:10.078541  / # export SHELL=3D/bin/sh. /lava-9798263/e=
nvironment

    2023-03-28T18:48:10.078756  =


    2023-03-28T18:48:10.179643  / # . /lava-9798263/environment/lava-979826=
3/bin/lava-test-runner /lava-9798263/1

    2023-03-28T18:48:10.179943  =


    2023-03-28T18:48:10.184310  / # /lava-9798263/bin/lava-test-runner /lav=
a-9798263/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64233696c070268f2362f78c

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
4-g1abeb39fad59/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64233696c070268=
f2362f794
        new failure (last pass: v6.1.21-104-gd5eb32be5b26)
        1 lines

    2023-03-28T18:48:31.849048  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eb827dc4, epc =3D=3D 80201f24, ra =3D=
=3D 80204874
    2023-03-28T18:48:31.849267  =


    2023-03-28T18:48:31.874588  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-28T18:48:31.874814  =

   =

 =20
