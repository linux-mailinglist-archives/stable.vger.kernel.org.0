Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B5D456602
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 00:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhKRXFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 18:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbhKRXFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 18:05:40 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F5BC061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 15:02:39 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so9519939pja.1
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 15:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TZfREpWFxbzfQOU3JFwTitWrnQiqb45RF33KvCEp9D8=;
        b=4xZ1Vgf/jvbjcU+/TeWatwWRM+tBYg/SD3IQtC0OEddCq+Rhg0reafpeTGkhexxxsl
         mETxnFhm1sQFhb77cDwaD5BQRTXEu6ZFK32mB6WLAQrx2ScYPRVAOzZHuvVIEfYkxTEL
         w75bVaJkAxTVcImQY3NGWp/jxoR+YQPRWV0gh3Sa9HD7PxnN3vqOHDK1O68gQPIP3HKZ
         gzLBJTPfzxCJnGCVgo2+nY2YBV1ZeSzNgpu/S6AvA7+NgcoIWlHQmlalF+fpCRENDwNk
         J+299+WHoEk/9ytxJ+ftrcDUoYY89Ji6PX5p+jXSkdJES1F5UABqvrbd8GKdNSSM20Vp
         nkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TZfREpWFxbzfQOU3JFwTitWrnQiqb45RF33KvCEp9D8=;
        b=67CnFsHv8sNRiZbgdRHvhbQjFjVAUPSUnKa7Y37aDP4eVWu+5wfORijzriduP+RSi2
         oL9BonhObVm++xq0eaQ5fszEYb1t84hlzKk7nhFzhiPrbwoXUpSE6IFTULzlSRtO0Yrq
         ejXVmaK79/hWcMjA5UTHfXXsVkM0eNH1jzJwKavmAIy4eeqlUczo1mAcZFpubwHB022k
         iv+KlnN6EStrF0EyRhprzfCHtp2tdLO81RKBYDAGr5ePfa+uhR8MxgrOc+EAyel0iOd+
         /kcAL7N0dPPZmjIxfdJOQh2aJY3rMC8uMv4iw5rCfuJLYp71CPZL11iVk69zZE/zYqS6
         a3/w==
X-Gm-Message-State: AOAM532Q393QSMBKSKJzYk0db9VxDK0TLHYaWQjB+gbjrTg6p8YYKOQp
        c6B73ANL6dvQMYHkZwOcr3MFGY9SeVgprYhp
X-Google-Smtp-Source: ABdhPJzJ4vdnWLiYWYnylFO0DKeezlUfWdLoYo6OgnYj4tNviujY9GbuK2TaoVuyCkttUVjv7S2EwA==
X-Received: by 2002:a17:903:1208:b0:143:e4e9:4ce3 with SMTP id l8-20020a170903120800b00143e4e94ce3mr18948010plh.21.1637276559001;
        Thu, 18 Nov 2021 15:02:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w187sm616135pfd.119.2021.11.18.15.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 15:02:38 -0800 (PST)
Message-ID: <6196db8e.1c69fb81.96b64.3168@mx.google.com>
Date:   Thu, 18 Nov 2021 15:02:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.217-251-gd104c0a7fd2c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 136 runs,
 1 regressions (v4.19.217-251-gd104c0a7fd2c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 136 runs, 1 regressions (v4.19.217-251-gd104=
c0a7fd2c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-251-gd104c0a7fd2c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-251-gd104c0a7fd2c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d104c0a7fd2ca12da34e38b70edb8f636379c64c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6196a13f9ef69e154fe551c7

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-gd104c0a7fd2c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-gd104c0a7fd2c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6196a13f9ef69e1=
54fe551cd
        new failure (last pass: v4.19.217-251-gdb8a90cbc48f)
        2 lines

    2021-11-18T18:53:35.565260  <8>[   21.103302] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-18T18:53:35.610208  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2021-11-18T18:53:35.619193  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
