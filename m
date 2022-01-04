Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EB0484630
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 17:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiADQtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 11:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbiADQtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 11:49:33 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6CAC061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 08:49:33 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j13so27499528plx.4
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 08:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tjTgcn8q8f6YtEcRyOw2BmvKlcfwmx91tDgTeRrzWdE=;
        b=A3Q92glFOUi8MGV6iTPNLPyNHg8diYDNHW9VQIaKvBLPdgfisS4+aRsGTmcoz5sSXk
         5oN5ZQPNlSKbhf1S+fZ3nl/s9VY2upBVDzgRmxYCx0FNFOsAcBWy5eN5+YXfd+czY2wp
         BTRddwgrfYutN5K0ofeFKI3aAnqq0aHigk10Sca0QVlStBYLGDFT7xNI4HzWF31sHx6B
         gTRzOQWxlKxseP38p2SWKHYa3e2BS2/f4163B3mjJCOgog1ABI1KhQ8ZfMZWe1eTMrFo
         ygFrrqDwIgXHyRPD1Plo2RK/j1wrNuSt70/7L/xtDPa99pgwwfp2SK4u2aoO31iRMKpA
         C6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tjTgcn8q8f6YtEcRyOw2BmvKlcfwmx91tDgTeRrzWdE=;
        b=Xi4X+edduxd3sR+hpcyFV0t4CYdYCAvGY+HWeu0DGJ1wY8GqSAawy8EATT5bv5WDNB
         e/ahthwBCVMjavmuGjDI8EdJCVIYtrs/SKfz5dbuCZvVyrTKhmd9qAr4ZvsTpqmxIR77
         OfsLMkMxjL2A3aM9Pw7Q8fnAXSdoAumZQKsTTwpd0Um3/iUVcliugOL5kG7ulUMZ5JzI
         wP0dChpD1433d7g8wuVelkfK458TLHNuO1/X20zS3jL4oTn6kUnN1G/USbsmUY9lFaPx
         frAwKn+UEj5GMSmQOBTGNhC37YxeKu4ZGgzWnbLzGVt4+kOnpxrqepoAWpdvjxl21I7I
         JRoQ==
X-Gm-Message-State: AOAM530uACHOGQNwsguujyfz81/15J2PtpTZa7/ivXKS06Bf5xHV+4mU
        T6ymxgVgdaps48PAqyV7vCKzpTOMteg9tSt1
X-Google-Smtp-Source: ABdhPJyLVODhuUmcW9BBYvFaWha/DURK9mld9LRZGltrtM8jK730bykxksLIojWEx2/BcdULJlr2+Q==
X-Received: by 2002:a17:90b:4f43:: with SMTP id pj3mr61481380pjb.239.1641314972766;
        Tue, 04 Jan 2022 08:49:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x31sm44838485pfh.116.2022.01.04.08.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 08:49:32 -0800 (PST)
Message-ID: <61d47a9c.1c69fb81.8bda6.51b8@mx.google.com>
Date:   Tue, 04 Jan 2022 08:49:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.223-27-g41037988c76f
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 1 regressions (v4.19.223-27-g41037988c76f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 1 regressions (v4.19.223-27-g41037=
988c76f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.223-27-g41037988c76f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.223-27-g41037988c76f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41037988c76fb7f0b16c288df4af0e7c8226a8ae =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d449a2781f230637ef6802

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g41037988c76f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g41037988c76f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d449a2781f230=
637ef6805
        failing since 0 day (last pass: v4.19.223-16-ge86e6ad8a5c1, first f=
ail: v4.19.223-27-g939eabea13d4)
        2 lines

    2022-01-04T13:20:18.477110  <8>[   21.164154] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-04T13:20:18.522690  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2022-01-04T13:20:18.532019  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
