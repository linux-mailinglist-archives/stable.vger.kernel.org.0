Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD5633AD4A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCOIXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhCOIXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:23:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C960C061574
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 01:23:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so13938457pjc.2
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 01:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=495APLW4OpnjAJIkmtn0FODNkuDemJetvyBLhyNlif4=;
        b=K/ZzPqa0yxN4d5DT8ACBvPCVbCFqRthGSuDd4AZCR/4N/BypfuL71GBrbdalQDGxu8
         qQWep82oxaSrmpztC36187PgEBgoYQcioFX+y9GbRBBttd3XF/2e4VBFsMNRPFMG6CJh
         LIY2QMwN06zh46B3vKeVqgQf/VVxedaEOwT33m1lHKGw8SbAtlZzpPYTPI7KfROrGHu3
         x1XM5ndFSmh7iiAy8oAjtanhYxcbeBw3O/LQUzhRIJxJFshWNzO3iUOmS2/fTipFZD7s
         TkA0Sg6kJw4eN8J+MYrYwoDxv4Jv8jC3GvygTkYnJiZ1XjlL042mq0zKpahOp8Rv6K4w
         5wwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=495APLW4OpnjAJIkmtn0FODNkuDemJetvyBLhyNlif4=;
        b=dHBEixnZR3MXIT87aOiQLEeynP5sHFsBAjHnv+9RRmjpKKpuV+p7yu1T8wVX4FpylN
         VmS5hLshLzXJJtqZVNAf0jJV8aE7oq3vyeQK9i5HFf49MyCoSOtT9SVjtVOgDZoyH5GA
         1E4C6yIdoTb/rRBHGLSwCAIfV5LpTVMWUsLAYQwU7KmGiZ8YtqfY0UPZcTOBMRgsGw2h
         9IEnao4SH85OlwPpSXlrpRa8NxAzXOMZ/uiBATA/sAswVsSKbjYiulL/fBi32JyD7Ixv
         uTKa8p2NCKcKBmWm2GKihb7pSV6omr50f2yY52q+UtMuvABXNPHPTrpO6SfIySF0vHgt
         frfA==
X-Gm-Message-State: AOAM530d+JidixOpyLkArjjq4ji7CCNVHd5CaoUP3ZGuyuYJpfD7So0r
        Qf7pZXDDBfPRYuhQFbogy0/ge3RcEq1Vhg==
X-Google-Smtp-Source: ABdhPJzdxmJ+SsOvqkXqEshGFDh47NQ7LR2W4njbn3eFxjz6hLi9uzucE3kmPW8O6tncmofJhOmxbg==
X-Received: by 2002:a17:90a:86c9:: with SMTP id y9mr11601301pjv.205.1615796614617;
        Mon, 15 Mar 2021 01:23:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id co20sm10283155pjb.32.2021.03.15.01.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 01:23:34 -0700 (PDT)
Message-ID: <604f1986.1c69fb81.a5e0c.895c@mx.google.com>
Date:   Mon, 15 Mar 2021 01:23:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105-172-g0f971576906c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 172 runs,
 2 regressions (v5.4.105-172-g0f971576906c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 172 runs, 2 regressions (v5.4.105-172-g0f9715=
76906c)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.105-172-g0f971576906c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.105-172-g0f971576906c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f971576906c39d912ceeb04bebf76c591af12c0 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/604ee2fe9e78a24c80addce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
72-g0f971576906c/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
72-g0f971576906c/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ee2fe9e78a24c80add=
ce3
        failing since 114 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/604ee5d24bdc9c48b1addcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
72-g0f971576906c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
72-g0f971576906c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ee5d24bdc9c48b1add=
cb6
        new failure (last pass: v5.4.105-60-ge07ad67f9cf4) =

 =20
