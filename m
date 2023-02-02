Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAF56877A8
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 09:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjBBIiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 03:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjBBIiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 03:38:02 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4777A96
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 00:37:59 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id h9so1122315plf.9
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 00:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=06SYJtzR2F6vINMoqmiRk0ouCLL24GndBkNRQbmryiY=;
        b=NIvNVm6Sf/5zJgppticGAGJigTRw2kHIUybtnwludNXBig1ZKa6W1xZ6FOLcIbMVZZ
         VJuYPfkIiwUTQ6ceUqqHZHRjHU1h2s8tu78omTBRuJY9jAxONPWaCi3qS7roqPBA3S1u
         0MoFeT78UsIFRdG1ZwGqiK6OTATozJG3N/zS9+g4RfBZKkjud4qSpGyKsZ/XL6pD8knB
         tHBSCVrIDl2mbBGi4b53EMudeE//9Uz7rCl4uVb7CQ+g4OkJIwd6zakc/t+5cnoscoGa
         8tVBZZ4zK4wHqAiWhfmzY2zYKcJQAvPzF7OPomDlXhFY9qyeraZ6Xnx8mFcXAx2Sy4WZ
         qV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=06SYJtzR2F6vINMoqmiRk0ouCLL24GndBkNRQbmryiY=;
        b=NAAu0i6cozK+VujSgpBho4hqS7EPgMi7kOv5a4QTwXsmsKpgE4UfVZ2Fmt7xCw0AHY
         xll53feE7its2e3/5wxshEq9uPo4uO+c/28t9X1qM4vpy7fypen70EkSOU99CYHJ3FCe
         GQ8QU1DxuwXh8zDBLfE8TTue7o0sQORxMLzo3kcJTkK83GgvxdwPmIqA6AM6VJ2lBPoo
         6gAoeydm/DN8Zdyor7uzUbUw99OI6ZT1i3nlhBGg12VsXdefHVINNlp/r8sMP2xD6jZt
         JirmkPMEvm4d7SpqXGZ5XKWONMlRCj0oDFMfJP9MssRnkolOTORPgjwA0v+zANjNLpXB
         U2tg==
X-Gm-Message-State: AO0yUKXgFKM1I7ekLi+podf9DQGuEMMUTMyBbLlsdy3425IXIbwEKOJf
        hqqOnGTAlEGi1u5I9amxuMZ6roUZdyAoGU2xkQ0Psw==
X-Google-Smtp-Source: AK7set98PPa12g3nfQG9UV0M7Sk61lvr72WF0VGsL4tMtFJbdWxyVsSU3/zfj0yg++XNS5vSJpk3Ig==
X-Received: by 2002:a17:90a:1a11:b0:22b:b76b:5043 with SMTP id 17-20020a17090a1a1100b0022bb76b5043mr5818211pjk.9.1675327078888;
        Thu, 02 Feb 2023 00:37:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ft8-20020a17090b0f8800b0022908f1398dsm2659987pjb.32.2023.02.02.00.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 00:37:58 -0800 (PST)
