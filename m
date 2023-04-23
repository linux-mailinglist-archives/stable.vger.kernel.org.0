Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3C06EC224
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 21:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjDWT6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 15:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjDWT6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 15:58:01 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C804E5D
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 12:58:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a6715ee82fso42716815ad.1
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 12:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682279879; x=1684871879;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDvjKjSUMEBNp/tEStZb1g/Zpsydwrf5DsnDUE2fwGk=;
        b=RiLcVXWtWNKsFw4UjIL3eM3YnOXRBWj51XAABschjOLBuyujXniJ6/ruumAkuGwHWZ
         IHa0l7b5dRmRRyhoabkbuwhuq66CTpFILk/HHEDraWwbzrD/0MSdbSEQeM9WrFq7hcBV
         o9cbcdEp0EC1HsG8LpV9wpIZrlvpuCQx5ZFdrzwBhobJPvqeq60n1sKMfQKbvwZppgOO
         GKspg8rKoix+DXFOfiYoSpQ3I9eoSj8LlP+1TH4ARqRyHQIrVSy7VX1yD8ZfLxSwQjbD
         5y2cjCbKaR8aAEGTwy4gO8JdHq4BtZYG/fCi/j+oJxbwITIR/mMqOImcrd8mTDmRDS+T
         gt7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682279879; x=1684871879;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZDvjKjSUMEBNp/tEStZb1g/Zpsydwrf5DsnDUE2fwGk=;
        b=PLoLqCaA1dP1tOehJH710Ngxdlv6Mye3ELsdC6xDOlAijmihv+E4SnRQ2cA5oYaTyL
         eMMLZe9Q6hYt93Tc4oQ4TNk3l4kabRLIv+pQ1RbnORj+MsEjUiCHkQ0QkZN2p+v9AhcK
         kWPQb/3yjoDc/QYxU4r2JQPHioyJC8qNlBOb9Td9mRv8eWEHflicWxgJQmYvzYqmdxJr
         c6gkdJ0oSdshtI9tO0tcwAFwVm7RsSlQOzJidcqUhfGdOp8DJETXJd/LznZukZvXfuTM
         uWyPn0gHigpsM+JURiFk/Orwp8AkQFD5C6mRyr4JJUUOGJIhm2m1ySZAtnA5/6jBdDF5
         +kZQ==
X-Gm-Message-State: AAQBX9dHUcrmzIzkeWOtWHhS2SUyuPOVGvK4QZjE3DnLyWQ3wNaBVC1a
        57G4F6zYpvkeDhvL2FFASx0k5VM3fGM9Mo/VhRFWWw==
X-Google-Smtp-Source: AKy350bSnmMOIMXkGW6YHxkP85+Gn4ZiY8W/B0aLAwAuDTrL0kX5/3/xXzLl3wvXXadloUNLB+I5ZA==
X-Received: by 2002:a17:902:c613:b0:1a9:3916:c2d1 with SMTP id r19-20020a170902c61300b001a93916c2d1mr9191129plr.54.1682279879545;
        Sun, 23 Apr 2023 12:57:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g4-20020a1709026b4400b0019a6cce2060sm5364472plt.57.2023.04.23.12.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 12:57:59 -0700 (PDT)
Message-ID: <64458dc7.170a0220.a9f54.a833@mx.google.com>
Date:   Sun, 23 Apr 2023 12:57:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.238-235-g3cbd3ff2fa405
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 67 runs,
 5 regressions (v5.4.238-235-g3cbd3ff2fa405)
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

stable-rc/queue/5.4 baseline: 67 runs, 5 regressions (v5.4.238-235-g3cbd3ff=
2fa405)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

imx6dl-udoo                  | arm    | lab-broonie   | gcc-10   | imx_v6_v=
7_defconfig          | 1          =

imx6q-udoo                   | arm    | lab-broonie   | gcc-10   | imx_v6_v=
7_defconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.238-235-g3cbd3ff2fa405/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-235-g3cbd3ff2fa405
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3cbd3ff2fa40570bd6d5866c53604bc656de9e87 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64455bc52a979066482e8610

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/64455bc52a979066=
482e8618
        failing since 186 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-04-23T16:24:22.253616  / # =

    2023-04-23T16:24:22.261816  =

    2023-04-23T16:24:22.367302  / # #
    2023-04-23T16:24:22.373905  #
    2023-04-23T16:24:22.476083  / # export SHELL=3D/bin/sh
    2023-04-23T16:24:22.486195  export SHELL=3D/bin/sh
    2023-04-23T16:24:22.588204  / # . /lava-3524714/environment
    2023-04-23T16:24:22.598312  . /lava-3524714/environment
    2023-04-23T16:24:22.700550  / # /lava-3524714/bin/lava-test-runner /lav=
