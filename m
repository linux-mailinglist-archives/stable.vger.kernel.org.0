Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF762301DB
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 07:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgG1FhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 01:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgG1FhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 01:37:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF463C061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 22:37:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t1so142857plq.0
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 22:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SxfiOOXFnFav6PZ2D2P91EW2CK3MhGC5Og8y4ZUuKW8=;
        b=b3/CtCM6khkiYMPqRHJXP29xrJHi12KrU2tHXfZVbI3lO5Vescov5AQP+BZ9zYAU54
         q4G+qoR/Rv/90AaNwn1V/ofjFrclSp8EQcwvuDsO4wznLHwzSg9RByuTinWIVOLY8tdg
         b89sQ2UESJp2qqqLhuCvmxcLpFAQ4TmR2vKsl57NQWHgV6O4539Mqo1zqV8jfo/iuZ01
         ixc0YCeehVWYKE/33FwFwVO9o6fpGAKos9enPwlFM872TAyq8hTFsKLJViqxZnb04/SD
         3VamZu8s2n/V7ow99WpoY3FDEWVgy4qRvkZHpNvZc2a6GhtRahHgc9wzPND0W6VH73y8
         HuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SxfiOOXFnFav6PZ2D2P91EW2CK3MhGC5Og8y4ZUuKW8=;
        b=P4o39IfcsTZU3nnnrBh0N7X+lXdyKyewEXLfyWmloKfCrSvFiRPJwAhAr2vl0gkOl6
         u06r48smne/JUXD34nNJzOfS//BVVtkbxhBCX36cSBTJ0DiofMa/l7lhpJsb21NFtqJ0
         o9UYOUIpaG04bEd3pWTjvAwZrUVc6xAAFNaVBugTwhfLtfIHK+v2Y67+HVAwE1U9hjxq
         7Pc8VYEGKkCigj5PZ31yTUAv5xbmsHiptIBilJDV/f8ZbQGpEDnYkszFf21x4MaFu4zH
         rqnpxiUoLWfSFiz4/XqK90DEuAY/SirMW6ojdKwtWswcXqE/OM6mPX4H5weOnMRsUjpr
         YDoQ==
X-Gm-Message-State: AOAM530AB3PISytDTVYeRq08SSmCw3HW1TP+8mdfw57QwoSQB+ly2bmx
        VHc0FF5fzpTkcjuMdxBewsw4+OPFm6I=
X-Google-Smtp-Source: ABdhPJxbAtR+OyOTcxJZsYhcimwsD+5nGRaangcqvWE5E0pv5tCCrHVxpEnTowMarubE0juz+e/Ebg==
X-Received: by 2002:a17:90a:89:: with SMTP id a9mr2800589pja.171.1595914632844;
        Mon, 27 Jul 2020 22:37:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11sm16055958pfq.91.2020.07.27.22.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 22:37:12 -0700 (PDT)
Message-ID: <5f1fb988.1c69fb81.37039.a130@mx.google.com>
Date:   Mon, 27 Jul 2020 22:37:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.53-139-g7a4613493cc3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 184 runs,
 3 regressions (v5.4.53-139-g7a4613493cc3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 184 runs, 3 regressions (v5.4.53-139-g7a461=
3493cc3)

Regressions Summary
-------------------

platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 0/1    =

qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =

qemu_x86_64-uefi      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.53-139-g7a4613493cc3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.53-139-g7a4613493cc3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a4613493cc30754cf5159b126623d26314454bd =



Test Regressions
---------------- =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1f7e004842607ff685bb1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.53-=
139-g7a4613493cc3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.53-=
139-g7a4613493cc3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1f7e004842607ff685b=
b1c
      failing since 107 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1f874c36a7f7995785bb29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.53-=
139-g7a4613493cc3/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.53-=
139-g7a4613493cc3/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1f874c36a7f7995785b=
b2a
      new failure (last pass: v5.4.53) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
qemu_x86_64-uefi      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1f874db95742d74585bb22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.53-=
139-g7a4613493cc3/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.53-=
139-g7a4613493cc3/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1f874db95742d74585b=
b23
      new failure (last pass: v5.4.53) =20
