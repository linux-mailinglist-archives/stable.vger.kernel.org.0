Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06A86E15CF
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 22:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjDMUZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 16:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjDMUZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 16:25:21 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF0C76B9
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 13:25:18 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b5c4c769aso144035b3a.3
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 13:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681417517; x=1684009517;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=erwtoRVt7z3AupLiLXMxT+dAY7pIMVpRSJJIbS6k41E=;
        b=vDPSqJZcabNqezEzDBzI4BON6mtuEBEIfpMPGKGYeiKSsZ3KWZ1eTrMNJoqP3ltGZg
         Aa2UQwd/cgHvWJX8BJXYRcXQkMi5/PBUVdw6PshCbMBOydPuojI6BQrZ27/kcsGiq8Qa
         /pvFMg6yX/rGMZJC9sNecQPCFjDG0rOYOcIhQfB+CF/AEqJhpdxzhU4DyQuajIasKJ+a
         Poen2+LQfNxhQSAQfK5QaC0cHkN/FJjzOibzxwsIyQSkvkV1s33UwIP2PCqPJoTcjYgH
         N822uaSlJAETUfDWUxuPFMhzNnr494d0QHGYe5NrLbbOKF6+H3B7CMTvJVnaYJRH6zUb
         vUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681417517; x=1684009517;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=erwtoRVt7z3AupLiLXMxT+dAY7pIMVpRSJJIbS6k41E=;
        b=ewOYCXEG48ynEV7nshAn3vM9FXysuFIfsFuotdE8tA/VO9UTTqtgEs1q+V9h50pW7z
         03zQiKCao2kLIAe96nnP1YcAopT3AG0b/Ub4ydwJCsU2l+UwdoNegEV+gBdwrPPo6wy4
         9wI0x7cBVP6Wrdo//6Qrtw69rj0OLnJFFxaJ/ZFuL18bFUa3yylunFr5FcZztrMzhl+h
         Llb9Ra99+Pb9t101VP7KcU8AEjGPINy/Io9veBdSynquAxBnlBHWdKi5VRSr7tWslllh
         aVfUiGTcQDVkH/9xQRzAFXGy91p30e30LAD3FknP+cQTcDgmPsmnCpgqh7XPBJmCkCq5
         SOSw==
X-Gm-Message-State: AAQBX9eURQLki83Z33wqV4XxEeB2+ZhEaZOl0edin2rtH1I9spo2KTqd
        TY08cw6m/8Uo48ATi3ABtlMBmTsBH3twN/KTu+D7eK11
X-Google-Smtp-Source: AKy350Y5MFhBA1eAf7qvKSuy8TQU10hnva5OuciwyJtSJhIJf4zlArg28vcGJZjWeRIxL3gPvcKzFA==
X-Received: by 2002:a05:6a00:248a:b0:63b:64a6:570 with SMTP id c10-20020a056a00248a00b0063b64a60570mr179724pfv.26.1681417516975;
        Thu, 13 Apr 2023 13:25:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23-20020aa78d17000000b00627ed4e23e0sm1756939pfe.101.2023.04.13.13.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 13:25:16 -0700 (PDT)
Message-ID: <6438652c.a70a0220.2a1c.3dfc@mx.google.com>
Date:   Thu, 13 Apr 2023 13:25:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.107
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 261 runs, 19 regressions (v5.15.107)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 261 runs, 19 regressions (v5.15.107)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

imx8mn-ddr4-evk              | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

mt8173-elm-hana              | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm...ok+kselftest | 1          =

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre  | gcc-10   | sunxi_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.107/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.107
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4fdad925aa1a320c2f32bf956ed29100c7fdc464 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382ad8e47c5a0c412e85ff

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382ad8e47c5a0c412e8604
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:16:06.000132  + set +x

    2023-04-13T16:16:06.006626  <8>[   10.531530] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9961688_1.4.2.3.1>

    2023-04-13T16:16:06.111214  / # #

    2023-04-13T16:16:06.212277  export SHELL=3D/bin/sh

    2023-04-13T16:16:06.212463  #

    2023-04-13T16:16:06.313383  / # export SHELL=3D/bin/sh. /lava-9961688/e=
nvironment

    2023-04-13T16:16:06.313566  =


    2023-04-13T16:16:06.414487  / # . /lava-9961688/environment/lava-996168=
8/bin/lava-test-runner /lava-9961688/1

    2023-04-13T16:16:06.414763  =


    2023-04-13T16:16:06.420578  / # /lava-9961688/bin/lava-test-runner /lav=
