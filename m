Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C266483544
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiACRAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiACRAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:00:49 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E853DC061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 09:00:48 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id v25so30531444pge.2
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 09:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2wgKP2mMHTvMTV3aWfmEVXxN5aLPZxnvsC18TPDyfIM=;
        b=gXRwQQAlNxwjk5n0oxpUXSHmfWUYM5k99Ovb9di3+a60yqSjkRDlIA56TRUAHz6syC
         ogWYipshWbmqK9ZJ8+ZEko/yWZD2tCXRIupvjGcLaABJG+Y6AGbH89aEjL0aeBLqju02
         icUMu1ELlLMC+hBhGZnO10GeoArMpsVqBShCHGWD6inEuTRN7yw/bcJjnAFunm6jDeGG
         c6DC4SaMwGS33EmYT4ugfVaL5jzusecZPL2P8IyHo9cIeDzN3A1JgCrv/j2JYtRhZ/io
         ap/bBzdc4yblqetP5JsdDQn3oSLCHLyackVP22NdxWwQx30adFoBXACUKTpAtJ4NhrV1
         gO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2wgKP2mMHTvMTV3aWfmEVXxN5aLPZxnvsC18TPDyfIM=;
        b=ztrBIZJ33oDH27jilhRUuLNiAK00qXD7H/bdmKHr48KPzvTkEdqOCp5ctxq/WurOr4
         zZRqyBaApYxIn/ZW4E+BD9PRGkpAv9+9ncJXLA2x0c3ZGjl/O+F4BNZP40QPT6Io6vHa
         e6IvYLJcQuYw7sol4Jr3qzV6zvFHLvSe+eMvvEc67lW+Gmj9z+Z5CLe0e4s0Hlf3r9Cc
         okBnAkS/DBCulO+8Y39NiGuQV288q/ftFqV7zvBvwLKIBvwctbDrzrie8M6vDDc+xiul
         N2aWQITxOMDGSd9RB5+xpPwcVjEztkeokFI3yqHuxmckS0jMDHVZdZE5SP7SPySmb+ML
         lG5A==
X-Gm-Message-State: AOAM531hwvIYvtVi+RD0dtZ9UO8kXw1IbHOi4vYJYkcIvzPww0KnN8mY
        V+u56rU5dEMNxj/VGhh2ZmukzIdooh+naPO2
X-Google-Smtp-Source: ABdhPJxFiZMwy39fzqtS2ABvUOEdBRYqWYxcpu9cSKAK1iaJzpwy52crvFIw5e2QZ+752iAenX8a0w==
X-Received: by 2002:a63:784e:: with SMTP id t75mr22916367pgc.285.1641229248327;
        Mon, 03 Jan 2022 09:00:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k2sm40979431pfc.53.2022.01.03.09.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 09:00:47 -0800 (PST)
Message-ID: <61d32bbf.1c69fb81.24ab1.c0f4@mx.google.com>
Date:   Mon, 03 Jan 2022 09:00:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.260-20-gfa39c1a8f424
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 121 runs,
 1 regressions (v4.14.260-20-gfa39c1a8f424)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 121 runs, 1 regressions (v4.14.260-20-gfa3=
9c1a8f424)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.260-20-gfa39c1a8f424/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.260-20-gfa39c1a8f424
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa39c1a8f42483bc9c688efc40d8e49dcec66b73 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d2f76df33301c8f9ef6773

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
60-20-gfa39c1a8f424/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
60-20-gfa39c1a8f424/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d2f76df33301c=
8f9ef6776
        failing since 11 days (last pass: v4.14.258-46-g5b3e273408e5, first=
 fail: v4.14.259)
        2 lines

    2022-01-03T13:17:14.195916  [   20.362396] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T13:17:14.237372  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2022-01-03T13:17:14.246239  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-03T13:17:14.259331  [   20.427368] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
