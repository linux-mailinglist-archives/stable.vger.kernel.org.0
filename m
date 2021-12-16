Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676C3476770
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 02:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhLPBaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 20:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhLPBaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 20:30:35 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37059C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 17:30:35 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g18so22229513pfk.5
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 17:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fZ++iwmhkWVz2fGDlEFtzAeUZAWFOOMCnkSsgcRUO0g=;
        b=2+BxS6SaVa01iBzCzgbnueadeVF3EZmWV3uD0QWsfPnomcjDdigFkU08iT6/b4QyRX
         HNKttThcAUzYJ4hAPGnkKb0+vQdhdi7cnwxE9RV4rrfsptJD7imULQn/F/LeC9SFhAZO
         ccG+C4pWUIusSw5Y+ZhGTdmCoDKZHb0keOdSZoiLwL09V1ihsqYDcpEJcLW/QYnvf2QG
         jT+ngLFEl5ieF7cVvnFd/tbVrgktxfdrg2RXCkXaLT1yOEi1SdIx6Ui9SJwKRnyErWsv
         hdwNyZCJuhOGPwEaGvIMZrkmmZoqqg+Zm8HzVky004aK0EKxsmcHuOVYxfRcfQFSRmAF
         XUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fZ++iwmhkWVz2fGDlEFtzAeUZAWFOOMCnkSsgcRUO0g=;
        b=xrhxhgdzsQTxHOJYSTxDrRk3hnTbGHvkLfK0JzVnqSvRfy65JLs8OLbg0St8+xC37X
         6HrEx95Q00g1yrti9wuW3KyFHGyhVECj1Dhq5G9JE5Veez+ZZ1p/TelWyukmIfeXTAtf
         zJb8r7EzIVqUxecxOFZQymQPWb3TR2zyENSkatw/vKtmoMyrmhsGLlngzqKxVdqCv1HA
         UqI206KQvz/y75eqm5bKvRdtjZHIYJCib0/zMMsxKDfViKQNYGoNeT7Xe12oqxdynfPq
         WYh3ikxLgqQHK3yEIC66TglxI6gKXFZsg8+JN752Sy3F6UGKOcf5OcLaU/ND9gqF90ks
         6TDA==
X-Gm-Message-State: AOAM531Z3xa7f00+ss+L+IWGiUpuWq1tTTkT6qHJUxTZcgG9CYcyFMzJ
        BJj+PzMwDoxeEKNI7EPFv/cA59heX7DEDOxJ
X-Google-Smtp-Source: ABdhPJxX3Xix+wwUjyQfwuBKiUV9Ml6lNWPwvii1lV1kGQ4rUhkNWkavd7UysBXBKxYvhxk/W8Z4KA==
X-Received: by 2002:a63:461c:: with SMTP id t28mr9635192pga.171.1639618234554;
        Wed, 15 Dec 2021 17:30:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6sm3363763pgk.43.2021.12.15.17.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 17:30:34 -0800 (PST)
Message-ID: <61ba96ba.1c69fb81.98aea.9a45@mx.google.com>
Date:   Wed, 15 Dec 2021 17:30:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.165-19-gb780ab989d60
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 164 runs,
 4 regressions (v5.4.165-19-gb780ab989d60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 164 runs, 4 regressions (v5.4.165-19-gb780a=
b989d60)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.165-19-gb780ab989d60/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.165-19-gb780ab989d60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b780ab989d6045e3a7f03d21348c50a4ac4fb2c5 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba5fd7db981c1697397153

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.165=
-19-gb780ab989d60/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.165=
-19-gb780ab989d60/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba5fd7db981c1697397=
154
        new failure (last pass: v5.4.165) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba69166bc5c280b739711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.165=
-19-gb780ab989d60/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.165=
-19-gb780ab989d60/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba69166bc5c280b7397=
11f
        new failure (last pass: v5.4.165) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba5fd5db981c1697397150

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.165=
-19-gb780ab989d60/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.165=
-19-gb780ab989d60/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba5fd5db981c1697397=
151
        new failure (last pass: v5.4.165) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba68ee94daa60cf5397132

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.165=
-19-gb780ab989d60/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.165=
-19-gb780ab989d60/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba68ee94daa60cf5397=
133
        new failure (last pass: v5.4.165) =

 =20
