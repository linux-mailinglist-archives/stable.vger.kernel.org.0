Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDE531B476
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 05:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhBOEA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 23:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhBOEA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 23:00:28 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE390C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 19:59:48 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z6so3417788pfq.0
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 19:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x8BkWBeEntV0Cyj83/L9vVDKJKmV6U1BH4NETwwZ3w4=;
        b=JCTCuJb564z5ateYDj4tioYc6svwcSyRHIfkAKFsi1tnk7WhCuKPsW+EZvxpsL8kHn
         /oJAuRwxlkkdY0pTkFfvIClO/J8fzpss509UN3Ixxiy/bRZTOEyUBER3yorZ8sfXll4i
         i8CzAn6W7URJ3NWJA6ZSN/mSn6kPB/ObO+7O/mdTrddD9Wk+gs5ZkFV8K3x9bTLhU0zv
         3YlP0hufi6KxZoS8Un/RYXuH8cl0zuyXRT2rs2aPj04w7qwLXrNsZ+nAp/EP0l+2ALuG
         28Yz3LcAS9A6pQ++tyUIMOcGSt9ArenVke9Y59NmHHQXeZw4jVoiUQgKn2yxlee3vm0z
         X0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x8BkWBeEntV0Cyj83/L9vVDKJKmV6U1BH4NETwwZ3w4=;
        b=ACGsl3I1vMseZJxCeFvSDlR1UihVSOsgbUCp5djNxXLJjLhKJt+WwN9CfH05PIlnAU
         qFJOmbjGTBNRr6B5oYe44qrttkhrphcpqO8hGkZ1OKJt1VbXE7FYWztYC9nhkVdO0ulq
         7vGbCZGsLKcKABNL3bzkj4Ny6433OwzEWG1AGp6qhGHAyk/w3LWHxcf8PvtOGQQTdvQq
         RDabHNFImw07FqphE+4u8/SB4ZG+iGyvTPnCnsf+cxK4H0PVtguTndVOfvFuQwU/gHTD
         qXiSuTpZ33nKQLuabFfeteiS7zkG6t6pRRMXrOiPp2T+TkE2QSbtBGvntsO4ia4BpCCy
         KVGQ==
X-Gm-Message-State: AOAM532oExJPWEhTw0Sioq+k7rdRJ/QSedRtG1vmfYN0gd22woAbwrIt
        MNiGghSh3jubfXpOYk1NUsD/YGBeseBRAQ==
X-Google-Smtp-Source: ABdhPJzjwEuJXEzNpJlvjWo0yX+RrY6Kl9vZB4SNJ+Ny4Pmu9vaCbe/UELnQSZYkTkKEoigwRnPLCA==
X-Received: by 2002:a63:f447:: with SMTP id p7mr13080664pgk.243.1613361588092;
        Sun, 14 Feb 2021 19:59:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z125sm18635399pgz.45.2021.02.14.19.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 19:59:47 -0800 (PST)
Message-ID: <6029f1b3.1c69fb81.40b88.8472@mx.google.com>
Date:   Sun, 14 Feb 2021 19:59:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.98-25-g5c3d6f8d21fc
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 91 runs,
 1 regressions (v5.4.98-25-g5c3d6f8d21fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 91 runs, 1 regressions (v5.4.98-25-g5c3d6f8d2=
1fc)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.98-25-g5c3d6f8d21fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.98-25-g5c3d6f8d21fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c3d6f8d21fce78460d28c614b5b8a5fe1d77eea =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6029be246521cf91a73abe80

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-25=
-g5c3d6f8d21fc/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-25=
-g5c3d6f8d21fc/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6029be246521cf91a73ab=
e81
        failing since 86 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20
