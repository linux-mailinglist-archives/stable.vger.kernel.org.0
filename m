Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3F26DFACC
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 18:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjDLQFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 12:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjDLQFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 12:05:35 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C75765A0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 09:05:33 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o2so11875973plg.4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 09:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681315533; x=1683907533;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BFdgg0IMuYD09O+85Qn34M8RIXxH4utiFFrWaMd0Waw=;
        b=IUVzXJ0wUC4UoyWCPL3v+r9Yuit4+pHE30gp9ISZm8/Xz9gRedtyOXTMoVchIElqM6
         Ul9NqcIQn3yPxrovR1nXPf6aDMbieSb45HPxGrYE/FAKj0W9Mb9xFwD43L6JOKzniGFv
         jLg1E1waNfH4AxK6ZE1COOuhxp3QnRJ9/itK3UtTPv54DxvP5sMRQOfjeOPl2oJ0rOXC
         zO3Mcdp2i2+bUW/2Th5I0+Do+XKWomnQIPP+pKfD7k8Ar7SwzKCJJq4QJ+UtXOs0KJjO
         nED5nawtjCmsgLoKDflZGF/kpNH75fiiR21eqwv5yc3M+NUp9g3sHdsML8F9y1PJMhwY
         8mEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681315533; x=1683907533;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BFdgg0IMuYD09O+85Qn34M8RIXxH4utiFFrWaMd0Waw=;
        b=fFhoW5afavngjPynMlrxRW8cm68NbblkVOvteYdO+TmxvxzdplwX+Lr2gRDmc91w5h
         KXLLPbqF4v5FKvU2n/7oXEW7NMBQ77nNbLCcZarLNt7irPjuOVwSOKioY8GHYieyZxbt
         6Ebuboo2jFeUcfjqLoodZgGW6LITFsGaVBmdA2KBgSDFa2m5bg9HAi/BIeiM9gcqxGuU
         4o4eznMxCltf/WV9S//CykFNTXMVXL0YDLfKSOF/Nsr18Vzm5SKERvjN8RXXeOkTZGuE
         JNTxUttC5j/mBfpqDi5bcapMYTyFVIp3MwsYryelFlMntOC955RKB9m64oiN17+pPUUS
         yROA==
X-Gm-Message-State: AAQBX9eRT/aLECt9aunqNZdSBXXBznvQUdnu1vmorBvWHW/DSGQKPKBO
        KeC/R6lvvSXP4sUrvjIiJt9P4Y8jJE1bPG+FZiwqew==
X-Google-Smtp-Source: AKy350YvZ/KuDoP1fp4dmdI2LusUHiqyTGqEwv3duXSIrp6ogctxzNKM12UV/ZlD2Sjv4VW9Ntx5QQ==
X-Received: by 2002:a17:90b:1a85:b0:23d:10f2:bda2 with SMTP id ng5-20020a17090b1a8500b0023d10f2bda2mr24984719pjb.30.1681315532313;
        Wed, 12 Apr 2023 09:05:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q20-20020a170902b11400b0019f2328bef8sm11825336plr.34.2023.04.12.09.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 09:05:31 -0700 (PDT)
Message-ID: <6436d6cb.170a0220.2ffdb.7f54@mx.google.com>
Date:   Wed, 12 Apr 2023 09:05:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-188-gc249f030431b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 180 runs,
 10 regressions (v5.15.105-188-gc249f030431b)
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

stable-rc/queue/5.15 baseline: 180 runs, 10 regressions (v5.15.105-188-gc24=
9f030431b)

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

at91sam9g20ek                | arm    | lab-broonie   | gcc-10   | multi_v5=
_defconfig           | 1          =

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
nel/v5.15.105-188-gc249f030431b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-188-gc249f030431b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c249f030431b412c74a487ae5705def74cfab234 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a1d88e4b188f602e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a1d88e4b188f602e85eb
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-12T12:19:10.641752  <8>[   10.291312] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948661_1.4.2.3.1>

    2023-04-12T12:19:10.645107  + set +x

    2023-04-12T12:19:10.752621  / # #

    2023-04-12T12:19:10.855599  export SHELL=3D/bin/sh

    2023-04-12T12:19:10.856423  #

    2023-04-12T12:19:10.958455  / # export SHELL=3D/bin/sh. /lava-9948661/e=
nvironment

    2023-04-12T12:19:10.959249  =


    2023-04-12T12:19:11.061360  / # . /lava-9948661/environment/lava-994866=
1/bin/lava-test-runner /lava-9948661/1

    2023-04-12T12:19:11.062703  =


    2023-04-12T12:19:11.068871  / # /lava-9948661/bin/lava-test-runner /lav=
a-9948661/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a19976f2ff03e12e8653

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a19976f2ff03e12e8658
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-12T12:18:14.287037  + <8>[   11.446415] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9948680_1.4.2.3.1>

    2023-04-12T12:18:14.287127  set +x

    2023-04-12T12:18:14.391645  / # #

    2023-04-12T12:18:14.492706  export SHELL=3D/bin/sh

    2023-04-12T12:18:14.492922  #

    2023-04-12T12:18:14.593869  / # export SHELL=3D/bin/sh. /lava-9948680/e=
nvironment

    2023-04-12T12:18:14.594089  =


    2023-04-12T12:18:14.695033  / # . /lava-9948680/environment/lava-994868=
0/bin/lava-test-runner /lava-9948680/1

    2023-04-12T12:18:14.695419  =


    2023-04-12T12:18:14.700572  / # /lava-9948680/bin/lava-test-runner /lav=
