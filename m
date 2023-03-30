Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729A86D0856
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 16:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjC3O35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 10:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjC3O3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 10:29:50 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751B710DD
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 07:29:47 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u10so18226695plz.7
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 07:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680186586;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gN5XslU50OZogwECO9NxYzuVg4cwdPzAvLFMrmB5toY=;
        b=gIHL7iwBsyrvxbnNX6qCjpdvW3tmsNSXs8hJ1ACT2zrP91cAhbleovU6zW0+CYzpxR
         vuQfBItqv/PfdQczd5ae0INi03Pr1iGnIG75nvrsA7I4BuVOUsw8eMltHNYC7Id4DywM
         mbj1BojZWNXZbQp8L+bVsawq7LtVNuEr6V3imn8oMccBb4r0InzMIwgthRTuTaogtJyG
         ktMTmgu/v4bPhAzBvQato9Aq56FkUMzjwG39XxX62ju1C8QpV5c5TmZk4n3bYEzllfi0
         JBMSX85QD8+1dIVPLnrWeV5d8Sx2RelSBJ5GvY70p39lhMY515A/lQ7Cj8LD2HFE/G0D
         O1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680186587;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gN5XslU50OZogwECO9NxYzuVg4cwdPzAvLFMrmB5toY=;
        b=kHnVMP1GSUxvoo6a4Y8MxFD36HhqNGshkiwrv4iFJmYFmbxu+iz0bC39gqSTUc8i4o
         ObB+1j/WjTVZhCavhlvj1eToKaxcEBs6EFZ5PlLUKhVFl0i1o5UwqO2k1RTiJiFwBT0l
         DTXw20R11rJ3VRjf4X06oUir9Vte7CQi3csbMNYZYy2r7QLbPBYspc03nQk8H65zhFll
         f3HfT0cizbKR014z6NT/zB5rvVVlWd2yNvnG5QK0fVYi5amTm+rmacms8QxlGoaYQeE4
         1EyFZIKfqZx2+u0zsWlFYPB76LaXhBR/e8PMJj+btK688TcBv6AE2Bl4rpZ1GkZcitnY
         c1/A==
X-Gm-Message-State: AAQBX9cOOgSJSxAUf8v5MgGtuJum0xLSYBDRyJAMkP/1tdd2Guy1uuJg
        CXPWkYHofIPldS+DjvRWuqcR1sOb16utWXUWBgg6bA==
X-Google-Smtp-Source: AKy350Ysu9x4NMmEA2hs4EwK/Qe0zK4kmkAbFvAPRtOuYBbUX5rl3YIjTC9XR7DnRHdtKOvJXYGwLw==
X-Received: by 2002:a17:90b:164e:b0:233:f98a:8513 with SMTP id il14-20020a17090b164e00b00233f98a8513mr26372411pjb.8.1680186586474;
        Thu, 30 Mar 2023 07:29:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4-20020a17090a088400b0023b3a9fa603sm3235620pjc.55.2023.03.30.07.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:29:46 -0700 (PDT)
Message-ID: <64259cda.170a0220.8d004.6870@mx.google.com>
Date:   Thu, 30 Mar 2023 07:29:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-145-g0d1637352a75
Subject: stable-rc/queue/5.15 baseline: 178 runs,
 9 regressions (v5.15.104-145-g0d1637352a75)
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

stable-rc/queue/5.15 baseline: 178 runs, 9 regressions (v5.15.104-145-g0d16=
37352a75)

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

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.104-145-g0d1637352a75/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.104-145-g0d1637352a75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d1637352a758d3c8bbc1f5dbafe548ec39c6037 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642569d3dcd02ae15662f770

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642569d3dcd02ae15662f775
        failing since 1 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T10:51:40.426493  + set +x

    2023-03-30T10:51:40.432963  <8>[   10.990381] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9813787_1.4.2.3.1>

    2023-03-30T10:51:40.535426  =


    2023-03-30T10:51:40.636386  / # #export SHELL=3D/bin/sh

    2023-03-30T10:51:40.636609  =


    2023-03-30T10:51:40.737503  / # export SHELL=3D/bin/sh. /lava-9813787/e=
nvironment

    2023-03-30T10:51:40.737739  =


    2023-03-30T10:51:40.838785  / # . /lava-9813787/environment/lava-981378=
7/bin/lava-test-runner /lava-9813787/1

    2023-03-30T10:51:40.839219  =


    2023-03-30T10:51:40.845039  / # /lava-9813787/bin/lava-test-runner /lav=
a-9813787/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642569c87ff1d7b72862f7c9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642569c87ff1d7b72862f7ce
        failing since 1 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T10:51:28.767992  + set<8>[   11.774783] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9813785_1.4.2.3.1>

    2023-03-30T10:51:28.768600   +x

    2023-03-30T10:51:28.877191  / # #

    2023-03-30T10:51:28.980090  export SHELL=3D/bin/sh

    2023-03-30T10:51:28.980988  #

    2023-03-30T10:51:29.083319  / # export SHELL=3D/bin/sh. /lava-9813785/e=
nvironment

    2023-03-30T10:51:29.084224  =


    2023-03-30T10:51:29.186284  / # . /lava-9813785/environment/lava-981378=
5/bin/lava-test-runner /lava-9813785/1

    2023-03-30T10:51:29.187710  =


    2023-03-30T10:51:29.192945  / # /lava-9813785/bin/lava-test-runner /lav=