a-9961688/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64382aefb981f936fe2e8623

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382aefb981f936fe2e8628
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:16:21.365201  + set +x

    2023-04-13T16:16:21.372034  <8>[   11.637938] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9961781_1.4.2.3.1>

    2023-04-13T16:16:21.477119  / # #

    2023-04-13T16:16:21.578152  export SHELL=3D/bin/sh

    2023-04-13T16:16:21.578354  #

    2023-04-13T16:16:21.679299  / # export SHELL=3D/bin/sh. /lava-9961781/e=
nvironment

    2023-04-13T16:16:21.679506  =


    2023-04-13T16:16:21.780476  / # . /lava-9961781/environment/lava-996178=
1/bin/lava-test-runner /lava-9961781/1

    2023-04-13T16:16:21.780771  =


    2023-04-13T16:16:21.786603  / # /lava-9961781/bin/lava-test-runner /lav=
a-9961781/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382ad9ed38de8f682e8612

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382ad9ed38de8f682e8617
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:16:14.147128  + set +x<8>[   11.493628] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9961727_1.4.2.3.1>

    2023-04-13T16:16:14.147646  =


    2023-04-13T16:16:14.255320  / # #

    2023-04-13T16:16:14.357894  export SHELL=3D/bin/sh

    2023-04-13T16:16:14.358744  #

    2023-04-13T16:16:14.460738  / # export SHELL=3D/bin/sh. /lava-9961727/e=
nvironment

    2023-04-13T16:16:14.461458  =


    2023-04-13T16:16:14.563299  / # . /lava-9961727/environment/lava-996172=
7/bin/lava-test-runner /lava-9961727/1

    2023-04-13T16:16:14.564526  =


    2023-04-13T16:16:14.569795  / # /lava-9961727/bin/lava-test-runner /lav=
a-9961727/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64382aed2910a2ba042e8630

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382aed2910a2ba042e8635
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:16:22.120779  + <8>[   11.794196] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9961749_1.4.2.3.1>

    2023-04-13T16:16:22.121355  set +x

    2023-04-13T16:16:22.229112  / # #

    2023-04-13T16:16:22.332128  export SHELL=3D/bin/sh

    2023-04-13T16:16:22.332916  #

    2023-04-13T16:16:22.434972  / # export SHELL=3D/bin/sh. /lava-9961749/e=
nvironment

    2023-04-13T16:16:22.435770  =


    2023-04-13T16:16:22.537581  / # . /lava-9961749/environment/lava-996174=
9/bin/lava-test-runner /lava-9961749/1

    2023-04-13T16:16:22.538777  =


    2023-04-13T16:16:22.543820  / # /lava-9961749/bin/lava-test-runner /lav=
a-9961749/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382ad92910a2ba042e85f3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382ad92910a2ba042e85f8
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:16:08.345141  <8>[   11.411584] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9961761_1.4.2.3.1>

    2023-04-13T16:16:08.348921  + set +x

    2023-04-13T16:16:08.450874  =


    2023-04-13T16:16:08.551851  / # #export SHELL=3D/bin/sh

    2023-04-13T16:16:08.552066  =


    2023-04-13T16:16:08.652873  / # export SHELL=3D/bin/sh. /lava-9961761/e=
nvironment

    2023-04-13T16:16:08.653090  =


    2023-04-13T16:16:08.754035  / # . /lava-9961761/environment/lava-996176=
1/bin/lava-test-runner /lava-9961761/1

    2023-04-13T16:16:08.754416  =


    2023-04-13T16:16:08.759528  / # /lava-9961761/bin/lava-test-runner /lav=
a-9961761/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64382adb7f71b79ac22e85fd

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382adb7f71b79ac22e8602
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:16:16.952616  + set +x

    2023-04-13T16:16:16.958913  <8>[   11.436477] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9961775_1.4.2.3.1>

    2023-04-13T16:16:17.064009  / # #

    2023-04-13T16:16:17.166605  export SHELL=3D/bin/sh

    2023-04-13T16:16:17.167366  #

    2023-04-13T16:16:17.269052  / # export SHELL=3D/bin/sh. /lava-9961775/e=
nvironment

    2023-04-13T16:16:17.269338  =


    2023-04-13T16:16:17.370607  / # . /lava-9961775/environment/lava-996177=
5/bin/lava-test-runner /lava-9961775/1

    2023-04-13T16:16:17.371867  =


    2023-04-13T16:16:17.377098  / # /lava-9961775/bin/lava-test-runner /lav=
