Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444503DB8DE
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 14:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhG3MtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 08:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238847AbhG3Ms6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 08:48:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13F7C061765
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 05:48:53 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so8657952pjz.0
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 05:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R8uKwFdzxmXqqqo5KDl+ZZIOhrmRtZf7yqLIr+lGuE0=;
        b=aXYm5OXkGCA9lQGKSY7ipXNK3GtwFIZJU62SK5p1O9hqNabk6VNdR8lF569zo9TJsC
         hKhwIMRLSa6XTUIBVtND+DUp5heLDQA5LcgfxUOeL5ouBG9zGNOv1G5RRfB8k/G6k3Wj
         2zwUPJ9bdtJsZORVbykuNoOGOOYalE9hjmtBwDCInisQYUP8TvayAQ+mdiiqK0kfLqvg
         fkI0clmFX03E4oagpRDXKeFm6Pm0zz98mnkpEMTckSNmceC/0qaF+jgZsc3cIQy/e9Dp
         1U1NiOwevrEUZuacVObCVAVG06myrPdQ6qJmhyTwJitsQrTQ7BnuWC4wB230YUP9in/k
         NiHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R8uKwFdzxmXqqqo5KDl+ZZIOhrmRtZf7yqLIr+lGuE0=;
        b=OQAU2UUqzfGgHHpWO1eUrPy+n/jnWiEsY03Huy0LD/bw0/5OwnBWqjfQ0pUUlBez1v
         b/OFUqozJfOSaDrDIAo2zvRm22b7jGGlzbjiz3UeAnqAc0+W6/SRxyt+oOYl1pBh4zAL
         L/7LYkBusKeVEICfBRYVUWJgD3m5NPfj/RCmA2xgFBgg4lTfiLWYg8KwH9b0zCouh4Fr
         TSI0IbUQzpskt6oHri6Hgr0D0Sp2kNCcRhyOalDWWWvRs6RYMYYsVjWGtLUVDqEl38qu
         uvlqWXyDj0Rwi9kZ7yhhMsGUOzBuVEID+GOYt8x6I/JkJxfgTyS0MbIBXIyxcDwikGet
         LIcw==
X-Gm-Message-State: AOAM532KExSQo6JQw47wH42QM57VKt2EKJXCAlJAEfVC2OHtTZSQvi/Y
        RyUNh7sMrP5IQRK6dZUl6PK0jHzdYMfTX8hf
X-Google-Smtp-Source: ABdhPJxhhxWDYEOeI2COO0Oy/C1tuYMBiAXaWrqTAepCAPiqMKwIi0E0Le95Fx++NuNzdjgt2JOAmg==
X-Received: by 2002:a17:902:ec85:b029:12c:6896:dd62 with SMTP id x5-20020a170902ec85b029012c6896dd62mr1710013plg.44.1627649333307;
        Fri, 30 Jul 2021 05:48:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w134sm2320042pfd.124.2021.07.30.05.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 05:48:53 -0700 (PDT)
Message-ID: <6103f535.1c69fb81.78eb0.526a@mx.google.com>
Date:   Fri, 30 Jul 2021 05:48:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.277-14-g60c4faa62630
Subject: stable-rc/queue/4.9 baseline: 119 runs,
 4 regressions (v4.9.277-14-g60c4faa62630)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 119 runs, 4 regressions (v4.9.277-14-g60c4faa=
62630)

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
el/v4.9.277-14-g60c4faa62630/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.277-14-g60c4faa62630
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      60c4faa626302c207b5dc402d3b0cdd9cca00475 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6103ba266a258460765018d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
4-g60c4faa62630/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
4-g60c4faa62630/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6103ba266a25846076501=
8da
        failing since 258 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6103bb0974f2d23f2a501910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
4-g60c4faa62630/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
4-g60c4faa62630/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6103bb0974f2d23f2a501=
911
        failing since 258 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6103bcd060b6e851e85018ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
4-g60c4faa62630/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
4-g60c4faa62630/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6103bcd060b6e851e8501=
8cf
        failing since 258 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6103bb2723bb5c4e045018c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
4-g60c4faa62630/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
4-g60c4faa62630/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6103bb2723bb5c4e04501=
8c2
        failing since 258 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
