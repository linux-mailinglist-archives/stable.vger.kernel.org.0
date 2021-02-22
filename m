Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1CD322272
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 23:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhBVW6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 17:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbhBVW6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 17:58:16 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A499C061786
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 14:57:36 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z6so7579864pfq.0
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 14:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O8NmRdmcSXacqwnLaDfYq+GO5nPXYy4tcceYG8XEToM=;
        b=elgWzQ7zDOD5e7Y3jpnfOlo88CL69bJML6ERavNg4w5Ur9gMhQRj52gvt9OsNRc14P
         LuJjsqN4VB0rt7rToBiP1bBR0jw37eZOoR+Uu8IGh9xCrShOXlT2KwEIX7P0nhXXCWyF
         fYIosEjcoVIkEAjFdvSY3/rfdG6ewnKHoJJp/v1mNxMsGiewIEcTdApI/kRKlStYi3dC
         eIKItrE96sgtIob4ORo5ju2maa48cQZW6+uV/ofTonFpbEf7KMFjxokXy5+Qw6yPQhs3
         KyfZPyY6JKMLfC4RA0JxBXYuQNwb+w8nXz+e/Sxve5C3m6O2J6YHHXna72KILo0Ht9Vg
         gfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O8NmRdmcSXacqwnLaDfYq+GO5nPXYy4tcceYG8XEToM=;
        b=hsGxN1zZmfHc8ZdtPYZZXqV79H31WkWyi/3a8KzlfZ2VafGMHkeCFhCGaSPRELBONG
         NPrbZeupDd/goHe9Cp/nSFQE5a2mMdXBKDG+W/KftPorB0IKUw4t/rzhZHHMV/XThztg
         rJr4Lf8PyAewPYSahFgpbGuN68J7uvYJ40M6vsyhQ30AsHVybpLwPorio3bYHkCiAx9o
         mjpZ663knXKd4gz9Oppk/zQ+bLBUSYQSmN35tHgm5NJ8YMlgOg41xM3r14jhQlM4v6PO
         Mp/qkxb+Sav2E5pVBqtI5Z7aEWvy9yjBL/eQJo/8mooDrNk+tTSi/Pm+ewnxudQkihCv
         MDqw==
X-Gm-Message-State: AOAM532vvuFxFvb0Ua8geavdaMu3f/z/DxrMDX2XRF+fvKD3CA+b9qdk
        QxXSHwWVagWCkwrJ1blNzzEqsh7NORm8Pw==
X-Google-Smtp-Source: ABdhPJyDb1B7zzgZaat5Wdwf9qZA+pg5hPC1v+xiiCXtzJihetSedVNIE/eCoexrTCmjzrqL3EmI3w==
X-Received: by 2002:a63:4d52:: with SMTP id n18mr21179306pgl.237.1614034655922;
        Mon, 22 Feb 2021 14:57:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g8sm4246947pfu.13.2021.02.22.14.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 14:57:35 -0800 (PST)
Message-ID: <603436df.1c69fb81.de3aa.8de0@mx.google.com>
Date:   Mon, 22 Feb 2021 14:57:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17-30-g905cc0ddef721
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 103 runs,
 2 regressions (v5.10.17-30-g905cc0ddef721)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 103 runs, 2 regressions (v5.10.17-30-g905c=
c0ddef721)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.17-30-g905cc0ddef721/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.17-30-g905cc0ddef721
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      905cc0ddef721db27341d7ca4f85bbcd82bbb6e1 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/60340517fb033d68e2addcbc

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
7-30-g905cc0ddef721/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
7-30-g905cc0ddef721/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60340517fb033d6=
8e2addcc0
        failing since 4 days (last pass: v5.10.16-17-g91ae446e84dab, first =
fail: v5.10.17)
        4 lines

    2021-02-22 19:25:00.514000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address ebd267a8
    2021-02-22 19:25:00.514000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-02-22 19:25:00.515000+00:00  kern  :a<8>[   39.686300] <LAVA_SIGNA=
L_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-02-22 19:25:00.515000+00:00  lert : [ebd267a8] *pgd=3D3bc1141e(bad=
)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60340517fb033d6=
8e2addcc1
        failing since 4 days (last pass: v5.10.16-17-g91ae446e84dab, first =
fail: v5.10.17)
        20 lines

    2021-02-22 19:25:00.566000+00:00  kern  :emerg : Process kworker/3:2 (p=
id: 80, stack limit =3D 0x(ptrval))
    2021-02-22 19:25:00.566000+00:00  kern  :emerg : Stack: (0x<8>[   39.73=
1959] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D20>
    2021-02-22 19:25:00.567000+00:00  c3691f10 to 0xc3692000)
    2021-02-22 19:25:00.567000+00:00  kern  :e<8>[   39.743340] <LAVA_SIGNA=
L_ENDRUN 0_dmesg 747955_1.5.2.4.1>
    2021-02-22 19:25:00.567000+00:00  merg : 1f00:                         =
            c3ac79a0 c322a680 ef7d2200 c0360874   =

 =20
