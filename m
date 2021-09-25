Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B213417F91
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 06:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhIYET3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 00:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhIYET2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 00:19:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FFAC061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 21:17:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so5883863pjw.0
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 21:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hKQkFec+Cz+BReliDZmz3w1TVBdA3zdmE2r6127sNJ0=;
        b=yxT0LkAOolKsha8Bk9aaDw6CgNPqNsV+LOdNzibA2aFaPMW36r3QBJ4fl+izCdo6su
         RjZubQIOB+GhV1/ZKn2AbZVJKQnHShVpRlmydyb0Co/sPQ1XwpgUqLWRs+sB6/waArfQ
         KpRK6LwWT3zluZBn+o4Jw2kklJ5eslWiMR/5ajH/g6/NctCB08kNmK7Dpc+zZJgKicg7
         idmT6coLh+sHtIEUnflsZkhCTaI3Hsh0BwN4s9hbnb4XZJSwjjhN3xY6Y1Ra9WRl7Czb
         K+rB468yzz0u+fw6RggdN/tpp9wZ9iXEpaLRwEeM5XVsFtbkHTff+259ytfZCTdal+RT
         88dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hKQkFec+Cz+BReliDZmz3w1TVBdA3zdmE2r6127sNJ0=;
        b=8ErAOl1aTcRlOVw7V2Yvb5nF8+JUhAExOqi+ksRVF2X7sm6PnwtPCxCcCKzCRv0bbo
         M6aRRLEQ4Hpa1tczPfFOQj/GRSEQI2Xn0AAfOvUeiqmQv4JRi60Ecx++6L4f2lLH739Q
         6HDl4qW6MTqEyJqp1P29SiAZVpSLEPBkkihlhch2eUIljRpRJp5TY47mKI8m4mLKXM9O
         IPTrdEfcvRIn2GjQbfq2qb/S0ITN8d9BW3U1UYhHukpJi1/HHGImIBGm84ZGPIQYNLU8
         Ru1x133SBi1IWrdh4HnF8E0+RNzkm+rTDwT5SK65rUwnpEJhnI+Q93pAEOQaQZLy6dVW
         H/7w==
X-Gm-Message-State: AOAM533WZacT70CxULWfI+1OayCKJNxw++hUQKeXCQ8ujyT8f6kjA39y
        2c2UIWQdBYCIqg/SXcKJQ6N/AehxIs8Vxntz
X-Google-Smtp-Source: ABdhPJzhM+qT21PYRri9x0Yx0mdGDZmlv664E2VKSF563BW+WMTY4eZJ4KYTqElIaZj3FlNRi2oTCQ==
X-Received: by 2002:a17:90a:1a12:: with SMTP id 18mr6528875pjk.113.1632543474084;
        Fri, 24 Sep 2021 21:17:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm10988272pga.23.2021.09.24.21.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 21:17:53 -0700 (PDT)
Message-ID: <614ea2f1.1c69fb81.fa308.4d2b@mx.google.com>
Date:   Fri, 24 Sep 2021 21:17:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207-35-g5615a99c7c2d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 104 runs,
 3 regressions (v4.19.207-35-g5615a99c7c2d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 104 runs, 3 regressions (v4.19.207-35-g561=
5a99c7c2d)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.207-35-g5615a99c7c2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.207-35-g5615a99c7c2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5615a99c7c2df1d1ab7b26351c1ddc229b9692c6 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/614e631aa6e09b9a7499a2df

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07-35-g5615a99c7c2d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07-35-g5615a99c7c2d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614e631aa6e09b9a7499a2f3
        failing since 101 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-09-24T23:44:37.532889  /lava-4580930/1/../bin/lava-test-case
    2021-09-24T23:44:37.549396  <8>[   20.343516] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-24T23:44:37.549887  /lava-4580930/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614e631aa6e09b9a7499a30c
        failing since 101 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-09-24T23:44:35.091202  /lava-4580930/1/../bin/lava-test-case
    2021-09-24T23:44:35.109541  <8>[   17.902158] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-24T23:44:35.109813  /lava-4580930/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614e631aa6e09b9a7499a30d
        failing since 101 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-09-24T23:44:34.072309  /lava-4580930/1/../bin/lava-test-case
    2021-09-24T23:44:34.077795  <8>[   16.882740] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
