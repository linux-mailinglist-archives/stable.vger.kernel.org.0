Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4F4431123
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 09:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhJRHLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 03:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhJRHLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 03:11:07 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67ABC06176A
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 00:08:46 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so11826283pjb.5
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 00:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q/2Fso9xmVuXfPR4QLbsMg06D4jK/lYrOSOfwZIbXzk=;
        b=xYqUAZD7Xh9RtBumddIQdRlN5C2ikLDypDkQDwvleBcqF7WLEJKnnLOeIgfkrvHABQ
         2m67VuC3WP831OKmcxlYqJcFYWP4Rs1Uox/8CFXoxP6xt3AUDvZEIXMxrijjnAp8gG+H
         YOCkxcFxZDn7TVK0Txqa7gEbqgbJhHDuoett4ojrLTe7DzsTh8G8c/3wgp7pd23zqB2m
         K9svWnEaB0mnW/9StHOOI1S8F/Tc1Ikpe8tyjdOMkSFiQCH1sJLksPc9r8TQti/VQG05
         KucVYcaFfACngFe3TDolmM451N8VDEVyf6FD/3RXJ/3wzbRTiIcuFJP2i6SZvvHLMJwB
         2AVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q/2Fso9xmVuXfPR4QLbsMg06D4jK/lYrOSOfwZIbXzk=;
        b=SHCPxSy5oH4IqXAj1FPG6baDT+Qhxqb7syXz7BAlYFeTrlXZ8W/y79E/5jSrcJ2jXk
         RlfF7nLaeYeMAsp7iV9ZEHAVtT1G7jKSQj76BBq20QPS39PT7Jv3r9vAwY/QigYzAQIT
         MWBccNQeqfSy8z+J+ruq6msssOndQaLWRxb8Qt+43Vef8daMOLYL5TtfFdC7OEDsNQLs
         L2Nglu9CqIOFbcGx1H7HvMmM8YU4jYtyV684vkLKY1l9n0oo3DLfWzWH0dPiDo45X7s4
         0ATjLKD+l+jUCki6uCYgRRyG1Eb+pZmKCEgwOxKCj4MrwPtu1sZeGQjKQlLRirek5LQt
         U6rw==
X-Gm-Message-State: AOAM531spdZ2MtFKvlZoDPiNLKCzv0Arl7DOT5rl9OGKIT+nGvZJ741c
        QhOz4LmNja4fAYK+oBY4FprZ4rg1Lhf+GEEe
X-Google-Smtp-Source: ABdhPJxUM+kYqMEEDKrf2Rpv55bySKy5QlaGytk4hhCb6T6iXl4XHdsct2A2JfJwm6Qh43n+vQXs+g==
X-Received: by 2002:a17:90b:1bc6:: with SMTP id oa6mr7885578pjb.206.1634540926042;
        Mon, 18 Oct 2021 00:08:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13sm4161430pfu.196.2021.10.18.00.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 00:08:45 -0700 (PDT)
Message-ID: <616d1d7d.1c69fb81.926a6.ac42@mx.google.com>
Date:   Mon, 18 Oct 2021 00:08:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.250-41-g23de85e22f4d
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 112 runs,
 4 regressions (v4.14.250-41-g23de85e22f4d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 112 runs, 4 regressions (v4.14.250-41-g23d=
e85e22f4d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.250-41-g23de85e22f4d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.250-41-g23de85e22f4d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      23de85e22f4def6f205365fc1a7d3c611eef56aa =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616cdd94197c36aa123358ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-41-g23de85e22f4d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-41-g23de85e22f4d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616cdd94197c36aa12335=
8eb
        failing since 337 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616cf6b6fbe6e423ae3358f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-41-g23de85e22f4d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-41-g23de85e22f4d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616cf6b6fbe6e423ae335=
8fa
        failing since 337 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616cdd8d600fcffad53358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-41-g23de85e22f4d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-41-g23de85e22f4d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616cdd8d600fcffad5335=
8f4
        failing since 337 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616cdd3ede6f3d043d3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-41-g23de85e22f4d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-41-g23de85e22f4d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616cdd3ede6f3d043d335=
8dd
        failing since 337 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