Message-ID: <63db7666.170a0220.c67c9.4b31@mx.google.com>
Date:   Thu, 02 Feb 2023 00:37:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-216-g9ba6045971e4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 173 runs,
 5 regressions (v5.15.90-216-g9ba6045971e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 173 runs, 5 regressions (v5.15.90-216-g9ba60=
45971e4)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-216-g9ba6045971e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-216-g9ba6045971e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ba6045971e4839faba9a48c03016210c06a4306 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63db462a9009bd5bea915ebb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db462a9009bd5bea915ec0
        failing since 15 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-02T05:11:20.384130  <8>[    9.877767] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-02-02T05:11:20.390590  + set +x<8>[    9.888951] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3270423_1.5.2.4.1>
    2023-02-02T05:11:20.390913  =

    2023-02-02T05:11:20.498399  / # #
    2023-02-02T05:11:20.600036  export SHELL=3D/bin/sh
    2023-02-02T05:11:20.600434  #
    2023-02-02T05:11:20.701624  / # export SHELL=3D/bin/sh. /lava-3270423/e=
nvironment
    2023-02-02T05:11:20.702054  =

    2023-02-02T05:11:20.803365  / # . /lava-3270423/environment/lava-327042=
3/bin/lava-test-runner /lava-3270423/1
    2023-02-02T05:11:20.804061   =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63db44c2eee6c92c11915eda

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db44c2eee6c92c11915edf
        failing since 5 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-02-02T05:05:50.642700  + set +x
    2023-02-02T05:05:50.642875  [    9.336328] <LAVA_SIGNAL_ENDRUN 0_dmesg =
895604_1.5.2.3.1>
    2023-02-02T05:05:50.750914  / # #
    2023-02-02T05:05:50.852225  export SHELL=3D/bin/sh
    2023-02-02T05:05:50.852797  #
    2023-02-02T05:05:50.956523  / # export SHELL=3D/bin/sh. /lava-895604/en=
vironment
    2023-02-02T05:05:50.957264  =

    2023-02-02T05:05:51.058810  / # . /lava-895604/environment/lava-895604/=
bin/lava-test-runner /lava-895604/1
    2023-02-02T05:05:51.059771  =

    2023-02-02T05:05:51.062093  / # /lava-895604/bin/lava-test-runner /lava=
-895604/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63db44c2f7588e5cc3915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32=
mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32=
mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db44c2f7588e5cc3915ebe
        failing since 0 day (last pass: v5.15.72-36-g3886958cda706, first f=
ail: v5.15.90-215-gdf99871482a0)

    2023-02-02T05:05:49.129596  <8>[   11.508314] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3270417_1.5.2.4.1>
    2023-02-02T05:05:49.236787  / # #
    2023-02-02T05:05:49.338791  export SHELL=3D/bin/sh
    2023-02-02T05:05:49.339319  #
    2023-02-02T05:05:49.441045  / # export SHELL=3D/bin/sh. /lava-3270417/e=
nvironment
    2023-02-02T05:05:49.441502  =

    2023-02-02T05:05:49.543523  / # . /lava-3270417/environment/lava-327041=
7/bin/lava-test-runner /lava-3270417/1
    2023-02-02T05:05:49.545021  =

    2023-02-02T05:05:49.548718  / # /lava-3270417/bin/lava-test-runner /lav=
a-3270417/1
    2023-02-02T05:05:49.615599  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63db44b31b64d33529915f0c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db44b31b64d33529915f11
        failing since 15 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-02T05:05:41.263541  <8>[   16.097679] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3270377_1.5.2.4.1>
    2023-02-02T05:05:41.385820  / # #
    2023-02-02T05:05:41.491938  export SHELL=3D/bin/sh
    2023-02-02T05:05:41.493559  #
    2023-02-02T05:05:41.597288  / # export SHELL=3D/bin/sh. /lava-3270377/e=
nvironment
    2023-02-02T05:05:41.599303  =

    2023-02-02T05:05:41.703026  / # . /lava-3270377/environment/lava-327037=
7/bin/lava-test-runner /lava-3270377/1
    2023-02-02T05:05:41.705878  =

    2023-02-02T05:05:41.708347  / # /lava-3270377/bin/lava-test-runner /lav=
a-3270377/1
    2023-02-02T05:05:41.755149  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63db451e6c10058ef0915ee6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
216-g9ba6045971e4/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db451e6c10058ef0915eeb
        failing since 15 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-02T05:07:34.236571  + set +x
    2023-02-02T05:07:34.240743  <8>[   16.134732] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 234672_1.5.2.4.1>
    2023-02-02T05:07:34.353528  / # #
    2023-02-02T05:07:34.455888  export SHELL=3D/bin/sh
    2023-02-02T05:07:34.456740  #
    2023-02-02T05:07:34.558865  / # export SHELL=3D/bin/sh. /lava-234672/en=
vironment
    2023-02-02T05:07:34.559321  =

    2023-02-02T05:07:34.660981  / # . /lava-234672/environment/lava-234672/=
bin/lava-test-runner /lava-234672/1
    2023-02-02T05:07:34.661930  =

    2023-02-02T05:07:34.666204  / # /lava-234672/bin/lava-test-runner /lava=
-234672/1 =

    ... (12 line(s) more)  =

 =20
