Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B5E6ED527
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 21:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjDXTPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 15:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjDXTPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 15:15:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DE2E41
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 12:15:10 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63d4595d60fso30446064b3a.0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 12:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682363709; x=1684955709;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CalurzxPdNVhRAxBBaTVHSAJWKYF8cjnJybxi3BvNHQ=;
        b=Er3b0GwbeerHZMEX6+OsqsHPggds6BvwOGjb3QC/3sq+0Lph+6sm67zS2XNk5oQboN
         fypSiGWJixM7VFktMsSysEc8mIqIDFYJ4Dj9bFbnXqGNTiD6y2ajZIqUUUmYoFwrIyDW
         H6Si0YJNybOmpBtenaRiW85WJEDyr7LmHbMNfy/Th5r5Cr4tl0GDH4oZBc1opTxQ+x9c
         7cWFglAV5x0Uqgm2Mkz2Vf/EzDh+F7Z0pocZQ0R6iCM5KS9JWMT2VLm0QMfzWijAdrxv
         EAdjVqjCpK5WapQZ5rHFajp0dnlC3+z7q2qlwgke2Pmbte72QGzc1I4liez/9yMExv5Q
         qObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682363709; x=1684955709;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CalurzxPdNVhRAxBBaTVHSAJWKYF8cjnJybxi3BvNHQ=;
        b=duOIebizE539RgKK26fc2LRyOhu6n1dRvFH2d7Q4NXxqGeptQo25qxnbTZf0ivKBld
         x6XhPBH/MtugOoqAkz6fVQF6rBhhnzmTAJ+SN92ryYwiMDEPLKPHpJxmLT2BQXDIeSFM
         PN4xupDGxXEC+ZRb0kWIGZCJqWrhCy61o45IrH6jkFBc6DlqF+upZNzuW3yr5y7H30Xh
         5RUZpuotD2IbITZ1ztuzz3eCfbu2ovAtywMkAJ49gVe80p+6qs1TSCaI9NCUhL1HmB4S
         opPCTR9VGBoWsAawao8LdHGbbtyf6B5/b3uLkVQ7gEvUq/HEBueeANYSaOFEgcndUtDV
         dc8Q==
X-Gm-Message-State: AAQBX9cFrXo0gXqzQWVEXl5luzU8IA23sRBOm0cJT2zJ3fvhzy0/OfVe
        nNtxas241aKBjVMPBkVaa6GnNoiBnCPYu08mp3QY6Q==
X-Google-Smtp-Source: AKy350aXb84WLarxOvNdzxFOD5du+9QF5yzPkAGLjdEv/7tO6DbORpZcDL0ZI4te63libzEGVbNRKQ==
X-Received: by 2002:a05:6a20:7d9a:b0:ee:786b:d6f3 with SMTP id v26-20020a056a207d9a00b000ee786bd6f3mr17413195pzj.9.1682363709445;
        Mon, 24 Apr 2023 12:15:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10-20020aa79e8a000000b005d22639b577sm7706943pfq.165.2023.04.24.12.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 12:15:08 -0700 (PDT)
Message-ID: <6446d53c.a70a0220.ce4d.f6e0@mx.google.com>
Date:   Mon, 24 Apr 2023 12:15:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-573-gdac6f9da57aaa
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 122 runs,
 10 regressions (v6.1.22-573-gdac6f9da57aaa)
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

stable-rc/queue/6.1 baseline: 122 runs, 10 regressions (v6.1.22-573-gdac6f9=
da57aaa)

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

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

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
el/v6.1.22-573-gdac6f9da57aaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-573-gdac6f9da57aaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dac6f9da57aaaed02bd8d5f262848bac1c027da1 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64469fa73ecab8b66e2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469fa73ecab8b66e2e85eb
        failing since 26 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-24T15:26:14.855480  + set +x

    2023-04-24T15:26:14.861953  <8>[   11.181045] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10105283_1.4.2.3.1>

    2023-04-24T15:26:14.966464  / # #

    2023-04-24T15:26:15.067219  export SHELL=3D/bin/sh

    2023-04-24T15:26:15.067472  #

    2023-04-24T15:26:15.167973  / # export SHELL=3D/bin/sh. /lava-10105283/=
