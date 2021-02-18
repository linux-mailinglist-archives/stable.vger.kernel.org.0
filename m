Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F4531EDEA
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBRSDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhBRPaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 10:30:05 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B92C061574
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 07:29:22 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o63so1355348pgo.6
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 07:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iKZHKaEA2nvX+dqhP04Ko7wKKR3Lp21sLoUCOsIKOfc=;
        b=cpym6hSw9ena0MYQYk8iWWFlxiQ6nlnuV7pNizfbYuctgWx5iqwkRPoaXNPOEFufCr
         FW7h6hkzl2nNirwdHGrWZvrDvrYfn1k55FR0z7t+YyEevkpdVLArIwbq8LoSXAfRHuqB
         wdUHepUFC3AHX7C3IuGmyawK4X9j6CBTQFYqLE5+iMCzMD0d/GoI7TKO+3NkNSeLnmtM
         KDNG98uocnEOzy6c/E0fjonZkyEMXM5q66OYNTL++5hYOJXhAr8R+rOMPMLwfz33mcTh
         JSxHTK4CdE2QQVcpmve2vCUTC+aipOP5dXkJZAS0ymD4wwMVCJM7rElE+lYULcFXJ3Gg
         bb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iKZHKaEA2nvX+dqhP04Ko7wKKR3Lp21sLoUCOsIKOfc=;
        b=lwk046tU1Cb7cYfWrcfAKEmsCTHvL0mXR4uXsxcOMZ36kQtn6c1VrtY07hzv/r/Isr
         iKJAL5hdoOtGYhqUWBtcmtxuKFwivXnfFEtEjIsofZOcMJmkJlegoFRWmU9B98xfAZmP
         DOGEHjMWRCqpSbSG1OmGrxbvMemK4uWNoYN6AXU0mIqpfmO7T3sPIXe1zqbcYIFRLbnu
         9hfwoYOWCYsazer0n28BSo0hdNxWiHMCtCan0ebHVh0VyDaMZLz+3pg419ibJNmdoEt1
         gvtn8vUnhoU9Xp78GZZV0Y+ifw40xuERg7DHcObrfgPPZDLCvrLT4V7ZNoZGDPjB1UzI
         wV3A==
X-Gm-Message-State: AOAM532aS+dFde2k5TWRz/a5nLGhcc/cZX3sTePjpN7AeQAxYmhxLmMK
        HhveZqm3f37horDAmdSh7W68PwHUN6pgRw==
X-Google-Smtp-Source: ABdhPJzS7cJxOa5jUNk3wWr+jFOmGpO2mQ+0EgZCdRCFWbX58U7dia69F/cMKX0lb0vRlCKIXRgFxg==
X-Received: by 2002:a63:ea4b:: with SMTP id l11mr4339434pgk.61.1613662161147;
        Thu, 18 Feb 2021 07:29:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x20sm6531935pfi.115.2021.02.18.07.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 07:29:20 -0800 (PST)
Message-ID: <602e87d0.1c69fb81.ba40b.de94@mx.google.com>
Date:   Thu, 18 Feb 2021 07:29:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.257-25-gb1ee02351b82
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 43 runs,
 2 regressions (v4.4.257-25-gb1ee02351b82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 43 runs, 2 regressions (v4.4.257-25-gb1ee0235=
1b82)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig           | regr=
essions
-----------+------+-----------------+----------+---------------------+-----=
-------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig  | 1   =
       =

panda      | arm  | lab-collabora   | gcc-8    | omap2plus_defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.257-25-gb1ee02351b82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.257-25-gb1ee02351b82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b1ee02351b82f76faea8fe86de46870795ad92cf =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig           | regr=
essions
-----------+------+-----------------+----------+---------------------+-----=
-------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig  | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/602e5676ef8d856accaddcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-2=
5-gb1ee02351b82/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-2=
5-gb1ee02351b82/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602e5676ef8d856accadd=
cd6
        new failure (last pass: v4.4.257-24-g4944cca282f0d) =

 =



platform   | arch | lab             | compiler | defconfig           | regr=
essions
-----------+------+-----------------+----------+---------------------+-----=
-------
panda      | arm  | lab-collabora   | gcc-8    | omap2plus_defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/602e55693d9d3a304baddcb8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-2=
5-gb1ee02351b82/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-2=
5-gb1ee02351b82/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602e55693d9d3a3=
04baddcbd
        new failure (last pass: v4.4.257-24-g4944cca282f0d)
        2 lines

    2021-02-18 11:54:13.422000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-18 11:54:13.438000+00:00  [   19.291534] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
