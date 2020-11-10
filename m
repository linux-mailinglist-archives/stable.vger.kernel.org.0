Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21052AE3C3
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 23:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbgKJWyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 17:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgKJWyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 17:54:44 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843ADC0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 14:54:44 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id f38so29612pgm.2
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 14:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BXpMRGOJHlfvlexYXvvKNmCsbhqpfo1GvYpBH0cdpP4=;
        b=iCG28qmoTOq+ETEo0v+jWQg4paLIvEXQi6xSrYhAAm0ALw8cyGNK2ao8udum7qqxNe
         rhfLbBcRaL2FYLi3hduw2tSX5Ly5gUTUVSTN0aCSehkvgs45zDYHKoa5PDVF6r4sbILy
         dObn+Oww7tjU84vtbR3y8EqLoCuhilJGCt5dH3pFiQSw2uhVfnM8MixOLx3Bx/59F5ye
         mZqtfF6ClEWUXRKYGDSCQBGnJZj5YtlkFuZZSol7910PT7ZoWcYW1pfdr9OA3QjBgS7N
         qKyxxBNxInolxZTe9Ncq9lFpLKtl25rmhmn3kxaAm7msb0f4NgKYbLNZdGwcSPvQCY6+
         CG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BXpMRGOJHlfvlexYXvvKNmCsbhqpfo1GvYpBH0cdpP4=;
        b=EwS2X5n84oA0me/mYAHvuoelMCrFXUoQgjOnzkxpS2GTmavp2CiPAXBtJoIIqxa/Nz
         b1FgFeOV1ykP3u7EVPZieLg65BRfj4C//Y0dU3jocHuYGs6GpPt0aZdDNJI8BQTsHJr3
         3TpsPkV/kKOugsAu6jA3ycA75ZWNhoBqGewYK6Ku/R2aBs7GUVYUiJvKwukM/jFIKu2F
         DWb6hzS7DKu5BuvsXhBGvH4t0bvv04PTXowhO95qAetZ9pdsz0Sadm36lABQptlv9hEX
         vcI0WG3Mnb2ORdIwIcIaStQdu7Qtu0Wplwrorx0OwpjCALjiy1ne8RsqBnXQwwDSwmim
         N7Hw==
X-Gm-Message-State: AOAM531E1ITUan3QWNHMWwfpdvSLn4WvYChL5uNmM8jg8sNL2rgZnQxG
        WOn/bn7Dlb8GSAtzCZ8Ej3k1wmTe0n1C7A==
X-Google-Smtp-Source: ABdhPJzUSrMKSFSKZZyzb9M2z3URjV/6An8gwVcUU97vrgfFVY2XTdK8HDSLZRB2Fdv0+rPCVjlS6A==
X-Received: by 2002:a62:38c1:0:b029:18a:d50f:255f with SMTP id f184-20020a6238c10000b029018ad50f255fmr20561935pfa.22.1605048883723;
        Tue, 10 Nov 2020 14:54:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q8sm51095pjy.3.2020.11.10.14.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:54:43 -0800 (PST)
Message-ID: <5fab1a33.1c69fb81.cb1c5.0357@mx.google.com>
Date:   Tue, 10 Nov 2020 14:54:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.205
Subject: stable-rc/linux-4.14.y baseline: 155 runs, 2 regressions (v4.14.205)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 155 runs, 2 regressions (v4.14.205)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
meson-gxbb-p200  | arm64  | lab-baylibre | gcc-8    | defconfig        | 1 =
         =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.205/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.205
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e98f3c4269fda898b913259a7d9b60fb38269869 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
meson-gxbb-p200  | arm64  | lab-baylibre | gcc-8    | defconfig        | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5faae6668507e0da5adb8877

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
05/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
05/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faae6668507e0da5adb8=
878
        failing since 224 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5faae6402eaef1e4dfdb8886

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
05/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
05/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faae6402eaef1e4dfdb8=
887
        new failure (last pass: v4.14.204-49-g0c03e845a8b9) =

 =20
