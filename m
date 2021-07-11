Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B693C3F4D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 22:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhGKUuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 16:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKUuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 16:50:51 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F71C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 13:48:04 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g24so8866589pji.4
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 13:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KKzIqvRlw33rKc4HBjJ29H/v3XBJAw0vy9tsuDSJ/Lc=;
        b=jynJMqa5V1NiL/PR4hSDZThhKrKDa9nyALwBySDLTdKw23BQQQg+FAK0AgEh/FRoeP
         SFxIivxJvn5ZcFB3TnXwAXbcUs3frlFixxDPLmQUdBdTHZcv0q4gFrD3Ty/NhzC+t4uO
         KMwaLvh4pgTJUQxDCUUd+yhYhl4Yuln99qQowLt13484GAsXNjkp8XdC17E+zWqW6pqu
         A6I1S7GRxVTSCCtFMk7muECXr4CdhuYY/oNcQ4JSWgyoeT6f+ojDc/w/OI2ByypCPFgs
         5BBnGtFMg7UcEP19dmK7dLJZcqE9zQKEr4ogNbr9f6LGzoa2QXLIATqQmH3QdBB4FttB
         Vz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KKzIqvRlw33rKc4HBjJ29H/v3XBJAw0vy9tsuDSJ/Lc=;
        b=dhXYIOIUM+gmJp64ewwLnKNyPc2buhz6s/qGuGQfVbW+jWuWU3cb/VaVJJDsjygckm
         ZythxzkenXJV3oAXCFZMvpEA7Y2mfoVI5wzgQFJ85MI9M8up1yYfRrcKduPCEh1yDtuJ
         xVGVT1O3qA45FadANVm9yeYbXq9ip8H166h05bYNMpaIZvfnmaOpFTwbp1mRvj3hgsYg
         St4RZPtB0oUKyYDLxR2vgmmJYKX+sERGWKnCM4qbKXu6ac+krXtDM06SVGbDNtdm5jBQ
         v66NKCleaopbhzPfhyjpjPsuFJZWLc0vWDOfGiTa80qT5fOeufDBQj0lnReep9PnTUX6
         Ihrw==
X-Gm-Message-State: AOAM530Ch+EN8yprBHKc4f5SKsL/62HUmiRfQHttMz6y/ebzkkPf/qWV
        UkePzQ+mj88ZAljjl6hvrgW9voTGYD6t70OT
X-Google-Smtp-Source: ABdhPJzpmtqHYRoQAaEQvsgvjmy9WqNKWedzHqdv7dVG+0AvvDckX2XOg61sglPjy0IX8nn5tPY+MA==
X-Received: by 2002:a17:902:f2c1:b029:12a:e27f:7366 with SMTP id h1-20020a170902f2c1b029012ae27f7366mr11398806plc.22.1626036484088;
        Sun, 11 Jul 2021 13:48:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm12942156pff.128.2021.07.11.13.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 13:48:03 -0700 (PDT)
Message-ID: <60eb5903.1c69fb81.a3cc9.62b6@mx.google.com>
Date:   Sun, 11 Jul 2021 13:48:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.275-122-g38e709a8889be
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 128 runs,
 5 regressions (v4.9.275-122-g38e709a8889be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 128 runs, 5 regressions (v4.9.275-122-g38e7=
09a8889be)

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
el/v4.9.275-122-g38e709a8889be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.275-122-g38e709a8889be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38e709a8889be5c32bc3f96f54bcc06ddf471d87 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb26f3e47978b1f4117972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb26f3e47978b1f4117=
973
        failing since 239 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb2e853a95b235a41179b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb2e853a95b235a4117=
9b2
        failing since 239 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb27e1b0512790541179a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb27e1b051279054117=
9a7
        failing since 239 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb31cd3de531eec8117970

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb31cd3de531eec8117=
971
        failing since 239 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb27cc9ff67b91ed1179b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-122-g38e709a8889be/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb27cc9ff67b91ed117=
9b2
        failing since 235 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
