Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16B23B4790
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 18:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFYQvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 12:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhFYQvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 12:51:06 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18612C061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 09:48:46 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y21so5011352plb.4
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 09:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9Spc1TWZLwrRy9h6x+9JRsfEd/S16C8wFO0dyKYdbtA=;
        b=cqL9Dxolu0JWIhKjDCuHsXLtsAHK/z6u6CO/j7qkdXSDszoKlK3C0/uMM1Q0px8Ff1
         7tNifhJ1liCHw6qaS9fgGJWOjLNZ9zdsY2KPCXTR+wsy/mYfidsQnOV1qpaBLIN8REz8
         T4Dx+og8Y1HJssva56s9Qlma+Cmte840BoBGh0pT8IogEq3oBdOM/D9zmcM3OmFe98uF
         4ZNg8Y6Hnhx+/orB2dNe15uGFXoQJBOdTS8iVf87Kc3hS1KXA3FOh1SfMiBO8fw6NziA
         uYUBryDQRjDNHEHuqSS6tV+kltahtjjgdHPxFGDC1Tzm8mishEmtaCBrN9eDtXmQjPil
         lxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9Spc1TWZLwrRy9h6x+9JRsfEd/S16C8wFO0dyKYdbtA=;
        b=YuhGlZguh07Gtat9SO/2hJbXOIhthkYh9Sr/02+1g5x+X91hC6Ge93vhPDMHZhzuYq
         eZJZUkYivmR3FktOyYzL0mX8jJEVpT05ig00rUH9C34l5VrMZd3Rvp+YlVtjLPaP7JNy
         DlqxqXRANH+LRQacIQxi1ZiIWJAJ4UDI2LQUk5prDa8mOgUrvjHvFu9JkS5XOedkl7rH
         Z5VbXu7XHA8062L6jQ+QlZa3I9s8VkL+j5V3zpnJyuDj6+Jfo3KCTe7Vck7xp5qFqQa2
         XJ2WJHSoPxZRFoWsWjUN1zRX8AXZaisX+gI0mpYIodU8iVfz704Cr2zDoKITOoY6G2Co
         PFhg==
X-Gm-Message-State: AOAM5300DogDczHtqWfJ8fOatu2uY185jT2mSjRUgdCdck46eu+C//Cv
        ABuReM436wQbXCDEAEArl5BLi7Ar4CEJwH+0
X-Google-Smtp-Source: ABdhPJzwM9wpmC/eceyp+2X/cTH/6mExkbcSWwu8O0tav8HNqN2henoKb+58MEefT2YtPVeSKZA88Q==
X-Received: by 2002:a17:902:bd09:b029:ec:7e58:a54a with SMTP id p9-20020a170902bd09b02900ec7e58a54amr10079125pls.62.1624639725411;
        Fri, 25 Jun 2021 09:48:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k21sm5770848pgb.56.2021.06.25.09.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 09:48:45 -0700 (PDT)
Message-ID: <60d608ed.1c69fb81.ac631.fb1b@mx.google.com>
Date:   Fri, 25 Jun 2021 09:48:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.13-11-g6645d6f022e7
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.12.y baseline: 160 runs,
 4 regressions (v5.12.13-11-g6645d6f022e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 160 runs, 4 regressions (v5.12.13-11-g6645=
d6f022e7)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.13-11-g6645d6f022e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.13-11-g6645d6f022e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6645d6f022e751498713e7c669a7f3c434d2c652 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d5d9eee78b180f7141327f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
3-11-g6645d6f022e7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
3-11-g6645d6f022e7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5d9eee78b180f71413=
280
        failing since 2 days (last pass: v5.12.11-49-g3197a891c08a, first f=
ail: v5.12.12-179-g88a915cf22fc) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60d5ecf32fbcfb545a413280

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
3-11-g6645d6f022e7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
3-11-g6645d6f022e7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d5ecf42fbcfb545a41329d
        failing since 10 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-06-25T14:49:16.937356  /lava-4094847/1/../bin/lava-test-case
    2021-06-25T14:49:16.942811  <8>[   11.522895] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d5ecf42fbcfb545a41329e
        failing since 10 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-06-25T14:49:17.957075  /lava-4094847/1/../bin/lava-test-case
    2021-06-25T14:49:17.974157  <8>[   12.542412] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-25T14:49:17.974597  /lava-4094847/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d5ecf42fbcfb545a4132b6
        failing since 10 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-06-25T14:49:19.385457  /lava-4094847/1/../bin/lava-test-case
    2021-06-25T14:49:19.402213  <8>[   13.971031] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-25T14:49:19.402771  /lava-4094847/1/../bin/lava-test-case   =

 =20