environment

    2023-04-24T15:26:15.168173  =


    2023-04-24T15:26:15.268653  / # . /lava-10105283/environment/lava-10105=
283/bin/lava-test-runner /lava-10105283/1

    2023-04-24T15:26:15.269000  =


    2023-04-24T15:26:15.274474  / # /lava-10105283/bin/lava-test-runner /la=
va-10105283/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64469fc875346e7d432e860c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469fc875346e7d432e8611
        failing since 26 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-24T15:26:39.348569  + set<8>[   11.894755] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10105320_1.4.2.3.1>

    2023-04-24T15:26:39.348997   +x

    2023-04-24T15:26:39.456300  / # #

    2023-04-24T15:26:39.558369  export SHELL=3D/bin/sh

    2023-04-24T15:26:39.559026  #

    2023-04-24T15:26:39.660440  / # export SHELL=3D/bin/sh. /lava-10105320/=
environment

    2023-04-24T15:26:39.661108  =


    2023-04-24T15:26:39.762404  / # . /lava-10105320/environment/lava-10105=
320/bin/lava-test-runner /lava-10105320/1

    2023-04-24T15:26:39.763466  =


    2023-04-24T15:26:39.768696  / # /lava-10105320/bin/lava-test-runner /la=
va-10105320/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64469fa93ecab8b66e2e85f6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469fa93ecab8b66e2e85fb
        failing since 26 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-24T15:26:13.619679  <8>[    9.884259] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10105272_1.4.2.3.1>

    2023-04-24T15:26:13.623450  + set +x

    2023-04-24T15:26:13.724919  =


    2023-04-24T15:26:13.825531  / # #export SHELL=3D/bin/sh

    2023-04-24T15:26:13.825768  =


    2023-04-24T15:26:13.926345  / # export SHELL=3D/bin/sh. /lava-10105272/=
environment

    2023-04-24T15:26:13.926538  =


    2023-04-24T15:26:14.027193  / # . /lava-10105272/environment/lava-10105=
272/bin/lava-test-runner /lava-10105272/1

    2023-04-24T15:26:14.027470  =


    2023-04-24T15:26:14.032060  / # /lava-10105272/bin/lava-test-runner /la=
va-10105272/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/64469f99293e8cd2832e8669

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469f99293e8cd2832e869c
        failing since 1 day (last pass: v6.1.22-556-g2944ac9cf90bf, first f=
ail: v6.1.22-556-g51522a0e29940)

    2023-04-24T15:25:52.930441  + set +x
    2023-04-24T15:25:52.933636  <8>[   16.945475] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 379749_1.5.2.4.1>
    2023-04-24T15:25:53.050627  / # #
    2023-04-24T15:25:53.153290  export SHELL=3D/bin/sh
    2023-04-24T15:25:53.153836  #
    2023-04-24T15:25:53.255931  / # export SHELL=3D/bin/sh. /lava-379749/en=
vironment
    2023-04-24T15:25:53.256638  =

    2023-04-24T15:25:53.358209  / # . /lava-379749/environment/lava-379749/=
bin/lava-test-runner /lava-379749/1
    2023-04-24T15:25:53.359238  =

    2023-04-24T15:25:53.365858  / # /lava-379749/bin/lava-test-runner /lava=
