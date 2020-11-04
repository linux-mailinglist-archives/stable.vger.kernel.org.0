Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02BF2A5CB1
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 03:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbgKDCaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 21:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729188AbgKDCaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 21:30:13 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C07C061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 18:30:12 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 133so16037628pfx.11
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 18:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fwl0sy3LjduLuwEkpj0My//ARt/8+uQGnDjRUwCLd9U=;
        b=XcCDuQddZclQCWPFy5V7VlF0lKl7vo3WKMHhOTO+5txFNid/yIF3XcgL2qU4ayUsDk
         RcQELu5JGKSc2G5dr90AbArphr2pG6xU7CtZz7uDhP61iSE51xAVjqBwRE9O0j9y1Emr
         10idi3UZrbsUp7kLasAoEBB+yV5LCkSp5YOoVs7pW35Eo3/55l1Goy2LqartU6VS6PL1
         DM333Nu9pJwz/awT4Qizg187w3SehxwkFqtoBI2vfe41pj+dhX2aKpdhkIcN7uzRK2Wm
         13oAMztfeGvoVghDOUfuXdEynRz2j2KnrmzNLjmgCQD+oaFQbYUQ4gDTvlUx2ADgY2HD
         /FmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fwl0sy3LjduLuwEkpj0My//ARt/8+uQGnDjRUwCLd9U=;
        b=ChmAstHWhqOWTSwNcyY56gKniEp9z6fw6Nr4TRbRLt3EyjPk+L2PZtrnVIddparXto
         TihAYz1RwKCl5sFspt4S7rChjDlpnN+jeEQU+tXaj5CVzNyX+lhJWyI9sYKs2fm9R2pY
         9C37w6HrXVyTAH6mPN3gnez5XenNk3So0Xq/WOV1mjOjzQ9rt572lFfFgHdu0nXBc0oF
         kKNJ4QBtN0U6c3XGreCbT7T4t+RLsRSHf4xx6UDmUz9y/26aZnypcXrGb8g8yxSVOt3V
         hy/7QyKZQI+wvQ83vygMDH64O+r7baPg4dHqK4lw2tnvI+2FNR7p2Hs12nJ0fvW5LOGd
         Tn9w==
X-Gm-Message-State: AOAM530vm/Www/pn3rJ7g2VseBkVAnu95t0Xm0GgvA3xOZoI7xSgmUwh
        kj3FBn9u7g8GDaxSNslnwiS1wBAjMr33TQ==
X-Google-Smtp-Source: ABdhPJwtN/U5BUdik1aB6Adt0Q0GD5BRi4YPYuwd4lLlRHXZ0p6k8CeiSUE9u597AdBNoyebpzBXoQ==
X-Received: by 2002:aa7:908d:0:b029:15f:d774:584 with SMTP id i13-20020aa7908d0000b029015fd7740584mr27359924pfa.6.1604457011391;
        Tue, 03 Nov 2020 18:30:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 26sm272307pgm.92.2020.11.03.18.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 18:30:10 -0800 (PST)
Message-ID: <5fa21232.1c69fb81.c7677.12de@mx.google.com>
Date:   Tue, 03 Nov 2020 18:30:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-66-gcf149e8ad82e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 114 runs,
 2 regressions (v4.4.241-66-gcf149e8ad82e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 114 runs, 2 regressions (v4.4.241-66-gcf149e8=
ad82e)

Regressions Summary
-------------------

platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1 =
         =

qemu_i386-uefi | i386 | lab-broonie   | gcc-8    | i386_defconfig      | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-66-gcf149e8ad82e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-66-gcf149e8ad82e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf149e8ad82ea9abebd211c3149891e8eabb3e85 =



Test Regressions
---------------- =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa1e13671d4183c2ffb5308

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
6-gcf149e8ad82e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
6-gcf149e8ad82e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa1e13671d4183=
c2ffb530f
        failing since 2 days (last pass: v4.4.241-8-gd71fd6297abd, first fa=
il: v4.4.241-10-g5dfc3f093ca4)
        2 lines =

 =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
qemu_i386-uefi | i386 | lab-broonie   | gcc-8    | i386_defconfig      | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa1dfec90122a062cfb530c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
6-gcf149e8ad82e/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
6-gcf149e8ad82e/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1dfec90122a062cfb5=
30d
        new failure (last pass: v4.4.241-41-g583b80963b82) =

 =20
