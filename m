Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15815465C53
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 03:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349936AbhLBDCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 22:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbhLBDCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 22:02:01 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D7FC061748
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 18:58:39 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id n8so19211202plf.4
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 18:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x6+8gt4L2dPrtghbbu75lkigtiDvFmDUwIHrVBf1dpQ=;
        b=HyYXIKQq6BEH5cX5EXcMaHqmkbmQWdmEOJUFyP3EItjWoMzDKQ98YtwXM4difSS8Xd
         w2JbmWS/dgWe83NPAcRTwUnDnT9SFE+tB1Pk6+y2tSvlx5T8H3wZfJNEEW5XVzCMIQFE
         go2+u1bwnQVFYEqBwaWCyAVZJnIO2Fhp6LFpg9O35iEQRmO1C4e8rPqPJAlfYjq+Ed9v
         aQsC/tIBiy98wBm7j7tK98BVlh3v13rbhnAPs334h7xN/vxzd8zgHJ8s8Nr1X5c9orTi
         fz4IbY7vc28AzoTO08CXEKA/Dv/Y/H5xL/VhsSvWI7kO0V0SPNqqhrwwLkeNs2ypUVIo
         bArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x6+8gt4L2dPrtghbbu75lkigtiDvFmDUwIHrVBf1dpQ=;
        b=s+QJJNX0VuFNCjaVjkxpFFr4zinFDr61xB+5ucVvSwGi3RiYG2zooTVQ7Ycxi1uk7F
         G0zotEsRiPfrYpgoa694jTGL7E6aHqN4sfCqqbeJ7rhLRaBHlomhlMbhIPjkkzbwPHqr
         /+0cPJUYPBJ00IA/1QGtsjICFY8yTBJz1EL+vJ/yPJAGP6VTumS3Dpnd2fwXlG5HfL34
         9uUIe1Fb0ftbIc2XamAAi4ScaIn3GBcp+Oz6VyTU72ijm/oYFstRWAsjHNDdpupHslXp
         GHAmNr/SAwK/PspbNlXyMJpG/pIHAMP2BYR3L4Xo1HM7vyXTP8qr0c0U0aA+9RFuKWWZ
         K3NQ==
X-Gm-Message-State: AOAM530hmvWsiI8CDAkpDaR2BHQoyX3Zh+ZVozHgvHyNPmcsikQPO4KV
        2oFkcQmPA9sgmM68FKk++BWIJ+CGTpXH7KpL
X-Google-Smtp-Source: ABdhPJxprVQ0eNOVLT5orBbqmd1JwFI6FgqHCMIKGbWTZHCWPqxGv9FiwZUt5zN95HwoDNhUZAIslg==
X-Received: by 2002:a17:90b:1a88:: with SMTP id ng8mr2676095pjb.180.1638413919124;
        Wed, 01 Dec 2021 18:58:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g19sm872183pgi.10.2021.12.01.18.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 18:58:38 -0800 (PST)
Message-ID: <61a8365e.1c69fb81.4b286.41b4@mx.google.com>
Date:   Wed, 01 Dec 2021 18:58:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-3-gb27e97c3f7a9f
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 123 runs,
 1 regressions (v4.19.219-3-gb27e97c3f7a9f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 123 runs, 1 regressions (v4.19.219-3-gb27e97=
c3f7a9f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-3-gb27e97c3f7a9f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-3-gb27e97c3f7a9f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b27e97c3f7a9f19a3f85511fa73f78bcbcb19b08 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a801a35ef65a92711a9494

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-3-gb27e97c3f7a9f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-3-gb27e97c3f7a9f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a801a35ef65a9=
2711a9497
        failing since 0 day (last pass: v4.19.218-69-g6b346297fec0b, first =
fail: v4.19.218-72-g334f0c9afaaa1)
        2 lines

    2021-12-01T23:13:24.160644  <8>[   21.259948] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-01T23:13:24.205644  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-01T23:13:24.215009  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
