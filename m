Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B7B549B37
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 20:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiFMSNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 14:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244695AbiFMSND (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 14:13:03 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8519297285
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:07:55 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id z17so5843426pff.7
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ubAqpJzPSKONdzCCw39bRbaA8/nwdJ12d1Bcl/O7dWs=;
        b=IMz1drkR5ZbH4iLH6Xgy37sc8Lspliqh9XWO9toQ9sicuU+ck84qQgA99j04sQgwT5
         /RX2SMC2XNjvmr4OfFR3/v9tuDZE1YkInKnN2LrJ9hSWgSUvBkWyg+yBXx/0YlA0LDMI
         y0nDVBZrCEfCMPIsEu4R045lo3curJ/hc1FDaEY1ox6/ZHYhCg9lYrQKDOWxhyiquJI1
         nlbRLJYXBwLDnV+PtUtL60u+3F3HWUy7899OsQnBaIOW8FiWriMMjjlJx2ceDS54jdF6
         0pzcsYLMQCgCMjORVXVDN/+T8sTBlKXrnGEcBomgNZ4kTgum8y17WtE9pkaD+PKT4Zzy
         BBLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ubAqpJzPSKONdzCCw39bRbaA8/nwdJ12d1Bcl/O7dWs=;
        b=tMD9Eqo3Y1JXeFP5RiRE+joIB3lfyCJzG/XO51ARlcepdG7vzEZugVEbEdti+0+q26
         YGBHck8SxOKAcTkL75inGdevV/8/WFiEi+hZJxF1l1NIfv+lD+2YNlwp2L174exbHyjN
         bg3r3NgeV69nN4X7TCj/jCG87lNMwvGFSDOTv0VNYUm1tTv8rCA7sbws7kbByauuDeS4
         xwBBdtNeNg1E5AZ+kDr9JX1bMbf4hOGoEpACwx4wZCwdg3EbkLgFGWMMKxJ5E3i3ffj3
         03yKBWsCWc10MOFOvKMo7CbjiUQ5g8YsYCUm3VPcQpeaeIsDh6kfdSNbocbqyYYoipKp
         PiOw==
X-Gm-Message-State: AOAM532TR+RG1oamcyuTCud5nNIPqqASsIZCgihAxAAfysYQ+q96DUmb
        Ddha50x2PKB6MWjHBmB56VFNkl7Y+MNWz1e1ZA4=
X-Google-Smtp-Source: ABdhPJxhcjnsFi/S3k8+hwpRH7ppU7oc0zpg0Sg/vMOuhZ81wPoqALO93zkFXkhmFaG0U0zRjA/KMA==
X-Received: by 2002:a62:de84:0:b0:51b:e34b:ed2e with SMTP id h126-20020a62de84000000b0051be34bed2emr52669042pfg.86.1655129274830;
        Mon, 13 Jun 2022 07:07:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6-20020a170903110600b001624b1e1a7bsm5148913plh.250.2022.06.13.07.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 07:07:54 -0700 (PDT)
Message-ID: <62a744ba.1c69fb81.3d8c1.6427@mx.google.com>
Date:   Mon, 13 Jun 2022 07:07:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-911-ge74187a013383
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 136 runs,
 4 regressions (v5.15.45-911-ge74187a013383)
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

stable-rc/queue/5.15 baseline: 136 runs, 4 regressions (v5.15.45-911-ge7418=
7a013383)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =

rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =

tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-911-ge74187a013383/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-911-ge74187a013383
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e74187a013383b26f79173808c7965869933b7df =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/62a70dc220137854f9a39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
911-ge74187a013383/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
911-ge74187a013383/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a70dc220137854f9a39=
bd4
        failing since 0 day (last pass: v5.15.45-833-g04983d84c84ee, first =
fail: v5.15.45-880-g694575c32c9b2) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a713ff80340a89d0a39bdd

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
911-ge74187a013383/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
911-ge74187a013383/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62a713ff80340a89d0a39bff
        failing since 97 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-13T10:39:34.482459  /lava-6604926/1/../bin/lava-test-case
    2022-06-13T10:39:34.493778  <8>[   60.846804] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/62a710a34a0418e329a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
911-ge74187a013383/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
911-ge74187a013383/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a710a34a0418e329a39=
bce
        failing since 0 day (last pass: v5.15.45-880-g694575c32c9b2, first =
fail: v5.15.45-882-gf1e18052eb978) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/62a715f8b290673c4ba39bd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
911-ge74187a013383/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
911-ge74187a013383/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a715f8b290673c4ba39=
bd9
        failing since 20 days (last pass: v5.15.40-102-g526a14d366391, firs=
t fail: v5.15.41-132-gede7034a09d1) =

 =20
