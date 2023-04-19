Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD676E7ABC
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 15:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbjDSN26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 09:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbjDSN24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 09:28:56 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B52167D2
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 06:28:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a682eee3baso19968325ad.0
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 06:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681910899; x=1684502899;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FesVjCSpf+mNKpw9afszPyvmC+WbVNtZAYDk3jjUCBc=;
        b=KLyEoZtRx9lrCZc5zsa5qqZrOUYGFqJNzuWmA554gpviVVilJZ/VHZFe9NaCcSxqs2
         WvOQkLnDzQDsi5zUT82myONzJ+83yY1R9y2zlpkBvuX5e5mkl3bVT2WXSA0Bl1r9HA8g
         FAdCa8RDaQS1aTh3g5Z0c5plF2FEaTn3H3Ox0E/hNUKvTmd8E/bqhtaZoskeLLER115z
         M0s7LU9W+fgUL9a93xotdZqlXDiykdSe3Zspuv8ShsD6cePyPb9AnN+p8klqpWfur64n
         xyPF2oJtWkGUTI4O26bIHIzWDtCuPBG0OadowI5wKyXWXCN9G6OYVhOW4V+zEGO4IfFI
         eOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910899; x=1684502899;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FesVjCSpf+mNKpw9afszPyvmC+WbVNtZAYDk3jjUCBc=;
        b=hMhxwRem2PMaSOnKZ3SMLsx/6AP5XF2vmGd1klrvCTXIL/2Tt0KeTXKkLU2RvErDfv
         RAhiurBPz3ke1HanfEnjg1OmyJ4Zzq2Wh+LkpJjDoBSaOCDvqwSGiOVFVuTDRuIvcoHK
         3Nb6EyNCOzWzUNR6sPVQAGGLD2ppk/S83I1Z0m3EHqQz8Ysz6+3ldLwrzWzg9x6SBXxy
         7tp6KZypmNZVrB3HJIDS9RLP1Es7P/nHmmdhkrMdC4Qs7EyfwaeFAfObe1p/PRB4uHhN
         BSn+/NXj6UvKFL2FDPCtPIeXH0CTspn0CjkFu4yASJTEfESjToPGJTWqT/86thU1FUKG
         C2Bw==
X-Gm-Message-State: AAQBX9dcbWUxkN8g3oNZv49H9e89gGkVi1V5Pg4dCfbBZzW9J+41XbVh
        95oif3toXVV0+6aR/crhDwqZuRH4L1bPDjHT5iIVVLd5
X-Google-Smtp-Source: AKy350a6qBWKu6rPEWn24aVJmS/jRWnA4U0KLTmfX2Pv4J+qb3M4iJJxLPsQDWXXrxtKk4SA2y+9cw==
X-Received: by 2002:a17:903:2481:b0:1a2:9ce6:6483 with SMTP id p1-20020a170903248100b001a29ce66483mr4622127plw.64.1681910899047;
        Wed, 19 Apr 2023 06:28:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902a40b00b001a240f053aasm588231plq.180.2023.04.19.06.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:28:18 -0700 (PDT)
Message-ID: <643fec72.170a0220.5ea4e.0e0a@mx.google.com>
Date:   Wed, 19 Apr 2023 06:28:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-276-g7437085161d70
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 177 runs,
 17 regressions (v5.15.105-276-g7437085161d70)
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

stable-rc/queue/5.15 baseline: 177 runs, 17 regressions (v5.15.105-276-g743=
7085161d70)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

qemu_riscv64                 | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_riscv64                 | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_riscv64                 | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-276-g7437085161d70/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-276-g7437085161d70
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7437085161d70f330e00cd8dac51c87d7cca46b5 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fbac1190e6da7bb2e864b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fbac1190e6da7bb2e8650
        failing since 21 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T09:55:52.685276  + set +x

    2023-04-19T09:55:52.692031  <8>[   10.802896] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10043778_1.4.2.3.1>

    2023-04-19T09:55:52.801014  / # #

    2023-04-19T09:55:52.903957  export SHELL=3D/bin/sh

    2023-04-19T09:55:52.904762  #

    2023-04-19T09:55:53.006623  / # export SHELL=3D/bin/sh. /lava-10043778/=
environment

    2023-04-19T09:55:53.007512  =


    2023-04-19T09:55:53.109597  / # . /lava-10043778/environment/lava-10043=
778/bin/lava-test-runner /lava-10043778/1

    2023-04-19T09:55:53.110954  =


    2023-04-19T09:55:53.116176  / # /lava-10043778/bin/lava-test-runner /la=
