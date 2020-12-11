Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A345A2D7F93
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 20:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgLKToL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 14:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgLKToG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 14:44:06 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861C9C0613CF
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 11:43:26 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id f17so7823052pge.6
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 11:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3BtkZJWfG9qnMlCkjXJ7BjeiLgSyKFU3fgKreI0KSh0=;
        b=H704IB2fuSTnJz5HOHcG791SNGWObXGdzG+DKWbfKmKRJl4MT4amFiiMxv4dSwP1Zg
         YzqzK5IinJBMbapLACQpdvRtUv4m6rQDsvtvdQIppznYhbvShAqNPRVB9+fe/oHo/CR+
         mEQ/h9A/fBMjosSbZgigem+OGJEVGWd5Egr4OiKnnFLnuCIe5wmomV7ekDrNQAMccpae
         IKRljZ2beWt5p2igwfxAHAQaVvuViu3WOakAcPA6X+ZOfbr6EPDv90ojJTYzDlX6htZ6
         f82LcyMY2jpepCILO6z3sp7UDuHL0IWZAybZrfQzxK7g62rS54mbvL3MNycjV+1CSASj
         7IEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3BtkZJWfG9qnMlCkjXJ7BjeiLgSyKFU3fgKreI0KSh0=;
        b=iktpFZgiglZa6iyqcTysFy1+KaoSUM5DljC8VPewpPBk5kL3YE2vIP34Z2xKXMNuVz
         pVCJ2iAlQ1MV+gyhs5YbXmBQYz7+TTIJO3XC69T5q/4M3sjN0SlnBgdk4JoeqN9neQu2
         UPa5HZDro9thH3imLe5B0RBwF4mSbZM1GGzxcT2c/+D3OR07wFGNvZvoQBrMCuVjM0bA
         I4YZ+If2IYyimMQ4ohe4fGnQj5Hml6QzA3TyYqFVQoyU404XbKYW+V8xvzTvMvp8tO5x
         aaSfyGzQ/XX8+dmZlvixabcL95xqliomzXHdYXf8ASUCY0MdC0eGEnASc0nglJR1KYzv
         TLzQ==
X-Gm-Message-State: AOAM530YXauxLEaP6PiV2HBOGajhJcolTjleEV2lUEBimkMHTPIre2KX
        nDg/Q5v59ozJXAbhcCTQe3Vcf8QSQtDW9w==
X-Google-Smtp-Source: ABdhPJzd3WTsKslK8O21NKKnSu75nF6AOT4P6Vo1YGKmdRmfyqoechQHiVJUmIFPRrLtV9xx5qlcZw==
X-Received: by 2002:a62:844b:0:b029:19e:62a0:ca18 with SMTP id k72-20020a62844b0000b029019e62a0ca18mr13146380pfd.46.1607715805740;
        Fri, 11 Dec 2020 11:43:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c62sm7602294pfa.116.2020.12.11.11.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 11:43:23 -0800 (PST)
Message-ID: <5fd3cbdb.1c69fb81.f5c60.e156@mx.google.com>
Date:   Fri, 11 Dec 2020 11:43:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-47-gdbe0bff17846
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 90 runs,
 4 regressions (v4.9.247-47-gdbe0bff17846)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 90 runs, 4 regressions (v4.9.247-47-gdbe0bff1=
7846)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.247-47-gdbe0bff17846/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.247-47-gdbe0bff17846
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbe0bff17846a837bd2ad81f3b692db9d9f721f9 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd397e701749dfa42c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
7-gdbe0bff17846/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
7-gdbe0bff17846/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd397e701749dfa42c94=
ccf
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd397f691107edbf9c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
7-gdbe0bff17846/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
7-gdbe0bff17846/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd397f691107edbf9c94=
cbe
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd397ee2ada9046dcc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
7-gdbe0bff17846/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
7-gdbe0bff17846/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd397ee2ada9046dcc94=
cba
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd397a24ba9251617c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
7-gdbe0bff17846/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
7-gdbe0bff17846/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd397a24ba9251617c94=
cc1
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