a-9948680/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a19a4d6578e5e52e85f6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a19a4d6578e5e52e85fb
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-12T12:18:11.466533  <8>[   10.469908] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948646_1.4.2.3.1>

    2023-04-12T12:18:11.469874  + set +x

    2023-04-12T12:18:11.575629  #

    2023-04-12T12:18:11.676963  / # #export SHELL=3D/bin/sh

    2023-04-12T12:18:11.677135  =


    2023-04-12T12:18:11.778047  / # export SHELL=3D/bin/sh. /lava-9948646/e=
nvironment

    2023-04-12T12:18:11.778213  =


    2023-04-12T12:18:11.879123  / # . /lava-9948646/environment/lava-994864=
6/bin/lava-test-runner /lava-9948646/1

    2023-04-12T12:18:11.879383  =


    2023-04-12T12:18:11.884577  / # /lava-9948646/bin/lava-test-runner /lav=
a-9948646/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
at91sam9g20ek                | arm    | lab-broonie   | gcc-10   | multi_v5=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a1460510041bd62e8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6436a1460510041bd62e8=
652
        new failure (last pass: v5.15.105-192-g2d6ce1bab2b6) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a64ca178b2cae92e8645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6436a64ca178b2cae92e8=
646
        failing since 68 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a680c73b9157d02e85fc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a680c73b9157d02e8601
        failing since 85 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-12T12:39:11.744110  <8>[    9.899106] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3489295_1.5.2.4.1>
    2023-04-12T12:39:11.854081  / # #
    2023-04-12T12:39:11.957214  export SHELL=3D/bin/sh
    2023-04-12T12:39:11.958120  #
    2023-04-12T12:39:12.060135  / # export SHELL=3D/bin/sh. /lava-3489295/e=
nvironment
    2023-04-12T12:39:12.061077  =

    2023-04-12T12:39:12.163097  / # . /lava-3489295/environment/lava-348929=
5/bin/lava-test-runner /lava-3489295/1
    2023-04-12T12:39:12.164601  =

    2023-04-12T12:39:12.165033  / # <3>[   10.273502] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-12T12:39:12.169425  /lava-3489295/bin/lava-test-runner /lava-34=
89295/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a1ac50e51611ce2e85ef

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a1ac50e51611ce2e85f4
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-12T12:18:36.770775  + set +x

    2023-04-12T12:18:36.777476  <8>[   10.497704] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948627_1.4.2.3.1>

    2023-04-12T12:18:36.882338  / # #

    2023-04-12T12:18:36.983414  export SHELL=3D/bin/sh

    2023-04-12T12:18:36.983621  #

    2023-04-12T12:18:37.084560  / # export SHELL=3D/bin/sh. /lava-9948627/e=
nvironment

    2023-04-12T12:18:37.084742  =


    2023-04-12T12:18:37.185648  / # . /lava-9948627/environment/lava-994862=
7/bin/lava-test-runner /lava-9948627/1

    2023-04-12T12:18:37.185923  =


    2023-04-12T12:18:37.190851  / # /lava-9948627/bin/lava-test-runner /lav=
a-9948627/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a186234811f11a2e862e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a186234811f11a2e8633
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-12T12:17:57.086038  <8>[   10.825861] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948686_1.4.2.3.1>

    2023-04-12T12:17:57.089353  + set +x

    2023-04-12T12:17:57.194761  #

    2023-04-12T12:17:57.297679  / # #export SHELL=3D/bin/sh

    2023-04-12T12:17:57.298383  =


    2023-04-12T12:17:57.400152  / # export SHELL=3D/bin/sh. /lava-9948686/e=
nvironment

    2023-04-12T12:17:57.400839  =


    2023-04-12T12:17:57.502708  / # . /lava-9948686/environment/lava-994868=
6/bin/lava-test-runner /lava-9948686/1

    2023-04-12T12:17:57.503839  =


    2023-04-12T12:17:57.508911  / # /lava-9948686/bin/lava-test-runner /lav=
a-9948686/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a19876f2ff03e12e8648

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a19876f2ff03e12e864d
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-12T12:18:20.774561  + set<8>[   11.100410] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9948624_1.4.2.3.1>

    2023-04-12T12:18:20.775019   +x

    2023-04-12T12:18:20.879307  / # #

    2023-04-12T12:18:20.980210  export SHELL=3D/bin/sh

    2023-04-12T12:18:20.980407  #

    2023-04-12T12:18:21.081341  / # export SHELL=3D/bin/sh. /lava-9948624/e=
nvironment

    2023-04-12T12:18:21.081526  =


    2023-04-12T12:18:21.182458  / # . /lava-9948624/environment/lava-994862=
4/bin/lava-test-runner /lava-9948624/1

    2023-04-12T12:18:21.182756  =


    2023-04-12T12:18:21.187248  / # /lava-9948624/bin/lava-test-runner /lav=
a-9948624/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436a184234811f11a2e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-188-gc249f030431b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436a184234811f11a2e85f9
        failing since 15 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-12T12:18:05.564876  <8>[   11.587463] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9948659_1.4.2.3.1>

    2023-04-12T12:18:05.669132  / # #

    2023-04-12T12:18:05.770337  export SHELL=3D/bin/sh

    2023-04-12T12:18:05.770595  #

    2023-04-12T12:18:05.871573  / # export SHELL=3D/bin/sh. /lava-9948659/e=
nvironment

    2023-04-12T12:18:05.871846  =


    2023-04-12T12:18:05.972856  / # . /lava-9948659/environment/lava-994865=
9/bin/lava-test-runner /lava-9948659/1

    2023-04-12T12:18:05.973234  =


    2023-04-12T12:18:05.978073  / # /lava-9948659/bin/lava-test-runner /lav=
a-9948659/1

    2023-04-12T12:18:05.983048  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
