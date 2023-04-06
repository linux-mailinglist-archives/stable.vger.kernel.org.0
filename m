Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681346D9E0C
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 18:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjDFQ5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 12:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDFQ5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 12:57:18 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE9130FB
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 09:57:16 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q102so37787376pjq.3
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 09:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680800235; x=1683392235;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pjy7WWCcKL7iEVcRw/EMaZLjXjsWpCmnoi+Q/o4qc/w=;
        b=UwqPsUIN1E7yJ3cKK9IXp37YhC8egnR6bVo7FfJ7BFn/f+c4oj72+TGMRIOkWClk8S
         HeC4+szNBICzqMsVyaKr6J0emer8LFD8YXNYI6Bu06JN4Wxsy7q2pl3LVWzdBZIuG+9u
         Q3zlBJYM+LLI8rwIhYkIFlrpbUvWKGFIunBhR5DutUgdD2UJHX7CCJlAeRoAli/q+sS+
         gXoAD5tLG0LRCaqKuhXS3ZwW1aRJDuJ92zeURj+rjKfFPLnFX13P8cDTT3pr22xajqPm
         mybgxZo01z9HQBlq+DVhQpTHx8RgdBkUjvEDCoBkbL1g5LnnxfWikN7HWvw460qTlNRE
         5ncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680800235; x=1683392235;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pjy7WWCcKL7iEVcRw/EMaZLjXjsWpCmnoi+Q/o4qc/w=;
        b=OE8MGPF84GKjf+mXyDdg+P6VwmcYvDuoyQdXnGCaVpx170GQgbqTdYmVP3XyQCCqYi
         jWUu+sovlF1G7BAyNtjbEGdi6dVwAw0LqchdT2ZKHTuX4aW7bexJ+RusPv7L6RYgzFZp
         x4Bk9psL9GeiTIyEeN4eEcQgVFisDhci9jZHaKTMWVuQWTWNbT9MuwfVMyyKyrWctUv/
         X3Vh0DvP+AgFgDhTPm4hl4GTo/HX3Q0uACP/B8meEAy81GQtAFhqIasjqK1VvRsBvv9d
         R9nPKX/FT5Hpc8GQB0ZJIB762lEqDpou8EeSVtsPyZ4CPbbFDSlEiuCGHfIjvkjKQpuZ
         BRiA==
X-Gm-Message-State: AAQBX9dci11VQR2NhaZGUDBWbBhxoel5gC+37vJYViaCdck/+eTVJBFW
        nU3glCYiRoaxbQJyZFthmmD/eYSoIOwMsx/35OQtQtDD
X-Google-Smtp-Source: AKy350YqWIaYTUONYWoy3kabvT6sdAez8zoF0xr/BbbztqD12kJW4yJ6b2xFXLfA784h5oIuNyea9Q==
X-Received: by 2002:a17:903:41c7:b0:19f:2dff:21a4 with SMTP id u7-20020a17090341c700b0019f2dff21a4mr13287954ple.16.1680800235305;
        Thu, 06 Apr 2023 09:57:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902bd4c00b001a5023e7395sm1262774plx.135.2023.04.06.09.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 09:57:15 -0700 (PDT)
Message-ID: <642ef9eb.170a0220.5f094.211b@mx.google.com>
Date:   Thu, 06 Apr 2023 09:57:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-124-g10e14d35d2d3
Subject: stable-rc/queue/5.15 baseline: 117 runs,
 9 regressions (v5.15.105-124-g10e14d35d2d3)
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

stable-rc/queue/5.15 baseline: 117 runs, 9 regressions (v5.15.105-124-g10e1=
4d35d2d3)

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

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-124-g10e14d35d2d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-124-g10e14d35d2d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10e14d35d2d3abd017c3f2a70a67cc3786f0b25f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ec6d44cb48da77279e986

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ec6d44cb48da77279e98b
        failing since 9 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-06T13:18:54.483948  + set +x

    2023-04-06T13:18:54.490181  <8>[   10.276493] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9895278_1.4.2.3.1>

    2023-04-06T13:18:54.592547  =


    2023-04-06T13:18:54.693509  / # #export SHELL=3D/bin/sh

    2023-04-06T13:18:54.693789  =


    2023-04-06T13:18:54.794781  / # export SHELL=3D/bin/sh. /lava-9895278/e=
nvironment

    2023-04-06T13:18:54.795065  =


    2023-04-06T13:18:54.895851  / # . /lava-9895278/environment/lava-989527=
8/bin/lava-test-runner /lava-9895278/1

    2023-04-06T13:18:54.896149  =


    2023-04-06T13:18:54.901709  / # /lava-9895278/bin/lava-test-runner /lav=
a-9895278/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ec6d37d34120ea279e933

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ec6d37d34120ea279e938
        failing since 9 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-06T13:19:09.102658  + <8>[   11.059858] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9895249_1.4.2.3.1>

    2023-04-06T13:19:09.103100  set +x

    2023-04-06T13:19:09.210428  / # #

    2023-04-06T13:19:09.313424  export SHELL=3D/bin/sh

    2023-04-06T13:19:09.314449  #

    2023-04-06T13:19:09.416874  / # export SHELL=3D/bin/sh. /lava-9895249/e=
nvironment

    2023-04-06T13:19:09.417113  =


    2023-04-06T13:19:09.518037  / # . /lava-9895249/environment/lava-989524=
9/bin/lava-test-runner /lava-9895249/1

    2023-04-06T13:19:09.518376  =


    2023-04-06T13:19:09.522989  / # /lava-9895249/bin/lava-test-runner /lav=
