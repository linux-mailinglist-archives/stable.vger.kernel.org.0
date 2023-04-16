Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDE56E3A56
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 18:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjDPQwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 12:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDPQwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 12:52:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80122136
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 09:52:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id z11-20020a17090abd8b00b0024721c47ceaso9809631pjr.3
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 09:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681663923; x=1684255923;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPhJBGtam/X+po6/elvkrhBgUb8k8kV2F3pYyH2rpYE=;
        b=p59dFX6myXEcpZ5AOEos5zRu++rvm+NkBHfSigRA7yV/3bv8P8tzUOCSbvQk0d+Tmq
         bokxYOZq/ly3k3HA+ayRCTBvaMarTjiUlVyCivnC+2QHEvArlqeoKR6BHPRblMyA5vis
         TmkGEZqYNoYIx8bJtH+aytZjZDgy/m2w7DVTVLqwX/GemKcSLowgVJIYLkSu512WDK8X
         JfiuUUs+I/z+eMJZ3akfCen0oMd3ae5Vqw9lV9frLRcY4WYNIMPF+mddyYuzKznhlXsi
         B1Fz0E0UYIUmz8zxIeZhBslAkc/O7hCwESunGc5Xw4Zlf0Xfxz48ND1QOTeTDlBvy7Ma
         lYNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681663923; x=1684255923;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZPhJBGtam/X+po6/elvkrhBgUb8k8kV2F3pYyH2rpYE=;
        b=P5Z7GFa7yiTjRyWwIdfbCMVs1bpUNU48v4Bijtxuqn6iHg9SH2f4RUDBwvZkVS9yPX
         IxbJf7xIdNItwhcKFisnO2uFG7LtqYW18B76k4s4rnOGADjiibs2ipcjImPM8bFQynZg
         /k+f6v2hkwYoNPsNG7q6GTeX+BxEXF73a0OK9a+p77ANzUvUBWxZhOGjZSxz6glBKNmM
         ZaZaLkUovIOzMbyKHWIZ7/YvaWN4sjxAAivZRqa5Xc/le2x8YYNgJOg7+wFM0xGQYhwT
         oonq5ox5z4uVOa03tQeAtTeLiJRf+yV8ZyysbYzeCt3puw61J+YXWn2nuC2cTAVJyLBZ
         xu0w==
X-Gm-Message-State: AAQBX9f4d3gtzq/NSzjiVfCbIrHGnahMCT6+ecPiAgAwVJiepFpDhUY2
        XyzJu2Y4bde+0FdoA2t1uWzhpNkz+/jgCICSRAsC4eVG
X-Google-Smtp-Source: AKy350YC8EVX7twZIiPJVyRc1WGQCk86t6VHgtkbam2L+qe6vvoy9Ob3eKvR8fpoJwLhdGzrQpD3hg==
X-Received: by 2002:a17:903:2289:b0:19c:e842:a9e0 with SMTP id b9-20020a170903228900b0019ce842a9e0mr11357317plh.16.1681663922920;
        Sun, 16 Apr 2023 09:52:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b001a64011899asm6066801pla.25.2023.04.16.09.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 09:52:02 -0700 (PDT)
Message-ID: <643c27b2.170a0220.c2a51.d60b@mx.google.com>
Date:   Sun, 16 Apr 2023 09:52:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-236-g6722a1f40256
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 181 runs,
 11 regressions (v5.15.105-236-g6722a1f40256)
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

stable-rc/queue/5.15 baseline: 181 runs, 11 regressions (v5.15.105-236-g672=
2a1f40256)

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

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-236-g6722a1f40256/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-236-g6722a1f40256
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6722a1f402560cdb696d5428ee0678dddf3c704c =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf3db7dac84238e2e85fa

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf3db7dac84238e2e85ff
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-16T13:10:26.734835  <8>[   10.376739] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005249_1.4.2.3.1>

    2023-04-16T13:10:26.738327  + set +x

    2023-04-16T13:10:26.846276  / # #

    2023-04-16T13:10:26.949115  export SHELL=3D/bin/sh

    2023-04-16T13:10:26.950061  #

    2023-04-16T13:10:27.051996  / # export SHELL=3D/bin/sh. /lava-10005249/=
