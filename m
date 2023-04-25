Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC026EE6FF
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 19:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbjDYRjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 13:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbjDYRjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 13:39:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0858D15457
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 10:38:47 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b5fca48bcso5098527b3a.0
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 10:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682444325; x=1685036325;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=E+aQmpIMM9Eip6WaNv/Ut4e6+ftmovXj3y2biDuYD98=;
        b=Gtxb0Z9srZmjpXoggzz6/wSITiMjUsO0aHq98fACA66nf/qXKiSlXX+8wKYOxOnK69
         2zHS9CAf/GG7IdekDEFjwd+FlSXtPHFK4BqFLr551Qg5kLsqQBmypRNr5eMB1uWf81T9
         Rtm5kU5aCw4JY/+gCxKnH6I12RBu+DPaH+YhmWo0H4VFL4jBJmuuKc/LEN5txQTltZF5
         uyAHSZpSxxpNbqbdO9yKrEzL2iwO/9yik9Md4DuWYGI9XbqoZa/fhFpF3btpF0sCnjmO
         A81kGQYB7D1NI25InNLMONWZXWZhmazGMfkPtRq4eNaZDz1kb42gI9EpCNcN2370uh83
         rFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682444325; x=1685036325;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E+aQmpIMM9Eip6WaNv/Ut4e6+ftmovXj3y2biDuYD98=;
        b=eBsiqLAb1IIVQPcBw260u900meXBaWbhlqIJd3IHH6pDriGdpJrP6/d9fGSSEXMDY4
         PxP9S+LQMydeV7sOWIWrJPZmQrIwS042XI00iNGdAKGavzfnssCUXV6MBI7cR6mOpWHW
         4YkS+X63hEjvELevScyHDEwl/LVGv3NYunoQk5i0GjKK0rdM2ruFkcjoiydYaItvkqwK
         r8INRxqeUBB1Pcx5fwImSf/rvDJPNmg8pWzfrnU83dTlkdJ44X0HeS6eajn5VM1uPSkB
         k7oDOuvCIYjR7WKADNUX78vV8UYR3gkFljWcMU5fzZ/hToivCCSxULIeDVv4xjUSFPaP
         htqA==
X-Gm-Message-State: AAQBX9eZGGQazTDixQWxq6qlzjJT/S75nr6fRvTIaUVIFPOL50J5qHQ0
        xpX2R2ClsR5dXlx5ONkdxwQJjyEU5cyfV9fe3vwsyiVP
X-Google-Smtp-Source: AKy350YH9cAT1lqf5EUsR/kjcYPXuaDm5NSUV+zx8Szx9ddfpyCzZiw1aZrxP1JXpFWB1s7rxpWx/g==
X-Received: by 2002:a05:6a00:1951:b0:63d:4752:4da3 with SMTP id s17-20020a056a00195100b0063d47524da3mr25251023pfk.25.1682444325111;
        Tue, 25 Apr 2023 10:38:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m30-20020a62a21e000000b0062ddaa823bfsm9512636pff.185.2023.04.25.10.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 10:38:44 -0700 (PDT)
Message-ID: <64481024.620a0220.b4f72.30a7@mx.google.com>
Date:   Tue, 25 Apr 2023 10:38:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-573-gb59efb7adcb8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 118 runs,
 9 regressions (v6.1.22-573-gb59efb7adcb8)
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

stable-rc/queue/6.1 baseline: 118 runs, 9 regressions (v6.1.22-573-gb59efb7=
adcb8)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
acer-R721T-grunt             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

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
el/v6.1.22-573-gb59efb7adcb8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-573-gb59efb7adcb8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b59efb7adcb8594c73455d80983cb3616a7a890f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
acer-R721T-grunt             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447f36e58825efcca2e8619

  Results:     18 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-acer-R721T-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-acer-R721T-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6447f36e58825ef=
cca2e862c
        new failure (last pass: v6.1.22-573-gdac6f9da57aaa)
        1 lines

    2023-04-25T15:36:07.838810  kern  :emerg : __common_interrupt: 1.55 No =
irq handler for vector<8>[   11.011719] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>

    2023-04-25T15:36:07.838905  =

   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447dca02762abc9592e85ef

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447dca02762abc9592e85f4
        failing since 27 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-25T13:58:28.165034  <8>[   11.911588] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10118292_1.4.2.3.1>

    2023-04-25T13:58:28.168274  + set +x

    2023-04-25T13:58:28.272655  / # #

    2023-04-25T13:58:28.373376  export SHELL=3D/bin/sh

    2023-04-25T13:58:28.373634  #

    2023-04-25T13:58:28.474166  / # export SHELL=3D/bin/sh. /lava-10118292/=
environment

    2023-04-25T13:58:28.474429  =


    2023-04-25T13:58:28.575024  / # . /lava-10118292/environment/lava-10118=
292/bin/lava-test-runner /lava-10118292/1

    2023-04-25T13:58:28.575418  =


    2023-04-25T13:58:28.581276  / # /lava-10118292/bin/lava-test-runner /la=
va-10118292/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447dc6623bf6682cb2e860e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447dc6623bf6682cb2e8613
        failing since 27 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-25T13:57:41.580328  + set<8>[   11.925657] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10118278_1.4.2.3.1>

    2023-04-25T13:57:41.580413   +x

    2023-04-25T13:57:41.685273  / # #

    2023-04-25T13:57:41.787958  export SHELL=3D/bin/sh

    2023-04-25T13:57:41.788660  #

    2023-04-25T13:57:41.890051  / # export SHELL=3D/bin/sh. /lava-10118278/=
