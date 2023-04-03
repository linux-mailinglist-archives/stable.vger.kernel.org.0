Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA10C6D4EEF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 19:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDCR2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 13:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjDCR2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 13:28:04 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF97F9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 10:28:02 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j13so27934174pjd.1
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 10:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680542882;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+XFBS9E0GzRGo/iE9L7mkP17w4dMantwELek2grmnEc=;
        b=KlyvpbxMlfvEHOHWcFQeLkR7xTb7gC2OD0QR9m6Vg3DxmbcqpHqx86x2jbB1oqb9qb
         6nfjcT6KhF8xziy6lr9u2Z0dD9Yo4rAm7BkFNQz4Kpx6Nc/JcPbrlr1ibc0VcI43XNAL
         lA8xi5hyf1lnBNixdahq/kyvwZk+Hkzzksdl//x9sBWUmHfDkIhlHR8zkXsMnjrD1Mxy
         rE0dERjfox20/j/TA+geITKyUeMl7bOAMV7keTgFUEY35sXiP9SkhOr7OeDQPT3YcWFh
         nGCbU7vN+0BU9zzarqVDG2/LCtIoUV+hUCZ4JwBUIrIkR/VSZKH4SgQGE+YxIttyUdKV
         wIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680542882;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+XFBS9E0GzRGo/iE9L7mkP17w4dMantwELek2grmnEc=;
        b=KQZQJ5i6o+oXdxom1ihutit6ua4Gh53AMWiEq+exJMBxCHWUrjjxJa5pjW/VMzimM5
         blMqD9Kq+6rs0Cz6TBbWJ5kez/y7HDu82xAab3k/1KZ+FARZhARVQgGA4Kb6Bx4cCWsF
         mVyBKX2Mczris6kG6Pj97/nJ0kXR5wBklJF+E1cwKMWnctlEPRXPSyUaBOjl3zU+wtYe
         ta2jirs0XfJ6JkD/WvvkIAIUAwx69iDiAsKQ/YcdySCqTpuAsbRn5WX4I3jGwD+pv25l
         LxCNu4H4WRpvkdAyuuks/EE25Zh8V70FtpTpccXTlu9F0DUSJ0+tC8OlWweY2CqWsdfS
         XtgA==
X-Gm-Message-State: AAQBX9fKpSBQzM9JrG3/Z5OdtKG2aZlESnUVdijgssWZ4rqoEEHgAziL
        F8++4el4JyPYVZw95rcBc+kkWXAiQOIrDL3ey++S6Q==
X-Google-Smtp-Source: AKy350Z/Yy7+KeJird1kLzfFQlwhXZ42OYYx3c44RPPFfw2uDQeqlWlk8Zhwl0IaEQDwfmoLZVWJqQ==
X-Received: by 2002:a17:90b:1e0e:b0:23d:3698:8ee8 with SMTP id pg14-20020a17090b1e0e00b0023d36988ee8mr41853162pjb.31.1680542881994;
        Mon, 03 Apr 2023 10:28:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090abb0300b0023371cb020csm9955916pjr.34.2023.04.03.10.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 10:28:01 -0700 (PDT)
Message-ID: <642b0ca1.170a0220.a91f1.364a@mx.google.com>
Date:   Mon, 03 Apr 2023 10:28:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.279-78-gfdd25f7ed127
Subject: stable-rc/linux-4.19.y baseline: 110 runs,
 4 regressions (v4.19.279-78-gfdd25f7ed127)
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

stable-rc/linux-4.19.y baseline: 110 runs, 4 regressions (v4.19.279-78-gfdd=
25f7ed127)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
beaglebone-black     | arm    | lab-broonie   | gcc-10   | omap2plus_defcon=
fig          | 1          =

cubietruck           | arm    | lab-baylibre  | gcc-10   | multi_v7_defconf=
ig           | 1          =

hp-14-db0003na-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =

r8a7743-iwg20d-q7    | arm    | lab-cip       | gcc-10   | shmobile_defconf=
ig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.279-78-gfdd25f7ed127/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.279-78-gfdd25f7ed127
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fdd25f7ed12706ca8c08858a520733b1913e0b43 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
beaglebone-black     | arm    | lab-broonie   | gcc-10   | omap2plus_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642adb4212cfd4b98c62f7af

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
79-78-gfdd25f7ed127/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
79-78-gfdd25f7ed127/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642adb4212cfd4b98c62f7e1
        new failure (last pass: v4.19.279)

    2023-04-03T13:56:38.508156  + set +x
    2023-04-03T13:56:38.511307  <8>[   20.141190] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 269993_1.5.2.4.1>
    2023-04-03T13:56:38.675613  / # #
    2023-04-03T13:56:38.796312  export SHELL=3D/bin/sh
    2023-04-03T13:56:38.802187  #
    2023-04-03T13:56:38.913425  / # export SHELL=3D/bin/sh. /lava-269993/en=
vironment
    2023-04-03T13:56:38.921985  =

    2023-04-03T13:56:38.931096  / # . /lava-269993/environment
    2023-04-03T13:56:39.046141  / # /lava-269993/bin/lava-test-runner /lava=
-269993/1
    2023-04-03T13:56:39.062972  /lava-269993/bin/lava-test-runner /lava-269=
993/1 =

    ... (12 line(s) more)  =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
cubietruck           | arm    | lab-baylibre  | gcc-10   | multi_v7_defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad9f0e0a59b372f62f78b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
79-78-gfdd25f7ed127/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
79-78-gfdd25f7ed127/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ad9f0e0a59b372f62f790
        failing since 76 days (last pass: v4.19.268-50-gbf741d1d7e6d, first=
 fail: v4.19.269-522-gc75d2b5524ab)

    2023-04-03T13:51:14.450998  + set +x<8>[    7.159361] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3467833_1.5.2.4.1>
    2023-04-03T13:51:14.451585  =

    2023-04-03T13:51:14.561422  / # #
    2023-04-03T13:51:14.664950  export SHELL=3D/bin/sh
    2023-04-03T13:51:14.665807  #
    2023-04-03T13:51:14.767793  / # export SHELL=3D/bin/sh. /lava-3467833/e=
nvironment
    2023-04-03T13:51:14.768712  =

    2023-04-03T13:51:14.871250  / # . /lava-3467833/environment/lava-346783=
3/bin/lava-test-runner /lava-3467833/1
    2023-04-03T13:51:14.872257  =

    2023-04-03T13:51:14.878768  / # /lava-3467833/bin/lava-test-runner /lav=
a-3467833/1 =

    ... (12 line(s) more)  =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
hp-14-db0003na-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ada34dba346e3cd62f77b

  Results:     17 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
79-78-gfdd25f7ed127/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-14-db0003na-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
79-78-gfdd25f7ed127/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-14-db0003na-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/642ada35dba346e=
3cd62f78e
        new failure (last pass: v4.19.279)
        1 lines

    2023-04-03T13:52:29.437220  kern  :emerg : do_IRQ: 1.55 No irq handler =
for vector
   =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
r8a7743-iwg20d-q7    | arm    | lab-cip       | gcc-10   | shmobile_defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642ad96c12a7ce8acf62f76c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
79-78-gfdd25f7ed127/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
79-78-gfdd25f7ed127/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642ad96c12a7ce8acf62f=
76d
        new failure (last pass: v4.19.279) =

 =20
