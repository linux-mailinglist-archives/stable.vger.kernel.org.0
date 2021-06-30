Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2823B7B93
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 04:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhF3CiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 22:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhF3CiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 22:38:02 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D17C061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 19:35:34 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a127so1021014pfa.10
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 19:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=81TnGpu6YsMUFdibnucm4ubmNZOvJc176zbqHUZ2DSs=;
        b=a06jnNF4p2ZZ5vU/+yF8n73XJT7HrWWIHD74t/TQ29eJt4C0ljY/GsLhryLxJffYjo
         nBTp8eZKbVBeLmG7Fuy/UdRtYxrM8Nx/sbfSsbPqz5RnU+fTnnnEUIXEJMerscpCfAE+
         W+hPp4Pb92tcr7j8KZs79jqHEda9S/ofFB72Cih2kJ3mSfgwdlK78eyuB4dpDqJs6aAz
         OzRJ+jlmSx78EX4FSoJI51etj4J07VNt22vgNOc2g6HAmyjnrUJBPhM39WFwOtXQbL8j
         pTwTYyW8N086Vj5h2ctzkyH8/oeU4IMw7of89oGUusqRIL72ei4wBZQntI/briFjpwwk
         DSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=81TnGpu6YsMUFdibnucm4ubmNZOvJc176zbqHUZ2DSs=;
        b=tTMuP6yVWZtrY9c+yPgwIO0ie+oR5j+S+g+pKDU63e6Kl5EK7kvWwrdP/15IaXRVW6
         0coyjgxRJbAuBf5IqWjDSaIdz9bvcrjru+SMj3rgcKXQVfeqkhPQTFltw14Q2JAneXMT
         8k6enRqIRqobHuH8qTw+gb9qtGbTWsciKsEqNkaHQY5lSqsFVHuVihiVqTOyGSXSLKBK
         dbR0GVTOCDvbY70ReY1jhzBS+ELsAC548OLH5Rp+HPO2dDbo8YUiT2lpyiTiBG/E/77H
         BUTbivKfc8czQeLmgRyH78a0zPtKEyhfEAWsjO2ntYDw1wIQSzqsKOlkUAhzDbZfz+65
         vKEA==
X-Gm-Message-State: AOAM5321Ih0qsKBJU/+aO1Q1SU6gFafJEfs2GuLro1PUi4wYoy8TH8wQ
        ypalZXbFekdeFgsORCbooUdhiEYnjUFxsuh2
X-Google-Smtp-Source: ABdhPJw/rGCM/gGgv0bxvXFrHLHdZCp/jtEurBmxaK6d7pFCl0a8dzvx80toCZPrATsu5MkdTeNayg==
X-Received: by 2002:a63:f256:: with SMTP id d22mr31529240pgk.399.1625020533723;
        Tue, 29 Jun 2021 19:35:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x13sm20343233pjh.30.2021.06.29.19.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 19:35:33 -0700 (PDT)
Message-ID: <60dbd875.1c69fb81.1aad8.c7de@mx.google.com>
Date:   Tue, 29 Jun 2021 19:35:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-70-ga70498c6df777
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 99 runs,
 4 regressions (v4.9.273-70-ga70498c6df777)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 99 runs, 4 regressions (v4.9.273-70-ga70498=
c6df777)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.273-70-ga70498c6df777/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.273-70-ga70498c6df777
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a70498c6df777cd2ca19edbae97f6e0241eb0599 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dba3841ae30739f523bbed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-70-ga70498c6df777/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-70-ga70498c6df777/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dba3841ae30739f523b=
bee
        failing since 227 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dba3881d0e7199e223bbbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-70-ga70498c6df777/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-70-ga70498c6df777/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dba3881d0e7199e223b=
bbe
        failing since 227 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dba4b26f49a9375523bbd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-70-ga70498c6df777/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-70-ga70498c6df777/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dba4b26f49a9375523b=
bd3
        failing since 227 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60dba57d6d08c9505723bbc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-70-ga70498c6df777/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-70-ga70498c6df777/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dba57d6d08c9505723b=
bc7
        failing since 223 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
