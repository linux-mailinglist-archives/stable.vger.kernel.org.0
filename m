Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90D43D0DDD
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbhGUKx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 06:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbhGUKdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 06:33:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F908C0611A3
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 04:13:33 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id jx7-20020a17090b46c7b02901757deaf2c8so832568pjb.0
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 04:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x/2uPcjcFoMpdWNsSwBdCw7bffJGA12aW+as13nauWg=;
        b=sk8PsiJzJFwGDlAbB0G9o1d6MHCtxIEr4Bn7B6We24qqoBr9fhzP/cuwtKicesFAyx
         YriD4QqHP7eQ/SiNHivQvTujjwLuKputzTOq6VndJMCpsAS2GXKpnmBo73o6UyqZkFi7
         aw/ObzBh2Dw8yhmKrLeJry8tJf5sakhO5iqdm1KJ6NxJdbUn6aQxgVzgXnifQA0mp10D
         VaewNTDVgygls/up+RZQpKF4QwLJQXeWlB+TfAts/trsb4KP32LzpSyJrH+7lQDJKgmE
         1DwkSdZb/7wr7j/BWT0Fwrv/LgdFyEHf8d+wAj6KR2xWjNGxBy3HHcc0Rs70Ri9oAxVG
         gAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x/2uPcjcFoMpdWNsSwBdCw7bffJGA12aW+as13nauWg=;
        b=OE0BlmluhmT8uwoPtpz08QO1hpIA1m9UcMjLvsNiOxOW7xhmVlpV1NWtU6ApXp0jnJ
         Dza07SdEKF05mnKcS2lbODfW5Ky/3ofD5yZprZ2o32oD5RMjU8vvq9wsSTGtrRzdf7ol
         A5sp0iJfMwMu/ibueJM7GgmFNSGYiWSsXgux1cK8LusgCLAKFaCpbBhyR1JR8g2dj3vL
         YJUzfnuX3477awqKae+XDb3Cd02i1ar2MKb2LVx4ZIoZw8XYRhCopJ1z54xDZbvCvDYo
         /2w2pa5kUgsfJ6ecYq+7mdgfT89usbSNuRFTnJ71CIC/q89K6U2Y7PI/NSU/5tBOkxiO
         mnqg==
X-Gm-Message-State: AOAM53178s03VQdrq/gIvn7CSLZlr1Yftdo7+13q+qwfW0OApmV1SdjX
        P3W+heHtpBStFhR1VRsoAG0d+H8yNogh+LMm
X-Google-Smtp-Source: ABdhPJwWv89MVEhkEtSL7w8Kn0QTRyWcI0OolgrFVez+owAJ7B7YeVoLV6YdoK7R1VUxExVR+jgJqA==
X-Received: by 2002:a17:902:fe0a:b029:11d:81c9:3adf with SMTP id g10-20020a170902fe0ab029011d81c93adfmr27424131plj.0.1626866012808;
        Wed, 21 Jul 2021 04:13:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23sm21941855pjq.2.2021.07.21.04.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 04:13:32 -0700 (PDT)
Message-ID: <60f8015c.1c69fb81.8d941.2b9a@mx.google.com>
Date:   Wed, 21 Jul 2021 04:13:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.275-246-g04afcb7e33f59
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 123 runs,
 4 regressions (v4.9.275-246-g04afcb7e33f59)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 123 runs, 4 regressions (v4.9.275-246-g04af=
cb7e33f59)

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
el/v4.9.275-246-g04afcb7e33f59/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.275-246-g04afcb7e33f59
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04afcb7e33f59d83d1e1bf39a8c0d9bbe6df454c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7c9d305b6e5c8a785c256

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-g04afcb7e33f59/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-g04afcb7e33f59/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7c9d305b6e5c8a785c=
257
        failing since 248 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7c78828fb90bf8f85c2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-g04afcb7e33f59/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-g04afcb7e33f59/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7c78828fb90bf8f85c=
2e0
        failing since 248 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7c729a66df8e2f785c259

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-g04afcb7e33f59/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-g04afcb7e33f59/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7c729a66df8e2f785c=
25a
        failing since 248 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7ca86712b0376a485c26e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-g04afcb7e33f59/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-g04afcb7e33f59/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7ca86712b0376a485c=
26f
        failing since 245 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
