Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C9F3147E5
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 06:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhBIFIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 00:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhBIFHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 00:07:12 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D63CC061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 21:06:32 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 8so9056263plc.10
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 21:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8aWbwAhxMq8HnfnsIJy61ZCqHYrGDkGBb721t3haKbM=;
        b=jq4+HRjJg1KSs8CLjt2Mq2kLxSaebtPjAru6rTs6BpyOFkSigaA1hJD03/pbfHqDtV
         pzB/ric8VUKprS7JEBUcoalzvWbDXpn06i1PubEjiGZHhXejWJQt48NkdPZGTcN2w+/f
         59pSnT9tOA770VTT3ZP+fGaeQKTDJ88EgH/aRnh/gcXCpG8kp6jzK4CIozvzh1+YIvJ0
         3Ig9DoxkTEkN332Bx4sSakJz/T4mG9ifUH+O7IUZuqCwJrTK3wKo8+o6GBnqd52Tc2sR
         JiFTCoTxibuVTy0Vy916K9TpocoymqGFWj3uOXqU3yt2NDPMR+u5W3lASOX1lLAj8TSC
         gHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8aWbwAhxMq8HnfnsIJy61ZCqHYrGDkGBb721t3haKbM=;
        b=oA1nWUntMCbnJi7yT9dAUSee/7W3eccqQKQCCQiFOc/+7I8cnkETlPPvK9/r/BNLZK
         IKQv8bVu0Rf3psaRT9ENNiaqpZcnJcnCzxzT8pfFmty6d8HYxLILuMt8UM39OH2HmjJz
         30tcTbZce/GQiMzKiFcBLXpFwTrDK1syFCPfF3R7xH8ljt/RDStgGlRm9/A1cF7A8CJB
         Sz5HrMrn7HuiaCRzP/SZ0IZiZGGlk30kKBO67iCk3iJlot4t8P+s7hjMV+jEOG0jw8R0
         MFVDToIZKKwbBOnr5op+btjAz2t4q2WadwHqOK8llOcjmwO1AGlumYLtAEkKqES/9m23
         wnmQ==
X-Gm-Message-State: AOAM532YfwdkHXeCKD0+BJhXd3zDgqde4WWZKAUW9bZXG4upyW22or+Z
        /xSL5+jFsEtrpHLqjib133HIxc1e583Z8Q==
X-Google-Smtp-Source: ABdhPJz8OwTtvhS/wyyMTRAYYYTLy4wW/KrfPtZNMy8v0uayA7b8iCipE/KqJ3RXdQuQPqMv+4VarQ==
X-Received: by 2002:a17:90b:3787:: with SMTP id mz7mr2268254pjb.96.1612847191385;
        Mon, 08 Feb 2021 21:06:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i1sm9310170pfq.158.2021.02.08.21.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 21:06:30 -0800 (PST)
Message-ID: <60221856.1c69fb81.f103.5989@mx.google.com>
Date:   Mon, 08 Feb 2021 21:06:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.174-39-g69312fa72410
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 88 runs,
 1 regressions (v4.19.174-39-g69312fa72410)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 88 runs, 1 regressions (v4.19.174-39-g6931=
2fa72410)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.174-39-g69312fa72410/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.174-39-g69312fa72410
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69312fa724104d8af5a6124d4f61935bac6a8562 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6021e6a588ffce20913abec0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
74-39-g69312fa72410/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
74-39-g69312fa72410/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6021e6a588ffce2=
0913abec7
        new failure (last pass: v4.19.174)
        2 lines

    2021-02-09 01:34:24.513000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-09 01:34:24.528000+00:00  <8>[   22.916412] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
