Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8D324783E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 22:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgHQUkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 16:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHQUkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 16:40:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98585C061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 13:40:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id i92so8376495pje.0
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 13:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5Yu5zLsUeqQortGv3qDuZNU77cW2j6ZfckMxxkUl5sc=;
        b=AfvjejAV1lmWKFEibugAKrzcFr94oU0OD7NjVEinIVDYD52RY28H3bNJyp4v06fmNN
         Y4TGI8BFIe/+zOfbqS9Uy1q9rfCcNiroZ7rox7Xps/9dl4LPx2yErwZVVCvxoRPxFSDA
         Vcm2hYi2UCEk/X6Wz4pI5HocEkF+3hxJGH9E2Rc73PLFPRZy7HiXY1xhxJciA4sGBf2t
         ynR/bkJ1FjXzYMvZG7yaIUT5kz8on3Tj0X5jtAX0t6mvZ83wS7yjTKHwU1gqQL2Z8LOR
         pFQfWhYoO8tf6nPtdmf6p8QN+isVzNYRsMvXT1ARUedSwbPbMx7EOR/WPgyfgpCgxgPw
         kFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5Yu5zLsUeqQortGv3qDuZNU77cW2j6ZfckMxxkUl5sc=;
        b=IDk/cTxxRMVWa5eozdOEFJEfvkRq+Xm/7Sgu/lFqnAYdftnZjYBcllpzpGQHFVPBsx
         L2rlZRHwoTjnEIBueY6jpKMRcD0SVyycO93zYUGvoMj6zSZTMG/XkXO2kk0wTHLheJL6
         YwPMK3ggvcCshIw9N+OlUbxzlrXZVqqIzRjuvxTkHqka/L7QxNxM/VWbAzluTk3vLvxk
         8iiju83WKoEVUM2Vov1PNMsjz0GYslcB2KEiCeD6j0JnrZkC7Pe2kPGq/IFj0jihEwXv
         5Sn8qTPye2z3POJH0ffnAkJuFA++RZNEL/vmZF0WkEqpn+hJkyP1JVCehOTldDD+9EHm
         OQ2g==
X-Gm-Message-State: AOAM533+YWpC1M/wegITwlIZycvKFGyoIXGkAcWnNFteNK5fY4h8ujrJ
        eDqXJP5HGZYCcls7kxVNvNxDBV/FcmLA9g==
X-Google-Smtp-Source: ABdhPJz6nQbzSer+7NMit0CwzR87R5WeEn1zFPL+d3QinAiGsUB0KiLFD76yEcBY/Ety4d5BlO5ByA==
X-Received: by 2002:a17:902:a585:: with SMTP id az5mr12642350plb.172.1597696807213;
        Mon, 17 Aug 2020 13:40:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b25sm20846241pft.134.2020.08.17.13.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 13:40:06 -0700 (PDT)
Message-ID: <5f3aeb26.1c69fb81.8ecf0.2e1d@mx.google.com>
Date:   Mon, 17 Aug 2020 13:40:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.7.15-394-g833b53db2607
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 193 runs,
 3 regressions (v5.7.15-394-g833b53db2607)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 193 runs, 3 regressions (v5.7.15-394-g833b5=
3db2607)

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

sun7i-a20-cubieboard2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.15-394-g833b53db2607/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.15-394-g833b53db2607
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      833b53db2607bc32cd4574e9cf2ddf924310a571 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3ab6b36b0ed23165d99a4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
394-g833b53db2607/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
394-g833b53db2607/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3ab6b36b0ed23165d99=
a4e
      failing since 32 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9)  =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f3ab426b4d612cdefd99a76

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
394-g833b53db2607/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
394-g833b53db2607/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3ab426b4d612cd=
efd99a79
      failing since 0 day (last pass: v5.7.15, first fail: v5.7.15-381-g483=
2c39ae70e)
      1 lines

    2020-08-17 16:45:09.977000  / # =

    2020-08-17 16:45:09.987000  =

    2020-08-17 16:45:10.091000  / # #
    2020-08-17 16:45:10.099000  #
    2020-08-17 16:45:11.358000  / # export SHELL=3D/bin/sh
    2020-08-17 16:45:11.368000  export SHELL=3D/bin/sh
    2020-08-17 16:45:12.989000  / # . /lava-286543/environment
    2020-08-17 16:45:12.999000  . /lava-286543/environment
    2020-08-17 16:45:15.955000  / # /lava-286543/bin/lava-test-runner /lava=
-286543/0
    2020-08-17 16:45:15.966000  /lava-28[   19.779539] hwmon hwmon1: Underv=
oltage detected!
    ... (9 line(s) more)
      =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
sun7i-a20-cubieboard2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3ab726f7ffbb7054d99a45

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
394-g833b53db2607/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15-=
394-g833b53db2607/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3ab726f7ffbb7054d99=
a46
      new failure (last pass: v5.7.15-381-g4832c39ae70e)  =20
