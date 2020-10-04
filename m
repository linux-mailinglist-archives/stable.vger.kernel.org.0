Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83B32827B1
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 02:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgJDAyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 20:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgJDAyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 20:54:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D71C0613D0
        for <stable@vger.kernel.org>; Sat,  3 Oct 2020 17:54:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u3so3185960pjr.3
        for <stable@vger.kernel.org>; Sat, 03 Oct 2020 17:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XazXZhJSzqNqyDpZnZfNvAt8DmM3rM+1iAF0uaROjnA=;
        b=tptIGCZs5hD/FUJ16wsZu/B5492nfL3LO2m0mF30FxTaAZdYFf20MmM/DhZ7PNRWTq
         302IA+WpN6Z6a4h+eNH8d/YnW8QhnieiVObnCIBKYvAvY5g2frwJYIuyx1RHLt9XtfVi
         vyJUfknh0syfTFinRgu0NlTpKgR5JmUzI0sp2FOBpoa9X0dvX+SqxZpnEsHP7yk9OXtx
         0zgZ25vfh0+PtZJry+cCjgG4bhByKjXGK7720fy/zDTgrbZdnrJOK59LG9tfDAvo8PqL
         fPhr/RACY/ymfvO2VbsNs/bljnPqZWO7mQTTRxnYubhy60azjJJPLXBS+eE9Bo6B+CXY
         +LPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XazXZhJSzqNqyDpZnZfNvAt8DmM3rM+1iAF0uaROjnA=;
        b=gEB4xA3zpYrfE9lq5MWlCJoVl2DKrF5nco2dDf2YM8ea73S/eUzq5th1VNE0Y929EP
         igKOIxsa/7x/pYNCpgmxf47bPkH+6K9V3ZWAlgpZdqTXEEie4g3zPy2BXBORisDtAAG6
         3Lu5bacPno9o0Rk8mCRWWndBEG5y2B4Z7AziwzH2Ad2cQitih2upitYs8iMvhk5zmF9E
         IQ53CL9lPhQFzAR3HL/e3aRyBoUKU20S6IYJxcnVN9Ep0MReIWB08QscphpvQSlKCSpp
         Sky06/r+n5KIjxUnB0PxuAHCLTPPdd+oRU8NnU0HpOMM34s/YkImK5s5MoA9p2KmlNDf
         fMeg==
X-Gm-Message-State: AOAM530S5X4FfJmn1O1Eu5ZpsgNw3POWRBLCNeU2H40FG9txgPBamFpt
        jJrkG3o/sSKICFooLebt0xAmXOknX33tRg==
X-Google-Smtp-Source: ABdhPJygPk41kQ544G1ib3QlnbiZgqG4ohbPgTIzGUzoZsoqnK19s0bdwaoNEohHM7oknm/3nb2MuQ==
X-Received: by 2002:a17:90a:d58e:: with SMTP id v14mr9865669pju.66.1601772874010;
        Sat, 03 Oct 2020 17:54:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q66sm2571129pfc.109.2020.10.03.17.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 17:54:33 -0700 (PDT)
Message-ID: <5f791d49.1c69fb81.df8a2.4d72@mx.google.com>
Date:   Sat, 03 Oct 2020 17:54:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149-5-gc7c6637a3e67
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 122 runs,
 2 regressions (v4.19.149-5-gc7c6637a3e67)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 122 runs, 2 regressions (v4.19.149-5-gc7c663=
7a3e67)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.149-5-gc7c6637a3e67/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.149-5-gc7c6637a3e67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c7c6637a3e67e3a5ec47681b68c58848d3c4a39d =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =


  Details:     https://kernelci.org/test/plan/id/5f78e23de32d5317ce4ff3f3

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-5-gc7c6637a3e67/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-5-gc7c6637a3e67/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f78e23de32d5317=
ce4ff3f7
      failing since 0 day (last pass: v4.19.149-4-gb110045ffdd5, first fail=
: v4.19.149-4-g55b73b3448d7)
      1 lines

    2020-10-03 20:40:38.597000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-03 20:40:38.598000  (user:khilman) is already connected
    2020-10-03 20:40:54.135000  =00
    2020-10-03 20:40:54.135000  =

    2020-10-03 20:40:54.135000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-03 20:40:54.135000  =

    2020-10-03 20:40:54.135000  DRAM:  948 MiB
    2020-10-03 20:40:54.150000  RPI 3 Model B (0xa02082)
    2020-10-03 20:40:54.237000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-03 20:40:54.269000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (371 line(s) more)
      =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:     https://kernelci.org/test/plan/id/5f78e4dedc1c17aa4f4ff3e5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-5-gc7c6637a3e67/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-5-gc7c6637a3e67/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f78e4dfdc1c17a=
a4f4ff3ec
      new failure (last pass: v4.19.149-4-g55b73b3448d7)
      2 lines  =20
