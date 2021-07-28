Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05E03D973B
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 23:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhG1VKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 17:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhG1VKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 17:10:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB408C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 14:10:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b1-20020a17090a8001b029017700de3903so7087330pjn.1
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 14:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Gz8DcR9gB1Xeyhg4uhRdpeqcGRDpn4HQliu7UWozLtw=;
        b=f5srzAQAloL51nnqiMcHLlj42Zsn23zNRU+GDKJwCoi3OlNPrSZjYh3kXacvfEA82Y
         G9qy3JiBvfwOPvil4TEw/kqM+D2CIJdYU6d368kGBESzTfsS1LbYxW+XDIjmAkL0dywu
         h24MzbWHTjU4YL5vAqaLiO0S4E8L9nIyGVW/tEJC0eZEkogm/j9oH3WJA/J4vqoNO2Iz
         Flnu2l0tKhXvHQydXgAx94QS3rE2Qxt4iyzcqf/ahKVYvq43iYnrxhsnw4pfs89CxZQ0
         fqqHKgNRrnHLfyA8UdFvcv8fhDF8EV89txJDZw+KRVn69qxo6nm5GDe54iSsZdPYV+Wo
         o0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Gz8DcR9gB1Xeyhg4uhRdpeqcGRDpn4HQliu7UWozLtw=;
        b=G4+oYhTjbrVf98pJ/J5Pw2jEnA9YjnonadBr6wmDHBkvZJ4+YnHDU7vvc3Pn+GPy2C
         Qay+aDbbTDs/D6GH/QwTZzRjQZdD0ULCyVOvvRqLfDQkCKtEx8aMpSxq4T0fZm97dFoJ
         sPIXAC1UPKWDiTuawGiUf/vFZn0f11FSxW2wYAbRUiEzArR2hwWEBQDZqgzuwxTx8R07
         +G7KNpEP/pggoqAXnm5cxVYZXngE2lOJ9JSQn4hNBfVUXpsfj67WdGr/nkwwMPDSmfSz
         gQ3IjO9Egii83GSFjhBYGOQ8g3Wq/55jS59bqeSDNdonvvK3uOr5EfI591rgviaV5S5n
         JheA==
X-Gm-Message-State: AOAM5308YeomKa1FQs/XzW4e1R0/slJSZ1nzvcLPieOAdD11K88bXVse
        B8m4fMbA8BAmdvi5ziOqQzt35KnRo0dKeY7J
X-Google-Smtp-Source: ABdhPJwFI4s3B37uLloL9iCqbkHuRG1cenPZ3XDVChDU2fetRHtvoXMGebNDDO4uYrHX11ll5ttbSg==
X-Received: by 2002:a63:fb16:: with SMTP id o22mr742654pgh.309.1627506651083;
        Wed, 28 Jul 2021 14:10:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6sm6896394pjr.5.2021.07.28.14.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 14:10:50 -0700 (PDT)
Message-ID: <6101c7da.1c69fb81.5aa06.6059@mx.google.com>
Date:   Wed, 28 Jul 2021 14:10:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.241
Subject: stable-rc/linux-4.14.y baseline: 93 runs, 4 regressions (v4.14.241)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 93 runs, 4 regressions (v4.14.241)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
beaglebone-black     | arm  | lab-cip       | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.241/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.241
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce4d1565392b2dc8ea33032615c934c3dc6a32bb =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
beaglebone-black     | arm  | lab-cip       | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61018ee041b6322c885018c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018ee041b6322c88501=
8c7
        new failure (last pass: v4.14.240-82-g44bb6f3b2f37) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610193dc44028f48885018dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610193dc44028f4888501=
8dd
        failing since 256 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61018de24a7168bd075018c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018de24a7168bd07501=
8ca
        failing since 256 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61018f9a85d5fab0085018d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018f9a85d5fab008501=
8d5
        failing since 256 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
