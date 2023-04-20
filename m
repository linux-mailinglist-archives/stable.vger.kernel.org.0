Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C704D6E9A7F
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 19:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjDTRSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 13:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjDTRS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 13:18:27 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2393AA6
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 10:18:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-246bb512038so885105a91.1
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 10:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682011104; x=1684603104;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KLLhBmE/i9xtfvb2CEokRVLVvOCwzbJtbPAESqkdvi4=;
        b=DxTUGrjikOz6TKTPactOQkt5cl2c817rFI9KBRO2O03M8DTWHa5eHJ8GIrNX8BWbrt
         j9loXtQxKH5eg1e9NhP/uDg/F1rvDhymfBUq4rSJsCIYgi5UpTF8GTEA+3in681evUsp
         5p5ofn3OjRMWM+hHRE78spT4fxDx7PDAB2J/R9DqXK+o4PG/hsU+CyNPOh5rEcipBUAG
         uavJguE5mKO0KGfMNZZ9CXxtKCqaa3aneea557VBzuHHBJBVG1ce3wrmKk/WDyyo1U0A
         KPC9xnp17vkex5yO0gigWyD1pDdNZDYsVDlxZZL7TtWnTce6KVfSxP56qjFXcsDWefEM
         h9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682011104; x=1684603104;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KLLhBmE/i9xtfvb2CEokRVLVvOCwzbJtbPAESqkdvi4=;
        b=TTwVAeZ4laiXfxmIeOcO4zXNaXSqjiOK/cteWdfku4InqZdTBcAEPFea7gWbHKVxDQ
         a59HwbPWi8kP3edenh9D6yltsQ6s3/3I9ODY7v3/3sKtkQfQFsJjCh/qFPZpluvxP84i
         MtLU3h50RhNZYYiwRc9IvuAnQ/maLAsO5ke4EYoUWebozDLuY9g9D1u/x7g3iOdvDFL0
         G8H7onBORhTHDumiD+mB89FlVHWKUvyEN9UujlWFXVqD22vmTX/9hzZtbBkzK/cinO0d
         pXBkKMFLLyOqcWjrPGIrEthlEsl+HtyT0QLmq4NDXCKNYkYLBRxdhK4sZGnUPU67CRz0
         n6pQ==
X-Gm-Message-State: AAQBX9eBeT6J54ySLpYgzSDLniqAwmF3nXHazXvmbV5OiiCftoFFGwue
        qXBf8eED2/ISzHMk+a8WmXI3YHjNIbVqX/9ig1eYxxGx
X-Google-Smtp-Source: AKy350YSk32oh8lG2s8YpLQ5WDFIFTs+Pj+ptdDo5L6Gd0ADlsSHVjS53hC/xL5S2CnH4ndhlvdlAw==
X-Received: by 2002:a17:90a:ca81:b0:247:a272:71be with SMTP id y1-20020a17090aca8100b00247a27271bemr2224762pjt.46.1682011103984;
        Thu, 20 Apr 2023 10:18:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gt17-20020a17090af2d100b0023a84911df2sm1451747pjb.7.2023.04.20.10.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 10:18:23 -0700 (PDT)
Message-ID: <644173df.170a0220.8e711.35c1@mx.google.com>
Date:   Thu, 20 Apr 2023 10:18:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v6.1.25
X-Kernelci-Report-Type: test
Subject: stable/linux-6.1.y baseline: 140 runs, 10 regressions (v6.1.25)
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

stable/linux-6.1.y baseline: 140 runs, 10 regressions (v6.1.25)

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

sun7i-a20-cubieboard2        | arm    | lab-baylibre  | gcc-10   | sunxi_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.25/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.25
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f17b0ab65d17988d5e6d6fe22f708ef3721080bf =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644140526fc84129a12e8673

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C436=
FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C436=
FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644140526fc84129a12e8678
        failing since 20 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-20T13:38:08.790319  + set +x

    2023-04-20T13:38:08.796817  <8>[    9.870580] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10062022_1.4.2.3.1>

    2023-04-20T13:38:08.901818  / # #

    2023-04-20T13:38:09.002744  export SHELL=3D/bin/sh

    2023-04-20T13:38:09.002999  #

    2023-04-20T13:38:09.103914  / # export SHELL=3D/bin/sh. /lava-10062022/=
environment

    2023-04-20T13:38:09.104129  =


    2023-04-20T13:38:09.205123  / # . /lava-10062022/environment/lava-10062=
022/bin/lava-test-runner /lava-10062022/1

    2023-04-20T13:38:09.205411  =


    2023-04-20T13:38:09.211618  / # /lava-10062022/bin/lava-test-runner /la=
va-10062022/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6441401b6325fb846d2e8697

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-CM14=
00CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-CM14=
00CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441401b6325fb846d2e869c
        failing since 20 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-20T13:37:10.809337  + set<8>[   11.556480] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10061966_1.4.2.3.1>

    2023-04-20T13:37:10.809919   +x

    2023-04-20T13:37:10.918425  / # #

    2023-04-20T13:37:11.021361  export SHELL=3D/bin/sh

    2023-04-20T13:37:11.022133  #

    2023-04-20T13:37:11.124046  / # export SHELL=3D/bin/sh. /lava-10061966/=
environment

    2023-04-20T13:37:11.124902  =


    2023-04-20T13:37:11.226776  / # . /lava-10061966/environment/lava-10061=
966/bin/lava-test-runner /lava-10061966/1

    2023-04-20T13:37:11.228203  =


    2023-04-20T13:37:11.232990  / # /lava-10061966/bin/lava-test-runner /la=
