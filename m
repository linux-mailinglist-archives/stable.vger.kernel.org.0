Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C56294B88
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 12:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441811AbgJUKy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 06:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441810AbgJUKy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 06:54:27 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241EAC0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 03:54:27 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id o3so1248067pgr.11
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 03:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8FgWYfYzU8+d16mLleMpKr70IWhTprMJ6S5VMEX6z74=;
        b=T2WJzfCwa/LjiGneeuFMeWXtIhsa1iJXkZdeQn+mW32OixDuFGxYibETFRNO6fBnm3
         gVNuMO8uXCKh7sJyH6WeIcBH0e7ZgFKCZoA+w1p0YtdcxOrNgemYR0BeAVHMx9eHotPs
         gmGK6mMJ44vHvip7Mdqdp9lYHE7+MUw3dsc3h40Vh4YasW47vv2uEecQlEG+H5c7bt9d
         QR6momJ2OZJ+WSEljkuQmbtW6B+nclutZ8EJ1lNHNAP66WfLmyHQaVJ1HhGj6U1BtaFh
         rOfHIQtMs1O0B6NJNxd4Vb+UCmmvavDCT8fLvSqYR2zguyWbZgoO5wN/3IiYE+/4Dma8
         9++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8FgWYfYzU8+d16mLleMpKr70IWhTprMJ6S5VMEX6z74=;
        b=qixORzxHR4wvA8DI1ORYWxbWkcypSkirksqmPrqwnc2bqCBmOd1a9MmM13Jkb3DEAO
         Erh5cD7RszEytkR8qf7EP5lf2MK5Od7aP0CrL7L4t9MSuL7Txug3nIOFbPEhpkGlLfLZ
         XD7AOlM3Y/+ollpzr3Ou9Xw7XBtOsYc0oOVrT4pgdpwR4qA5g6By3qeZ9yXdjzd71DQL
         C4Km4+4qdkm70qqNWmtVwXYZd/M4UgodmANNXPhGIBBw//z62bU039Z+44fZVHAcDeHm
         sGMtAOTnw7Z2XuZTH79Q3Y++JRNj1KiOsQICEIyHHA7y60BUf8pVTzC9dAio4472lCht
         bCOw==
X-Gm-Message-State: AOAM532541NxncGbOdWgUZZ2FRRYU/QN7k2eG7l9RCixicuOpMVD7zsC
        eWy1L05s3eRbL1O3lu871uf3LagAcu7wfw==
X-Google-Smtp-Source: ABdhPJz+aIjQXEHLxWbp+3djxQ7UxIN3mGFPtVeY2RsnI9SvUTR7+1eqVdNQT1zbumrxE+JAtDcj3A==
X-Received: by 2002:aa7:9e9d:0:b029:152:5ebd:42a with SMTP id p29-20020aa79e9d0000b02901525ebd042amr2855239pfq.4.1603277666353;
        Wed, 21 Oct 2020 03:54:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w135sm2072823pfc.103.2020.10.21.03.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 03:54:25 -0700 (PDT)
Message-ID: <5f901361.1c69fb81.d1cd7.4c91@mx.google.com>
Date:   Wed, 21 Oct 2020 03:54:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.240-5-gbfa505ccb587
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 74 runs,
 1 regressions (v4.4.240-5-gbfa505ccb587)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 74 runs, 1 regressions (v4.4.240-5-gbfa505ccb=
587)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig      | results
----------+------+---------------+----------+----------------+--------
qemu_i386 | i386 | lab-collabora | gcc-8    | i386_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-5-gbfa505ccb587/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-5-gbfa505ccb587
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bfa505ccb5872a9ea42e59c6b067da008e63d6cc =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig      | results
----------+------+---------------+----------+----------------+--------
qemu_i386 | i386 | lab-collabora | gcc-8    | i386_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8fdaaecb3e7208564ff40c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-5=
-gbfa505ccb587/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-5=
-gbfa505ccb587/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8fdaaecb3e7208564ff=
40d
      new failure (last pass: v4.4.240-5-gba0afff56cd5)  =20
