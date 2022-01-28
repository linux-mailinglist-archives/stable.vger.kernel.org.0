Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3449FBDD
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245084AbiA1Ojj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244940AbiA1Ojj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:39:39 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F9FC061714
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 06:39:39 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c3so6083090pls.5
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 06:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BTixdK0PppQ0GXXSyZHvwqDVSiAMbWPqf47i8YZpbwQ=;
        b=F7VAwUdQH3z7hoTV0ExPMjB3Cfi+c9/XZ96FjhDlpCF5uQ6h84enHlUnIiY7HXCzk8
         1sAqEA3kQc5Hc47gAK3Jl0IpW97enjuOddfkCmNYPn38dCaUTZ/ERkrxa0ry1SkqkAb7
         i4b+WO7WkX68/6GwkxvxxKdrpqB4K6yUaA2U1foFyOibmDW4qmus8gnBZTUs9874Sn4W
         2lqp71INmynFIHsOn7C77+35UJYY1SnuuSGj9z/gIjj/CcsRa3jFyh71fbDy/KHd18ra
         At1ulaLaenUbhRIrkXzgC6FasYj1NEM/lwgBtIPDriwhTShu9ra5o2lQLhjN1YNPRmmz
         rADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BTixdK0PppQ0GXXSyZHvwqDVSiAMbWPqf47i8YZpbwQ=;
        b=dodeQO2yczHE+ubZ4XnRddNN+K1iBAYlbtGqCQqZi1aMVliW6txK2mR6PlNF6WsxXy
         MeZm2Rjc1iR5bkwlyyrgIxTwWqo7muj3cIFOCU3uYtNZUYduzFAjxbZfcYPqKty9WOFT
         OyM5uokFPzad8c23DrNm4qsxto8eXzjJ1in3kSpyl5Lnkkar4Zji33riY9iMj6h2fk2I
         c4m2nXrqakeo6sXnYn1qlxx/s4/xWFwkdnNuKdbLh53enqQljoJGD5M+f24GkreOy/AJ
         PQuODP+Ojs2OpAadKXx83Xlws6JpRfoLIE0PwE2DSFQsbgq2zvyoyYbcPzxnrAnERkjp
         rx8A==
X-Gm-Message-State: AOAM531usN8gX0e5NlRdyvHIYWzL5F4Sdwlv1d6bGQ+xEjhX5j2LWu60
        FrkauVTKFycBroe0qUfYWHQuZAkIBjIKbTad
X-Google-Smtp-Source: ABdhPJw52SObJLBYlzsnjKBtYZed+TDnd3/Evk+ns4qHpwwcXW8888pQ4f2lq5xmH2PhyEC/L4rNJQ==
X-Received: by 2002:a17:902:a3c8:: with SMTP id q8mr8899726plb.20.1643380778000;
        Fri, 28 Jan 2022 06:39:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p22sm10075540pfo.163.2022.01.28.06.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:39:37 -0800 (PST)
Message-ID: <61f40029.1c69fb81.20915.ac7d@mx.google.com>
Date:   Fri, 28 Jan 2022 06:39:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.174-12-gf9e7ae34555f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 144 runs,
 4 regressions (v5.4.174-12-gf9e7ae34555f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 144 runs, 4 regressions (v5.4.174-12-gf9e7ae3=
4555f)

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
el/v5.4.174-12-gf9e7ae34555f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.174-12-gf9e7ae34555f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9e7ae34555ff62e17a8d510cd1142529ccd56f5 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f3ca3eff8b8d8d9cabbd38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gf9e7ae34555f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gf9e7ae34555f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f3ca3eff8b8d8d9cabb=
d39
        failing since 43 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f3ca52facb3a212babbd2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gf9e7ae34555f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gf9e7ae34555f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f3ca52facb3a212babb=
d2e
        failing since 43 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f3ca3ffacb3a212babbd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gf9e7ae34555f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gf9e7ae34555f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f3ca3ffacb3a212babb=
d20
        failing since 43 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f3ca5343783ea044abbda1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gf9e7ae34555f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gf9e7ae34555f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f3ca5343783ea044abb=
da2
        failing since 43 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
