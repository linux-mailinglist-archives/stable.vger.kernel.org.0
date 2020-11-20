Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D8B2BADD7
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 16:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgKTPKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 10:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbgKTPK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 10:10:29 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1838BC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 07:10:30 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f18so7507834pgi.8
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 07:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3Jst01Tb5Z/OZKdYbrfkASbAqzbT1a0cXFqJbnkog4o=;
        b=ape3xzPf3jVO3kvFMuJ+OHdZwTAW4aFGHsQsjd8dsYOqyv5F5J1GRzAf2aka8NWwFQ
         LeZZREq/UmkT7AxOKgbt+p0wuxQH9U2EVY26W2DnVfUNyKdRwwcLRxwjNezSWPZFW4c4
         xIWlFc2fXPTJyX7p95eiHPpn+4Ygqu2G0wW3ARjfUxsNLb0ollxVCVGHUB1BMTslA/0d
         isNaPFMshm2ziEexBTjcDpjvkVLM67HWkqdw6QMnDq9SBg44V32QB8b0Y5uy4EOAV9Y/
         bHtRV8zjuScZwvywTjSYBRXBgoApr6Hec975T8f7sjfoHNouCJI3oF5+279L4RNYdeq+
         Gv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3Jst01Tb5Z/OZKdYbrfkASbAqzbT1a0cXFqJbnkog4o=;
        b=fiRAtXLJD73hWwRDPElaXnMXlR7gAZIbCf8tFl89k9VBeukIB8iwZ8TDtaUMT2X/AJ
         iWCnVlUFQ/MWFMuA4Mhx5bZSsmner2L+e2/zo5WiK3F11CXN592N/IzwkZWEeIbLNs6U
         k6Fre30dxUaYLkzaLC2+pcX1OfYyFBi0c3jp3pQqmsLR4MU7mXvdKATA8RCn/jSfhMis
         A76QmlrXNYqcRxHaYJhEqeBIDeJLBRUjiBnJYDs0jeotjUcxM4+I91P4D4nJ87csfxYu
         atGiUSIIHzsGeVmI4lVNL/j0m+32sxZ+QKEo0JEoIC2rrUeqxYFAuRCvccgGTyl2po9m
         +rzw==
X-Gm-Message-State: AOAM533MlvVQAqLI4EnJwMbnXI3kIkA+MXls5lWaa1Ju3/YseARjOiV1
        57vC6kCZMWT+r2jU4poeOPZPvktflpjTdQ==
X-Google-Smtp-Source: ABdhPJxZOh6mriGCjWKMQrxtPsqAjmhuyDl/3EMGQ36DrKXLNsOC3DwhR9VrzoAvj5hZ0FNy+HE7Ug==
X-Received: by 2002:a17:90a:d491:: with SMTP id s17mr11178135pju.2.1605885029182;
        Fri, 20 Nov 2020 07:10:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y3sm3357235pgq.40.2020.11.20.07.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 07:10:28 -0800 (PST)
Message-ID: <5fb7dc64.1c69fb81.829b3.645f@mx.google.com>
Date:   Fri, 20 Nov 2020 07:10:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.158-15-gc12ebe354432
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 94 runs,
 4 regressions (v4.19.158-15-gc12ebe354432)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 94 runs, 4 regressions (v4.19.158-15-gc12ebe=
354432)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.158-15-gc12ebe354432/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.158-15-gc12ebe354432
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c12ebe354432094bfb49aff27040678f8dba6358 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a265345508b68ed8d8fd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-gc12ebe354432/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-gc12ebe354432/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb7a265345508b=
68ed8d902
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55)
        2 lines

    2020-11-20 11:02:56.160000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a37c5f769f8d25d8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-gc12ebe354432/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-gc12ebe354432/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a37c5f769f8d25d8d=
908
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a38cc3ac306616d8d914

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-gc12ebe354432/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-gc12ebe354432/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a38cc3ac306616d8d=
915
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a339afab5b7943d8d908

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-gc12ebe354432/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-15-gc12ebe354432/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a339afab5b7943d8d=
909
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20
