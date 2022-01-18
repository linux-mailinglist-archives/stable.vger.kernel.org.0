Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA82492C09
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 18:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiARRMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 12:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347063AbiARRMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 12:12:07 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969C9C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 09:12:07 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 78so13582932pfu.10
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 09:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k63pEZo0ci1N5H31NpFJo99IZaL3mG2TNwuFUEvbX94=;
        b=XwdyIK0/Z4jcP2b8wSOvYIlD2dWU0JmYxAioLxYgtVPmrR8XRn7rTE3zM8sF1Hjgob
         IKrFBJmPmW0CuzozFFQw35X5j35A5D2ECw3pAjHevBmFOlESu1WD2Xv7tWqyL20ifBy5
         Sf4ANnq1VduIyMvOtV/IvdOImoFRNVakrsL9nS2EGZiiByebOS3ei3Av6VTXYHvrErxf
         aBwTE4rDMzkVDWVHfXwjrM/Ff7FUIZJliHTIoaicx8T7sHMSWhy6zyu1RkRAccSDDYvQ
         nKbQweJRRrFsoIprrJrGhs7hCMEmm81MZr5s0HcrDP3jax/iYPf5wrR1Ud6d3/ddIt/0
         mBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k63pEZo0ci1N5H31NpFJo99IZaL3mG2TNwuFUEvbX94=;
        b=r1C0cUbBdBEytwYoZlzvZSBjMBYLXhEvsHIoOQCqi15UbCEYfKYnqrulvJ+eGEnX0c
         LJq+naMt1t0gi7NMO5Qlot1JQND5KM/KMPcI2fX8jW8JGyxyP1mDCkO6I/Q5haDaKM1e
         OdWECsRCZIa4cjHAS+qUaM2yMSYi7HusRDXkj9jI26/nyTKONthsZeSKggSYVQ2CmhwP
         nXzzvzvBkP5UwSEuT+N5Xgmciw4vPzPv37y6RwaH4ztkot0z0ceaX07iIBJ/ZSaATGVN
         qw6rC579aa8SwpkhO6He6jo5ILTkLVdhURVr1Zbl/TgiNSg4O0Te0hkop6SJ0lPvD716
         H6Mw==
X-Gm-Message-State: AOAM532PUsJdMbiy/byzdyLbzPtl8rXoNVWfBFQeOdvptYAeu8+BMDo7
        UT+4WnbwqYR1NlJ4q/lRB0cfadkvsxZ6vtSA
X-Google-Smtp-Source: ABdhPJzssTXOkGOL1bDsaOpHqneFAi3KS9YWhvnrs8lN6hqcswF7+8nDn+iqHGuI8ga15arJOsissA==
X-Received: by 2002:a05:6a00:2408:b0:4c1:e1a1:770 with SMTP id z8-20020a056a00240800b004c1e1a10770mr26220974pfh.70.1642525926975;
        Tue, 18 Jan 2022 09:12:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm18919862pfi.154.2022.01.18.09.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 09:12:06 -0800 (PST)
Message-ID: <61e6f4e6.1c69fb81.73962.1835@mx.google.com>
Date:   Tue, 18 Jan 2022 09:12:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-12-g2fd461e2108a
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 134 runs,
 1 regressions (v4.9.297-12-g2fd461e2108a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 134 runs, 1 regressions (v4.9.297-12-g2fd461e=
2108a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-12-g2fd461e2108a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-12-g2fd461e2108a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2fd461e2108ad0c3bcc375766989b6c330293046 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e6c0c0fe610194b8ef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
2-g2fd461e2108a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
2-g2fd461e2108a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e6c0c1fe61019=
4b8ef6740
        failing since 0 day (last pass: v4.9.297-10-gfdec8da75479, first fa=
il: v4.9.297-10-gece287e6caf0)
        2 lines

    2022-01-18T13:29:22.264002  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2022-01-18T13:29:22.273018  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-18T13:29:22.291748  [   20.577545] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
