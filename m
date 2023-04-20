Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D206E9C57
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 21:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjDTTPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 15:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjDTTPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 15:15:37 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D32630D1
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 12:15:32 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b5c4c769aso1899062b3a.3
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 12:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682018131; x=1684610131;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xZ6gpKVchpuAxlQHTC4dZ5XM68lWyahT6H3qEY1aeyQ=;
        b=f22v+9tPGCKu0U0tPFmXntklsugT1wxUd4of88t/cT0zUyFfZYIGczyaJ5APHbLYYv
         xCMI7hRLhhpnx3CZ4M/YmYxjbZwWmK/T9DkZbovHe3ITFxz2HHSZCkru6y04XCT4LiQz
         nCw5iXtcnbgVxdw4Hsc/6oBG9HKVhigP/n9WvhbC1gvePVH4+Rl9Q3pQMZREgN0owqHf
         Ulledh4l3AIRgbG1u9HP0l+XuvdN1/Ygyj2XNZEUinS7ASx0N2pgIJofhbfpwGB/KChO
         OXpaAfNdC72Jt3G1dImSsBVafnhoqgN3H7UWUroU8p6m1Vr5uc69lLkKbCP98udIUOQo
         8dmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682018131; x=1684610131;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZ6gpKVchpuAxlQHTC4dZ5XM68lWyahT6H3qEY1aeyQ=;
        b=LkFiZcCsrV3httMgftevxGm3GzR4CwUb//ld0DYb/WWGrvX/baAf4OA6Glw9yIoeHI
         92sHp/Sx+Z1b4jVJIzBwlz0vkkSeUaFQSidcHR5flyPbKuLCOghWEQIJTrTA3xJwCZwN
         Smlflye0lYevDH/sE470Y6P9c50W+QUdAAlvKREvQKeZ8hjx+fg/cdAyPbgK2DBxmlka
         PDQJvNyThwvHPV8831+l17TRaKUKp20ItI/3+itJ0Ptme9V2S+zJLIpJmXaLGL+mco4t
         aU+lv3fJLD55b4nO4x5u6cp3vexUmWcsjBG64brGgBNpArFU5jBuz2oU2SyfPbhynGAg
         rCAg==
X-Gm-Message-State: AAQBX9d8QPAAPW6ZI88EdGAOkkdBPUihygCqtqZLJWO3M7iotRX+aMXa
        k84il8XxtoBHordxNaqoJ5ifuB0DKbh48bkSh533kgB/
X-Google-Smtp-Source: AKy350Y0undXs2Na8oe/yPc33RURX2DZ7SgBnfPzfqll6MmTvhvhS3juAGB++1BZo/pXItGEdBBRzw==
X-Received: by 2002:a05:6a00:1a8b:b0:623:8592:75c4 with SMTP id e11-20020a056a001a8b00b00623859275c4mr2792204pfv.29.1682018130998;
        Thu, 20 Apr 2023 12:15:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a22-20020a056a000c9600b0062dd9a8c1b8sm1587767pfv.100.2023.04.20.12.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 12:15:30 -0700 (PDT)
Message-ID: <64418f52.050a0220.64be5.3a26@mx.google.com>
Date:   Thu, 20 Apr 2023 12:15:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.108
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 108 runs, 22 regressions (v5.15.108)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "chromeos.kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 108 runs, 22 regressions (v5.15.108)

Regressions Summary
-------------------

platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
acer-R721T-grunt             | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

hp-11A-G6-EE-grunt           | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

hp-14-db0003na-grunt         | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

hp-14-db0003na-grunt         | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

hp-x360-12b-c...4000-octopus | x86_64 | lab-collabora-staging | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.108/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.108
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3299fb36854fdc288bddc2c4d265f8a2e5105944 =



Test Regressions
---------------- =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
acer-R721T-grunt             | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415b4a55ba1eefbc748172

  Results:     17 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-acer-R721T-grunt.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-acer-R721T-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.video-driver-present: https://kernelci.org/test/case/id=
/64415b4a55ba1eefbc748182
        failing since 20 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T15:33:09.865104  /lava-10064252/1/../bin/lava-test-case

    2023-04-20T15:33:09.873014  <8>[    8.229219] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dvideo-driver-present RESULT=3Dfail>
   =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
