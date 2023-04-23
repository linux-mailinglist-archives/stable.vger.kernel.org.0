Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2248D6EC121
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 18:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjDWQhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 12:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDWQhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 12:37:17 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A587135
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 09:37:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b5465fc13so3019953b3a.3
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 09:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682267834; x=1684859834;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YAvVWGY80KIQqY3b7RHG3g5+aJ4qrZ6Ygqkd4IYMeVo=;
        b=ymzQzm+lRItmfuoFj/r3PM4OE2VYrBCMHuASL75Phxn72EPDQ35S/G/onvOM4rXmT0
         DMGecRgspnG/sOuzwXAY3bypujlhc17q3QkDR0SWqnLkj1L96Twy3be/i2VaI4oMBWSW
         K8E5jT5iX6zfRUGo98j4jCUmVJEAAq2N4SzyXS0qVziXt70uDHJcLQvzJEMyRE/8NFRM
         4fFkBV10bjthJ0Tt/Hqa/vMD9jQG8fuT+5Bu3ErhmpNYQ8QI3ziSzfPd4JN8BMzUWThB
         macu8KwHvHbbQKFf1AVATs3o++HaLSMho6H1exnRmtqdyLgBjDClhIQtYihfY8U/43FA
         UZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682267834; x=1684859834;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YAvVWGY80KIQqY3b7RHG3g5+aJ4qrZ6Ygqkd4IYMeVo=;
        b=kDC6LqccfKKztrrQGemCcn4MqaqKLMfFpcIUtYdKAa7dLVDAQeYw9AEuxhq0cqmgy1
         OWl2W+KhE1d0hm+08ReqKWazKlfL4B6z3EZI+5YFwPWR3+d64YR+mpdFGSyZ/WZgbiM5
         GYxQTc2hgRgbdGhdOGnZBoEGttDZahAbyuusBsMGxHZ55mRwoHQsPpcEULpGpRNXURJk
         9YgqtyIsEOkyMEWlz2N34D6+eGWrPIJMIDmZNuZ2DBlxHflz1bKEjjOBfhaDIZgQG5ZB
         rOSaWrnJvTsAfJADACCLP/T2wKqSYvNMVcBveJpbv5ZwJF85BlCJqs5AO27NbjmYb9bo
         S1Bg==
X-Gm-Message-State: AAQBX9fWhg22RR23hR5MY9T/9hh7GtJLbJmUYqeYtSGbcF4Yo5uPrzEj
        jIgf8AsNyQHFlh3rIYb8p+uQKDzT+f1WLCuKt9KNTg==
X-Google-Smtp-Source: AKy350YbaeiA1wI1enR7SLeb6vQm8tbyr9Q8M8lZGn9zDk1GM2fEoOn6yr13PbX8OhTAzCYLXpx1Ig==
X-Received: by 2002:a05:6a00:2448:b0:63b:7a55:ae89 with SMTP id d8-20020a056a00244800b0063b7a55ae89mr14610357pfj.27.1682267834172;
        Sun, 23 Apr 2023 09:37:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t1-20020a62d141000000b0063b8ce0e860sm5900476pfl.21.2023.04.23.09.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 09:37:13 -0700 (PDT)
Message-ID: <64455eb9.620a0220.5a19b.bb97@mx.google.com>
Date:   Sun, 23 Apr 2023 09:37:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-560-gc4a6f990f6a64
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 139 runs,
 9 regressions (v6.1.22-560-gc4a6f990f6a64)
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

stable-rc/queue/6.1 baseline: 139 runs, 9 regressions (v6.1.22-560-gc4a6f99=
0f6a64)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-560-gc4a6f990f6a64/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-560-gc4a6f990f6a64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4a6f990f6a64c4e9dd624d5d128764d0cc85b6f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64452640a960a3a0802e8636

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64452640a960a3a0802e863b
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T12:36:06.783829  + set +x

    2023-04-23T12:36:06.790542  <8>[    9.822679] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092043_1.4.2.3.1>

    2023-04-23T12:36:06.899097  / # #

    2023-04-23T12:36:07.001872  export SHELL=3D/bin/sh

    2023-04-23T12:36:07.002651  #

    2023-04-23T12:36:07.104641  / # export SHELL=3D/bin/sh. /lava-10092043/=
environment

    2023-04-23T12:36:07.105419  =


    2023-04-23T12:36:07.207612  / # . /lava-10092043/environment/lava-10092=
043/bin/lava-test-runner /lava-10092043/1

    2023-04-23T12:36:07.208839  =


    2023-04-23T12:36:07.216065  / # /lava-10092043/bin/lava-test-runner /la=
va-10092043/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445263cb15402c6b02e8652

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445263cb15402c6b02e8657
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T12:35:52.260040  + set<8>[   11.771282] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10092024_1.4.2.3.1>

    2023-04-23T12:35:52.260126   +x

    2023-04-23T12:35:52.365057  / # #

    2023-04-23T12:35:52.465855  export SHELL=3D/bin/sh

    2023-04-23T12:35:52.466018  #

    2023-04-23T12:35:52.566903  / # export SHELL=3D/bin/sh. /lava-10092024/=
environment

    2023-04-23T12:35:52.567088  =


    2023-04-23T12:35:52.667893  / # . /lava-10092024/environment/lava-10092=
024/bin/lava-test-runner /lava-10092024/1

    2023-04-23T12:35:52.668133  =


    2023-04-23T12:35:52.673045  / # /lava-10092024/bin/lava-test-runner /la=
