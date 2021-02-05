Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7BE311125
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBERoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbhBERlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 12:41:52 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EBBC061786
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 11:23:36 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id g15so4381281pjd.2
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 11:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Th8AzSga+4716gB+0E0Rzk8DiPolYgv45HlRN8SM6xs=;
        b=u39zggXkoNVt0Ke5o+u22FVkAFwigRM+G5PDwzAjjzdpna+dR8UaunGtlRpk4r42Aj
         0KWCTazmerTQceUAM/opNl+8n118uLzcae4fuKCJa3eLTSN4fLV6Lmu1qebx1BIDyE7N
         DtOXZo+4ct24HLloHCDYP5J230j0kZNL49321SmLLuqwBOo9rdQ5dH7Sce07CCpkFg2F
         PQju8+QuCzaY165jfcP1m0Am+98BYam85Fh0LF/LPUcxkjBZJ1FF5tX3DGL5a8B8gH8o
         fwkhaPKiOCb/vo1/SRW0IKaOlgKy8sVFmpKUfhmcVQGr2+1r/sFYyluzDpDus8RTA4sY
         HpaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Th8AzSga+4716gB+0E0Rzk8DiPolYgv45HlRN8SM6xs=;
        b=L3mDZxVjiR9a8DT57VpStM9QPhH350Ov31xEAH+Mo8L6HtzL8y1FPk6wQs/G1PfaF2
         eCnoFW3cEHK0D+qjtvve4czES/tFcIK2GjYM6tUk/sf8rHAEzwyNRkfpLDbY+x81S/ud
         EkOmUf012+vALgy8vCQ+Mx3tzBN4ciMmDUHeAzw5Ce6lrYYcMQoNlSbo2ta/sx2ndNoq
         9zWIfVTk5kB902b5frze/dhO43OSJfty7MAjtXvJ5XOekQMO+KwmRP/1XWPpb/IGERg+
         fIoSD7i7/6XsU/XJrMRh0GX60zpHAakmMsW6KqJ2PW5pxz2mQjD5MGKHxdzRFvY5mw4J
         gNXw==
X-Gm-Message-State: AOAM531sPGwh/hGXMLxjRwcPvMCjI4npBQ/MdRdZPEWUb1umwUb6QHkv
        ZolarnD6zjsn1+6jVTdtWEzaOyAQfLe7GQ==
X-Google-Smtp-Source: ABdhPJyXzUovjQ5/q+uPJiAQuiYWACFoohYk3rb21UYzuONqBqFPavJAjKt66ZVA2G2dDHiI+E9UVA==
X-Received: by 2002:a17:90b:1105:: with SMTP id gi5mr5365285pjb.26.1612553015482;
        Fri, 05 Feb 2021 11:23:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a5sm11060792pgl.41.2021.02.05.11.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 11:23:34 -0800 (PST)
Message-ID: <601d9b36.1c69fb81.3b403.7ccb@mx.google.com>
Date:   Fri, 05 Feb 2021 11:23:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.255-17-gd2af09dda691
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 100 runs,
 4 regressions (v4.9.255-17-gd2af09dda691)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 100 runs, 4 regressions (v4.9.255-17-gd2af09d=
da691)

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
el/v4.9.255-17-gd2af09dda691/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.255-17-gd2af09dda691
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d2af09dda6915b36dba2c3c12314a6c2120308ae =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d66dfc81465382a3abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
7-gd2af09dda691/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
7-gd2af09dda691/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d66dfc81465382a3ab=
e6d
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d66f23af6c9c47a3abe6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
7-gd2af09dda691/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
7-gd2af09dda691/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d66f23af6c9c47a3ab=
e6c
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d66f43af6c9c47a3abe6e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
7-gd2af09dda691/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
7-gd2af09dda691/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d66f43af6c9c47a3ab=
e6f
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d66ac80f54310153abe7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
7-gd2af09dda691/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
7-gd2af09dda691/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d66ac80f54310153ab=
e7b
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
