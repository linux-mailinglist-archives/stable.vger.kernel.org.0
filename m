Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EEF3E0CF6
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 05:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhHED6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 23:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhHED6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 23:58:47 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F08C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 20:58:33 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id k2so5468347plk.13
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 20:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5BQlTPfs2Sl4TQ44KHxVgy6johPaIGqzTIfU3rR9ZR8=;
        b=hgARGEljL4lveYbgYAptM6jQiYTCsunTy6yo4W8DmBtHl9x155OYK+5SxXpdkvd90y
         oUCWDQW9Vi5wGA1kUD1N9WrnU9fo/7MCdbXJ2Lh8NctdWcaWaGUWLj1RTrLkPK5KJjje
         T/3vLtd4xj59GsB/wpE5SOTB42TM5p35BZdflU7BK/5GO5Ffv8p2y6ryFRXCjS8xOvxS
         ktN+dIEin4RWypQ4CNAv/Cr+ghtNWqYi6c8lv0kziDcSVj6Kx9I6FnjUBrGPnp9AaISb
         z+wpHUr/M8cykovNmOroXUTnyYyEoTAb+sZFHOzrUINMewMB0zbuSPThHY3+N9SxOWuJ
         Lv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5BQlTPfs2Sl4TQ44KHxVgy6johPaIGqzTIfU3rR9ZR8=;
        b=TkO2j1rsIjxDfHQ23Ik/ZK/vI9FAJLMTutaVxlqX1LqKW+/Q09swBxZpCsQRLHbKOT
         iUclwYQ7ufMcZl9f5WTmO00JCVVnNawdQuchKeyKDBr88gnG9bdQUJtCOKsjtdGiidgH
         vZ/ZcWmqNxyX9bONBwfIhom/jelQ2/iKH4tXXnChwQGerwnnuOfYoQCvyM9sYKzaq3wY
         psOMNZOARD7/dQKfpnJq0w8dGoP6KraxtAJ6GtrPGKVdSvAQNW9SHB6VmPhx2Qg9MWbl
         kNMIFM29CM2z1ebDQU0ENecnDpaFFfL4Y02TScxrvpoWY/DlSNmctso7tW5kcUBQnw1k
         nnRw==
X-Gm-Message-State: AOAM530Ec79TUScF3ISwBwFVy2VvcKO/3hkmPXyVHxOkQvIFjDt6YB5n
        iqTSabxzxKBODv0YdcY7X5hf0Q6+RiGnsrWa
X-Google-Smtp-Source: ABdhPJyRLWwY44kEtnHmdwUfP4vILxR/uz0z9aDwJd6qlQDQNJn6/vtwtXZw7BkmYyqKqWtgmN/Ebg==
X-Received: by 2002:a17:90a:d3cc:: with SMTP id d12mr2498634pjw.151.1628135912740;
        Wed, 04 Aug 2021 20:58:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm5393907pgd.50.2021.08.04.20.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 20:58:32 -0700 (PDT)
Message-ID: <610b61e8.1c69fb81.ec34a.14aa@mx.google.com>
Date:   Wed, 04 Aug 2021 20:58:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 86 runs, 3 regressions (v4.19.201)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 86 runs, 3 regressions (v4.19.201)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.201/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.201
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6ca2f514c57864e3085a65c5e9d2adca4144bc4c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b29e781021ec7a6b13671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b29e781021ec7a6b13=
672
        failing since 259 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b274b1ab9343d4fb13667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b274b1ab9343d4fb13=
668
        failing since 259 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b5b02efd342675fb1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b5b02efd342675fb13=
67c
        failing since 259 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