acer-cb317-1h-c3z6-dedede    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415c41a2c97cd8b3748129

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-acer-cb317-1h-c3z6-dedede.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-acer-cb317-1h-c3z6-dedede.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64415c41a2c97cd8b3748=
12a
        failing since 86 days (last pass: v5.15.89, first fail: v5.15.90) =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644156fd0bd2c40c69748105

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus=
-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus=
-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644156fd0bd2c40c69748109
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:14:45.776203  + set +x

    2023-04-20T15:14:45.782806  <8>[   10.594464] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10063582_1.4.2.3.1>

    2023-04-20T15:14:45.891232  / # #

    2023-04-20T15:14:45.994348  export SHELL=3D/bin/sh

    2023-04-20T15:14:45.995139  #

    2023-04-20T15:14:46.097003  / # export SHELL=3D/bin/sh. /lava-10063582/=
environment

    2023-04-20T15:14:46.097785  =


    2023-04-20T15:14:46.199729  / # . /lava-10063582/environment/lava-10063=
582/bin/lava-test-runner /lava-10063582/1

    2023-04-20T15:14:46.201086  =


    2023-04-20T15:14:46.207109  / # /lava-10063582/bin/lava-test-runner /la=
va-10063582/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415c41a2c97cd8b374812c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64415c41a2c97cd8b3748=
12d
        failing since 20 days (last pass: v5.15.104, first fail: v5.15.105) =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415e512d287cfc80748192

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-intel-denverton.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-intel-denverton.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-intel-denverton.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415e512d287cfc80748197
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:46:06.749741  + set +x

    2023-04-20T15:46:06.753700  <8>[    6.762672] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064698_1.4.2.3.1>

    2023-04-20T15:46:06.861901  / # #

    2023-04-20T15:46:06.964985  export SHELL=3D/bin/sh

    2023-04-20T15:46:06.965803  #

    2023-04-20T15:46:07.067939  / # export SHELL=3D/bin/sh. /lava-10064698/=
environment

    2023-04-20T15:46:07.068763  =


    2023-04-20T15:46:07.170859  / # . /lava-10064698/environment/lava-10064=
698/bin/lava-test-runner /lava-10064698/1

    2023-04-20T15:46:07.172165  =


    2023-04-20T15:46:07.178043  / # /lava-10064698/bin/lava-test-runner /la=
va-10064698/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/644159fa22a36cbbdc74810d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config=
+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromiumos-x86_64.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-asu=
s-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromiumos-x86_64.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-asu=
s-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644159fa22a36cbbdc748112
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:27:37.720434  + set +x

    2023-04-20T15:27:37.727207  <8>[    7.114917] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064055_1.4.2.3.1>

    2023-04-20T15:27:37.831990  / # #

    2023-04-20T15:27:37.933048  export SHELL=3D/bin/sh

    2023-04-20T15:27:37.933280  #

    2023-04-20T15:27:38.034222  / # export SHELL=3D/bin/sh. /lava-10064055/=
environment

    2023-04-20T15:27:38.034473  =


    2023-04-20T15:27:38.135455  / # . /lava-10064055/environment/lava-10064=
055/bin/lava-test-runner /lava-10064055/1

    2023-04-20T15:27:38.135813  =


    2023-04-20T15:27:38.140369  / # /lava-10064055/bin/lava-test-runner /la=
va-10064055/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644156bd6d0e7c6f1a748179

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus=
-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus=
-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644156bd6d0e7c6f1a74817e
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:13:47.619120  <8>[   11.737774] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10063599_1.4.2.3.1>

    2023-04-20T15:13:47.723608  / # #

    2023-04-20T15:13:47.824590  export SHELL=3D/bin/sh

    2023-04-20T15:13:47.824744  #

    2023-04-20T15:13:47.925485  / # export SHELL=3D/bin/sh. /lava-10063599/=
environment

    2023-04-20T15:13:47.925627  =


    2023-04-20T15:13:48.026536  / # . /lava-10063599/environment/lava-10063=
