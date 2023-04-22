Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065AD6EBC0C
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 01:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDVXBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 19:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDVXBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 19:01:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595C326B5
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:01:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a6817adde4so37088855ad.0
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682204510; x=1684796510;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mop0iQ1Inq3Rj7wrBnnRKIPwvTaGYM+2QRpeiBbS0lk=;
        b=cjqeUFVf2PxZOQsgz0zOIyS2ojfhI5b7K/SFAsLxQ70gQ13fwOpfjCXZoXOuSKnuge
         qIEVR1siwxoFvfGjgLsu/5D7nhu2aYqunA9SXB1yWwg3cE+muXKkS+07f/TZOU8FTuFo
         zLtGY3t3Akt1w1xpORtESDVf9r7rMGToNUFjIn6rYTHbYctAc9WeiRdL6HV6kHnaJlBT
         JqXR/57IgGweO1amHZKbEtE5wU1eIHnZ95ylK/AGXnFErEeXC8HATd401Iq2aaWuNhf1
         PMKCqORwKVz3paCOAte7LFMG6BU055/bKAPsLwqHsHWOf0RK8zCaAz/9y0b/g6Mxl9Kz
         tDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682204510; x=1684796510;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mop0iQ1Inq3Rj7wrBnnRKIPwvTaGYM+2QRpeiBbS0lk=;
        b=Gjuw8+NCSfeOK1wQJaZKY8iRN9wcEyTObAvvUkeJsm0W8egwY04ZBqghQYdq87ZHEy
         esCw2XwluCkFjHtgPv7ar7QYA7KdXfxHxyHdG3RRaXM6VThSKYkEGkQW7ccWlPLcvFEy
         wza9ij48MMY8aEmYxOCGolCNcALfvpkDih9pfp+f89xkZiurPrwV55KDotl3Wb8HY0yQ
         S2lHSVfwwgtJbsxWChrVC5KPhEcp4I2NCcAhMCM3tNTFMsrm3MDWdRG2/jCORvKUmOgt
         k0GCVfHIUOjgy327gQvC7rl0dzjYWKKCgzaE0CaELtC4mLDUmGhPO4UQPh+ZbLpESLm+
         jWGg==
X-Gm-Message-State: AAQBX9c6Jw244g41RPdSZ0GWd8jFeVXmxdOZfkpXJDrnxvqhUXLeJ7Y4
        JTAq+qRTLZEA6VVQQ0qfmj0ZlrKQFc+IidOwgoW4Nb/J
X-Google-Smtp-Source: AKy350bxid9HUuxk/zd3QfR6X6HTBB3fK1Fh+IvZA65FMw+8rA80QsLe0UAb4HMHoYHxfe/q0O/2qg==
X-Received: by 2002:a17:903:410a:b0:1a6:7570:5370 with SMTP id r10-20020a170903410a00b001a675705370mr7987055pld.10.1682204510408;
        Sat, 22 Apr 2023 16:01:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w15-20020a170902d70f00b001a6c58e95d7sm4421395ply.269.2023.04.22.16.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 16:01:49 -0700 (PDT)
Message-ID: <6444675d.170a0220.94485.8fda@mx.google.com>
Date:   Sat, 22 Apr 2023 16:01:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-556-g51522a0e29940
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 139 runs,
 11 regressions (v6.1.22-556-g51522a0e29940)
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

stable-rc/queue/6.1 baseline: 139 runs, 11 regressions (v6.1.22-556-g51522a=
0e29940)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

bcm2835-rpi-b-rev2           | arm    | lab-broonie     | gcc-10   | bcm283=
5_defconfig            | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx6dl-riotboard             | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-556-g51522a0e29940/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-556-g51522a0e29940
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      51522a0e29940e8cef223e952d9b12c503cc2bb6 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644430bc3b467501cc2e8877

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644430bc3b467501cc2e8=
878
        new failure (last pass: v6.1.22-556-g2944ac9cf90bf) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442fd3844614a58c2e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442fd3844614a58c2e85fc
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T19:04:29.035255  <8>[    9.913633] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10086201_1.4.2.3.1>

    2023-04-22T19:04:29.038380  + set +x

    2023-04-22T19:04:29.140016  #

    2023-04-22T19:04:29.140293  =


    2023-04-22T19:04:29.241250  / # #export SHELL=3D/bin/sh

    2023-04-22T19:04:29.241444  =


    2023-04-22T19:04:29.342337  / # export SHELL=3D/bin/sh. /lava-10086201/=
