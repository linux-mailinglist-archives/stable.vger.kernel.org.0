Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8F062754D
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 05:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKNEab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Nov 2022 23:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235817AbiKNEaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Nov 2022 23:30:30 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793B263FC
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 20:30:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b11so9315424pjp.2
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 20:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cDalL4sAky8fhLrZ1aoVzAHB/dF+XnwsO1o1vSM17/I=;
        b=kZGhNwBmpyzHkX8e/48q06G95lhLWLOsQsPfnVVnhEOClXJn59uHP4z2vF/Slyn0be
         IYTWGfZwmP3WfNmnpM04kcO0eyxHbN2Sjk+zazlzuipcyUwXDNsVDJ4yqbtK1ci6KZ8K
         V8na23V4YxAYInowsL4l5nHeK0VP+ERiHWVCTJlj0Ak9gBbBzEvkkXjh7VKpUS6jk4uv
         jOSN70yPHiVCnZ6NYf3163cdrI18iIadd82BT23GNfSjzMjKy12v1pt5dlBzXecB6ETt
         uaVaaseCuhz994pTy67A8xBfMo9YZZyItBhUuP/VL1sHtaVi3YzUILsVOqHwQg8uqYa0
         DgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cDalL4sAky8fhLrZ1aoVzAHB/dF+XnwsO1o1vSM17/I=;
        b=bVyUuassZmstsvWVBndqObbBf7AQrsXtV/rJVVmPc/plq6ACe3RgW/oF0FVEFXxJ6Q
         mHDLop/nuOs262EY4R3aY8olbLkf+m0OgUtXuDupjwqlCHMghOdONPYaUAOiqIf9FMHw
         0SUAQ2kcKWehehxXU5zoMj4XGN/ukWu4qET7ifbhLF4AuMCrP5J2JJ2e2KrDFhsphkVm
         +jaxupyI7mKtSLclVhlwkW/GPAqxNNy5uYynrR5eDvIEiAtx/2A1WM4q4jGHGDSz17v8
         rdTxzb3bmc1ChI1zaLXApsr2ebb0a2gMVNflkr/juTOOiX4L/e5QUtgFmS33mCYP1RgF
         K+yw==
X-Gm-Message-State: ANoB5pmh+T0GTw+zv5imVBSlSH4T6o8A6gx1+W13esmOk72W6N9ZNIQs
        NMKUwsj7Z4mzOKMKIeVCKQB1mKhRepgSDoIfmBI=
X-Google-Smtp-Source: AA0mqf54rrYMDmb6x6fs/U1ctrnhm2XnoletUdLz989u/enjHT2LpDK1teGqw+aRwJ+5mAW3JibMoA==
X-Received: by 2002:a17:902:d2ca:b0:186:cbf1:27e3 with SMTP id n10-20020a170902d2ca00b00186cbf127e3mr11972935plc.143.1668400227856;
        Sun, 13 Nov 2022 20:30:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l9-20020a17090a150900b0020d48bc6661sm8665761pja.31.2022.11.13.20.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 20:30:27 -0800 (PST)
Message-ID: <6371c463.170a0220.90ab2.cdbd@mx.google.com>
Date:   Sun, 13 Nov 2022 20:30:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.78-81-ge59bfbab78c4
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 154 runs,
 3 regressions (v5.15.78-81-ge59bfbab78c4)
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

stable-rc/queue/5.15 baseline: 154 runs, 3 regressions (v5.15.78-81-ge59bfb=
ab78c4)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig           | regre=
ssions
--------------+------+-------------+----------+---------------------+------=
------
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig  | 1    =
      =

imx7ulp-evk   | arm  | lab-nxp     | gcc-10   | imx_v6_v7_defconfig | 1    =
      =

imx7ulp-evk   | arm  | lab-nxp     | gcc-10   | multi_v7_defconfig  | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.78-81-ge59bfbab78c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.78-81-ge59bfbab78c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e59bfbab78c40e4a022721f665fead2153904bb4 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig           | regre=
ssions
--------------+------+-------------+----------+---------------------+------=
------
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig  | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6371920f8f7f9c3281e7db66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
81-ge59bfbab78c4/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
81-ge59bfbab78c4/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6371920f8f7f9c3281e7d=
b67
        new failure (last pass: v5.15.78-6-g2127e10a18b1) =

 =



platform      | arch | lab         | compiler | defconfig           | regre=
ssions
--------------+------+-------------+----------+---------------------+------=
------
imx7ulp-evk   | arm  | lab-nxp     | gcc-10   | imx_v6_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/637192d8ca2d793fd3e7db5c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
81-ge59bfbab78c4/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
81-ge59bfbab78c4/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637192d8ca2d793fd3e7d=
b5d
        failing since 49 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform      | arch | lab         | compiler | defconfig           | regre=
ssions
--------------+------+-------------+----------+---------------------+------=
------
imx7ulp-evk   | arm  | lab-nxp     | gcc-10   | multi_v7_defconfig  | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/637194a13e460f22cde7db86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
81-ge59bfbab78c4/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
81-ge59bfbab78c4/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637194a13e460f22cde7d=
b87
        failing since 49 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
