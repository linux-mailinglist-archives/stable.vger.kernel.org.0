Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AA52A6E50
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 20:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgKDTwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 14:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgKDTwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 14:52:16 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D14C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 11:52:15 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 62so10175326pgg.12
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 11:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q/T7JkxT6wihoKAmdJD2szFe4C3pAPmCPm6jJ+eMI4k=;
        b=VNq0XCrnyXE3A1MIKRrHXHxAZ8P7yqktMny+VbeA/mGRyCIVZJhKi4V608zd4P5B9S
         yqqzVVgTsMG5l0W8K7RMY1psTwv4hw/EShVT0DSdC6WHXKLxeJGnMOxPri4Nn0OuzInD
         IX4QMDFhq4HNmb3Zp56R/LNZmgKa8OsyFiEQIF6cu1TEllgBKEKEygFCvYrbqr0jy60r
         +Vkho/U1xNKUKckquSeYiOwCdlke9tjket+xzBYq5s/KkYnrMRTl2+2GNUZ5m8YRmzRv
         5LpL1/P5BSlK82TccU+YSSfKZ0vZVUVpv88do0lB+wQdscP1MKuZ/kG1TnczAGE774gr
         ADgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q/T7JkxT6wihoKAmdJD2szFe4C3pAPmCPm6jJ+eMI4k=;
        b=X63SSb90quebLZwziuBg5Teq+jaD1qgKfwqP1uMKA1ETeBlvnSeQWfOumtSshrtmXz
         /nfjC8UUSCemC9zMycAlA8t1gZUEwSQp46HhcVipJASnzOfkBJSZ6d/pzJkiOFVQodNi
         cIIxktogpYygp5EqQ6AIm3cBA34jJ05P8HJMFh790gAbLBKdINmAqOzKOXJmEV97dfK1
         W/ama5lSyrrpOEDuhBZ3/gm1kiH2VinBfYQxK1qhGgXoVfpL7KGQ0AnV5tgwEK5hmG5S
         RULYFpRq71Er3cGZc+VZcbJy+ViVTOfCf2erAkAfxWaoUZa/9YPH9f2iq+b9n/JG58+Q
         NX0A==
X-Gm-Message-State: AOAM5330qtUcn85fbwaGwsGUZeUP0+SBX//wpl/0C8hn6b2/23dIoQPb
        MQPUM3OAi1mp9vn9ShMRXtdVx6ZPufTV2g==
X-Google-Smtp-Source: ABdhPJxkAnkaMCTvdjIhe2Z0F33RJ97imXU54G1EZLTFF8zGcJ6Kqb5dvcfHg+ZrIGSDfsY/iIqKFQ==
X-Received: by 2002:a62:75c4:0:b029:163:e95e:f52e with SMTP id q187-20020a6275c40000b0290163e95ef52emr32561891pfc.52.1604519534392;
        Wed, 04 Nov 2020 11:52:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7sm3201222pfn.37.2020.11.04.11.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 11:52:13 -0800 (PST)
Message-ID: <5fa3066d.1c69fb81.3d87c.7c34@mx.google.com>
Date:   Wed, 04 Nov 2020 11:52:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-123-g2108d96b29a8
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 176 runs,
 1 regressions (v4.14.203-123-g2108d96b29a8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 176 runs, 1 regressions (v4.14.203-123-g2108=
d96b29a8)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-123-g2108d96b29a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-123-g2108d96b29a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2108d96b29a84ad0e8dd73d97843a43b9502e05a =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa2d3e6b0fe39ba3dfb5312

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-123-g2108d96b29a8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-123-g2108d96b29a8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2d3e6b0fe39ba3dfb5=
313
        new failure (last pass: v4.14.203-124-g6aeefdbd6063) =

 =20
