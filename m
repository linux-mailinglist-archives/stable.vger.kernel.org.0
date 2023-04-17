Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAFC6E44B9
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 12:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjDQKEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 06:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDQKDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 06:03:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A3F9EFE
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 03:02:28 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1a6670671e3so10810565ad.0
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 03:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681725738; x=1684317738;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zKf0rwQPuiJgIn9Q45REmsUUmYwVBYVuyb/Q1S+dRAI=;
        b=NubjeYDZUEq4oAgv9IF+AEm4BC9tZjJ1fNbRWGS8rzMDxfOj2gtLJKP66OJL6iXL7U
         RIgzLg8nwbHt1Rgm9GGdLVopod1Zz6raAzRdpRcEuo+INT85HuvGD6xP9yXvD5vsF+4U
         1lvdmbdBmyHS7JnG6rh5IsFvS6gVdVfGHryu41BBLhTYT7Rs1kxd28ow+84FdmTS1kQK
         wgAxDJuxgBPCFVTynSQm0ZHx+1CzWo8oBDxD2h1w5TfQHJfzmJAvAbML5UBfP28/6nvi
         PUQ4n76dvZGNx8CFkbr0Mu1spCdGJz/S1xgUAU+/R6hCSKqaSTZTPEJKbH87ArplCm7s
         Y2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681725738; x=1684317738;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zKf0rwQPuiJgIn9Q45REmsUUmYwVBYVuyb/Q1S+dRAI=;
        b=Dsc4mlHthWLlenKN85vMyujMV6vHFPqQ7pEpb5vwbk3HQUmKyVTgS1XlmmEx3i8D31
         I+y1reeFLI2BKYth/Okbc7wWIUomnyyn3HQJEccpVGqjg12Ki/S4xdIzVBihcQeWt7s+
         7tH5yLvXiLbYhPWVxfxybaD0kcz6yAzdIHs1Thf60tnhkkrgKS7S6JPEDiGT0VUypD/v
         w1fkZeFeN3rWvDmpyKOiHRMFs38iscM7UhpwEbJ7vrBzwulaDsc1YrbTzQQwdmQStOG/
         CuNU+aSRZ1iWl8xtgFCPMYBZ/hJSMdRZho3E3t3mUP/032K+s3MbE7T/m4SR5MHta5Fy
         dQeA==
X-Gm-Message-State: AAQBX9dmG+533UcnsEvJeutLEbum9q312lCc4gZkMI/Z3WXbAnFgiV3K
        XrQcPFJBZDOzBtJQVxlsImbRU9MWdVpeu36DO74vTaFY
X-Google-Smtp-Source: AKy350YQfNFKNp/Mcn4dC5pdnwoYiZD8kceuBUaUFPx9nQN/WMDaXrZodPsExsz8siDMFzvzv8YaSw==
X-Received: by 2002:a05:6a00:17a9:b0:63b:8b47:453c with SMTP id s41-20020a056a0017a900b0063b8b47453cmr5685799pfg.1.1681725738141;
        Mon, 17 Apr 2023 03:02:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o21-20020a63f155000000b0050be8e0b94csm6746110pgk.90.2023.04.17.03.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 03:02:17 -0700 (PDT)
Message-ID: <643d1929.630a0220.c656.e5a6@mx.google.com>
Date:   Mon, 17 Apr 2023 03:02:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-244-g4632bdfc359d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 180 runs,
 11 regressions (v5.15.105-244-g4632bdfc359d)
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

stable-rc/queue/5.15 baseline: 180 runs, 11 regressions (v5.15.105-244-g463=
2bdfc359d)

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
nel/v5.15.105-244-g4632bdfc359d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-244-g4632bdfc359d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4632bdfc359d448752bea799ffa9b4b1c7a3342d =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce2e67c6db646dc2e85f8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce2e67c6db646dc2e85fd
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T06:10:22.110181  + set +x

    2023-04-17T06:10:22.116768  <8>[   11.105198] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10015317_1.4.2.3.1>

    2023-04-17T06:10:22.222262  =


    2023-04-17T06:10:22.324001  / # #export SHELL=3D/bin/sh

    2023-04-17T06:10:22.324237  =


    2023-04-17T06:10:22.425169  / # export SHELL=3D/bin/sh. /lava-10015317/=
