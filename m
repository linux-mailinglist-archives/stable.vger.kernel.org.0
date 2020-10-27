Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB5129C7CF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829160AbgJ0Suo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:50:44 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:33686 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829137AbgJ0Suh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 14:50:37 -0400
Received: by mail-pf1-f170.google.com with SMTP id j18so1457276pfa.0
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 11:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N0z8H4BtfZylSbfDSpdlieXARFQd2q/3KXYgpN0ZbkY=;
        b=IYu+kR2ZNl31ZHJ+N+aueJwYvyHn/iB6zr54kC6a/wz0hSR8Hwl7/GUP6zdA/nsMfe
         olqDEABr33+ysDRgD0vipDKh9w/6ZSdScDTWJqFvtWhFtOxdmBgvAG/BVrkhbVYH0iO+
         Ar+xi/0Jm/RPEbCYM+h892trmG50TjOxNK408H8/Trcdp53M+X5kWUmll8cGnAOjOrFE
         jdlVAFq4/FLIX5kvx1YiiUIOd8FP/5gqSiSfxbwqfdCl3qUCFePAU1o6rdSGFoxNbh6f
         +YOd5kvSjrVooYpqcqCTzFSn8vT1X/KvCWxurJP6tRpCIJK6cYauqJ1sRE7sIyohQqdT
         lA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N0z8H4BtfZylSbfDSpdlieXARFQd2q/3KXYgpN0ZbkY=;
        b=JFrOSka50U2zZlOILWjkPa4P2mE3z5TQvJ/4c70QPykqllZrMYLKKjanLgtXNnUHol
         MXFa2IJC4GEa6uTJXMvVfSEHCNFmKKmBFlwfvlNB9NTha1CG5jhlj+GV++8FnM2XY569
         Gd0Ly181Lg5w2sc6314vlZGif7QHKQl5Moib//qrlu7UJzgXqzRk6RnGyKMX9xoW7Y56
         UQ8n9b/qKeIx1pdk5CKxHzxqpqjotJ+ud6xWiFaYlO2IOAseVkdGe2WDNrbynmOcSL5j
         uvz93QEkYFNMlt541DxwkQZQLkY/cc7XMe25mymRZBpotnNlk+xVOhlHiwOvThBywyvN
         opSw==
X-Gm-Message-State: AOAM530PEHzpRwZag8/d+Qbwr+GECAKiK4A2KEhvIQ4ofH3JS1iKk4pf
        W9ZlrcotF3mEFRoYOFN/ul/QK1n4n03YPg==
X-Google-Smtp-Source: ABdhPJyZ2D0S8KEqBqmyVGapiSNDIR7s4TfiJFvVvDHEWfEzu78mKn6Vmjx53VRHSqrJo+TIjr5zxg==
X-Received: by 2002:aa7:9a04:0:b029:163:fe2a:9e04 with SMTP id w4-20020aa79a040000b0290163fe2a9e04mr3797579pfj.30.1603824626975;
        Tue, 27 Oct 2020 11:50:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g22sm3132391pfh.147.2020.10.27.11.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 11:50:25 -0700 (PDT)
Message-ID: <5f986bf1.1c69fb81.eaccd.61c6@mx.google.com>
Date:   Tue, 27 Oct 2020 11:50:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.240-140-g97bfc73b33b5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 129 runs,
 1 regressions (v4.9.240-140-g97bfc73b33b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 129 runs, 1 regressions (v4.9.240-140-g97bf=
c73b33b5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.240-140-g97bfc73b33b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.240-140-g97bfc73b33b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      97bfc73b33b595e89801f5fd849c14af344dccdd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9838edc13a50b479381035

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.240=
-140-g97bfc73b33b5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.240=
-140-g97bfc73b33b5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9838edc13a50b=
47938103c
        new failure (last pass: v4.9.240-15-g726ac45a50a6)
        2 lines =

 =20
