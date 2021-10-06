Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD5B424A9F
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 01:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJFXpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 19:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhJFXpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 19:45:22 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C0FC061746
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 16:43:29 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa6-20020a17090b1bc600b0019ffc4b9c51so5541007pjb.2
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 16:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DfwIvxdev0KqzEwf988s9duU02ekPgljErsz9SuKWvg=;
        b=vjVXmbjTKgLT6wqgPbLTkxb8i1dD1NLDXqOma+PizDHqWHRpwrprs06td0PfGZHPLB
         XzSUY8b2dnqDHBFYpxlf40BdjRmhVrTwY1kM3pB2avwR4aO7xE8tOY/m0/75fOCMNdUA
         62CoUkvHR3g44e5K1B4d3Dk9qARpJKWzJiUBf4mcGSYSXnx6ZBHTj42s08xTC6V5SVgo
         sxX0OKeuFwJsvKWcdiiK6fzXZ5zrgFxoZLJ74brdUrYVt9alwbxMRRRyH3OdJ7+M+8gO
         WvhvPPEYuUjhxyWS8Ep1Bs4twiLU1JK9QA+e9OkIhKx35oUqqS96xt7eeG6hnbp/iy7D
         SUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DfwIvxdev0KqzEwf988s9duU02ekPgljErsz9SuKWvg=;
        b=Nm3MkebiCzhdB/ABcJ3kyv5b8JzWXIp2rEjGS0HqPn+LLA7VY8vWB5jOA8+Yz3W4/b
         ZjHY44MdapoA0Olp8gLUaK714XK88diPX5b8D3yU+uPaT5ugWsTtMX4X+yVbzW+yGsFu
         3I+izhBfmq451kzeKKnj7sLB0bFFmKWmAhAEBl/Jws8o5gxNpEufCuVIeNsz24Poapqc
         Mjn3/0WRQYEZHQgVAEL2JIj4o7Mjy1XY88T7T5eURg1udQQ+niCQWqjAO3SoYa1W+Xj+
         CLnrskZ8GXMf4c13L+AcD91kCFZ38LH1Pbv84l9HD94mB9Nez8exMb1fBe22tQZIW73a
         OQrQ==
X-Gm-Message-State: AOAM5308YjdW2zl7NKBe66XrAYUKuMYwR4axJEV5mS9Kzgs9yPZ6dbrg
        lKZN/Lx0OxHyEl7dN3uDTNyn6N6mkBJbhhuG
X-Google-Smtp-Source: ABdhPJzDuaKjooZqr8iif1i4VsSOppzoXNx2PeGmktKpDFQXs/MHanLzKC8bcn6BfprTeHgLQ6JnVg==
X-Received: by 2002:a17:90b:1c92:: with SMTP id oo18mr1793829pjb.56.1633563808850;
        Wed, 06 Oct 2021 16:43:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 18sm21749431pfi.60.2021.10.06.16.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 16:43:28 -0700 (PDT)
Message-ID: <615e34a0.1c69fb81.5181c.2901@mx.google.com>
Date:   Wed, 06 Oct 2021 16:43:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.150-53-gc5afd6e806b4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 127 runs,
 3 regressions (v5.4.150-53-gc5afd6e806b4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 127 runs, 3 regressions (v5.4.150-53-gc5afd6e=
806b4)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.150-53-gc5afd6e806b4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.150-53-gc5afd6e806b4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5afd6e806b4bdff96017981031b4703fd4f374e =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/615e1ad640fa3f28fa99a2e9

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.150-5=
3-gc5afd6e806b4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.150-5=
3-gc5afd6e806b4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615e1ad640fa3f28fa99a2fd
        failing since 113 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-06T21:53:05.687494  /lava-4658241/1/../bin/lava-test-case<8>[  =
 17.198033] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-10-06T21:53:05.687892  =

    2021-10-06T21:53:05.688131  /lava-4658241/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615e1ad640fa3f28fa99a315
        failing since 113 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-06T21:53:04.245248  /lava-4658241/1/../bin/lava-test-case
    2021-10-06T21:53:04.262756  <8>[   15.773218] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615e1ad640fa3f28fa99a32c
        failing since 113 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-06T21:53:03.225914  /lava-4658241/1/../bin/lava-test-case
    2021-10-06T21:53:03.231401  <8>[   14.753866] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
