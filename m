Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4F344C418
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 16:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhKJPN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 10:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbhKJPNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 10:13:20 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0BDC061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 07:10:33 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id r130so2938036pfc.1
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 07:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pge2/n+Fxxw/b7YpX9M3uvGM7hMnksq0NQLIHHD3Vkw=;
        b=uGIFdvUmm37zXInthANHih/2LwbZEk2a6I6og86eVEyyg50+JfzTOVMf+jVP/SvMg6
         RKYVlzG0PLRALBlgT5LvmIEGZjZV2cB0oKJ7XCx4PAO0iUjwQ0FAKXbWDFYesijE9sxQ
         82cmCoIm4pEY5r1M8hQOTlZdQ/lsf8EfFr+O+JRC/Hv3VRAJp29oXQhH2CR1AkzRkEjy
         F4qo7ePMzyLlWna+t4DYqkLYRZsyhyOggxuIjsJ8h8AuFgqymTmkQFeF3GSjCUMXy0Zl
         jZDTlohzIQ5oLL8kcd3cR2U1VRK9xROJ6jIkLWELATbQ9038gwdnJFBVlQnrNc28zEiI
         +JSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pge2/n+Fxxw/b7YpX9M3uvGM7hMnksq0NQLIHHD3Vkw=;
        b=mVv9/OsEgSFqY8lVHL1oTiv3/hrQ+q+3bIjH9QfBH490b6nG/XVmOKOx+i6K7Mpst0
         tBgzYBxKtSG6S9wPAC9zwbH6v2hCyM7eow6qMahEg9hJ0YXMkDcPgbgRJTv2Iqw3ldG3
         w6zwqTHGMUkEuPsxdrAZ8iVYPyOdm9SOYdFwkUPQQIUDFaym4P7DMT28YUzch7bO4ikh
         5mXUxno5rsPwl87+JU7pRBMy2a91BkYV1zWsDK5MYU9akSH3W11Cbpp2fqQum5SiFVYq
         Or662YYlkGPPqH4K7/kwQzoPBSoonT5tnSCI7tsrnMvkHhgRQIzlv8ThPcq4jIID7RQi
         9OmQ==
X-Gm-Message-State: AOAM532wPszzpr99rx9AsiEAHVm7Lb6gLYsRicUgVsYI1OJs+9fkFNEl
        qEID3ZCqfGtJNv43lwZ5IwbWoTFBXmr2RbiP
X-Google-Smtp-Source: ABdhPJzXOlG6vNFp9S0kTcijIcPIzLqor9X46UhliOEvsSDqqqztDsAmnKwnItC/7vjdls2Ckv79sA==
X-Received: by 2002:a63:fe15:: with SMTP id p21mr325080pgh.477.1636557032564;
        Wed, 10 Nov 2021 07:10:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lj15sm40231pjb.12.2021.11.10.07.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 07:10:32 -0800 (PST)
Message-ID: <618be0e8.1c69fb81.15006.022c@mx.google.com>
Date:   Wed, 10 Nov 2021 07:10:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-13-ge7b157b77485
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 210 runs,
 2 regressions (v5.14.17-13-ge7b157b77485)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 210 runs, 2 regressions (v5.14.17-13-ge7b157=
b77485)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
beagle-xm                | arm    | lab-baylibre  | gcc-10   | omap2plus_de=
fconfig | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-13-ge7b157b77485/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-13-ge7b157b77485
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7b157b77485e77d90db1ab644c3d4d930be073b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
beagle-xm                | arm    | lab-baylibre  | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/618ba8d0cf3ef555c73358e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-ge7b157b77485/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-ge7b157b77485/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618ba8d0cf3ef555c7335=
8e5
        failing since 16 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/618ba6b7437c949d8e3358f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-ge7b157b77485/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-ge7b157b77485/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618ba6b7437c949d8e335=
8f5
        new failure (last pass: v5.14.17-13-gbb0509ba5901) =

 =20
