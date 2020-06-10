Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05311F4B96
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 04:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgFJCrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 22:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgFJCru (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 22:47:50 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D4CC05BD1E
        for <stable@vger.kernel.org>; Tue,  9 Jun 2020 19:47:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id g12so363097pll.10
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 19:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aKw9+gUq+nM1Cd+T7irOp8CT/HdazVVNohge/qz4tdY=;
        b=EJAGxGO1JECSAtvqexAq9HbbvRjgaiv7jPrw8jc6JGTYQGKAOpndmxPhMzSgxgSeys
         rgIWtN0IgLpWMSah1fEXoenYWoO0N6tAa+deOu43urNdmlYRALhd3V2fgyOizDyc5Xct
         ATBtltRygFOIp+7lOIZrsAq9Q1xF+KEY7emm9EbRyXhOOcu7fbsr6t/CDCknZD0tQSw3
         TxE4kVbccPWEY2mh3Ilc8qYLgI5MYAorUuVenGSzEgWMd7gL1hTkXUmxqjxiiEcmK/m7
         jtZ33OAzffz2n4CyxWc2utPBxXBKwvdtioj0Uel6SEMNKj44qL/90ImYvBKCIvuHwelo
         p8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aKw9+gUq+nM1Cd+T7irOp8CT/HdazVVNohge/qz4tdY=;
        b=ktNU/rYJdPaRGSqHmJY5y6t6aPovjyO2OglTM9aOoXRD25BT/37KmcBdG7FjBKHC7G
         FdKp+br4/oetL2G90WSJFSfhQ9vgL4E/d77qWRDHkSWezRzQwRinUc+qnr6HyJfX/6RS
         qMEa/B6oy0NTXpXPfiQAGVsT2XGuqJf6zS/F3a2GCfhBzJWd0B848F5O1JMnqdDwxJ28
         sbUDIIGze6TIUBS8T7F/+jXn3n+cUKgbetkRh2se8Xw6nRjHWtHJGuXPAITIJK3KsheO
         nQ+QgspbV0STe19BWpaWc+v8EnkrR4AyTuT5bdgef07K7tLIUPRs+EW1XGUmIb37FGAt
         ek1A==
X-Gm-Message-State: AOAM532iiKqC0z0EpLiCAbnYvRetUYyvuWHLe8YebrHRLYsyzGJ3SIPP
        224TD2/q9zTQjo0J0D0l1iBqOueaPZc=
X-Google-Smtp-Source: ABdhPJx6ndeWBlu5krCKD9gL71EveCBoZP9MYSe0HlerjbNDjVcakF4kBhBbqipObwzK7ErcHQLF/Q==
X-Received: by 2002:a17:90a:eb0b:: with SMTP id j11mr882533pjz.72.1591757267681;
        Tue, 09 Jun 2020 19:47:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i5sm3568146pjd.23.2020.06.09.19.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 19:47:46 -0700 (PDT)
Message-ID: <5ee049d2.1c69fb81.32aac.be65@mx.google.com>
Date:   Tue, 09 Jun 2020 19:47:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-47-g9817cdae1b62
Subject: stable-rc/linux-4.14.y baseline: 87 runs,
 2 regressions (v4.14.183-47-g9817cdae1b62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 87 runs, 2 regressions (v4.14.183-47-g9817=
cdae1b62)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
0/1    =

omap4-panda     | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-47-g9817cdae1b62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-47-g9817cdae1b62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9817cdae1b62b5a7d9c2b690e448512bbe175285 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee013feb6cf3d6e6d97bf1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-47-g9817cdae1b62/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-47-g9817cdae1b62/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee013feb6cf3d6e6d97b=
f1c
      failing since 70 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
omap4-panda     | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
3/5    =


  Details:     https://kernelci.org/test/plan/id/5ee013bedb15caec5a97bf14

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-47-g9817cdae1b62/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-om=
ap4-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-47-g9817cdae1b62/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-om=
ap4-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ee013bedb15cae=
c5a97bf19
      failing since 4 days (last pass: v4.14.182-77-ge64996742439, first fa=
il: v4.14.183-23-g6b882ea9cfe0)
      2 lines =20