va-10043778/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fba4206b6fe7bfe2e860f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fba4206b6fe7bfe2e8614
        failing since 21 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T09:53:57.533998  + set<8>[   11.678986] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10043734_1.4.2.3.1>

    2023-04-19T09:53:57.534586   +x

    2023-04-19T09:53:57.642776  / # #

    2023-04-19T09:53:57.745635  export SHELL=3D/bin/sh

    2023-04-19T09:53:57.746525  #

    2023-04-19T09:53:57.848480  / # export SHELL=3D/bin/sh. /lava-10043734/=
environment

    2023-04-19T09:53:57.849453  =


    2023-04-19T09:53:57.951647  / # . /lava-10043734/environment/lava-10043=
734/bin/lava-test-runner /lava-10043734/1

    2023-04-19T09:53:57.952901  =


    2023-04-19T09:53:57.957806  / # /lava-10043734/bin/lava-test-runner /la=
va-10043734/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fba3e92c3abc4852e8657

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fba3e92c3abc4852e865c
        failing since 21 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T09:53:45.385782  <8>[   10.948396] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10043727_1.4.2.3.1>

    2023-04-19T09:53:45.389119  + set +x

    2023-04-19T09:53:45.490722  #

    2023-04-19T09:53:45.490982  =


    2023-04-19T09:53:45.592070  / # #export SHELL=3D/bin/sh

    2023-04-19T09:53:45.592282  =


    2023-04-19T09:53:45.693216  / # export SHELL=3D/bin/sh. /lava-10043727/=
environment

    2023-04-19T09:53:45.693418  =


    2023-04-19T09:53:45.794353  / # . /lava-10043727/environment/lava-10043=
727/bin/lava-test-runner /lava-10043727/1

    2023-04-19T09:53:45.794611  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643fbadaac5aae0fce2e873d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fbadaac5aae0fce2e8=
73e
        failing since 74 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fbbb5b3e2499db52e8654

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fbbb5b3e2499db52e8659
        failing since 92 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-19T09:59:57.067363  <8>[    9.919138] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3511486_1.5.2.4.1>
    2023-04-19T09:59:57.175199  / # #
    2023-04-19T09:59:57.276928  export SHELL=3D/bin/sh
    2023-04-19T09:59:57.277343  #
    2023-04-19T09:59:57.277582  / # export SHELL=3D/bin/sh<3>[   10.112819]=
 Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-19T09:59:57.378900  . /lava-3511486/environment
    2023-04-19T09:59:57.379284  =

    2023-04-19T09:59:57.480499  / # . /lava-3511486/environment/lava-351148=
6/bin/lava-test-runner /lava-3511486/1
    2023-04-19T09:59:57.481083  =

    2023-04-19T09:59:57.486025  / # /lava-3511486/bin/lava-test-runner /lav=
