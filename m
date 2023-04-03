Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2526D4EFE
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 19:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjDCRbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 13:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjDCRbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 13:31:13 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090FC19A8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 10:31:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x15so27933030pjk.2
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 10:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680543068;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3rIP53UqlRtdVoD0KGI7PlVgWrE2pVcBDWsyKZon4aI=;
        b=P8uwM/c8PQoVc1uykRM8IHAqO9zyWbxv/ZSs/oup6HkYQPCMZ5BImeAi5RmN396psQ
         8zf8B2sOtZQUVQeq8AnAc3LxqH0n2P/MwD2j8QJ92J0eHLxm6yMtfnk7GG/t7x3zop7A
         xbnAiWc1dsI0jdleByuuZk+sD2dZ4VAtU2wojb0tlGERdKavbcdg+ae/m7wuSJjqn5Df
         KQKJ8JQAzxweTJfHqgl187gon2C1bt9+SinIh/AI84O4K7fEEGIPz6TAhaFmipoGM3TP
         6DkGan6eEDH9cMV5+36/ta9C6hhqIh2pGk5LXxy0oidaUhsuIGbh5PDJafEFsXqd0pB1
         Gsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680543068;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3rIP53UqlRtdVoD0KGI7PlVgWrE2pVcBDWsyKZon4aI=;
        b=mRyfuV+XUo8kvlh86IK+T8buAtXxit41lyKKf6/ixefEFigNSlKV6XdDngSaSOhbcj
         7eJxYPWeChgJCwXmOwsfTzAuWmyr4g/9k/VUZd2ta/ua+PwzqeFLToPFFMYmYc44p/nO
         HL/iMOpdpBObFaK9ysxRsUy1Xukv1jScq3pucIs9tTLTPw7BQSm6awu0l737dUUb+bd+
         0ObSr02ni6FVNomod7u7p7DVuP/DmrIUbeosu3D+Yh/d2D8SgSRDUWMKyCVhnaLTjTnc
         WmwMduKJ6d149H/XylXmSNK2ApeCtjAqAXVcVuWTFc+JAqPOhn9hNc5xVTwmtPlbB4K3
         mgEA==
X-Gm-Message-State: AAQBX9fd5+Zl3KcVd/622isnSP8edwe13EXDJfajVIc+XlS25Pdgx8M/
        bsHaWavEu+GA4mXyM0U68v3hELQ3G63zrMuvLtQmXA==
X-Google-Smtp-Source: AKy350YzGi+b3xn9LR0txuwGFb1WMXmxavdTMLPZ51F3WbSrl/sl0QYtMM3bNovxc8dfe7TCq1962A==
X-Received: by 2002:a17:902:fa46:b0:1a0:514c:c2d2 with SMTP id lb6-20020a170902fa4600b001a0514cc2d2mr32132971plb.68.1680543067959;
        Mon, 03 Apr 2023 10:31:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z21-20020a1709028f9500b00198f36a8941sm6823070plo.221.2023.04.03.10.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 10:31:07 -0700 (PDT)
Message-ID: <642b0d5b.170a0220.e15a.d5b2@mx.google.com>
Date:   Mon, 03 Apr 2023 10:31:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-171-gcd464ddaea44
Subject: stable-rc/linux-6.1.y baseline: 172 runs,
 8 regressions (v6.1.22-171-gcd464ddaea44)
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

stable-rc/linux-6.1.y baseline: 172 runs, 8 regressions (v6.1.22-171-gcd464=
ddaea44)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22-171-gcd464ddaea44/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22-171-gcd464ddaea44
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd464ddaea44d5007c6c1282d9450c45ac1945db =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad6b4ab6e5e3fb962f794

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ad6b4ab6e5e3fb962f799
        failing since 3 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-03T13:37:30.104662  <8>[    7.948350] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850937_1.4.2.3.1>

    2023-04-03T13:37:30.107824  + set +x

    2023-04-03T13:37:30.209721  #

    2023-04-03T13:37:30.210049  =


    2023-04-03T13:37:30.310989  / # #export SHELL=3D/bin/sh

    2023-04-03T13:37:30.311225  =


    2023-04-03T13:37:30.412209  / # export SHELL=3D/bin/sh. /lava-9850937/e=
nvironment

    2023-04-03T13:37:30.412409  =


    2023-04-03T13:37:30.513219  / # . /lava-9850937/environment/lava-985093=
7/bin/lava-test-runner /lava-9850937/1

    2023-04-03T13:37:30.513530  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad6b7ab6e5e3fb962f7c6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ad6b7ab6e5e3fb962f7cb
        failing since 3 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-03T13:37:49.050724  + set<8>[   11.085955] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9850957_1.4.2.3.1>

    2023-04-03T13:37:49.051164   +x

    2023-04-03T13:37:49.158539  / # #

    2023-04-03T13:37:49.261187  export SHELL=3D/bin/sh

    2023-04-03T13:37:49.261900  #

    2023-04-03T13:37:49.363610  / # export SHELL=3D/bin/sh. /lava-9850957/e=
nvironment

    2023-04-03T13:37:49.364495  =


    2023-04-03T13:37:49.466434  / # . /lava-9850957/environment/lava-985095=
7/bin/lava-test-runner /lava-9850957/1

    2023-04-03T13:37:49.467457  =


    2023-04-03T13:37:49.472381  / # /lava-9850957/bin/lava-test-runner /lav=