599/bin/lava-test-runner /lava-10063599/1

    2023-04-20T15:13:48.026758  =


    2023-04-20T15:13:48.031801  / # /lava-10063599/bin/lava-test-runner /la=
va-10063599/1

    2023-04-20T15:13:48.045194  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415e592d287cfc807481af

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-intel-denverton.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-intel-denverton.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-intel-denverton.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415e592d287cfc807481b4
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:46:16.683464  <8>[    6.388384] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064688_1.4.2.3.1>

    2023-04-20T15:46:16.686624  + set +x

    2023-04-20T15:46:16.791501  / # #

    2023-04-20T15:46:16.892627  export SHELL=3D/bin/sh

    2023-04-20T15:46:16.892849  #

    2023-04-20T15:46:16.993803  / # export SHELL=3D/bin/sh. /lava-10064688/=
environment

    2023-04-20T15:46:16.994038  =


    2023-04-20T15:46:17.095038  / # . /lava-10064688/environment/lava-10064=
688/bin/lava-test-runner /lava-10064688/1

    2023-04-20T15:46:17.095428  =


    2023-04-20T15:46:17.100210  / # /lava-10064688/bin/lava-test-runner /la=
va-10064688/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644156ac6d0e7c6f1a74810d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus=
-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus=
-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644156ac6d0e7c6f1a748112
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:13:40.476476  <8>[    7.841535] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10063649_1.4.2.3.1>

    2023-04-20T15:13:40.480196  + set +x

    2023-04-20T15:13:40.581940  #

    2023-04-20T15:13:40.582268  =


    2023-04-20T15:13:40.683285  / # #export SHELL=3D/bin/sh

    2023-04-20T15:13:40.683483  =


    2023-04-20T15:13:40.784471  / # export SHELL=3D/bin/sh. /lava-10063649/=
environment

    2023-04-20T15:13:40.784673  =


    2023-04-20T15:13:40.885556  / # . /lava-10063649/environment/lava-10063=
649/bin/lava-test-runner /lava-10063649/1

    2023-04-20T15:13:40.885868  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-11A-G6-EE-grunt           | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415b4e55ba1eefbc748193

  Results:     17 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.video-driver-present: https://kernelci.org/test/case/id=
/64415b4e55ba1eefbc748196
        failing since 20 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T15:33:05.833223  /lava-10064230/1/../bin/lava-test-case

    2023-04-20T15:33:05.841268  <8>[    7.962737] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dvideo-driver-present RESULT=3Dfail>
   =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-14-db0003na-grunt         | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415b3fbe36943ea7748122

  Results:     17 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-hp-14-db0003na-grunt.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-hp-14-db0003na-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.video-driver-present: https://kernelci.org/test/case/id=
/64415b3fbe36943ea7748125
        failing since 20 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-20T15:32:59.690333  /lava-10064265/1/../bin/lava-test-case

    2023-04-20T15:32:59.696368  <8>[    8.466831] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dvideo-driver-present RESULT=3Dfail>
   =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-14-db0003na-grunt         | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415aecbe36943ea7748101

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config=
+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromiumos-x86_64.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-hp-=
14-db0003na-grunt.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromiumos-x86_64.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-hp-=
14-db0003na-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64415aecbe36943ea7748=
102
        new failure (last pass: v5.15.107) =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644156e9bc97324e5174811f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x=
360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x=
360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644156e9bc97324e51748124
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:14:34.739944  + set +x

    2023-04-20T15:14:34.747021  <8>[   10.441113] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10063593_1.4.2.3.1>

    2023-04-20T15:14:34.855284  / # #

    2023-04-20T15:14:34.958303  export SHELL=3D/bin/sh

    2023-04-20T15:14:34.959127  #

    2023-04-20T15:14:35.061039  / # export SHELL=3D/bin/sh. /lava-10063593/=
environment

    2023-04-20T15:14:35.061925  =


    2023-04-20T15:14:35.164003  / # . /lava-10063593/environment/lava-10063=
593/bin/lava-test-runner /lava-10063593/1

    2023-04-20T15:14:35.165306  =


    2023-04-20T15:14:35.170250  / # /lava-10063593/bin/lava-test-runner /la=