a-3511486/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fbac6ac5aae0fce2e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fbac6ac5aae0fce2e8=
5e7
        failing since 2 days (last pass: v5.15.105-244-g4632bdfc359d, first=
 fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fbaeb2206f09d2e2e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fbaeb2206f09d2e2e860d
        failing since 21 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T09:56:42.127734  + set +x

    2023-04-19T09:56:42.134357  <8>[    9.906092] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10043787_1.4.2.3.1>

    2023-04-19T09:56:42.239358  / # #

    2023-04-19T09:56:42.340449  export SHELL=3D/bin/sh

    2023-04-19T09:56:42.340668  #

    2023-04-19T09:56:42.441623  / # export SHELL=3D/bin/sh. /lava-10043787/=
environment

    2023-04-19T09:56:42.441837  =


    2023-04-19T09:56:42.542729  / # . /lava-10043787/environment/lava-10043=
787/bin/lava-test-runner /lava-10043787/1

    2023-04-19T09:56:42.543035  =


    2023-04-19T09:56:42.547903  / # /lava-10043787/bin/lava-test-runner /la=
va-10043787/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fba2518b22dd2902e8621

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fba2518b22dd2902e8626
        failing since 21 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T09:53:26.486438  + set +x

    2023-04-19T09:53:26.493182  <8>[    9.992326] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10043760_1.4.2.3.1>

    2023-04-19T09:53:26.598235  / # #

    2023-04-19T09:53:26.699331  export SHELL=3D/bin/sh

    2023-04-19T09:53:26.699561  #

    2023-04-19T09:53:26.800477  / # export SHELL=3D/bin/sh. /lava-10043760/=
environment

    2023-04-19T09:53:26.800669  =


    2023-04-19T09:53:26.901547  / # . /lava-10043760/environment/lava-10043=
760/bin/lava-test-runner /lava-10043760/1

    2023-04-19T09:53:26.901930  =


    2023-04-19T09:53:26.906338  / # /lava-10043760/bin/lava-test-runner /la=
va-10043760/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fba3f06b6fe7bfe2e85f9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fba3f06b6fe7bfe2e85fe
        failing since 21 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T09:53:44.002165  + <8>[   11.369402] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10043755_1.4.2.3.1>

    2023-04-19T09:53:44.002256  set +x

    2023-04-19T09:53:44.106388  / # #

    2023-04-19T09:53:44.207328  export SHELL=3D/bin/sh

    2023-04-19T09:53:44.207512  #

    2023-04-19T09:53:44.308382  / # export SHELL=3D/bin/sh. /lava-10043755/=
environment

    2023-04-19T09:53:44.308544  =


    2023-04-19T09:53:44.409471  / # . /lava-10043755/environment/lava-10043=
755/bin/lava-test-runner /lava-10043755/1

    2023-04-19T09:53:44.409765  =


    2023-04-19T09:53:44.414906  / # /lava-10043755/bin/lava-test-runner /la=
va-10043755/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fbb78ecd4a442762e8632

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fbb78ecd4a442762e8637
        failing since 81 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-19T09:58:57.778721  + set +x
    2023-04-19T09:58:57.779119  [    9.389716] <LAVA_SIGNAL_ENDRUN 0_dmesg =
930589_1.5.2.3.1>
    2023-04-19T09:58:57.886810  / # #
    2023-04-19T09:58:57.988955  export SHELL=3D/bin/sh
    2023-04-19T09:58:57.989441  #
    2023-04-19T09:58:58.090719  / # export SHELL=3D/bin/sh. /lava-930589/en=
vironment
    2023-04-19T09:58:58.091294  =

    2023-04-19T09:58:58.193248  / # . /lava-930589/environment/lava-930589/=
bin/lava-test-runner /lava-930589/1
    2023-04-19T09:58:58.193984  =

    2023-04-19T09:58:58.196943  / # /lava-930589/bin/lava-test-runner /lava=
-930589/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fba2618b22dd2902e862c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fba2618b22dd2902e8631
        failing since 21 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T09:53:29.586619  <8>[   12.069595] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10043751_1.4.2.3.1>

    2023-04-19T09:53:29.691250  / # #

    2023-04-19T09:53:29.792326  export SHELL=3D/bin/sh

    2023-04-19T09:53:29.792581  #

    2023-04-19T09:53:29.893491  / # export SHELL=3D/bin/sh. /lava-10043751/=
environment

    2023-04-19T09:53:29.893699  =


    2023-04-19T09:53:29.994594  / # . /lava-10043751/environment/lava-10043=
751/bin/lava-test-runner /lava-10043751/1

    2023-04-19T09:53:29.994899  =


    2023-04-19T09:53:29.999293  / # /lava-10043751/bin/lava-test-runner /la=
va-10043751/1

    2023-04-19T09:53:30.005221  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb8b90fde919f992e8604

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fb8b90fde919f992e8=
605
        failing since 2 days (last pass: v5.15.105-244-g4632bdfc359d, first=
 fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fbe592410d7c0ca2e862e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fbe592410d7c0ca2e8=
62f
        failing since 2 days (last pass: v5.15.105-244-g4632bdfc359d, first=
 fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb86f9993f6fc662e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_risc=
v64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_risc=
v64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fb86f9993f6fc662e8=
5e7
        failing since 2 days (last pass: v5.15.105-244-g4632bdfc359d, first=
 fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb8bba944cfb99d2e8611

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_=
riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_=
riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fb8bba944cfb99d2e8=
612
        failing since 2 days (last pass: v5.15.105-244-g4632bdfc359d, first=
 fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fbe5aecd283a44e2e8624

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_r=
iscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_r=
iscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fbe5aecd283a44e2e8=
625
        failing since 2 days (last pass: v5.15.105-244-g4632bdfc359d, first=
 fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb8709993f6fc662e85e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8=
_riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-276-g7437085161d70/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8=
_riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fb8709993f6fc662e8=
5ea
        failing since 2 days (last pass: v5.15.105-244-g4632bdfc359d, first=
 fail: v5.15.105-251-ge618cb6cad09) =

 =20
