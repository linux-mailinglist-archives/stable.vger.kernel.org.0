Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E526E7F78
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 18:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbjDSQVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 12:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjDSQVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 12:21:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C415D86AC
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 09:20:55 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x8-20020a17090a6b4800b002474c5d3367so692217pjl.2
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 09:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681921255; x=1684513255;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3c10rDSE73vcLWlT7lQKiUWP0XrK9r6e+naEBruqTiw=;
        b=1Tq09WwIcg4c3d6vfFwHPF0QnEXq459HHzYZFZl5FUrvsELvjzM1vx0zHmykZG62xs
         t3C3pJczHW2c0/Z5qcCIK2B/oXBEruZWx5BgsimDmwPyKzOPIRdMkyWnISbk9Yk9sK9U
         YSPU6gV4G7toO6pgwp0rxvZmnULTfytvO4h3v23pHduu4UNhVBykMqr+2DV8c0aKwSX3
         GBc/VoiyJ38hOJ5QyQ70nPvT5i70li2I32WODYZmkg2Y90Dui9VgoDhDvFuAemePOYql
         ip936VdEF5H9xTF5Sx6jHHPQHQob83qXAhX/t7pt5+/igz4gPEvPcc1OwpEl4X4rF/ET
         fhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921255; x=1684513255;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3c10rDSE73vcLWlT7lQKiUWP0XrK9r6e+naEBruqTiw=;
        b=TmywotMMI0KqBcaoE3ZjKxJdREIhG5y4S0+dvMsVcSA7Q5uW4qrD7M6msOClKxt7kw
         Vgde//IHQCjnj4i+SNTVm6t2uUtN5vucUJzfqtpKPRB4uVZR2vRqrB+DxYzsqhtAy9BJ
         rRgJ4FkOfbvceqI7l1JIG5ypW6fwxWLcCfVV86EWTgVZpV/tPquAzM6I5LeLzchEpY4U
         YaJUWklIH4tRQycrN3WYFDzV8IxCUP5lJa8sMcJxwRJH4V3ZMEYLsz0r79Iy+L/8WT8M
         p6SWgP1QCc/ObXfoZ1aVmPUiLAAFOTFuGlIaein53UYGbDKhIMRmN6/S4EMWDV/yNL8J
         pnuQ==
X-Gm-Message-State: AAQBX9fTKF9tqds6/MPoxxFsncyreancojie4s+cI2Y7jYqQwQWvqIAQ
        IzJ1mFQt9WXGkTVarr+4oO4LkVAQ5zG+cVrayYlXxIF+
X-Google-Smtp-Source: AKy350ZV79punRVaMWX8zY+m4I14bGGEuRY9hBmqUANWOxKp6SN3H6E44ChOq0ZDYa3E3e4em4KPkw==
X-Received: by 2002:a05:6a20:72a4:b0:f0:a283:4854 with SMTP id o36-20020a056a2072a400b000f0a2834854mr3313863pzk.13.1681921254594;
        Wed, 19 Apr 2023 09:20:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8-20020a634b48000000b0051ba4d6fe4fsm6023500pgl.56.2023.04.19.09.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:20:54 -0700 (PDT)
