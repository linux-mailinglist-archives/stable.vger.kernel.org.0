Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DC844732C
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 15:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhKGOEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 09:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhKGOEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 09:04:24 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD847C061570
        for <stable@vger.kernel.org>; Sun,  7 Nov 2021 06:01:38 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id x16-20020a17090a789000b001a69735b339so6793201pjk.5
        for <stable@vger.kernel.org>; Sun, 07 Nov 2021 06:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uq+2FeP4RUpquEiK0s/YNPllvtomAhEcLZzs+mOIFvQ=;
        b=RVd1OgCtFvVi1y5AIJVrp3gbCTWiJUUmnka6Qb3NsC/pKX+v+L8MxU6JynzBK/R3qw
         6cFb7fAu3qZEmg5zpqHPLrGGhaFFlyarYb/dAH7G+BhUfmHocy/Php5IcfhBibr8XUPe
         Znyaepyfj2TyPxF0mXgWMAAsRNGPyMAT/RYhAFCCcf4GBeph1y76qduXOXoQZLJim5DB
         AmvCM17RC8r5rm32Q8n1Pmzi1Vsr0WVyDyPNdCd2wCDEP41Kx+8r09GwALESUHIV3CAT
         YgDA4NKvoplefBPh1cwB7bxsZObHjbcOhw46UOV7pPoIiY08yeOmFpQdMA56AO+oMXyr
         dQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uq+2FeP4RUpquEiK0s/YNPllvtomAhEcLZzs+mOIFvQ=;
        b=HGh/q3u70VeYLIIMfDL8XwHR7ShGzOdt3ynO7EUK8peK+3ISuEGSMYrQzEsvm0z7+4
         mQLwUs+2gb88aJMJ4S1Uubbkhzj6EJuDL0hinAOJJ3cHayoqUNy90mx9Lwp76aHkhEW3
         2m0gYajKqta8cIqVogQTAd2yGaq6ODjCf5pvw4C9PC+kPAjM6KACYt/7FEfPZN4L8/MR
         ARPBineN3fhSp1F18Miy0NefcGcLrmFPiYSkFrtlA5Mp4ddGO7FKZxpJxI7kjpBhDsfx
         H7R/0jCEMtEqOWmPixf+NXZAgxgKid4icxrtFVWflfQh8lJww1ryRZ60dHMX6G0T+/zY
         c8rA==
X-Gm-Message-State: AOAM532hyp/vq06JliT/VtcOf0WrJv06Doo4UsHoI995YSuInn+KPZrA
        RbuzPX0qGeAECowxnj8r27o72pJIwIXIlt1d
X-Google-Smtp-Source: ABdhPJwb9w0fcA7RnmlqNd0+pLjHxYdpF96taXitAx+SWzNjnXZx16GxUqOHGnTy3p4+YPq5Vasf+g==
X-Received: by 2002:a17:90a:6542:: with SMTP id f2mr43701497pjs.159.1636293698113;
        Sun, 07 Nov 2021 06:01:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 32sm4880321pgn.31.2021.11.07.06.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 06:01:37 -0800 (PST)
Message-ID: <6187dc41.1c69fb81.38618.e43e@mx.google.com>
Date:   Sun, 07 Nov 2021 06:01:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 131 runs, 1 regressions (v4.4.291)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 131 runs, 1 regressions (v4.4.291)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.291/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.291
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0018f4c9325b36ae75a591d54879bf9a9f41a26 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6181a5125f0eabd8f53358ff

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.291=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.291=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6181a5125f0eabd=
8f5335902
        failing since 2 days (last pass: v4.4.291, first fail: v4.4.291-3-g=
59c6c12a4647)
        2 lines

    2021-11-07T09:48:03.921995  [   18.993560] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-07T09:48:03.970141  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-11-07T09:48:03.979048  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