environment

    2023-04-16T13:10:27.052874  =


    2023-04-16T13:10:27.154949  / # . /lava-10005249/environment/lava-10005=
249/bin/lava-test-runner /lava-10005249/1

    2023-04-16T13:10:27.156195  =


    2023-04-16T13:10:27.162408  / # /lava-10005249/bin/lava-test-runner /la=
va-10005249/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf3c1cef35b13282e8668

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf3c1cef35b13282e866d
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-16T13:10:18.980930  + set<8>[   11.864792] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10005255_1.4.2.3.1>

    2023-04-16T13:10:18.981423   +x

    2023-04-16T13:10:19.090265  / # #

    2023-04-16T13:10:19.193456  export SHELL=3D/bin/sh

    2023-04-16T13:10:19.194337  #

    2023-04-16T13:10:19.296486  / # export SHELL=3D/bin/sh. /lava-10005255/=
environment

    2023-04-16T13:10:19.297366  =


    2023-04-16T13:10:19.399100  / # . /lava-10005255/environment/lava-10005=
255/bin/lava-test-runner /lava-10005255/1

    2023-04-16T13:10:19.399497  =


    2023-04-16T13:10:19.404111  / # /lava-10005255/bin/lava-test-runner /la=
va-10005255/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf3ca78aa3067112e860b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf3ca78aa3067112e8610
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-16T13:10:29.416068  <8>[   10.701615] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005251_1.4.2.3.1>

    2023-04-16T13:10:29.419502  + set +x

    2023-04-16T13:10:29.525124  =


    2023-04-16T13:10:29.627165  / # #export SHELL=3D/bin/sh

    2023-04-16T13:10:29.627917  =


    2023-04-16T13:10:29.729781  / # export SHELL=3D/bin/sh. /lava-10005251/=
environment

    2023-04-16T13:10:29.730522  =


    2023-04-16T13:10:29.832320  / # . /lava-10005251/environment/lava-10005=
251/bin/lava-test-runner /lava-10005251/1

    2023-04-16T13:10:29.833417  =


    2023-04-16T13:10:29.838937  / # /lava-10005251/bin/lava-test-runner /la=
va-10005251/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf5e9cbee9fd95c2e8600

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643bf5e9cbee9fd95c2e8=
601
        failing since 72 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf6041c9fe4f6b52e8604

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf6041c9fe4f6b52e8609
        failing since 89 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-16T13:19:43.774051  + set +x<8>[    9.876480] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3502394_1.5.2.4.1>
    2023-04-16T13:19:43.774637  =

    2023-04-16T13:19:43.884781  / # #
    2023-04-16T13:19:43.988310  export SHELL=3D/bin/sh
    2023-04-16T13:19:43.989349  #
    2023-04-16T13:19:44.091424  / # export SHELL=3D/bin/sh. /lava-3502394/e=
nvironment
    2023-04-16T13:19:44.091823  =

    2023-04-16T13:19:44.193063  / # . /lava-3502394/environment/lava-350239=
4/bin/lava-test-runner /lava-3502394/1
    2023-04-16T13:19:44.194794  =

    2023-04-16T13:19:44.195609  / # /lava-3502394/bin/lava-test-runner /lav=
a-3502394/1<3>[   10.272861] Bluetooth: hci0: command 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf3bcb9a6b297242e873d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf3bcb9a6b297242e8742
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-16T13:10:07.224732  + set +x

    2023-04-16T13:10:07.231469  <8>[   10.393103] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005222_1.4.2.3.1>

    2023-04-16T13:10:07.339647  / # #

    2023-04-16T13:10:07.440789  export SHELL=3D/bin/sh

    2023-04-16T13:10:07.441622  #

    2023-04-16T13:10:07.543305  / # export SHELL=3D/bin/sh. /lava-10005222/=
environment

    2023-04-16T13:10:07.544111  =


    2023-04-16T13:10:07.646052  / # . /lava-10005222/environment/lava-10005=
222/bin/lava-test-runner /lava-10005222/1

    2023-04-16T13:10:07.646443  =


    2023-04-16T13:10:07.650527  / # /lava-10005222/bin/lava-test-runner /la=
