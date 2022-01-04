Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F30484421
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 16:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbiADPEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 10:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbiADPEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 10:04:02 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA6AC061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 07:04:01 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p14so27288038plf.3
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 07:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wTq3eQBgzUDPT0ORLOKQMHBE0gfAUQw0pCWoEfHzzqE=;
        b=bdvM6nxtoiUfeZk52dwNmfkH28MHRz0bg0FDE34iAXT2BK2cVUYvd0fVq/Et6Yljp/
         Y2mhoEdpW51vSIZjZ0FdNZEBPIpPSu4JdqOJEDLGxoj6Bh7d6JoFXB/FigDBYe/dbX0R
         jOHorjGmPvzG8Oy7Tqvu7+gzNKXe+xu6pCJwtNnTbTr2f6WkSj4TLmQ5l20Vm5w2s7QN
         PAzhjpBVe8ru9bJkKJQ19zPoMSN2GjivoRFf/cT0XWkFaj10iGXGz+3LMcpkvQxzcgCx
         e2Ppdzh/k5PF6q7qrHLkPdRy2nFs88elBHHjQSKTs76x2T6qc0/O/JcHP0rg6dXD1CbA
         bdag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wTq3eQBgzUDPT0ORLOKQMHBE0gfAUQw0pCWoEfHzzqE=;
        b=UioXfNjoZLAKsom16cD8g+REpZkQw2+KsomNXq2rMyfUeR8EmE8OfuE+ahWMGGYade
         n2bHg6febEeeX25kC/0X0wUsgv7WncXMU6IHrRccyiJszIG5NsSaOPDC3S4Jp8HpOxyI
         yeJpiEdFqibpMrY8SrCruAQVMeCvSyirfjNVamivMaEdLYSunEQgq7q62mCaI+tg2jb2
         0DIOAfpRLsTrhEdFrPF7o/CQXL2CjNBUAXHS8UKEQe/LbK4WO2GK9qvAe5K5xZb3sx6E
         9Y1EgX0iFt61obZhqs6UMY8/X+BDcggL0tP9M06Y+Ox8Ta8NE2p3/lb7KoLssjMSWUNx
         rAmA==
X-Gm-Message-State: AOAM532pmZK+6Uh5JjL/wPOgqWZys/uCodwkKU8fiGshlNFLJAy3r5BG
        mfzVyNtEa65iHgkGyjCY79EoFN2nt3OBmVHh
X-Google-Smtp-Source: ABdhPJzDXSYCcQII8o9se8RpHXwpN56LBKuNc90OEfvZBlOPtP36ADmy+rirF4gEH4yGJrejbMl9wg==
X-Received: by 2002:a17:90b:314e:: with SMTP id ip14mr60439802pjb.19.1641308641275;
        Tue, 04 Jan 2022 07:04:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y21sm34788466pge.41.2022.01.04.07.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 07:04:01 -0800 (PST)
Message-ID: <61d461e1.1c69fb81.e1353.e084@mx.google.com>
Date:   Tue, 04 Jan 2022 07:04:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.169-36-gd07b74812a43
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 148 runs,
 4 regressions (v5.4.169-36-gd07b74812a43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 148 runs, 4 regressions (v5.4.169-36-gd07b748=
12a43)

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
el/v5.4.169-36-gd07b74812a43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.169-36-gd07b74812a43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d07b74812a43e11b0f5976f3f6a5a4171f8ba46c =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d430f8988e1f63fdef6754

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
6-gd07b74812a43/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
6-gd07b74812a43/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d430f8988e1f63fdef6=
755
        failing since 19 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d430ef2fa058985cef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
6-gd07b74812a43/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
6-gd07b74812a43/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d430ef2fa058985cef6=
73e
        failing since 19 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d430c5ad2bf97552ef675b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
6-gd07b74812a43/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
6-gd07b74812a43/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d430c5ad2bf97552ef6=
75c
        failing since 19 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d430c724a43bf293ef6744

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
6-gd07b74812a43/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
6-gd07b74812a43/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d430c724a43bf293ef6=
745
        failing since 19 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
