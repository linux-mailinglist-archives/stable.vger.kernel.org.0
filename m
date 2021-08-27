Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BF93F947B
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 08:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhH0Goe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 02:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhH0Goe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 02:44:34 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0306AC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 23:43:46 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id x4so5231799pgh.1
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 23:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I6vyJ48f3+nHzYbyH6Mop7WrUv8H1EuPxCur5p53oHs=;
        b=Xm2HNjjYzLz5OBzewAWHcrJzEtaFAYVe5QoCGIyJ01yGfpqihaLE5KNm5rZjewYrhm
         vRRTJjwzRF0O6OOCq/i6HDYNkBrCiBXqbyHkBhy4krkaj0o77Vq5HvQPRD5l3Fm7NMCG
         OISJ/4AQ7fbcM+If98E9agaFcG7hwH+qdxK/mvBc6DxvPYLtgjbM5TjAO752NeoooYPH
         uyZ98RbdL0CE11izlAgQNeDjnxCG0Cqt4KM6ZCPvosXq+yeLXrWclosMFkQimZ8J/Mmj
         QVJC9OICHgUmNnZL6wBhzTIQQgQcZAa0pp2YmIVxlkvow9TSRNNnmYMFz/F1cI8IWhZT
         8g+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I6vyJ48f3+nHzYbyH6Mop7WrUv8H1EuPxCur5p53oHs=;
        b=EZiesBSWTPbCARkm3VcpQyGief8l8VyvShFSfAnm0kdB41flgm5kF7sHpt/MQNn3Hr
         /i8zoj3jacJR7f3ngmUqGGw5kesJFRF5NlH6WJBrCv7305Dy9ZTmSPyEkH0wJvDBIns7
         yNHXPNIzJqjJt7WAhOro9s6V1O2mqfCOILclgTBVgMAi2ymvl+my2o6HzV3V3PKWT+Lz
         IFKpyCTlA1MzDHOWgIYJLWcful/TkyOKLAgzr8gXbsusQXvJP6e36TeWdLOqB85seX5Q
         f5eRvUEvYQmQk6DVnyRQeZUsaacGg7zGbs4SmNWNZIQ0hthji2UmSP6LCXLJGnrE05PB
         VEhg==
X-Gm-Message-State: AOAM532mfn4rn7ajvTWp+PkdeoYNpryBHBxN1xhMwg1RB8cJHkAYKpwM
        dDBl8rKneJZRs4ZX41aYQOfhQOlrAYlVgw9j
X-Google-Smtp-Source: ABdhPJyJgvTdkarNBpxsltDEWGOPo6TOHyI2FsAesNCQ1IV57gQCwLIW+4aB2lT3U+7uP366tG0tzw==
X-Received: by 2002:a62:e70b:0:b0:3ed:7c2d:8052 with SMTP id s11-20020a62e70b000000b003ed7c2d8052mr7588938pfh.51.1630046625358;
        Thu, 26 Aug 2021 23:43:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 9sm11212323pjs.53.2021.08.26.23.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 23:43:45 -0700 (PDT)
Message-ID: <612889a1.1c69fb81.60fe9.d0fe@mx.google.com>
Date:   Thu, 26 Aug 2021 23:43:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.143
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 90 runs, 3 regressions (v5.4.143)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 90 runs, 3 regressions (v5.4.143)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.143/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.143
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd80923202c6bfd723742fc32426a7aa3632abaa =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6128509464d8cb68648e2c8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128509464d8cb68648e2=
c8e
        failing since 279 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6128503ff5c0eb31558e2c7f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128503ff5c0eb31558e2=
c80
        failing since 285 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61284dfb9b985b24ec8e2c84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61284dfb9b985b24ec8e2=
c85
        failing since 285 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
