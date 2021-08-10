Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CB73E7E06
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhHJRLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhHJRLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 13:11:04 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113D0C0613C1
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 10:10:42 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id nt11so10866648pjb.2
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 10:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fvSavD1R9IGFaSY2WG908sXhsrHl7Ay98CmqzspOKxY=;
        b=DJsJpUf6iPnsIvNkkfH69DrxzqaTWR3Fc8Hn6Opob/lRqzL1duVh6lLhU4+MD7jOi1
         agy3A4w8wKceg4nXwU4zETnDSfYUvRJr1Jkk2NPhSmgXI37ANBDQc5HAUAqFOZZvC7kJ
         yEHAxeN5HR9LlY/WbXq1TGoPenFr2P90W8dw1UfrZ/vYmih8XI8cEAZ3+jRfAmWJVqru
         yXPN+Sl8+LRDxOr30B6qxKJA1NX/vwyEzijdLbVRsJ6rlhCY/Os1di3sS6FBpvU2nkzI
         tn4DjSPoREd9lxVQkwOi7WXxWMUKlQtb8UHReCuXdPSVCxiKv1bsPHFD0dPWGeL1DKKO
         RrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fvSavD1R9IGFaSY2WG908sXhsrHl7Ay98CmqzspOKxY=;
        b=l7tvqj7en8LyOXSVG9ck3rVRIOjnhLb4Rr/B1kmwLY55aaoNbJDlecygjLQ/ViDOaj
         GGrpHGtgStT5TTC0mgE0mgUYINYigKoSB+jEy06N58DGBdpGPjCeOlUbRBhQBzlybExj
         z8CYNJGRfaIt1Fn5BFuso0yuZ9KmN3XiHutXoquAtQ8hjUmf4/5UOkTR65VDZuElq/Ou
         ABSZ35cB6jGQ0hYx/+FqT2kApMqQpRdBCnhxAieS3DwqQHYkqwhC7kGwfiYEn7JrrGbh
         FrPe0t/O+vDyLjAxz4UjaOe2J6NpfQwHw5UPIhFDGIwUakITKAvOgSf8+UXJ0qg2u5dL
         W93Q==
X-Gm-Message-State: AOAM531O5PpcXuiybUQJ8aPmA5w2+8JkBl6Hwj9n4kuZDWPkRLjG4PXM
        DULnjydJd5yvAz298WDuv1f4ymhfNpEHxUgc
X-Google-Smtp-Source: ABdhPJwik4bKf/tjc6/ygFIjWh8M6qIzUiPwnxsgYUDVGAAA0jdUE7x+PuzFyx6mi8zkHSRI5imVTA==
X-Received: by 2002:a17:90b:17c3:: with SMTP id me3mr5844413pjb.203.1628615441405;
        Tue, 10 Aug 2021 10:10:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3sm21267750pfn.76.2021.08.10.10.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 10:10:41 -0700 (PDT)
Message-ID: <6112b311.1c69fb81.4f5ac.e760@mx.google.com>
Date:   Tue, 10 Aug 2021 10:10:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-125-ge4a7485167f0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 154 runs,
 4 regressions (v5.10.57-125-ge4a7485167f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 154 runs, 4 regressions (v5.10.57-125-ge4a74=
85167f0)

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
nel/v5.10.57-125-ge4a7485167f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.57-125-ge4a7485167f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e4a7485167f0bfffb3b49b00a9e3ab3b82254ff9 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61127d5aa24d9837deb13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-ge4a7485167f0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-ge4a7485167f0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61127d5aa24d9837deb13=
666
        failing since 40 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61127ee36f8abe4be2b13675

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-ge4a7485167f0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-ge4a7485167f0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61127ee36f8abe4be2b1368d
        failing since 56 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-10T13:27:55.584896  /lava-4341858/1/../bin/lava-test-case
    2021-08-10T13:27:55.601658  <8>[   13.165338] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61127ee36f8abe4be2b136a5
        failing since 56 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-10T13:27:54.177808  /lava-4341858/1/../bin/lava-test-case<8>[  =
 11.740184] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-10T13:27:54.178365  =

    2021-08-10T13:27:54.178853  /lava-4341858/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61127ee36f8abe4be2b136a6
        failing since 56 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-10T13:27:53.140155  /lava-4341858/1/../bin/lava-test-case
    2021-08-10T13:27:53.145450  <8>[   10.720389] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
