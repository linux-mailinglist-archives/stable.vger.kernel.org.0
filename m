Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7A0429F7B
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 10:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhJLIP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 04:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbhJLIPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 04:15:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80359C061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 01:13:23 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k26so16974739pfi.5
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 01:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SDOuO5pSppEpXo6zUTPa/62Lrv/xDMvY4h94/T4hsfM=;
        b=qDYXmbjTSpDRxwdLmxIaH/8/mmc6tHwV7xdnwmnKgV27CVKirwcDKQWErS8ZEswjbe
         j5jqfETtuvGIEGy8Fnplx/7DKlMfYnDpkpQKz3bRXhmSd2rso9ZpzcW/U60IhczW7stn
         8m0zR2RYV8MNaXOeL8HnB9L8CI89T14VdSohz4Yc3loWuFaLbsgBgzhFSKACPhxuD72f
         sTXKQ06CnLi2JzTvMOFQsjUh0DlJqShNaeY5pdCnzFyYmm6VC2OjWd4ZRXTmhHwYt4Lz
         APnVHVYZXaIA2Z+a5qbKrEv6UlKEo19jsF3hcS/K1J1eardl5vYR026OFt6LgjcO2xOp
         dbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SDOuO5pSppEpXo6zUTPa/62Lrv/xDMvY4h94/T4hsfM=;
        b=5Lng1t2Bm2gmKbAKorszmA8W5RtQ04xOLm0RRTX982chz8Qsu3xnwKWn8eJItUhNLl
         YoYK/XwnI7grncbsEBb6Sn7eihdITz39MSThJkFjzlvUOp6sZlgV9aHMa/xy83/bukMh
         hisUd2n7u53fnZbUBt3FdU16T19/IsMKZTmrQweGabWsNdAn7YdQEWVFfyClKa+zoBOR
         3Z1jyYxd9X/+rm0ND25tVnWwnWvMyPAIvmcTwDscAWeAqECoBKNllYi59mrD4dNkMQB5
         BPGrqdxmxKQxUYwJoSMW67RDuiqZAsH+8fzB8bNztDHDOm0VepO8PRQExl6fY3rTsgh8
         pcWA==
X-Gm-Message-State: AOAM532cUUd1sIAeU5cCsrLRjWj9MJam2K6tLL5jDsNZvd1Do28WHSd1
        p0ckB27adIUn7LFbzbFadEPCnsqE9XVGt8FB
X-Google-Smtp-Source: ABdhPJzR0T0BwnH+Xmd/ZCbJirdjsdI/i0wpJ0XHVMqvgHVvVeZJCAWzFvosnKUXGa26V6EnIXS2wA==
X-Received: by 2002:a65:6392:: with SMTP id h18mr21730777pgv.397.1634026402879;
        Tue, 12 Oct 2021 01:13:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oj1sm1936301pjb.49.2021.10.12.01.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 01:13:22 -0700 (PDT)
Message-ID: <616543a2.1c69fb81.84d0a.65a9@mx.google.com>
Date:   Tue, 12 Oct 2021 01:13:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.152-52-gdbec2ad24369
Subject: stable-rc/queue/5.4 baseline: 123 runs,
 3 regressions (v5.4.152-52-gdbec2ad24369)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 123 runs, 3 regressions (v5.4.152-52-gdbec2ad=
24369)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.152-52-gdbec2ad24369/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.152-52-gdbec2ad24369
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbec2ad24369f6f2b3b1a42493f0ca4dbf313604 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6165203b61d9c7a41b08faab

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.152-5=
2-gdbec2ad24369/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.152-5=
2-gdbec2ad24369/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6165203b61d9c7a41b08fac3
        failing since 119 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-12T05:42:06.704914  /lava-4699266/1/../bin/lava-test-case
    2021-10-12T05:42:06.722098  <8>[   15.407582] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-12T05:42:06.722671  /lava-4699266/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6165203b61d9c7a41b08fadb
        failing since 119 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-12T05:42:05.279912  /lava-4699266/1/../bin/lava-test-case
    2021-10-12T05:42:05.297081  <8>[   13.982550] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-12T05:42:05.297616  /lava-4699266/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6165203b61d9c7a41b08fadc
        failing since 119 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-12T05:42:04.266350  /lava-4699266/1/../bin/lava-test-case<8>[  =
 12.962950] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-10-12T05:42:04.266898     =

 =20
