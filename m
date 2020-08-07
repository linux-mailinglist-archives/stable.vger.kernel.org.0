Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CDA23F3FB
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgHGUrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728653AbgHGUrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 16:47:33 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B43C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 13:47:33 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t11so1701082plr.5
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 13:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DwDKxCZfW2U8/rdzoQy4+FTgCRwGCctumQtqVlkK/4o=;
        b=oSleawpqJpqZVp7Ij4RVOqjFURxB9SblQEp5sq0eMul+TC5GSLP7zBJC3xNSRaXcyq
         UZ9853Va6RuUkS8koD1kFpMZvFN5Bhmw31LU0Z8AqesAouCY1P7VH2y11h6IfvPswkfU
         7nNPIMWH3ibUq+yUSdFcv7CsWEbcqjF43CgPF+wX3ayi/BXtcpERXly8xuLqMQsVRf5j
         zA96p8QqoVBrdqe4YZtpyuwnU5B1DRlpNWgg8RKWZ0dSXAaHOSzawvM+8Jh/nXdiltZ/
         v0hs8KYMkVAkUt6S1ROeGXcIYT62Q0WWiyl8z3T5G5NX9b1u/Z0pJQiL1fQYW6H03Qe7
         hgYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DwDKxCZfW2U8/rdzoQy4+FTgCRwGCctumQtqVlkK/4o=;
        b=UUmfqD9k4Byk4Vj0UJLxXuIDzD35pKmoFaunbECJ2/mCapQTvozIjeH42jNMvUtsk8
         xnT596Tz1MWZIVXjQG9hUi/MlGyBDpZIeo+VxfPk9ycTw1tkyVOZf5UpC0zQlg9eWQKA
         GKAmmid1MvmAYaYC3OalYU/QczkEQldsG9G6uK74+S170AUpaNURmh7sHxua1XDvyIWI
         7fzWDmQtWoeGaT5Ipeo9blk1crjx2NLLGsezaKv/WvhlW+zPpMOswmxWRAlORAdAbpGZ
         5IrYjs1yReX/k7kZQjbDVnDuivBhPvyjg/iFZu5APkGqoQ0qJh0E/fKb13ahxfg9U3Nc
         3+PA==
X-Gm-Message-State: AOAM533v+Pepp4RVHYlrudsOnvZjVOytZbAFvjU+FgXNoa/1dG/WUSpc
        zWT+YtctDThkc6cbhV9AuPDPGPSe6fA=
X-Google-Smtp-Source: ABdhPJyqvenxuSs+U+iBSb25/NNrOtypKqZLDFE5iR6cRQEFX4ZC3TeVeUQODX7xzo/pD6iWaGXedA==
X-Received: by 2002:a17:902:9f91:: with SMTP id g17mr14720099plq.261.1596833250858;
        Fri, 07 Aug 2020 13:47:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h5sm15295764pfk.0.2020.08.07.13.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 13:47:30 -0700 (PDT)
Message-ID: <5f2dbde2.1c69fb81.53b68.4f3d@mx.google.com>
Date:   Fri, 07 Aug 2020 13:47:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.138
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 124 runs, 1 regressions (v4.19.138)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 124 runs, 1 regressions (v4.19.138)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.138/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.138
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      961f830af0658ef5ef8a7708786d634a6115f16b =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f2d892f0de533d6aa52c1bc

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.138/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.138/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f2d892f0de533d6=
aa52c1bf
      new failure (last pass: v4.19.137)
      1 lines =20