a-9895249/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ec61f16882ceed979e928

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ec61f16882ceed979e92d
        failing since 9 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-06T13:15:53.423589  <8>[   10.027319] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9895284_1.4.2.3.1>

    2023-04-06T13:15:53.426766  + set +x

    2023-04-06T13:15:53.532955  /#

    2023-04-06T13:15:53.636031   # #export SHELL=3D/bin/sh

    2023-04-06T13:15:53.636770  =


    2023-04-06T13:15:53.738526  / # export SHELL=3D/bin/sh. /lava-9895284/e=
nvironment

    2023-04-06T13:15:53.739235  =


    2023-04-06T13:15:53.841087  / # . /lava-9895284/environment/lava-989528=
4/bin/lava-test-runner /lava-9895284/1

    2023-04-06T13:15:53.842256  =


    2023-04-06T13:15:53.847250  / # /lava-9895284/bin/lava-test-runner /lav=
a-9895284/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642ec7c20f4fbe66aa79e936

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642ec7c20f4fbe66aa79e=
937
        failing since 62 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642ec8a8fad78dc6b179e93e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ec8a8fad78dc6b179e943
        failing since 79 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-06T13:26:48.448946  + set +x<8>[    9.937617] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3476223_1.5.2.4.1>
    2023-04-06T13:26:48.449495  =

    2023-04-06T13:26:48.559077  / # #
    2023-04-06T13:26:48.661893  export SHELL=3D/bin/sh
    2023-04-06T13:26:48.662834  #
    2023-04-06T13:26:48.764808  / # export SHELL=3D/bin/sh. /lava-3476223/e=
nvironment
    2023-04-06T13:26:48.765749  =

    2023-04-06T13:26:48.867790  / # . /lava-3476223/environment/lava-347622=
3/bin/lava-test-runner /lava-3476223/1
    2023-04-06T13:26:48.869234  =

    2023-04-06T13:26:48.869643  / # /lava-3476223/bin/lava-test-runner /lav=
a-3476223/1<3>[   10.352995] Bluetooth: hci0: command 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ec74c1d320de3ab79e93c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ec74c1d320de3ab79e941
        failing since 9 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-06T13:21:00.266428  + set +x

    2023-04-06T13:21:00.273321  <8>[   10.884128] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9895267_1.4.2.3.1>

    2023-04-06T13:21:00.378099  / # #

    2023-04-06T13:21:00.479098  export SHELL=3D/bin/sh

    2023-04-06T13:21:00.479270  #

    2023-04-06T13:21:00.580183  / # export SHELL=3D/bin/sh. /lava-9895267/e=
nvironment

    2023-04-06T13:21:00.580376  =


    2023-04-06T13:21:00.681265  / # . /lava-9895267/environment/lava-989526=
7/bin/lava-test-runner /lava-9895267/1

    2023-04-06T13:21:00.681573  =


    2023-04-06T13:21:00.685765  / # /lava-9895267/bin/lava-test-runner /lav=
a-9895267/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ec68190270ddb2379e950

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ec68190270ddb2379e955
        failing since 9 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-06T13:17:32.377630  <8>[   10.407444] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9895253_1.4.2.3.1>

    2023-04-06T13:17:32.381085  + set +x

    2023-04-06T13:17:32.482629  #

    2023-04-06T13:17:32.583855  / # #export SHELL=3D/bin/sh

    2023-04-06T13:17:32.584052  =


    2023-04-06T13:17:32.684987  / # export SHELL=3D/bin/sh. /lava-9895253/e=
nvironment

    2023-04-06T13:17:32.685191  =


    2023-04-06T13:17:32.786164  / # . /lava-9895253/environment/lava-989525=
3/bin/lava-test-runner /lava-9895253/1

    2023-04-06T13:17:32.786454  =


    2023-04-06T13:17:32.791505  / # /lava-9895253/bin/lava-test-runner /lav=
a-9895253/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ec60be983f306cb79e98d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ec60be983f306cb79e992
        failing since 9 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-06T13:15:47.105727  + set<8>[   11.480768] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9895279_1.4.2.3.1>

    2023-04-06T13:15:47.105813   +x

    2023-04-06T13:15:47.210674  / # #

    2023-04-06T13:15:47.311741  export SHELL=3D/bin/sh

    2023-04-06T13:15:47.311939  #

    2023-04-06T13:15:47.412864  / # export SHELL=3D/bin/sh. /lava-9895279/e=
nvironment

    2023-04-06T13:15:47.413070  =


    2023-04-06T13:15:47.513814  / # . /lava-9895279/environment/lava-989527=
9/bin/lava-test-runner /lava-9895279/1

    2023-04-06T13:15:47.514100  =


    2023-04-06T13:15:47.519004  / # /lava-9895279/bin/lava-test-runner /lav=
a-9895279/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ec611c7e145fbcd79e98b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-124-g10e14d35d2d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ec611c7e145fbcd79e990
        failing since 9 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-06T13:15:49.669520  <8>[   12.035197] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9895233_1.4.2.3.1>

    2023-04-06T13:15:49.777544  / # #

    2023-04-06T13:15:49.879838  export SHELL=3D/bin/sh

    2023-04-06T13:15:49.880092  #

    2023-04-06T13:15:49.981181  / # export SHELL=3D/bin/sh. /lava-9895233/e=
nvironment

    2023-04-06T13:15:49.981978  =


    2023-04-06T13:15:50.083744  / # . /lava-9895233/environment/lava-989523=
3/bin/lava-test-runner /lava-9895233/1

    2023-04-06T13:15:50.085100  =


    2023-04-06T13:15:50.089788  / # /lava-9895233/bin/lava-test-runner /lav=
a-9895233/1

    2023-04-06T13:15:50.095547  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
