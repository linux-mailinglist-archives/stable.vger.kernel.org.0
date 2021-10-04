Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A59A42052F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 06:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhJDEVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 00:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbhJDEVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 00:21:50 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0839C0613EC
        for <stable@vger.kernel.org>; Sun,  3 Oct 2021 21:20:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id u7so13337720pfg.13
        for <stable@vger.kernel.org>; Sun, 03 Oct 2021 21:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bsza8kPU3v8iUYk9LAcu50eb8Tkr1f2IQVYj42oIK+w=;
        b=exAHmYpdRS1Z0Sic44lmtt3yndRYJbt67pYimskzMJ9WSZZHhTYFTgB35mwPaFPds1
         PqB/0RCLvbf2vj42n2NzhL5y1dkbmRQZDQyg4Nijg8o5hwx+VbBKe5cwuKfVv5lcv99T
         j9soaEP9zKe7/wSDZIkpXMxmCSX6FpkcO9wt4EJGLP3pOeHL0IC4b4oxV1geM+YVT2YA
         7wpNAacAaZlL8eA6etI0tv4/TJsMcm17xRoGT8F6Wjzm+yaVKbqmI6WPTCPMZcWY+ATU
         FB/I4wT/oLpW9VkQ5Bj231LdBXdwYMSvm8WxfE46Jb6sonIKCIL5bvJrCIEOrkcZ6EJC
         ywUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bsza8kPU3v8iUYk9LAcu50eb8Tkr1f2IQVYj42oIK+w=;
        b=NO+WgNq2mWOju1VnqMPbT/ay/1Ly8icRnym4LH45Q6d17wgrBj/LmZ+haG5+VW0s65
         YTekyp43oMLf0NfuLouwZknV22OyyMmcGjSlt0cwhlW6csUI/ah5PvP20Kgk9oTDeLB6
         lNehiT48ayeBG1GiBe/yqb43TgsWttV60OFlHDomAO/ytWiIvIGHcazc7E4GZEJiORz5
         scaCUkV/fKO9y6XskWDAn01QhisJdvxU2dx/vdEg+r4dv4eES322rxNh835Z0GYoW07R
         LvgfYOc4B2vmec6y8AvyYhnSy8nx6jrxvJZTLZ+tv93R1lLi0gIJyQmYMNsVeJ/fC5he
         y6ZA==
X-Gm-Message-State: AOAM532UdOAlf3VQh3iGMME61dVYHE7Dx01Fk8eoZdDkMVfHWCbdCNAj
        NA1YBHbAb4Yu7wAEBOhWXa5/Yx9+oOXUwZzc
X-Google-Smtp-Source: ABdhPJwS+s9AdUyox8e9l8K+0foufcfKT+cuLNwwy3JnKtuC7/3dPWaWsMQbaeX3QPmxTV2ZKTp5dg==
X-Received: by 2002:a63:950f:: with SMTP id p15mr9029856pgd.265.1633321201130;
        Sun, 03 Oct 2021 21:20:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e22sm12308307pfn.101.2021.10.03.21.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 21:20:00 -0700 (PDT)
Message-ID: <615a80f0.1c69fb81.c71c5.5368@mx.google.com>
Date:   Sun, 03 Oct 2021 21:20:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208-62-g0f04201c0ff5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 105 runs,
 4 regressions (v4.19.208-62-g0f04201c0ff5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 105 runs, 4 regressions (v4.19.208-62-g0f0=
4201c0ff5)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-8    | omap2plus_defconfig |=
 1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.208-62-g0f04201c0ff5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.208-62-g0f04201c0ff5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f04201c0ff5f1626882d81d25edf16e6c1e6c8f =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/615a48778d24c6ead699a301

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-62-g0f04201c0ff5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-62-g0f04201c0ff5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615a48778d24c6e=
ad699a307
        new failure (last pass: v4.19.208-56-g99d9199153a6)
        2 lines

    2021-10-04T00:18:47.525873  <8>[   22.917724] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-04T00:18:47.573081  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-10-04T00:18:47.582240  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  |=
 3          =


  Details:     https://kernelci.org/test/plan/id/615a499ceb7be6fcea99a2ea

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-62-g0f04201c0ff5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-62-g0f04201c0ff5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615a499ceb7be6fcea99a2ff
        failing since 110 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-10-04T00:23:25.838471  /lava-4636082/1/../bin/lava-test-case<8>[  =
 15.491299] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-10-04T00:23:25.838749  =

    2021-10-04T00:23:25.838942  /lava-4636082/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615a499ceb7be6fcea99a300
        failing since 110 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-10-04T00:23:24.801630  /lava-4636082/1/../bin/lava-test-case
    2021-10-04T00:23:24.806936  <8>[   14.471862] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615a499ceb7be6fcea99a328
        failing since 110 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-10-04T00:23:28.262428  /lava-4636082/1/../bin/lava-test-case
    2021-10-04T00:23:28.279744  <8>[   17.933335] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-04T00:23:28.279955  /lava-4636082/1/../bin/lava-test-case   =

 =20