a-3524714/0
    2023-04-23T16:24:22.709910  /lava-3524714/bin/lava-test-runner /lava-35=
24714/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64455ba8d19259e27d2e8616

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64455ba8d19259e27d2e861b
        failing since 25 days (last pass: v5.4.238-29-g39c31e43e3b2b, first=
 fail: v5.4.238-60-gcf51829325af)

    2023-04-23T16:23:49.294780  + set<8>[    9.985889] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10094735_1.4.2.3.1>

    2023-04-23T16:23:49.295259   +x

    2023-04-23T16:23:49.403173  =


    2023-04-23T16:23:49.504172  / # #export SHELL=3D/bin/sh

    2023-04-23T16:23:49.504440  =


    2023-04-23T16:23:49.605440  / # export SHELL=3D/bin/sh. /lava-10094735/=
environment

    2023-04-23T16:23:49.605626  =


    2023-04-23T16:23:49.706706  / # . /lava-10094735/environment/lava-10094=
735/bin/lava-test-runner /lava-10094735/1

    2023-04-23T16:23:49.707974  =


    2023-04-23T16:23:49.712191  / # /lava-10094735/bin/lava-test-runner /la=
va-10094735/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64455b71ccc3c528272e85f1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64455b71ccc3c528272e85f6
        failing since 25 days (last pass: v5.4.238-29-g39c31e43e3b2b, first=
 fail: v5.4.238-60-gcf51829325af)

    2023-04-23T16:22:59.330249  <8>[   13.054958] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10094695_1.4.2.3.1>

    2023-04-23T16:22:59.333467  + set +x

    2023-04-23T16:22:59.438016  / # #

    2023-04-23T16:22:59.539134  export SHELL=3D/bin/sh

    2023-04-23T16:22:59.539369  #

    2023-04-23T16:22:59.640404  / # export SHELL=3D/bin/sh. /lava-10094695/=
environment

    2023-04-23T16:22:59.640632  =


    2023-04-23T16:22:59.741642  / # . /lava-10094695/environment/lava-10094=
695/bin/lava-test-runner /lava-10094695/1

    2023-04-23T16:22:59.741977  =


    2023-04-23T16:22:59.747315  / # /lava-10094695/bin/lava-test-runner /la=
va-10094695/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx6dl-udoo                  | arm    | lab-broonie   | gcc-10   | imx_v6_v=
7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64455c01f6ca90bf0b2e8613

  Results:     29 PASS, 4 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/arm/imx_v6_v7_defconfig/gcc-10/lab-broonie/baseline-imx6d=
l-udoo.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/arm/imx_v6_v7_defconfig/gcc-10/lab-broonie/baseline-imx6d=
l-udoo.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.sound-card-probed: https://kernelci.org/test/case/id/64=
455c01f6ca90bf0b2e861d
        new failure (last pass: v5.4.238-227-g75c0c97923426)

    2023-04-23T16:25:21.087727  /lava-374805/1/../bin/lava-test-case
    2023-04-23T16:25:21.128271  <8>[   21.143642] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dsound-card-probed RESULT=3Dfail>   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx6q-udoo                   | arm    | lab-broonie   | gcc-10   | imx_v6_v=
7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64455bc22a979066482e85e7

  Results:     29 PASS, 4 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/arm/imx_v6_v7_defconfig/gcc-10/lab-broonie/baseline-imx6q=
-udoo.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
35-g3cbd3ff2fa405/arm/imx_v6_v7_defconfig/gcc-10/lab-broonie/baseline-imx6q=
-udoo.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.sound-card-probed: https://kernelci.org/test/case/id/64=
455bc22a979066482e85f1
        new failure (last pass: v5.4.238-227-g75c0c97923426)

    2023-04-23T16:24:10.672551  /lava-374802/1/../bin/lava-test-case
    2023-04-23T16:24:10.711274  <8>[   21.441862] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dsound-card-probed RESULT=3Dfail>   =

 =20
