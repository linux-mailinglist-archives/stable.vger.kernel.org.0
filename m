Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C873308CB8
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhA2SrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhA2SrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:47:04 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35736C061573
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 10:46:24 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id o7so7298487pgl.1
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 10:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E2wU7pNSgIBuofbb7URzgIeK17+rkp7Cg/xQTK15as8=;
        b=SDURjFbOuQKkfskF6sG8TGH7x7QvP1PO2bwQ3rFuIstM4JwURj8kLtwbqmpE9KLT86
         VIWUpcpIlkiQkXUkO4Esp0toROWzDcjy3MFdUBaHcFOMdL5PZfhTRwJrYM8u1fyFHCcA
         ZRmRIT5NqkA0Wg0MaThBwfsy0aBBfO1yn0vFENZOwYcAeEaOgaXd7Z1IOBcRn57UQxLW
         7nath7MheVc9gsgrqEk7P9818jWgGkoxf29W6dvWWQPtM7PG2n8tx571Dl794mb/8/47
         ahhMxClY7hIqgWEdt2/vhjSP1cXlNQigMcogVrfX3KIjYrXEADK2NS7Z5XhHha7dT4qr
         kLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E2wU7pNSgIBuofbb7URzgIeK17+rkp7Cg/xQTK15as8=;
        b=LTlVbvWpp+NKmrk+3BlGHv6LbWmS2ttHSZgWIDUXNV4s2Zy886ooM0DUyiQgkRlFEU
         dW6mE5uy6ZyofLmgKHvJxMT6d1NVse6BFCrMbQ62ikhlvKwm91ymhyx2/FrROKvhSCXr
         mDzkwUR5lGT2KernVwU85iWKUhwxhBjZxEQEi/8jc+i4QPoQYFbQvoUpygtUYK9usmM6
         WZcaR71xFUfg0MyOroPJYk7qnmfuLWTnMKI1AoXv40UBNWRhTDzfa9xPh1MFtPw/8rPY
         jhkrWa0dtB/6SqbVtmDx1ZqEEFdDOgQrXrJLhnSVpeLPFCWZK7j5RKYIQWwBONDiHyNY
         C/iQ==
X-Gm-Message-State: AOAM531hnGpyJ7kVD9eLyq0OTHKbcXMDPO8J8uoUEcX1o3oZ5Jp94bEg
        jaBqPsfzvGlu0KdbcdvQG0S7kl/+93U5Fg==
X-Google-Smtp-Source: ABdhPJzIXOMYIZy6vnY2b3cEPh1i83JcN2DX5PQKb9bW3vLKR26HGh9VWw7UxoP4Wcf9/+7iR+9/4g==
X-Received: by 2002:a62:a108:0:b029:1c1:119b:8713 with SMTP id b8-20020a62a1080000b02901c1119b8713mr5537355pff.74.1611945983461;
        Fri, 29 Jan 2021 10:46:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k1sm3087297pgq.87.2021.01.29.10.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 10:46:22 -0800 (PST)
Message-ID: <601457fe.1c69fb81.597b8.75ab@mx.google.com>
Date:   Fri, 29 Jan 2021 10:46:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.253-30-g6cb2db3a6d706
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 115 runs,
 4 regressions (v4.9.253-30-g6cb2db3a6d706)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 115 runs, 4 regressions (v4.9.253-30-g6cb2db3=
a6d706)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.253-30-g6cb2db3a6d706/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.253-30-g6cb2db3a6d706
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cb2db3a6d706b5354134009232858ab0c3380f9 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6014222397373ac576d3e010

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-3=
0-g6cb2db3a6d706/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-3=
0-g6cb2db3a6d706/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6014222397373ac576d3e=
011
        failing since 76 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6014222e2aa7d5ce57d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-3=
0-g6cb2db3a6d706/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-3=
0-g6cb2db3a6d706/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6014222e2aa7d5ce57d3d=
fca
        failing since 76 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6014221697373ac576d3dfe6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-3=
0-g6cb2db3a6d706/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-3=
0-g6cb2db3a6d706/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6014221697373ac576d3d=
fe7
        failing since 76 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601421c627b5c620f5d3dff2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-3=
0-g6cb2db3a6d706/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-3=
0-g6cb2db3a6d706/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601421c627b5c620f5d3d=
ff3
        failing since 76 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
