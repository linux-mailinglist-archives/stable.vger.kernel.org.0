Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BC8363875
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 01:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhDRXJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 19:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhDRXJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 19:09:32 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8787C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 16:09:01 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id b17so22962693pgh.7
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 16:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xnd6IQP88xPQRKaxnHqn6DRWcpbGyS06Z2xnfFiLUIg=;
        b=nlFy9Cg5NIcgFS4rP1pmb3dTzW6xY8W5xwqI1tGFhEitvieVFpsGCysSzt1mcKgyPM
         e+4yikl3A96p6lj/8faxf8wWsx/aBx8ElKkseQd4LLjeRutDweoCQCYgm9mfbnBTj+fr
         1RmhIulb5+e/15+clqjr7GyKvxVpTXc3eOnIOPByXfPP00ga+aG5gNGFNCfneUZ5Au4V
         U1Zrl12yT6be0D16bC0WHgQyZAU1PaIs6GHYeFZ2OvPksiphcEO6xLI32eh6+fFVgLjL
         qqGFhHao1vW5ZnxJ+qqFp++wUf/PsSmAPdQmGb3AaKyjDSIxGe8cbwbF4URrZ0bDrcnE
         Fa8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xnd6IQP88xPQRKaxnHqn6DRWcpbGyS06Z2xnfFiLUIg=;
        b=EsCZDUIBvRuqhlp/tz7FtkGSjhiZEQotvmPDxarLeWWSoRzln6EvHvbcc9RJssXafh
         5E1HDVJwKeqww0GrDxx5aUguYjNVl//ssQFbm9oPO6xDiKmJ5RN9qPCl4jfZSHv0Vh/Y
         hHVTvNg/oh5tBXBEISA2lgmOpzmgCoHaDsTGBy5zqd6CX4Vpg7FdR7K+NOJoDgl/62Ka
         +t0dzdmybNZcDMN5BjialCHkjdnKZVg9w8lZNxBbduUFt8QfmP6SwgHyT2GJYrZWAS/8
         x3ERXovheXjfvkvMa+hXdsuNf1kwZz2pFo0mKz6O7cirJ1ljwG35HrJYgVlM4Z8ab8v7
         Yrzg==
X-Gm-Message-State: AOAM531xOopC0b7TpeD7MEKQuH2HF4vKLJjSYcL2p68iE5rgnpuHDSQE
        f8+RmYxqeH/iGEsLgM0s0ZsAU64T3GafjJ/b
X-Google-Smtp-Source: ABdhPJyaCBQxJ7tFM7gWoe/5Amug8O8oP9SqqigR1W8yXj6J3rxvcPHkSrzJ5zw9Iw+W+zItmJFkSQ==
X-Received: by 2002:a63:5963:: with SMTP id j35mr2854300pgm.281.1618787341050;
        Sun, 18 Apr 2021 16:09:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w189sm10222713pfc.31.2021.04.18.16.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 16:09:00 -0700 (PDT)
Message-ID: <607cbc0c.1c69fb81.ec5a0.b1b3@mx.google.com>
Date:   Sun, 18 Apr 2021 16:09:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.31-86-g6e26851a4e8f
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 93 runs,
 1 regressions (v5.10.31-86-g6e26851a4e8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 93 runs, 1 regressions (v5.10.31-86-g6e268=
51a4e8f)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.31-86-g6e26851a4e8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.31-86-g6e26851a4e8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6e26851a4e8f39f4016f1612deb60f54027116c4 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c8027a51bca3c0bdac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
1-86-g6e26851a4e8f/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
1-86-g6e26851a4e8f/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c8027a51bca3c0bdac=
6b5
        new failure (last pass: v5.10.31) =

 =20
