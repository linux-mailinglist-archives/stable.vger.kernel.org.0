Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124BE3F246E
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 03:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhHTBvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 21:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbhHTBvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 21:51:55 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03894C061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 18:51:17 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u15so5028273plg.13
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 18:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rjgOGXgpjoI504nlB/uJE5b8QrmruI71MD82aYjT7go=;
        b=KLvA9ldTn5likU9SbPbB5kfyQYaVmiTeN6Hqiw07D1P6XLhrrHLNhZpmgUnAdSD3W+
         c/8aAINa4BsLx/D/9gf6TZXw+WSDVmDwUDvLvpr+pN0VBROllPtwHS6ap7/BRFc1tw+2
         jqglHLccLiFj1rY7aeMzsWcc4oV+gqOW+9MRsRkTQ308B/J/d4G4nE52ndZiCQUqQz3Y
         m97PZ2uZmbYSPAA5DWJ7cwB6QpkX/dpFLVjhsJKPFXrTkTgo63k40voRpdckaR4QIEqO
         KDJLwaA9KCML/q/7TPUpjnwSGY8MsN/+MQpHx02EOE9GquDxN2TWWtMA9Yey/+laiLwN
         fjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rjgOGXgpjoI504nlB/uJE5b8QrmruI71MD82aYjT7go=;
        b=YyA7FKid/+M9xiidb/HuJGwAGalnljqVvu51RLmII0AAYEvQvKpjKjRWefbYtgR+np
         xlGZeayLVjGNd6pvCQDxMeOF9EO1K3vSsuy6PYf6kToDWd6sbIUOu0hUeLUG616kcnmt
         1ccRk8QhdSaZD8/AK19BDUDVhhEmUFz0Vr5R+J7bMA6CmWdMY57o0yDnq5z8CWdZzN1P
         g8Oq+XQfTUQOVZz6GSDuDKc+anu07VnRmd4fvCLJFPoYOvybYxU2a6wx3Jn17v+ukpfo
         pPnGXqNcbDuqLxPUaOO1hs+1UdpZjws3zxynboNzLgEzipX7CJkPAQOLNvz+XBcWoaSB
         k6Pg==
X-Gm-Message-State: AOAM5328171IIk92KWagDXmGnIwhSFiNoLr56rfqiXkLpQL5xBGsL/sF
        k+0535Y7HyjLnd6OiEFlgn5Es4GVtlh4VJX3
X-Google-Smtp-Source: ABdhPJyj8a2iDBdTycVlTfcT3v+kXAv2U9Pm86pI/qcR5zgT4k/LKCqyv2IoJDcnpDSrC05SCQ460Q==
X-Received: by 2002:a17:90b:4d0e:: with SMTP id mw14mr1958827pjb.37.1629424277235;
        Thu, 19 Aug 2021 18:51:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z3sm4957907pff.47.2021.08.19.18.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 18:51:16 -0700 (PDT)
Message-ID: <611f0a94.1c69fb81.990ce.1063@mx.google.com>
Date:   Thu, 19 Aug 2021 18:51:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.142-23-ge1228d560a97
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 182 runs,
 3 regressions (v5.4.142-23-ge1228d560a97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 182 runs, 3 regressions (v5.4.142-23-ge1228d5=
60a97)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.142-23-ge1228d560a97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.142-23-ge1228d560a97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e1228d560a97270a04a9dfeac9f754cf561515b5 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611edb4ecb4bf6c20cb1369d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-2=
3-ge1228d560a97/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-2=
3-ge1228d560a97/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611edb4ecb4bf6c20cb136b5
        failing since 65 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-19T22:29:17.595390  /lava-4388922/1/../bin/lava-test-case<8>[  =
 14.782795] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-19T22:29:17.595928  =

    2021-08-19T22:29:17.596377  /lava-4388922/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611edb4ecb4bf6c20cb136cd
        failing since 65 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-19T22:29:16.154170  /lava-4388922/1/../bin/lava-test-case
    2021-08-19T22:29:16.172186  <8>[   13.358198] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-19T22:29:16.172780  /lava-4388922/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611edb4ecb4bf6c20cb136ce
        failing since 65 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-19T22:29:15.140951  /lava-4388922/1/../bin/lava-test-case<8>[  =
 12.338730] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-19T22:29:15.141635     =

 =20
