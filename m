Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC7C3C1EC5
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 07:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhGIFOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 01:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhGIFOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 01:14:12 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A583FC061574
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 22:11:28 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g24so5106280pji.4
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 22:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xpqB69cuZO+1sEXdMBC6CDUHV9mbcie5/EPkohGFjEs=;
        b=IzhjQt0ohtbEL5ZIwSQySCbDyNmf3983dun8kJsneSG9hDcpGm+9Nqwo1LQ3QBgwcR
         ryyJuL8ZXC/Hj2/8iwscU72pU15AntKjX8LQp2Bq1hCue6kj1JRUEp9pZH6TPwzBMUCd
         WVVrniLpu6LSvr4KolJ+8CPx7jQJhBU0Za+yGxyLc2Ly1MrgFWC8ahpicgLy9x4qg/ru
         abE7+vP9UrEVip7FRH/Rd1zTKi8SNDZl7ef5pS125KLUlpjJca8Q+HzQh8S4dmhlCxcK
         Nq2I2p4w2tCpvauObdzlEMp9ARj8KjvsStKPuHptexZ0NYWJNLCbkeT4hpTAFHa5+OEL
         cZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xpqB69cuZO+1sEXdMBC6CDUHV9mbcie5/EPkohGFjEs=;
        b=X/MkcErHhekiHMGzp/LnsYxqN+sFkBQ+OJZRVv8QBCgMo3qwe1xH9bVtmS8eS8CSDt
         WXKFZY2UdOIDLOOJE/g8HtAsmiwg8Kv8kH/UHuq6/RfuWnmmiAKEHunGEg+Fkq6wFMRW
         +UXtZ6FYGaxfa8DsgXgUg4i+hjzm6IHpd5yAhA9hbCX5z6sELzyZ/1Rv+lnoffpysE8T
         IJFBx8F4R8V6qcvRVFUUbzUdFFfgNm5HHXNOKsbkq2jbavJ8mFtL8TLuaj+/6q7C3a52
         xMwe4kqPrN8kWRrkOGqfYpZfcBjJHxlSUrVm6Eo2yrE2F1U7C7LjCGQ74AbK1UniVSUT
         XX5w==
X-Gm-Message-State: AOAM532Fz/iwj8h6k8P2MyNDFtPxfjLYs4ivNZBoQqpqBY/rNALFwCQY
        wl5UsT1q68BJQncZGklNycWxcWYTeRsgyS0t
X-Google-Smtp-Source: ABdhPJxxARoOi4Fua2aPR9qjUo+X57VzNEXkD5acxVYF7+xwXdg+5Eb7fqkVhdEfuG4ZVLjw4hF1rg==
X-Received: by 2002:a17:90b:3b46:: with SMTP id ot6mr8561606pjb.113.1625807487736;
        Thu, 08 Jul 2021 22:11:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5sm5144066pgt.46.2021.07.08.22.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 22:11:27 -0700 (PDT)
Message-ID: <60e7da7f.1c69fb81.a30ea.120a@mx.google.com>
Date:   Thu, 08 Jul 2021 22:11:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.15-3-g5f1dd5a13f07
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 134 runs,
 3 regressions (v5.12.15-3-g5f1dd5a13f07)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 134 runs, 3 regressions (v5.12.15-3-g5f1dd5a=
13f07)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.15-3-g5f1dd5a13f07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.15-3-g5f1dd5a13f07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f1dd5a13f07f41406201ebbaff28b5c0b084b76 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60e7bb362d3cd87376117991

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.15-=
3-g5f1dd5a13f07/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.15-=
3-g5f1dd5a13f07/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e7bb362d3cd873761179a5
        failing since 24 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-09T02:57:40.766841  /lava-4162062/1/../bin/lava-test-case
    2021-07-09T02:57:40.784969  <8>[   13.653157] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-09T02:57:40.785308  /lava-4162062/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e7bb362d3cd873761179bd
        failing since 24 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-09T02:57:39.339038  /lava-4162062/1/../bin/lava-test-case
    2021-07-09T02:57:39.356431  <8>[   12.224531] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-09T02:57:39.356663  /lava-4162062/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e7bb362d3cd873761179be
        failing since 24 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-09T02:57:38.318873  /lava-4162062/1/../bin/lava-test-case
    2021-07-09T02:57:38.324995  <8>[   11.204943] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
