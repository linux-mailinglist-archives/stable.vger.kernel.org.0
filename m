Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CF73A9DA0
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 16:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhFPOea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 10:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbhFPOeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 10:34:13 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F448C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 07:32:06 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e7so1204906plj.7
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 07:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uNx0xU5a/4dF/juRbISEqoH584BUTH/PUB2iTEIbd1U=;
        b=Ue/aWHMy8lyEKHQGS74n8DL6XlrkdPAoy0MHhg9yOm35esNAX2oLgPTlWsfqzfvdoy
         qrqurZge39fZovTkx3fBm94apjO1Y6Imwqlx7JG7mPm8HHT3vCPSxe1vxnfCjaU6htti
         3kfYve1JHBMUToSbE2cRdosmaoKgnhG8ew4K2V28Y/xv8ZtfXuLJtXzWtV+HonhJ5qRM
         i0EF3WN+SNK8yjLSmvnOz3w76GtfEYBzDaNjhU+e0CoLzl/DRB2+ZxuqsKvRm8r6Xx5P
         9jr/dDgw6HQHgW0HSyXgYRJghGiJEiv6z1y7w8X2RAZzCTXuzaYuSGkoVk86XPX2uiS8
         c4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uNx0xU5a/4dF/juRbISEqoH584BUTH/PUB2iTEIbd1U=;
        b=AWWDCE/59aLKi9JkBucUAR4fZbSTnrqx/jqdQaZt/7yjggZNPitmj/wpRfhxrG1VN+
         6liIIwTiZN3ldqShZYeYkgQFj4QawC+NW3oHmV61dLErqET5Nvx+Zmfc+LIc292ZQsXQ
         1LxUC6jv+KCCUw+w7kRvqrPEu4MZxCDSUCAYps8IhYntQJRDSDfJcCwm+60weTjZ21Bp
         sqH4+kDO1j7sWX3+zxBPb5xmufZNVUhIHC6V/Q6zx/oW9Ex6leAusL7+uakiUwcY8jWR
         qIZLkClV7aVl4dXJ12ly/yutmRisEgAfJc9RjSWZRSKa2sGzF/FT3Z5h4+3nUYXbNejD
         oRVA==
X-Gm-Message-State: AOAM530kbNKjVI2tGZK4ZuBcsR5s9+0YztYEOJI6zseM3+uprL8OI9mH
        4TmDOpt7gCjL0Ge9AhegiFNY2KFrC+1E9NDA
X-Google-Smtp-Source: ABdhPJwBgkwU3tj24ROBJvFSRZAvOPgQtdm0Ajrex+2ZBOT6tVNNY8v0ZX+1QlEGSRgTNwKVge7QPA==
X-Received: by 2002:a17:902:7442:b029:11e:4b18:daf5 with SMTP id e2-20020a1709027442b029011e4b18daf5mr4986962plt.47.1623853925603;
        Wed, 16 Jun 2021 07:32:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k70sm2541552pgd.41.2021.06.16.07.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 07:32:05 -0700 (PDT)
Message-ID: <60ca0b65.1c69fb81.b73d1.68b9@mx.google.com>
Date:   Wed, 16 Jun 2021 07:32:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.10-173-g9338bb0a7a25
X-Kernelci-Branch: queue/5.12
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.12 baseline: 156 runs,
 3 regressions (v5.12.10-173-g9338bb0a7a25)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 156 runs, 3 regressions (v5.12.10-173-g9338b=
b0a7a25)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.10-173-g9338bb0a7a25/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.10-173-g9338bb0a7a25
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9338bb0a7a25b78a61ec84ca0e12c36d30a299f3 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60ca024fbd25d8c98f41328c

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.10-=
173-g9338bb0a7a25/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.10-=
173-g9338bb0a7a25/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca0250bd25d8c98f4132a9
        failing since 1 day (last pass: v5.12.10-48-g5e97c6651365, first fa=
il: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-16T13:53:12.599504  /lava-4035497/1/../bin/lava-test-case
    2021-06-16T13:53:12.605241  <8>[   11.929389] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca0250bd25d8c98f4132aa
        failing since 1 day (last pass: v5.12.10-48-g5e97c6651365, first fa=
il: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-16T13:53:13.619468  /lava-4035497/1/../bin/lava-test-case
    2021-06-16T13:53:13.637836  <8>[   12.949192] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-16T13:53:13.638370  /lava-4035497/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca0250bd25d8c98f4132c2
        failing since 1 day (last pass: v5.12.10-48-g5e97c6651365, first fa=
il: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-16T13:53:15.052175  /lava-4035497/1/../bin/lava-test-case
    2021-06-16T13:53:15.069571  <8>[   14.381597] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-16T13:53:15.070263  /lava-4035497/1/../bin/lava-test-case   =

 =20
