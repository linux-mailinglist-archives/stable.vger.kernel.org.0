Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279833B8972
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 22:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhF3UFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 16:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhF3UFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 16:05:19 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E13C061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 13:02:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so2164404pjo.3
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 13:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m+BvWoRVt+RQskRPyqqCXHWlooamIXYK2jX9Tdk86Hs=;
        b=vr/COdXDaX0vaUtuEagBVYDVWjWcY9H4IjgycDiK8IgtnnrdYtpQ2Wdz97tpgRQaPC
         RxK1SmcX3qQ2C9cGQgnh0D5tqJEg74qlNgmCf8XMqKebgTxHVVocW4/yjAcn8q4BoCn+
         f1eh06dzXj/WLTGIJJJulvY2Hd7n6U8ho2Hm6YT+QAyashXXVOW8z/LO2hcRiMx6hgzT
         nDUrQ2r3ralLRGniVLLXYJ18f58+tzSyqm0d8WItVBWbGe/GbnaZ9pm5QGlmBF3e1q/K
         a8bJPN1h+bHeywwCxhttZmh1TtsY7Caa92ypJJLCV3d7Pnb0Ibv7oSrALKUXEhVdXnR+
         svIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m+BvWoRVt+RQskRPyqqCXHWlooamIXYK2jX9Tdk86Hs=;
        b=mi9ZG3sC+XGmmTgiVPTbHsT81ZXDFVKLWJZ0159DuFYuWGLf0+gAZ++2WONQHIhpaY
         l8PVKzzAIXK2+UHRsGQPspuiGfjNnU0YIPCAD6GG4cDAMr5p4jbR12L1NovFm0QPzxTB
         BPWf5h8oZDCArXqbuilnkSDSxGS0XRPZq0zHPSATmc5R6FOEPKQeGgRFy3Z+aOm+bvG6
         8JvemIjUFgMO1syd/K31a1OEy/JWGJ1yGv4DKO6MJLW+sTPo3a3X8ZXrRj7burcHjVQO
         QABWGBeKU1qdpoyds367jTX4im2EAFG948trXGkojLVqAyYfyd8F7y8+ngORkmHTGSUh
         u3mQ==
X-Gm-Message-State: AOAM531UFbFyTkDsHrTVVhGvBF7JHqATP0qqpM/LQNF6+MmvN7b/MMF5
        qi1aLlhd9oq+DftJUXX+L8iSN6VFaqekCI5m
X-Google-Smtp-Source: ABdhPJxKQ54LYTG3qXu9UL2TAnNrTU5rIjrMxTYOBtGY9Y+tMJyyvsvbZf2pM/LAkK67ScokePrW8A==
X-Received: by 2002:a17:902:f704:b029:11a:cdee:490 with SMTP id h4-20020a170902f704b029011acdee0490mr33617500plo.37.1625083369099;
        Wed, 30 Jun 2021 13:02:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q29sm19641402pfl.209.2021.06.30.13.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 13:02:48 -0700 (PDT)
Message-ID: <60dccde8.1c69fb81.8af1e.a5d3@mx.google.com>
Date:   Wed, 30 Jun 2021 13:02:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.274
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 89 runs, 3 regressions (v4.9.274)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 89 runs, 3 regressions (v4.9.274)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.274/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.274
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ebeed1e38d45d31da241fd1e4a93c0517a6cb6cf =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dc9706117c4afa9923bbc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.274/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.274/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc9706117c4afa9923b=
bc1
        failing since 223 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dc9b90d573e19f1b23bbe0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.274/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.274/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc9b90d573e19f1b23b=
be1
        failing since 223 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60dc9641534c47dbe823bbbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.274/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.274/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc9641534c47dbe823b=
bbe
        failing since 223 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
