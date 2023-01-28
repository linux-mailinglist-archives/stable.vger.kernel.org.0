Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0D567FA2E
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 19:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjA1SWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 13:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjA1SWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 13:22:51 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0CE270C
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 10:22:50 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id be8so7911393plb.7
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 10:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s+fbExP11WYIgKTkuoMDPVY6xW7ZW89RupyCLNpAKh0=;
        b=Qaa4zPcwjLqzAxiA2KuEAenwKZs/ecp88DDhhY56N5aD3eJCgMuit1fopAMRd6jEu9
         bOX14B2JsCTF+5OwXj3C6SPTT7r+b3hRckKnqvMK1f9rdU9/oRDtyBBORowK00Dftbpp
         OTETTL5OTNemghBo6Om5IIHaMXJ5tIzplclR1WICwp6xIyts+aiQIv6hv1HeMkvmfvqA
         JZp+BPX7sov2FpVb30gbj6//UrpeBVvLxm6AE6/HQ5HekJ4HV/iyqzrVwSh5RURTeMav
         GiODXfKnPHVEsPoREO5rodFYQ2Ife68SebNLWVxj6nKzBVB02cnjS16TLjqo1R6UIXRo
         bBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s+fbExP11WYIgKTkuoMDPVY6xW7ZW89RupyCLNpAKh0=;
        b=Xc3fA/LUn2rLxFdQZs8XaV3sn77BnkiVCXFXds00dQj19gyffYmhnTBK9Z6liVOVlZ
         hfOIDCFm/DEmrsTzyHgh1lbkA6M4r0DvCP8T3oxZdXhsBPoLMNvYfqRgSoLo85GGdAeA
         SM64bQMduGZHjZkm/yfJwnm/UEb2ZDAM1T6ioELolsBfmzuHBneDZAFy3U7gokL8BgUv
         UQeCY1ijioz8mY983U21ih5xMrEYTcN1YJY3gpVM+hy5T55zsQmjo91o2v+VCUcFmhoC
         6KWUP56NJrHygAt2T8K9zMHIv1UMDu1uZjUBEIaHcBdOvKlcX4SmQRSDhCjXKr5tn2pZ
         CI/g==
X-Gm-Message-State: AO0yUKXXFoudCMpVfoS1knmw89Eq6vX72+w4mIzn/dkqv8XWL3LB2sEs
        2A6l0ohlvbDh2u8GxVG9d5VhFqhnkmw99GTA5Ik=
X-Google-Smtp-Source: AK7set9tqXI6N/LnxgUTuXGtHw5jWIBlPxE9C/YpUifmVC5L6MPYmYGJMfxGPKQt3hFHp41Cd2mxAg==
X-Received: by 2002:a17:90b:1a8a:b0:22b:b3df:d970 with SMTP id ng10-20020a17090b1a8a00b0022bb3dfd970mr3526077pjb.44.1674930169633;
        Sat, 28 Jan 2023 10:22:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r2-20020a17090a454200b0022bfa25dd88sm6869941pjm.40.2023.01.28.10.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 10:22:49 -0800 (PST)
Message-ID: <63d567f9.170a0220.47859.b321@mx.google.com>
Date:   Sat, 28 Jan 2023 10:22:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-153-ga6022d594e27
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 170 runs,
 4 regressions (v5.15.90-153-ga6022d594e27)
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

stable-rc/queue/5.15 baseline: 170 runs, 4 regressions (v5.15.90-153-ga6022=
d594e27)

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
nel/v5.15.90-153-ga6022d594e27/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-153-ga6022d594e27
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6022d594e27b03d65fc145b4388635ae0cbfb3f =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5359f01517d6ae0915ee9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-ga6022d594e27/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-ga6022d594e27/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d5359f01517d6ae0915eee
        failing since 11 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T14:47:40.781147  + set +x<8>[    9.978135] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3236078_1.5.2.4.1>
    2023-01-28T14:47:40.781950  =

    2023-01-28T14:47:40.891701  / # #
    2023-01-28T14:47:40.995090  export SHELL=3D/bin/sh
    2023-01-28T14:47:40.995474  #
    2023-01-28T14:47:40.995639  / # export SHELL=3D/bin/sh<3>[   10.193926]=
 Bluetooth: hci0: command 0xfc18 tx timeout
    2023-01-28T14:47:41.096814  . /lava-3236078/environment
    2023-01-28T14:47:41.097195  =

    2023-01-28T14:47:41.198745  / # . /lava-3236078/environment/lava-323607=
8/bin/lava-test-runner /lava-3236078/1
    2023-01-28T14:47:41.200232   =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5357596d7cf00fa915edc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-ga6022d594e27/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-ga6022d594e27/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d5357596d7cf00fa915ee1
        failing since 1 day (last pass: v5.15.81-121-gcb14018a85f6, first f=
ail: v5.15.90-146-gbf7101723cc0)

    2023-01-28T14:47:11.688884  + set +x
    2023-01-28T14:47:11.689056  [    9.319406] <LAVA_SIGNAL_ENDRUN 0_dmesg =
890641_1.5.2.3.1>
    2023-01-28T14:47:11.795679  / # #
    2023-01-28T14:47:11.897144  export SHELL=3D/bin/sh
    2023-01-28T14:47:11.897552  #
    2023-01-28T14:47:11.998789  / # export SHELL=3D/bin/sh. /lava-890641/en=
vironment
    2023-01-28T14:47:11.999187  =

    2023-01-28T14:47:12.100398  / # . /lava-890641/environment/lava-890641/=
bin/lava-test-runner /lava-890641/1
    2023-01-28T14:47:12.101039  =

    2023-01-28T14:47:12.103313  / # /lava-890641/bin/lava-test-runner /lava=
-890641/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5555c18be345132915ec2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-ga6022d594e27/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-ga6022d594e27/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d5555c18be345132915ec7
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T17:03:12.848339  + set +x
    2023-01-28T17:03:12.853076  <8>[   16.108788] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3236117_1.5.2.4.1>
    2023-01-28T17:03:12.973116  / # #
    2023-01-28T17:03:13.078693  export SHELL=3D/bin/sh
    2023-01-28T17:03:13.080253  #
    2023-01-28T17:03:13.183556  / # export SHELL=3D/bin/sh. /lava-3236117/e=
nvironment
    2023-01-28T17:03:13.185060  =

    2023-01-28T17:03:13.288668  / # . /lava-3236117/environment/lava-323611=
7/bin/lava-test-runner /lava-3236117/1
    2023-01-28T17:03:13.294059  =

    2023-01-28T17:03:13.296634  / # /lava-3236117/bin/lava-test-runner /lav=
a-3236117/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5377ea239470577915ec4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-ga6022d594e27/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-ga6022d594e27/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d5377ea239470577915ec9
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T14:55:34.508838  <8>[   16.028660] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 201533_1.5.2.4.1>
    2023-01-28T14:55:34.620020  / # #
    2023-01-28T14:55:34.723009  export SHELL=3D/bin/sh
    2023-01-28T14:55:34.723458  #
    2023-01-28T14:55:34.825169  / # export SHELL=3D/bin/sh. /lava-201533/en=
vironment
    2023-01-28T14:55:34.827187  =

    2023-01-28T14:55:34.929614  / # . /lava-201533/environment/lava-201533/=
bin/lava-test-runner /lava-201533/1
    2023-01-28T14:55:34.930412  =

    2023-01-28T14:55:34.934293  / # /lava-201533/bin/lava-test-runner /lava=
-201533/1
    2023-01-28T14:55:34.979891  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
