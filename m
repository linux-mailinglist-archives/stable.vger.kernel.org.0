Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1632E6D0D8C
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 20:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjC3SPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 14:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjC3SPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 14:15:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A434FF18
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 11:14:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d13so18077161pjh.0
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 11:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680200089;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=f9CQw2STaSHb9YzewNFx8JN0tlcfKz3ffK524wzGe8M=;
        b=S5oluEEVTun09Et52j+hpzIgAqixX5PwX7lkBKC69GQ2MhtF89tbiDMO5XZOYklukA
         DNhVlCgHsm/S3hQVloTWi1kpHnWDlemT7TqSt23SkWyDY138FvoZOdYrcHpApBrJ3zED
         r/4+OLeawk2KoMQeLywKMXKGeWswaJo2ZsKcXHJPH9QZ7nOobRQZGeXb70ZePzUbsazJ
         MEL77ZK4u4uvJdTs/jnHOT69BLgiz39VzMyvKBrsejXlQHfP/cpy4m4D3gmbRW0QTXGV
         wGUf1oSkOjDM60W3mlWB7QJpsoeVklr2psx6Ug4QutK7l2gZfmQfQJ4tfbs7Msh2r0w1
         YRng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680200089;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9CQw2STaSHb9YzewNFx8JN0tlcfKz3ffK524wzGe8M=;
        b=Zyroh6WPbjyfd1utUmtLy9eA6sRKcpNrQGyBxB1WOdCLnl6UcCO9kdhigaqsVp+Sab
         eJ56/rJb6o9QNtkWzg3sNlhShBCbkfI3s2sdMOYQd44IckfV54WV3DHJP7SkXMKx7Yho
         BQQMerZGSHFyUG2CRuuuik+W3lIKU0sPesCdcM7dFgvHhynJ7XAut2sd/htkQ1JGcOzy
         4p4G3vm+VUbrhOmx7DmrosRS2fWmUolvZImNPt6gZIJIgpqNH82sJzQg2RTFlvVYgBzE
         nn9hsiFJ7IL2ut3JzRI0vr5L7TerRo8G+ktq8k2Bzc9JBD7lexve1nFEvfGZiITcuOba
         ryDg==
X-Gm-Message-State: AAQBX9fymbiVT8zSqHu8rzJ8J9DBe/5WMFPdKSUGNYDF7w+BgUSt6mAL
        FCqtBSpmO5fV0lPbhDx18BLLJvrtXYBzAnBC93GHTg==
X-Google-Smtp-Source: AKy350bwegobDSOrGJyKZoJ5ldYOVD9oPwhfp66Gfx1asASpoOmnphY1s7szdkTXN8ciB3HAkBMwog==
X-Received: by 2002:a17:90a:1990:b0:23d:16d6:2f05 with SMTP id 16-20020a17090a199000b0023d16d62f05mr27390169pji.22.1680200088918;
        Thu, 30 Mar 2023 11:14:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902748700b0019f0ef910f7sm41892pll.123.2023.03.30.11.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 11:14:48 -0700 (PDT)
Message-ID: <6425d198.170a0220.17ea7.02b3@mx.google.com>
Date:   Thu, 30 Mar 2023 11:14:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22
Subject: stable/linux-6.1.y baseline: 176 runs, 9 regressions (v6.1.22)
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

stable/linux-6.1.y baseline: 176 runs, 9 regressions (v6.1.22)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.22/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3b29299e5f604550faf3eff811d6cd60b4c6cae6 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425996162778cff3a62f778

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C436=
FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C436=
FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425996162778cff3a62f77d
        new failure (last pass: v6.1.21)

    2023-03-30T14:14:44.532207  + set +x

    2023-03-30T14:14:44.539207  <8>[   11.284403] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816863_1.4.2.3.1>

    2023-03-30T14:14:44.648130  #

    2023-03-30T14:14:44.649533  =


    2023-03-30T14:14:44.751903  / # #export SHELL=3D/bin/sh

    2023-03-30T14:14:44.752858  =


    2023-03-30T14:14:44.854731  / # export SHELL=3D/bin/sh. /lava-9816863/e=