va-10061966/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6441404f6fc84129a12e864c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx94=
00-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx94=
00-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441404f6fc84129a12e8651
        failing since 20 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-20T13:38:05.323270  <8>[    7.754096] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10062034_1.4.2.3.1>

    2023-04-20T13:38:05.326579  + set +x

    2023-04-20T13:38:05.428246  #

    2023-04-20T13:38:05.428641  =


    2023-04-20T13:38:05.529734  / # #export SHELL=3D/bin/sh

    2023-04-20T13:38:05.529934  =


    2023-04-20T13:38:05.630879  / # export SHELL=3D/bin/sh. /lava-10062034/=
environment

    2023-04-20T13:38:05.631106  =


    2023-04-20T13:38:05.732040  / # . /lava-10062034/environment/lava-10062=
034/bin/lava-test-runner /lava-10062034/1

    2023-04-20T13:38:05.732411  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/644141866758b69bd62e86c1

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644141866758b69bd62e86f4
        failing since 34 days (last pass: v6.1.19, first fail: v6.1.20)

    2023-04-20T13:43:08.868069  + set +x
    2023-04-20T13:43:08.872175  <8>[   17.334113] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 361385_1.5.2.4.1>
    2023-04-20T13:43:08.988323  / # #
    2023-04-20T13:43:09.091093  export SHELL=3D/bin/sh
    2023-04-20T13:43:09.091782  #
    2023-04-20T13:43:09.193718  / # export SHELL=3D/bin/sh. /lava-361385/en=
vironment
    2023-04-20T13:43:09.194431  =

    2023-04-20T13:43:09.296261  / # . /lava-361385/environment/lava-361385/=
bin/lava-test-runner /lava-361385/1
    2023-04-20T13:43:09.297509  =

    2023-04-20T13:43:09.303571  / # /lava-361385/bin/lava-test-runner /lava=
-361385/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6441403d5c2819890d2e8650

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
2b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
2b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441403d5c2819890d2e8655
        failing since 20 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-20T13:37:52.867151  + set +x

    2023-04-20T13:37:52.873754  <8>[   10.074886] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061995_1.4.2.3.1>

    2023-04-20T13:37:52.981789  / # #

    2023-04-20T13:37:53.082707  export SHELL=3D/bin/sh

    2023-04-20T13:37:53.082907  #

    2023-04-20T13:37:53.184017  / # export SHELL=3D/bin/sh. /lava-10061995/=
environment

    2023-04-20T13:37:53.184845  =


    2023-04-20T13:37:53.286734  / # . /lava-10061995/environment/lava-10061=
995/bin/lava-test-runner /lava-10061995/1

    2023-04-20T13:37:53.287257  =


    2023-04-20T13:37:53.292022  / # /lava-10061995/bin/lava-test-runner /la=
va-10061995/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6441400418a1042ce12e860b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441400418a1042ce12e8610
        failing since 20 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-20T13:36:53.516441  <8>[   10.138994] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061978_1.4.2.3.1>

    2023-04-20T13:36:53.519863  + set +x

    2023-04-20T13:36:53.624787  / # #

    2023-04-20T13:36:53.725883  export SHELL=3D/bin/sh

    2023-04-20T13:36:53.726081  #

    2023-04-20T13:36:53.827032  / # export SHELL=3D/bin/sh. /lava-10061978/=
environment

    2023-04-20T13:36:53.827259  =


    2023-04-20T13:36:53.928236  / # . /lava-10061978/environment/lava-10061=
978/bin/lava-test-runner /lava-10061978/1

    2023-04-20T13:36:53.928596  =


    2023-04-20T13:36:53.933966  / # /lava-10061978/bin/lava-test-runner /la=
va-10061978/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6441403df08beb22152e85f6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441403df08beb22152e85fb
        failing since 20 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-20T13:37:45.993558  + set<8>[   10.833428] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10062010_1.4.2.3.1>

    2023-04-20T13:37:45.994045   +x

    2023-04-20T13:37:46.102033  / # #

    2023-04-20T13:37:46.204971  export SHELL=3D/bin/sh

    2023-04-20T13:37:46.205751  #

    2023-04-20T13:37:46.307341  / # export SHELL=3D/bin/sh. /lava-10062010/=
environment

    2023-04-20T13:37:46.308177  =


    2023-04-20T13:37:46.410237  / # . /lava-10062010/environment/lava-10062=
010/bin/lava-test-runner /lava-10062010/1

    2023-04-20T13:37:46.411535  =


    2023-04-20T13:37:46.417069  / # /lava-10062010/bin/lava-test-runner /la=
va-10062010/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6441403f6fc84129a12e85fa

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo-TP=
ad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo-TP=
ad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441403f6fc84129a12e85ff
        failing since 20 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-20T13:37:50.810654  + <8>[   12.029776] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10062026_1.4.2.3.1>

    2023-04-20T13:37:50.811201  set +x

    2023-04-20T13:37:50.920505  / # #

    2023-04-20T13:37:51.023440  export SHELL=3D/bin/sh

    2023-04-20T13:37:51.024312  #

    2023-04-20T13:37:51.126058  / # export SHELL=3D/bin/sh. /lava-10062026/=
environment

    2023-04-20T13:37:51.126830  =


    2023-04-20T13:37:51.228509  / # . /lava-10062026/environment/lava-10062=
026/bin/lava-test-runner /lava-10062026/1

    2023-04-20T13:37:51.229729  =


    2023-04-20T13:37:51.234945  / # /lava-10062026/bin/lava-test-runner /la=
va-10062026/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/6441420e3c30d36b7b2e8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6441420e3c30d36b7b2e8=
634
        new failure (last pass: v6.1.24) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-baylibre  | gcc-10   | sunxi_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64413cfb4b09257cc72e85e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/arm=
/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/arm=
/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64413cfb4b09257cc72e8=
5e8
        new failure (last pass: v6.1.24) =

 =20
