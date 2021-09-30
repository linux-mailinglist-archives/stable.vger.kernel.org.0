Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D016541E260
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 21:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhI3Tsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 15:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346163AbhI3TsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 15:48:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFB6C06176A
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 12:46:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so5605044pjb.4
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 12:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d9lISnh8Q5BwsxnVW+1Ivral2ughqtLiq7EtSVOc8Gc=;
        b=X/b9O20+8+oRLCaMbMJFVYy/5yzSNJJjcyGydrnxMpFzB1wF93Z5spXEQBMQ2hXiMf
         RVpQ88umBgBu79Rruc3pysoueu4FczLCORUmB7jWMOKOCyNsDVtIyX3SWCJ7OCd8lZae
         7DhroYx1yWIRyJQASnoLA/jzOy6BVwCL9kypfbHQbbHob5DXpVEPrfM8ViD6NkzE1fPb
         nRrayHgyXK1eaou2x18Uc7oCOsByNECPh8we76lCIqLGGD9BoXRWT6gtVvk1envAr2me
         Hcf5OlcQzEwUPWTb49HxRayIzB7JWJLw8iTWWjl3vEl6wGWnKkLZx9AHsXPKtydDd8rg
         CFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d9lISnh8Q5BwsxnVW+1Ivral2ughqtLiq7EtSVOc8Gc=;
        b=vvTA5pSad74ETIJ+mV9ztbLPDV8ujEV6HLdOpKQ3z4NBlydLh3u4fKT3HVriUuoeM+
         IkPdlI6WNYikZEmiWEgY0DWGihZauWk8hzuBYNK/UXF7LMNdbhaZxhmF0U/tcVditf9N
         rTLVMvhZe7l7JLK2fS9BQHbkzxsP/sbJ4V7rnIAC75cwr9Kvp7PQJm634IiUF/ia1a3d
         Z02+f54CLOCZ0Rmdls1OjLtAsOe099MBl0+YnxGPhQNLh1XTQE/jA3JhhDLSAH1pZyQ7
         3vP19GTScIs3anfInPrSzFsyNM6FIAuwfDgGfNt+OsZXAR8axGQwV7h80iXFyFpq+BVn
         HvUA==
X-Gm-Message-State: AOAM532SmYXZMU2H2vnjnXRrFeJ5maBY3DEVoeiiC7Oyi4lc/Dlo4Wzv
        uMlFl9todn7vZ7+B/1++mvc59zzyq38a984w
X-Google-Smtp-Source: ABdhPJz3LZQRaevX3r1+Y5vMXYkKuv/AdO/+wJ6e+Uyl2CMYACu4mbdEk0HdypjV7xgFcHH1ehKYzA==
X-Received: by 2002:a17:902:e8c2:b029:123:25ba:e443 with SMTP id v2-20020a170902e8c2b029012325bae443mr5900436plg.29.1633031197150;
        Thu, 30 Sep 2021 12:46:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12sm3371575pjv.29.2021.09.30.12.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 12:46:36 -0700 (PDT)
Message-ID: <6156141c.1c69fb81.21384.9ff3@mx.google.com>
Date:   Thu, 30 Sep 2021 12:46:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.150
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 175 runs, 8 regressions (v5.4.150)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 175 runs, 8 regressions (v5.4.150)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.150/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.150
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3a7dc5b4cfbdfd8da37cb0e54f439d84cf5a5123 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6155dcc20b102e3e4399a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6155dcc20b102e3e4399a=
30a
        failing since 48 days (last pass: v5.4.139, first fail: v5.4.140) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6155d9f90dbbdf417e99a2ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6155d9f90dbbdf417e99a=
300
        failing since 315 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6155d9f10dbbdf417e99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6155d9f10dbbdf417e99a=
2f1
        failing since 315 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6155d9da482caa131f99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6155d9da482caa131f99a=
2e0
        failing since 315 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6156070106b9701b5599a307

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6156070106b9701b5599a=
308
        failing since 315 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/6155e3ce9a0d9ba8b999a2db

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.150/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6155e3ce9a0d9ba8b999a2ef
        failing since 106 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-09-30T16:20:13.793286  /lava-4612361/1/../bin/lava-test-case
    2021-09-30T16:20:13.810571  <8>[   15.325309] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-30T16:20:13.810805  /lava-4612361/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6155e3ce9a0d9ba8b999a307
        failing since 106 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-09-30T16:20:12.367941  /lava-4612361/1/../bin/lava-test-case
    2021-09-30T16:20:12.385293  <8>[   13.900219] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-30T16:20:12.385528  /lava-4612361/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6155e3ce9a0d9ba8b999a308
        failing since 106 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-09-30T16:20:11.354512  /lava-4612361/1/../bin/lava-test-case<8>[  =
 12.880865] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-30T16:20:11.354866     =

 =20
