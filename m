Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465BA2BC88D
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 20:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgKVTTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 14:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbgKVTTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 14:19:32 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E18C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 11:19:30 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 18so7722021pli.13
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 11:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yr9rOLc5dAFDRLHe6n759Inz8PYvZUtBB4e8bjOhjBM=;
        b=isE3Jy3qFKw26RK2yXJY5EWYLCZx50umsFDp0qiVCR4ySl8HUvSOlGlicJCIWAyFiZ
         HSOxEZXemiVPbQpyUfwvVRIXPCwIZbV6LHeqF01pFvGQUjgnfPRvcTsPVd+ydHrfD8d7
         YLAkXh86UkesWIDSZkPDvltD94Vy3kIY5PSkaIDZozAqrPw7E4oqTRvM7+fMg0F2X87h
         ChlfauQb9Gv6UZzngaHdlgBw6TEcILN98T9fU6kbjFLiQPrBGHtjELQduLNSQ725hpCQ
         j7hL3o7y6SaTT+Z7XaZhTSYBKWj/J9tpl9Qvg6YIX0/Jn7q1lU3xPgIVbWDYpuqz/5jr
         tNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yr9rOLc5dAFDRLHe6n759Inz8PYvZUtBB4e8bjOhjBM=;
        b=P84RNlsMIdtLvVtwXFe6JBVamXmn66qwp2+1Y9PhlEX1+FM5bcHI+hv/jYlQwA1pnR
         mG8DlKLUlflJcjlDEK9dMEAOQPs1Z3lnZCk17rODU2UlBhElhUucup0q26ZM1fzgLwam
         2+znPSVk3eftWfcW/sSeEkeC2BlZnh9ZZZIterXvwKRTIZ7Mz6GnytpmYoh5fWEEc9u0
         DT31HVdvQI5MKeYaApkWwq2IH7IqJDDwZUFDd0/2NCmsvjLuchXlIZChNbbfRolSBCY/
         Y2mIGVwNqhTVZ8VmNXPk7fS51GsYp8GuTW54/riCpvYCzWx7EUO7U/zZ1J6wqH1/vU2j
         y+dg==
X-Gm-Message-State: AOAM532SIaiT3WIxlsmb7OAHgTKqv2SKvA1YuQWLbuVtWZwxcaqbSH2N
        8/rLRRcWLFPTn30EPrtKYodYLVav5OP7+Q==
X-Google-Smtp-Source: ABdhPJxrJcezwi1IGLYJRw3wgfm1oZGH4mZRUW5/EiV2F8sOhBN0CYsBRji9lBaM8KUgY4/AQpuvkg==
X-Received: by 2002:a17:902:9f90:b029:d9:da48:6021 with SMTP id g16-20020a1709029f90b02900d9da486021mr14729117plq.81.1606072769774;
        Sun, 22 Nov 2020 11:19:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l1sm8630953pgg.4.2020.11.22.11.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 11:19:28 -0800 (PST)
Message-ID: <5fbab9c0.1c69fb81.d25c6.2bed@mx.google.com>
Date:   Sun, 22 Nov 2020 11:19:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.159
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 112 runs, 6 regressions (v4.19.159)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 112 runs, 6 regressions (v4.19.159)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.159/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.159
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76bda503e6406539b1ad5adefe69d3df439ee97f =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba872486a2d85c0fd8d909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba872486a2d85c0fd8d=
90a
        failing since 159 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba87b152874eb34bd8d91c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fba87b152874eb=
34bd8d921
        failing since 11 days (last pass: v4.19.155-42-g97cf958a4cd1, first=
 fail: v4.19.157)
        2 lines

    2020-11-22 15:45:48.708000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba85e98cf2b1c729d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba85e98cf2b1c729d8d=
905
        failing since 4 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba85e9af27796f18d8d949

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba85e9af27796f18d8d=
94a
        failing since 4 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba85e22f9f782988d8d909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba85e22f9f782988d8d=
90a
        failing since 4 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8591d7af0c4cacd8d906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
59/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8591d7af0c4cacd8d=
907
        failing since 4 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =20