va-10063593/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-12b-c...4000-octopus | x86_64 | lab-collabora-staging | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6441569a37583113d0748101

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora-staging/basel=
ine-hp-x360-12b-ca0500na-n4000-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora-staging/basel=
ine-hp-x360-12b-ca0500na-n4000-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441569a37583113d0748106
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:13:19.614786  + set +x

    2023-04-20T15:13:19.621213  <8>[    8.049713] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 439575_1.4.2.3.1>

    2023-04-20T15:13:19.728622  / # #

    2023-04-20T15:13:19.830176  export SHELL=3D/bin/sh

    2023-04-20T15:13:19.831026  #

    2023-04-20T15:13:19.932154  / # export SHELL=3D/bin/sh. /lava-439575/en=
vironment

    2023-04-20T15:13:19.932764  =


    2023-04-20T15:13:20.033703  / # . /lava-439575/environment/lava-439575/=
bin/lava-test-runner /lava-439575/1

    2023-04-20T15:13:20.034589  =


    2023-04-20T15:13:20.039084  / # /lava-439575/bin/lava-test-runner /lava=
-439575/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644156980f66fcf79374816c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x=
360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x=
360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644156980f66fcf793748171
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:13:12.819988  <8>[   10.188125] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10063623_1.4.2.3.1>

    2023-04-20T15:13:12.823182  + set +x

    2023-04-20T15:13:12.924886  #

    2023-04-20T15:13:12.925285  =


    2023-04-20T15:13:13.026313  / # #export SHELL=3D/bin/sh

    2023-04-20T15:13:13.026543  =


    2023-04-20T15:13:13.127470  / # export SHELL=3D/bin/sh. /lava-10063623/=
environment

    2023-04-20T15:13:13.127723  =


    2023-04-20T15:13:13.228673  / # . /lava-10063623/environment/lava-10063=
623/bin/lava-test-runner /lava-10063623/1

    2023-04-20T15:13:13.229033  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415e4f2d287cfc80748187

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-intel-denverton.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-intel-denverton.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-intel-denverton.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415e4f2d287cfc8074818c
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:46:06.298023  + set +x

    2023-04-20T15:46:06.304137  <8>[    6.638453] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064672_1.4.2.3.1>

    2023-04-20T15:46:06.413493  / # #

    2023-04-20T15:46:06.516413  export SHELL=3D/bin/sh

    2023-04-20T15:46:06.517188  #

    2023-04-20T15:46:06.619122  / # export SHELL=3D/bin/sh. /lava-10064672/=
environment

    2023-04-20T15:46:06.619929  =


    2023-04-20T15:46:06.721824  / # . /lava-10064672/environment/lava-10064=
672/bin/lava-test-runner /lava-10064672/1

    2023-04-20T15:46:06.722996  =


    2023-04-20T15:46:06.728465  / # /lava-10064672/bin/lava-test-runner /la=
va-10064672/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/644159f996eff64f69748122

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config=
+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromiumos-x86_64.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-hp-=
x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromiumos-x86_64.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-hp-=
x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644159f996eff64f69748127
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:27:40.755477  <8>[    6.595365] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064085_1.4.2.3.1>

    2023-04-20T15:27:40.860339  / # #

    2023-04-20T15:27:40.961386  export SHELL=3D/bin/sh

    2023-04-20T15:27:40.961574  #

    2023-04-20T15:27:41.062523  / # export SHELL=3D/bin/sh. /lava-10064085/=
environment

    2023-04-20T15:27:41.062731  =


    2023-04-20T15:27:41.163706  / # . /lava-10064085/environment/lava-10064=
085/bin/lava-test-runner /lava-10064085/1

    2023-04-20T15:27:41.164027  =


    2023-04-20T15:27:41.169207  / # /lava-10064085/bin/lava-test-runner /la=
