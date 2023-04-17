Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87E56E49BC
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 15:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDQNSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 09:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjDQNRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 09:17:46 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCB8270F
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 06:17:11 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id s23-20020a17090aba1700b00247a8f0dd50so1571207pjr.1
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 06:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681737428; x=1684329428;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0vRsZxspwauE7pI8eBe7ODtKdmMqUu4UCuAUzQXd4tg=;
        b=Ilsem8iivZS68iScQr0IvCKRBmVki/+27QAG2s/fg/+5ncsSnDPR1wOilRFhVu+OZM
         rKqmah8aIO7czUDQE6FewdRMznFzu2YG1eHY/v/jeKBowPRVSeTJlI2XuvcBCR+5m6W0
         iBPghxQMEDhixwt59594FQ/ZGn/aGTTSwOgT6qF+m3k+WyUUpRlb3aSc7WTzLuszC+lL
         AqRtH+pqlpzeWFmVqERea2Z32d+zWOeoLtKPAHVMfpa1Xe1W+BKU+fEjaFl+qniN4Dzc
         mksJpB2FbozWfHbvx+P8PGgGChvY8LKT3nPhDhoWcPL1rwTGn8WNKn+RRnDNbHqt2vW2
         upFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681737428; x=1684329428;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0vRsZxspwauE7pI8eBe7ODtKdmMqUu4UCuAUzQXd4tg=;
        b=Du0A2FBbgCD7ycMQmOVAMdVf8KpEmVr5NforrqPnElFldKhp2fOsyb5q90mc8YIOBd
         BpFCss9OQOPE1d0VoZsdkwfiXqaL0mjo1R6f/HJBsZOCFKiMMHyy2JDIUj5edVuOhEWi
         V1Vl899dbk/5nlqfWpFbjJFtUbvM3WwkYLwYVx3ZLPsMMeYQvfqul1HSyshdtZTv+2bQ
         0een5ACfjcEygFpfU7DORGjVzHpnLnEe59iKnClo2XFSRBoqlvwWthphcdaIdtHvhE12
         aS8CyIFUp8KZD0nskyiwilM7H++mzxpMSYcU/A/7RAfxjHeyMjDLX0wxtgWVMUVSLavJ
         AwGQ==
X-Gm-Message-State: AAQBX9fW/GiMTIZIvK6ihW3KcPb7U/+qB8gzhpwNCMaP1HTeuoFoMVRq
        VvhcT4vUut2Q+LxUIvMAxpYybBf+sPdn/kjXgFx5YPub
X-Google-Smtp-Source: AKy350Y/pz+/39wd9STLtM1ewKXeVCXueb91ZDYPPvBEUfn3FVqDFHyG5WvZOvGjOtND56D/9pPUdA==
X-Received: by 2002:a17:903:247:b0:19d:1bc1:ce22 with SMTP id j7-20020a170903024700b0019d1bc1ce22mr15561525plh.5.1681737427445;
        Mon, 17 Apr 2023 06:17:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c14d00b001a69dfd918dsm5754977plj.187.2023.04.17.06.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 06:17:06 -0700 (PDT)
Message-ID: <643d46d2.170a0220.b0e90.b8a7@mx.google.com>
Date:   Mon, 17 Apr 2023 06:17:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-462-g16a9aa862d1a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 183 runs,
 16 regressions (v6.1.22-462-g16a9aa862d1a)
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

stable-rc/queue/6.1 baseline: 183 runs, 16 regressions (v6.1.22-462-g16a9aa=
862d1a)

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
el/v6.1.22-462-g16a9aa862d1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-462-g16a9aa862d1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      16a9aa862d1aaf64bb35df86375baf020860b5ae =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d12c2b6ecded6c72e85ed

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d12c2b6ecded6c72e85f2
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T09:34:43.791808  <8>[   10.353025] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10017603_1.4.2.3.1>

    2023-04-17T09:34:43.794961  + set +x

    2023-04-17T09:34:43.899639  / # #

    2023-04-17T09:34:44.000600  export SHELL=3D/bin/sh

    2023-04-17T09:34:44.000760  #

    2023-04-17T09:34:44.101632  / # export SHELL=3D/bin/sh. /lava-10017603/=
environment

    2023-04-17T09:34:44.101798  =


    2023-04-17T09:34:44.202699  / # . /lava-10017603/environment/lava-10017=