environment

    2023-04-25T13:57:41.890342  =


    2023-04-25T13:57:41.990921  / # . /lava-10118278/environment/lava-10118=
278/bin/lava-test-runner /lava-10118278/1

    2023-04-25T13:57:41.991273  =


    2023-04-25T13:57:41.995671  / # /lava-10118278/bin/lava-test-runner /la=
va-10118278/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447dc438cc52676dd2e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447dc438cc52676dd2e85fc
        failing since 27 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-25T13:56:59.973380  <8>[   10.352815] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10118265_1.4.2.3.1>

    2023-04-25T13:56:59.976412  + set +x

    2023-04-25T13:57:00.078030  #

    2023-04-25T13:57:00.078414  =


    2023-04-25T13:57:00.179247  / # #export SHELL=3D/bin/sh

    2023-04-25T13:57:00.180048  =


    2023-04-25T13:57:00.281490  / # export SHELL=3D/bin/sh. /lava-10118265/=
environment

    2023-04-25T13:57:00.281722  =


    2023-04-25T13:57:00.382515  / # . /lava-10118265/environment/lava-10118=
265/bin/lava-test-runner /lava-10118265/1

    2023-04-25T13:57:00.383559  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447ddbaed5c50aac22e8642

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447ddbaed5c50aac22e8647
        failing since 27 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-25T14:03:23.612958  + set +x

    2023-04-25T14:03:23.619789  <8>[   10.500241] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10118264_1.4.2.3.1>

    2023-04-25T14:03:23.724131  / # #

    2023-04-25T14:03:23.824843  export SHELL=3D/bin/sh

    2023-04-25T14:03:23.825056  #

    2023-04-25T14:03:23.925652  / # export SHELL=3D/bin/sh. /lava-10118264/=
environment

    2023-04-25T14:03:23.925865  =


    2023-04-25T14:03:24.026411  / # . /lava-10118264/environment/lava-10118=
264/bin/lava-test-runner /lava-10118264/1

    2023-04-25T14:03:24.026717  =


    2023-04-25T14:03:24.031102  / # /lava-10118264/bin/lava-test-runner /la=
va-10118264/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447dcd210d85a497e2e85ee

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447dcd210d85a497e2e85f3
        failing since 27 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-25T13:59:24.255673  + set +x<8>[   10.535587] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10118267_1.4.2.3.1>

    2023-04-25T13:59:24.255813  =


    2023-04-25T13:59:24.357812  #

    2023-04-25T13:59:24.358143  =


    2023-04-25T13:59:24.458936  / # #export SHELL=3D/bin/sh

    2023-04-25T13:59:24.459704  =


    2023-04-25T13:59:24.561383  / # export SHELL=3D/bin/sh. /lava-10118267/=
environment

    2023-04-25T13:59:24.562357  =


    2023-04-25T13:59:24.664042  / # . /lava-10118267/environment/lava-10118=
267/bin/lava-test-runner /lava-10118267/1

    2023-04-25T13:59:24.665372  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447dc1bb056123ffb2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447dc1bb056123ffb2e85eb
        failing since 27 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-25T13:56:35.461117  + set<8>[   11.289738] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10118219_1.4.2.3.1>

    2023-04-25T13:56:35.461231   +x

    2023-04-25T13:56:35.565451  / # #

    2023-04-25T13:56:35.666460  export SHELL=3D/bin/sh

    2023-04-25T13:56:35.666693  #

    2023-04-25T13:56:35.767230  / # export SHELL=3D/bin/sh. /lava-10118219/=
environment

    2023-04-25T13:56:35.767429  =


    2023-04-25T13:56:35.867988  / # . /lava-10118219/environment/lava-10118=
219/bin/lava-test-runner /lava-10118219/1

    2023-04-25T13:56:35.868225  =


    2023-04-25T13:56:35.872793  / # /lava-10118219/bin/lava-test-runner /la=
va-10118219/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6447dc1db930e998d12e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6447dc1db930e998d12e85ed
        failing since 27 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-25T13:56:32.814333  + set +x<8>[   12.614816] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10118258_1.4.2.3.1>

    2023-04-25T13:56:32.814922  =


    2023-04-25T13:56:32.922588  / # #

    2023-04-25T13:56:33.024668  export SHELL=3D/bin/sh

    2023-04-25T13:56:33.025453  #

    2023-04-25T13:56:33.126840  / # export SHELL=3D/bin/sh. /lava-10118258/=
environment

    2023-04-25T13:56:33.127515  =


    2023-04-25T13:56:33.228834  / # . /lava-10118258/environment/lava-10118=
258/bin/lava-test-runner /lava-10118258/1

    2023-04-25T13:56:33.229916  =


    2023-04-25T13:56:33.234923  / # /lava-10118258/bin/lava-test-runner /la=
va-10118258/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/6447d78cd5dddabde22e8605

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gb59efb7adcb8/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6447d78cd5dddab=
de22e860d
        failing since 1 day (last pass: v6.1.22-560-gc4a6f990f6a64, first f=
ail: v6.1.22-564-g3588497f7ea83)
        1 lines

    2023-04-25T13:37:09.629327  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 3213685c, epc =3D=3D 80202234, ra =3D=
=3D 80204b84
    2023-04-25T13:37:09.629459  =


    2023-04-25T13:37:09.639327  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-25T13:37:09.639438  =

   =

 =20