environment

    2023-04-22T19:04:29.342536  =


    2023-04-22T19:04:29.443432  / # . /lava-10086201/environment/lava-10086=
201/bin/lava-test-runner /lava-10086201/1

    2023-04-22T19:04:29.443728  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442fd55e882360742e85ed

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442fd55e882360742e85f2
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T19:04:32.597998  + set<8>[   11.260586] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10086231_1.4.2.3.1>

    2023-04-22T19:04:32.598437   +x

    2023-04-22T19:04:32.707407  / # #

    2023-04-22T19:04:32.810713  export SHELL=3D/bin/sh

    2023-04-22T19:04:32.811507  #

    2023-04-22T19:04:32.913526  / # export SHELL=3D/bin/sh. /lava-10086231/=
environment

    2023-04-22T19:04:32.914545  =


    2023-04-22T19:04:33.016574  / # . /lava-10086231/environment/lava-10086=
231/bin/lava-test-runner /lava-10086231/1

    2023-04-22T19:04:33.018046  =


    2023-04-22T19:04:33.022714  / # /lava-10086231/bin/lava-test-runner /la=
va-10086231/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442fd96920f061882e862d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442fd96920f061882e8632
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T19:04:39.702817  <8>[   10.012405] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10086198_1.4.2.3.1>

    2023-04-22T19:04:39.706518  + set +x

    2023-04-22T19:04:39.812313  #

    2023-04-22T19:04:39.813722  =


    2023-04-22T19:04:39.916240  / # #export SHELL=3D/bin/sh

    2023-04-22T19:04:39.917146  =


    2023-04-22T19:04:40.019245  / # export SHELL=3D/bin/sh. /lava-10086198/=
environment

    2023-04-22T19:04:40.020156  =


    2023-04-22T19:04:40.122367  / # . /lava-10086198/environment/lava-10086=
198/bin/lava-test-runner /lava-10086198/1

    2023-04-22T19:04:40.123832  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie     | gcc-10   | bcm283=
5_defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/64442fbdb435a633f72e861d

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442fbeb435a633f72e8650
        new failure (last pass: v6.1.22-556-g2944ac9cf90bf)

    2023-04-22T19:04:04.043880  + set +x
    2023-04-22T19:04:04.047723  <8>[   16.549116] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 371567_1.5.2.4.1>
    2023-04-22T19:04:04.163041  / # #
    2023-04-22T19:04:04.264945  export SHELL=3D/bin/sh
    2023-04-22T19:04:04.265533  #
    2023-04-22T19:04:04.366829  / # export SHELL=3D/bin/sh. /lava-371567/en=
vironment
    2023-04-22T19:04:04.367434  =

    2023-04-22T19:04:04.468961  / # . /lava-371567/environment/lava-371567/=
bin/lava-test-runner /lava-371567/1
    2023-04-22T19:04:04.469407  =

    2023-04-22T19:04:04.476754  / # /lava-371567/bin/lava-test-runner /lava=
