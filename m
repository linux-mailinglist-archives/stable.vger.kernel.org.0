Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AAD222807
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgGPQKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 12:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgGPQKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 12:10:24 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E6DC061755
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 09:10:24 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x9so4078093plr.2
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 09:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rW98JB/7tZwCTdefo14l+QkQdhLUGXcNRCO6EdXng6M=;
        b=Z7D9VsFM0cBzT0pREBO1V6skAB4Ubbvgj5qB5R9A1awdlxio65xbEAZwnMd1T3nKhQ
         dkFeNrWLFlizkZt3APH8A0yHnYcvfl3vr89RaxlwI+QKfV3lp9SzKm7e71ke3SfoAjzN
         IBZ1v1WurPXkTx1rfpaJTJcpNLmcfgTUSsXBKSeoTTVk42Fs0aU+eZ34opn4CX4w4kpp
         UzTu5J8IHviUFi3eoKhVaLFq3NMpxc+yLZTA3iG7ApxhU9yvJxzVthKMgwuNCL1TZA2C
         RUBE4wG+ig55s0EZjeflNelAFjatd+6dFZfo5aLbr9KUAD46XgaWtdD7Vvm5dIjtBW7Y
         XQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rW98JB/7tZwCTdefo14l+QkQdhLUGXcNRCO6EdXng6M=;
        b=uDHBc1mAyDkc97w8eMjcARXDWfVcB/8OIh7l/49WW8bKJ72FCEKG/UXynVpXQUUA7A
         YT+OXY7AH7Zqn7WH05SKrqyjEwCFRtvAiXQ43b6sUhO0x3IAT2wrUlNOXclBBVI12j8p
         sEzX2b3FebJC7igW14lfVs7nh/985IpV6l9+ItZ3DrEHGyRouA1hge0HewllbhroMrFm
         hOmGnIbLkuYwS4MKaIe1xDaCExxzwwvC3+TZx7xBR7wxx7dO1ehj/PxqAqpQ1d4/eywc
         852inMibP592SGzNTTXoQrhm22tgS9WT5Tpdz1301lz+uGWXL9sC8TNpoheiITFe6aD9
         2SAg==
X-Gm-Message-State: AOAM53106xEKVevTWDQJjIO0VyemvTf4ZZ5QtnCs6cu2+I3nmx6IO5L1
        eYXsyq/dmbPnlu11aHSgK2gT/qAeMXw=
X-Google-Smtp-Source: ABdhPJzxbBCiZ9ttG9WKAnPVPkOFQrsS5YsRkGAE/xebTmzt8cmYWjxWgsnQ9c6XUcowxrdCkAsJ0w==
X-Received: by 2002:a17:902:40a:: with SMTP id 10mr4274744ple.260.1594915823289;
        Thu, 16 Jul 2020 09:10:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d25sm5630475pgn.2.2020.07.16.09.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 09:10:22 -0700 (PDT)
Message-ID: <5f107bee.1c69fb81.30722.f917@mx.google.com>
Date:   Thu, 16 Jul 2020 09:10:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.52
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 113 runs, 3 regressions (v5.4.52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 113 runs, 3 regressions (v5.4.52)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig         | res=
ults
----------------+-------+--------------+----------+-------------------+----=
----
bcm2837-rpi-3-b | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | 3/5=
    =

bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig         | 4/5=
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.52/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c57b1153a58a6263863667296b5f00933fc46a4f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig         | res=
ults
----------------+-------+--------------+----------+-------------------+----=
----
bcm2837-rpi-3-b | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | 3/5=
    =


  Details:     https://kernelci.org/test/plan/id/5f10458df6486775fd85bb18

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f10458df648677=
5fd85bb1c
      new failure (last pass: v5.4.51-110-ge41ac96492ed)
      4 lines* baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f10=
458df6486775fd85bb1d
      new failure (last pass: v5.4.51-110-ge41ac96492ed)
      30 lines =



platform        | arch  | lab          | compiler | defconfig         | res=
ults
----------------+-------+--------------+----------+-------------------+----=
----
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig         | 4/5=
    =


  Details:     https://kernelci.org/test/plan/id/5f104750aab0d9caad85bb29

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f104750aab0d9ca=
ad85bb2c
      new failure (last pass: v5.4.51-111-ga4b36fa05420)
      3 lines =20
