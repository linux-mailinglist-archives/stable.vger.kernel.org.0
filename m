Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C53D3FC187
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 05:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbhHaDeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 23:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239419AbhHaDeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 23:34:12 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5189DC061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 20:33:18 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d17so9758412plr.12
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 20:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VH19fOIaNxLh/AO3s5RAJI4mcKVSwCOwzlnzPYPVpgU=;
        b=cbGnrFINUf8QIMv1zKNqb9GVlESG7TlEdsLrtGvJt//7EhvRHyuzZjF3uGS+jMdhO9
         QozOX3OoC852qpLdRaNcHJ/rU+5No42mxySeeuOqiYkyt9YvaJUqrCOi1UzHj2VGOzGd
         nfh645w4Fxaz/2KpXKToJjWM7N1R/AoMrMionX6vr9xUucKas92VVAVqLlR0Sye4zrR7
         wEWbaTgT87JCTQns1S2azQV+G0tanhBKSLZBLmjcjtwjSkIVZz//KVSnq9DgaA93oWXS
         FPzrGZNdkpatJDX7kTlEnRcFzkX6K8aLQWmLePVo6u7/DVqVjqpR/zr+aaB0xtFQOYvF
         oVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VH19fOIaNxLh/AO3s5RAJI4mcKVSwCOwzlnzPYPVpgU=;
        b=hRzcuao8mSRBuho9pVx4q2MJwrxybMTkRvf42yjpiP1RognJLju9i8llc98Gnbst0I
         zQQ43IrfssdEjbs1kGO8akrkWUxbGKdAYjVAEbrmHxc2nJRIULeLs4TQf7HbcpcH53UT
         Jgd1eQFAmrDGxCaM3oWMEV0AdZt2wPxhZ3fjROtvUXP4XdxHOSczWaNv//5w9VFeOuEY
         EyKQy8X7FiWebdbCyhLqZd7IsiCwjNRS+HHPKBYlZy16tRL0nSE5S7NY2Lm8We365XZx
         NeQoFztm3IAPBl2o9mAGjk8hBD7mg0YZOYN44h56ZZL72FI4nyHDhQmmxBQGxQEA4/I8
         WLQw==
X-Gm-Message-State: AOAM532XXvpmqpCbQ1kYRz3wGgzUO62CGmBVayeYscIfWr+ptqZ63/WZ
        C3O4UHJddRm39Sb+VK0TidjFQly2CaQdApoK
X-Google-Smtp-Source: ABdhPJykbYW34a/3JZheVWys5BTiu9lNsatiSN1p+CzuFYkVecKv8uwcKhQp6nv95vEzfkycTHhYpA==
X-Received: by 2002:a17:902:680e:b0:138:b98d:4f89 with SMTP id h14-20020a170902680e00b00138b98d4f89mr2662211plk.31.1630380797646;
        Mon, 30 Aug 2021 20:33:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cq8sm867754pjb.31.2021.08.30.20.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 20:33:17 -0700 (PDT)
Message-ID: <612da2fd.1c69fb81.cd6e6.3c06@mx.google.com>
Date:   Mon, 30 Aug 2021 20:33:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.143-36-gf36140bd70f0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 152 runs,
 1 regressions (v5.4.143-36-gf36140bd70f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 152 runs, 1 regressions (v5.4.143-36-gf36140b=
d70f0)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1028a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.143-36-gf36140bd70f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.143-36-gf36140bd70f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f36140bd70f06d2c3e8b9f1a8146d095ac7bd486 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1028a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612d71255a93c5cd638e2c91

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-3=
6-gf36140bd70f0/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-3=
6-gf36140bd70f0/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d71255a93c5cd638e2=
c92
        new failure (last pass: v5.4.143-27-g38b5b40054ba) =

 =20
