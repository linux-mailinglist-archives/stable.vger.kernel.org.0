Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91ABF478152
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 01:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhLQAcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 19:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhLQAcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 19:32:05 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D52C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 16:32:05 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id l18so533500pgj.9
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 16:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wYJ7W+r9FfERqynLCcgDGb3xMSpMsPJJiD/rv4PrxQc=;
        b=eN5mYCB75tiz6eS8swav71f8J6Sc9uKeRfEBwORdBxDNOOd70j3RVSya8MMmWYNhZh
         IGyp6Lcfl0FB9oRm1Nca4Fmllj5ss3zLvzPnCh/1iZ8QTPPyp8iLr7yxtRp/OjtJiIZw
         M0MLNxii6YM/ax9AbeYblLSl5bwH3vPYPkLhoqI4vaKf2GWr+MKzvxHi4SvQMOgC1EZz
         vZcMNY/dQQl1RfD+NbAXhIQUCUh0stEsOgg255SOjYc7H8vAUYbpLOiuqEtbfOVCoWT5
         t3fzholDjqTquOBVm8gLyovoo8PGkMkQ1WXDlhzhbPdakwn3aorVRm+Jigyx5q/L6Wzg
         s2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wYJ7W+r9FfERqynLCcgDGb3xMSpMsPJJiD/rv4PrxQc=;
        b=n2tDp0Wq7HvOCD1agCbLTdNG5hZW0+wlyCro0Sq3LQYTnSlvUupjFSN6iq/SLFt3gv
         BPUl9WkixuehxgYDIa+fGSiyEL5+BBcP6nDDeaPfzmP/uRXrhJ+n0Km9696bkyRmMdJy
         dN96CE0yJcjE9NJ9pu5Gebf/5JWZzF86ewoycolVOdFa79Hl+eWatROPYKKdQM9cu/XY
         vJVwsmBtPngKqdNl/5wQS6sg8WuwNGu3793o+sM+RIJ0wL+3ofBwfPgiPyVjSqq3CyyX
         HbOgGALcmIltaLRPYykhzJamHRVRHooxhTwMbraxnwqfnaKTJ2sgiffuDKJDCXrh+AG0
         WGAg==
X-Gm-Message-State: AOAM5309JonwncmXhc9Qk1j0RTwSaBRrJcQi6l7l0/29jXw92qTZGnbN
        CRnk1Ue0WBGuPXrdrVzqg/tGV4vMeibQytnK
X-Google-Smtp-Source: ABdhPJx2lmUthFnW5ynC5RRDDVP3OM1U7cCnbwCmyyDq2vLfUxrh4MOOREE+OPGS/kpCHFyJgF8SdQ==
X-Received: by 2002:a63:8442:: with SMTP id k63mr592844pgd.543.1639701124950;
        Thu, 16 Dec 2021 16:32:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21sm7229510pfc.191.2021.12.16.16.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 16:32:04 -0800 (PST)
Message-ID: <61bbda84.1c69fb81.94841.47af@mx.google.com>
Date:   Thu, 16 Dec 2021 16:32:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.165-19-ga0fc6495a990
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 160 runs,
 5 regressions (v5.4.165-19-ga0fc6495a990)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 160 runs, 5 regressions (v5.4.165-19-ga0fc649=
5a990)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.165-19-ga0fc6495a990/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.165-19-ga0fc6495a990
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0fc6495a990ea7a7b336d9ed6be47a158c66fca =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bba28fd0fd62569a397121

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bba28fd0fd62569a397=
122
        failing since 0 day (last pass: v5.4.165-9-g27d736c7bdee, first fai=
l: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61bba524a42a766b61397167

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bba524a42a766b61397=
168
        failing since 0 day (last pass: v5.4.165-9-g27d736c7bdee, first fai=
l: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61bba53a7c7293836f39713c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bba53a7c7293836f397=
13d
        failing since 0 day (last pass: v5.4.165-9-g27d736c7bdee, first fai=
l: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61bba561a0d9369a45397139

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bba561a0d9369a45397=
13a
        failing since 0 day (last pass: v5.4.165-9-g27d736c7bdee, first fai=
l: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61bba53b031cd2ff26397149

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
9-ga0fc6495a990/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bba53b031cd2ff26397=
14a
        failing since 0 day (last pass: v5.4.165-9-g27d736c7bdee, first fai=
l: v5.4.165-18-ge938927511cb) =

 =20