a-9850957/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad6a58ed9f5082462f77b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ad6a58ed9f5082462f780
        failing since 3 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-03T13:37:26.671175  <8>[   10.114594] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850911_1.4.2.3.1>

    2023-04-03T13:37:26.674733  + set +x

    2023-04-03T13:37:26.779753  #

    2023-04-03T13:37:26.882651  / # #export SHELL=3D/bin/sh

    2023-04-03T13:37:26.883449  =


    2023-04-03T13:37:26.985325  / # export SHELL=3D/bin/sh. /lava-9850911/e=
nvironment

    2023-04-03T13:37:26.986199  =


    2023-04-03T13:37:27.088369  / # . /lava-9850911/environment/lava-985091=
1/bin/lava-test-runner /lava-9850911/1

    2023-04-03T13:37:27.089550  =


    2023-04-03T13:37:27.094987  / # /lava-9850911/bin/lava-test-runner /lav=
a-9850911/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad31bd5e0c976d362f776

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ad31bd5e0c976d362f7a9
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.21-225-g=
e6bbee2ba76f)

    2023-04-03T13:22:09.735739  + set +x
    2023-04-03T13:22:09.737984  <8>[   17.482450] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 269805_1.5.2.4.1>
    2023-04-03T13:22:09.853224  / # #
    2023-04-03T13:22:09.955290  export SHELL=3D/bin/sh
    2023-04-03T13:22:09.955735  #
    2023-04-03T13:22:10.057348  / # export SHELL=3D/bin/sh. /lava-269805/en=
vironment
    2023-04-03T13:22:10.057798  =

    2023-04-03T13:22:10.159691  / # . /lava-269805/environment/lava-269805/=
bin/lava-test-runner /lava-269805/1
    2023-04-03T13:22:10.160454  =

    2023-04-03T13:22:10.167159  / # /lava-269805/bin/lava-test-runner /lava=
-269805/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad6a28ed9f5082462f76d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ad6a28ed9f5082462f772
        failing since 3 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-03T13:37:29.359559  + set +x

    2023-04-03T13:37:29.365694  <8>[   10.905570] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850938_1.4.2.3.1>

    2023-04-03T13:37:29.470739  / # #

    2023-04-03T13:37:29.571631  export SHELL=3D/bin/sh

    2023-04-03T13:37:29.571812  #

    2023-04-03T13:37:29.672695  / # export SHELL=3D/bin/sh. /lava-9850938/e=
nvironment

    2023-04-03T13:37:29.672884  =


    2023-04-03T13:37:29.773821  / # . /lava-9850938/environment/lava-985093=
8/bin/lava-test-runner /lava-9850938/1

    2023-04-03T13:37:29.774165  =


    2023-04-03T13:37:29.778412  / # /lava-9850938/bin/lava-test-runner /lav=
a-9850938/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad6aa5e534df9fe62f770

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ad6aa5e534df9fe62f775
        failing since 3 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-03T13:37:19.269142  + set +x

    2023-04-03T13:37:19.275645  <8>[    9.957583] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850929_1.4.2.3.1>

    2023-04-03T13:37:19.378281  =


    2023-04-03T13:37:19.479208  / # #export SHELL=3D/bin/sh

    2023-04-03T13:37:19.479446  =


    2023-04-03T13:37:19.580414  / # export SHELL=3D/bin/sh. /lava-9850929/e=
nvironment

    2023-04-03T13:37:19.580626  =


    2023-04-03T13:37:19.681512  / # . /lava-9850929/environment/lava-985092=
9/bin/lava-test-runner /lava-9850929/1

    2023-04-03T13:37:19.681870  =


    2023-04-03T13:37:19.687495  / # /lava-9850929/bin/lava-test-runner /lav=
a-9850929/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad6b3ab6e5e3fb962f77b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ad6b3ab6e5e3fb962f780
        failing since 3 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-03T13:37:34.451248  + set<8>[    8.683544] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9850932_1.4.2.3.1>

    2023-04-03T13:37:34.451335   +x

    2023-04-03T13:37:34.555809  / # #

    2023-04-03T13:37:34.656765  export SHELL=3D/bin/sh

    2023-04-03T13:37:34.656968  #

    2023-04-03T13:37:34.757870  / # export SHELL=3D/bin/sh. /lava-9850932/e=
nvironment

    2023-04-03T13:37:34.758090  =


    2023-04-03T13:37:34.859021  / # . /lava-9850932/environment/lava-985093=
2/bin/lava-test-runner /lava-9850932/1

    2023-04-03T13:37:34.859300  =


    2023-04-03T13:37:34.864036  / # /lava-9850932/bin/lava-test-runner /lav=
a-9850932/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad6ba9875c8839962f775

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
171-gcd464ddaea44/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ad6ba9875c8839962f77a
        failing since 3 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-03T13:37:39.210140  <8>[   11.103090] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850974_1.4.2.3.1>

    2023-04-03T13:37:39.314932  / # #

    2023-04-03T13:37:39.415881  export SHELL=3D/bin/sh

    2023-04-03T13:37:39.416065  #

    2023-04-03T13:37:39.516928  / # export SHELL=3D/bin/sh. /lava-9850974/e=
nvironment

    2023-04-03T13:37:39.517105  =


    2023-04-03T13:37:39.617888  / # . /lava-9850974/environment/lava-985097=
4/bin/lava-test-runner /lava-9850974/1

    2023-04-03T13:37:39.618195  =


    2023-04-03T13:37:39.623101  / # /lava-9850974/bin/lava-test-runner /lav=
a-9850974/1

    2023-04-03T13:37:39.629830  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