va-10005222/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf3b2b9a6b297242e86f1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf3b2b9a6b297242e86f6
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-16T13:09:53.557492  + set +x

    2023-04-16T13:09:53.564235  <8>[   10.619178] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005211_1.4.2.3.1>

    2023-04-16T13:09:53.666808  #

    2023-04-16T13:09:53.667066  =


    2023-04-16T13:09:53.768034  / # #export SHELL=3D/bin/sh

    2023-04-16T13:09:53.768216  =


    2023-04-16T13:09:53.869161  / # export SHELL=3D/bin/sh. /lava-10005211/=
environment

    2023-04-16T13:09:53.869349  =


    2023-04-16T13:09:53.970308  / # . /lava-10005211/environment/lava-10005=
211/bin/lava-test-runner /lava-10005211/1

    2023-04-16T13:09:53.970586  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf3c6164d155a552e8615

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf3c6164d155a552e861a
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-16T13:10:06.196236  + set<8>[   11.531960] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10005199_1.4.2.3.1>

    2023-04-16T13:10:06.196344   +x

    2023-04-16T13:10:06.300912  / # #

    2023-04-16T13:10:06.401907  export SHELL=3D/bin/sh

    2023-04-16T13:10:06.402110  #

    2023-04-16T13:10:06.502985  / # export SHELL=3D/bin/sh. /lava-10005199/=
environment

    2023-04-16T13:10:06.503180  =


    2023-04-16T13:10:06.604076  / # . /lava-10005199/environment/lava-10005=
199/bin/lava-test-runner /lava-10005199/1

    2023-04-16T13:10:06.604472  =


    2023-04-16T13:10:06.609071  / # /lava-10005199/bin/lava-test-runner /la=
va-10005199/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf5b27de9c6c2102e8607

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf5b27de9c6c2102e860c
        failing since 79 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-16T13:18:32.028237  + set +x
    2023-04-16T13:18:32.028410  [    9.350859] <LAVA_SIGNAL_ENDRUN 0_dmesg =
927677_1.5.2.3.1>
    2023-04-16T13:18:32.135902  / # #
    2023-04-16T13:18:32.237646  export SHELL=3D/bin/sh
    2023-04-16T13:18:32.238125  #
    2023-04-16T13:18:32.339321  / # export SHELL=3D/bin/sh. /lava-927677/en=
vironment
    2023-04-16T13:18:32.339767  =

    2023-04-16T13:18:32.440921  / # . /lava-927677/environment/lava-927677/=
bin/lava-test-runner /lava-927677/1
    2023-04-16T13:18:32.441360  =

    2023-04-16T13:18:32.444353  / # /lava-927677/bin/lava-test-runner /lava=
-927677/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf3b6b9a6b297242e86ff

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf3b6b9a6b297242e8704
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-16T13:09:59.430285  + set<8>[   11.921759] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10005190_1.4.2.3.1>

    2023-04-16T13:09:59.430823   +x

    2023-04-16T13:09:59.540426  / # #

    2023-04-16T13:09:59.641511  export SHELL=3D/bin/sh

    2023-04-16T13:09:59.641695  #

    2023-04-16T13:09:59.742552  / # export SHELL=3D/bin/sh. /lava-10005190/=
environment

    2023-04-16T13:09:59.742788  =


    2023-04-16T13:09:59.843756  / # . /lava-10005190/environment/lava-10005=
190/bin/lava-test-runner /lava-10005190/1

    2023-04-16T13:09:59.844189  =


    2023-04-16T13:09:59.848946  / # /lava-10005190/bin/lava-test-runner /la=
va-10005190/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf0b02667cd77212e8631

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-236-g6722a1f40256/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf0b02667cd77212e8636
        failing since 74 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-16T12:57:07.258801  / # #
    2023-04-16T12:57:07.365271  export SHELL=3D/bin/sh
    2023-04-16T12:57:07.366973  #
    2023-04-16T12:57:07.470716  / # export SHELL=3D/bin/sh. /lava-3502210/e=
nvironment
    2023-04-16T12:57:07.472359  =

    2023-04-16T12:57:07.576169  / # . /lava-3502210/environment/lava-350221=
0/bin/lava-test-runner /lava-3502210/1
    2023-04-16T12:57:07.578973  =

    2023-04-16T12:57:07.590474  / # /lava-3502210/bin/lava-test-runner /lav=
a-3502210/1
    2023-04-16T12:57:07.685638  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-16T12:57:07.733459  + cd /lava-3502210/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
