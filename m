Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CDD59CF5F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 05:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiHWDWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 23:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiHWDWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 23:22:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CE0580AF
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 20:22:46 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 1so5038087pfu.0
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 20:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=K2bHUF84fr/joG6JLmWnSh2A1kdSDAxtybJ2dfv11is=;
        b=ELvOPwcdTRJaK112siiIujGTlDs9qD/3cP89bqKnhuceZeOohOCABCeMCW4BUE6PwI
         eesJ97KlJ9vKz6XqXQn2L+ahkDUQBRn3v+9+W/pueV+npqsVwCPsm1NK46vAsGx8W6n2
         XC51sXevX09kjhMt7kXCPFYZ3mz8PoFXb31fLJFwORAeL0BdNOn4VQHeokY3EkVAdEez
         65E0GqSE7zqM53HEnqKQuNTrNB/OJjqLiq4xwwIZe6FU7a+58Cyw3Mv/8Ppdyjz2wWjJ
         NOWp+A9bhMSJny1rrWY6lT9/ZdLopU61LwUmmlYd5NwxrHMLbdUi5VQjRalDuD7AI/dN
         bP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=K2bHUF84fr/joG6JLmWnSh2A1kdSDAxtybJ2dfv11is=;
        b=5MJHs8xMGMq7X52ZCH6KAGBRbrtw8Jo6FAqvxl8zgJtqMiRCXDJEg0ELo8RUxqD7s5
         judMrrdH8P7HIroIsWP9kn46giRS0GBIFmhXS/xy1eyOPRKnUunx2t9UR6nHP3AEKTR/
         PspJj6eoUoYjFLyk0nPuyWLWf33/Am/w8DIeF856gb6kGQvi/Be+a/rgIZdruw2Egs8d
         N8d+DjbIJ5GXN/k2tA8bhkHfz1+wE3H+Dd69+rOSToMxPsPf9O6EdV7y7evTvwN8kzeC
         bWkTfdglmUQe7VVRfr3M47w26i4tMskdNaorhSYBioM5V0NvFGcYiYj16XtCVa40G7uy
         PpSA==
X-Gm-Message-State: ACgBeo3CUtQydOsls1Kx3/4HOE5hG3TexQU76FSylPQwjFyneHOLSsfK
        kJQEJQjRUUkHJBdBbuDuNeoU7KSsVhMaIXe9
X-Google-Smtp-Source: AA6agR5wW7bw2VNHCT7Bvwt/uCc0o+Nx/aQUMU8yxOxoVNcS7uYMzvBAlIPrtM4tUlnEhYB+Ab7czA==
X-Received: by 2002:a05:6a00:1701:b0:535:91c1:b65f with SMTP id h1-20020a056a00170100b0053591c1b65fmr23195423pfc.40.1661224966120;
        Mon, 22 Aug 2022 20:22:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mg6-20020a17090b370600b001efa9e83927sm10712608pjb.51.2022.08.22.20.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 20:22:45 -0700 (PDT)
Message-ID: <63044805.170a0220.38e55.3b93@mx.google.com>
Date:   Mon, 22 Aug 2022 20:22:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.18-6-gad8a0ac8e472
Subject: stable-rc/queue/5.18 baseline: 138 runs,
 4 regressions (v5.18.18-6-gad8a0ac8e472)
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

stable-rc/queue/5.18 baseline: 138 runs, 4 regressions (v5.18.18-6-gad8a0ac=
8e472)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
bcm2836-rpi-2-b    | arm   | lab-collabora   | gcc-10   | bcm2835_defconfig=
  | 1          =

imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =

imx8mn-ddr4-evk    | arm64 | lab-baylibre    | gcc-10   | defconfig        =
  | 1          =

kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.18-6-gad8a0ac8e472/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.18-6-gad8a0ac8e472
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad8a0ac8e4725c1640f1ba805c32433a561d9bd7 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
bcm2836-rpi-2-b    | arm   | lab-collabora   | gcc-10   | bcm2835_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/63042d74d21cdb7449355679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18-=
6-gad8a0ac8e472/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18-=
6-gad8a0ac8e472/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63042d74d21cdb7449355=
67a
        failing since 7 days (last pass: v5.18.17-134-g620d3eac5bbd1, first=
 fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/63043f8f2139d3395a355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18-=
6-gad8a0ac8e472/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18-=
6-gad8a0ac8e472/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63043f8f2139d3395a355=
654
        failing since 48 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx8mn-ddr4-evk    | arm64 | lab-baylibre    | gcc-10   | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/63041a15f9d1bf13bf35572b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18-=
6-gad8a0ac8e472/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18-=
6-gad8a0ac8e472/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63041a15f9d1bf13bf355=
72c
        new failure (last pass: v5.18.18) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/630418c94dfaa04b1e35566c

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18-=
6-gad8a0ac8e472/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18-=
6-gad8a0ac8e472/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/630=
418c94dfaa04b1e355683
        new failure (last pass: v5.18.18)

    2022-08-23T00:01:03.059057  /lava-157662/1/../bin/lava-test-case
    2022-08-23T00:01:03.059430  <8>[   14.847399] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =20
