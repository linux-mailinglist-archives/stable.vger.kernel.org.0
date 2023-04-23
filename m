Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A156EC273
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 23:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjDWV0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 17:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDWV0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 17:26:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA22D1BD
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 14:26:31 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a686260adcso43232215ad.0
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 14:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682285191; x=1684877191;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IrCX+mfn6tzEqwwNOPa44JCeo3mTzOHSampekWTcweg=;
        b=OfCJNrvRudqyuD5z8yRtqgBRlkqbeJwkRRmyHSoDlhRQuL6nHDd6sWsFUnCCQIUsE3
         L3t4+7Upg7JiHO1zByPJMz1kwWigyQBB8KZk1EUGJHwm3M9SFKFEX0eE8yKH9PczaJXz
         GoXHt+V6iz2fb/HI/ACpMwYYPsMwgqPXs1ycmzlB1c2AMXOOQTuR2Z4ifW8uOL5fe9po
         xZlmAfU4jiZhZ4/+vl178x+DCmbxIyty8eDP8bOw/ZcNmDYbZ5Ap3GQ0kvDJefdetOXF
         Jw8/BkC5YKm8cVRPaTkd51jrsrNkbHLh5NSOCa/klHlTNNKSDe8gAMPQC/dpQ7VNHzrY
         goCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682285191; x=1684877191;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IrCX+mfn6tzEqwwNOPa44JCeo3mTzOHSampekWTcweg=;
        b=SV2vygemAe0jgDHtcfOukA72bckaa9gY5fTk9EP6HAzbHIZ9O27aI+//0FxUPfw8im
         F7wTRsa7H17BJasBodI5gvjyIvuiHYpTM8WC2uVJKlGuntzoDqibX61103wAdDlOzlVz
         v4RJ4TaNbT0mnqNpxW3ErUTKH9bpqidRSrNJ/mGf+RhU62SLcxLxyudSrPaiwYq99PG1
         6ELGKf/S7lXtLQUR0uGdzTr/1gYr1iZNvPpu/6K/MjL0i8WsSdFjRVSMalnYw/YzGpI+
         oa6iRTzpKq6G/ce9+qHGH32p5QgvU8wKcYCGdCTBCFCK4NbSVrTC+P4eDZGPug8jpYQ+
         lHgQ==
X-Gm-Message-State: AAQBX9dbmukEYDE+ZTU9yvdsc/dz/s05+zhYzXJwPQIhfS709arYqMg+
        tMi7epLhZ3dxi0n6ZyLhSE9mmam5T2nBgLaDQ6XgSw==
X-Google-Smtp-Source: AKy350ZpcJsxHn1qF7hQs2xuoTclfv0jUi0f1qL1zyJ2ioqmRg4963+nmYBSlo1WRK+/j1jfc1uDEg==
X-Received: by 2002:a17:902:f541:b0:1a6:523c:8589 with SMTP id h1-20020a170902f54100b001a6523c8589mr14970360plf.5.1682285191172;
        Sun, 23 Apr 2023 14:26:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5-20020a1709029b8500b0019ea9e5815bsm5449447plp.45.2023.04.23.14.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 14:26:30 -0700 (PDT)
Message-ID: <6445a286.170a0220.a03c1.b480@mx.google.com>
Date:   Sun, 23 Apr 2023 14:26:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-565-g56b80e8066ad4
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 138 runs,
 7 regressions (v6.1.22-565-g56b80e8066ad4)
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

stable-rc/linux-6.1.y baseline: 138 runs, 7 regressions (v6.1.22-565-g56b80=
e8066ad4)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22-565-g56b80e8066ad4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22-565-g56b80e8066ad4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      56b80e8066ad46a5547a638c809e6d08cb8738dc =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64456bfca2dc4668182e860f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456bfca2dc4668182e8614
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-23T17:33:25.745365  + set +x

    2023-04-23T17:33:25.751847  <8>[   10.330811] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10095375_1.4.2.3.1>

    2023-04-23T17:33:25.856156  / # #

    2023-04-23T17:33:25.957210  export SHELL=3D/bin/sh

    2023-04-23T17:33:25.957395  #

    2023-04-23T17:33:26.058300  / # export SHELL=3D/bin/sh. /lava-10095375/=
environment

    2023-04-23T17:33:26.058506  =


    2023-04-23T17:33:26.159671  / # . /lava-10095375/environment/lava-10095=
375/bin/lava-test-runner /lava-10095375/1

    2023-04-23T17:33:26.160744  =


    2023-04-23T17:33:26.203881  / # /lava-10095375/bin/lava-test-runner /la=
va-10095375/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64456bdeefb4e022ae2e85f5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456bdeefb4e022ae2e85fa
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-23T17:32:57.860015  + set<8>[   12.065293] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10095440_1.4.2.3.1>

    2023-04-23T17:32:57.860145   +x

    2023-04-23T17:32:57.965355  / # #

    2023-04-23T17:32:58.068420  export SHELL=3D/bin/sh

    2023-04-23T17:32:58.068637  #

    2023-04-23T17:32:58.169593  / # export SHELL=3D/bin/sh. /lava-10095440/=
