Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B783E50BB
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 03:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhHJBsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 21:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbhHJBsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 21:48:21 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEAEC0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 18:47:59 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so1972484pjb.3
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 18:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NhVkgnZrB8i84RsbuVpesQMQV00qoXcFQzebLfamfEE=;
        b=tybu0Md3/kbz7vlkwuUq5czQbeAMVddOXXy3eQOiB7vUiq+2si9yEceBcw2OxtH9e5
         a28wbw6U2yaNGrSTbQZ4jPgiAr8B6iRd8h1WTFkgj9++xP0XsVz31dk9r24bqSnFjWo1
         pkv08wQKvfUndAamqx3QpZ42RggczX3C/XJXqQGVg6NVHX12/gOumkDquxSG+Am3QkQV
         6R/r+3uFsEh8JT0bAPCzClNsRNW4ori4FVeLtlfuKJTR9cN3bY4RBU+QPmcDAm5uIP9C
         S/cMMXyyWg+LTWMggzrbeqE/tb219IQOaGwqlNc07rf9z00DtgE7kOsgdmsDGx/5KYXu
         bFeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NhVkgnZrB8i84RsbuVpesQMQV00qoXcFQzebLfamfEE=;
        b=V1GwL/1fcfTrnb8Awl91qIi9JSSd9InI9GSMz0tPhtQdMjlusU7L7sRhOmeJGeX31v
         ou4p1kIqqn3g+SHTnz6JzEDBZmKah0vy3Q0OO6KJPm72NgbdlaguYHUfbsY6ellC7LeN
         ZVe5MD4Rlzarp7lqPux9TbqIOb2F5u31v7gGjH1dLwcdEQDT9dD8nvZ583JRncr9nE2e
         +soaLQBqBbceYnc2gzR6OdalVUv3AlKLr5ra0cm8n0TMNCxBI4QNx8daOQH7WUE8hSCT
         lgzT5RofkW86CTYc9Zndb5ro77O2S+8qcvR5T2BFeACtoe/MvnHnJMeOHmpUSwBP4jtz
         /tRQ==
X-Gm-Message-State: AOAM533yfekkPfU65kNu1r20stsVMYJ7C2Rh2tj7o4uZyA4cVHJk+bUY
        Qw16HKqvNrF9dJy+O+llMPK2FYWcYZaX4czn
X-Google-Smtp-Source: ABdhPJzWiaL+gtWmowPvTG0/GYVJW5njbtA+omZyDr0HdIpBm1DmHG0wxzLcQfqu+Pjfe0R8FPACOA==
X-Received: by 2002:a05:6a00:1245:b029:30f:2098:fcf4 with SMTP id u5-20020a056a001245b029030f2098fcf4mr26524358pfi.66.1628560079057;
        Mon, 09 Aug 2021 18:47:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z18sm17260349pfn.88.2021.08.09.18.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 18:47:58 -0700 (PDT)
Message-ID: <6111dace.1c69fb81.76c0d.2192@mx.google.com>
Date:   Mon, 09 Aug 2021 18:47:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202-48-gdd2071b47526
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 105 runs,
 4 regressions (v4.19.202-48-gdd2071b47526)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 105 runs, 4 regressions (v4.19.202-48-gdd207=
1b47526)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.202-48-gdd2071b47526/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.202-48-gdd2071b47526
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd2071b475265d49f005014ce69da5f665ed4094 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6111a59891f7359631b13687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-48-gdd2071b47526/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-48-gdd2071b47526/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6111a59891f7359631b13=
688
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6111a5ed13c35c4579b1368e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-48-gdd2071b47526/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-48-gdd2071b47526/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6111a5ed13c35c4579b13=
68f
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6111a53ea49319dedab13695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-48-gdd2071b47526/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-48-gdd2071b47526/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6111a53ea49319dedab13=
696
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6111a53b6aef0d7b8bb13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-48-gdd2071b47526/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.202=
-48-gdd2071b47526/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6111a53b6aef0d7b8bb13=
663
        failing since 269 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
