Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86D838BA82
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 01:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhETXo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 19:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbhETXoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 19:44:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAFCC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 16:43:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so6126430pjo.0
        for <stable@vger.kernel.org>; Thu, 20 May 2021 16:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IVM5/UQgkZC9eo17QagYAgEpcT4OnR2AEUlxqz/bvDA=;
        b=KxPj6Jfme9YNCelekbEpzq9pwYvJhYPR+ib5mZa8K3uvw3N4Pw8TEfJTzLLK4RwLm8
         iuwvl1Cwl+b4ZrgG+m/wc6w3CPDYF6usBvRIjDzvLE4jqNwy1tniWUm2Ke2SffpCEE/J
         8gRI904UFYN65SpyNAReBlTK9S6Ldk91475/qSsp2rCTVTGTFvcnwxIrXqUvCGFg0o5O
         lPj+CHGNnwt7IcDIipPaUgFEQLfR4yZ9/myKgxeJ01TBzNaLDhKiX4LHQ1xRQgRznLvy
         rqIZWrOOUQy2ofJvoU6rZI9UEAzeeZQB1CyPBslcQd3EbIrb8Ec8Jr0uw5ChDaSNS3y+
         Fx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IVM5/UQgkZC9eo17QagYAgEpcT4OnR2AEUlxqz/bvDA=;
        b=RAFStNzsKjXkA6mFUffV4XGkR6lWZNchZYQYXsmoxHlqGCybKzd4xwpqDEiDx8u6Vp
         gjqWTXn+xYwKLGr54JUGshpr9gbgO3Jpq/BEDPdVJAHF2LpE8SEvEPoWM1WVqKGm9zAE
         6EXKZKvm4YUYbG6MIh+1wJTntjjClMgg+rUJ+k9go+9m7hq8n6aCd9DEJ9aLjL89exj7
         7i+6QeJOA/FVATXFBCm6tRtoaItn4ToNjxZGc/pAoWB1dNf/YEb88LE/WmbaF7wk7JUg
         bfahgWtq5a1FeSMjpGCqOVY17qveeCgWl+f2nUj7vc795qnt4tlwrkWEe0SyGkyEGSiY
         4Ipw==
X-Gm-Message-State: AOAM530MYcOjkdXOJseb+Wbmx1Hz3m0/Ox7odbMizI9a3Ol7EgoFZFsZ
        Zbbp4dCBiFXAiMhIcCKGyfaMyJcXI10K9nQD
X-Google-Smtp-Source: ABdhPJzw8G29iGkyYn4xBh93QAVt80Nz8B+6M+QWQIiPDZwVEMJQ3PwS95iBi9EYU+xsElhRduCjtw==
X-Received: by 2002:a17:90a:a78d:: with SMTP id f13mr7314415pjq.161.1621554208320;
        Thu, 20 May 2021 16:43:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a20sm2719490pfn.23.2021.05.20.16.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 16:43:27 -0700 (PDT)
Message-ID: <60a6f41f.1c69fb81.7460a.a417@mx.google.com>
Date:   Thu, 20 May 2021 16:43:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.38-45-g526ca80c867f
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 156 runs,
 2 regressions (v5.10.38-45-g526ca80c867f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 156 runs, 2 regressions (v5.10.38-45-g526ca8=
0c867f)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.38-45-g526ca80c867f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.38-45-g526ca80c867f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      526ca80c867fe70e4fa95d8a2cb8e13644b3f319 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60a6c044e17205b727b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.38-=
45-g526ca80c867f/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.38-=
45-g526ca80c867f/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6c044e17205b727b3a=
fa9
        new failure (last pass: v5.10.38-41-g8e0181be4efd) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60a6bfe05f95cc43aeb3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.38-=
45-g526ca80c867f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.38-=
45-g526ca80c867f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6bfe05f95cc43aeb3a=
fa4
        new failure (last pass: v5.10.38-41-g8e0181be4efd) =

 =20