603/bin/lava-test-runner /lava-10017603/1

    2023-04-17T09:34:44.203007  =


    2023-04-17T09:34:44.208945  / # /lava-10017603/bin/lava-test-runner /la=
va-10017603/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d12bc487aa991f02e861e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d12bc487aa991f02e8623
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T09:34:40.781535  + set<8>[   11.408914] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10017532_1.4.2.3.1>

    2023-04-17T09:34:40.782130   +x

    2023-04-17T09:34:40.890843  / # #

    2023-04-17T09:34:40.993767  export SHELL=3D/bin/sh

    2023-04-17T09:34:40.994517  #

    2023-04-17T09:34:41.096438  / # export SHELL=3D/bin/sh. /lava-10017532/=
environment

    2023-04-17T09:34:41.097217  =


    2023-04-17T09:34:41.199119  / # . /lava-10017532/environment/lava-10017=
532/bin/lava-test-runner /lava-10017532/1

    2023-04-17T09:34:41.200365  =


    2023-04-17T09:34:41.205696  / # /lava-10017532/bin/lava-test-runner /la=
va-10017532/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d12cc487aa991f02e86b8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d12cc487aa991f02e86bd
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T09:34:55.341098  <8>[   11.328067] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10017559_1.4.2.3.1>

    2023-04-17T09:34:55.344399  + set +x

    2023-04-17T09:34:55.450397  =


    2023-04-17T09:34:55.552552  / # #export SHELL=3D/bin/sh

    2023-04-17T09:34:55.552769  =


    2023-04-17T09:34:55.653704  / # export SHELL=3D/bin/sh. /lava-10017559/=
environment

    2023-04-17T09:34:55.653928  =


    2023-04-17T09:34:55.754856  / # . /lava-10017559/environment/lava-10017=
559/bin/lava-test-runner /lava-10017559/1

    2023-04-17T09:34:55.755563  =


    2023-04-17T09:34:55.760679  / # /lava-10017559/bin/lava-test-runner /la=
va-10017559/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643d111261353b19e52e8619

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d111261353b19e52e8647
        failing since 0 day (last pass: v6.1.22-446-gccec7b96e5e7, first fa=
il: v6.1.22-454-g7711a076dd12)

    2023-04-17T09:27:19.011602  + set +x
    2023-04-17T09:27:19.016462  <8>[   16.927867] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 341706_1.5.2.4.1>
    2023-04-17T09:27:19.131754  / # #
    2023-04-17T09:27:19.234254  export SHELL=3D/bin/sh
    2023-04-17T09:27:19.234726  #
    2023-04-17T09:27:19.336223  / # export SHELL=3D/bin/sh. /lava-341706/en=
vironment
    2023-04-17T09:27:19.337064  =

    2023-04-17T09:27:19.438915  / # . /lava-341706/environment/lava-341706/=
bin/lava-test-runner /lava-341706/1
    2023-04-17T09:27:19.439641  =

    2023-04-17T09:27:19.445868  / # /lava-341706/bin/lava-test-runner /lava=
-341706/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0f78c3da0b3bfb2e86f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d0f78c3da0b3bfb2e8=
6fa
        failing since 0 day (last pass: v6.1.22-446-gccec7b96e5e7, first fa=
il: v6.1.22-454-g7711a076dd12) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d12b0d48d29d9ca2e861e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d12b0d48d29d9ca2e8623
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T09:34:30.349664  + set +x

    2023-04-17T09:34:30.356560  <8>[   10.631174] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10017617_1.4.2.3.1>

    2023-04-17T09:34:30.461184  / # #

    2023-04-17T09:34:30.562230  export SHELL=3D/bin/sh

    2023-04-17T09:34:30.562435  #

    2023-04-17T09:34:30.663344  / # export SHELL=3D/bin/sh. /lava-10017617/=
environment

    2023-04-17T09:34:30.663547  =


    2023-04-17T09:34:30.764427  / # . /lava-10017617/environment/lava-10017=
617/bin/lava-test-runner /lava-10017617/1

    2023-04-17T09:34:30.764722  =


    2023-04-17T09:34:30.769267  / # /lava-10017617/bin/lava-test-runner /la=
va-10017617/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d12b9487aa991f02e8613

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d12b9487aa991f02e8618
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T09:34:41.534649  <8>[   10.213010] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10017599_1.4.2.3.1>

    2023-04-17T09:34:41.538260  + set +x

    2023-04-17T09:34:41.642858  / # #

    2023-04-17T09:34:41.745563  export SHELL=3D/bin/sh

    2023-04-17T09:34:41.746244  #

    2023-04-17T09:34:41.848158  / # export SHELL=3D/bin/sh. /lava-10017599/=
