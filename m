Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0842E2A069D
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 14:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgJ3NkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 09:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgJ3NkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 09:40:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C95C0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 06:40:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g12so5219351pgm.8
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 06:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K507i6YpLgsPsc9E0ixbTLMS/tJLr8s5x2QMSyIvE7c=;
        b=Y4QDB3cGZV2/skFWLHT0W1Mpn2kXAXkFZM+J0lPYwb4qjddoukClPYwhflV/j2gpfw
         +zq7OALWV6l2mWcvWUnJCS4topol6Obd0D8pVBL7X9RrtS53VaCEYoGgTbAmJB00CvjA
         jSXbzwYERrR6/+0u+19Tdg3R8vlznKEdv0tdutxyG7whxRYDKfi8XVhSO+U3HFqdCCCK
         gBlUo+OCuqQuAoKvBrYsyF7PlXAe+ArkyKQvLQaec0aiyE3oLaD5G4xhEanIqwkptVfL
         Kk11KSlKY4gUDXaiFGhuHCxHrwpuk1JgJClAkp/0xPE3BLpwNNSTx1bUh4hBo5t9fP/+
         8/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K507i6YpLgsPsc9E0ixbTLMS/tJLr8s5x2QMSyIvE7c=;
        b=M8zG+MNjmlLqd+7U5Qc2u+gUnSGV9Fy0l6Wia7Vwe9LQgPtQJQWLNy485/5OfmVQCT
         pfUySZWxAUdXXld+aPYGxU6XoIt4WfplwLG8Sv42arlC5fAFLBXd78bSJp536RcmBaaO
         s9tshcc1fSNt9t7fxJIiyrsskAGByAKZmPDCQ+uDSyqFZXuhRWL/qusBWALPb6pd+4re
         nN6xJF+4aw/Io5ddsHpI5AxSMe5jKsOx4LpWb+mxVPfg9eNs8tGgbxJr60IaORBPPubs
         sUjGrTD3pArbq9CgBlw5QUbSFL+tHjRRDIKhBSSdJ94p9qoGaUpQtYUgvQ/RO2uOSzY8
         j+0g==
X-Gm-Message-State: AOAM532Mv11orY7OHpNExrw6PMkZD7Exzk16e8Z+Ix5Mwa+kOYe23JEG
        Opq62PmB5bN+xpMXUkJssho2cleCbrMgwA==
X-Google-Smtp-Source: ABdhPJyfbsOLswq6Y7lq4OzH7i1DQXtCDVX7rG01lJCT8o/j/AsRQrb58zUr24C0Y61EJW+R0mq/eQ==
X-Received: by 2002:a17:90a:66c8:: with SMTP id z8mr2512483pjl.8.1604065211722;
        Fri, 30 Oct 2020 06:40:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e5sm3907226pjd.0.2020.10.30.06.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 06:40:11 -0700 (PDT)
Message-ID: <5f9c17bb.1c69fb81.a3dea.9027@mx.google.com>
Date:   Fri, 30 Oct 2020 06:40:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-4-gc1c109eb9867
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 132 runs,
 1 regressions (v4.9.241-4-gc1c109eb9867)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 132 runs, 1 regressions (v4.9.241-4-gc1c109eb=
9867)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-4-gc1c109eb9867/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-4-gc1c109eb9867
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1c109eb9867b5803229bea711acfc521c8a48f5 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9be44b98a5dfc433381021

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-gc1c109eb9867/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-gc1c109eb9867/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9be44b98a5dfc433381=
022
        failing since 1 day (last pass: v4.9.240-139-gd719c4ad8056, first f=
ail: v4.9.240-139-g65bd9a74252c) =

 =20
