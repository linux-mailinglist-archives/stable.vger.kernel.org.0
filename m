Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4622827CE
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 03:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgJDBWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 21:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgJDBWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 21:22:07 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C435EC0613D0
        for <stable@vger.kernel.org>; Sat,  3 Oct 2020 18:22:05 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gm14so3431563pjb.2
        for <stable@vger.kernel.org>; Sat, 03 Oct 2020 18:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wriX5uRah2yu50qYCZKpuPo/RG1Cnx8YvTlkLNCOPok=;
        b=l0vAByNM2IP6RlvCrKNH4dgS8dkBJjuCk+NXwyhALzKjwwCw/vIpTrvWwMZdj5AzrD
         3g+seJNlUPCmVylWhOsMlStWqMfhVUBnXPHOAKFJRCrR9MNM7+3a+wf5IO3agHNC+AT4
         StVEcauuza+oIYD7ZmDC/AxzrMBrH4yxy1/eRGRgBzu7+LVmBZOeo4a52VYu0oAG+/Pp
         EQ0JaPZ0dmSGnHJUAPp5FrLqpy1ijVEE2/Y1pPoLzUwep/XyA3um2cicHJeYcAe9L+H0
         6iKgPbldcKP14rqov7SSNTyQNJdPNkr8cl5lBBrroNaBYovK8+vrLSRj915m//4gDuzo
         7u4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wriX5uRah2yu50qYCZKpuPo/RG1Cnx8YvTlkLNCOPok=;
        b=D2YBThY2TryFF16n7DptK1Hg7EqJlWEzlBzTCN8UADotireUPF7nRF75HqG4oFGVnb
         bK4cXB05nWimWkzBIfTyTQDWs5n6j+Yf720gMLSvp06KgH26k+Z2NX2eeNauPKUFyreY
         Bgmy0+qisKhgjo8uFZ0BNX0zg4lVuR1DmDhVQalY33//19NBuaAVBZpP+3XvpU6b2NYI
         6YWa4fnRjayrUFyq/3jGGd07nEri2nXEejVhSQ04+NV9jQ/kYj/QT7TafAWQIvlWD2RC
         ar1VBJsI1uF5Jz6nhXu+EMG7Eor8H3CGC24LKJXOlD1DXFeM1zII7y8cii5zJeX6aVnP
         8/Dg==
X-Gm-Message-State: AOAM5325JWDZGXTytpktDKHMffDnQ/4FySmfKmV6AUb6MNTLA1QX3+Uq
        jl3V2ZuWeAHBwYwpi4Zu+vyNnG5z4gze7g==
X-Google-Smtp-Source: ABdhPJyKukc/wx2YFnIf61bnDo7igSevRlQ4MqdGRIxS0n1vFw7EYHzobIPlPnaymwpFHzWm7nZvAw==
X-Received: by 2002:a17:90a:cb86:: with SMTP id a6mr285211pju.161.1601774524876;
        Sat, 03 Oct 2020 18:22:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i25sm6463219pgi.9.2020.10.03.18.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 18:22:04 -0700 (PDT)
Message-ID: <5f7923bc.1c69fb81.f2420.cafc@mx.google.com>
Date:   Sat, 03 Oct 2020 18:22:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.13-3-g58c57ca2b2dd
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 113 runs,
 1 regressions (v5.8.13-3-g58c57ca2b2dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 113 runs, 1 regressions (v5.8.13-3-g58c57ca2b=
2dd)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.13-3-g58c57ca2b2dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.13-3-g58c57ca2b2dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      58c57ca2b2ddf5cb3954a5b603c85df5fa12becd =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f78e94ff1f4831a424ff3e1

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-3-=
g58c57ca2b2dd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-3-=
g58c57ca2b2dd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f78e94ff1f4831a=
424ff3e5
      new failure (last pass: v5.8.12-99-g7910fecf197e)
      2 lines

    2020-10-03 21:10:34.789000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-03 21:10:34.789000  (user:khilman) is already connected
    2020-10-03 21:10:50.656000  =00
    2020-10-03 21:10:50.656000  =

    2020-10-03 21:10:50.656000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-03 21:10:50.657000  =

    2020-10-03 21:10:50.657000  DRAM:  948 MiB
    2020-10-03 21:10:50.672000  RPI 3 Model B (0xa02082)
    2020-10-03 21:10:50.758000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-03 21:10:50.790000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (385 line(s) more)
      =20
