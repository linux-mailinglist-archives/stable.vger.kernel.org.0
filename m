Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB281413508
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhIUOJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbhIUOJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 10:09:52 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BA2C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 07:08:24 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s11so20797288pgr.11
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 07:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lX/Uh8xhTjhlm0UVbW92PADrH7wSJ9Yyofp4esFnUj4=;
        b=WeAsar4zL0Ymr96h3wCYqqgEmPbGjYDMC+nYzsgR7EYeyvcUw4LGbfh4ihW9DLiu3u
         Z62B/IAmndyD6PjIc/fX92AFUW1Qw47tBl+5eSm7e1lEepcoaKZ6t8fDDB8f+nQH8TBl
         CdaCAxPN+sovF9R66I+WHDlZKKd/uzjN+McV25gX7vDVi+Dbe0ZBq+exRDWwAJFSfkLn
         rniHYaAeqV9BdocTQKrc/2CZ7Eq9ld831rQZsN8Ivr5zN/2uBHPl7FgcizrQAi25rO9j
         0WC1I+rLPjR3sTv/tUCu4MCX1WUQgDBki1e92tUbGZL4KY8tUOYBvY/QylTcnakLB4rN
         6hcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lX/Uh8xhTjhlm0UVbW92PADrH7wSJ9Yyofp4esFnUj4=;
        b=XHNvSOUnuJ78KJgzHkWjWPwYt/qRdkxaPLpjV0Bcb3ng9OBTHVqDhH2FxBflKQ+BiI
         p1i3GdWX76cs7UNKlnvo50O64C8zPY84sE0TSIUfZtFxy48iziUL9ypyO7lOi8eZocB8
         gLI1EWmlmdMjhYcLLwNSNyRFBQnodW6ymUX8kE/wBFpq3BBRDem3daVZGPMo20kEi6iS
         p/wjhz0DcSbQGb5r6rvfoB8O/z858hx4KLqPvrymSeZpg+FrrXq8y1Sv5fyrNcYUNOOL
         4w3eIntPMXBJZj0CfPn5gF3GIykOKKNEC1zlpZY1qZGHYeFIDBQ/unUr5PIk4p9NDZXA
         XnHg==
X-Gm-Message-State: AOAM531mcTVV3XWw/zq5KeFV2mkHwrGblJKany+8eWS2oYdXQkv8euCi
        147VpHozzyqp0pQ5FWJaKL/nmFVasRF3vmNH
X-Google-Smtp-Source: ABdhPJxfWxgZ2sdlTN7I9fd3tAdF1MOSqqLBUvCK6p13bGD8vzECquTStCv+bl3gR/Kb9tJ+bCfZBg==
X-Received: by 2002:a63:ed4a:: with SMTP id m10mr28870796pgk.448.1632233303598;
        Tue, 21 Sep 2021 07:08:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm19423159pgs.64.2021.09.21.07.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 07:08:23 -0700 (PDT)
Message-ID: <6149e757.1c69fb81.25945.acbf@mx.google.com>
Date:   Tue, 21 Sep 2021 07:08:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.67-124-gd409bad9aec2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 168 runs,
 4 regressions (v5.10.67-124-gd409bad9aec2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 168 runs, 4 regressions (v5.10.67-124-gd409b=
ad9aec2)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.67-124-gd409bad9aec2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.67-124-gd409bad9aec2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d409bad9aec217f4e0c9b10aa4f424fd1ee34dfe =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6149b4ca6f181de1e299a34e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
124-gd409bad9aec2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
124-gd409bad9aec2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149b4ca6f181de1e299a=
34f
        failing since 81 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/6149d0601a1e2e93fe99a2fe

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
124-gd409bad9aec2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
124-gd409bad9aec2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6149d0601a1e2e93fe99a312
        failing since 98 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-21T12:30:10.785507  /lava-4549806/1/../bin/lava-test-case
    2021-09-21T12:30:10.802667  <8>[   13.401131] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-21T12:30:10.803138  /lava-4549806/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6149d0601a1e2e93fe99a32a
        failing since 98 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-21T12:30:09.358539  /lava-4549806/1/../bin/lava-test-case
    2021-09-21T12:30:09.376946  <8>[   11.974878] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-21T12:30:09.377410  /lava-4549806/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6149d0601a1e2e93fe99a32b
        failing since 98 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-21T12:30:08.339484  /lava-4549806/1/../bin/lava-test-case
    2021-09-21T12:30:08.344896  <8>[   10.955122] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
