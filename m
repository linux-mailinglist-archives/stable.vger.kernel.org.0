Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2406453BAD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 22:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhKPVfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 16:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhKPVfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 16:35:53 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CBAC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 13:32:56 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id r130so637167pfc.1
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 13:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LRl70Npmvv7hoEA2ePukR2pxzNRzUXzOPLgEJjBHEog=;
        b=wEuMgNdlDL6C5a0Axubx/T7+2GbDZINIbtT4YCcQe1Sb1rmWZM54oUQvx61cCSEM6F
         ZvWnBqGNov35hGZw+ltKZIEIwmjprkISp6JTkcVZUE5f/rgG6noOCwlu1p4RdvNHo1C8
         BB9YIbdZSu3G0c0ejBHf1IXNPoNaNGSh0Tbm6B9M8uAfnL6c+b9+xLdrroUWQuf+rhLx
         +S+DQg/OTK0GeMByZmRO1MBCrbgH8ATcxROAyAMf041UbG2hAjeir4fvCXRcqy7chyJX
         bIDZfgjuC0AHewQOMrIEZvVUlh1kjh7/Krga5yu47AIe/Kqa0kg/HELFyV9L2xOhyd7W
         wzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LRl70Npmvv7hoEA2ePukR2pxzNRzUXzOPLgEJjBHEog=;
        b=DxtCp/Q//mD9yAxL8VwGpwKwjuS/4F76aVPx/Uj8JX0CwQkfiUCHER1B0/Km3cyqrH
         l8QrT6fHxP2c13BbB/FNPOJ4/hhPiEEngOBOn344pMd6d9G47wNBEkGwRs272fBqRT8D
         WAswEjuh5aQidEjqCXL5pjsp0fb783Vrgu5Pgu0GEJVT+JWzkl3FSZOpAEWRrKPheIna
         m+sWOn5pfE9YxqzhS6AlSwcVRg8NtFg/T/vN6COLXWTIit6r8xZW1pzea7Xazyt0X6gW
         NeVkBCrHSRn67q65ADHw/mw3aFwQpUh050jKl6q/bW4t+yO48DxS6f7JBuU9GbemuudG
         0NJg==
X-Gm-Message-State: AOAM530AAmz4mjxMCDfDRx58KYXkBrs9lw2qlNK2yaEKpm2Spj30D3BV
        OWZN5i04V/07ET5oZtVv2kkTiSOWPpDcPyKk
X-Google-Smtp-Source: ABdhPJy+S61cg/DCEwNbuuxjqqBt6M7ULp5+eZegvCNBvI4RLiPkAItBukR762BHx/EKvg19ksnhWw==
X-Received: by 2002:a63:2b48:: with SMTP id r69mr1507302pgr.421.1637098375782;
        Tue, 16 Nov 2021 13:32:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7sm3179698pjs.45.2021.11.16.13.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 13:32:55 -0800 (PST)
Message-ID: <61942387.1c69fb81.b5a7b.9dc6@mx.google.com>
Date:   Tue, 16 Nov 2021 13:32:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-114-g1e22bc7dab47
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 84 runs,
 2 regressions (v4.4.292-114-g1e22bc7dab47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 84 runs, 2 regressions (v4.4.292-114-g1e22b=
c7dab47)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.292-114-g1e22bc7dab47/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.292-114-g1e22bc7dab47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e22bc7dab47db44ec665730b5ffe2e15cf2d7a9 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/6193e9d00ee85d82a03358e2

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-114-g1e22bc7dab47/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-114-g1e22bc7dab47/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6193e9d00ee85d8=
2a03358e5
        failing since 0 day (last pass: v4.4.292-36-g43195d0a7bf0, first fa=
il: v4.4.292-114-g4dc964d8b18be)
        2 lines

    2021-11-16T17:26:15.866226  [   19.462097] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-16T17:26:15.909299  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2021-11-16T17:26:15.918322  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/6193e8addb19ec457f335964

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-114-g1e22bc7dab47/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-114-g1e22bc7dab47/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193e8addb19ec457f335=
965
        new failure (last pass: v4.4.292-114-g4dc964d8b18be) =

 =20
