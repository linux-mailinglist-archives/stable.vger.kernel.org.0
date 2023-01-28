Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A8167F67D
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 09:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbjA1I6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 03:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjA1I63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 03:58:29 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCE227D7A
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 00:58:24 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id j5so6789535pjn.5
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 00:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5UscZgEz9VclAmIZfjPTP6g+th25pP07d+XpEF4wk1s=;
        b=myjgCBvzfSR5vm6WqAG2G9GYfG+ytyXruOcW8nxZv/H0M4bhyT8ZErPV4q4PdSS85i
         1F09m71RKqM8/zU2+0hPFog1XAPjkqhqKjFT2nwqIaaBVDVehdAZiLnClcsSkvQ5SgDm
         FJCls5SpN8y4DtFS0XWthA97Pvm73tQpW7CKaDWOLqPybmZuiSwdF6qH7MySEpQOYGj9
         2sIdydj9nwIbhQ4epuAI8yjuWrAbfvMAPujfW9ZRjsL4k3Ev4eIfhnqvFsg96TBJLNtP
         Wba9Yvq2h8sInwj7JSw3Sgg/ZIFIWoynSfJVeuKzLw/1kKLtDeD+4/8dzoBzUitGvNcw
         Ow6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5UscZgEz9VclAmIZfjPTP6g+th25pP07d+XpEF4wk1s=;
        b=j6LO+ye0SljsPRL1q5IkhFV1plUFwYSxXFly8T0AnRWKBfdYQ1q8LUJ/CbjNdsxDKP
         te0Y3IdfgysYmTNXnXVhQt/i1rwyeAwp0aZQLs2j5ljpgTUsvfM2vCqEFE6EQ/maqSZp
         5G3fuwxyo+WpxSwROlm6zKIwUStFV996dlut4h+qzyNcpuHpGDSh4a0ns/O2XmEa743V
         hE3CIBBfLeiiKy+5EQK4DROYX0XUVOmHwrKcSU+MYAa94fczZXWPuNVquiCeZ0p/Hy0y
         y8pOplwBbfZU9H3/bFYCC/f//twpzkfWRpuKjwnGDq2hF8/fy24Du4iktcHu3LklrTeM
         DKrQ==
X-Gm-Message-State: AFqh2koSK9ZAD0fiLlrvg1kZ/7Yow8EkjutgXtL9Y8s9K5/yxEjoJ1zd
        Ak1v/QCVGwU8N+YMAYhCTue+inKBV8zYfxRBPWxv7w==
X-Google-Smtp-Source: AMrXdXu0fcOHqAOxvXegwxrdwjDUK2paS5OUjAmrdy54urfU+mR25Zo710QlawPJKUaNU2rkXmzaUg==
X-Received: by 2002:a17:902:e88c:b0:194:dda8:397d with SMTP id w12-20020a170902e88c00b00194dda8397dmr39897077plg.20.1674896303596;
        Sat, 28 Jan 2023 00:58:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bh1-20020a170902a98100b001960e5dcb8esm4103388plb.29.2023.01.28.00.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 00:58:23 -0800 (PST)
Message-ID: <63d4e3af.170a0220.85ba4.6dc7@mx.google.com>
Date:   Sat, 28 Jan 2023 00:58:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-148-gb8b87db6183d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 4 regressions (v5.15.90-148-gb8b87db6183d)
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

stable-rc/queue/5.15 baseline: 174 runs, 4 regressions (v5.15.90-148-gb8b87=
db6183d)

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

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-148-gb8b87db6183d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-148-gb8b87db6183d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8b87db6183d299a0b541d6d61c87e11d4f5c525 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4b15acb43bf411b915f53

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
148-gb8b87db6183d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
148-gb8b87db6183d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d4b15acb43bf411b915f58
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T05:23:26.884283  <8>[    9.968075] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3231554_1.5.2.4.1>
    2023-01-28T05:23:26.995228  / # #
    2023-01-28T05:23:27.099283  export SHELL=3D/bin/sh
    2023-01-28T05:23:27.100388  #
    2023-01-28T05:23:27.202926  / # export SHELL=3D/bin/sh. /lava-3231554/e=
nvironment
    2023-01-28T05:23:27.204054  =

    2023-01-28T05:23:27.306532  / # . /lava-3231554/environment/lava-323155=
4/bin/lava-test-runner /lava-3231554/1
    2023-01-28T05:23:27.308293  =

    2023-01-28T05:23:27.308744  / # <3>[   10.353301] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-01-28T05:23:27.313571  /lava-3231554/bin/lava-test-runner /lava-32=
31554/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4b17f2dd93d5e6e915f06

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
148-gb8b87db6183d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
148-gb8b87db6183d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d4b17f2dd93d5e6e915f0b
        failing since 0 day (last pass: v5.15.81-121-gcb14018a85f6, first f=
ail: v5.15.90-146-gbf7101723cc0)

    2023-01-28T05:23:49.837274  [    9.358717] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-01-28T05:23:49.844950  + set +x
    2023-01-28T05:23:49.845125  [    9.369761] <LAVA_SIGNAL_ENDRUN 0_dmesg =
890172_1.5.2.3.1>
    2023-01-28T05:23:49.951753  / # #
    2023-01-28T05:23:50.053424  export SHELL=3D/bin/sh
    2023-01-28T05:23:50.054109  #
    2023-01-28T05:23:50.155415  / # export SHELL=3D/bin/sh. /lava-890172/en=
vironment
    2023-01-28T05:23:50.155997  =

    2023-01-28T05:23:50.259897  / # . /lava-890172/environment/lava-890172/=
bin/lava-test-runner /lava-890172/1
    2023-01-28T05:23:50.260668   =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4b1a774e9591126915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
148-gb8b87db6183d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
148-gb8b87db6183d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d4b1a774e9591126915ebe
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T05:24:35.627348  + set +x
    2023-01-28T05:24:35.631494  <8>[   16.125815] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3231524_1.5.2.4.1>
    2023-01-28T05:24:35.751423  / # #
    2023-01-28T05:24:35.857002  export SHELL=3D/bin/sh
    2023-01-28T05:24:35.858531  #
    2023-01-28T05:24:35.961980  / # export SHELL=3D/bin/sh. /lava-3231524/e=
nvironment
    2023-01-28T05:24:35.963546  =

    2023-01-28T05:24:36.067240  / # . /lava-3231524/environment/lava-323152=
4/bin/lava-test-runner /lava-3231524/1
    2023-01-28T05:24:36.072643  =

    2023-01-28T05:24:36.075191  / # /lava-3231524/bin/lava-test-runner /lav=
a-3231524/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4b0bbb8203fe9f8915f03

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
148-gb8b87db6183d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
148-gb8b87db6183d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d4b0bbb8203fe9f8915f08
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T05:20:47.826857  + set +x
    2023-01-28T05:20:47.830903  <8>[   16.018356] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 197305_1.5.2.4.1>
    2023-01-28T05:20:47.942681  / # #
    2023-01-28T05:20:48.045244  export SHELL=3D/bin/sh
    2023-01-28T05:20:48.045758  #
    2023-01-28T05:20:48.147244  / # export SHELL=3D/bin/sh. /lava-197305/en=
vironment
    2023-01-28T05:20:48.147761  =

    2023-01-28T05:20:48.249234  / # . /lava-197305/environment/lava-197305/=
bin/lava-test-runner /lava-197305/1
    2023-01-28T05:20:48.250115  =

    2023-01-28T05:20:48.254706  / # /lava-197305/bin/lava-test-runner /lava=
-197305/1 =

    ... (12 line(s) more)  =

 =20
