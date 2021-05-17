Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70664383C9D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 20:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhEQSq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 14:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbhEQSqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 14:46:24 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A982BC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 11:45:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h7so3691117plt.1
        for <stable@vger.kernel.org>; Mon, 17 May 2021 11:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nqVuMW2LzCRU0XfgFRK2xdDn43AUPHFjxzXeaJY8wt0=;
        b=hJpFCb4Hqff54k9Dmf2TU2DHXik4ZdgqjY3Z2C7oi1PafHR8e58QBXrH7CDZZPoo+X
         Z66eI4osmzJZqU3bdEeUK5Xxu3nhmh4TAwVbtxCwBc1pSE1hNJM9ZEIREQLkfTQabzCd
         tnKHetVEGm6YzQJHV2/RxO0fqD8QyDxgmu+XR0+6h0k5PZZOgKT6RsaD8kZX0lNsrtuJ
         w3cbtN21gzN966576FybhWw1tGwmFuurmKFyADk/ytHlkOlsRPJ3eF3gi5rrjJKbktHw
         000eZZ7UFODb9GNdwA7aJh3tsemP+PBMd7Iv40rh2tCjslpdjdxTn7tYTD6p0qz+zKSy
         I5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nqVuMW2LzCRU0XfgFRK2xdDn43AUPHFjxzXeaJY8wt0=;
        b=FLaXWn7Ok49Nqk4hIVLX3GNzxcXIBU9h0XzmyaR8eIfg9F7D6sWRDoPgotgeuXpl2L
         HagayQIQjCjIJvJpB9cLR/E/AD0josjrtDsWZORyED/bgQZ6rMwiHAvinANXXqEQNqFC
         9oMqfG63/uJ0JPH4ytqTIXuQcVHpbUKt2nJVtd0KsINEPbzXXG1wc6xJI3BVI6MjPRV2
         rkhMpKevIiFguZ3LtDwMAXC41FuzZk3E8Ljl5EtBPtvbDIohhl/8rVq6JnCzAuF+9azK
         JMPjEzPVwB2TZFEU+aiZTiTg+N9K7GqyMIE+JNECObwaOBZiiHnWfHep3JTvkK4Sg+Eq
         HkvQ==
X-Gm-Message-State: AOAM533sUQiIPxcOopLkHvPfmf148X+YqMnf7Wp5mHOEHWXQr0mJ7x+h
        XHfclgT3CbtAQwX9yonVTkTlBVqbdCTqE1l6
X-Google-Smtp-Source: ABdhPJzQQpuYFW7x1OW0a01nswBGWt4XG5/1MhjwFOsXMf2T2y985wna7WalyILca3iBtTywFu4X4A==
X-Received: by 2002:a17:90a:e552:: with SMTP id ei18mr555038pjb.72.1621277106900;
        Mon, 17 May 2021 11:45:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h8sm5216032pfv.60.2021.05.17.11.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 11:45:06 -0700 (PDT)
Message-ID: <60a2b9b2.1c69fb81.cdbd5.078f@mx.google.com>
Date:   Mon, 17 May 2021 11:45:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.21-330-g6d09fa399bd5
X-Kernelci-Branch: linux-5.11.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.11.y baseline: 133 runs,
 4 regressions (v5.11.21-330-g6d09fa399bd5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.11.y baseline: 133 runs, 4 regressions (v5.11.21-330-g6d0=
9fa399bd5)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.11.y/ker=
nel/v5.11.21-330-g6d09fa399bd5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.11.y
  Describe: v5.11.21-330-g6d09fa399bd5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d09fa399bd51fced0a3ad760d2b28f3cfca1678 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60a288ee99f573763eb3afa1

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-330-g6d09fa399bd5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-330-g6d09fa399bd5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a288ee99f5737=
63eb3afa7
        failing since 0 day (last pass: v5.11.19, first fail: v5.11.21-311-=
g7cfd36cbe8c6)
        4 lines

    2021-05-17 15:16:00.067000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-05-17 15:16:00.068000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 39.022869] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-05-17 15:16:00.068000+00:00     =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a288ee99f5737=
63eb3afa8
        failing since 0 day (last pass: v5.11.19, first fail: v5.11.21-311-=
g7cfd36cbe8c6)
        47 lines

    2021-05-17 15:16:00.119000+00:00  kern  :emerg : Internal error: Oops: =
17 [#1] SMP ARM
    2021-05-17 15:16:00.119000+00:00  kern  :emerg : Process kworker/1:1 (p=
id: 61, stack limit =3D 0x(ptrval))
    2021-05-17 15:16:00.119000+00:00  kern  :emerg : Stack: (0xc26e7d58 to =
0xc26e8000)
    2021-05-17 15:16:00.120000+00:00  kern  :emerg : 7d40:                 =
                                      c36ab1b0 c36ab1b4
    2021-05-17 15:16:00.120000+00:00  kern  :emerg : 7d60: c36ab000 c36ab01=
4 c1439260 c09cdfb8 c26e6000 ef8726c0 c09cf378 c36ab000
    2021-05-17 15:16:00.121000+00:00  kern  :emerg : 7d80: 000002f3 0000000=
c c19bb05c c04a0a50 c26e6000 c36a9000 c36a9050 c36ab014
    2021-05-17 15:16:00.162000+00:00  kern  :emerg : 7da0: c1439260 7f2a208=
b 0000000c c3d36d00 c3709480 c36ab000 c36ab014 c1439260
    2021-05-17 15:16:00.162000+00:00  kern  :emerg : 7dc0: c19bb040 0000000=
c c19bb05c c09db8b8 c1436ea4 00000000 c36ab00c c36ab000
    2021-05-17 15:16:00.162000+00:00  kern  :emerg : 7de0: c22db410 c32373c=
0 c3982080 c09b13e0 c36ab000 fffffdfb c22db410 bf044134
    2021-05-17 15:16:00.163000+00:00  kern  :emerg : 7e00: c3d36340 c3991b0=
8 00000120 c32373c0 c3982080 c0a0ba94 c3d36340 c3d36340 =

    ... (34 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28a219092471cccb3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-330-g6d09fa399bd5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-330-g6d09fa399bd5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28a219092471cccb3a=
fb2
        failing since 2 days (last pass: v5.11.21, first fail: v5.11.21-229=
-gd46f592c4fca) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60a289957b958937d0b3afb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-330-g6d09fa399bd5/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-=
rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
1-330-g6d09fa399bd5/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-=
rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a289957b958937d0b3a=
fb4
        new failure (last pass: v5.11.21-311-g7cfd36cbe8c6) =

 =20