a-9813785/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642569b4f5bbe3d50862f7be

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642569b4f5bbe3d50862f7c3
        failing since 1 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T10:51:25.060857  <8>[    7.940923] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9813783_1.4.2.3.1>

    2023-03-30T10:51:25.064138  + set +x

    2023-03-30T10:51:25.169383  #

    2023-03-30T10:51:25.272452  / # #export SHELL=3D/bin/sh

    2023-03-30T10:51:25.273314  =


    2023-03-30T10:51:25.375211  / # export SHELL=3D/bin/sh. /lava-9813783/e=
nvironment

    2023-03-30T10:51:25.375982  =


    2023-03-30T10:51:25.477581  / # . /lava-9813783/environment/lava-981378=
3/bin/lava-test-runner /lava-9813783/1

    2023-03-30T10:51:25.478966  =


    2023-03-30T10:51:25.483916  / # /lava-9813783/bin/lava-test-runner /lav=
a-9813783/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6425681a005083164062f79d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6425681a005083164062f=
79e
        failing since 55 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64256a162076246e5b62f78a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64256a172076246e5b62f78f
        failing since 72 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-30T10:53:00.102546  + set +x<8>[   10.027511] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3454895_1.5.2.4.1>
    2023-03-30T10:53:00.102793  =

    2023-03-30T10:53:00.209516  / # #
    2023-03-30T10:53:00.312175  export SHELL=3D/bin/sh
    2023-03-30T10:53:00.312568  #
    2023-03-30T10:53:00.413866  / # export SHELL=3D/bin/sh. /lava-3454895/e=
nvironment
    2023-03-30T10:53:00.414219  =

    2023-03-30T10:53:00.515457  / # . /lava-3454895/environment/lava-345489=
5/bin/lava-test-runner /lava-3454895/1
    2023-03-30T10:53:00.516527  =

    2023-03-30T10:53:00.516820  <3>[   10.353292] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642569ba37d20e45f862f76c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642569ba37d20e45f862f771
        failing since 1 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T10:51:28.556352  + set +x

    2023-03-30T10:51:28.563060  <8>[   10.570097] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9813777_1.4.2.3.1>

    2023-03-30T10:51:28.667875  / # #

    2023-03-30T10:51:28.768927  export SHELL=3D/bin/sh

    2023-03-30T10:51:28.769153  #

    2023-03-30T10:51:28.870048  / # export SHELL=3D/bin/sh. /lava-9813777/e=
nvironment

    2023-03-30T10:51:28.870292  =


    2023-03-30T10:51:28.971216  / # . /lava-9813777/environment/lava-981377=
7/bin/lava-test-runner /lava-9813777/1

    2023-03-30T10:51:28.971569  =


    2023-03-30T10:51:28.976185  / # /lava-9813777/bin/lava-test-runner /lav=
a-9813777/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642569c0ee061bca9a62f7c5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642569c0ee061bca9a62f7ca
        failing since 1 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T10:51:26.390972  <8>[   10.668730] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9813790_1.4.2.3.1>

    2023-03-30T10:51:26.394552  + set +x

    2023-03-30T10:51:26.496122  #

    2023-03-30T10:51:26.597316  / # #export SHELL=3D/bin/sh

    2023-03-30T10:51:26.597504  =


    2023-03-30T10:51:26.698215  / # export SHELL=3D/bin/sh. /lava-9813790/e=
nvironment

    2023-03-30T10:51:26.698400  =


    2023-03-30T10:51:26.799485  / # . /lava-9813790/environment/lava-981379=
0/bin/lava-test-runner /lava-9813790/1

    2023-03-30T10:51:26.799776  =


    2023-03-30T10:51:26.805313  / # /lava-9813790/bin/lava-test-runner /lav=
a-9813790/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642569c97ff1d7b72862f7d4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642569c97ff1d7b72862f7d9
        failing since 1 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T10:51:28.998555  + <8>[   10.963036] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9813752_1.4.2.3.1>

    2023-03-30T10:51:28.998673  set +x

    2023-03-30T10:51:29.103603  / # #

    2023-03-30T10:51:29.204559  export SHELL=3D/bin/sh

    2023-03-30T10:51:29.204733  #

    2023-03-30T10:51:29.305615  / # export SHELL=3D/bin/sh. /lava-9813752/e=
nvironment

    2023-03-30T10:51:29.305824  =


    2023-03-30T10:51:29.406779  / # . /lava-9813752/environment/lava-981375=
2/bin/lava-test-runner /lava-9813752/1

    2023-03-30T10:51:29.407052  =


    2023-03-30T10:51:29.411869  / # /lava-9813752/bin/lava-test-runner /lav=
a-9813752/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642569acdf89bba0ea62f783

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g0d1637352a75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642569acdf89bba0ea62f788
        failing since 1 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T10:51:16.213957  + set +x<8>[   11.693638] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9813730_1.4.2.3.1>

    2023-03-30T10:51:16.214057  =


    2023-03-30T10:51:16.318653  / # #

    2023-03-30T10:51:16.419724  export SHELL=3D/bin/sh

    2023-03-30T10:51:16.419942  #

    2023-03-30T10:51:16.520888  / # export SHELL=3D/bin/sh. /lava-9813730/e=
nvironment

    2023-03-30T10:51:16.521106  =


    2023-03-30T10:51:16.622071  / # . /lava-9813730/environment/lava-981373=
0/bin/lava-test-runner /lava-9813730/1

    2023-03-30T10:51:16.622400  =


    2023-03-30T10:51:16.627284  / # /lava-9813730/bin/lava-test-runner /lav=
a-9813730/1
 =

    ... (12 line(s) more)  =

 =20
