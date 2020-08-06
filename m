Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7943323D63B
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 07:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725272AbgHFFBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 01:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgHFFBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 01:01:42 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E32DC061574
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 22:01:42 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id s26so24266257pfm.4
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 22:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bqZrZFN/gw+brU5EyQMGW9X4WoqNtkE9qoA2DLbZweM=;
        b=Flw3MzoZgxuNhTtqitRxtLvqvUMWdvV4N9IMYTx3anlKQ+YCSFcfBtf4RjdR29VO5+
         RSfSM/CMbQYrKGxrDNep4IW2ffagNG0FccH/Cl5bbUWM/72Y2qEaMSlIdzdssm3zvICk
         pFAL00WIBU/Cr76PHEmfj2HT1Bpi0VtC42cYY/IYod20DdmTCM32IM1eFTCLQd0fgb0k
         TokkI6OjGIrwYjbnKez9vhaIDS60A4MuNUUbaLWrez5s5AdAZPSRuNri2q+GaKI6QQDW
         MlYQ+M4saXDiZN6ycXsu+tdUWPZAsqAex6HkO7ZCzNtvcWbIndy0b64220aInu4b0YJM
         UvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bqZrZFN/gw+brU5EyQMGW9X4WoqNtkE9qoA2DLbZweM=;
        b=o4vz/akiG4NxBHPeHpOKFmmuv/yE9OWlOePEwm+RTV/SVOB36fQfKPZ5UeqpL8YzEL
         Ry0TtrvaeLkA3G97E+3P5x+zMCKHKnqSTMicb0pIO6tTMR3QWWNIvVA5S8zIiSCtb/EL
         H/iVM6Kn7PgFsQWUZNjGViwlSbdwZkNi0ylgL+W2IMskh5nUADO1k6coKTwwhFowFN9r
         823+xJ1v+7IF6yCBN5CCV3CfFAgsQ4MtFNcO9788TUwpMK6A2xXBSFnGWFyAaF0ICOjt
         tUEDo+79ePC04iHjs0l5JlUhb/fN2OnmD9cOMN582TJoOqQ7jGNq719vDS5TErrytvy7
         PNhA==
X-Gm-Message-State: AOAM532lqBkD5hdeIBFtCxxTAcutd79IMFSrDqCATejhZxQJFVQMXvhi
        hcfi4f0Fm1HYt2MdDm4WQuYhEl3nmQg=
X-Google-Smtp-Source: ABdhPJzV/6/ev7ub54wa9AoU+l2um8NSCjakfiWwqby2gG27E9u4mervsGL8K03xhf9HJUFGv3kQXA==
X-Received: by 2002:aa7:9a4c:: with SMTP id x12mr6651142pfj.307.1596690097917;
        Wed, 05 Aug 2020 22:01:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b26sm6548003pff.54.2020.08.05.22.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 22:01:37 -0700 (PDT)
Message-ID: <5f2b8eb1.1c69fb81.5e8ef.21ac@mx.google.com>
Date:   Wed, 05 Aug 2020 22:01:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.55-97-g1c4819817cd8
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 147 runs,
 3 regressions (v5.4.55-97-g1c4819817cd8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 147 runs, 3 regressions (v5.4.55-97-g1c4819=
817cd8)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 4/5    =

omap3-beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.55-97-g1c4819817cd8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.55-97-g1c4819817cd8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c4819817cd892724f91e5d253eec5f746243602 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2b5b61e706f22fae52c1dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55-=
97-g1c4819817cd8/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55-=
97-g1c4819817cd8/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2b5b61e706f22fae52c=
1dd
      failing since 116 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9) =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f2b5c15fe04af32db52c1a6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55-=
97-g1c4819817cd8/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55-=
97-g1c4819817cd8/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f2b5c15fe04af32=
db52c1a9
      new failure (last pass: v5.4.55-87-g47b594b8993f)
      2 lines =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
omap3-beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2b5eb121fdbb72d052c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55-=
97-g1c4819817cd8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55-=
97-g1c4819817cd8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2b5eb121fdbb72d052c=
1a7
      new failure (last pass: v5.4.55-87-g47b594b8993f) =20