-371567/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6444314a829f3fc45f2e8612

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6444314a829f3fc45f2e8=
613
        failing since 2 days (last pass: v6.1.22-477-g2128d4458cbc, first f=
ail: v6.1.22-474-gecc61872327e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442fb4b435a633f72e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442fb4b435a633f72e85eb
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T19:04:03.268525  + set +x

    2023-04-22T19:04:03.274645  <8>[   10.550708] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10086171_1.4.2.3.1>

    2023-04-22T19:04:03.380115  / # #

    2023-04-22T19:04:03.481140  export SHELL=3D/bin/sh

    2023-04-22T19:04:03.481337  #

    2023-04-22T19:04:03.582264  / # export SHELL=3D/bin/sh. /lava-10086171/=
environment

    2023-04-22T19:04:03.582484  =


    2023-04-22T19:04:03.683446  / # . /lava-10086171/environment/lava-10086=
171/bin/lava-test-runner /lava-10086171/1

    2023-04-22T19:04:03.683761  =


    2023-04-22T19:04:03.688251  / # /lava-10086171/bin/lava-test-runner /la=
va-10086171/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442fc342bbac60342e85fa

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442fc342bbac60342e85ff
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T19:04:14.941764  + set<8>[   10.876153] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10086220_1.4.2.3.1>

    2023-04-22T19:04:14.941851   +x

    2023-04-22T19:04:15.043838  #

    2023-04-22T19:04:15.144844  / # #export SHELL=3D/bin/sh

    2023-04-22T19:04:15.145002  =


    2023-04-22T19:04:15.245919  / # export SHELL=3D/bin/sh. /lava-10086220/=
environment

    2023-04-22T19:04:15.246095  =


    2023-04-22T19:04:15.346968  / # . /lava-10086220/environment/lava-10086=
220/bin/lava-test-runner /lava-10086220/1

    2023-04-22T19:04:15.347260  =


    2023-04-22T19:04:15.352381  / # /lava-10086220/bin/lava-test-runner /la=
va-10086220/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442fc8b435a633f72e8680

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442fc8b435a633f72e8685
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T19:04:23.506642  + <8>[   11.471478] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10086176_1.4.2.3.1>

    2023-04-22T19:04:23.507074  set +x

    2023-04-22T19:04:23.614573  / # #

    2023-04-22T19:04:23.717348  export SHELL=3D/bin/sh

    2023-04-22T19:04:23.718083  #

    2023-04-22T19:04:23.820027  / # export SHELL=3D/bin/sh. /lava-10086176/=
environment

    2023-04-22T19:04:23.820754  =


    2023-04-22T19:04:23.922550  / # . /lava-10086176/environment/lava-10086=
176/bin/lava-test-runner /lava-10086176/1

    2023-04-22T19:04:23.923682  =


    2023-04-22T19:04:23.928237  / # /lava-10086176/bin/lava-test-runner /la=
va-10086176/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6dl-riotboard             | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644432aa5b061e7c122e8633

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644432aa5b061e7c122e8638
        new failure (last pass: v6.1.22-556-g2944ac9cf90bf)

    2023-04-22T19:16:34.597339  + set[   14.932839] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 934477_1.5.2.3.1>
    2023-04-22T19:16:34.597536   +x
    2023-04-22T19:16:34.703411  / # #
    2023-04-22T19:16:34.804967  export SHELL=3D/bin/sh
    2023-04-22T19:16:34.805507  #
    2023-04-22T19:16:34.906765  / # export SHELL=3D/bin/sh. /lava-934477/en=
vironment
    2023-04-22T19:16:34.907262  =

    2023-04-22T19:16:35.008503  / # . /lava-934477/environment/lava-934477/=
bin/lava-test-runner /lava-934477/1
    2023-04-22T19:16:35.009145  =

    2023-04-22T19:16:35.012126  / # /lava-934477/bin/lava-test-runner /lava=
-934477/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64442fb22aed1fb6d12e861a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-55=
6-g51522a0e29940/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442fb22aed1fb6d12e861f
        failing since 25 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-22T19:04:06.297117  <8>[   11.993649] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10086178_1.4.2.3.1>

    2023-04-22T19:04:06.405518  / # #

    2023-04-22T19:04:06.508530  export SHELL=3D/bin/sh

    2023-04-22T19:04:06.509516  #

    2023-04-22T19:04:06.611566  / # export SHELL=3D/bin/sh. /lava-10086178/=
environment

    2023-04-22T19:04:06.612471  =


    2023-04-22T19:04:06.714569  / # . /lava-10086178/environment/lava-10086=
178/bin/lava-test-runner /lava-10086178/1

    2023-04-22T19:04:06.715919  =


    2023-04-22T19:04:06.720986  / # /lava-10086178/bin/lava-test-runner /la=
va-10086178/1

    2023-04-22T19:04:06.728161  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
