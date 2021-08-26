Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31AA3F88A7
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 15:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhHZNVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhHZNVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 09:21:40 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A36AC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 06:20:53 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id u6so2123613pfi.0
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 06:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=681Hmloaf6vMUju6XzEkbD5piwCiVXkmgjlbMdqLREY=;
        b=YCC8H8ToeDvT2iPIzTmrjFQeSTlPaDf4LufZ9S31J82E1v4Cx6A2/UcqmDzmRUv0AD
         xoOTlhBbysTD48Mn/LaokRCziQbTc3XCw6hi/Jv0tW8mNuK1A/aOZ/HHizQK4neueXIV
         Xy4HHxqxrzRnI8ofnjRJa1ikSJHHmNQFUovrMh2iAL0KlD0AekWdSMcnjGF3KNY2vnVi
         iqfUMiFGbWtjUsKnNgPv4HbfGNPRVcU6sl/CK83XELOsMXHiwbWkEbulgMvUc27GoTOe
         aIgUnPzJEwNFkB8Be9AZ/YVAVw+qWI6UbNBCh5Wsnb2N+g438sqChkJjZOiEGYoyEBb9
         ApFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=681Hmloaf6vMUju6XzEkbD5piwCiVXkmgjlbMdqLREY=;
        b=rsM/rfUbRmj/xVLSm/0b69urG9X3Rimqxi0rnK+qH+5EKY6S1OmwG1dAwR/QQhx7NX
         HWqZethAR/IVsl2AzpzcWWkLHqscwtf7htiZJtD3oPK5ZUodt1A/dzpl/ONJNaL7/SBP
         6ZYsRW0CDVDie2s/sUZqGElzOac4qAA4UAbRBx11H0EXrwjyBCYM1PY4dRVrw3Gdms5k
         m6h7O5ql1YCTCh/x60cdhUgO4U8/tQOth9g7MEmuZmRxTDJXCwxObe8U/zw/FaUsGyCH
         iL34xMThFN7vJFNydMRWni+Pve8PRIl6vz2Rj8TzuR/25UFb82F7afRY7SVY6Fy2MIET
         2XCg==
X-Gm-Message-State: AOAM533Un7gL+DMXxnQorVcNWFF/RbqS0vOoCk/bLB/KTKW/ebLccwUw
        O4d/aOFwwcTOtbtRLemIZwhAhXNWk7Dc2+Lu
X-Google-Smtp-Source: ABdhPJxVKy/j33N9mMD0Pf2g8+/DLnl+ZK60PyggI132mO5FcNLfoXIEd4bP7cjIzQFFhEnIhDzTCw==
X-Received: by 2002:a05:6a00:1626:b029:3e0:99b6:b320 with SMTP id e6-20020a056a001626b02903e099b6b320mr3747338pfc.25.1629984052424;
        Thu, 26 Aug 2021 06:20:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j4sm3776715pgi.6.2021.08.26.06.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:20:52 -0700 (PDT)
Message-ID: <61279534.1c69fb81.48197.a684@mx.google.com>
Date:   Thu, 26 Aug 2021 06:20:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.142-60-ga209aa8fdef3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 120 runs,
 3 regressions (v5.4.142-60-ga209aa8fdef3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 120 runs, 3 regressions (v5.4.142-60-ga209aa8=
fdef3)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.142-60-ga209aa8fdef3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.142-60-ga209aa8fdef3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a209aa8fdef3d8238be4a3ab134a64e73a606f83 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/612760132171b2689c8e2ca1

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-6=
0-ga209aa8fdef3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-6=
0-ga209aa8fdef3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/612760132171b2689c8e2cb5
        failing since 72 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-26T09:34:05.979051  /lava-4415047/1/../bin/lava-test-case<8>[  =
 14.678868] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-26T09:34:05.979554  =

    2021-08-26T09:34:05.979866  /lava-4415047/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/612760132171b2689c8e2ccb
        failing since 72 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-26T09:34:04.539290  /lava-4415047/1/../bin/lava-test-case
    2021-08-26T09:34:04.539826  <8>[   13.254441] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/612760132171b2689c8e2ccc
        failing since 72 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-26T09:34:03.518536  /lava-4415047/1/../bin/lava-test-case
    2021-08-26T09:34:03.524031  <8>[   12.234761] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
