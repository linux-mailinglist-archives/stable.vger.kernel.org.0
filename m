Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC2B48395E
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 01:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiADAHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 19:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiADAHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 19:07:23 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA38C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 16:07:23 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id jw3so29931525pjb.4
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 16:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=izcOx5jIsYPmTJMh1HmpfDmc7OV+TftTiINpQExR6GY=;
        b=rctZkO508ZubjXbl+aB/bkJ5twwSbfvv5UgKt4d3PnjhJ+0mE2Tw+RMj86qbXXHPID
         UuD85c6AxXuDhQwvR7Lh03FsWve5L+2KZwV2wwUwwe5SeSJcLDq2rf2CZhJ+OscupHL6
         YxY/mAAkGDvj8QuqJuvHRLI5CcELek7Mgd3NAkZfq7IPbdkhdaL0W+yMQlZB1FJFujBD
         g0B2MAXZVR9zP4jWzmUs63y/JgqZSsXfI8zzKR1hgKIiPOjtxM2f0Lx5IfwuTAl1wH8Y
         MSRUVkDklCavrs42BuFwDLZ5srOQ0ZXwL7NqKBg0ya9xabWjK6flUzYIxACDf7ujMUcG
         RrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=izcOx5jIsYPmTJMh1HmpfDmc7OV+TftTiINpQExR6GY=;
        b=BpGPJU8jfVX2NX329K7kVhWQkpaOrkCuFMeKWjBhlkTsnhka7EDgHrMxURskqO4WXR
         MYjYypqyDUMkkNgdk1O6YOUs4Z48fZlBHIroNDBW74FCYZ0OIcFJXIOx4qHEufuJ43uE
         cDjiy6A8H6mzthCMIBx4QaUZzJs5j/HDt25LnKzWVGaA5wKwdEBGJzybuA1Gj3s6Q96+
         79k490xXPzJfh20qDVFuSPemaMxwxZHb02cJP88QNCs0NCTE7oHQ6QRT/WKty+up6LDm
         PQd6RAZM+pYE3BizDCV9VpdDnBrubA+P31an2ZPHbDe5e/SneqgWXOwpMDEZEh54eEDm
         1pcA==
X-Gm-Message-State: AOAM531fZ7/okmdzz1w6wCTHCVYC6cF6IxnEWYlMgQbUll8IFpUaiWS6
        YZo9xbpF1xjj2KF5P1xZhBzPQVDxbTgxRfVX
X-Google-Smtp-Source: ABdhPJzM2KavsYakrvfjWwWt++5R+LBWx0zKZjwnG+GyuYXxRIlVfUrst5bqGWRKAkQFrEtVgj2RsQ==
X-Received: by 2002:a17:90a:5417:: with SMTP id z23mr10006687pjh.158.1641254842517;
        Mon, 03 Jan 2022 16:07:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e7sm19681252pfv.9.2022.01.03.16.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 16:07:22 -0800 (PST)
Message-ID: <61d38fba.1c69fb81.96be0.0506@mx.google.com>
Date:   Mon, 03 Jan 2022 16:07:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.260-19-g0db94ba85930
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 94 runs,
 1 regressions (v4.14.260-19-g0db94ba85930)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 94 runs, 1 regressions (v4.14.260-19-g0db94b=
a85930)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.260-19-g0db94ba85930/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.260-19-g0db94ba85930
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0db94ba85930a2ae6df847ca94278ce655ed8964 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d35ddd55a64910b7ef675f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-19-g0db94ba85930/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-19-g0db94ba85930/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d35ddd55a6491=
0b7ef6764
        failing since 0 day (last pass: v4.14.260-5-g5ba2b1f2b4df, first fa=
il: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-03T20:34:19.311943  [   20.027099] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T20:34:19.355497  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-01-03T20:34:19.364033  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-03T20:34:19.380851  [   20.097930] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
