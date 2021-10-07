Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE131424E0B
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 09:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhJGHYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 03:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbhJGHYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 03:24:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A1FC061746
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 00:22:52 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so4379543pjb.4
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 00:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tFgxNHUBgbaAp2uVAex9rhUezklsVZLujtA2Scqjn+Q=;
        b=AIpeBFwWEx5BOxAs14rWBV2xJ5RYGr3tB6+iigLeimkR0AMW8WzxMiBaXcm3WL7wWv
         3bbyYHoMHDfagdT9PYHqlFAj+QhADB4yageO1poDYlUYX5oGHfC58uraYOtE3YKBdcH/
         qQq8OU6Xlhv6ZRJh6Grx7Wq072qqOWJTM1PlNk5b6/HlzpTDdlltuewSgFs8YgMYWcjG
         BiXF/5GFQEyZUaQAvR0qf2qNyEeGW/0xRhATj+QnZ7qRXUdnrAUWHEAcVsUjbQiQbNSE
         Xjqis37AxAT+m0wJKvOmaS8NL16DdgKxKPqbDaQVWCL8FwAkF/VvUFo8lX0KYP8PYkLL
         oWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tFgxNHUBgbaAp2uVAex9rhUezklsVZLujtA2Scqjn+Q=;
        b=YXCQDMiOu+uP+j7k8HVOviPmvXTu5VWIAczFCwizDqc52syOxdvPBxyDoW5amnRzn+
         V67169J9d9AuOSl9VE1/XVmvrlA4eWdaohrRtaeSN/fV/Iycp+pHnNr+31CBQz/DG1VG
         TIKm32KKiFyxGC4UXnZmZGhOrLReDBF/NltgN3Z6U7fFAA+pfBZtvwWw+te7PdCDX91o
         xyS8C8RKWLh7/LZgqgdBRj+58k5UPhGdnROWqeArSFqQfZfyLizDN8YAFsYxehqKp2NE
         /xZivx3vIyOkJLeRlmz3nvb1VmL8qoNhEn544rVLreHplOUsOfkRcYsSfew2y6vGLVUn
         pzDg==
X-Gm-Message-State: AOAM530SEbUHMJOMR02A4eyjdTUPFOI+vOhTK9cSyAqgN+LoiUPEtt/i
        AnWbtM5ZawfpYm3B3MSmbA1gOZIYF+rYFnDd
X-Google-Smtp-Source: ABdhPJzzm7mAgorKD3daaG6sr+4vrFU/Zzw8kHUED/Xg9oD1HsHOK/ZFY5MOQ7fJRg3PuhBnnMT+nA==
X-Received: by 2002:a17:90a:c89:: with SMTP id v9mr3006991pja.71.1633591371654;
        Thu, 07 Oct 2021 00:22:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2sm24306457pgd.84.2021.10.07.00.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 00:22:51 -0700 (PDT)
Message-ID: <615ea04b.1c69fb81.4bec2.8ed6@mx.google.com>
Date:   Thu, 07 Oct 2021 00:22:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.70-92-g164ad51675cf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 162 runs,
 3 regressions (v5.10.70-92-g164ad51675cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 162 runs, 3 regressions (v5.10.70-92-g164ad5=
1675cf)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.70-92-g164ad51675cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.70-92-g164ad51675cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      164ad51675cf3cabcbaff34615be2089a95378ca =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/615e78e9460546ed0f99a2f2

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
92-g164ad51675cf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
92-g164ad51675cf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615e78e9460546ed0f99a306
        failing since 113 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-07T04:34:26.656854  /lava-4659965/1/../bin/lava-test-case
    2021-10-07T04:34:26.674244  <8>[   13.545465] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-07T04:34:26.674737  /lava-4659965/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615e78e9460546ed0f99a31d
        failing since 113 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-07T04:34:25.234566  /lava-4659965/1/../bin/lava-test-case
    2021-10-07T04:34:25.248101  <8>[   12.118840] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-07T04:34:25.248413  /lava-4659965/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615e78e9460546ed0f99a31e
        failing since 113 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-07T04:34:24.211060  /lava-4659965/1/../bin/lava-test-case
    2021-10-07T04:34:24.216614  <8>[   11.099339] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
