Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393826D9AB2
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 16:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbjDFOmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 10:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239281AbjDFOlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 10:41:49 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63395AF0B
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 07:39:55 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so40872960pjb.0
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 07:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680791994; x=1683383994;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=drs3DDkrdTo7w1RXbNECtWsgKHrwIG74d1GMglP2ImM=;
        b=m1pmpqZ0UO2Ko1Blljf83H+tis5H4iAJ635pRXA7Zo7xE3DGSHRhbZF2RQYX0E6ut7
         MmmrvqgsuOanMIsrz8CEQGtPujyaJo05AXYb3g9gKoNLTOG4xYUpNFf+7cOOou01vBWy
         W1ZLdG69YIvJGcV0Xy77ekoynK1NLh7JaPbMB5XnvAB5QTjSrZPxcZ0AcjvrlGwqPv9l
         Sgo2kqNXogHDSXHTdw8b82KmXhRlYoc8SCEO/y2oZkeDDVpbAf5yrNfFjiPaXOZxt2ym
         9Gf4tyIV5DgoCggYL/OP5b2Wqa1HGDEnBQQLB2y6uXd1JKxZSdX0Cw0yRpvmB8iB3x9l
         ohTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680791994; x=1683383994;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=drs3DDkrdTo7w1RXbNECtWsgKHrwIG74d1GMglP2ImM=;
        b=zsSn7u5RwlPRO/s1+/72Vqf/HEvC4uayyssodFfwhgBPsAyDlkV0q/2CavgJ77iML3
         AwhFcHOrzT2/w/2sK9XpVDimMEZDI6J8Z06+AJ3l0c9dLj+CHV5/zoe/uCO6clv5HYWk
         FIiWCCgEFYVQhwn6C+xzNJUY6OR5utwTblyFWvknSFGy3VvVSWvykpA7CTDYKTG2uxY6
         Q0CvgsqwMM5LO1956k4sSZw5Uuzk/U6VbC51jcm+7uQ+z1wWEECMCpyT02CWAnKOlw4z
         +Ust7pfJPfawx7q9TfhTb4meiS0QrH/nMRHhdVRo1DKtXu3og8NkYLQhfURPPDAQbTuJ
         UJvA==
X-Gm-Message-State: AAQBX9c6H0vcfzUlHX/+JHpsLYpUcedBuMxReDTy2VTTQ7nZPcaBzpDj
        0xCJkENL+vovZ3vN6FRwEGm2wJBTVdxGMKJS3P2ZLanY
X-Google-Smtp-Source: AKy350Y83YhIa24mEZA2I/s/ZwER4VqDgBqfwBvR3QWYYIUgZYhaNi76pRNAEFtjQgvLxBjFBfk+yw==
X-Received: by 2002:a17:903:22c1:b0:19e:b38c:860b with SMTP id y1-20020a17090322c100b0019eb38c860bmr12688166plg.24.1680791993971;
        Thu, 06 Apr 2023 07:39:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1-20020a1709026b4100b0019a5aa7eab0sm1459315plt.54.2023.04.06.07.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 07:39:53 -0700 (PDT)
Message-ID: <642ed9b9.170a0220.93f2.2a5f@mx.google.com>
Date:   Thu, 06 Apr 2023 07:39:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.23
Subject: stable/linux-6.1.y baseline: 181 runs, 8 regressions (v6.1.23)
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

stable/linux-6.1.y baseline: 181 runs, 8 regressions (v6.1.23)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.23/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.23
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      543aff194ab6286af7791c5a138978ee7da4c93f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ea8d2687394297679e925

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C436=
FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C436=
FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ea8d2687394297679e92a
        failing since 6 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-06T11:10:56.735680  <8>[   10.462550] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9894485_1.4.2.3.1>

    2023-04-06T11:10:56.738431  + set +x

    2023-04-06T11:10:56.843442  / # #

    2023-04-06T11:10:56.944468  export SHELL=3D/bin/sh

    2023-04-06T11:10:56.944657  #

    2023-04-06T11:10:57.045565  / # export SHELL=3D/bin/sh. /lava-9894485/e=
nvironment

    2023-04-06T11:10:57.045753  =


    2023-04-06T11:10:57.146886  / # . /lava-9894485/environment/lava-989448=
5/bin/lava-test-runner /lava-9894485/1

    2023-04-06T11:10:57.148208  =


    2023-04-06T11:10:57.154292  / # /lava-9894485/bin/lava-test-runner /lav=
a-9894485/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ea8c6bff196ec7b79e945

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-CM14=
00CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-CM14=
00CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ea8c6bff196ec7b79e94a
        failing since 6 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-06T11:10:53.132875  + <8>[   11.741853] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9894499_1.4.2.3.1>

    2023-04-06T11:10:53.132964  set +x

    2023-04-06T11:10:53.237566  / # #

    2023-04-06T11:10:53.338596  export SHELL=3D/bin/sh

    2023-04-06T11:10:53.338810  #

    2023-04-06T11:10:53.439767  / # export SHELL=3D/bin/sh. /lava-9894499/e=
nvironment

    2023-04-06T11:10:53.440003  =


    2023-04-06T11:10:53.540929  / # . /lava-9894499/environment/lava-989449=
9/bin/lava-test-runner /lava-9894499/1

    2023-04-06T11:10:53.541355  =


    2023-04-06T11:10:53.546182  / # /lava-9894499/bin/lava-test-runner /lav=
