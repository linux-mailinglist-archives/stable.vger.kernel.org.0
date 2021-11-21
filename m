Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0D04583EE
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 14:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbhKUN6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 08:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbhKUN6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 08:58:21 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3438BC061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 05:55:17 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y8so11875078plg.1
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 05:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KmSY8ek7db6eydUKlLeOC1veO7P46oQ/xfkaKm2Co/A=;
        b=wYX7jzoGuEko/9HqTiVYhkbiDivn1VD71soCjFZuD+OTvw3pn3j+Afjd0dp3J7vnLz
         yBMmgrjRSMJ4IsgARRACyfvlXfqcyb88pFC4xzieB1GmTlNtbzwXn6yhf/JI4FNzd2v3
         m4+tG43pm3DHohoyIz0LpemotBRX4nL1NYB0gCkO0Y3DbDbFHUvSaj6Ojpn5lGyTRI04
         y9PxdqSZKP1OWTy76zdc8tI1xnpFB7EHtCKfsihLf6aiePt/loDtF6sLlRqtuSvARXD4
         n7K+RV1xxewRmQsK3lDGsKt5tuDOd+Kpzbk1C11HxkbxLQ9aILxlggTnIZQQZe+xnGQU
         Zh0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KmSY8ek7db6eydUKlLeOC1veO7P46oQ/xfkaKm2Co/A=;
        b=5BU88hzAVQo5N0dfmKZFstrQfUZYsdCG9LIXBlrW8ntozGUTsPYyc25+2zHo5Z3HIf
         qo/TdcHRXq2JvF6zx3Nviwlh5ZqG8Y0UrOdR9gPVBxJaPkBooAV/XKo0iHQ5BErwPnSq
         klFPMWzmrttR87Ee5Gqu9vHHHuJONcqC07teGDvf2L1+cV9Ps0R7QttAQed1eKiKSYAV
         epEDVMTBSOS3EWk29sfla3JuX3h4NUvdGLrTNY76JUnnOWmJireOewqzrqoNRh2lg/IE
         0krPMcrDUmW595coMWxSJdbxdmUK7gT7Xa7pnTxXyFaS9S8R99Eg/k4F5Bnux19jFNYe
         NnHQ==
X-Gm-Message-State: AOAM532oMkeOqKqjvKSsUka73E9kAqlTvYwM1M3XJQajHnNeY8mVTMx1
        KZH4iAHwo8c/CjaBPtA8ubJ92KQQqv9YT5PD
X-Google-Smtp-Source: ABdhPJyN4xhkSl5Fu6peEomvyvfMinwMOeR7tbV5NZoVXeROsZBKoTyam1Yybbzs3hA99JN8m41X8g==
X-Received: by 2002:a17:90b:38c4:: with SMTP id nn4mr21570654pjb.26.1637502916689;
        Sun, 21 Nov 2021 05:55:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq14sm17296287pjb.54.2021.11.21.05.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 05:55:16 -0800 (PST)
Message-ID: <619a4fc4.1c69fb81.53436.2151@mx.google.com>
Date:   Sun, 21 Nov 2021 05:55:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.255-201-gd07d109b2abf
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 141 runs,
 1 regressions (v4.14.255-201-gd07d109b2abf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 141 runs, 1 regressions (v4.14.255-201-gd07d=
109b2abf)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-201-gd07d109b2abf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-201-gd07d109b2abf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d07d109b2abf36b427f1fda5608594372fd00084 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619a1958c042e01888e551ed

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-201-gd07d109b2abf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-201-gd07d109b2abf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619a1958c042e01=
888e551f3
        failing since 2 days (last pass: v4.14.255-198-g2f5db329fc88, first=
 fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-21T10:02:45.363593  [   20.304718] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-21T10:02:45.405503  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:1/19
    2021-11-21T10:02:45.415544  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
