Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7921533FEEA
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 06:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCRFfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 01:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCRFfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 01:35:19 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952ABC06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 22:35:19 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g15so2706074pfq.3
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 22:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VOYSf0u50XdFWlsWORFK6Y+L7f2PGo/nQ6h/Q2X6Gn4=;
        b=EHeYNGVKTfKd7sTUcLaNuXjBj7Oje/FQ8Fd4IG1MJmu7Gk/7qosoVazoWskNGRaV8W
         o87cKKDTIEqBzSM/UXaPWgVK486bZgNvqZzjnZg+YqMiWiX2QsK8m0k3v0fSV74NZSno
         KQ6ikjVXZmpRmaqJdwFewMyzUr8M9Ae+yBrQz5LAyQSxwu4F5khe0wOi0YCQcHjnET88
         BFKR9me04oYRH6NmE6O1/6lDu3WQN5j3w7bRyLGEPo+WbZzHz7KW/WDlNVDJiDgGx9zY
         a8KAA7DW69hs8vtkBL1TnwaTAAsCkFoXch3/U53jHuh5CGlMRsHQY2Pb5PKQCjmGoTMD
         pPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VOYSf0u50XdFWlsWORFK6Y+L7f2PGo/nQ6h/Q2X6Gn4=;
        b=sZEglhQ2Er4gQc+3HnxMkHzd0eH554IG0lZ9jdh62zxypkdAJAmodaSVAhbv6wSc4V
         4hUZ9wblh+GcDEOMe3JVrFd+D/sc8tQW6cdyGmGsHNm7mPZiKgsHkU003dqbPxal8581
         J92K/PDrsmmFucA6/rfIYEiXtyDNMAUhRmREZlVnC1PWSYJ0rbkqlxIMcyqihQDVXYzh
         lNcpTyDtcEe1bhLF12/xACCiqWSmBQxsuruy35006IJAPdwiDG3C+D5L8agvgG3eluB3
         3crJtMVMQoumkmDE6xWyIAyR3Lu8eTGresuu2rFguGpldiuTj4/82fVuUII3B+bZalPT
         gu3A==
X-Gm-Message-State: AOAM533Rv7Dve0jnRywiF6QCHhUHkkWsuTTulVJj25mr07l1dlkbX37e
        fjCfKwdigcB4ShkWR2XUujaR/352fU5LeA==
X-Google-Smtp-Source: ABdhPJwgmWODLO0j9LJyCQoZnf2ylF95I6hd0GGckQ66N3KOs3FCu54JaJyUkYLVqlF1QOaSCRrrzA==
X-Received: by 2002:a63:3705:: with SMTP id e5mr5408691pga.318.1616045718848;
        Wed, 17 Mar 2021 22:35:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 4sm768695pgh.71.2021.03.17.22.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 22:35:18 -0700 (PDT)
Message-ID: <6052e696.1c69fb81.632c4.283e@mx.google.com>
Date:   Wed, 17 Mar 2021 22:35:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.181
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 115 runs, 3 regressions (v4.19.181)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 115 runs, 3 regressions (v4.19.181)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.181/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.181
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ac3af4beac439ebccd17746c9f2fd227e88107aa =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6052b27ba9d180e9b3addcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
81/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
81/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052b27ba9d180e9b3add=
cd3
        failing since 119 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6052b2cb040ec1be5faddcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
81/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
81/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052b2cb040ec1be5fadd=
cc6
        failing since 119 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6052b2437fa676b100addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
81/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
81/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052b2437fa676b100add=
cc8
        failing since 119 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
