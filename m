Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71153EAF00
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 05:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbhHMD4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 23:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbhHMD4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 23:56:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F83C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 20:55:53 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w14so13384877pjh.5
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 20:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a6LiiSKkPEpPyxyv7Kv4bytRZmitGgQzlzAeeL6QG+w=;
        b=MsXlXsm9N67zeudNgklWc57X3zjWsFT1CwvigdLjOUh8JINh1zr6E4qfhyHttNtq0N
         6DWGrzrC0RorQjN48EFwTbxjgGZxPSOMDMCws1PR0A+Iarl5KDZbStanwEraaUhRSH4L
         WUKdnPoStrI0MPrFNq9jWkll3fGx+i+XL4bhjoWPiFwC0xv0bfjTUMAtMOYWAXPDyg76
         cZ39e9Ln9mMtb8tifSDqTqe1bucQ6FkWodq1pwM6L/VN+hLdciXk8PQ/ywzhwqPfmBHo
         dwr1vh2zJpDb6YPHlCoEoQA0wrx/KGJ3UbPRyVd4jKfeYKXqJn9w4tiqaa6EhJr7x9Vz
         7zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a6LiiSKkPEpPyxyv7Kv4bytRZmitGgQzlzAeeL6QG+w=;
        b=WjomyQdv+2efZmeyYyL8z55LxpKnds5r8I2ztlzfAjlui2YyEvtYzFwYS/XtDJ9APh
         k/9DurT5JsRWb0lekZECk0xyu0R2eFeTz9XY0TAIpnYCgvmstX7gXtPFXdFCVW6ZMSJq
         VRJgy47XVo9IkBiWHTEHVq/e0nyLsTo5WRE6B4joS2QZL/TO0mwwOIGnf3V2rH3TZgXu
         dvLywyklrFH4B3Co9OmvsyR9tOZMSWnPfKy0clzm8PVyp07LLHXtPjEU1fJXw3F/8haa
         sKkCpEV0NnH48Vnhb4gcXI43zgh3y/aQjtXqKeAH2T8Vgfk7azPSwnGCHEN+7VsQZ+yI
         YQYg==
X-Gm-Message-State: AOAM532VSat3FYloxFxvsJbfsbYNTyDmGCzWiboesVLSjKOQQlqlqhpA
        SuPn9FsDVyf3j+snqVUxvGq2HOUTts+Juil6
X-Google-Smtp-Source: ABdhPJybOjGpeVNUpo0D9eS912Cl8AVjhJRqzsCZBTZY2rTIoYwDII+Qvul12YdQPjxXC0i3VpgWdA==
X-Received: by 2002:a17:90a:8909:: with SMTP id u9mr543516pjn.9.1628826952768;
        Thu, 12 Aug 2021 20:55:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d19sm280606pjz.26.2021.08.12.20.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 20:55:52 -0700 (PDT)
Message-ID: <6115ed48.1c69fb81.4b46a.10ba@mx.google.com>
Date:   Thu, 12 Aug 2021 20:55:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.139-90-g53f010fe123e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 176 runs,
 4 regressions (v5.4.139-90-g53f010fe123e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 176 runs, 4 regressions (v5.4.139-90-g53f010f=
e123e)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
imx6ul-14x14-evk  | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.139-90-g53f010fe123e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.139-90-g53f010fe123e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      53f010fe123e3bd944b1136514e29ebb03c3415b =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
imx6ul-14x14-evk  | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6115ba1714c4d18f02b13679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-9=
0-g53f010fe123e/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-9=
0-g53f010fe123e/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6115ba1714c4d18f02b13=
67a
        new failure (last pass: v5.4.139-85-gd1a62f9876ac) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6115baa0b699671818b1366d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-9=
0-g53f010fe123e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-9=
0-g53f010fe123e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6115baa0b699671818b13685
        failing since 58 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-13T00:19:24.494206  /lava-4355734/1/../bin/lava-test-case
    2021-08-13T00:19:24.511517  <8>[   14.497183] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-13T00:19:24.512003  /lava-4355734/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6115baa1b699671818b1369d
        failing since 58 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-13T00:19:23.070602  /lava-4355734/1/../bin/lava-test-case
    2021-08-13T00:19:23.087949  <8>[   13.073053] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-13T00:19:23.088474  /lava-4355734/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6115baa1b699671818b1369e
        failing since 58 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-13T00:19:22.056138  /lava-4355734/1/../bin/lava-test-case<8>[  =
 12.053621] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-13T00:19:22.056604     =

 =20
