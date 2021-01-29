Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D6B308CF9
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 20:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhA2TDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 14:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbhA2TCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 14:02:51 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A658C06174A
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 11:02:06 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b8so5749374plh.12
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 11:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qcTcMUB1ujPPk17NED8JexFSa2PJs1MKqqjCoJU+pNA=;
        b=xJ2aDeULCN95hPbu/lzDnsrxJx7gLFUec65T1RtD5VX8rUgO4ACOmKK1+m5k3kFo1g
         pQ+/LtLZpcCflPovvguXqnFNREGJIJ60HrMjOjZL9SywIMM0fPa+B6Vh/qIZqgLzssZM
         vkLtEpMvUwadWjSUaNqqn0m2bd02xGlOy+8ry1uSmsK3h07ZHq5P+Jwyqj1ugFtCJyMJ
         L8rgSJqIViKC6+/dfY4odo+VqxE9/jyTL/KxQxImM1/ZUe07vYVGHSIYf9VzCBmxgrAg
         f1sLtj+byk5Y5u7jbAxaKpwhw02/071BgbqvNePe89v/y2J7bm6dVjL/98j1amkaLE1i
         cYow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qcTcMUB1ujPPk17NED8JexFSa2PJs1MKqqjCoJU+pNA=;
        b=bg64yK/Mq4TmvH889zjekdQkoFZRkhaeBV7IF369l0vjwuf7E1vrie0Guuf5IXscrS
         Z8QYezmrFTbA88g43/EIVLC5gsVr4eZNTjbnVeT6JA3rmanSd/Pu5v7K7ao9x5J6cfaY
         iOKBlBn8MGlhQklcRgKH2N2Qfs73dQOvoSSDmlOQyrvxlWH17aWj6x9f3whj3rPdfz7P
         Z+xIdQjhbHMKh3lWUbrirBhg9GBewk8KnU5esnUAmg5xAJ123huFmiVWWrs6En7fSsU7
         8ghHF/JHY4dZK3BJqC06jHgHEv8YZkwuI04ApD8WBzDKj/f6Nk4mD3m2YloIQ3Ng4Rsv
         Da7w==
X-Gm-Message-State: AOAM530h9nKpopffC1GnIPykG0z7wEhGvD7+GJvC7pbGNneSjEgseoV6
        hV59aRNTgtv5epSsq5weOloZgkJqZACL+w==
X-Google-Smtp-Source: ABdhPJzr3ZYyKk+Zx/7VyOlB+jOcC6KB7qNjxfBC4iYCjvI5HlfB1vTVht/TNbsAn9f1iKopfqI4zg==
X-Received: by 2002:a17:90a:e602:: with SMTP id j2mr6105052pjy.191.1611946925271;
        Fri, 29 Jan 2021 11:02:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm9433515pgm.67.2021.01.29.11.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:02:04 -0800 (PST)
Message-ID: <60145bac.1c69fb81.ad15c.69b3@mx.google.com>
Date:   Fri, 29 Jan 2021 11:02:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.11-33-g324e71045b28
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 178 runs,
 3 regressions (v5.10.11-33-g324e71045b28)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 178 runs, 3 regressions (v5.10.11-33-g324e=
71045b28)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
bcm2837-rpi-3-b-32         | arm   | lab-baylibre | gcc-8    | bcm2835_defc=
onfig | 1          =

imx8mp-evk                 | arm64 | lab-nxp      | gcc-8    | defconfig   =
      | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-8    | defconfig   =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.11-33-g324e71045b28/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.11-33-g324e71045b28
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      324e71045b28705e935d8136fac983c6aa808e06 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
bcm2837-rpi-3-b-32         | arm   | lab-baylibre | gcc-8    | bcm2835_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6014260e5859478a2dd3dfe2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
1-33-g324e71045b28/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
1-33-g324e71045b28/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6014260e5859478=
a2dd3dfe6
        new failure (last pass: v5.10.11)
        150 lines

    2021-01-29 15:13:00.201000+00:00  <4>[   26.548226] aops:ramfs_aops ino=
:1e35 dentry name:\"libc-2.30.so\"
    2021-01-29 15:13:00.238000+00:00  <4>[   26.554511] flags: 0x10081e(ref=
erenced|uptodate|dirty|lru|arch_1|unevictable)
    2021-01-29 15:13:00.240000+00:00  <4>[   26.562043] raw: 0010081e eaa68=
5c4 eaa68604 c1bd90f0 00000114 00000000 e1a0c007 e92dd8eb
    2021-01-29 15:13:00.240000+00:00  <4>[   26.570534] page dumped because=
: bad pte
    2021-01-29 15:13:00.241000+00:00  <1>[   26.574788] addr:b6f5a000 vm_fl=
ags:00000075 anon_vma:00000000 mapping:c1bd90f0 index:114
    2021-01-29 15:13:00.242000+00:00  <1>[   26.583295] file:libc-2.30.so f=
ault:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-01-29 15:13:00.243000+00:00  <4>[   26.592601] CPU: 0 PID: 165 Com=
m: lava-test-case Tainted: G    B   WC        5.10.12-rc1 #1
    2021-01-29 15:13:00.244000+00:00  <4>[   26.601352] Hardware name: BCM2=
835
    2021-01-29 15:13:00.282000+00:00  <4>[   26.605079] Backtrace: =

    2021-01-29 15:13:00.283000+00:00  <4>[   26.607857] [<c08bb938>] (dump_=
backtrace) from [<c08bbcd8>] (show_stack+0x20/0x24) =

    ... (374 line(s) more)  =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
imx8mp-evk                 | arm64 | lab-nxp      | gcc-8    | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60142a0603cfa010f3d3dff0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
1-33-g324e71045b28/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
1-33-g324e71045b28/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60142a0603cfa010f3d3d=
ff1
        new failure (last pass: v5.10.11) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-8    | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/601428e6f8aa76bbe2d3dfcb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
1-33-g324e71045b28/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
1-33-g324e71045b28/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601428e6f8aa76bbe2d3d=
fcc
        new failure (last pass: v5.10.11) =

 =20
