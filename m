Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FD66CCDEC
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 01:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjC1XQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 19:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjC1XQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 19:16:25 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2AE2D43
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 16:16:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso16803770pjb.0
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 16:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680045382;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Jym8PAyzdE8KUX/noNzanxCx1nNOy4aqOXuR87DgyrQ=;
        b=Wun8qZkZY8/eWU7+ctiLs1jceqvjXu4mdJiakscWIp3Kh3RqlQQgJMfEM1xqvKsWdY
         +KvK+QtglFjh8RttLB/jFJ7SMScfKHENwzaEJxRyGtBlbzvohcvQ/KD+Gpi+YQ8Lz7F5
         +JUoLzNo65dUSBxhPJL6DiR0Rf9wCSgLLbw5TmnqHts/CmDZrYbbkG7vtR8ODiHEVPqg
         JNvHJWDNRLUAHVMe8GgDD6SBsDaZYomOT724R+ddWbDLXFhzWEp2ABVZnRJQsoLHohfU
         z/Do1+OaOKSO2xRBkh/AGMlRxi9BcYVlR9Og1IdBzAGUZHVJAiCB7DF42ywMB6vnbOt3
         lqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680045382;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jym8PAyzdE8KUX/noNzanxCx1nNOy4aqOXuR87DgyrQ=;
        b=Wa2lOBWMZiZrEfHlGhluEn2LB4p51itccoDIMIq+RSAyChYN0EKRFEHITgqTd8fBFX
         pmwse86rEWSU5a8AlPEjUVy5dYJ/bkcEGrmeXW4PemZIxDdRx1FaTzFiqEOdounzRY+P
         8r/cHmh9plLIlknhkJS5zUqvGX9qnbYuXPmrqk63jZj8pufMXWd+9/osQziNzPm42lCQ
         5JCUazu9LP3fMLXj8Vrau9rUpbdUr54Hk9EPcG2o1NyBp+bV/2zfQ6G3ZbR+wHxF9NZl
         Yu4FoWvVYZW4+JVZ2TiwbE+pfqxu6PY7GDJJC9srXjsWP1jdH+uyQceVGKtCs3NlV3Fr
         g28A==
X-Gm-Message-State: AAQBX9cgac/8u7aOYhov9EGEfwApLYQJtORffFD9pk4TTAAJ82DA0oLR
        B0bTKNB+IdGqw+dl54FwQBUiYsmsUFbwbbx43keKCg==
X-Google-Smtp-Source: AKy350anACt0HtJv0LanmK4dKJU0/ur+DCeWpOCW417aeamlAwZMCbG0Bzdp9N6x3838erg+wuVDtQ==
X-Received: by 2002:a17:902:e1cc:b0:1a0:45f6:d7ce with SMTP id t12-20020a170902e1cc00b001a045f6d7cemr12987490pla.32.1680045382531;
        Tue, 28 Mar 2023 16:16:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902a40b00b001a042f532cfsm21565356plq.27.2023.03.28.16.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 16:16:22 -0700 (PDT)
