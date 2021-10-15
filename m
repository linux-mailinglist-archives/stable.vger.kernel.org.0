Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBD742FDA5
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 23:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbhJOVxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 17:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhJOVxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 17:53:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE80C061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 14:51:12 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id c4so2698734pgv.11
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 14:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RPPkoL3+dfBz09MOYstW3Zk6MDLdxecf9ZSKg1SH0ic=;
        b=jpgUBY4MbjUQfNSxTxb9/LN4oQX/O91R5O6COXZkOjpJDIEQBdj6k7Ok4Qzj1o2pms
         gop/263atHJ5ob+egcjmG5NDtV4IXEyg+oC3gNGbSfU/s87InqMieKDHvXHl1/6y+nnL
         ecQ8XUWh2YP/ZiL/zP9EbnyLSYCIbqJwqK2SH1NmuXI3BgQkTwW8PJPEO/TFt1aIsldU
         0OEkDTo9tPXCyOiWwXbiF7jPalEBxRR2JDZ4UfAh3qhsGOdpgUSlFk53WU64Xe7Ai5J6
         MmgcAa+Jd35RZ/nBkBe+k5IuE716CNNCBDZlSpBi3+TeoLJvUJzp2y+yhsT29zkawTlB
         oYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RPPkoL3+dfBz09MOYstW3Zk6MDLdxecf9ZSKg1SH0ic=;
        b=M6rCbXvPAyp4o/pY5pACY/Fm66Ho2sumizUIcMWIKNavXDCxMTab4QzYv/HkEGN+aq
         lGRUuJkcTuH33bHWa6sbsbHQBpqPdObSrKrZ9t/NPcUScxiw32JsBkxjG7lZrsX7ig2K
         hoylaDVJJuvaAtGjIsyw4VWRw28VLX8EMxZC/fW9kAqCEHgxDZ4aqQ+74w+eLy1rokrm
         DE6LS1hL2lH4BOuJr/H9399rBxQjxClkcmA7XDNbh3bSUpVklLT4eAttob35LryBsiZf
         l3LZsTID5X3+YIstgH7knzYKE7SI1s0reV+GxgpnSCyLfzGIrcknz/c9Eq8QmK0LWXFT
         fFOw==
X-Gm-Message-State: AOAM532P4kMyYBU0igTvA9x/J51TaqgwgG7JiiODg7cFW4b/jgBCOpXA
        ANQU3IyLKTN3EJBJnC9KFybtishoDyih2en/
X-Google-Smtp-Source: ABdhPJzBIhAZKkMt7niYc2mscG1Sd+aeqm8HFvyzn/8lN53igcNYcqr1/40ln+5RhiMplVEgB7R46Q==
X-Received: by 2002:a05:6a00:d43:b0:44d:6d58:41fb with SMTP id n3-20020a056a000d4300b0044d6d5841fbmr13871748pfv.56.1634334671703;
        Fri, 15 Oct 2021 14:51:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id rj6sm2264994pjb.30.2021.10.15.14.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 14:51:11 -0700 (PDT)
Message-ID: <6169f7cf.1c69fb81.3857b.6fa2@mx.google.com>
Date:   Fri, 15 Oct 2021 14:51:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.288-18-g7376049d5811
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 60 runs,
 7 regressions (v4.4.288-18-g7376049d5811)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 60 runs, 7 regressions (v4.4.288-18-g7376049d=
5811)

Regressions Summary
-------------------

platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_x86_64         | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig  =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.288-18-g7376049d5811/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.288-18-g7376049d5811
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7376049d581124aa56b9fa265531f19f3ac326be =



Test Regressions
---------------- =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169bed57388571d6b3358ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169bed57388571d6b335=
8f0
        failing since 335 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169bef1ecb4deb92e3358f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169bef1ecb4deb92e335=
8fa
        failing since 335 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv2 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169bec87388571d6b3358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169bec87388571d6b335=
8e2
        failing since 335 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169bed4ffd6830419335907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169bed4ffd6830419335=
908
        failing since 335 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169bef0ecb4deb92e3358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169bef0ecb4deb92e335=
8f4
        failing since 335 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv3 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169beccffd6830419335901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169beccffd6830419335=
902
        failing since 335 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_x86_64         | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig  =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169b98b7777e082123358fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-g7376049d5811/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169b98b7777e08212335=
8fb
        new failure (last pass: v4.4.288-18-ga8ec20dcebd9) =

 =20