va-10064085/1

    2023-04-20T15:27:41.252289  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644156af45c68c3ca7748103

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x=
360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x=
360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644156af45c68c3ca7748108
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:13:30.344939  <8>[   11.711091] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10063613_1.4.2.3.1>

    2023-04-20T15:13:30.450103  / # #

    2023-04-20T15:13:30.551194  export SHELL=3D/bin/sh

    2023-04-20T15:13:30.551477  #

    2023-04-20T15:13:30.652422  / # export SHELL=3D/bin/sh. /lava-10063613/=
environment

    2023-04-20T15:13:30.652659  =


    2023-04-20T15:13:30.753657  / # . /lava-10063613/environment/lava-10063=
613/bin/lava-test-runner /lava-10063613/1

    2023-04-20T15:13:30.753951  =


    2023-04-20T15:13:30.758371  / # /lava-10063613/bin/lava-test-runner /la=
va-10063613/1

    2023-04-20T15:13:30.772500  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415c3ca2c97cd8b3748112

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-amd-stoneyridge.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64415c3ca2c97cd8b3748=
113
        failing since 86 days (last pass: v5.15.89, first fail: v5.15.90) =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415e462d287cfc80748102

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromeos-intel-denverton.flavour=
.config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-intel-denverton.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromeos-intel-denverton.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415e462d287cfc80748107
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:45:56.951563  + <8>[    7.831277] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10064705_1.4.2.3.1>

    2023-04-20T15:45:56.952215  set +x

    2023-04-20T15:45:57.061424  / # #

    2023-04-20T15:45:57.164436  export SHELL=3D/bin/sh

    2023-04-20T15:45:57.165280  <3>[    7.851552] usb 1-1.4: device not acc=
epting address 10, error -71

    2023-04-20T15:45:57.165786  #<6>[    7.922069] usb 1-1.4: new full-spee=
d USB device number 11 using xhci_hcd

    2023-04-20T15:45:57.166156  <4>[    7.929260] usb 1-1.4: Device not res=
ponding to setup address.

    2023-04-20T15:45:57.166661  =


    2023-04-20T15:45:57.268303  / # export SHELL=3D/bin/sh. /lava-10064705/=
environment

    2023-04-20T15:45:57.268591  =

 =

    ... (18 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/644159e19dcd85975f748163

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config=
+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromiumos-x86_64.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-len=
ovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/cros---chromeos-5.15-x86_64-chromiumos-x86_64.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-len=
ovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644159e19dcd85975f748168
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:27:19.241549  + set +x

    2023-04-20T15:27:19.244576  <8>[    7.167401] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064090_1.4.2.3.1>

    2023-04-20T15:27:19.349719  / # #

    2023-04-20T15:27:19.450832  export SHELL=3D/bin/sh

    2023-04-20T15:27:19.451051  #

    2023-04-20T15:27:19.551985  / # export SHELL=3D/bin/sh. /lava-10064090/=
environment

    2023-04-20T15:27:19.552194  =


    2023-04-20T15:27:19.653062  / # . /lava-10064090/environment/lava-10064=
090/bin/lava-test-runner /lava-10064090/1

    2023-04-20T15:27:19.653430  =


    2023-04-20T15:27:19.658464  / # /lava-10064090/bin/lava-test-runner /la=
va-10064090/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644156ac37583113d0748132

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-leno=
vo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.108/=
x86_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-leno=
vo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644156ac37583113d0748137
        failing since 15 days (last pass: v5.15.105, first fail: v5.15.106)

    2023-04-20T15:13:33.658268  + <8>[   11.735449] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10063624_1.4.2.3.1>

    2023-04-20T15:13:33.658834  set +x

    2023-04-20T15:13:33.768021  / # #

    2023-04-20T15:13:33.870738  export SHELL=3D/bin/sh

    2023-04-20T15:13:33.871594  #

    2023-04-20T15:13:33.973551  / # export SHELL=3D/bin/sh. /lava-10063624/=
environment

    2023-04-20T15:13:33.974217  =


    2023-04-20T15:13:34.076093  / # . /lava-10063624/environment/lava-10063=
624/bin/lava-test-runner /lava-10063624/1

    2023-04-20T15:13:34.077246  =


    2023-04-20T15:13:34.081713  / # /lava-10063624/bin/lava-test-runner /la=
va-10063624/1
 =

    ... (12 line(s) more)  =

 =20
