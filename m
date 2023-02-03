Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590D66890BB
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 08:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBCHZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 02:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjBCHZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 02:25:07 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6221F8B7E8
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 23:25:06 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z3so2953863pfb.2
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 23:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3/oqknfb6n+IjaczPSOTEur4HILMOzqlr/quEA/E0ps=;
        b=RorJzzysBzq2B2Yt0gJLpvDLsBcYUuM1Gm1k4OVRVZlSnswyDvSOybDW0H72pKJJYe
         ivfsdsBlziAmEzVJ7fl+8A6sTvPMbQevHM7UmSFCcvCMTTeRoXX+Mo+1/sKUPi5TyXsx
         IUqo+2P220wZLB1mLqAsIkbz0KCVJLAjYMYg673ZiHsiY6t5dumb3ysKoYIbNWu7Yt/B
         aChGmvQfj9GoFsAvWB2xl9nRWZ07l1HAUEp3Df6qg/diMcpZlFLJCxg17HIl+DrCjE70
         xVgZzEMYSXazMeoSJkpQsmk/LGFssPJyNv2IIC5v5qx2Lv5Gx1KeJPY+PYgaIQubheeC
         jmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3/oqknfb6n+IjaczPSOTEur4HILMOzqlr/quEA/E0ps=;
        b=THJJ1hA4TL/9FbeCvDD/hcV3iCTitjEOKskDtc3G2PHeaLjHfKPm9ZcfNn/MN6jNkV
         wFlARtpa5yKH/dz8PtjuNMuwUB4v3mag1n3o0cCVKtVffxhhwqtq+lkwCpovbw1HOnYc
         St+/JEnDg3fAEO6mK3NWKKGwaIkVIYFZdRGgxDHtXY1/5o7B4u4xujvyLhAMmX4al1+H
         JuB4m1KGO7pVDq7z2P5aEAMW3jmGovgZZqaqzIlfOchLIEHoi+YR6KrcOn8PpdLBtbpI
         ZAa5M6EKceuQr8fPmpyS6VndcLL+vdWuRjjEY0WXI9+ARep+zlI5L0ke4AD4/zbCzOZU
         nn1g==
X-Gm-Message-State: AO0yUKXCy76FsXhza3qTpG5ldj3auAMGH4GFy7h2doX+ryd5sw8TWTb5
        7yoOGqNcdWiq0sMmEDSMc/PFJzFTxkkDnliXoh8=
X-Google-Smtp-Source: AK7set/NB32WtyRWykK6oOe9H2JiUgUMVwVQK7PNKSH+EPxucw8oveUF0pF3lti076gQ+k+9EQ/+iA==
X-Received: by 2002:aa7:82cb:0:b0:594:335f:928a with SMTP id f11-20020aa782cb000000b00594335f928amr3690266pfn.7.1675409105581;
        Thu, 02 Feb 2023 23:25:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k131-20020a628489000000b0058dbd7a5e0esm932729pfd.89.2023.02.02.23.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 23:25:05 -0800 (PST)
Message-ID: <63dcb6d1.620a0220.a9d58.1d7e@mx.google.com>
Date:   Thu, 02 Feb 2023 23:25:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.91-12-g3290f78df1ab
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 118 runs,
 3 regressions (v5.15.91-12-g3290f78df1ab)
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

stable-rc/queue/5.15 baseline: 118 runs, 3 regressions (v5.15.91-12-g3290f7=
8df1ab)

Regressions Summary
-------------------

platform        | arch | lab             | compiler | defconfig          | =
regressions
----------------+------+-----------------+----------+--------------------+-=
-----------
cubietruck      | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | =
1          =

imx53-qsrb      | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | =
1          =

stm32mp157c-dk2 | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.91-12-g3290f78df1ab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.91-12-g3290f78df1ab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3290f78df1ab39a84577b1c25ba31a00ee45568f =



Test Regressions
---------------- =



platform        | arch | lab             | compiler | defconfig          | =
regressions
----------------+------+-----------------+----------+--------------------+-=
-----------
cubietruck      | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/63dc8405ff8275a554915ebf

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
12-g3290f78df1ab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
12-g3290f78df1ab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dc8405ff8275a554915ec4
        failing since 16 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T03:48:02.541359  <8>[   10.096696] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3279378_1.5.2.4.1>
    2023-02-03T03:48:02.651516  / # #
    2023-02-03T03:48:02.754923  export SHELL=3D/bin/sh
    2023-02-03T03:48:02.755807  #<3>[   10.193846] Bluetooth: hci0: command=
 0xfc18 tx timeout
    2023-02-03T03:48:02.756251  =

    2023-02-03T03:48:02.858068  / # export SHELL=3D/bin/sh. /lava-3279378/e=
nvironment
    2023-02-03T03:48:02.860233  =

    2023-02-03T03:48:02.962525  / # . /lava-3279378/environment/lava-327937=
8/bin/lava-test-runner /lava-3279378/1
    2023-02-03T03:48:02.963251  =

    2023-02-03T03:48:02.967457  / # /lava-3279378/bin/lava-test-runner /lav=
a-3279378/1 =

    ... (12 line(s) more)  =

 =



platform        | arch | lab             | compiler | defconfig          | =
regressions
----------------+------+-----------------+----------+--------------------+-=
-----------
imx53-qsrb      | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/63dc83d543aba456e7915ec9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
12-g3290f78df1ab/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
12-g3290f78df1ab/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dc83d543aba456e7915ece
        failing since 6 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-02-03T03:47:09.723894  + set +x
    2023-02-03T03:47:09.724087  [    9.358308] <LAVA_SIGNAL_ENDRUN 0_dmesg =
896843_1.5.2.3.1>
    2023-02-03T03:47:09.831029  / # #
    2023-02-03T03:47:09.932690  export SHELL=3D/bin/sh
    2023-02-03T03:47:09.933138  #
    2023-02-03T03:47:10.034342  / # export SHELL=3D/bin/sh. /lava-896843/en=
vironment
    2023-02-03T03:47:10.034932  =

    2023-02-03T03:47:10.136322  / # . /lava-896843/environment/lava-896843/=
bin/lava-test-runner /lava-896843/1
    2023-02-03T03:47:10.137194  =

    2023-02-03T03:47:10.139249  / # /lava-896843/bin/lava-test-runner /lava=
-896843/1 =

    ... (12 line(s) more)  =

 =



platform        | arch | lab             | compiler | defconfig          | =
regressions
----------------+------+-----------------+----------+--------------------+-=
-----------
stm32mp157c-dk2 | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/63dc83d143aba456e7915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
12-g3290f78df1ab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
12-g3290f78df1ab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dc83d143aba456e7915ebe
        failing since 1 day (last pass: v5.15.72-36-g3886958cda706, first f=
ail: v5.15.90-215-gdf99871482a0)

    2023-02-03T03:47:20.205826  <8>[   11.507530] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3279417_1.5.2.4.1>
    2023-02-03T03:47:20.311853  / # #
    2023-02-03T03:47:20.414603  export SHELL=3D/bin/sh
    2023-02-03T03:47:20.415223  #
    2023-02-03T03:47:20.516866  / # export SHELL=3D/bin/sh. /lava-3279417/e=
nvironment
    2023-02-03T03:47:20.517619  =

    2023-02-03T03:47:20.619109  / # . /lava-3279417/environment/lava-327941=
7/bin/lava-test-runner /lava-3279417/1
    2023-02-03T03:47:20.620405  =

    2023-02-03T03:47:20.623890  / # /lava-3279417/bin/lava-test-runner /lav=
a-3279417/1
    2023-02-03T03:47:20.691819  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