a-9961775/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64382d979e935316c92e85fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64382d979e935316c92e8=
5fc
        failing since 8 days (last pass: v5.15.105, first fail: v5.15.106) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64382de58cb6e21f8e2e860b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382de58cb6e21f8e2e860e
        failing since 84 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-04-13T16:28:33.032525  <8>[    9.978434] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3491883_1.5.2.4.1>
    2023-04-13T16:28:33.144867  / # #
    2023-04-13T16:28:33.248952  export SHELL=3D/bin/sh
    2023-04-13T16:28:33.250250  #
    2023-04-13T16:28:33.352882  / # export SHELL=3D/bin/sh. /lava-3491883/e=
nvironment
    2023-04-13T16:28:33.354198  =

    2023-04-13T16:28:33.457318  / # . /lava-3491883/environment/lava-349188=
3/bin/lava-test-runner /lava-3491883/1
    2023-04-13T16:28:33.459457  =

    2023-04-13T16:28:33.464014  / # /lava-3491883/bin/lava-test-runner /lav=
a-3491883/1
    2023-04-13T16:28:33.486698  <3>[   10.433488] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382b982d440168542e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382b982d440168542e85ed
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:19:20.667876  + <8>[   10.323009] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9961705_1.4.2.3.1>

    2023-04-13T16:19:20.667984  set +x

    2023-04-13T16:19:20.770051  #

    2023-04-13T16:19:20.770461  =


    2023-04-13T16:19:20.871576  / # #export SHELL=3D/bin/sh

    2023-04-13T16:19:20.871860  =


    2023-04-13T16:19:20.972863  / # export SHELL=3D/bin/sh. /lava-9961705/e=
nvironment

    2023-04-13T16:19:20.973118  =


    2023-04-13T16:19:21.074050  / # . /lava-9961705/environment/lava-996170=
5/bin/lava-test-runner /lava-9961705/1

    2023-04-13T16:19:21.074337  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64382bb6263ca6c0ea2e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382bb6263ca6c0ea2e860d
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:19:55.299645  + set +x

    2023-04-13T16:19:55.305999  <8>[   11.940500] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9961786_1.4.2.3.1>

    2023-04-13T16:19:55.415543  / # #

    2023-04-13T16:19:55.518586  export SHELL=3D/bin/sh

    2023-04-13T16:19:55.519350  #

    2023-04-13T16:19:55.621397  / # export SHELL=3D/bin/sh. /lava-9961786/e=
nvironment

    2023-04-13T16:19:55.622211  =


    2023-04-13T16:19:55.724262  / # . /lava-9961786/environment/lava-996178=
6/bin/lava-test-runner /lava-9961786/1

    2023-04-13T16:19:55.725573  =


    2023-04-13T16:19:55.730853  / # /lava-9961786/bin/lava-test-runner /lav=
a-9961786/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382ac5ed38de8f682e85ea

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382ac5ed38de8f682e85ef
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:15:45.097916  + set +x

    2023-04-13T16:15:45.104387  <8>[   10.650826] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9961682_1.4.2.3.1>

    2023-04-13T16:15:45.207035  =


    2023-04-13T16:15:45.307823  / # #export SHELL=3D/bin/sh

    2023-04-13T16:15:45.308021  =


    2023-04-13T16:15:45.408944  / # export SHELL=3D/bin/sh. /lava-9961682/e=
nvironment

    2023-04-13T16:15:45.409159  =


    2023-04-13T16:15:45.510137  / # . /lava-9961682/environment/lava-996168=
2/bin/lava-test-runner /lava-9961682/1

    2023-04-13T16:15:45.510383  =


    2023-04-13T16:15:45.515251  / # /lava-9961682/bin/lava-test-runner /lav=
a-9961682/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64382adb45458831102e860a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382adb45458831102e860f
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:16:03.501895  + set +x

    2023-04-13T16:16:03.508127  <8>[   11.319243] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9961774_1.4.2.3.1>

    2023-04-13T16:16:03.610451  =


    2023-04-13T16:16:03.711529  / # #export SHELL=3D/bin/sh

    2023-04-13T16:16:03.711709  =


    2023-04-13T16:16:03.812489  / # export SHELL=3D/bin/sh. /lava-9961774/e=
nvironment

    2023-04-13T16:16:03.812701  =


    2023-04-13T16:16:03.913502  / # . /lava-9961774/environment/lava-996177=
4/bin/lava-test-runner /lava-9961774/1

    2023-04-13T16:16:03.913816  =


    2023-04-13T16:16:03.919132  / # /lava-9961774/bin/lava-test-runner /lav=
a-9961774/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382ac3812159a5562e85f0

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382ac3812159a5562e85f5
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:15:44.470887  + set<8>[   11.307023] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9961677_1.4.2.3.1>

    2023-04-13T16:15:44.470998   +x

    2023-04-13T16:15:44.575108  / # #

    2023-04-13T16:15:44.676091  export SHELL=3D/bin/sh

    2023-04-13T16:15:44.676367  #

    2023-04-13T16:15:44.777398  / # export SHELL=3D/bin/sh. /lava-9961677/e=