nvironment

    2023-03-30T14:14:44.855512  =


    2023-03-30T14:14:44.957569  / # . /lava-9816863/environment/lava-981686=
3/bin/lava-test-runner /lava-9816863/1

    2023-03-30T14:14:44.958835  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259988ca00bff36762f793

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-CM14=
00CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-CM14=
00CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259988ca00bff36762f798
        new failure (last pass: v6.1.21)

    2023-03-30T14:15:22.864725  + <8>[    8.957184] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9816918_1.4.2.3.1>

    2023-03-30T14:15:22.865325  set +x

    2023-03-30T14:15:22.974372  / # #

    2023-03-30T14:15:23.077649  export SHELL=3D/bin/sh

    2023-03-30T14:15:23.078550  #

    2023-03-30T14:15:23.180889  / # export SHELL=3D/bin/sh. /lava-9816918/e=
nvironment

    2023-03-30T14:15:23.181882  =


    2023-03-30T14:15:23.283751  / # . /lava-9816918/environment/lava-981691=
8/bin/lava-test-runner /lava-9816918/1

    2023-03-30T14:15:23.285250  =


    2023-03-30T14:15:23.289997  / # /lava-9816918/bin/lava-test-runner /lav=
a-9816918/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425997c0b2d91e9e062f779

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx94=
00-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx94=
00-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425997c0b2d91e9e062f77e
        new failure (last pass: v6.1.21)

    2023-03-30T14:15:06.336991  <8>[   10.318465] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816910_1.4.2.3.1>

    2023-03-30T14:15:06.340298  + set +x

    2023-03-30T14:15:06.441885  #

    2023-03-30T14:15:06.543358  / # #export SHELL=3D/bin/sh

    2023-03-30T14:15:06.543604  =


    2023-03-30T14:15:06.644371  / # export SHELL=3D/bin/sh. /lava-9816910/e=
nvironment

    2023-03-30T14:15:06.644647  =


    2023-03-30T14:15:06.745664  / # . /lava-9816910/environment/lava-981691=
0/bin/lava-test-runner /lava-9816910/1

    2023-03-30T14:15:06.746085  =


    2023-03-30T14:15:06.750533  / # /lava-9816910/bin/lava-test-runner /lav=
a-9816910/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/642596ab7ce6b447d262f7b3

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642596ab7ce6b447d262f7e4
        failing since 13 days (last pass: v6.1.19, first fail: v6.1.20)

    2023-03-30T14:03:01.107777  + set +x
    2023-03-30T14:03:01.110491  <8>[   17.242513] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 250348_1.5.2.4.1>
    2023-03-30T14:03:01.227475  / # #
    2023-03-30T14:03:01.329841  export SHELL=3D/bin/sh
    2023-03-30T14:03:01.330517  #
    2023-03-30T14:03:01.432245  / # export SHELL=3D/bin/sh. /lava-250348/en=
vironment
    2023-03-30T14:03:01.433066  =

    2023-03-30T14:03:01.535030  / # . /lava-250348/environment/lava-250348/=
bin/lava-test-runner /lava-250348/1
    2023-03-30T14:03:01.536070  =

    2023-03-30T14:03:01.542321  / # /lava-250348/bin/lava-test-runner /lava=
-250348/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259971633b7b573362f77b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
2b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
2b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259971633b7b573362f780
        new failure (last pass: v6.1.21)

    2023-03-30T14:14:56.515871  + set +x

    2023-03-30T14:14:56.522079  <8>[   10.576415] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816909_1.4.2.3.1>

    2023-03-30T14:14:56.627433  / # #

    2023-03-30T14:14:56.728448  export SHELL=3D/bin/sh

    2023-03-30T14:14:56.728668  #

    2023-03-30T14:14:56.829383  / # export SHELL=3D/bin/sh. /lava-9816909/e=
