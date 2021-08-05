Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8D03E0DC4
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 07:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhHEFcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 01:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhHEFcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 01:32:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E29C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 22:32:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso6936427pjf.4
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 22:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/gTMhXN5unFewEh2LoP567szkRylKvAMebD98pvfM5s=;
        b=vCCXzomLgnnoBsv6Wv0kz/ASPIOtlyLLhjRwblHR4bJ5Itztn5DX+vZstmFcNO+iRU
         YJn3+dJ4t5FFvEjgPu2NKWEqmlFvrc32mMh5IjT4DYDRPo6nB3EhlQoxD02KpM0wL0zH
         C06q2KkLvsuLqpKx8LHseEUb3m+3B5LXsYOuVlEUqqDTsdW8o2jW1RKUs6vBgs9q5Awa
         SQirGLWIO41S7qqHSpG6Ai5eqSLk6Iaapi1k1VW2rTxCv9sMwspEhy0+0SAW9Rz0WMty
         H4UjHL2aWYfswhSyiySPqS3ktgdbajrUPxydvxg7ei46pdrZSGw0Jk1eH09CApTxKddM
         ih0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/gTMhXN5unFewEh2LoP567szkRylKvAMebD98pvfM5s=;
        b=MMjd0Gx35IWqHIqb3d3fuZerQMxcQrNvMvKYH+ByDe6SM6n5MRhqwISRgXjqzQWxN+
         BFKlu80oe+pmFMzxhveR9InnBYDv0xCI7gsJU/rBr1nlCUbRpBWueSyMo0h161xDvR2s
         S6e+IsZMziw6f3GnzYVXorBFX5f1sMPm3DGsHIBp6/eVib9F/K/ucQfaagMaIegKQQbl
         4m+GxXR8lH6eBsR2Q4VqrgWMWMO0dsELa5CaHpr6mT/L7kOz9ZYxkTeq/rE7+3B5qQwy
         3Xk/Ot9ETgF5pdj6Wnlx3osTB2AbzReber2bMJfFetLCGdH1h7E26udJk+0c7jIFS4EA
         HR/g==
X-Gm-Message-State: AOAM530+7qQ2DBai28gqYoqeBNkk37b2mS8+vjnw/6lIhI3EaNyoOsRb
        v5nz/QQE7m3yLbvZkGsZ0PuN02iirfQ+lzzdPME=
X-Google-Smtp-Source: ABdhPJzaPeSiQAwB8Cr8J1gF7J24eFpXt5JP5I/q4Ca4WKkv7eYxKRB/j5fSQO5rPp3f91RjRpohrg==
X-Received: by 2002:a05:6a00:181c:b029:3c6:2258:a844 with SMTP id y28-20020a056a00181cb02903c62258a844mr3436580pfa.6.1628141519315;
        Wed, 04 Aug 2021 22:31:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 135sm5101563pfv.20.2021.08.04.22.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 22:31:58 -0700 (PDT)
Message-ID: <610b77ce.1c69fb81.b4bb5.ff44@mx.google.com>
Date:   Wed, 04 Aug 2021 22:31:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.201
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 86 runs, 3 regressions (v4.19.201)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 86 runs, 3 regressions (v4.19.201)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.201/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.201
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6ca2f514c57864e3085a65c5e9d2adca4144bc4c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b3f3e16aeb5dce3b13671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.201/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.201/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b3f3e16aeb5dce3b13=
672
        failing since 259 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b3f3eb7f6fd13cfb13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.201/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.201/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b3f3eb7f6fd13cfb13=
66a
        failing since 259 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b5ed492db0f793db136ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.201/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.201/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b5ed492db0f793db13=
6af
        failing since 259 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