Message-ID: <64237546.170a0220.6d3cf.7aaa@mx.google.com>
Date:   Tue, 28 Mar 2023 16:16:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.238-60-gcf51829325af
Subject: stable-rc/queue/5.4 baseline: 118 runs,
 5 regressions (v5.4.238-60-gcf51829325af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 118 runs, 5 regressions (v5.4.238-60-gcf51829=
325af)

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

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.238-60-gcf51829325af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-60-gcf51829325af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf51829325aff299227854956faa0df31099d340 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64233c40d1bae19b5b62f78f

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/64233c40d1bae19b=
5b62f796
        failing since 160 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-03-28T19:12:43.748071  / # =

    2023-03-28T19:12:43.748902  =

    2023-03-28T19:12:45.813366  / # #
    2023-03-28T19:12:45.814481  #
    2023-03-28T19:12:47.825874  / # export SHELL=3D/bin/sh
    2023-03-28T19:12:47.826587  export SHELL=3D/bin/sh
    2023-03-28T19:12:49.841557  / # . /lava-3451093/environment
    2023-03-28T19:12:49.841975  . /lava-3451093/environment
    2023-03-28T19:12:51.857655  / # /lava-3451093/bin/lava-test-runner /lav=
a-3451093/0
    2023-03-28T19:12:51.858800  /lava-3451093/bin/lava-test-runner /lava-34=
51093/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64233b81f5f45ac12162f79f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64233b81f5f45ac12162f7a4
        new failure (last pass: v5.4.238-29-g39c31e43e3b2b)

    2023-03-28T19:09:34.847600  + set<8>[   10.352499] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9798437_1.4.2.3.1>

    2023-03-28T19:09:34.847694   +x

    2023-03-28T19:09:34.949725  #

    2023-03-28T19:09:35.050926  / # #export SHELL=3D/bin/sh

    2023-03-28T19:09:35.051135  =


    2023-03-28T19:09:35.152033  / # export SHELL=3D/bin/sh. /lava-9798437/e=
nvironment

    2023-03-28T19:09:35.152242  =


    2023-03-28T19:09:35.253123  / # . /lava-9798437/environment/lava-979843=
7/bin/lava-test-runner /lava-9798437/1

    2023-03-28T19:09:35.253420  =


    2023-03-28T19:09:35.257931  / # /lava-9798437/bin/lava-test-runner /lav=
a-9798437/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64233b87f5f45ac12162f7b6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64233b87f5f45ac12162f7bb
        new failure (last pass: v5.4.238-29-g39c31e43e3b2b)

    2023-03-28T19:09:38.798149  <8>[   12.628561] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798387_1.4.2.3.1>

    2023-03-28T19:09:38.801127  + set +x

    2023-03-28T19:09:38.902791  #

    2023-03-28T19:09:38.903015  =


    2023-03-28T19:09:39.003916  / # #export SHELL=3D/bin/sh

    2023-03-28T19:09:39.004152  =


    2023-03-28T19:09:39.105180  / # export SHELL=3D/bin/sh. /lava-9798387/e=
nvironment

    2023-03-28T19:09:39.105371  =


    2023-03-28T19:09:39.206317  / # . /lava-9798387/environment/lava-979838=
7/bin/lava-test-runner /lava-9798387/1

    2023-03-28T19:09:39.206589  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx6dl-udoo                  | arm    | lab-broonie   | gcc-10   | imx_v6_v=
7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64233dfc4c62ccdd9c62f793

  Results:     29 PASS, 4 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/arm/imx_v6_v7_defconfig/gcc-10/lab-broonie/baseline-imx6dl-=
udoo.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/arm/imx_v6_v7_defconfig/gcc-10/lab-broonie/baseline-imx6dl-=
udoo.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.sound-card-probed: https://kernelci.org/test/case/id/64=
233dfc4c62ccdd9c62f79d
        new failure (last pass: v5.4.238-29-g39c31e43e3b2b)

    2023-03-28T19:20:15.002581  /lava-241219/1/../bin/lava-test-case
    2023-03-28T19:20:15.037670  <8>[   19.883513] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dsound-card-probed RESULT=3Dfail>   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64233d7d8c966fd0a562f7c6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-6=
0-gcf51829325af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64233d7d8c966fd0a562f7cb
        failing since 55 days (last pass: v5.4.230-108-g761a8268d868, first=
 fail: v5.4.230-109-g0a6085bff265)

    2023-03-28T19:17:57.151242  / # #
    2023-03-28T19:17:57.253316  export SHELL=3D/bin/sh
    2023-03-28T19:17:57.253809  #
    2023-03-28T19:17:57.355271  / # export SHELL=3D/bin/sh. /lava-3451120/e=
nvironment
    2023-03-28T19:17:57.355748  =

    2023-03-28T19:17:57.457297  / # . /lava-3451120/environment/lava-345112=
0/bin/lava-test-runner /lava-3451120/1
    2023-03-28T19:17:57.458274  =

    2023-03-28T19:17:57.475885  / # /lava-3451120/bin/lava-test-runner /lav=
a-3451120/1
    2023-03-28T19:17:57.549751  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-28T19:17:57.550345  + cd /lava-3451120/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
