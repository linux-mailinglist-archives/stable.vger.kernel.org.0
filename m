Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187E435B185
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 06:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhDKEZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 00:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhDKEZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 00:25:44 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93862C06138B
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 21:25:28 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d10so6808259pgf.12
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 21:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FVAPE4oQB4VErgCwfnnplU8uEjxELf2jWXXI0fxBzXk=;
        b=lvDP4AEMv/OAwQBjtNfPA5UF63hGt7gbLv7HfJiylYqcjjYWt3Y/BN6WE4wyuFJR/m
         gZiCXDg23LbY64CzlcRblis+RPiuMtv4yzV3Okar8HrI8v7x4Am0xFcErtBkfCsf+SLt
         36A5csaZDHJ4nmfJ7LQMl0guB5fuNgxAn4h/fiDkNISMgtMgNDSC+FWzUOJ617AQXw/Y
         WhZW0gCa7Vccjp8cdi0rgCP10rXFJ6VGTi6uxphZCkGpYG/b8fup93cnZ9fkSCk8Q9SR
         6MlCNQhu5WW0eodaaJM7fyUixpwhKpu9NTnJA6+/2Yh9UXsR+tGtulLi4l55S9zGcLYV
         2cvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FVAPE4oQB4VErgCwfnnplU8uEjxELf2jWXXI0fxBzXk=;
        b=KJ9TUQb5HcLPznvy7+UXZ9BVTI82VsGLVpYLFmwkpTHbKLld2TpACc7eg02dAEX8LL
         g8UhsiV/r9zSIo0pObDY2YTzb9k8YqJ2SX5Gcs9nPi0kLadwumvonM1Rf6rcDFiYwMGi
         vys3WdoGVXT9sapfW0r4SxJwHzx8nB2nGNTo9vlEEPTNSF60jwf9x4OJbnmB5sz7sMs7
         HqLpLozovbOhxaHuWLtBJbnbr5HqlAs2VRspXmP6faENlX7NMYL+XLAOoWEpHUm1RaR0
         7EK5d7U50drCLvJYAyGulWOBSvNQ7x3snYDf+IIL/WyqhMDype5/Y1ojPa/hsoQhYWc9
         Hr8w==
X-Gm-Message-State: AOAM531iPWee051uBWiSanBxql74F37SueBQVlPdT9uxjldVq7m1koM9
        OP8zPoB5zUvqh6Grz0lOjd68//tH4sj3+Q==
X-Google-Smtp-Source: ABdhPJzENnJFc+Au8abUYwtBB0MYl3jpF5AyUDnPaJOZO0eicMZpU/YOz1DEkFs8tTHQHpL76EBxTw==
X-Received: by 2002:a63:1202:: with SMTP id h2mr20947023pgl.35.1618115127872;
        Sat, 10 Apr 2021 21:25:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m7sm6241220pfd.52.2021.04.10.21.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 21:25:27 -0700 (PDT)
Message-ID: <60727a37.1c69fb81.564bf.fd7e@mx.google.com>
Date:   Sat, 10 Apr 2021 21:25:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.186-21-g4659135847508
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 107 runs,
 1 regressions (v4.19.186-21-g4659135847508)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 107 runs, 1 regressions (v4.19.186-21-g46591=
35847508)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.186-21-g4659135847508/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.186-21-g4659135847508
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46591358475080ee39090c2e99e15f6266092f74 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60723ea990f1686006dac6db

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-21-g4659135847508/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-21-g4659135847508/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60723ea990f1686=
006dac6e2
        new failure (last pass: v4.19.185-18-gb9c63423ccf3)
        2 lines

    2021-04-11 00:11:16.620000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2021-04-11 00:11:16.630000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
