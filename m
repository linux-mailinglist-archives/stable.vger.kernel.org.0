Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F9749339F
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 04:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242776AbiASD2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 22:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351310AbiASD2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 22:28:17 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1925C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 19:28:16 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id e9so1112140pgb.3
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 19:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lObZO+EOWLUsxT+onuhql/50gN3tcQO/Tot0TyKlUTw=;
        b=WNZupbJz1bBrh+Kxpfd34rXofloWZXkm7cFV9nXxPt29Dtbp/ccmsyeEPci/wX5Yiw
         6CPq8sY9s6O7qCIkSCGR7CchSLHpRbRwov0zdGm60eDAaofOAUUakvLy3wrHesJDhm26
         ViZ6QgJIXq/+IzCRH6Ud/GO+u/95+UZQc+vhyz+ILVMBOmBwiPxAwXPiUwe8dLmzajJK
         6ZzICgMWp7FbGzwcILwn+5MUJ5J8LFkqih6YR0OjQVa151S6cuQlb/HYtJUhBOAtNO/8
         XVZ9/lx5NM4TWeiw7/JmEIPgJi2L5XkxwHrDN+ZUZawjnGdSFhXpgRi9F7kr3YdhixMe
         qUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lObZO+EOWLUsxT+onuhql/50gN3tcQO/Tot0TyKlUTw=;
        b=hUBrqeLdWY9uN51jclE5pG7e8Nd3yH9+Pqy84iqdlhprkiqtavLJk9uCZK1dbVcmDc
         9qZkDp/QTiG4OrH+NDmHCx1oHQ2E3qFwv2KYjGt7x/cNQcYHoAcipTmmLplf4KbGWAkM
         V3huGcxrX2q061V5piykWUkCGRgWp8YQWYleTg6sMoy7rQPYlh28AD/PFIbyiGGlMgGw
         nRdXn3vjdM3ZX3XVtc5Prz0cxq7QVsjHVElAWu0mqVqEap5g7iwGIk3l2KSBIojB/Umk
         gNscscIS58tGa0zbhyxyWUOfhFSdGM6pWDMgoxLQTAZHqSxo4E9JIzNhsnpbYLWc1yBs
         Ca1w==
X-Gm-Message-State: AOAM530hb4q52/0J8NIO9c1hK7tcKgQ+pf8ospMoPaJycI/EAbhN7tkz
        GSVvfMOmD2RMcJVm9KqqquRb/9E+HUk3Opwx
X-Google-Smtp-Source: ABdhPJxqN1IZsMxbgexdpHeIcMhEwBpYEOLdm6CyGwanMLPWFUJaCqXdgWNN8Qtpdk1JTB52qgNZ4g==
X-Received: by 2002:a05:6a00:1595:b0:4c2:7c7c:f3df with SMTP id u21-20020a056a00159500b004c27c7cf3dfmr23760352pfk.71.1642562896314;
        Tue, 18 Jan 2022 19:28:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t12sm16633553pfl.68.2022.01.18.19.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 19:28:15 -0800 (PST)
Message-ID: <61e7854f.1c69fb81.7f03d.dd83@mx.google.com>
Date:   Tue, 18 Jan 2022 19:28:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.171-34-g717ea32e61e8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 151 runs,
 4 regressions (v5.4.171-34-g717ea32e61e8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 151 runs, 4 regressions (v5.4.171-34-g717ea32=
e61e8)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.171-34-g717ea32e61e8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-34-g717ea32e61e8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      717ea32e61e84fdd6832226bb1be5a7db2b44e19 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e751236b99ff37a5abbd40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-g717ea32e61e8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-g717ea32e61e8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e751236b99ff37a5abb=
d41
        failing since 34 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e75141f08bbc0bdaabbd1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-g717ea32e61e8/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-g717ea32e61e8/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e75141f08bbc0bdaabb=
d1e
        failing since 34 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e751216b99ff37a5abbd3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-g717ea32e61e8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-g717ea32e61e8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e751216b99ff37a5abb=
d3e
        failing since 34 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e7513d6b99ff37a5abbd72

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-g717ea32e61e8/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-g717ea32e61e8/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e7513d6b99ff37a5abb=
d73
        failing since 34 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
