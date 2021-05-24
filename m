Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68CC38ECB9
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbhEXPWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbhEXPQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 11:16:02 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEC2C0612ED
        for <stable@vger.kernel.org>; Mon, 24 May 2021 07:53:18 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f22so12654874pfn.0
        for <stable@vger.kernel.org>; Mon, 24 May 2021 07:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f0F2PjIROeu7/LLDPnGFHzT7Frjq/5dXMx+8pJIhGk4=;
        b=fzz4RJYFYc/KRnNGirPlL+TPjMz2ijGyS1sd86WfXF92DGmrRnDNtZPa5S7ExqV+sf
         1klc6Fu3uwcJg4EFNTWzHpiFla35/gN7u54lZwB+1zMK7C9oM/EowiowaTABUOypBTdy
         nj8mGRwY3J55tmslkX62IeF9Gyd5iO/obrOYV14bdsv1gnNSvSgk72cElWSLiq0k0QFn
         2rgWjdfIWZopxythUrqTNequwdZDcAz6rlUzoEzpIAZGiPXOTqeLP0ss7zZjQdzJF9o5
         3xGMquRCUadPMC+pN4xlNeYKXytxtKx6WW1G63ZCTENAlA7iCjHXLnZw7muyZe15iIZA
         4eyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f0F2PjIROeu7/LLDPnGFHzT7Frjq/5dXMx+8pJIhGk4=;
        b=Um+XtB8/W4z1l7Rff/s0/HihUY9fabbCoEAj9zs1kgXthyFkSAglIrx9VDMWYw9ij/
         hD/x6NZgvzEdcdK/yDOZkqcQH8+1YtWijDSwHOLyczNDkXxCFkFiSkG6eY5AXbPybCDI
         W1wGYB25mqXnR6HHMsokP3NF6/w/LJ/XK5FJZDEkc80RL/zFyqhmgHkh6xVRpeJoIMYo
         m+Oi7achyTd0qdUVGja7GV6LGTdd6k6ZD3cm4upb4gDs6oK5GrAjTtlmvOzGCjvMMRZj
         ObiCFwxeyYE3Hm2ymE9kyXyBBRHfFBG95+UdbcShS16801O0jHv1YCk37tcouRHjOIkG
         9oQQ==
X-Gm-Message-State: AOAM533NiFbn6OTEfmbutda14EcAx6Ehe6td1u/KX+jm5fPaZMIsBilx
        Mv49Hfh68jcO2ufdrSTTUMgKH3cikHRnI8c2
X-Google-Smtp-Source: ABdhPJzWGdnuUondGRFbKxPdB2qcCDuswg3UhY2tx7WpTO+Woo3YxwXK9+wWx/8yQC4+Muu+ltfnKw==
X-Received: by 2002:a63:ba1b:: with SMTP id k27mr13982453pgf.381.1621867997477;
        Mon, 24 May 2021 07:53:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 85sm11711726pge.92.2021.05.24.07.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 07:53:17 -0700 (PDT)
Message-ID: <60abbddd.1c69fb81.6975d.6042@mx.google.com>
Date:   Mon, 24 May 2021 07:53:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.233-12-g1446a7fb9ba5
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 84 runs,
 4 regressions (v4.14.233-12-g1446a7fb9ba5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 84 runs, 4 regressions (v4.14.233-12-g1446a7=
fb9ba5)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

qemu_i386-uefi       | i386 | lab-broonie   | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.233-12-g1446a7fb9ba5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.233-12-g1446a7fb9ba5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1446a7fb9ba555a5f708258597a3b0af46d774c3 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab89156ebe5383cbb3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-12-g1446a7fb9ba5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-12-g1446a7fb9ba5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab89156ebe5383cbb3a=
f9c
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab88b1d96b5c98b4b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-12-g1446a7fb9ba5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-12-g1446a7fb9ba5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab88b1d96b5c98b4b3a=
f99
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab8e501b1f3cf1d6b3b055

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-12-g1446a7fb9ba5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-12-g1446a7fb9ba5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab8e501b1f3cf1d6b3b=
056
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_i386-uefi       | i386 | lab-broonie   | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab8acd1451ad5762b3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-12-g1446a7fb9ba5/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-12-g1446a7fb9ba5/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab8acd1451ad5762b3a=
fae
        new failure (last pass: v4.14.232-327-g2fbe9738ee01) =

 =20
