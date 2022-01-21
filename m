Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3BF496790
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 22:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiAUVuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 16:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiAUVuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 16:50:10 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A69AC06173B
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 13:50:10 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id i1so169029pla.0
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 13:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5ycH+XoESXZEKfpKUiRAelQdw/WkfMqCn9QQSAIfWr8=;
        b=O+h9ZDAKpuXLD2IPyiOYfKup4+ym+behoR5lO8Mq0XZRvqImzrKiWCIdJ4TPCWq5rx
         ULN6lzOK4okWmNAmNCk1xPVz22J/ZnP/WzKqYyepScpkR56+ADCK6vdQR64EnxpudvAz
         Un4ZNegolctd0m5ymDViWKWli87w2fyD/5O8chpPqlBelWciG5r+FxULGjroWst9zi41
         BSYSBkq7n5QJ1XlZgCnh8dMFVBp/GuA5IjV7HBdMpNQOqZZJTlYHmoDqju+AaI7bdEKA
         b1Qj8h/tsMIYBCMNSgoFa427Ch2CuA67oF5EByykvxpwuHYIHfGOoLl4uuzrQbY8Tm2g
         0GCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5ycH+XoESXZEKfpKUiRAelQdw/WkfMqCn9QQSAIfWr8=;
        b=WwdEDcSx7OGm0B9JPhCPbhytu2TJyv1akCYf2vb4BZfvDV6pcP2XvQNf9xlU1ce3Qm
         Z6FXoYhQszFsax//k1H654JMcTpGpdV3Udq7oPxUUCvEhvRvnW2ReQdShKZ62kNSd9M7
         Uoujxe4+Ly/bBZCWW8iK4nc5fFWvJYHB3V8Vo5Bpzkd9KyOlMXhbRQjLpXytirtsUMIc
         EQ4r15fi603xTyULNhPHJvTaqJSpyS4Dr5f0l8LxhYZsYrz0NoTfGLPPKXgj6AY7eOwr
         2J5S56AnYLhf9bYSi48OlNC4IhnRkvAH6YWhLmWp82OxDdsyHD6PYDFKHj5vs7MhqEXH
         6Tgw==
X-Gm-Message-State: AOAM533TcozeRykB+Y5/TIb1YPraCKphPsq6oR5fPC3F3WICbpvlbaV8
        h/T9mEZ1p5zVBHsyE1EkR2A5akdK9kFMNE2/
X-Google-Smtp-Source: ABdhPJynSim5g5oS+l77Wx044Vm2nGYdhdoYxjxvNrQGpnMkDI5WyiVI8HuXyHoAot0fPSE91+XYeg==
X-Received: by 2002:a17:90b:4d87:: with SMTP id oj7mr2616690pjb.11.1642801809301;
        Fri, 21 Jan 2022 13:50:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r12sm2323111pgn.6.2022.01.21.13.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 13:50:08 -0800 (PST)
Message-ID: <61eb2a90.1c69fb81.90d4.5cb3@mx.google.com>
Date:   Fri, 21 Jan 2022 13:50:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-12-g9f1a88b11580
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 142 runs,
 1 regressions (v4.9.297-12-g9f1a88b11580)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 142 runs, 1 regressions (v4.9.297-12-g9f1a88b=
11580)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-12-g9f1a88b11580/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-12-g9f1a88b11580
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f1a88b11580fac2be1650f504cd207ddd297499 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61eaf8ead2f5b1987cabbd4f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
2-g9f1a88b11580/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
2-g9f1a88b11580/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61eaf8ead2f5b19=
87cabbd55
        failing since 1 day (last pass: v4.9.297-12-g2155294a7be2, first fa=
il: v4.9.297-12-g4a79c59748ce)
        2 lines

    2022-01-21T18:17:57.425693  [   20.145141] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-21T18:17:57.476400  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2022-01-21T18:17:57.485632  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