va-10092024/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64452646578a5d4b122e85f3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64452646578a5d4b122e85f8
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T12:35:58.003192  <8>[   10.364051] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092004_1.4.2.3.1>

    2023-04-23T12:35:58.006741  + set +x

    2023-04-23T12:35:58.108617  =


    2023-04-23T12:35:58.209555  / # #export SHELL=3D/bin/sh

    2023-04-23T12:35:58.209758  =


    2023-04-23T12:35:58.310675  / # export SHELL=3D/bin/sh. /lava-10092004/=
environment

    2023-04-23T12:35:58.310874  =


    2023-04-23T12:35:58.411771  / # . /lava-10092004/environment/lava-10092=
004/bin/lava-test-runner /lava-10092004/1

    2023-04-23T12:35:58.412050  =


    2023-04-23T12:35:58.416416  / # /lava-10092004/bin/lava-test-runner /la=
va-10092004/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/6445256413e9ee0a0e2e860f

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445256413e9ee0a0e2e8642
        failing since 0 day (last pass: v6.1.22-556-g2944ac9cf90bf, first f=
ail: v6.1.22-556-g51522a0e29940)

    2023-04-23T12:32:10.277378  + set +x
    2023-04-23T12:32:10.279749  <8>[   16.624603] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 373637_1.5.2.4.1>
    2023-04-23T12:32:10.398286  / # #
    2023-04-23T12:32:10.500043  export SHELL=3D/bin/sh
    2023-04-23T12:32:10.501035  #
    2023-04-23T12:32:10.603193  / # export SHELL=3D/bin/sh. /lava-373637/en=
vironment
    2023-04-23T12:32:10.604141  =

    2023-04-23T12:32:10.706192  / # . /lava-373637/environment/lava-373637/=
bin/lava-test-runner /lava-373637/1
    2023-04-23T12:32:10.706812  =

    2023-04-23T12:32:10.712843  / # /lava-373637/bin/lava-test-runner /lava=
-373637/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/644529216896715a712e861a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644529216896715a712e8=
61b
        failing since 3 days (last pass: v6.1.22-477-g2128d4458cbc, first f=
ail: v6.1.22-474-gecc61872327e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445262db15402c6b02e8617

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445262db15402c6b02e861c
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T12:35:46.192904  + <8>[   10.254801] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10092012_1.4.2.3.1>

    2023-04-23T12:35:46.193012  set +x

    2023-04-23T12:35:46.294869  #

    2023-04-23T12:35:46.295191  =


    2023-04-23T12:35:46.396155  / # #export SHELL=3D/bin/sh

    2023-04-23T12:35:46.396382  =


    2023-04-23T12:35:46.497302  / # export SHELL=3D/bin/sh. /lava-10092012/=
environment

    2023-04-23T12:35:46.497506  =


    2023-04-23T12:35:46.598515  / # . /lava-10092012/environment/lava-10092=
012/bin/lava-test-runner /lava-10092012/1

    2023-04-23T12:35:46.598798  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445262bb15402c6b02e860c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445262bb15402c6b02e8611
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T12:35:39.499555  + set +x<8>[    7.890525] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10091983_1.4.2.3.1>

    2023-04-23T12:35:39.500154  =


    2023-04-23T12:35:39.609501  #

    2023-04-23T12:35:39.712371  / # #export SHELL=3D/bin/sh

    2023-04-23T12:35:39.713250  =


    2023-04-23T12:35:39.815159  / # export SHELL=3D/bin/sh. /lava-10091983/=
environment

    2023-04-23T12:35:39.815891  =


    2023-04-23T12:35:39.917512  / # . /lava-10091983/environment/lava-10091=
983/bin/lava-test-runner /lava-10091983/1

    2023-04-23T12:35:39.918704  =


    2023-04-23T12:35:39.923761  / # /lava-10091983/bin/lava-test-runner /la=
va-10091983/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64452647ae8add96132e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64452647ae8add96132e85f9
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T12:35:59.701579  + set<8>[   10.998459] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10092022_1.4.2.3.1>

    2023-04-23T12:35:59.702057   +x

    2023-04-23T12:35:59.811192  / # #

    2023-04-23T12:35:59.912183  export SHELL=3D/bin/sh

    2023-04-23T12:35:59.912379  #

    2023-04-23T12:36:00.013270  / # export SHELL=3D/bin/sh. /lava-10092022/=
environment

    2023-04-23T12:36:00.013491  =


    2023-04-23T12:36:00.114305  / # . /lava-10092022/environment/lava-10092=
022/bin/lava-test-runner /lava-10092022/1

    2023-04-23T12:36:00.114589  =


    2023-04-23T12:36:00.119080  / # /lava-10092022/bin/lava-test-runner /la=
va-10092022/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445262eb15402c6b02e8622

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-56=
0-gc4a6f990f6a64/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445262eb15402c6b02e8627
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-23T12:35:46.158974  <8>[   11.835843] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092009_1.4.2.3.1>

    2023-04-23T12:35:46.263481  / # #

    2023-04-23T12:35:46.364399  export SHELL=3D/bin/sh

    2023-04-23T12:35:46.364571  #

    2023-04-23T12:35:46.465469  / # export SHELL=3D/bin/sh. /lava-10092009/=
environment

    2023-04-23T12:35:46.465649  =


    2023-04-23T12:35:46.566686  / # . /lava-10092009/environment/lava-10092=
009/bin/lava-test-runner /lava-10092009/1

    2023-04-23T12:35:46.566961  =


    2023-04-23T12:35:46.571015  / # /lava-10092009/bin/lava-test-runner /la=
va-10092009/1

    2023-04-23T12:35:46.578297  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
