Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BED83E2C09
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbhHFOAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbhHFOAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 10:00:33 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B237C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 07:00:17 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e5so7192472pld.6
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 07:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZhFPkyNJ40wEqlxLgzi/4FDqfEPchNidiQjDs1l73LI=;
        b=FDcUosuWwrGlLB1hi+ojGnyJkECWJtV6qV0g9l6GK4vMZLqhumth64zG/V2ZUH11QI
         YQQI66LG0pVIMP7mf+RsSyT9SV/+rhD/HxIoiFEX6iRVpIDCx4A89ZeDW+1tXQei1d3Q
         lMWW7shPEe6Wl1xs0Jkda0EpfZNw9H8mPJ+IpKnX/0JPqZjL5BeHuytK66X9i8VnXc+I
         YguIPCLm3ZfO6PLo/LK1DJOiq1TwJMSjxqZ3tqVJ6SSKzmyRFo4YrZymMJ2tu6FZ9LGl
         viAxHa6bNf1IA6G2MZaVzyUkAtCJlk7TsnpySuky1S1wkDm0PALmqv4LUXFFUnvt94Pz
         BS0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZhFPkyNJ40wEqlxLgzi/4FDqfEPchNidiQjDs1l73LI=;
        b=HoVfcFtmT1aeDUEhxN0YPq7BnyynQTELvvzAAUU3Nlm01dh4Dq+i/qZJKwSrFgnKZw
         6tPEB1krwehloMeYahFFY9xhLFKDntUB2EkD7VrsdHSd9nkyc5nTgeUBqSSn/6xW7HgJ
         cSmGkqKbHfnec6OeCeZgXRGkjB6yzqKclvMgW4FcNXuSz9/UcV2QnAeOGHrG04So1mJI
         NfuqZSb8dKrh28VgZTp3AtxQALLqOxGs5Rx0d3xVhBehaA2/PvOi7qJCkQXhO7yqXdLK
         fmec/dT+/5AtVfga77f/qysRzdpT23pTFDNG2l3k3R5mjgW+csHNfYBQGAkMqeZDKiJL
         Igkg==
X-Gm-Message-State: AOAM5335V2Fd7+ydDz1sPOMrPVUGKFXnmzYCaNYLkqf6uFfRXZJsrp2K
        xuYUO3NEMnU6/OKZwRTmCBSxWapvXLw4lQ==
X-Google-Smtp-Source: ABdhPJy9UjjJ10HL9MUaAxQhUhEFeh3QHUmgZBs4C/2+7x5CEKD+SIwK0LidYn38SG+sTvUgkcAzDA==
X-Received: by 2002:a63:5641:: with SMTP id g1mr961291pgm.33.1628258416903;
        Fri, 06 Aug 2021 07:00:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l185sm2868149pfd.62.2021.08.06.07.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 07:00:16 -0700 (PDT)
Message-ID: <610d4070.1c69fb81.6bdf.67d3@mx.google.com>
Date:   Fri, 06 Aug 2021 07:00:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.278-7-g5a87c3db13ae
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 74 runs,
 2 regressions (v4.9.278-7-g5a87c3db13ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 74 runs, 2 regressions (v4.9.278-7-g5a87c3db1=
3ae)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.278-7-g5a87c3db13ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.278-7-g5a87c3db13ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a87c3db13ae80a9b871d69d0f0937142f1b058c =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610d0d1ab7a0b237c8b1366b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-7=
-g5a87c3db13ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-7=
-g5a87c3db13ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d0d1ab7a0b237c8b13=
66c
        failing since 265 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610d06efd33a676b68b1368b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-7=
-g5a87c3db13ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-7=
-g5a87c3db13ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d06efd33a676b68b13=
68c
        failing since 265 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
