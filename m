Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863A049AA17
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1324071AbiAYDaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1316867AbiAYC6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 21:58:53 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC357C06137A
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:30:41 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id q63so13262971pja.1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7kA7M2/Qlpy1H0bHT3gcmxMd4gdBof3354KlYnlsS+k=;
        b=yq+nky+B0d/O9M0Q+HxEUXlzLXmkVUmS4APPCpzxc6wOX2Llw01RtV08dKyuWs4gMM
         oAiZh9xCdHFsY6aIU7XFx20xcuKhRr5Y2Ufalu8VW+lLmKgIwrNFoYv/PMUTR+Odcti3
         DuUz6fpUElGtpD8d36Vp5Hnl6WtFXhlV2nhnN5siPfmGwBogPHkuf7JRgIEHGpnTf9AU
         Uo3f5nVTJC8hbm1LR/+nxae/JgRPIGtp4vjsZLJqkG77YZ16M8W5YLw/Nfi6zkhbzNPd
         4MlGYqljLyYGssl1HMZwXouFORCxx31ucYqxzI5cUI2g5uOPgsjCZ/IP6So14Vzb6xU/
         qsaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7kA7M2/Qlpy1H0bHT3gcmxMd4gdBof3354KlYnlsS+k=;
        b=Q4n/QtT+a718pWpmk2ih1PrX+Ef05kXLKKSnAesrpL8fRzcOJoDEZhzkc2fwxiGmqG
         tC1OlWc1UtFM6RhcqNbfxFJI4O5FmNIDzaXZACQ2TuuKoGT8k2uMVGZPaxj0LOrJ0//C
         VfIsYksu1Zv8ePhEM7EGdBQCfv7lGae5Y+PWCj1pxOXfk+OgWXCMbiJ+Q/LvnQ4hBu7u
         mbPf8BfO7ga7pBLTT9Ur8nXYwUjfl5x5J5lTIO4eReqngwX5E3iZ9RlzSt7ti8CxwOcT
         mRWMbpGebG3YdxPUCvaMjcYUM9Pj7gQN5fBoe6euEU2nydSYdpIzdwQQ4ht5X+Z4z9X4
         jJ4w==
X-Gm-Message-State: AOAM53302tZqSuMsUZ+KODB1x90gvZC4s9chWp6e0EPxgI+IG5EV6WHW
        OMuLraE4z7jl2FKXA42lCd/IdsLXqN/tuGjQ
X-Google-Smtp-Source: ABdhPJwvityv8zXm7QCO33C//f0RmH8A9atTWYl+ib7I4LZoU70xX2vdZg5xtjrECKZt78ofV0bvjg==
X-Received: by 2002:a17:90a:e7c6:: with SMTP id kb6mr581015pjb.17.1643067041286;
        Mon, 24 Jan 2022 15:30:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13sm7698445pgi.8.2022.01.24.15.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 15:30:40 -0800 (PST)
Message-ID: <61ef36a0.1c69fb81.c0e7a.4f75@mx.google.com>
Date:   Mon, 24 Jan 2022 15:30:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-322-gd54555cc4b03
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 145 runs,
 5 regressions (v5.4.173-322-gd54555cc4b03)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 145 runs, 5 regressions (v5.4.173-322-gd545=
55cc4b03)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.173-322-gd54555cc4b03/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.173-322-gd54555cc4b03
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d54555cc4b0350f5418d00912f3449db8d42f246 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61eefc0b8410464b89abbd1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eefc0b8410464b89abb=
d1d
        failing since 4 days (last pass: v5.4.171-35-g6a507169a5ff, first f=
ail: v5.4.173) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eefc0a456c92e571abbd37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eefc0a456c92e571abb=
d38
        failing since 39 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eefc05456c92e571abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eefc05456c92e571abb=
d12
        failing since 39 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eefbf399c93339ababbd46

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eefbf399c93339ababb=
d47
        failing since 39 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eefc0470532faca2abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-322-gd54555cc4b03/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eefc0470532faca2abb=
d12
        failing since 39 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