-379749/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6446a313a74ed808ea2e860f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6446a313a74ed808ea2e8=
610
        failing since 4 days (last pass: v6.1.22-477-g2128d4458cbc, first f=
ail: v6.1.22-474-gecc61872327e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64469fe46b382484f42e8606

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469fe46b382484f42e860b
        failing since 26 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-24T15:27:16.081368  + set +x

    2023-04-24T15:27:16.087997  <8>[   11.002466] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10105330_1.4.2.3.1>

    2023-04-24T15:27:16.192407  / # #

    2023-04-24T15:27:16.293092  export SHELL=3D/bin/sh

    2023-04-24T15:27:16.293305  #

    2023-04-24T15:27:16.393791  / # export SHELL=3D/bin/sh. /lava-10105330/=
environment

    2023-04-24T15:27:16.394048  =


    2023-04-24T15:27:16.494561  / # . /lava-10105330/environment/lava-10105=
330/bin/lava-test-runner /lava-10105330/1

    2023-04-24T15:27:16.494855  =


    2023-04-24T15:27:16.499885  / # /lava-10105330/bin/lava-test-runner /la=
va-10105330/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64469f96293e8cd2832e865c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469f96293e8cd2832e8661
        failing since 26 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-24T15:25:59.351240  + set +x<8>[   10.375237] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10105298_1.4.2.3.1>

    2023-04-24T15:25:59.351321  =


    2023-04-24T15:25:59.452894  / #

    2023-04-24T15:25:59.553710  # #export SHELL=3D/bin/sh

    2023-04-24T15:25:59.553885  =


    2023-04-24T15:25:59.654460  / # export SHELL=3D/bin/sh. /lava-10105298/=
environment

    2023-04-24T15:25:59.654614  =


    2023-04-24T15:25:59.755136  / # . /lava-10105298/environment/lava-10105=
298/bin/lava-test-runner /lava-10105298/1

    2023-04-24T15:25:59.755406  =


    2023-04-24T15:25:59.760449  / # /lava-10105298/bin/lava-test-runner /la=
va-10105298/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64469faa3ecab8b66e2e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469faa3ecab8b66e2e8606
        failing since 26 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-24T15:26:26.978561  + set<8>[   10.879321] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10105335_1.4.2.3.1>

    2023-04-24T15:26:26.978642   +x

    2023-04-24T15:26:27.082831  / # #

    2023-04-24T15:26:27.183493  export SHELL=3D/bin/sh

    2023-04-24T15:26:27.183711  #

    2023-04-24T15:26:27.284215  / # export SHELL=3D/bin/sh. /lava-10105335/=
environment

    2023-04-24T15:26:27.284391  =


    2023-04-24T15:26:27.384938  / # . /lava-10105335/environment/lava-10105=
335/bin/lava-test-runner /lava-10105335/1

    2023-04-24T15:26:27.385258  =


    2023-04-24T15:26:27.389967  / # /lava-10105335/bin/lava-test-runner /la=
va-10105335/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64469fab3ecab8b66e2e860c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469fab3ecab8b66e2e8611
        failing since 26 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-24T15:26:15.610836  + set +x<8>[   12.126403] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10105339_1.4.2.3.1>

    2023-04-24T15:26:15.611374  =


    2023-04-24T15:26:15.718716  / # #

    2023-04-24T15:26:15.821090  export SHELL=3D/bin/sh

    2023-04-24T15:26:15.821885  #

    2023-04-24T15:26:15.923401  / # export SHELL=3D/bin/sh. /lava-10105339/=
environment

    2023-04-24T15:26:15.924144  =


    2023-04-24T15:26:16.025617  / # . /lava-10105339/environment/lava-10105=
339/bin/lava-test-runner /lava-10105339/1

    2023-04-24T15:26:16.026812  =


    2023-04-24T15:26:16.031859  / # /lava-10105339/bin/lava-test-runner /la=
va-10105339/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/6446a04437c56a7fbd2e85f8

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gdac6f9da57aaa/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6446a04437c56a7=
fbd2e8600
        failing since 1 day (last pass: v6.1.22-560-gc4a6f990f6a64, first f=
ail: v6.1.22-564-g3588497f7ea83)
        1 lines

    2023-04-24T15:28:46.895283  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 3213685c, epc =3D=3D 80202234, ra =3D=
=3D 80204b84
    2023-04-24T15:28:46.895538  =


    2023-04-24T15:28:46.938794  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-24T15:28:46.939046  =

   =

 =20
