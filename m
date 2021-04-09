Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FDC359E5F
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 14:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhDIMJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 08:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbhDIMJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 08:09:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7257DC061760
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 05:09:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t23so2788001pjy.3
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 05:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5IAassMWf6vBU4VYiVkl/KT4G8FEWws4Q/fhRlUb2+k=;
        b=K4ly4aLX98ZjRU4ixpMiB3jfmfICH62uS8r0MiXy1pm+Gzyx591abQHhbCURmN/LdO
         Ig1gzPyecN0hQNpdTyiXTVj45Gn2RcwXn8Cr0JQxk6Gkh/Gg9EDZLGthf7cyCZ9iQIGT
         QpM2rLOb3P3I91T1KIl97xxlp48TDyTxbdHqlUToNJw9mWgtIwh6RT/uptIh3eJIXF5X
         Na5TdPsc8V5mCaFLh5gFvrAPDLrUzEWi5mGP3iwdTdKye7mJqH1pzL33pJMDzk8zQR6M
         SoliK+p5bnygGEH2t1oAXp+Kq7lbuTqIhdnVZ/cEoLyoCO5CYR9b+h2+oX2ZMGlcrTfS
         y98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5IAassMWf6vBU4VYiVkl/KT4G8FEWws4Q/fhRlUb2+k=;
        b=mMPQtYPuky5NauIhWEWDRgzhxJzAXxlCTO/3t+tioD+02k82yHYBXgJTHTOqH6zI8K
         ZulL7sC/ZlWPUNmQaILU+ltznDxSw6MXWtw5XnlcfSh4S1TlmjnRcAeFbWrtjv99+cax
         HD+MNt5BhfVelns1t6ZCNbHMh0StBa4P0IQLU+yeU/PdrldYPBAWG3cL6iWLEYXPqYWm
         s+7DUFtwv/x3dimlDZ/Wi6J67sbfedqTaXisdFpGBjcZiofDseZ7G1nLzci3MRtGV3kR
         m3YbCH8zkSCg/n1lckH9ArGIJdjEqVWPzpLcekFTK2vUAS73H7rrmiexthKOLZYYCaYa
         pmeA==
X-Gm-Message-State: AOAM530dNO8lEK8lzdoOcxvHcvOAbph0RUp7zEnxVV1PRTOKmwjveStE
        chSGBA5+n3LxcN2a7jytnHQzeffc25w4LW7l
X-Google-Smtp-Source: ABdhPJxwi0hoF3pBhkyEIyY2zWVC99ROTPFh4wUmyLgG14dBDI6pmT41y4ZoQRqiMB9BXtpU3AaNFg==
X-Received: by 2002:a17:90a:d3d8:: with SMTP id d24mr13765607pjw.28.1617970176783;
        Fri, 09 Apr 2021 05:09:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4sm2272435pjk.57.2021.04.09.05.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 05:09:36 -0700 (PDT)
Message-ID: <60704400.1c69fb81.710ae.5b36@mx.google.com>
Date:   Fri, 09 Apr 2021 05:09:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.185-16-g6c4a14ed731b
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 146 runs,
 1 regressions (v4.19.185-16-g6c4a14ed731b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 146 runs, 1 regressions (v4.19.185-16-g6c4a1=
4ed731b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.185-16-g6c4a14ed731b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.185-16-g6c4a14ed731b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c4a14ed731bf58a8b8b9bab9f8cedb461d5febe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60700b35d9a8d23e1edac6b8

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.185=
-16-g6c4a14ed731b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.185=
-16-g6c4a14ed731b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60700b36d9a8d23=
e1edac6bf
        new failure (last pass: v4.19.184-56-gfcf30cfb5ee40)
        2 lines

    2021-04-09 08:07:13.374000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-04-09 08:07:13.377000+00:00  <8>[   22.807678] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
