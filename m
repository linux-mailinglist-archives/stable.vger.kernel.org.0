Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962A93343C5
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 17:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhCJQyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 11:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbhCJQyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 11:54:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE70C061760
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 08:54:21 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id l7so12493624pfd.3
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 08:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k+NipdSeb5WTAVT7EvJrsB913ND+Jy11+U3EDK8J8oE=;
        b=04gm2q29ScDYQB5/KgQQHjYU2lyXytKuw28uYhfF2Vdn1m5p6jqKIFYmARZH8ZkYdx
         Q61/jornYmDUIMOyIL0bVqDEKgbdKl892SKs/RUOyt59br6gGX/OGDiIWgWDZRWHNBfP
         qvahLgb9GhrZmv7neH+NmkyH1KhuCK0LmCXGSH4Zkvzsg1Fm+b4uC5pZrzTu6XmiP3D1
         x4QF3hLrhGXiw6vkShUbHl/zRssWXSicN199c2GB8m2KxAPwJpS8h8MPS/cMZPkF4hp2
         mAeSq6/atsEqobyxvdUaY/ykvavkZZ+2gGoR81asXSZjRh5t09ogcA8J+BcZuGDtL62E
         hvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k+NipdSeb5WTAVT7EvJrsB913ND+Jy11+U3EDK8J8oE=;
        b=hfqa0oMJBhJ05L/OOQIP9vdHiIU+Rq1rNFym/34uN5mCIocz6Ze54dWsOV2cD4IsMe
         eul/E+ApS4Yz21ntOp0ZI/BQcnyLf62rm1HFOa9pIsYewTIYzQkTGlS8AWC1FIPehbfG
         lhX/CWNMRZxpL76klx/jDbgKvVwufdQ5PINPUYtzLeHjnZ4KPIDSsWTyU4qr9ff7MVlb
         /kTY5Q+2dkwesxCvyf34laegtD6S/ADRHYIYJe0BIIQrq1gKrRsiXUK3mG/nBnKFIfBH
         lDXG2J3ZeQgNDzY6wL4cTVI7lWZ+VZQ0YcElcEzRet+CjqW0/Rv/R/AMKe1mhn5hciY0
         uOPA==
X-Gm-Message-State: AOAM533zGpsAqbKyY0LxgDf0RuAAw7KE0CR/wR1c6zHkxlFPZaeRIVo9
        /PidE3WjmCI2FKM22V/h3RDlndjrfBFKEBR9
X-Google-Smtp-Source: ABdhPJxZ8uVK9PtlZ7AQ4o1cF/BxZPQ5Vf1JRKZljzWXd6Z2S83VorZAy586qrO+/uM+hWml/g+g9A==
X-Received: by 2002:a63:c02:: with SMTP id b2mr3517175pgl.53.1615395260750;
        Wed, 10 Mar 2021 08:54:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i62sm127080pgc.11.2021.03.10.08.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 08:54:20 -0800 (PST)
Message-ID: <6048f9bc.1c69fb81.c2919.059c@mx.google.com>
Date:   Wed, 10 Mar 2021 08:54:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.22-49-gf5829772d607
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 87 runs,
 1 regressions (v5.10.22-49-gf5829772d607)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 87 runs, 1 regressions (v5.10.22-49-gf582977=
2d607)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.22-49-gf5829772d607/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.22-49-gf5829772d607
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f5829772d607104e9464440b692c1c0671b9c93b =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6048c6e4ac043104a7adddac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.22-=
49-gf5829772d607/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.22-=
49-gf5829772d607/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6048c6e4ac043104a7add=
dad
        new failure (last pass: v5.10.22-1-g3a720b3b47d5e) =

 =20