nvironment

    2023-04-13T16:15:44.777604  =


    2023-04-13T16:15:44.878551  / # . /lava-9961677/environment/lava-996167=
7/bin/lava-test-runner /lava-9961677/1

    2023-04-13T16:15:44.878843  =


    2023-04-13T16:15:44.883969  / # /lava-9961677/bin/lava-test-runner /lav=
a-9961677/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64382adb7f71b79ac22e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382adb7f71b79ac22e860d
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:16:16.346556  + <8>[   12.048987] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9961777_1.4.2.3.1>

    2023-04-13T16:16:16.347032  set +x

    2023-04-13T16:16:16.455258  / # #

    2023-04-13T16:16:16.558266  export SHELL=3D/bin/sh

    2023-04-13T16:16:16.559117  #

    2023-04-13T16:16:16.661092  / # export SHELL=3D/bin/sh. /lava-9961777/e=
nvironment

    2023-04-13T16:16:16.661907  =


    2023-04-13T16:16:16.763786  / # . /lava-9961777/environment/lava-996177=
7/bin/lava-test-runner /lava-9961777/1

    2023-04-13T16:16:16.765070  =


    2023-04-13T16:16:16.770052  / # /lava-9961777/bin/lava-test-runner /lav=
a-9961777/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx8mn-ddr4-evk              | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64382f2c6a784b622c2e8616

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64382f2c6a784b622c2e8=
617
        new failure (last pass: v5.15.104) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64382aa8eff17497ac2e8603

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382aa8eff17497ac2e8608
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:15:22.275285  + set +x<8>[   11.841411] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9961667_1.4.2.3.1>

    2023-04-13T16:15:22.275374  =


    2023-04-13T16:15:22.379719  / # #

    2023-04-13T16:15:22.480972  export SHELL=3D/bin/sh

    2023-04-13T16:15:22.481226  #

    2023-04-13T16:15:22.582135  / # export SHELL=3D/bin/sh. /lava-9961667/e=
nvironment

    2023-04-13T16:15:22.582345  =


    2023-04-13T16:15:22.683278  / # . /lava-9961667/environment/lava-996166=
7/bin/lava-test-runner /lava-9961667/1

    2023-04-13T16:15:22.683710  =


    2023-04-13T16:15:22.687854  / # /lava-9961667/bin/lava-test-runner /lav=
a-9961667/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64382aeeb981f936fe2e8618

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64382aeeb981f936fe2e861d
        failing since 14 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-13T16:16:19.395802  + <8>[   12.518842] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9961722_1.4.2.3.1>

    2023-04-13T16:16:19.396316  set +x

    2023-04-13T16:16:19.504760  / # #

    2023-04-13T16:16:19.606048  export SHELL=3D/bin/sh

    2023-04-13T16:16:19.606810  #

    2023-04-13T16:16:19.708892  / # export SHELL=3D/bin/sh. /lava-9961722/e=
nvironment

    2023-04-13T16:16:19.709681  =


    2023-04-13T16:16:19.811490  / # . /lava-9961722/environment/lava-996172=
2/bin/lava-test-runner /lava-9961722/1

    2023-04-13T16:16:19.812752  =


    2023-04-13T16:16:19.817035  / # /lava-9961722/bin/lava-test-runner /lav=
a-9961722/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
mt8173-elm-hana              | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/64382f4c8f570e586a2e8683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64382f4c8f570e586a2e8=
684
        failing since 79 days (last pass: v5.15.89, first fail: v5.15.90) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre  | gcc-10   | sunxi_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/6438293b0d5bf3dac62e85f8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-orangepi-r1.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.107/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-orangepi-r1.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438293b0d5bf3dac62e85fd
        failing since 70 days (last pass: v5.15.82, first fail: v5.15.91)

    2023-04-13T16:09:09.309387  / # #
    2023-04-13T16:09:09.415011  export SHELL=3D/bin/sh
    2023-04-13T16:09:09.416709  #
    2023-04-13T16:09:09.520338  / # export SHELL=3D/bin/sh. /lava-3491760/e=
nvironment
    2023-04-13T16:09:09.521970  =

    2023-04-13T16:09:09.625322  / # . /lava-3491760/environment/lava-349176=
0/bin/lava-test-runner /lava-3491760/1
    2023-04-13T16:09:09.628028  =

    2023-04-13T16:09:09.634591  / # /lava-3491760/bin/lava-test-runner /lav=
a-3491760/1
    2023-04-13T16:09:09.775412  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-13T16:09:09.776524  + cd /lava-3491760/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
