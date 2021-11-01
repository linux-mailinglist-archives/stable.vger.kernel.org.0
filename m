Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748334413AF
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 07:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhKAGVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 02:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhKAGVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 02:21:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B48C061714
        for <stable@vger.kernel.org>; Sun, 31 Oct 2021 23:18:47 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gn3so11475126pjb.0
        for <stable@vger.kernel.org>; Sun, 31 Oct 2021 23:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ha7cfhc6yTvJkXTkDkgwNcRc7sv+1bxJj21FMtYbdZQ=;
        b=noEaPZBfNvcA1p1EFgweWaASEHX6oMYhCKzP/XCTnbdQSYevZ1sEphTGkGOvtEJtY7
         5EkJNHfLKyy02UwxBioyBOrLRlw9cjedkSeNG/0576x88m0w7f9hNNPmSguPWnOPn9Q0
         44AgD6K8OQ+yVO1vKW5rOSHi1jb93ecjvYHUB3RQ5a6LU27ErxtO8IS/zl+3thwcy2ol
         71ZYGg62KKF8OIJNR6NZjSj6vt6RbfaSWdoTfQeq2ENg2c+QNmILFd+0weCksNL0SGYq
         39RtwX0fl6uBwUQYfW6NA2LxUZTePMdMj5PoQpNECn0ugjJHuA16oWExCivfpf9vUxZY
         oqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ha7cfhc6yTvJkXTkDkgwNcRc7sv+1bxJj21FMtYbdZQ=;
        b=4tXF3hXnNlFir6PDGe5GjiRinUT0BxBHjm+4Fsum7nOdCpG35Z/E0lsT7TTmldabrN
         pGlMIHvg/1vgbrCbb3xlWwuxxnY9QGXLzqr1CxSu1BL0uoC/7kYEfcsykCqhJmS9eiNY
         qnbH0uQAhxD+CBKE1L2GZQmjNIRJJunjS3PgH+F7k9OzR8JjOVImTlYsBFJcKNoWjZt6
         q8ig0TN+sujSJKQoU/upmn/2yHnGV0ohGH3pkUJw3Vwq/JNHA3mFUbOMNXEoO2XViOSe
         3BK6wXM2qzjz3lTnxa/zZ2NSk3LgS0b3sHoGb1KHXYC2IOetmozuryRTbfPFmlEHfAd8
         h0fQ==
X-Gm-Message-State: AOAM530BVurQbOYfAzWgkh9tnUGXOy5CRRbuulWubG9Mos3qL03P4Egi
        Nesc2JFvFLaMsXdHo9Yv2wDN41R/GVjwfoTh
X-Google-Smtp-Source: ABdhPJzrNaESI5n9GUkxnNUVPfFNbZ3TAEdL8KyWA0raC87C/3V6U6y8oABwUAE+jryYDe/baILZzQ==
X-Received: by 2002:a17:903:2452:b0:141:aaa9:ca9b with SMTP id l18-20020a170903245200b00141aaa9ca9bmr17630413pls.48.1635747526497;
        Sun, 31 Oct 2021 23:18:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm11732183pgf.14.2021.10.31.23.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:18:46 -0700 (PDT)
Message-ID: <617f86c6.1c69fb81.a01cf.14c1@mx.google.com>
Date:   Sun, 31 Oct 2021 23:18:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.15-116-gd02faacfbbea
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 120 runs,
 1 regressions (v5.14.15-116-gd02faacfbbea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 120 runs, 1 regressions (v5.14.15-116-gd02fa=
acfbbea)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.15-116-gd02faacfbbea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.15-116-gd02faacfbbea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d02faacfbbea752be2d3c3494fa62af785dd9b6e =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617f55f514db909480335906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
116-gd02faacfbbea/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
116-gd02faacfbbea/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617f55f514db909480335=
907
        failing since 7 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =20
