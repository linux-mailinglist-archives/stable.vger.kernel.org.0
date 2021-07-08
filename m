Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A473C1C3A
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 01:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhGHXtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 19:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGHXtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 19:49:52 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E59C061574
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 16:47:09 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 62so8124890pgf.1
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 16:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6V3xSJl7NEF2PH9bgx7F3u0EbEbGjCT+l3VlA+My3ug=;
        b=G5wdKBvgtjNVALMGagMCm07shIRunQiSwF266hcdk89RCuyqsq9jLHB6wBultFwn3y
         IxHCJRPphKnCKXtYBti6iU/6xCUrIUUd4reChWDRBQkg9IO4qesq7Y405t8ywV9+Imrg
         dkfswchxEbBHWozZKbAtXwQlIKm1VM7bhkKEACW0Nw1yp0Cfc8NE05sRknYx2CbaoXRj
         INhDdrNObgFZjjQ0pSqVC7Qqfbg7gYG9xp5N0+W4mDJCP860GSybNXlXpnnH6DA4zncg
         NM/a9gS66yfDGMIJmMisjeZ1IC8jckWLjc562N64aNt1wuYzTSOsw+mdEd63/45f8vU7
         DLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6V3xSJl7NEF2PH9bgx7F3u0EbEbGjCT+l3VlA+My3ug=;
        b=YzIF6oKBwM5azJpsovP8vgdWhod8H5h64QpgVdr5tPIjivhjOVmemzCAvjF8lFdcnX
         VOfK1oCm1ZuSiHOspHXOBQKDyw6CHJ0ItKhVnLC2ICRIM27FkUG7AeF0jdd+l3MrotFz
         YGtIB3TJk3PLHekLxpqxIrVdZtRk4eCVrJWhfOAYqbNYk2u4033hMB0S74+ahXYmK86b
         4DOCgQP1xPovI88uA8xoTbDW1Yt5c/aJvTHrFYaj1HZ6//P3Xd0E7Tsg2fLtpJmHN/Mt
         JKG26iWdaHyATuGxrrCDk/+x0mcG4p4jZ7kBQDYa8Nl3GPJU4KU9CBzUoiwgJyXBoiX2
         GB9w==
X-Gm-Message-State: AOAM533nhD2c5/Xh1UVqcO9naOpExHb/TsauEz6ObSju+HezWQJJR3Rn
        pcfH8DReK6I85/0vBwzDF2/dilojUIcCVI79
X-Google-Smtp-Source: ABdhPJwifw2kxoEhRH+6ckTb+ak7hDo6wvqYwaA03Wiwb6RAnjbiRIWrv10SgPpDlATbwvt+acaDHg==
X-Received: by 2002:a63:5511:: with SMTP id j17mr35072530pgb.191.1625788028248;
        Thu, 08 Jul 2021 16:47:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p53sm4000515pfw.108.2021.07.08.16.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 16:47:07 -0700 (PDT)
Message-ID: <60e78e7b.1c69fb81.3cdd.cb39@mx.google.com>
Date:   Thu, 08 Jul 2021 16:47:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.48
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 140 runs, 3 regressions (v5.10.48)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 140 runs, 3 regressions (v5.10.48)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.48/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.48
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a09a52277207fa79fc1aa7c32be6035c264a79c4 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60e775e2f91509cc3b117984

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e775e3f91509cc3b117993
        failing since 23 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-08T22:02:00.898830  /lava-4160242/1/../bin/lava-test-case
    2021-07-08T22:02:00.916551  <8>[   13.835814] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e775e3f91509cc3b1179ab
        failing since 23 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-08T22:01:59.492773  /lava-4160242/1/../bin/lava-test-case<8>[  =
 12.411508] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-08T22:01:59.493129  =

    2021-07-08T22:01:59.493319  /lava-4160242/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e775e3f91509cc3b1179ac
        failing since 23 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-08T22:01:58.455216  /lava-4160242/1/../bin/lava-test-case
    2021-07-08T22:01:58.460790  <8>[   11.392108] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
