Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7DA45E033
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 19:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348381AbhKYSIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 13:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355670AbhKYSGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 13:06:41 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B767C061397
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:58:33 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k4so5048115plx.8
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=seDJKCLMvTgABvhjGIdBJzld2hgNHKq2U5wQEIZdj0U=;
        b=wYfeeTo1/ipkes91kGGElYLdCqowwWCrA8FE+zmIqulOctblROV7HCjIx/Mbzh8+Ux
         UnaYNmmusboENdYbKWhFpW/kJJcWP3+7bLA0YzfJdHTJs+s/lxvx9sXXvCn8Z7s/Vmuq
         UorIOftGKG7XVJ5dffelXRBnf7lWMatBAAPoHKWciYpWLWiZaNoOOZdbjmXTyW6FHpm2
         57VYUtSStC4bUxSl2Hx0Z9GHGO4op7N17U7dv0SrbGLW9bQcWEkrT6EHrr62SL3cuudf
         fIMOR3tjMp03kGB3rafKrnvbl7Zaoc+V84OM/jhpLfvvex/4th8CU5uYrxB4jKIfbGtv
         dAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=seDJKCLMvTgABvhjGIdBJzld2hgNHKq2U5wQEIZdj0U=;
        b=fNjR0YamElgjlFUIix4ZhUQ/CA5XKpOcsNcSCWCW3CyaxNLLQc5oGGWCqYZKBGZkzX
         mDR0WMn6fVhwGv98vbF3WM8b+f0+2Zm1mm6plQvL3r0q4u5VEG/n2tE+Yy6GDgzGFpRT
         D4VR+vHwe+nFlsYd1Y7xsN6JAX1w5CAfmStECzO7R/6JxuYOc7Ps2Wlc3mkAunQzOXmr
         9jUPJq2H+emLUZHnjgvAhIBDwJxZ2Z1I+yNE26zzKo9iX/1beMh1B1oeTPm95M1Nd23Y
         Wce6Nd743VE25okQUSFcL7HDb9CNDdDO17iHCrqkgO72jGUcie3j5bMG9s1QqI9/NBmO
         Taqw==
X-Gm-Message-State: AOAM532JliHM+wD38k8qITsR1qiQ/+OVgAjCZV6OQlmTX26GdgXw5SuI
        zkLILT7cfTGJOpYRmAshheQ6CmoIHibWvF4baKM=
X-Google-Smtp-Source: ABdhPJyGAyO20ebnsPjPNFBy4O+ihx0xQmRI44+fkLA2RcRq1oarkcwsBAmkeXlfMscYsgvhkEwjiA==
X-Received: by 2002:a17:903:2291:b0:142:b53:6e08 with SMTP id b17-20020a170903229100b001420b536e08mr32412675plh.10.1637863112391;
        Thu, 25 Nov 2021 09:58:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14sm2812491pgl.13.2021.11.25.09.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 09:58:31 -0800 (PST)
Message-ID: <619fcec7.1c69fb81.64d3d.778c@mx.google.com>
Date:   Thu, 25 Nov 2021 09:58:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-250-g0b1b1688e7ac
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 111 runs,
 2 regressions (v4.14.255-250-g0b1b1688e7ac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 111 runs, 2 regressions (v4.14.255-250-g0b1b=
1688e7ac)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-250-g0b1b1688e7ac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-250-g0b1b1688e7ac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b1b1688e7ac96077b499e859ea5d436b2a13102 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/619f9626fdeaac4565f2efa9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-250-g0b1b1688e7ac/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-250-g0b1b1688e7ac/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619f9626fdeaac4=
565f2efac
        new failure (last pass: v4.14.255-248-g646bcac5a19c)
        2 lines

    2021-11-25T13:56:40.457496  [   19.689056] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T13:56:40.498238  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2021-11-25T13:56:40.507294  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-25T13:56:40.521230  [   19.753356] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/619f95af7e26957678f2efbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-250-g0b1b1688e7ac/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-250-g0b1b1688e7ac/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f95af7e26957678f2e=
fbd
        new failure (last pass: v4.14.255-248-g646bcac5a19c) =

 =20
