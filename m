Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34CA280CF3
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 06:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgJBExL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 00:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgJBExL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 00:53:11 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CB7C0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 21:53:10 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u3so130207pjr.3
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 21:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4cjDZSb+LqgsYKbIt8hxYdujvaKWjhp0jqOgOrwlo78=;
        b=sg9o5jAlTZlV/t3QcKwY6AwYINfEb+TR/EfCMtTrbk9GrOzjAGva95srxfOhOMC6el
         PWqYtHPpbeTR5ML9oghO9lnmYYJGQxCztbqYGCPNabum0azGV2Ciur6YEmPl83rpiukw
         mahSlQ2i5/y23z00mO21NvG0pwjkeFzoSsakKqQ5YL+nFN5JqePJLmWqM1LAgKDC6Evl
         GbCojyVsSrPuoS38XvQARWMApTaOFZJ+5gLfdgEj3spsbcl/6uodhg0qZExoagRbfzhu
         diNVGIJM+DQqrxNSvdATpxm1u26DHywA7oerXMFM+v1/b0bEscgIaUBsmMylk5vz88JL
         3mcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4cjDZSb+LqgsYKbIt8hxYdujvaKWjhp0jqOgOrwlo78=;
        b=bW+Y90Vd13B8cskmpuf//hYyn3eiKDBKeEjF8lWlhC2tOWaLdvK/KHY5bahWEjz39c
         OxJHzP1omGVN30+mqcYsyAbRuHk8E8owmdBKSD8CUjxmNJbTaVBWZ/9mP/wCPHF9Ie44
         yd25SIBcXNYEPVORiuAH2yixx6w0fhnFFcY41TTfNHK/5/XlqpPp7vS5Ta2HNJQE8T3w
         Gi3ni6cntCTAkhcdI8L87DRyoOvItukcCMecC92EV+g3pyVCOOAQEHkmeegLA9It9JhQ
         f5Lm5I2FsejSnDjnt6i1CJBXyuWKIDeaV4v/kc0de74y/RDmN47EYP2gwtQglSW+f0DB
         X2Ew==
X-Gm-Message-State: AOAM531GZQasxfMJsJPVUNJHtpzCNWjJy9R26eTZXRLC2N22xnGitUQR
        Pc17VzxxejAwDtMC59t11MqK3jrVvtxT7A==
X-Google-Smtp-Source: ABdhPJzQvpLew4excZ9eH0Xfj4q2au9n8yZEs9rJQrfJvIedAVKeDwmgyReFUAw9DbKTUSD8AaYI9Q==
X-Received: by 2002:a17:90b:e01:: with SMTP id ge1mr735239pjb.187.1601614390037;
        Thu, 01 Oct 2020 21:53:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r8sm335189pgn.30.2020.10.01.21.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 21:53:09 -0700 (PDT)
Message-ID: <5f76b235.1c69fb81.d9120.0dad@mx.google.com>
Date:   Thu, 01 Oct 2020 21:53:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.13
X-Kernelci-Branch: linux-5.8.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.8.y baseline: 153 runs, 1 regressions (v5.8.13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 153 runs, 1 regressions (v5.8.13)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cdcec6869074d67b3613977517deca1da249e43a =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f76783cad5e5b14538771dd

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.13/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.13/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f76783cad5e5b14=
538771e1
      new failure (last pass: v5.8.12)
      1 lines

    2020-10-02 00:43:46.645000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-02 00:43:46.645000  (user:khilman) is already connected
    2020-10-02 00:44:01.852000  =00
    2020-10-02 00:44:01.853000  =

    2020-10-02 00:44:01.868000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-02 00:44:01.868000  =

    2020-10-02 00:44:01.869000  DRAM:  948 MiB
    2020-10-02 00:44:01.884000  RPI 3 Model B (0xa02082)
    2020-10-02 00:44:01.973000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-02 00:44:02.005000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (381 line(s) more)
      =20
