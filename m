Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68756494235
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 21:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242646AbiASU50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 15:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiASU5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 15:57:23 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B005C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 12:57:23 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id br22-20020a17090b0f1600b001b50eaa9e8bso1622986pjb.5
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 12:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j5HLkxaUVVOwMM3+8RGpc7xMkpIS+pfEnxO0v8E+0OM=;
        b=DwMIGhmQrmBTMCTg6wKTf2FSLkw4niWfdn/yI93Qh5xUWDj+/ns8q5RRSVLy4UJJSi
         ++C+bY7Gq3MYioF7pN3q3jynzr/RwFp1/HFsA7NKf5qtKhQWrMfDZ22cZ4ewYh36j2DB
         hWrRPwWCLkSGwiD4aaEVrosOrFaxwEwqRmeL9yCsSL7U6bLBiuH9clwAwLFhrA4mBX0R
         cnmvwnJ2b/UKDOCKGeiMn48oPmA6M25su1I1rKTH7cX98DatMcF8hZnJETF740mzNLa/
         xMAVhkiX0dDd++x0unwSRvBChVB9Da/wfYKfA7Jcwxu3HPFwX834G+qF5y17myH2dYWI
         nRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j5HLkxaUVVOwMM3+8RGpc7xMkpIS+pfEnxO0v8E+0OM=;
        b=UXnP0rUPyH90hFX6cwdSMKIEOL/GudeYfYgCpPsMwJ3hm7fi6ExHxvFsGVBjqDweZB
         vTPFXBUdMvnwHNpd2Q2NDsBOS6sJiJYkXB/ZIcPnVfqUM6Q/+eSMGe/AYUAskDeacusm
         RFmHsxpGgNHH34mjnNWWm5uvYPvgtAo+ij9MFYjrzPQDtg+avYfRO9POSoM2LCIj+uEz
         9cXRdAE7VfIsi8GHneoiNKXAyZ1LX5UP1F/s2SieeHjwNF1ZUy4VqDRwGxDUSyTxeH6g
         4lMIxi8mgDBLqasDK0j/CUETF+nXkqkAe3dGX3cfF7Fg0LJ+Nnc1G8MGjXrKKbtgM54s
         Bnqg==
X-Gm-Message-State: AOAM531w13yg+GXDNKhiPXqf17ZHurMwNn0PL3o30+lfg69DrTql3mvt
        wWot09YMHvvcZSLbK7VwO0l7WPaeEjE5vmwU
X-Google-Smtp-Source: ABdhPJzjDXg0gdOr+/FEIwANS0TE0ocyvQHFaoJoQojkff/w442/WCH9Vc6gS6dmtQ1EmCMNqEeEEg==
X-Received: by 2002:a17:90b:3ec4:: with SMTP id rm4mr6418328pjb.120.1642625842622;
        Wed, 19 Jan 2022 12:57:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5sm497919pgd.36.2022.01.19.12.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 12:57:22 -0800 (PST)
Message-ID: <61e87b32.1c69fb81.121d.1fe0@mx.google.com>
Date:   Wed, 19 Jan 2022 12:57:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.171-34-gf15ab5dd5b0f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 119 runs,
 4 regressions (v5.4.171-34-gf15ab5dd5b0f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 119 runs, 4 regressions (v5.4.171-34-gf15ab5d=
d5b0f)

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
el/v5.4.171-34-gf15ab5dd5b0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-34-gf15ab5dd5b0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f15ab5dd5b0f988c0bdfdde02bfd0568361514de =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e84616df30aed883abbd40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-gf15ab5dd5b0f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-gf15ab5dd5b0f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e84616df30aed883abb=
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


  Details:     https://kernelci.org/test/plan/id/61e8463c24ff860446abbd22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-gf15ab5dd5b0f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-gf15ab5dd5b0f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e8463c24ff860446abb=
d23
        failing since 34 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e84617d27a9501f9abbd1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-gf15ab5dd5b0f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-gf15ab5dd5b0f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e84617d27a9501f9abb=
d1c
        failing since 34 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e8463d6988595adbabbd18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-gf15ab5dd5b0f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
4-gf15ab5dd5b0f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e8463d6988595adbabb=
d19
        failing since 34 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
