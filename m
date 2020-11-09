Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12962AB021
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 05:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgKIEFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 23:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgKIEFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 23:05:48 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B23C0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 20:05:47 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id e7so6824428pfn.12
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 20:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=udGnAz2bbng9+KbdsM+T72/A8nH2rwZ02Lf8EVKtjUQ=;
        b=gQgREYgAeR5Ch9af9ztNFio9nSFEU3KL2R5xXLE7SATM0UrzYoOt4U/kDu9EbjX57d
         /eGmxcq5PSQ6XEqzEfBI2Y91rGxnm6Hh23XO5ADtA1AYiUswAXihilcTEmdC5Bg2eOsH
         nO4QU/xhqXYjI+1MIv3eYLqcZ93b5j8cIoHsFIUhD8Wr/D4gGFMOugXrywpGD9xWYTX5
         HXOslSOQeHRhZX0MBwtQBfput41B29XOBl/wBm3fZKsTKuBXPTtHy3XzyfIgr+cJkF/I
         HGhqiPIDVzH++AAYZdWFWwS6ESy6lZT2dAJARnDsIkpy0U10KREQR/FItii8qOam2eQn
         Z4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=udGnAz2bbng9+KbdsM+T72/A8nH2rwZ02Lf8EVKtjUQ=;
        b=SRVAWVG4b2R0K34+hLgAZ4uPbrqnBiHxJl7Jb5wQsZWdKtD1RsByBb4baJnSOj9scF
         Nx0pYbhNAk1UMUENLttlNXOm5xaVZX9OnlqGYXyxwAZOvh4S0a+8ENPekpEvwFcrrSBh
         akthAc/0q3kLljsYzkSnnep1E3GBT2J6Pt1VlAqbCaYuHs0K3qZPoOL/b2EzMY43sp8t
         SvVPCs9pgDplVpk8O+HOSJswEMvINYKFfUDJnNuYyxvCfCUojWPZssX4WLC1zdNJFG2/
         PsA2sC00WeP+5P+XreDSGRCqCegfRwG4GRodMmffFrKOH/frPhPwwQie5IWwF5q1H9Ye
         pGCA==
X-Gm-Message-State: AOAM5317wclbgZXeysXoEUSCkBwaAYI2UCpTrzrHN7BBdg2nQsfjRPNf
        521SBo7Ik3bEx+C+sTKr7/2xijmVhRAoHA==
X-Google-Smtp-Source: ABdhPJzIGlkxaD5Rf3qm79Fa4yP4ob20kS37ylnmktwQ8ZNoh+iQ2cG3TgcbOdGIGO0aLkmZo/Dp7Q==
X-Received: by 2002:a63:4516:: with SMTP id s22mr11217710pga.45.1604894747061;
        Sun, 08 Nov 2020 20:05:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z9sm10007735pfc.131.2020.11.08.20.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 20:05:46 -0800 (PST)
Message-ID: <5fa8c01a.1c69fb81.bd755.61b8@mx.google.com>
Date:   Sun, 08 Nov 2020 20:05:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.241-76-ge0e2c4f39b67
Subject: stable-rc/queue/4.4 baseline: 100 runs,
 1 regressions (v4.4.241-76-ge0e2c4f39b67)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 100 runs, 1 regressions (v4.4.241-76-ge0e2c4f=
39b67)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-76-ge0e2c4f39b67/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-76-ge0e2c4f39b67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0e2c4f39b6794e5e38c699d5b6631c40943ecdf =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa88e1bcefc77b400db88ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-7=
6-ge0e2c4f39b67/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-7=
6-ge0e2c4f39b67/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa88e1bcefc77b400db8=
8af
        new failure (last pass: v4.4.241-71-gf370af230490) =

 =20
