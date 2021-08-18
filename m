Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBAC3F0B27
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 20:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhHRSjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 14:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbhHRSjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 14:39:41 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC622C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 11:39:06 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a21so3046093pfh.5
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 11:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Llw8cgDj5ScWMUn75c0ksbrTg6GMejtfGr5kTol1Tn8=;
        b=n/WwPr+D4QyQ6Q/MocHzkQS8msKxvPSZzQKE6xJUXXxyZmcrwO/uGN4ROaTpgPIpK+
         iBVFxiAgkDtq9qwEVWv587S0jsR4MCIvKS88Lany/MNgF5SLlGLEshYpwt0Onbky0r8H
         2/rVm4s4QH/egbJis59zBB2OzyMXt3ddy70QTM6Oiy/7zcA23LCXP3OKIEB7M/0mqqRI
         VTo7b2jUgV4rjfuogO0nkgSdad4nDK0o/9HWbM2BVvs6vMrA2FP59fCR0WHBocEjKFFT
         sUTZFD3WnX/uGhdZz3I+UyNRnMaCkLM5fkj5JghE8OCXQOzXgF0a0bFbMEj5pQWp+ltc
         KqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Llw8cgDj5ScWMUn75c0ksbrTg6GMejtfGr5kTol1Tn8=;
        b=a05qPNY3WFUclHAR9LtT8nE9g2j5d+HK0L9lOfmvCGc365ZcYT3AicjdQ6uj22oojc
         Q6z9IcvcmsimweSz8E9L4UF1KkeQ1k0cUAXR4mePnDQWkd4ALlTeDIWt2IYsmzMerncm
         LxhZpzil7xiY/4sADIng0xj8cwyOY9+bY0PYkDRMjoIbHCaij11lOSIiLIfCs0vML+Kt
         A3WuDEOf6fI8rZSsTfrmGkKw7bjZbwudWkklCh2lKVFv75X+8/uBDsI8KNmxJr/NoXKt
         tzs6qdicViMrDm+yaTd00h7GLnpu0Rb/NP5Lz60Y465NJS81F7+SopAsQuhIKUDKUxJx
         YD3w==
X-Gm-Message-State: AOAM531lAYg6fpMtlNlhxfYD/XZUDyKep1qrilOno9tptkBDd5n8OY+0
        zkluf1tbqV7zywxI7EFbLhByZFrdVL4i5rLU
X-Google-Smtp-Source: ABdhPJyljp+y0e8iq9HILs3ejGSN95USdoKfE+k6zkKGWy6JW94/dXhWxrUGvSoHKWXIWebqHByXnA==
X-Received: by 2002:a63:e446:: with SMTP id i6mr10330604pgk.288.1629311946157;
        Wed, 18 Aug 2021 11:39:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u25sm458240pfn.209.2021.08.18.11.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 11:39:05 -0700 (PDT)
Message-ID: <611d53c9.1c69fb81.c6ab9.1df9@mx.google.com>
Date:   Wed, 18 Aug 2021 11:39:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.59-99-gf82f3c334fcc
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 210 runs,
 5 regressions (v5.10.59-99-gf82f3c334fcc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 210 runs, 5 regressions (v5.10.59-99-gf82f=
3c334fcc)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.59-99-gf82f3c334fcc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.59-99-gf82f3c334fcc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f82f3c334fcc9444324972565f2fd882a6315d85 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/611d2704821d9cb1dab13674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
9-99-gf82f3c334fcc/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
9-99-gf82f3c334fcc/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d2704821d9cb1dab13=
675
        failing since 47 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/611d20c55b00f46fddb13696

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
9-99-gf82f3c334fcc/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
9-99-gf82f3c334fcc/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d20c55b00f46fddb13=
697
        failing since 4 days (last pass: v5.10.57-136-g252d84386e00, first =
fail: v5.10.57-155-ged2493daa915) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/611d2433691329d825b13676

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
9-99-gf82f3c334fcc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
9-99-gf82f3c334fcc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611d2433691329d825b1368e
        failing since 64 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611d2433691329d825b136a6
        failing since 64 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-18T15:15:41.146417  /lava-4377043/1/../bin/lava-test-case
    2021-08-18T15:15:41.153356  <8>[   11.987210] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611d2433691329d825b136a7
        failing since 64 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-18T15:15:40.127667  /lava-4377043/1/../bin/lava-test-case
    2021-08-18T15:15:40.132777  <8>[   10.967635] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
