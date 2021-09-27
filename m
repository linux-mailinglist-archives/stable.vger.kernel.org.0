Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98793418E1F
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 06:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhI0EUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 00:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhI0EUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 00:20:22 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2E1C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 21:18:45 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso12356163pjb.3
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 21:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4YG1zp6T8mBBn0JxGGLnzSpMoX57rD6T3751JGRa6fQ=;
        b=WiWRHMJ6qcYwvgufqegPfOExDdM68alGUllAjaO/2F+GdkiQCBKznJq7XNLzAluQWv
         vvJq7CWd/urUY1g8POkJtdP4zp1FPWgguI0LxVhEduvg+t4faJuvzul3vveMp3KTXPy+
         oNfvL4yUTKTotTXy5PdugwiUdE42QqxpYTFCHsgyOPOgHxxm62RN21xg6L2LnURpWKOs
         8iNZKdHDn52D+iA8tY1qMPOHtccV0b0kM6LkeX85RLSd99N0BWqkBUt3xjt1TlBv+C4n
         65XAr2UViDmvlDq4xAkX1WcGNQlPxMaJRNalw6aYzJMA+BfBezDZ5Xu4/DrajXTjkpco
         P8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4YG1zp6T8mBBn0JxGGLnzSpMoX57rD6T3751JGRa6fQ=;
        b=K0Z0DtpxmEOoR0BTkGCUvHTZ5qhPrvB266yucJ02x+uiCJBuvWBfpIY7R9Vo6zCt6i
         koscTgcdkTfczfZ2o06b1KhDIg20vZY0OcwwPta6MqS6r5fpa2BKBxZlfaV276vEffb+
         sXM0VlUf9PiSq5ur3BNRTGkJKWmMLgjb9L1L60hxyQpDbSv+NTwBp3T6EO9C/Scqq18T
         pVa6O0ezA5duwXazZyje5pnFFhGAb6CoRzoc9wtCJ3wgBXGhG6golnA8VXtpQyXl+4f1
         Wd4t7gbCXJjKEQg0/wdVpuCUYBM+z1Ej13x3+yG9nTK4RIroxIynQBEGF0hRq3yWRpPS
         NzfQ==
X-Gm-Message-State: AOAM530++BnxviQC9Re/TQY+j8rzTFrlTJ6EXxU/tCjj1wLlk5QmA754
        p8Tn8+QuCw4vnm8NYL5hKrmJXljsjKP0r/4X
X-Google-Smtp-Source: ABdhPJwVQJzcCA1Y0KINK4Exor1CBqTkh07c56NZ2kU7yzSNhaQe1vlPubOJZ8G+Oc77RaOMsuUhmQ==
X-Received: by 2002:a17:902:7142:b0:13e:e77:7a26 with SMTP id u2-20020a170902714200b0013e0e777a26mr8255797plm.38.1632716324829;
        Sun, 26 Sep 2021 21:18:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u8sm3496358pgf.78.2021.09.26.21.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 21:18:44 -0700 (PDT)
Message-ID: <61514624.1c69fb81.90331.07ce@mx.google.com>
Date:   Sun, 26 Sep 2021 21:18:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.247-43-gc6f5c52c329f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 111 runs,
 4 regressions (v4.14.247-43-gc6f5c52c329f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 111 runs, 4 regressions (v4.14.247-43-gc6f5c=
52c329f)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-8    | defconfig  =
        | 1          =

rk3288-veyron-jaq          | arm   | lab-collabora | gcc-8    | multi_v7_de=
fconfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.247-43-gc6f5c52c329f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.247-43-gc6f5c52c329f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c6f5c52c329f14875ba22fe39b116ba55a5702ec =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-8    | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6151124636a185802199a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-43-gc6f5c52c329f/arm64/defconfig/gcc-8/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-43-gc6f5c52c329f/arm64/defconfig/gcc-8/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6151124636a185802199a=
2f2
        new failure (last pass: v4.14.247-8-g6c70a9ccd5be) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
rk3288-veyron-jaq          | arm   | lab-collabora | gcc-8    | multi_v7_de=
fconfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6151126aac69086e9c99a2da

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-43-gc6f5c52c329f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-43-gc6f5c52c329f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6151126aac69086e9c99a2ee
        failing since 103 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6151126bac69086e9c99a307
        failing since 103 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-27T00:37:13.418555  /lava-4586720/1/../bin/lava-test-case[   16=
.430427] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-09-27T00:37:13.418758  =

    2021-09-27T00:37:14.431735  /lava-4586720/1/../bin/lava-test-case
    2021-09-27T00:37:14.448996  [   17.449197] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-27T00:37:14.449264  /lava-4586720/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6151126bac69086e9c99a308
        failing since 103 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583) =

 =20
