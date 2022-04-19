Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9894F507663
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 19:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351319AbiDSRXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 13:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355857AbiDSRW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 13:22:59 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E1F167E6
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:20:15 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id s17so5574893plg.9
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E9br9ufwZgFiXoiMwyIC4M42Fxv7oRyV6pGUI18gBa8=;
        b=tuNPSViWA3OJD0tEzV4dubGj0FO4ZlOXKx7E1w8B3toBvnIw8+f64QKhyCQKWylYFC
         ipvbBi7PBNfDy1MLezXKrWXBWxObq1epGTyE0FpE+/9FfOSf4J+F2Q0RhcZPbtc1ipAa
         3Aihsws0s+8gqq7Zf63Ky+P9PWYecR9AY23y4JoJnuS3PvTcTxcUqjCk+DD0qcJ5kZRE
         F7JSxyAuPHM4p29tTfBTWYCiveqp7Bg+AsKYBvBMrWPHKd1nh0dNrWTYb6vDwRam4crU
         Aa6cdNuROTpKOsUgmLXnLnztGTo/bIC6t68u54ZoeTiue0NHIUCNLsiEPiO19L5QRM8A
         ttaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E9br9ufwZgFiXoiMwyIC4M42Fxv7oRyV6pGUI18gBa8=;
        b=Gxz9bEOldcXticiStS9wR9hVTm7/uNB0lrNN/wvuVUvK3Uum+oVNvLWPNdcWR7q79j
         FdLkDeO65SxX+4jbN8eVwtXCddFuC4BtgXssnh316sGRhRKM37gHG792lcSYkO4lSKZr
         48RWMho0KP6rki7w28kecydRXykGGz9rRempbeNwJidkpifKha8VvPEAyOusCgqMbO9M
         BttUfLLVCcILaB0ck53s2S6MMGv8OSM3KJo4keNLeoFC3YN9Aw4yqlGbFZ2WUhM/l/Mv
         NzOsMYa0Txx8SKs9lUW3Xk5ptna9F4RgYX2sxlaZWPfD2fyzdANuaBa73V29GzypZI8i
         99wg==
X-Gm-Message-State: AOAM533CW4ig1gfdRe6Xc0FXMfCbzv7Ykx0/Ym3vFxHw++5e9r6wE0bE
        zrjl0wZ3daztgd/LM+ds5Q1NTY9j5MPq/22k
X-Google-Smtp-Source: ABdhPJz/3b4pHCNf8rh/j30Y3IG8ZlnObgDld1gRF6Oyny9EES7AV50AhXqpsgrCRLBmvAqFtHVNDw==
X-Received: by 2002:a17:902:b694:b0:153:1d9a:11a5 with SMTP id c20-20020a170902b69400b001531d9a11a5mr16799993pls.151.1650388814765;
        Tue, 19 Apr 2022 10:20:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm16862577pgh.65.2022.04.19.10.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 10:20:14 -0700 (PDT)
Message-ID: <625eef4e.1c69fb81.fa1b8.7287@mx.google.com>
Date:   Tue, 19 Apr 2022 10:20:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.238-31-g048465f6e4e69
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 111 runs,
 3 regressions (v4.19.238-31-g048465f6e4e69)
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

stable-rc/queue/4.19 baseline: 111 runs, 3 regressions (v4.19.238-31-g04846=
5f6e4e69)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.238-31-g048465f6e4e69/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.238-31-g048465f6e4e69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      048465f6e4e691a5f59fecbe6b41ab27023e3da5 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec4afa0e9efae08ae068f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-31-g048465f6e4e69/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-31-g048465f6e4e69/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ec4afa0e9efae08ae0=
690
        failing since 18 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec71b749a060578ae0694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-31-g048465f6e4e69/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-31-g048465f6e4e69/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ec71b749a060578ae0=
695
        failing since 13 days (last pass: v4.19.237-15-g3c6b80cc3200, first=
 fail: v4.19.237-256-ge149a8f3cb39) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec14ea46cccba01ae0689

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-31-g048465f6e4e69/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-31-g048465f6e4e69/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625ec14ea46cccba01ae06ab
        failing since 44 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-19T14:03:46.421653  <8>[   35.926714] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-19T14:03:47.436952  /lava-6121988/1/../bin/lava-test-case
    2022-04-19T14:03:47.445300  <8>[   36.951103] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
