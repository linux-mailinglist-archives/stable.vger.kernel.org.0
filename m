Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E8E4A55A9
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 04:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiBADgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 22:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiBADgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 22:36:21 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960B3C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 19:36:21 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id v3so14151665pgc.1
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 19:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N9zgaoFPmRbdEkj7M4LQUqX6b+k8APiHKyZLTtCCVgQ=;
        b=BJPML+G1tsN4J3vZ5nEGeY7uaNmycaz1nyxyOBpzWR5fK8gowb+DFW7hHZUatRGBKd
         nvtC28b3QeGPKFCwWv+ueIfMkHy1F7Eb5U/ELNp+CVLXak624wtNWBo74tnQJV6+t+Rc
         qBbPCpGm9jqoENbjkme78hGL+zyqAdU0wM1uAoQop0J8lU+8l2ryvfoKpd6BUDn6a2UA
         ARVxyt6mQeHzWn4Sh6D4lrh1/sBzTkLtduvDMPfCEViBrpzxdcL1FmJb6085WkgxtiY3
         VEdsBRad0dI2B/S/T1dkG15WRHXlKt+6ZEIoAaeaxIx4ONK2NhUPpOtuH7XMoT/zE6LP
         S4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N9zgaoFPmRbdEkj7M4LQUqX6b+k8APiHKyZLTtCCVgQ=;
        b=SvY/JNu7kuKSPN71j/02voIgXVDHZGUYHQjng4iPq8AH1tze512MpiszR5mF5DSW6p
         1uSEkuSI/JUbg8DuoKOWilSbKEnU6abkFM8xuKOOIaHSVjYCIe5nS0S0pvwrKbwCyR9+
         beByzu5ZgwCXz5F4XL2T5NeEroD3Omzoug6sg5VKAJ6s/eoc4iQc8tbXz/Fmizq4aLJX
         drETxlrrusqQ8PiXH8lK6A7Sen6nxVK993lymeZdxVjfa45bYXRcaegVUNXlKXbaxxKZ
         1XPsejakAXyFnAJO9ieXT3ky00bT6fmcRyXUymXvfWBuaBDQ9JDWxBAo/8qqWJw8LRTQ
         VyZw==
X-Gm-Message-State: AOAM530zIrdByaYU0j/8Moa1FjkbS8XJXB2Vey/YDytrU2d8HmDyGDcz
        lhM4l5oJvxYqh5p2T2hHafxPQLq4MFROC//K
X-Google-Smtp-Source: ABdhPJylP/ckZI9BdfnCdDpzuXn5x7ok9T/5ERFz9v2ICMq9e96ikFhrMB94tlKIejDg+O+JHyI09w==
X-Received: by 2002:a05:6a00:198f:: with SMTP id d15mr23322580pfl.78.1643686580982;
        Mon, 31 Jan 2022 19:36:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nm14sm719992pjb.32.2022.01.31.19.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 19:36:20 -0800 (PST)
Message-ID: <61f8aab4.1c69fb81.95d52.3419@mx.google.com>
Date:   Mon, 31 Jan 2022 19:36:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227-47-g86004a50cfe5
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 112 runs,
 2 regressions (v4.19.227-47-g86004a50cfe5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 112 runs, 2 regressions (v4.19.227-47-g860=
04a50cfe5)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.227-47-g86004a50cfe5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.227-47-g86004a50cfe5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86004a50cfe5e3f87958e466be900c5dc2b8b272 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61f8739ef982b736415d6eed

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27-47-g86004a50cfe5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27-47-g86004a50cfe5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f8739ef982b73=
6415d6ef3
        failing since 0 day (last pass: v4.19.227, first fail: v4.19.227-47=
-g0366c2cb37a1)
        2 lines

    2022-01-31T23:40:55.499153  <8>[   21.350891] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-31T23:40:55.544628  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2022-01-31T23:40:55.553619  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61f876be6078fdc81e5d6f0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27-47-g86004a50cfe5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/b=
aseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27-47-g86004a50cfe5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/b=
aseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f876be6078fdc81e5d6=
f0f
        new failure (last pass: v4.19.227-47-g0366c2cb37a1) =

 =20