Message-ID: <644014e6.630a0220.7b879.d7cb@mx.google.com>
Date:   Wed, 19 Apr 2023 09:20:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-477-g2128d4458cbc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 178 runs,
 15 regressions (v6.1.22-477-g2128d4458cbc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 178 runs, 15 regressions (v6.1.22-477-g2128d4=
458cbc)

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

hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

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

qemu_riscv64                 | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_riscv64                 | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_riscv64                 | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-477-g2128d4458cbc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-477-g2128d4458cbc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2128d4458cbcea29012df8507cba5b5f6566b28e =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fded1cab621f6042e8621

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fded1cab621f6042e8626
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T12:29:48.794221  + set +x

    2023-04-19T12:29:48.801088  <8>[    7.976665] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10045694_1.4.2.3.1>

    2023-04-19T12:29:48.908832  / # #

    2023-04-19T12:29:49.010403  export SHELL=3D/bin/sh

    2023-04-19T12:29:49.010571  #

    2023-04-19T12:29:49.111537  / # export SHELL=3D/bin/sh. /lava-10045694/=
environment

    2023-04-19T12:29:49.112221  =


    2023-04-19T12:29:49.214115  / # . /lava-10045694/environment/lava-10045=
694/bin/lava-test-runner /lava-10045694/1

    2023-04-19T12:29:49.215349  =


    2023-04-19T12:29:49.220979  / # /lava-10045694/bin/lava-test-runner /la=
va-10045694/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdeccfd178c291b2e85f6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fdeccfd178c291b2e85fb
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T12:29:49.238860  + set<8>[   11.713075] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10045720_1.4.2.3.1>

    2023-04-19T12:29:49.239421   +x

    2023-04-19T12:29:49.349121  / # #

    2023-04-19T12:29:49.452500  export SHELL=3D/bin/sh

    2023-04-19T12:29:49.453388  #

    2023-04-19T12:29:49.555575  / # export SHELL=3D/bin/sh. /lava-10045720/=
environment

    2023-04-19T12:29:49.555818  =


    2023-04-19T12:29:49.657055  / # . /lava-10045720/environment/lava-10045=
720/bin/lava-test-runner /lava-10045720/1

    2023-04-19T12:29:49.658462  =


    2023-04-19T12:29:49.663136  / # /lava-10045720/bin/lava-test-runner /la=
va-10045720/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdecb9efad6ee322e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fdecb9efad6ee322e85fc
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T12:29:47.955938  <8>[   10.049713] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10045700_1.4.2.3.1>

    2023-04-19T12:29:47.958985  + set +x

    2023-04-19T12:29:48.064906  =


    2023-04-19T12:29:48.167269  / # #export SHELL=3D/bin/sh

    2023-04-19T12:29:48.168066  =


    2023-04-19T12:29:48.269793  / # export SHELL=3D/bin/sh. /lava-10045700/=
environment

    2023-04-19T12:29:48.270605  =


    2023-04-19T12:29:48.372564  / # . /lava-10045700/environment/lava-10045=
700/bin/lava-test-runner /lava-10045700/1

    2023-04-19T12:29:48.373791  =


    2023-04-19T12:29:48.379261  / # /lava-10045700/bin/lava-test-runner /la=
va-10045700/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdd798605a0e1fa2e85f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fdd798605a0e1fa2e8=
5f3
        new failure (last pass: v6.1.22-479-g7149a0de08fa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdec99efad6ee322e85ec

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fdec99efad6ee322e85f1
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T12:29:46.705224  + set +x

    2023-04-19T12:29:46.711411  <8>[   10.981976] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10045752_1.4.2.3.1>

    2023-04-19T12:29:46.816468  / # #

    2023-04-19T12:29:46.917388  export SHELL=3D/bin/sh

    2023-04-19T12:29:46.917564  #

    2023-04-19T12:29:47.018424  / # export SHELL=3D/bin/sh. /lava-10045752/=
environment

    2023-04-19T12:29:47.018593  =


    2023-04-19T12:29:47.119491  / # . /lava-10045752/environment/lava-10045=
752/bin/lava-test-runner /lava-10045752/1

    2023-04-19T12:29:47.119864  =


    2023-04-19T12:29:47.124524  / # /lava-10045752/bin/lava-test-runner /la=
va-10045752/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdeb5eeb753c4ff2e85f1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fdeb5eeb753c4ff2e85f6
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T12:29:25.672032  + set +x

    2023-04-19T12:29:25.678542  <8>[   10.212915] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10045733_1.4.2.3.1>

    2023-04-19T12:29:25.781007  #

    2023-04-19T12:29:25.882236  / # #export SHELL=3D/bin/sh

    2023-04-19T12:29:25.882395  =


    2023-04-19T12:29:25.983251  / # export SHELL=3D/bin/sh. /lava-10045733/=
environment

    2023-04-19T12:29:25.983447  =


    2023-04-19T12:29:26.084394  / # . /lava-10045733/environment/lava-10045=
733/bin/lava-test-runner /lava-10045733/1

    2023-04-19T12:29:26.084655  =


    2023-04-19T12:29:26.090141  / # /lava-10045733/bin/lava-test-runner /la=
va-10045733/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdec4a330d175e42e8631

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fdec4a330d175e42e8636
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T12:29:46.230541  + set<8>[   11.065149] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10045743_1.4.2.3.1>

    2023-04-19T12:29:46.231122   +x

    2023-04-19T12:29:46.339548  / # #

    2023-04-19T12:29:46.442482  export SHELL=3D/bin/sh

    2023-04-19T12:29:46.443361  #

    2023-04-19T12:29:46.545457  / # export SHELL=3D/bin/sh. /lava-10045743/=
environment

    2023-04-19T12:29:46.546258  =


    2023-04-19T12:29:46.648443  / # . /lava-10045743/environment/lava-10045=
743/bin/lava-test-runner /lava-10045743/1

    2023-04-19T12:29:46.649738  =


    2023-04-19T12:29:46.654813  / # /lava-10045743/bin/lava-test-runner /la=
va-10045743/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdeb6eeb753c4ff2e8607

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fdeb6eeb753c4ff2e860c
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T12:29:28.762876  + <8>[   12.217585] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10045740_1.4.2.3.1>

    2023-04-19T12:29:28.762962  set +x

    2023-04-19T12:29:28.867938  / # #

    2023-04-19T12:29:28.969099  export SHELL=3D/bin/sh

    2023-04-19T12:29:28.969282  #

    2023-04-19T12:29:29.070167  / # export SHELL=3D/bin/sh. /lava-10045740/=
environment

    2023-04-19T12:29:29.070354  =


    2023-04-19T12:29:29.171241  / # . /lava-10045740/environment/lava-10045=
740/bin/lava-test-runner /lava-10045740/1

    2023-04-19T12:29:29.171528  =


    2023-04-19T12:29:29.176033  / # /lava-10045740/bin/lava-test-runner /la=
va-10045740/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe168a1fd57fbab2e85e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe168a1fd57fbab2e8=
5e8
        failing since 1 day (last pass: v6.1.22-462-g16a9aa862d1a, first fa=
il: v6.1.22-479-g35f051d5ebe4) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdd373cef1203ed2e863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv64.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv64.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fdd373cef1203ed2e8=
63c
        new failure (last pass: v6.1.22-479-g7149a0de08fa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe51fa4f54bd8492e85e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe51fa4f54bd8492e8=
5e8
        new failure (last pass: v6.1.22-479-g7149a0de08fa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdd096a0bb9698a2e861b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv64.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv64.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fdd096a0bb9698a2e8=
61c
        new failure (last pass: v6.1.22-479-g7149a0de08fa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdd383cef1203ed2e863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_risc=
v64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_risc=
v64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fdd383cef1203ed2e8=
63f
        new failure (last pass: v6.1.22-479-g7149a0de08fa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe54724bb160de62e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe54724bb160de62e8=
5e7
        new failure (last pass: v6.1.22-479-g7149a0de08fa) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fdd08dba2a0935e2e85e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_ris=
cv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
7-g2128d4458cbc/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_ris=
cv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fdd08dba2a0935e2e8=
5e8
        new failure (last pass: v6.1.22-479-g7149a0de08fa) =

 =20
