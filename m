Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7701B6944E2
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjBMLxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjBMLxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:53:19 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E928C12F19
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:53:17 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id r8so13264386pls.2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1a3Wybd5V+6DTBeuX8C1jGZveIp+KxHY25tI9oYnB6k=;
        b=4r16N/18gqHuqVjNrU891oOhWo4PPYPzXMQmTjE/cAl11oCIYq5H9yJzAitli2DFiT
         TtwyRVMDKvO/X/ZdXNXwhaDMYfqgIQIB7F+a1nX56EYzRhtyXDmfU1mrmTty/mX0mkBD
         3RSLdg9XGs3+y+CDLbFqlA1lh/eQt16bJxCZQFVeaiNDnPTHej3a4rk7N+V+eEcRIspa
         pML7XSM8TR/KQPutjo0S8GqFvYyBRNPs75SdYf8F/dtEMBArBs4xWd9/emZUsYZvIySA
         Bru+HGMh0/Y+Sq5ZX0/FLnvC7JJQqBPjqvQ8yaMF3j9Hn4QhngL1lzcCaA9KgXqOurhX
         k56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1a3Wybd5V+6DTBeuX8C1jGZveIp+KxHY25tI9oYnB6k=;
        b=rVn9mxNCmVDxZ4IJIkROudcl66P8KmwKmEEWuMD0GpVDoS2tdyvS/ZpysR+oZcIN7x
         R6F5CdAhDhhVyeumSjETBP64CIxhekt0z+zfjTGg+sUcUjUVYQsRHZR3VJ8Peg/s784X
         AO6ncABC8vSF8JTRm3Pta3YkFzD/o/AyMoIcnV6VIWz8aiFRDLThqnDlsEVSAMCWMVN6
         1RuEGO739YqNH6RsnirnXwqyDtXHfXX802fkibGU6iHuL1DhGgDaY+VMEDvjPEWZsLPk
         mKq1YRn7+qeTdMJWVrtSc5Vz8bZiiElrjTjxmCPLtND3Ry+9jIdlPd8d3FLnHpzzJSYX
         Wi3g==
X-Gm-Message-State: AO0yUKWIdEk2O0D44x7DQE8SX1Gt2gPPr1zlfjOD8sfhTEK86SAsj2PN
        q4hLnRHGhAtIxfdghtTozWRyG8eYKgby35IfWH4=
X-Google-Smtp-Source: AK7set9IRxbqthnwuP+ss/eLaYCUmmmafLLVUTFX3r0dk4biOkXj+uZlIbq1pqEktAPj6bkh9veyBg==
X-Received: by 2002:a17:902:e40d:b0:19a:a2f3:e41c with SMTP id m13-20020a170902e40d00b0019aa2f3e41cmr1975482ple.35.1676289197187;
        Mon, 13 Feb 2023 03:53:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o7-20020a1709026b0700b00196519d8647sm8055854plk.4.2023.02.13.03.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 03:53:16 -0800 (PST)
Message-ID: <63ea24ac.170a0220.39ae1.e02b@mx.google.com>
Date:   Mon, 13 Feb 2023 03:53:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93-48-g91b0616b8246
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 3 regressions (v5.15.93-48-g91b0616b8246)
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

stable-rc/queue/5.15 baseline: 172 runs, 3 regressions (v5.15.93-48-g91b061=
6b8246)

Regressions Summary
-------------------

platform      | arch | lab             | compiler | defconfig          | re=
gressions
--------------+------+-----------------+----------+--------------------+---=
---------
at91sam9g20ek | arm  | lab-broonie     | gcc-10   | multi_v5_defconfig | 1 =
         =

cubietruck    | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | 1 =
         =

imx53-qsrb    | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.93-48-g91b0616b8246/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.93-48-g91b0616b8246
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91b0616b824681196c285ea59ecb0426f6c31647 =



Test Regressions
---------------- =



platform      | arch | lab             | compiler | defconfig          | re=
gressions
--------------+------+-----------------+----------+--------------------+---=
---------
at91sam9g20ek | arm  | lab-broonie     | gcc-10   | multi_v5_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63e9f1526982277d608c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
48-g91b0616b8246/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
48-g91b0616b8246/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9f1526982277d608c8=
65a
        new failure (last pass: v5.15.93-43-g62691dabb900) =

 =



platform      | arch | lab             | compiler | defconfig          | re=
gressions
--------------+------+-----------------+----------+--------------------+---=
---------
cubietruck    | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63e9f2e0ba406930fd8c864a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
48-g91b0616b8246/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
48-g91b0616b8246/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e9f2e1ba406930fd8c8653
        failing since 27 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-13T08:20:17.013046  <8>[   10.003964] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3332406_1.5.2.4.1>
    2023-02-13T08:20:17.119856  / # #
    2023-02-13T08:20:17.221527  export SHELL=3D/bin/sh
    2023-02-13T08:20:17.222024  #
    2023-02-13T08:20:17.323313  / # export SHELL=3D/bin/sh. /lava-3332406/e=
nvironment
    2023-02-13T08:20:17.323739  =

    2023-02-13T08:20:17.424977  / # . /lava-3332406/environment/lava-333240=
6/bin/lava-test-runner /lava-3332406/1
    2023-02-13T08:20:17.425696  =

    2023-02-13T08:20:17.430563  / # /lava-3332406/bin/lava-test-runner /lav=
a-3332406/1
    2023-02-13T08:20:17.478287  <3>[   10.433870] Bluetooth: hci0: command =
0xfc18 tx timeout =

    ... (12 line(s) more)  =

 =



platform      | arch | lab             | compiler | defconfig          | re=
gressions
--------------+------+-----------------+----------+--------------------+---=
---------
imx53-qsrb    | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63e9f2ae9ab73ceb1d8c86d0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
48-g91b0616b8246/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
48-g91b0616b8246/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e9f2af9ab73ceb1d8c86d9
        failing since 16 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-13T08:19:35.009012  [    9.349816] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-02-13T08:19:35.016184  + set +x
    2023-02-13T08:19:35.016509  [    9.360748] <LAVA_SIGNAL_ENDRUN 0_dmesg =
904629_1.5.2.3.1>
    2023-02-13T08:19:35.124452  =

    2023-02-13T08:19:35.231919  / # #export SHELL=3D/bin/sh
    2023-02-13T08:19:35.232699  =

    2023-02-13T08:19:35.336750  / # export SHELL=3D/bin/sh. /lava-904629/en=
vironment
    2023-02-13T08:19:35.337247  =

    2023-02-13T08:19:35.438595  / # . /lava-904629/environment/lava-904629/=
bin/lava-test-runner /lava-904629/1
    2023-02-13T08:19:35.439490   =

    ... (12 line(s) more)  =

 =20
