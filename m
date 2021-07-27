Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6E33D7E80
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 21:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhG0T3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 15:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhG0T3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 15:29:40 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCF0C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 12:29:39 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c16so11580158plh.7
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 12:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nXg0Ed/cKARob62YLQQpuEUFI1DgahhjC7HJvW8Qgxg=;
        b=osD+m8AAcNrXdhxxVLFkSTuyg4jBIyWpqYm8WomY/3pr2sv8l/LYOOnJO4xR0dmxPc
         U3+w4v2A0BMWo/4wNFBNBf6Q6L717XGm3SUFwUsVrK8cgNi7ZjDy28Vo9HyFrb9ElNeP
         vBlQ3JamXBwNHM0ZSr8P+3ziXuHyymGCejgE1v+OprcwpW3+YmZXOYOCwY/4qgQJOqCq
         DnV6+be3KJur9gwE9wloyfI0fHynA6gqu/UKUEZRYZ7XN9fIoDxtnJbFVPsgy5eixW3D
         nGsT3vHAdE9FeFx/1gUDhRoBh9McvrNKnQGYpJiWaXIOtCmFuy+FMvS3x56un4lLeDXz
         HB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nXg0Ed/cKARob62YLQQpuEUFI1DgahhjC7HJvW8Qgxg=;
        b=MpFEVYMa38Njn6l+UUYwaK4OIGi21xD8l+Kt3wN02Wc3hPAfs2/h5iAqiPsNevnlkL
         sLz3q1PQJBCBB1A3TNOtwXuJGbFTRjUd4LBuuNNmKCNOY4dODbwABboHsKwoH6oMPKPu
         TixqHAYoxvHXQeMpRa1vDshzK7Ao3QuGt228d/vi+tEttYQ9bZq1+m8FLFFKcNeGYEWo
         GlRrtYK3GCEuYgU+DRRovLx60TtIruyCkxIYHBQlxv9M9p28m6DdzxyB/UKLR2QQbXg5
         etYumD4Scd5vFWeF2AzdODkruYTa2SW9Ub96TMuCjww0skxeZG3hizpXKw+dnwcW4qDb
         T2Hw==
X-Gm-Message-State: AOAM531aRX9TkcxNVqcAFzdE5OQLZcZ3v3ehZpeyWSDqA6ecJDnrS9Pi
        s97T/TXDClZzl8jois74qH33dgQ6dweCTw4P
X-Google-Smtp-Source: ABdhPJwCdwPB/ND9qPNXOfNWNKF/U+CBW7RA9xn1YOlTU+RuKVTZN27aKpn6GVevPmi5ghHW2eVgew==
X-Received: by 2002:a63:de45:: with SMTP id y5mr24995214pgi.261.1627414177098;
        Tue, 27 Jul 2021 12:29:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm3692194pjq.32.2021.07.27.12.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 12:29:36 -0700 (PDT)
Message-ID: <61005ea0.1c69fb81.be75c.bc73@mx.google.com>
Date:   Tue, 27 Jul 2021 12:29:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.276-59-gba35ef58c4fc
Subject: stable-rc/queue/4.9 baseline: 128 runs,
 4 regressions (v4.9.276-59-gba35ef58c4fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 128 runs, 4 regressions (v4.9.276-59-gba35ef5=
8c4fc)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.276-59-gba35ef58c4fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.276-59-gba35ef58c4fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba35ef58c4fcb61789b4e9b17a6cfabb1dd7c732 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610026305ed0f7eb1e5018fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-gba35ef58c4fc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-gba35ef58c4fc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610026305ed0f7eb1e501=
8fe
        failing since 255 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610025bfee4d55f88f5018ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-gba35ef58c4fc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-gba35ef58c4fc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610025bfee4d55f88f501=
8cb
        failing since 255 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610025bb0fb28a4ff05018e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-gba35ef58c4fc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-gba35ef58c4fc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610025bb0fb28a4ff0501=
8e7
        failing since 255 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6100258caa9c708c5e5018dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-gba35ef58c4fc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.276-5=
9-gba35ef58c4fc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6100258caa9c708c5e501=
8dd
        failing since 255 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
