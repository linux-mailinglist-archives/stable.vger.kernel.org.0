Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE8D6D8343
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 18:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbjDEQNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 12:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbjDEQMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 12:12:43 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D247DAD
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 09:12:16 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 185so10884413pgc.10
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 09:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680711135;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qG4yPaORguB58OPl0JeKZDH5dzS9QZLTE/0SdXQxECY=;
        b=rlqrbXS7DAD5uaqZmplPTod9bRJ1aGd183R8m8j30SNkkz8U0LNkPEASVENMhT1dm9
         NBH5UYbEA789/c+6TbbtDIyS1Kz+vWO2d4FNGeGBQ5LwONgKG+LPONZ7PRdTcEuW9sCL
         Ptv5qMv0ZNknV6lmxEvEQIoiTdQrM/y5sopTP3vGYc21XHKP7l3diKAAwjpkSVvu4ZFs
         D8MHqgyoCAO9UcIiOXHNurxjz6wUnvnkMiWJdIHhK72Li7t0Etu2m4SXwhiHEK4D150d
         APBrBoKypwbdsZcMsi7Go5a7cPGtNvXEIEKXWnFpCduB0HnFySii0oMP0aK/91l6EhgI
         Rq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680711135;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qG4yPaORguB58OPl0JeKZDH5dzS9QZLTE/0SdXQxECY=;
        b=DU39MG4TuPrJ2mYhrGOQT8sTDLCXUglRFrl6V+Ggg+qkGkriHTkM0IEWpMdLglsRth
         LQHA8N+0q5P60VuYy6PeX5r/b1le91LCGMgVtFkY8Z5iVX6so9+vjPonfxDriBXu8a8M
         MHDtPvAUwrrqTVqwhH2yIkHH0zJxpjfPjbfgG2zNgjvqQI2+D4t0f/7YQ4Pq+8W7t4Mo
         xKM6g/YF7h7AEOZ31LbEtgi3g/zyL4F2QRbhJuCa5n/JyXfvbg8wUd/IOPAfNs/ebR9Z
         5h0xluhBxxQHnsj9bVQmgjnw0v91VDg9fTJEvjbdSdphdCJs9l2sYbzexPtsh+4i97Ox
         YB/A==
X-Gm-Message-State: AAQBX9cpEu95vVPsBpltg47gFeLoUi3mQwHqohqVRTmAXmexWqAx+P0Y
        rKKnUtzdzsDt/B/OVCYRa9CJNdBu8Su6CpvbbHaX1Q==
X-Google-Smtp-Source: AKy350bzSQORpKp3yTeHhNJUsrUYWulQ/8bcGV1QtNWRom6W+CQ4Fdzs5Rb+8MdvF9Uev5mdAXI9Ew==
X-Received: by 2002:a62:18c3:0:b0:628:1852:7343 with SMTP id 186-20020a6218c3000000b0062818527343mr5648600pfy.2.1680711135044;
        Wed, 05 Apr 2023 09:12:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8-20020aa78548000000b006288ca3cadfsm10889057pfn.35.2023.04.05.09.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 09:12:14 -0700 (PDT)
Message-ID: <642d9dde.a70a0220.21f67.5dec@mx.google.com>
Date:   Wed, 05 Apr 2023 09:12:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-177-ge130cbb3aea4d
Subject: stable-rc/queue/6.1 baseline: 171 runs,
 8 regressions (v6.1.22-177-ge130cbb3aea4d)
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

stable-rc/queue/6.1 baseline: 171 runs, 8 regressions (v6.1.22-177-ge130cbb=
3aea4d)

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
el/v6.1.22-177-ge130cbb3aea4d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-177-ge130cbb3aea4d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e130cbb3aea4df8314d983478b87e946949003a1 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6ad4eb7d7539db79e95b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6ad4eb7d7539db79e960
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T12:34:04.483353  <8>[    9.876820] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878542_1.4.2.3.1>

    2023-04-05T12:34:04.486927  + set +x

    2023-04-05T12:34:04.591914  / # #

    2023-04-05T12:34:04.693099  export SHELL=3D/bin/sh

    2023-04-05T12:34:04.693356  #

    2023-04-05T12:34:04.794300  / # export SHELL=3D/bin/sh. /lava-9878542/e=
nvironment

    2023-04-05T12:34:04.794572  =


    2023-04-05T12:34:04.895577  / # . /lava-9878542/environment/lava-987854=
2/bin/lava-test-runner /lava-9878542/1

    2023-04-05T12:34:04.895968  =


    2023-04-05T12:34:04.901189  / # /lava-9878542/bin/lava-test-runner /lav=
a-9878542/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6ac354925626df79e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6ac354925626df79e927
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T12:33:59.740430  + set<8>[   11.805298] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9878498_1.4.2.3.1>

    2023-04-05T12:33:59.741042   +x

    2023-04-05T12:33:59.849841  / # #

    2023-04-05T12:33:59.953027  export SHELL=3D/bin/sh

    2023-04-05T12:33:59.953915  #

    2023-04-05T12:34:00.056038  / # export SHELL=3D/bin/sh. /lava-9878498/e=
nvironment

    2023-04-05T12:34:00.056934  =


    2023-04-05T12:34:00.159290  / # . /lava-9878498/environment/lava-987849=
8/bin/lava-test-runner /lava-9878498/1

    2023-04-05T12:34:00.160688  =


    2023-04-05T12:34:00.165773  / # /lava-9878498/bin/lava-test-runner /lav=
