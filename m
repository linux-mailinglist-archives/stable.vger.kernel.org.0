Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E444A49D4
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 16:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242214AbiAaPH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 10:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiAaPH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 10:07:29 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E86C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 07:07:29 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o11so14304804pjf.0
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 07:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PDu3sPbQ7y1EnSBOP0NMkeHPlXiNYuO3bfC8cqvIeXE=;
        b=ydXXO3l4qVsPRMpvlo1fNBilkzLlfDivlch5or8fCmtX1vv3HGyXdRkrtoLyQVAsq8
         gYKXUodB1W2D8jiuiwgZcEGqVWh8TeDvHVOokDNEXy+9Cth3Km6/95AqSAQGIMRM4o9d
         krSm+fseWIeLcGduMfu27dmXiZT0Qk3ryIzXbJR2gj4ka2Hi2/z0MF5DoTC3pKhD3CxN
         O/kiEaUMo79S8tCSfWKWiJaX0RZdoAsJTzV5CacIV4RWSIHfBu1IehhnkoM5vBCTpqQ9
         lSwO2RDtvQyQEP5lVFXIaGsBlrQvDalV5Aq8pNc/j81dQDfXWQ0rMAg30dOQAdDZtiMz
         R+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PDu3sPbQ7y1EnSBOP0NMkeHPlXiNYuO3bfC8cqvIeXE=;
        b=HCLLle/Q6/L8wkWME8ziQcIVFFzd78mu4rkP3VMYP05M9JeqkahdFggdEfr64e4gEu
         Rps3qDDuDqfqR94io6e5Pl3FfeY/4sgSPzFWe3zGlql7IsdLQ1quIHhnsA1n37oZvKyN
         w0HLSWZMkvxz4P9R79nIIMak1RlctcPP1L1FObYtYi+9TBUM0SX4jsUlp99xDyMhyi2o
         DI8aOnN6dV/zIYiDmiKEdNyr1P2qF3vWx/eK/qauCT8fsX7H+DBwiNFGs+lJ62jpYA88
         TKsQrY87eGpM2ztoeYJQWneRUcew9hDbYk5mksKEeyIRqpDIoW9Y8RwDFPbsJaZL1TK6
         7Ymg==
X-Gm-Message-State: AOAM530Yi/V5iznZWI5cYb73zYdSCGeaWni6t1lZ1Hkk/aw5p4SrVxs2
        8pqzcsCD4keAYhtGST9IbsY5HI3e4naYXEpV
X-Google-Smtp-Source: ABdhPJxCj1sG36GVi/98e5WNsBlivkO4LHgFnUVIII/EkSqIuwsNsHFsIOp5ltEW8cv1o2s/T2873Q==
X-Received: by 2002:a17:903:1250:: with SMTP id u16mr20985785plh.126.1643641648350;
        Mon, 31 Jan 2022 07:07:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm16361987pfu.127.2022.01.31.07.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:07:27 -0800 (PST)
Message-ID: <61f7fb2f.1c69fb81.cf151.a661@mx.google.com>
Date:   Mon, 31 Jan 2022 07:07:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.175-62-g1dbccdc9d01a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 107 runs,
 4 regressions (v5.4.175-62-g1dbccdc9d01a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 107 runs, 4 regressions (v5.4.175-62-g1dbccdc=
9d01a)

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
el/v5.4.175-62-g1dbccdc9d01a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.175-62-g1dbccdc9d01a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1dbccdc9d01af99724b7148cc6dfb3fe321f399c =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f7c3bf6ece06b6c2abbd1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
2-g1dbccdc9d01a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
2-g1dbccdc9d01a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f7c3bf6ece06b6c2abb=
d1c
        failing since 46 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f7c3e0ac9379a8d0abbd58

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
2-g1dbccdc9d01a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
2-g1dbccdc9d01a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f7c3e0ac9379a8d0abb=
d59
        failing since 46 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f7c3c16ece06b6c2abbd20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
2-g1dbccdc9d01a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
2-g1dbccdc9d01a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f7c3c16ece06b6c2abb=
d21
        failing since 46 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f7c3e2de238258e2abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
2-g1dbccdc9d01a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
2-g1dbccdc9d01a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f7c3e2de238258e2abb=
d12
        failing since 46 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