environment

    2023-04-17T06:10:22.425414  =


    2023-04-17T06:10:22.526472  / # . /lava-10015317/environment/lava-10015=
317/bin/lava-test-runner /lava-10015317/1

    2023-04-17T06:10:22.526757  =


    2023-04-17T06:10:22.532726  / # /lava-10015317/bin/lava-test-runner /la=
va-10015317/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce2d231b48881ce2e8604

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce2d231b48881ce2e8609
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T06:10:04.396578  + <8>[   11.015197] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10015326_1.4.2.3.1>

    2023-04-17T06:10:04.396675  set +x

    2023-04-17T06:10:04.500714  / # #

    2023-04-17T06:10:04.601621  export SHELL=3D/bin/sh

    2023-04-17T06:10:04.601827  #

    2023-04-17T06:10:04.702751  / # export SHELL=3D/bin/sh. /lava-10015326/=
environment

    2023-04-17T06:10:04.702970  =


    2023-04-17T06:10:04.803914  / # . /lava-10015326/environment/lava-10015=
326/bin/lava-test-runner /lava-10015326/1

    2023-04-17T06:10:04.804234  =


    2023-04-17T06:10:04.808660  / # /lava-10015326/bin/lava-test-runner /la=
va-10015326/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce2ce31b48881ce2e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce2ce31b48881ce2e85ec
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T06:10:03.246182  <8>[   10.389203] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10015268_1.4.2.3.1>

    2023-04-17T06:10:03.249319  + set +x

    2023-04-17T06:10:03.351518  =


    2023-04-17T06:10:03.452553  / # #export SHELL=3D/bin/sh

    2023-04-17T06:10:03.452804  =


    2023-04-17T06:10:03.553760  / # export SHELL=3D/bin/sh. /lava-10015268/=
environment

    2023-04-17T06:10:03.554002  =


    2023-04-17T06:10:03.654974  / # . /lava-10015268/environment/lava-10015=
268/bin/lava-test-runner /lava-10015268/1

    2023-04-17T06:10:03.655343  =


    2023-04-17T06:10:03.660190  / # /lava-10015268/bin/lava-test-runner /la=
va-10015268/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce755da44d459432e8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ce755da44d459432e8=
654
        failing since 72 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce6d0856173b0c82e85f7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce6d0856173b0c82e85fc
        failing since 89 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-17T06:26:55.005547  <8>[    9.922804] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3504614_1.5.2.4.1>
    2023-04-17T06:26:55.112130  / # #
    2023-04-17T06:26:55.213743  export SHELL=3D/bin/sh
    2023-04-17T06:26:55.214114  #
    2023-04-17T06:26:55.315274  / # export SHELL=3D/bin/sh. /lava-3504614/e=
nvironment
    2023-04-17T06:26:55.315656  =

    2023-04-17T06:26:55.416654  / # . /lava-3504614/environment/lava-350461=
4/bin/lava-test-runner /lava-3504614/1
    2023-04-17T06:26:55.417225  =

    2023-04-17T06:26:55.422166  / # /lava-3504614/bin/lava-test-runner /lav=
a-3504614/1
    2023-04-17T06:26:55.462774  <3>[   10.353077] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce30c7d828a787c2e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce30c7d828a787c2e85fc
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T06:11:09.390498  + <8>[   10.310447] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10015329_1.4.2.3.1>

    2023-04-17T06:11:09.390595  set +x

    2023-04-17T06:11:09.493024  =


    2023-04-17T06:11:09.594026  / # #export SHELL=3D/bin/sh

    2023-04-17T06:11:09.594237  =


    2023-04-17T06:11:09.695193  / # export SHELL=3D/bin/sh. /lava-10015329/=
environment

    2023-04-17T06:11:09.695402  =


    2023-04-17T06:11:09.796379  / # . /lava-10015329/environment/lava-10015=
329/bin/lava-test-runner /lava-10015329/1

    2023-04-17T06:11:09.796685  =


    2023-04-17T06:11:09.801377  / # /lava-10015329/bin/lava-test-runner /la=
va-10015329/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce2bf9442b5be9f2e85f5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce2bf9442b5be9f2e85fa
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T06:09:53.044438  + set +x

    2023-04-17T06:09:53.051044  <8>[    8.008966] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10015301_1.4.2.3.1>

    2023-04-17T06:09:53.155503  / # #

    2023-04-17T06:09:53.256505  export SHELL=3D/bin/sh

    2023-04-17T06:09:53.256690  #

    2023-04-17T06:09:53.357586  / # export SHELL=3D/bin/sh. /lava-10015301/=
