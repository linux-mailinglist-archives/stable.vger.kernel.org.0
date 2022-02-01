Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0454A68CF
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 00:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242998AbiBAXzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 18:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiBAXzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 18:55:53 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCA5C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 15:55:53 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id e6so17292657pfc.7
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 15:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vw6CwETjXAlBDznJ37jMfaZz+Lt68MbttumfBvqq5bI=;
        b=Q3dxwbJ8Ugk/ctZNAw3THQuEPwUMW9aNcTi+LIIj0twzby+2rQZ+AHfCcXgkQgJxep
         EhQwP+PcVi6jPAM5+qWlLiT7ZFI97Z2oXt/8nhs5EJu81b1RHMQkpA7mCgBadJBwpT3/
         gpu0DGhqhCqDLwSWEiiE+Lf1yJ4LUl2oJJwnCUjV3oi6cUM9XtA01w7pGbgncRxiGO/0
         L0B0+H9kDY4lfh01fbeH5GrObb1kcl+ClcsQpDYIhRgwCLVDwkEGaVi40dnMiYNd8lx2
         p2fxB92EaMCbx4ntZz46Ff0IUyMLFJvUwlpYOBD76i1ZfvaNUZuJGioojPl39gVeBweu
         pKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vw6CwETjXAlBDznJ37jMfaZz+Lt68MbttumfBvqq5bI=;
        b=JwnsXxSAD8XLsbA96Ftza417TqE0AnZrFwqUuwK9KxrNQwbN4T2NFC2A/hXYN8KIuv
         ZVf2n4DAeHztOjxR+NBJyjm//h8Flwi0fo0zNTsSJDTI6gbIzCi9o8TJBx+GPCP6Sf++
         fA+lnQC+MuzKGhc4mBbbRFZHvMo6pFZlWQeHK7ihsQXvZ7NR8miU/jmXkT1g5zdR/khR
         IkW1OQpfV5vgEckNRyTZUDN5TnJ2nqCCiUoNNRLpyETd66yyYPcN5TiJy8DxpYEbJaV3
         Z3v1y38x7eFXbEQnU1itiFkyUp9jXDYGDRAapIrfEzULcBG5EmN2iHdJPwmS6ogHz0wq
         3L/g==
X-Gm-Message-State: AOAM530b34YC4w99suLhqqT9CrxzJywCFQl2MkHeIY80ZWWCD559QgN+
        nlKOZhZMgToT5xZetxHuBJo7k2HupQlAP+XP
X-Google-Smtp-Source: ABdhPJzkrpQwl7Av8IuT1ESIZEaY/8ryBsAoeaALSeKWM9o5mnaBmbaqbaFMm9eQSIOW3pu/yc79PA==
X-Received: by 2002:a63:6946:: with SMTP id e67mr22567833pgc.535.1643759752633;
        Tue, 01 Feb 2022 15:55:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19sm9578135pfh.40.2022.02.01.15.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 15:55:52 -0800 (PST)
Message-ID: <61f9c888.1c69fb81.b74a5.846d@mx.google.com>
Date:   Tue, 01 Feb 2022 15:55:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-37-g2a37885a2c26
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 145 runs,
 1 regressions (v4.14.264-37-g2a37885a2c26)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 145 runs, 1 regressions (v4.14.264-37-g2a378=
85a2c26)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-37-g2a37885a2c26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-37-g2a37885a2c26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a37885a2c26f330475ddf54d3990e01821dc839 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f98f655f65a334275d6f1a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-g2a37885a2c26/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-g2a37885a2c26/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f98f655f65a33=
4275d6f20
        failing since 0 day (last pass: v4.14.264-38-gda1a5053b8f1b, first =
fail: v4.14.264-37-g88d20e7b4411)
        2 lines

    2022-02-01T19:51:48.132098  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2022-02-01T19:51:48.141589  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
