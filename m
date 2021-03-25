Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BCF349481
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 15:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhCYOs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 10:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhCYOsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 10:48:06 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A3CC06174A
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 07:48:05 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id m7so1996131pgj.8
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 07:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nbDZg2lH5TsEPUq1kBEjNF6Nrs9WuqRjtFQMSvDJO5E=;
        b=Hf18sDhFEqlh+c40I3O69uIOoGkAFf/Uafl/ZwKNNJWcOx+Dcnhxan0Z72d3siV18v
         +JCWqoW4ZPJa4yBzgJmcbNUzzqoHVB9OA12UoU5PxHBSoNZkgIjWtM8kV/BQH2O9PWb8
         PYdYgCW4fkZtXXDPvJM1mH2TErWVVy76r1zqV0OvaLUvlDWgJhoY+jgD7zIRgFM/3TFo
         T5sc3X89hFyrGhQ4tu5xDeE1qYdBtPOfg+ZOM8iCSJZzUZa+fFG+pvcVq/AMbuPGA7FU
         oEWxEaADct0BQzjiNczrdOBYbo5YgTdXyJP8krfu9n7GmkTShD3cNPpwS7BHYLEQbucL
         wDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nbDZg2lH5TsEPUq1kBEjNF6Nrs9WuqRjtFQMSvDJO5E=;
        b=WuvsYBd0bi0VgcPAAX/vfHb0jNXzT4cmfOCwgfLm6A7Wi7E+JfE7Q4MG00UD0c0XMi
         hs5UpOD2KUH7nW96n2pNd+TD1Ypi239k1nHK3M2rKl8DYSyeXneXByBcr101AAkvRdZS
         gFxuuQb897hn2uR9xXcTDHdUt0nFd5KKa4p31arblL2gIM9kSVB1hds9DieQecizMjqz
         XwaOVwTjZtvt9bE5PY+9AUBkQKzMrRPRmKgaMkMNpuB+akFXpRfNBiReHzsacloQddU6
         ssm1QOnq3MHaWbm/FK9M96+sGTxd7cELvRwSuWzZRI8OUS2CTvnQSSume8k7OQDEpWRk
         HwZw==
X-Gm-Message-State: AOAM530a6KvORbMWdzAMLztxVctRVQ+xd+NOmphAQA0tiPqSANCt8dLB
        EMUYfRvbEzDuAly0TkH6/CkGp9v8KzRuSA==
X-Google-Smtp-Source: ABdhPJzip/H41PS3MBacyGe/ZRQYFt2RmUqp0AsroqisZ4w/tciYPA/u4g2XfoD63GecodIb4ESD+Q==
X-Received: by 2002:aa7:8187:0:b029:213:d43b:4782 with SMTP id g7-20020aa781870000b0290213d43b4782mr8358846pfi.26.1616683685311;
        Thu, 25 Mar 2021 07:48:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t16sm6265059pfc.204.2021.03.25.07.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:48:05 -0700 (PDT)
Message-ID: <605ca2a5.1c69fb81.43e4d.f1b2@mx.google.com>
Date:   Thu, 25 Mar 2021 07:48:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 146 runs, 1 regressions (v5.10.26)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 146 runs, 1 regressions (v5.10.26)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      856cd02bbdd412bf91ce327a3c97c52066f11c79 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/605c7080d6b79b63d6af02bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
6/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
6/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605c7080d6b79b63d6af0=
2be
        new failure (last pass: v5.10.25-151-gf6bd595b6fdae) =

 =20