environment

    2023-04-17T06:09:53.357766  =


    2023-04-17T06:09:53.458700  / # . /lava-10015301/environment/lava-10015=
301/bin/lava-test-runner /lava-10015301/1

    2023-04-17T06:09:53.458946  =


    2023-04-17T06:09:53.464293  / # /lava-10015301/bin/lava-test-runner /la=
va-10015301/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce2be7546f9574c2e8613

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce2be7546f9574c2e8618
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T06:09:59.100640  + set +x<8>[    8.740641] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10015348_1.4.2.3.1>

    2023-04-17T06:09:59.101135  =


    2023-04-17T06:09:59.208966  / # #

    2023-04-17T06:09:59.311546  export SHELL=3D/bin/sh

    2023-04-17T06:09:59.312297  #

    2023-04-17T06:09:59.414037  / # export SHELL=3D/bin/sh. /lava-10015348/=
environment

    2023-04-17T06:09:59.414844  =


    2023-04-17T06:09:59.516652  / # . /lava-10015348/environment/lava-10015=
348/bin/lava-test-runner /lava-10015348/1

    2023-04-17T06:09:59.517046  =


    2023-04-17T06:09:59.521552  / # /lava-10015348/bin/lava-test-runner /la=
va-10015348/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce6a419d38fd7632e85e7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce6a419d38fd7632e85ec
        failing since 79 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-17T06:26:19.208300  + set +x
    2023-04-17T06:26:19.208478  [    9.404361] <LAVA_SIGNAL_ENDRUN 0_dmesg =
928250_1.5.2.3.1>
    2023-04-17T06:26:19.316214  / # #
    2023-04-17T06:26:19.417769  export SHELL=3D/bin/sh
    2023-04-17T06:26:19.418266  #
    2023-04-17T06:26:19.519501  / # export SHELL=3D/bin/sh. /lava-928250/en=
vironment
    2023-04-17T06:26:19.519956  =

    2023-04-17T06:26:19.621179  / # . /lava-928250/environment/lava-928250/=
bin/lava-test-runner /lava-928250/1
    2023-04-17T06:26:19.621761  =

    2023-04-17T06:26:19.623959  / # /lava-928250/bin/lava-test-runner /lava=
-928250/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce2be9442b5be9f2e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce2be9442b5be9f2e85ec
        failing since 19 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-17T06:09:52.894080  <8>[   11.672517] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10015346_1.4.2.3.1>

    2023-04-17T06:09:52.998771  / # #

    2023-04-17T06:09:53.099766  export SHELL=3D/bin/sh

    2023-04-17T06:09:53.100011  #

    2023-04-17T06:09:53.200963  / # export SHELL=3D/bin/sh. /lava-10015346/=
environment

    2023-04-17T06:09:53.201163  =


    2023-04-17T06:09:53.302099  / # . /lava-10015346/environment/lava-10015=
346/bin/lava-test-runner /lava-10015346/1

    2023-04-17T06:09:53.302400  =


    2023-04-17T06:09:53.307587  / # /lava-10015346/bin/lava-test-runner /la=
va-10015346/1

    2023-04-17T06:09:53.313203  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce30c7d828a787c2e85ec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-244-g4632bdfc359d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce30c7d828a787c2e85f1
        failing since 75 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-17T06:11:12.200599  / # #
    2023-04-17T06:11:12.306925  export SHELL=3D/bin/sh
    2023-04-17T06:11:12.308543  #
    2023-04-17T06:11:12.412199  / # export SHELL=3D/bin/sh. /lava-3504499/e=
nvironment
    2023-04-17T06:11:12.413809  =

    2023-04-17T06:11:12.517226  / # . /lava-3504499/environment/lava-350449=
9/bin/lava-test-runner /lava-3504499/1
    2023-04-17T06:11:12.520006  =

    2023-04-17T06:11:12.539167  / # /lava-3504499/bin/lava-test-runner /lav=
a-3504499/1
    2023-04-17T06:11:12.645951  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-17T06:11:12.649278  + cd /lava-3504499/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
