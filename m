Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB67329EDFF
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 15:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgJ2ORd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 10:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgJ2ORd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 10:17:33 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AC9C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 07:17:32 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i26so2449136pgl.5
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 07:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bEhookLsjLedYV1ntM31W+OBnTzmRDN7s/d/WM63zzY=;
        b=1OJgGJklGYhWPrPvXIRZsUTPpmxU2UALD0LrJpt3dwTo27p40XII6PPYTsX5cAsFdu
         JZLpHpK5+mKEdccznQp3bbvm+R4NDmDQg+4uXYqaKdckE80pRSQSB3k8pLTlrb1xzMFi
         hbxtLXOzItH8g4R49s5Qn2RNVOtFQi9FzkZpGc1OgxyN3Nb+cRS9UZ27bPZyv/7ESmpY
         NxV2k+HcKjQTaJVKM5S60XKX4COGoH16L8oOvKBUWURnGmQmpoLa9healRjXB0rtFroM
         6kXRP/zu8HaQ1fO6lFY2Snz/YnIzHqCr+7Fdulz1vBTA3SBQYiaAFP3bQ7pPd8wLE4Hc
         leWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bEhookLsjLedYV1ntM31W+OBnTzmRDN7s/d/WM63zzY=;
        b=MGDJbqcAFjzyM73Im58AW15Mznp6umP7Bwo5CGpdFHOKhfj0+zP1R3iIFI1xOQvMXB
         g/ayIR3MZRMmcNOW6EWkazd6xvEGON7u8/uDdOIpYem2TOmR0RFjXrRg2/m3LVMP7Sbd
         wLpeVx86xvLY9/K/thi+TgIihYkDbxsx7EBNi4JX4yD6fu3FExTHy/umMafAcEF24fQ9
         6FbCu1n0fUxMTl5Oo9qhiN6oBGDrvbkOqbPTu1jt0TqdTOBonvPSQQUPuFrjjdVJhCNk
         m6iB64Qu6Bg3c7GHOFGPsIYzQ3kForjHECYzAAYU/S8VV8pgNPqCDubh/oxyFmE52Yir
         A28w==
X-Gm-Message-State: AOAM530Caeq70WP6UyknMscCem0A42C+0ef9pYXGk7ypMYtwzCscQg39
        nvNO5z5InxoXL+8RZZCJN/BhWKUp+hbXcw==
X-Google-Smtp-Source: ABdhPJx620uYZ5HPOZtr90obD3h/LW0t4fhynPrg9kgI5GzjpV4ZhF2VY0YqCv+bYz9ci2ej1VQVsg==
X-Received: by 2002:a62:1b96:0:b029:164:5161:e393 with SMTP id b144-20020a621b960000b02901645161e393mr4615840pfb.7.1603981051244;
        Thu, 29 Oct 2020 07:17:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm2738136pgm.79.2020.10.29.07.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 07:17:30 -0700 (PDT)
Message-ID: <5f9acefa.1c69fb81.a6d4d.5de0@mx.google.com>
Date:   Thu, 29 Oct 2020 07:17:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-145-g2cc9ca5cff8d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 182 runs,
 1 regressions (v4.19.152-145-g2cc9ca5cff8d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 182 runs, 1 regressions (v4.19.152-145-g2cc9=
ca5cff8d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-145-g2cc9ca5cff8d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-145-g2cc9ca5cff8d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2cc9ca5cff8d5c0a484f9234f90f087df3150472 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9a9e1ee72cad8c7b381019

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-145-g2cc9ca5cff8d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-145-g2cc9ca5cff8d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9a9e1ee72cad8=
c7b381020
        failing since 2 days (last pass: v4.19.152-260-gbad1094e2c61, first=
 fail: v4.19.152-261-gd2b228260b67)
        2 lines =

 =20
