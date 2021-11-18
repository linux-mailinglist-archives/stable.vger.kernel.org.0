Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70C7455CEF
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 14:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhKRNsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 08:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhKRNsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 08:48:39 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4E3C061570
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 05:45:39 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id v19so5279676plo.7
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 05:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rUN6YuuaNsbiLscR/LVT4NmkgS5ycusdU2cma2yn42s=;
        b=m0FjMX4UwX5tcvJBl6TEf76vJBbcx4V6x9eLVCIOOwO9d3jFgLgkZemJVMpYc0eEZM
         kf0eCigvLEvVxz9UzoAtOX0BLXTwZSb6wc7+YHhly4mji9uzi48DFtFQ1rl06OXGT7fF
         3UqgusX+W/K1AJ7ottYr8/IK7YwS9Raox7sMUEeCR+FrlaOtGAOXBMmfb8ULOaek5eTt
         dv+J3/5zQ6QdayMH2x+MvBS/kQ5dU/+feCtZcbJ8gbOsdTPt3rB+ew1SbNumC/uCdBdU
         BF3gQwHnxs/piYS+Qj3bJ+G47eWhG06BlSJmKPd3J6SYYf6cwEweWNmeFuWUQzZ4TVRe
         AxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rUN6YuuaNsbiLscR/LVT4NmkgS5ycusdU2cma2yn42s=;
        b=iArcBUIfke/ZSimQR87WofXK72PpbkLYw/xPVrcUJ8g7ucKozOV8ZM0X2kmsmuDYiS
         p7HKjzOvtdNVUHGcyKAWOlQw+G1SGUanU2FBIvZ6nHWKolaAGVxPP0/fuMunDQhK6syi
         tIreogf9NkyxvtgwayVaI1cNG+CVizDKLRypbowP3PmgiAUMgJfKPK5Irfy4Qlm6jQ4j
         O1XVkcfdu8PvL2kGyFaYuvE3Fb6pAzA0Lv5BwlDv7YgHS7IZkU9T+HC4smkMBRLtXmsI
         iZMVj3wzq7b+x+QlC8bP3QLP0Kx1aJ+qJFpmPOzWic6U9HTcx84KSCCLi1qKgqKxfPzQ
         l+wA==
X-Gm-Message-State: AOAM532WOtnMTyzKCTW4YEgts2pY46nhVBeIImFUOveI6IdoqDWt7CKf
        VdirsS1GopxI5mM2kS92bvkS49iKSnEpEmJP
X-Google-Smtp-Source: ABdhPJw06XO8uc6d5rXo1sCmO0KB0aEJHQNFReqeE2500KH8LwT/hjRLRXV/q+aYD/YTMNC16itJ+g==
X-Received: by 2002:a17:90a:3488:: with SMTP id p8mr10985987pjb.114.1637243138860;
        Thu, 18 Nov 2021 05:45:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e15sm3190056pfc.134.2021.11.18.05.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 05:45:38 -0800 (PST)
Message-ID: <61965902.1c69fb81.bdd30.92ee@mx.google.com>
Date:   Thu, 18 Nov 2021 05:45:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.292-113-gdc53d6b27d3d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 101 runs,
 1 regressions (v4.4.292-113-gdc53d6b27d3d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 101 runs, 1 regressions (v4.4.292-113-gdc53d6=
b27d3d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-113-gdc53d6b27d3d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-113-gdc53d6b27d3d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc53d6b27d3dba2b80459a6847ac8acb4e37eb1c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619627a4aa31f32d8ee551f1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-gdc53d6b27d3d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-gdc53d6b27d3d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619627a4aa31f32=
d8ee551f7
        failing since 1 day (last pass: v4.4.292-113-ge9a92f80c735, first f=
ail: v4.4.292-113-g643cfcb15c40)
        2 lines

    2021-11-18T10:14:39.163875  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-11-18T10:14:39.173358  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-18T10:14:39.189556  [   19.526153] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
