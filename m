Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1E1326978
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 22:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBZV15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 16:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhBZV1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 16:27:52 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5302C061756
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 13:27:12 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id a4so6952937pgc.11
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 13:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nU370zuRq//xwsGqGgFsptf9iimYCjfprZL42TLWc70=;
        b=Orc7NZgUyduIL47occztW/w3aQbyeCsCK/jYIIQSZ85a5cheGSnx6XbbiTVJ8wNcSR
         qpsEZz1tCZOqo3LmTMyyECy1epeC018kWpch92y/j/qKk8i+jobAEIo2PxstQCqzhdsL
         JoJYeWRRV7mZNsyU8IVv5O4pChsXRsxsc4nklJBeLKd3bICas9Kj1E4Ji6CXeVlful+8
         0QERYU+8oPCuCtkWWuxpqHnQzoHzOXOa1GB7+ZINUwvu6pEfg4hNbHpSWB+PxhLKviLc
         zQtDEf4ug8OXf5dFbFoeOHEgLYMqQbC21PPaNqv9WmgFqD0LF5YCWeS7TYclAihYKz5M
         uZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nU370zuRq//xwsGqGgFsptf9iimYCjfprZL42TLWc70=;
        b=jLjQon/q5KUkh/Q1yr5XBeSTHi1be3YGWwm8qdEnN0i2Fok3pwTQVM6URgzq/MAAL7
         52I2GwPqadYLl27gWfy33E02aMoATjwFaMjDvjEcR6ahZCkEIhlzyxLgixRtxfAIEU01
         GcAuBSR4hSI4yJWzG7OXGhwlb+LLJMcDhzOjiDg9B5Id5u/8lPJu8myDId4z4E47dnac
         bHElYuXMob5OVps6nLGIZTnw8+LyJ7HVw9EIGevjtFwMgimPiTil9Ao7yHf+PB0TOvbD
         iFPzpZ2gLNVxMPEkS2URgMDj2MVl5LuNAUFh28i/YKDY8yf9i8MrPSha1wBWbrWr23rN
         Mlyg==
X-Gm-Message-State: AOAM533zVs+4uM5KjHrhX1AAJhLa+7QY8U3gfb6GgSBIRQUT4hrwiJ7D
        hwHj/trjun/WiM6+EJCeQofDGcMxueUxVQ==
X-Google-Smtp-Source: ABdhPJzFa/ScIIx6ejUrjN390/r+uGfY8hshW32IWG8C/Rn2/1JiZ6b516totUueGQgT7VqMIj//wg==
X-Received: by 2002:a63:f311:: with SMTP id l17mr4645363pgh.349.1614374831285;
        Fri, 26 Feb 2021 13:27:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 9sm9472813pgw.61.2021.02.26.13.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 13:27:10 -0800 (PST)
Message-ID: <603967ae.1c69fb81.784ab.5c9f@mx.google.com>
Date:   Fri, 26 Feb 2021 13:27:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-17-g4bcba42cabea
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 76 runs,
 1 regressions (v4.19.177-17-g4bcba42cabea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 76 runs, 1 regressions (v4.19.177-17-g4bcba4=
2cabea)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.177-17-g4bcba42cabea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.177-17-g4bcba42cabea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4bcba42cabeaf4c97bb4b7842ad72b180581a040 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6039345951b5e0de60addcb1

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-17-g4bcba42cabea/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-17-g4bcba42cabea/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6039345951b5e0d=
e60addcb6
        new failure (last pass: v4.19.177-17-gbb745d19d4750)
        2 lines

    2021-02-26 17:48:00.960000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/107
    2021-02-26 17:48:00.969000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-26 17:48:00.983000+00:00  <8>[   22.868743] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