a-9894499/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ea8d5687394297679e954

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx94=
00-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx94=
00-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ea8d5687394297679e959
        failing since 6 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-06T11:10:51.988357  <8>[    9.934700] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9894491_1.4.2.3.1>

    2023-04-06T11:10:51.991715  + set +x

    2023-04-06T11:10:52.093600  /#

    2023-04-06T11:10:52.194783   # #export SHELL=3D/bin/sh

    2023-04-06T11:10:52.194979  =


    2023-04-06T11:10:52.295872  / # export SHELL=3D/bin/sh. /lava-9894491/e=
nvironment

    2023-04-06T11:10:52.296084  =


    2023-04-06T11:10:52.397015  / # . /lava-9894491/environment/lava-989449=
1/bin/lava-test-runner /lava-9894491/1

    2023-04-06T11:10:52.397295  =


    2023-04-06T11:10:52.402077  / # /lava-9894491/bin/lava-test-runner /lav=
a-9894491/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/642ea6f43e4255694d79e962

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ea6f43e4255694d79e994
        failing since 19 days (last pass: v6.1.19, first fail: v6.1.20)

    2023-04-06T11:03:00.071825  + set +x
    2023-04-06T11:03:00.074766  <8>[   17.645662] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 290369_1.5.2.4.1>
    2023-04-06T11:03:00.191219  / # #
    2023-04-06T11:03:00.295025  export SHELL=3D/bin/sh
    2023-04-06T11:03:00.296812  #
    2023-04-06T11:03:00.402055  / # export SHELL=3D/bin/sh. /lava-290369/en=
vironment
    2023-04-06T11:03:00.402737  =

    2023-04-06T11:03:00.505240  / # . /lava-290369/environment/lava-290369/=
bin/lava-test-runner /lava-290369/1
    2023-04-06T11:03:00.506305  =

    2023-04-06T11:03:00.513381  / # /lava-290369/bin/lava-test-runner /lava=
-290369/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ea8d0bff196ec7b79e9b2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
2b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
2b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ea8d0bff196ec7b79e9b7
        failing since 6 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-06T11:10:53.954488  + set +x

    2023-04-06T11:10:53.961105  <8>[   10.566853] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9894495_1.4.2.3.1>

    2023-04-06T11:10:54.066452  / # #

    2023-04-06T11:10:54.167610  export SHELL=3D/bin/sh

    2023-04-06T11:10:54.167844  #

    2023-04-06T11:10:54.268832  / # export SHELL=3D/bin/sh. /lava-9894495/e=
nvironment

    2023-04-06T11:10:54.269065  =


    2023-04-06T11:10:54.370049  / # . /lava-9894495/environment/lava-989449=
5/bin/lava-test-runner /lava-9894495/1

    2023-04-06T11:10:54.370424  =


    2023-04-06T11:10:54.375585  / # /lava-9894495/bin/lava-test-runner /lav=
a-9894495/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ea8cd003a772c3679e941

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ea8cd003a772c3679e946
        failing since 6 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-06T11:10:53.395316  + set +x

    2023-04-06T11:10:53.401995  <8>[   10.083786] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9894456_1.4.2.3.1>

    2023-04-06T11:10:53.504132  #

    2023-04-06T11:10:53.504409  =


    2023-04-06T11:10:53.605414  / # #export SHELL=3D/bin/sh

    2023-04-06T11:10:53.605605  =


    2023-04-06T11:10:53.706515  / # export SHELL=3D/bin/sh. /lava-9894456/e=
nvironment

    2023-04-06T11:10:53.706706  =


    2023-04-06T11:10:53.807631  / # . /lava-9894456/environment/lava-989445=
6/bin/lava-test-runner /lava-9894456/1

    2023-04-06T11:10:53.807882  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ea8bf8eebf0fa0679ea7f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ea8bf8eebf0fa0679ea84
        failing since 6 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-06T11:10:49.853075  + <8>[   11.114403] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9894435_1.4.2.3.1>

    2023-04-06T11:10:49.853501  set +x

    2023-04-06T11:10:49.961320  / # #

    2023-04-06T11:10:50.064138  export SHELL=3D/bin/sh

    2023-04-06T11:10:50.064325  #

    2023-04-06T11:10:50.165190  / # export SHELL=3D/bin/sh. /lava-9894435/e=
nvironment

    2023-04-06T11:10:50.165369  =


    2023-04-06T11:10:50.266301  / # . /lava-9894435/environment/lava-989443=
5/bin/lava-test-runner /lava-9894435/1

    2023-04-06T11:10:50.266571  =


    2023-04-06T11:10:50.270710  / # /lava-9894435/bin/lava-test-runner /lav=
a-9894435/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ea8c064fe52726879e92a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo-TP=
ad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.23/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo-TP=
ad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ea8c064fe52726879e92f
        failing since 6 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-06T11:10:38.097525  + set<8>[   11.982326] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9894461_1.4.2.3.1>

    2023-04-06T11:10:38.097610   +x

    2023-04-06T11:10:38.202402  / # #

    2023-04-06T11:10:38.303367  export SHELL=3D/bin/sh

    2023-04-06T11:10:38.303534  #

    2023-04-06T11:10:38.404446  / # export SHELL=3D/bin/sh. /lava-9894461/e=
nvironment

    2023-04-06T11:10:38.404607  =


    2023-04-06T11:10:38.505481  / # . /lava-9894461/environment/lava-989446=
1/bin/lava-test-runner /lava-9894461/1

    2023-04-06T11:10:38.505715  =


    2023-04-06T11:10:38.510052  / # /lava-9894461/bin/lava-test-runner /lav=
a-9894461/1
 =

    ... (12 line(s) more)  =

 =20
