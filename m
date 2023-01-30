Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1F6681598
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 16:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbjA3Pwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 10:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbjA3Pwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 10:52:34 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170144231
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 07:52:31 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id mi9so2309968pjb.4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 07:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=N0MOYbYZhxKnO5nggYacqin1S4LCTaCLcwRHoyQsB8w=;
        b=VEfm6dNM2RLc8+Fu+oPk1Qz6uRoQ/Ed56tFHT60x9vwZ6+0xB2OXLkLmRPA8vHzoZD
         HnKM2bwaFx2HiuPIciZS2lFaz9iEnmF9W6MQcuw9ydyEg7kuGxpIv//69nTrk7YHHj75
         fquvDtBuBKKEii840syYesjAoLzbKFzJjmU0F1b+DEX49VprTnMFpbfRuTNBlKbfUG3Z
         iBMGqmmjjJ/svh3R0Bhw0hCh15UtkzvRSvYfg8SM8WPKGx/IyN5IfEtkopSMqvP9X+XP
         GErs2bBGdXAU+ffAUmqcLY/WjKY1SMdc+u6dyuNw3/SkFf44orqa+u3EZuJRT+18Fu6m
         9h7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N0MOYbYZhxKnO5nggYacqin1S4LCTaCLcwRHoyQsB8w=;
        b=CygVGCrRAnOHFlmtqlMgVilftA9fJlOzQc81eORlWTSd3MV2u6HE5+zkpreGhAV5DW
         nTEF414CQNMZqHhcb6oLI23MZ02vsakUd9nZm6CvFVKDLJXhROUlny6RDXY8ArZRMQaz
         C7ym7CxfTSVTImMexUtGgkCR25NvdD6viCr2MxymyWXc9kx1fA2nvTJIsxvYHhZLJ7Gy
         5JrSmAQisDh20ARD1OSbu5Dy7WUvAidsWv6NkubQToe4+11DfseLLtPOs3+Oce/lKgAk
         DDm3PgvTQGYbRURhaEuxJyJrphZXfzFVXSB/oaABQ86NHUT5665XqMG1vMqhgqN9obZ5
         sBVQ==
X-Gm-Message-State: AO0yUKWE8QX53TYg4dEM0uEhBgIoZTwzAtTRitF8dBzuYgnxwGmGDXNZ
        ezJFn2XV22b8fYuqwXf/1kCxYnRVeBTpXTW/Mjde7A==
X-Google-Smtp-Source: AK7set8IWFWzyjtJh9SbRJI4XVEGNYLQzSLQv7hGqDmu+7ffhlIh6TbpMvMDTHKnQwEFXpF0a66uQg==
X-Received: by 2002:a17:902:d484:b0:196:8bd6:2396 with SMTP id c4-20020a170902d48400b001968bd62396mr3275033plg.30.1675093950276;
        Mon, 30 Jan 2023 07:52:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c14d00b00194706d3f25sm8008212plj.144.2023.01.30.07.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 07:52:29 -0800 (PST)
Message-ID: <63d7e7bd.170a0220.2ba97.d934@mx.google.com>
Date:   Mon, 30 Jan 2023 07:52:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-201-g031728bce11d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 163 runs,
 4 regressions (v5.15.90-201-g031728bce11d)
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

stable-rc/queue/5.15 baseline: 163 runs, 4 regressions (v5.15.90-201-g03172=
8bce11d)

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
nel/v5.15.90-201-g031728bce11d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-201-g031728bce11d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      031728bce11debea2a6b9df80e11ecd9b1da9fcf =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7b9a527b7c263b1915ec2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
201-g031728bce11d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
201-g031728bce11d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7b9a527b7c263b1915ec7
        failing since 13 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T12:35:32.458213  + set +x<8>[    9.974921] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3246691_1.5.2.4.1>
    2023-01-30T12:35:32.458869  =

    2023-01-30T12:35:32.567467  / # #
    2023-01-30T12:35:32.671065  export SHELL=3D/bin/sh
    2023-01-30T12:35:32.672121  #
    2023-01-30T12:35:32.672717  / # <3>[   10.113678] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-01-30T12:35:32.774880  export SHELL=3D/bin/sh. /lava-3246691/envir=
onment
    2023-01-30T12:35:32.775809  =

    2023-01-30T12:35:32.877872  / # . /lava-3246691/environment/lava-324669=
1/bin/lava-test-runner /lava-3246691/1
    2023-01-30T12:35:32.879337   =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7b72656372ad1ad915ee8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
201-g031728bce11d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
201-g031728bce11d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7b72656372ad1ad915eed
        failing since 3 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-01-30T12:24:45.413016  [    9.362692] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-01-30T12:24:45.420437  + set +x
    2023-01-30T12:24:45.420601  [    9.373453] <LAVA_SIGNAL_ENDRUN 0_dmesg =
891961_1.5.2.3.1>
    2023-01-30T12:24:45.527861  / # #
    2023-01-30T12:24:45.631870  export SHELL=3D/bin/sh
    2023-01-30T12:24:45.634638  #
    2023-01-30T12:24:45.741306  / # export SHELL=3D/bin/sh. /lava-891961/en=
vironment
    2023-01-30T12:24:45.741852  =

    2023-01-30T12:24:45.843070  / # . /lava-891961/environment/lava-891961/=
bin/lava-test-runner /lava-891961/1
    2023-01-30T12:24:45.843773   =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7c439bb86a30287915ee8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
201-g031728bce11d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
201-g031728bce11d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7c439bb86a30287915eed
        failing since 12 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T13:20:47.129051  + set +x
    2023-01-30T13:20:47.133218  <8>[   16.153842] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3246482_1.5.2.4.1>
    2023-01-30T13:20:47.253353  / # #
    2023-01-30T13:20:47.358964  export SHELL=3D/bin/sh
    2023-01-30T13:20:47.360485  #
    2023-01-30T13:20:47.463836  / # export SHELL=3D/bin/sh. /lava-3246482/e=
nvironment
    2023-01-30T13:20:47.465346  =

    2023-01-30T13:20:47.568797  / # . /lava-3246482/environment/lava-324648=
2/bin/lava-test-runner /lava-3246482/1
    2023-01-30T13:20:47.571529  =

    2023-01-30T13:20:47.574786  / # /lava-3246482/bin/lava-test-runner /lav=
a-3246482/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7b353ccaf29fe35915ec3

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
201-g031728bce11d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
201-g031728bce11d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7b353ccaf29fe35915ec8
        failing since 12 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T12:08:44.079856  + set +x
    2023-01-30T12:08:44.083249  <8>[   16.025768] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 212490_1.5.2.4.1>
    2023-01-30T12:08:44.192903  / # #
    2023-01-30T12:08:44.294537  export SHELL=3D/bin/sh
    2023-01-30T12:08:44.294976  #
    2023-01-30T12:08:44.396363  / # export SHELL=3D/bin/sh. /lava-212490/en=
vironment
    2023-01-30T12:08:44.396786  =

    2023-01-30T12:08:44.498155  / # . /lava-212490/environment/lava-212490/=
bin/lava-test-runner /lava-212490/1
    2023-01-30T12:08:44.498745  =

    2023-01-30T12:08:44.502072  / # /lava-212490/bin/lava-test-runner /lava=
-212490/1 =

    ... (12 line(s) more)  =

 =20
