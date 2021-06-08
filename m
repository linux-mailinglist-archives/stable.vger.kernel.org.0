Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DDD3A0525
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 22:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhFHUbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 16:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbhFHUbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 16:31:38 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391A7C061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 13:29:45 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso51626pjb.5
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 13:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=30BKx8pZqIJRqMqLfhxRo9iuIQwyAt6bewLZ3dkCeHY=;
        b=oFkGOwDYF+SjqHcjG1JQ4JBvWdy8563c5Ms5/bMUxO4HlMtVnN6PNZS+HHA/gpaf76
         9oaWkqJWF/tJzUi4TkhsuQtr9DEtg7l8FA/qPXuZf3mRTccbBy348duc+64lK325eQvz
         JKUfhZSw/Mh8ZFDMJP4GfBD6AJLD6JwQA3lYNCWKFA7QcfCIorsBu1T0EiQBk9Rxmp8l
         yfsyiGkCjCBTJJMC7E9zFjqBQd1luDICKT0QyvgcCql1iERfo6fZjcuCkk8GZohfhdpa
         v4Yu7IHxzpk1aEHgEVHtatehijnj4lcwo7UdwG2r5+DO4FgO7DsokwApDtL3A16wfbEq
         a/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=30BKx8pZqIJRqMqLfhxRo9iuIQwyAt6bewLZ3dkCeHY=;
        b=IUtkvROKLry28jWADVLcSZCIpZXunKMrRuEhvkMK80eNJ9Wnbb/hicRAY/rR3RHfmh
         DxiWwas61cK2464OPWftPKcPrsZbcYAT7oHpyBZ1JYCQVY+SIlFo5SFJX/B9dij0ftil
         i5YjKf7zgo0cIi70S44tcVIu4bEyLhTRdRslbOvq23Pngzua76QhgsfwzihPiZgXYCCP
         ANtdQTeOGuKEaD+BmuA+M+YKOQOZ8eY9KZ2UrGIOS2oztKnvDkMkXLL+knJxNVZVkS9D
         kl8IWvAAwV7m8lncSYBWaGLlnHPE7ipx9l7N1GYbcBx1GRTvBASKKH5gkY0jrmKKB8iT
         LF8Q==
X-Gm-Message-State: AOAM53368Fku75No0unDI9KDoJBy39/okDIrZm5iRsxApuS71jWf0xJr
        u2Js7nbj858Rtr/rpU2T8l2bqFEru2fOuvQU
X-Google-Smtp-Source: ABdhPJz3o+Nqr7ICXqDOeh4GFWd1+nXV7E/REfNqQkIv8tUBoemqS1NXujA8myMJc5XCQwtVDN5PKg==
X-Received: by 2002:a17:90a:f995:: with SMTP id cq21mr28215732pjb.232.1623184184517;
        Tue, 08 Jun 2021 13:29:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v22sm11428534pff.105.2021.06.08.13.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 13:29:44 -0700 (PDT)
Message-ID: <60bfd338.1c69fb81.5abea.3121@mx.google.com>
Date:   Tue, 08 Jun 2021 13:29:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.271-26-g429e66fdae11
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 120 runs,
 4 regressions (v4.9.271-26-g429e66fdae11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 120 runs, 4 regressions (v4.9.271-26-g429e66f=
dae11)

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
el/v4.9.271-26-g429e66fdae11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.271-26-g429e66fdae11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      429e66fdae11b120707e54de1df04d164a6fbd68 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf9ddfffebe104ca0c0df7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
6-g429e66fdae11/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
6-g429e66fdae11/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf9ddfffebe104ca0c0=
df8
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf9e1b90f8d642950c0df5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
6-g429e66fdae11/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
6-g429e66fdae11/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf9e1b90f8d642950c0=
df6
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf9de12d29fa17ed0c0e37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
6-g429e66fdae11/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
6-g429e66fdae11/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf9de12d29fa17ed0c0=
e38
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf9e2edb82dc2c350c0e0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
6-g429e66fdae11/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
6-g429e66fdae11/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf9e2edb82dc2c350c0=
e0f
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
