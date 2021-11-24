Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC6E45CC6D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 19:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243771AbhKXSun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 13:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbhKXSu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 13:50:29 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1348C06174A
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 10:47:19 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b13so2615745plg.2
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 10:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TeezqBsgb4G9O82qfWdtyUeeEd4i0Mm+xBCcPcuGNxQ=;
        b=Nm6jFL8ectnLYqVUsgFcqa2n7REwgtfLVedsKxjt9GCdr9OX2rHd3VqW4GfMCafK9t
         L8dc8CFx54QDucZih2nVMwiyk3g5Hmvyo+OVrjzIt5EUP0SR/Crvjr6wwxXVjrVRPCuD
         vne/1mkZ2AA0DzDSeaM95tMEyLDKE+zAM+x/N/NB6rOOdxS7zU1XxuXn872tX6ZzAzNL
         q7Xp548q/n7EGCTh2Bt1q8O6zp3AV7Mn7eQ8ZcAum1FIhO5fXCPu1AeGgS0bSPdfX+21
         DXxlKNXRdYxvxiwQwe92CycYalK5uo/4qOnG+mG7QCIE67DBfqKbdyXdGKe7k+TFNyPT
         LgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TeezqBsgb4G9O82qfWdtyUeeEd4i0Mm+xBCcPcuGNxQ=;
        b=5m1ZcF0SiDSIbn/QGXpAEtvJ37nus8gd6NfPMkn8/U4w1g0Mefe9JtDY3Wu7oEWk5D
         rtBmlIszvvwFdaJv/zpJebXScXef7it4V/EFHD7bM/eYh1jcNQM5hULLDxqpBVCIM6US
         uOjr8E1CKBnFIDL3Ns8CwWh/3HD3kVMZjtu2v8eREAzzXyM7FP0GINnJN3KdSvHTdeTL
         MTv7xMy+PZPB/NEuWdq/hNEfpWfnthCqCFLvn90zbGB9cK7w3QhoysLW8DHGKVvVa78B
         hWmWrV+bSvoTLerz8yns4eCfntQK8qqljrdFp2KriDrGPgqgrKfrmTvC+U811D6kXgxn
         qRtQ==
X-Gm-Message-State: AOAM530vztyeGmB+Pe+W9lgHe6tlZ87hpVEmde29UeXsS8xxQ2REvn8S
        pB6i1qRx0hqROm0j22UwSTcfiVp80W3mNOnGB2s=
X-Google-Smtp-Source: ABdhPJw4Egsww1l8cEENZoUM0jtCKWn8Oe1MbDt1FaWy179jByD6Ei+sHQmtGDMv7SHrdZ7NpwMFFw==
X-Received: by 2002:a17:90b:4a50:: with SMTP id lb16mr18617989pjb.37.1637779639145;
        Wed, 24 Nov 2021 10:47:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l15sm443600pfu.149.2021.11.24.10.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 10:47:18 -0800 (PST)
Message-ID: <619e88b6.1c69fb81.dde00.1c02@mx.google.com>
Date:   Wed, 24 Nov 2021 10:47:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-206-g073a61fe6d5a
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 117 runs,
 1 regressions (v4.9.290-206-g073a61fe6d5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 117 runs, 1 regressions (v4.9.290-206-g073a61=
fe6d5a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-206-g073a61fe6d5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-206-g073a61fe6d5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      073a61fe6d5abe3b77d6b88b35ae2bf52f256d02 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619e4fd9f549075b90f2efc9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
06-g073a61fe6d5a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
06-g073a61fe6d5a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e4fd9f549075=
b90f2efcc
        failing since 0 day (last pass: v4.9.290-204-g0f8512aac86d, first f=
ail: v4.9.290-204-g6644175930559)
        2 lines

    2021-11-24T14:44:23.845243  [   21.342071] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T14:44:23.888065  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-11-24T14:44:23.897199  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