a-9878498/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6ac7460329af1279e94a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6ac7460329af1279e94f
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T12:33:58.938882  <8>[   10.952197] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878476_1.4.2.3.1>

    2023-04-05T12:33:58.942624  + set +x

    2023-04-05T12:33:59.047926  #

    2023-04-05T12:33:59.150990  / # #export SHELL=3D/bin/sh

    2023-04-05T12:33:59.151816  =


    2023-04-05T12:33:59.253849  / # export SHELL=3D/bin/sh. /lava-9878476/e=
nvironment

    2023-04-05T12:33:59.254630  =


    2023-04-05T12:33:59.356555  / # . /lava-9878476/environment/lava-987847=
6/bin/lava-test-runner /lava-9878476/1

    2023-04-05T12:33:59.357878  =


    2023-04-05T12:33:59.363476  / # /lava-9878476/bin/lava-test-runner /lav=
a-9878476/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/642d687a733d4778f479e935

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d687a733d4778f479e968
        failing since 0 day (last pass: v6.1.22-181-gcacf34e34abf0, first f=
ail: v6.1.22-179-ga7cb9fb3a7e4e)

    2023-04-05T12:24:09.044580  + set +x
    2023-04-05T12:24:09.047108  <8>[   17.483767] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 282808_1.5.2.4.1>
    2023-04-05T12:24:09.166108  / # #
    2023-04-05T12:24:09.267428  export SHELL=3D/bin/sh
    2023-04-05T12:24:09.267792  #
    2023-04-05T12:24:09.368817  / # export SHELL=3D/bin/sh. /lava-282808/en=
vironment
    2023-04-05T12:24:09.369116  =

    2023-04-05T12:24:09.470254  / # . /lava-282808/environment/lava-282808/=
bin/lava-test-runner /lava-282808/1
    2023-04-05T12:24:09.470702  =

    2023-04-05T12:24:09.477298  / # /lava-282808/bin/lava-test-runner /lava=
-282808/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6ac63ef9af4d2a79e979

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6ac63ef9af4d2a79e97e
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T12:33:54.828721  + set +x

    2023-04-05T12:33:54.835522  <8>[   10.524590] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878537_1.4.2.3.1>

    2023-04-05T12:33:54.940131  / # #

    2023-04-05T12:33:55.041190  export SHELL=3D/bin/sh

    2023-04-05T12:33:55.041367  #

    2023-04-05T12:33:55.142250  / # export SHELL=3D/bin/sh. /lava-9878537/e=
nvironment

    2023-04-05T12:33:55.142439  =


    2023-04-05T12:33:55.243328  / # . /lava-9878537/environment/lava-987853=
7/bin/lava-test-runner /lava-9878537/1

    2023-04-05T12:33:55.243627  =


    2023-04-05T12:33:55.248520  / # /lava-9878537/bin/lava-test-runner /lav=
a-9878537/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6ab24dbb4db7b779e94d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6ab24dbb4db7b779e952
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T12:33:40.953112  <8>[    9.983845] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878533_1.4.2.3.1>

    2023-04-05T12:33:40.956531  + set +x

    2023-04-05T12:33:41.062611  #

    2023-04-05T12:33:41.163902  / # #export SHELL=3D/bin/sh

    2023-04-05T12:33:41.164071  =


    2023-04-05T12:33:41.265109  / # export SHELL=3D/bin/sh. /lava-9878533/e=
nvironment

    2023-04-05T12:33:41.265772  =


    2023-04-05T12:33:41.367673  / # . /lava-9878533/environment/lava-987853=
3/bin/lava-test-runner /lava-9878533/1

    2023-04-05T12:33:41.368833  =


    2023-04-05T12:33:41.373824  / # /lava-9878533/bin/lava-test-runner /lav=
a-9878533/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6aceeb7d7539db79e93f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6aceeb7d7539db79e944
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T12:33:59.689067  + set<8>[   10.823666] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9878481_1.4.2.3.1>

    2023-04-05T12:33:59.689163   +x

    2023-04-05T12:33:59.794555  / # #

    2023-04-05T12:33:59.895609  export SHELL=3D/bin/sh

    2023-04-05T12:33:59.895837  #

    2023-04-05T12:33:59.996795  / # export SHELL=3D/bin/sh. /lava-9878481/e=
nvironment

    2023-04-05T12:33:59.997027  =


    2023-04-05T12:34:00.097972  / # . /lava-9878481/environment/lava-987848=
1/bin/lava-test-runner /lava-9878481/1

    2023-04-05T12:34:00.098272  =


    2023-04-05T12:34:00.102494  / # /lava-9878481/bin/lava-test-runner /lav=
a-9878481/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6ab54dbb4db7b779e96e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
7-ge130cbb3aea4d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6ab54dbb4db7b779e973
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T12:33:45.787968  + set<8>[   12.322289] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9878500_1.4.2.3.1>

    2023-04-05T12:33:45.788412   +x

    2023-04-05T12:33:45.897018  / # #

    2023-04-05T12:33:45.999702  export SHELL=3D/bin/sh

    2023-04-05T12:33:46.000428  #

    2023-04-05T12:33:46.102148  / # export SHELL=3D/bin/sh. /lava-9878500/e=
nvironment

    2023-04-05T12:33:46.102884  =


    2023-04-05T12:33:46.204766  / # . /lava-9878500/environment/lava-987850=
0/bin/lava-test-runner /lava-9878500/1

    2023-04-05T12:33:46.206072  =


    2023-04-05T12:33:46.211301  / # /lava-9878500/bin/lava-test-runner /lav=
a-9878500/1
 =

    ... (12 line(s) more)  =

 =20
