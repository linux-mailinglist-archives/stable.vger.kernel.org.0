Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FD933FAAB
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 22:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCQVwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 17:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhCQVwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 17:52:19 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D23C06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:52:18 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m7so94725pgj.8
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b4VUyFf9Tjt4XxIJrtjpWAhZgj99Q0r31r7z7OrZkqY=;
        b=ePkP8GAOzZ75Ciq0B2vJtRhE0Qapv+vUzTceoYt6q7mXCN74Yy5x0mFh5oReiwmSeu
         BIcwFz6TMn6VPLZknoFAiOY5CCSj/lLErSItPhsN3RNId/PLDE+O1ethYC4Csz3JbfW7
         KnjE6K0w3tbe7rL8XZ+UcLb68Q13SD+lZm7IoQsoTd66pGAIV7+R5kpZgaDjE8NbJIvl
         sDG2IxEZwhvTHDGQH73X6efWBtxl/C/ZTaTXK33s3ghQOFSDGc9aFhlBH7eEyOYB4Tm0
         foCj9I0eqbcqIA9x7uNG79K0J9f5ObyLX+H8szWWDPQfrb8QwFbXga8OTkSJPwE5mZVY
         OUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b4VUyFf9Tjt4XxIJrtjpWAhZgj99Q0r31r7z7OrZkqY=;
        b=Y6G+EY7UuKy34+gYjxzTuUmcVA6W4yes1IW4XrAsPW+z5nHM5su/GrU0GjJj/Iu2xP
         InwZ6waL7BtoikNRzNbDKuPDsR5KEFVH/Ynhx8g7li1nCDFEJPnTv7VJGuhU/0hJOTAe
         oSUaQIKc5/2BVvzfOL485gYCXw7QATvqOQ03glIElEbI7K23sRtSJgq04nItboBXmuEB
         ObXk4GlKCmtiQWTjixfys7efbZrSRiTazhZ5GvdZebIzwMNmd5jSbS/jIZtHdP/Nv7xI
         d2hw7dIC4lsEhLTxu75flhTj0AEWZfITeNAhkkushiYgpbtw7Jd5HDweUcycjG5AO1GU
         ML8Q==
X-Gm-Message-State: AOAM531QC2T9NA8DkatRZwbx51rI4tM2oxrUnAyEbF+pUlvwKiL2tK80
        DIliWbpo+GrcoVfqmibV7C+q6+dn0eeV0g==
X-Google-Smtp-Source: ABdhPJyCiXXY2zWe3r46wZ7b0gvv+vzoU8ONPc3bHJrIIpTZ/uJEOk5skdYSloa+YSX4MAfHMBkdrQ==
X-Received: by 2002:aa7:96cc:0:b029:202:6873:8ab4 with SMTP id h12-20020aa796cc0000b029020268738ab4mr986466pfq.42.1616017938094;
        Wed, 17 Mar 2021 14:52:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm80644pjv.49.2021.03.17.14.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 14:52:17 -0700 (PDT)
Message-ID: <60527a11.1c69fb81.a27d2.0617@mx.google.com>
Date:   Wed, 17 Mar 2021 14:52:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.226
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 101 runs, 6 regressions (v4.14.226)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 101 runs, 6 regressions (v4.14.226)

Regressions Summary
-------------------

platform              | arch | lab             | compiler | defconfig      =
     | regressions
----------------------+------+-----------------+----------+----------------=
-----+------------
panda                 | arm  | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm  | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm  | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm  | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm  | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

sun7i-a20-cubieboard2 | arm  | lab-clabbe      | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.226/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.226
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      cb83ddcd5332fcc3efd52ba994976efc4dd6061e =



Test Regressions
---------------- =



platform              | arch | lab             | compiler | defconfig      =
     | regressions
----------------------+------+-----------------+----------+----------------=
-----+------------
panda                 | arm  | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605246cd737e25d9acaddcef

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605246cd737e25d=
9acaddcf4
        new failure (last pass: v4.14.225)
        2 lines

    2021-03-17 18:13:30.382000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/100
    2021-03-17 18:13:30.391000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform              | arch | lab             | compiler | defconfig      =
     | regressions
----------------------+------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm  | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605245d56dd4679749addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605245d56dd4679749add=
cb9
        failing since 118 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform              | arch | lab             | compiler | defconfig      =
     | regressions
----------------------+------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm  | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605255fd271a805399addcdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605255fd271a805399add=
cdd
        failing since 118 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform              | arch | lab             | compiler | defconfig      =
     | regressions
----------------------+------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm  | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60524582b9a51458bcaddcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60524582b9a51458bcadd=
cb3
        failing since 118 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform              | arch | lab             | compiler | defconfig      =
     | regressions
----------------------+------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm  | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6052455cdd727209b1addcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052455cdd727209b1add=
cca
        failing since 118 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform              | arch | lab             | compiler | defconfig      =
     | regressions
----------------------+------+-----------------+----------+----------------=
-----+------------
sun7i-a20-cubieboard2 | arm  | lab-clabbe      | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60524678feda887b34addd38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.226/=
arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60524678feda887b34add=
d39
        new failure (last pass: v4.14.223) =

 =20
