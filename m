Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E1D3083DC
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 03:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhA2Cdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 21:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2Cdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 21:33:46 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C24DC061574
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 18:33:06 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b8so4430891plh.12
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 18:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=91Q21Mwjw1PHeNv10rRk7T+EgOBGYnoh/6m30IL+PFU=;
        b=D8lkmKddo99Re1BhjhJGemAfl+xf8Xu93IBzlV+y2hRePTv9i4fN/Ka/qlYMEe/LyW
         nhnHe9mblDyB5zKAE5R8iqbTHt9QVtp/3Ge+kZubpDLsZZzuaPe7wN4U5P+rkjFWZX9x
         X2GImAMJ87JpULAUjjyBniloh1F2cs6TGsZHqWaAicP4Z22bnnOc+eFa/N8h0bHFTBJu
         A+uYGmI8MBg+5Hpx5zG2djIZgTGetuqfH1Y+sA6v3DMcVLUcO/ACvsTS4C1u25COXV3U
         6iSBOKNr8qnFkD1O+N4v9iwwHb6CVw8+Ek7zmeKR4K8vrdbH88kbcPZOt0FYT8oNFrgi
         1L7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=91Q21Mwjw1PHeNv10rRk7T+EgOBGYnoh/6m30IL+PFU=;
        b=LB5FtCdoaF1wIGpowHlTxufZOT7SDbjdhrV8LTKHtVQoCwYxGWv9sh4BAXQPQexubJ
         BQV60p4d0MyYnu3A4m9eXcZUl17SbG/dgHS5YRR8PAwZ/HpokkRFn3AX39TshimW4TR0
         iGL7+gCGAE06pWN9g8FxRW03IE7eabaHaolcQoXHIUkvMfoSU/Cpkw2Fwi6CwBh2nZoI
         W2VwlME4XoAhSeOjWc8mDbahOapZMLWtDgTxBjMkq6pwQB8pd8tsDTqxX2NXqdZgUHCo
         1sSqmwe9QTR5iwM6E5tsN2Wi+WtsCp9CnmwgTKLaQx6A0hPM+sSEV2E1x2RBJllkqf7Y
         6iUA==
X-Gm-Message-State: AOAM530WG0o4vXb/OZv3Ee3c5TR2zMM0pspr+YE/NM1ac1asLl11+AyD
        Y5KERqWQUdkrzurvMHRXEnBFUkYTRiOQhA==
X-Google-Smtp-Source: ABdhPJx1IaoWN78XUNcfgPRov1tt9llbWbLOnhU6sithE3aW6VohFadTf+pNnw5Wn/RWZCPgQsqXug==
X-Received: by 2002:a17:90b:68c:: with SMTP id m12mr2303015pjz.212.1611887584398;
        Thu, 28 Jan 2021 18:33:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i25sm7256773pgb.33.2021.01.28.18.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 18:33:03 -0800 (PST)
Message-ID: <601373df.1c69fb81.6a87a.2541@mx.google.com>
Date:   Thu, 28 Jan 2021 18:33:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.11-2-g966747d2a376
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 191 runs,
 1 regressions (v5.10.11-2-g966747d2a376)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 191 runs, 1 regressions (v5.10.11-2-g966747d=
2a376)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.11-2-g966747d2a376/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.11-2-g966747d2a376
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      966747d2a376df607850a2a20a3acbcb65055982 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601343e19b689e0fbad3dfef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
2-g966747d2a376/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
2-g966747d2a376/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601343e19b689e0fbad3d=
ff0
        failing since 2 days (last pass: v5.10.10-199-g7697e1eb59f82, first=
 fail: v5.10.10-203-g7b2d1845e2139) =

 =20