environment

    2023-04-23T17:32:58.169826  =


    2023-04-23T17:32:58.270719  / # . /lava-10095440/environment/lava-10095=
440/bin/lava-test-runner /lava-10095440/1

    2023-04-23T17:32:58.271083  =


    2023-04-23T17:32:58.275404  / # /lava-10095440/bin/lava-test-runner /la=
va-10095440/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/64456a869e55c99a672e85f2

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456a869e55c99a672e8624
        failing since 4 days (last pass: v6.1.22-178-gf8a7fa4a96bb, first f=
ail: v6.1.22-480-g90c08f549ee7)

    2023-04-23T17:27:13.695647  + set +x
    2023-04-23T17:27:13.699507  <8>[   18.386357] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 375124_1.5.2.4.1>
    2023-04-23T17:27:13.816148  / # #
    2023-04-23T17:27:13.918833  export SHELL=3D/bin/sh
    2023-04-23T17:27:13.919304  #
    2023-04-23T17:27:14.020906  / # export SHELL=3D/bin/sh. /lava-375124/en=
vironment
    2023-04-23T17:27:14.021461  =

    2023-04-23T17:27:14.123046  / # . /lava-375124/environment/lava-375124/=
bin/lava-test-runner /lava-375124/1
    2023-04-23T17:27:14.124005  =

    2023-04-23T17:27:14.131032  / # /lava-375124/bin/lava-test-runner /lava=
-375124/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64456bd6f2e02711472e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456bd6f2e02711472e85f9
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-23T17:32:53.003219  + <8>[   10.598821] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10095395_1.4.2.3.1>

    2023-04-23T17:32:53.003308  set +x

    2023-04-23T17:32:53.104961  #

    2023-04-23T17:32:53.105255  =


    2023-04-23T17:32:53.206262  / # #export SHELL=3D/bin/sh

    2023-04-23T17:32:53.206471  =


    2023-04-23T17:32:53.307424  / # export SHELL=3D/bin/sh. /lava-10095395/=
environment

    2023-04-23T17:32:53.307634  =


    2023-04-23T17:32:53.408599  / # . /lava-10095395/environment/lava-10095=
395/bin/lava-test-runner /lava-10095395/1

    2023-04-23T17:32:53.408890  =

 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64456bd5f2e02711472e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456bd5f2e02711472e85ee
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-23T17:32:47.415023  <8>[    8.013235] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10095391_1.4.2.3.1>

    2023-04-23T17:32:47.418390  + set +x

    2023-04-23T17:32:47.526262  / # #

    2023-04-23T17:32:47.628850  export SHELL=3D/bin/sh

    2023-04-23T17:32:47.629586  #

    2023-04-23T17:32:47.731237  / # export SHELL=3D/bin/sh. /lava-10095391/=
environment

    2023-04-23T17:32:47.732004  =


    2023-04-23T17:32:47.833868  / # . /lava-10095391/environment/lava-10095=
391/bin/lava-test-runner /lava-10095391/1

    2023-04-23T17:32:47.835045  =


    2023-04-23T17:32:47.839884  / # /lava-10095391/bin/lava-test-runner /la=
va-10095391/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64456bd7efb4e022ae2e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456bd7efb4e022ae2e85ed
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-23T17:32:44.222911  + <8>[    8.628522] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10095412_1.4.2.3.1>

    2023-04-23T17:32:44.223384  set +x

    2023-04-23T17:32:44.332375  / # #

    2023-04-23T17:32:44.435039  export SHELL=3D/bin/sh

    2023-04-23T17:32:44.435784  #

    2023-04-23T17:32:44.537612  / # export SHELL=3D/bin/sh. /lava-10095412/=
environment

    2023-04-23T17:32:44.538401  =


    2023-04-23T17:32:44.640393  / # . /lava-10095412/environment/lava-10095=
412/bin/lava-test-runner /lava-10095412/1

    2023-04-23T17:32:44.641800  =


    2023-04-23T17:32:44.646162  / # /lava-10095412/bin/lava-test-runner /la=
va-10095412/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64456bd419bf2f2f4e2e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
565-g56b80e8066ad4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64456bd419bf2f2f4e2e85ee
        failing since 24 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-23T17:32:48.617315  + set +x<8>[   11.317806] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10095390_1.4.2.3.1>

    2023-04-23T17:32:48.617431  =


    2023-04-23T17:32:48.721917  / # #

    2023-04-23T17:32:48.822905  export SHELL=3D/bin/sh

    2023-04-23T17:32:48.823163  #

    2023-04-23T17:32:48.924059  / # export SHELL=3D/bin/sh. /lava-10095390/=
environment

    2023-04-23T17:32:48.924250  =


    2023-04-23T17:32:49.025307  / # . /lava-10095390/environment/lava-10095=
390/bin/lava-test-runner /lava-10095390/1

    2023-04-23T17:32:49.025688  =


    2023-04-23T17:32:49.030587  / # /lava-10095390/bin/lava-test-runner /la=
va-10095390/1
 =

    ... (12 line(s) more)  =

 =20
