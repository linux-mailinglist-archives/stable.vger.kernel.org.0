Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF393A0A1A
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 04:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbhFICjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:39:14 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:35523 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbhFICjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:39:13 -0400
Received: by mail-pf1-f171.google.com with SMTP id h12so14410402pfe.2
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 19:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z3Yxbn3rbUBZb61ZP/nUJ87L4XytUJiYbYVxlmLyXyY=;
        b=WThYBL1lrpORSDLm9WSDvgXUMrtTsga1AAzyw+2BRgt2vPkVjDmT68BWW5i824cDCQ
         UzGed/FeHBv5DLZsplBiZoB8P2kvukzLWyRwEo79/i9UuBM9oPatIvLsLNHGQ8teL4vJ
         t1VGp7rxlxkVx4PgheZ5MGWygliNKV8jX+QW8xFRfEJ2e720FApr1ei26VzSFhyrpBwz
         QKIaZLqQZgPYnjJBkazy2Q9Bht+GZgyquSYbEimBzxawjsWKtLkQDDcFmBUORPdw8d7M
         /oITHvHfMMCl/QfO+k48Fg3WRpwQOdC7WdkHPGxBqZ0YoUw76Ed02x9Cx58C+UJSofqO
         Ch2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z3Yxbn3rbUBZb61ZP/nUJ87L4XytUJiYbYVxlmLyXyY=;
        b=q7iGNLGvK7/1WciBxBcMO9fOC6vwWuIo7MaOkqKddNohyAaRJypyeABrsf2FUzti81
         J8BrmkMiO73Q8/6XQ6yL+qJmmiLt8QaPUNZdKsJgGnDWR/N7Wp1dNprwZWyJwrqQq8Qq
         uGvKfIPRwXqZ+x/khUzVXuY6b455c0gVeTdLx85AcEOBODEoosUL4a4IXm1yvrrMaFyE
         8d39/cIvejBVO7VaGElS6j8wWYTdes3IbG7oqWLyU62Ws8jl4PTrUYJ+IR6rHX2BFoNd
         ReJpuhIWSQJnf7/zVj023nHKk1tiMCKZFo/2Ies9EE7NlsQ3ZcTJB5vbZJXvuN3YiXXT
         OQZg==
X-Gm-Message-State: AOAM531h73GB5Zn/YrhHFxIPGPxAKQRVE7CQidayCmDMrNk9KBLVN2pt
        aEPgZDjWJgcgAASc7Hsipm/37AJVI4PWq9zc
X-Google-Smtp-Source: ABdhPJxL9YM8UMDpOsKU2MTHvNBb+u4zNEsCNWiu4UfqwPcE3EMqdfZlpZ7TiLIyLaPr0QJKTOpibA==
X-Received: by 2002:a05:6a00:170c:b029:2dc:dd8f:e083 with SMTP id h12-20020a056a00170cb02902dcdd8fe083mr3020674pfc.77.1623206166140;
        Tue, 08 Jun 2021 19:36:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 203sm11862732pfw.124.2021.06.08.19.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 19:36:05 -0700 (PDT)
Message-ID: <60c02915.1c69fb81.d4220.566c@mx.google.com>
Date:   Tue, 08 Jun 2021 19:36:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.271-30-g5f3a05577796
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 114 runs,
 5 regressions (v4.9.271-30-g5f3a05577796)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 114 runs, 5 regressions (v4.9.271-30-g5f3a0=
5577796)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.271-30-g5f3a05577796/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.271-30-g5f3a05577796
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f3a05577796b0a04f9705503ae9cfbfaa10cd8f =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bff4d5087b16af4e0c0e16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bff4d5087b16af4e0c0=
e17
        failing since 206 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bff4e7de2c61da780c0dfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bff4e7de2c61da780c0=
dfe
        failing since 206 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bff4d72b490337070c0dfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bff4d72b490337070c0=
dff
        failing since 206 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c00e77c05af0e2cc0c0e3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c00e77c05af0e2cc0c0=
e3b
        failing since 206 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60bff7000a112c3bb10c0df5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
-30-g5f3a05577796/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bff7000a112c3bb10c0=
df6
        failing since 202 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