environment

    2023-04-17T09:34:41.848892  =


    2023-04-17T09:34:41.950648  / # . /lava-10017599/environment/lava-10017=
599/bin/lava-test-runner /lava-10017599/1

    2023-04-17T09:34:41.951795  =


    2023-04-17T09:34:41.957288  / # /lava-10017599/bin/lava-test-runner /la=
va-10017599/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d12c8b6ecded6c72e85fa

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d12c8b6ecded6c72e85ff
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T09:34:46.534795  + set +x<8>[   11.149153] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10017602_1.4.2.3.1>

    2023-04-17T09:34:46.534879  =


    2023-04-17T09:34:46.639525  / # #

    2023-04-17T09:34:46.740632  export SHELL=3D/bin/sh

    2023-04-17T09:34:46.741375  #

    2023-04-17T09:34:46.843184  / # export SHELL=3D/bin/sh. /lava-10017602/=
environment

    2023-04-17T09:34:46.843930  =


    2023-04-17T09:34:46.945499  / # . /lava-10017602/environment/lava-10017=
602/bin/lava-test-runner /lava-10017602/1

    2023-04-17T09:34:46.946703  =


    2023-04-17T09:34:46.951251  / # /lava-10017602/bin/lava-test-runner /la=
va-10017602/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d12be228968d0062e860b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d12be228968d0062e8610
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T09:34:43.040732  <8>[   12.034773] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10017574_1.4.2.3.1>

    2023-04-17T09:34:43.145069  / # #

    2023-04-17T09:34:43.246035  export SHELL=3D/bin/sh

    2023-04-17T09:34:43.246231  #

    2023-04-17T09:34:43.347123  / # export SHELL=3D/bin/sh. /lava-10017574/=
environment

    2023-04-17T09:34:43.347317  =


    2023-04-17T09:34:43.448013  / # . /lava-10017574/environment/lava-10017=
574/bin/lava-test-runner /lava-10017574/1

    2023-04-17T09:34:43.448297  =


    2023-04-17T09:34:43.453017  / # /lava-10017574/bin/lava-test-runner /la=
va-10017574/1

    2023-04-17T09:34:43.460181  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643d119d90253a00082e85e7

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/643d119d90253a0=
0082e85ef
        failing since 0 day (last pass: v6.1.22-438-gda4a613e2013, first fa=
il: v6.1.22-446-gccec7b96e5e7)
        1 lines

    2023-04-17T09:29:42.424607  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 00000000, epc =3D=3D 00000000, ra =3D=
=3D 8023f81c
    2023-04-17T09:29:42.424820  =


    2023-04-17T09:29:42.460447  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-17T09:29:42.460652  =

   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0f32e2a51f5c3f2e85f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv64.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv64.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d0f32e2a51f5c3f2e8=
5f2
        failing since 0 day (last pass: v6.1.22-446-gccec7b96e5e7, first fa=
il: v6.1.22-454-g7711a076dd12) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d15b0009f8a4f1d2e86cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d15b0009f8a4f1d2e8=
6d0
        failing since 0 day (last pass: v6.1.22-446-gccec7b96e5e7, first fa=
il: v6.1.22-454-g7711a076dd12) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0fd3e19f8508a82e85ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv64.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv64.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d0fd3e19f8508a82e8=
5ed
        failing since 0 day (last pass: v6.1.22-446-gccec7b96e5e7, first fa=
il: v6.1.22-454-g7711a076dd12) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0f33e2a51f5c3f2e85f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_risc=
v64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_risc=
v64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d0f33e2a51f5c3f2e8=
5f8
        failing since 0 day (last pass: v6.1.22-446-gccec7b96e5e7, first fa=
il: v6.1.22-454-g7711a076dd12) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d15ecbd909562982e8619

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d15ecbd909562982e8=
61a
        failing since 0 day (last pass: v6.1.22-446-gccec7b96e5e7, first fa=
il: v6.1.22-454-g7711a076dd12) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643d0fd32cfacf72d82e85e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_ris=
cv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-46=
2-g16a9aa862d1a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_ris=
cv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643d0fd32cfacf72d82e8=
5ea
        failing since 0 day (last pass: v6.1.22-446-gccec7b96e5e7, first fa=
il: v6.1.22-454-g7711a076dd12) =

 =20