nvironment

    2023-03-30T14:14:56.829611  =


    2023-03-30T14:14:56.930533  / # . /lava-9816909/environment/lava-981690=
9/bin/lava-test-runner /lava-9816909/1

    2023-03-30T14:14:56.930843  =


    2023-03-30T14:14:56.935119  / # /lava-9816909/bin/lava-test-runner /lav=
a-9816909/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425996e341ed1356f62f79d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425996e341ed1356f62f7a2
        new failure (last pass: v6.1.21)

    2023-03-30T14:14:48.896624  + set +x

    2023-03-30T14:14:48.903345  <8>[   10.069714] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816875_1.4.2.3.1>

    2023-03-30T14:14:49.012387  =


    2023-03-30T14:14:49.114563  / # #export SHELL=3D/bin/sh

    2023-03-30T14:14:49.115448  =


    2023-03-30T14:14:49.217335  / # export SHELL=3D/bin/sh. /lava-9816875/e=
nvironment

    2023-03-30T14:14:49.218321  =


    2023-03-30T14:14:49.320260  / # . /lava-9816875/environment/lava-981687=
5/bin/lava-test-runner /lava-9816875/1

    2023-03-30T14:14:49.321649  =


    2023-03-30T14:14:49.327746  / # /lava-9816875/bin/lava-test-runner /lav=
a-9816875/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642599736fa15bd1ad62f7b6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642599736fa15bd1ad62f7bb
        new failure (last pass: v6.1.21)

    2023-03-30T14:15:04.664898  + set<8>[   10.893515] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9816911_1.4.2.3.1>

    2023-03-30T14:15:04.664999   +x

    2023-03-30T14:15:04.769463  / # #

    2023-03-30T14:15:04.870456  export SHELL=3D/bin/sh

    2023-03-30T14:15:04.870706  #

    2023-03-30T14:15:04.971603  / # export SHELL=3D/bin/sh. /lava-9816911/e=
nvironment

    2023-03-30T14:15:04.971817  =


    2023-03-30T14:15:05.072737  / # . /lava-9816911/environment/lava-981691=
1/bin/lava-test-runner /lava-9816911/1

    2023-03-30T14:15:05.073045  =


    2023-03-30T14:15:05.078214  / # /lava-9816911/bin/lava-test-runner /lav=
a-9816911/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259970341ed1356f62f7a8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo-TP=
ad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo-TP=
ad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259970341ed1356f62f7ad
        new failure (last pass: v6.1.21)

    2023-03-30T14:14:53.311739  <8>[   11.042053] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816906_1.4.2.3.1>

    2023-03-30T14:14:53.416506  / # #

    2023-03-30T14:14:53.517453  export SHELL=3D/bin/sh

    2023-03-30T14:14:53.517681  #

    2023-03-30T14:14:53.618606  / # export SHELL=3D/bin/sh. /lava-9816906/e=
nvironment

    2023-03-30T14:14:53.618828  =


    2023-03-30T14:14:53.719738  / # . /lava-9816906/environment/lava-981690=
6/bin/lava-test-runner /lava-9816906/1

    2023-03-30T14:14:53.720084  =


    2023-03-30T14:14:53.724693  / # /lava-9816906/bin/lava-test-runner /lav=
a-9816906/1

    2023-03-30T14:14:53.731110  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/642597b8708162eb1762f76b

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.22/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/642597b8708162e=
b1762f773
        new failure (last pass: v6.1.21)
        1 lines

    2023-03-30T14:07:18.171709  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eb827dc4, epc =3D=3D 80201f24, ra =3D=
=3D 80204874
    2023-03-30T14:07:18.171943  =


    2023-03-30T14:07:18.197555  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-30T14:07:18.197782  =

   =

 =20
