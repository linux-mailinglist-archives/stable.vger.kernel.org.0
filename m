Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C020743FEC9
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 16:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhJ2O7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 10:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhJ2O7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 10:59:02 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15326C061570
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:56:34 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x5so340717pgk.11
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oaiD7/JnwyVy96xZZzFSS6wpe2m2XccwYUgbUNTXSQE=;
        b=T9xwKroxLBcoXr9vg/XhiUDmERAbJg2mHELgatp49ScpG2tPuBQ+EchK2T8M3mE2E8
         +MdaZ9hzevzhLh+pnAmt2YpMn/Vxrhi3gbiqQyykx4N9oN8mxIJXppPGi1BaHRRltcuJ
         zREOLPlsywjqMxYmdFNUNAGwdqRIMn4We7ZyvwWrPp3Ky6h2OSozlNKPlnofQMZKeniu
         W96sB4AXhl5xU8ukZTfx8iOa8lOujLjiZtGpdaJJBkBh66U+QndnLQ6CxqjeZnwYcBfy
         +GQW4jLR0WvhBGQamK0tANlzgFw4t0W2/3wyLYHXlGG3Ji44y2ArFEM4bdhTr7W/Carn
         exqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oaiD7/JnwyVy96xZZzFSS6wpe2m2XccwYUgbUNTXSQE=;
        b=ZDxmPTSmMBa4cfzcd2T0FlIjU692GGIeRRYDg2Wnx2wtY5dgRvPaN9D7N/osRchYWt
         QfIcSq2tBiB4eeJSfW6Zxh6OO0h+LSjm6m/0Vh3rqGkai6KGpUbMcPSA96nP4bAS+wBq
         /rbyN4+rmVupCFKPuSchO4wqIzpdpw9gnVrb0HedrAj4auv5LJJftqi2r2gNoWTxDFZ4
         L8TH9zmKki9vfFByW370dy7cquuAFkYdC2dBUp3PTJXxbJgPRLWyWPmOAQKs5P1CLnru
         4bE+opuEMn/ww/zZWizwlZvjhfdFLR8FRHtZoLqf3AOZMXJiaedLAAxUJzjU1OkalJTR
         g9Zg==
X-Gm-Message-State: AOAM532MMB9jMTtsPpGXX7wmYDdrwO0H8icNdr+BIB9qExMnjWpBeJXV
        hDqnBjX125KjvdUizO+rXWj/8aqj2yD4mupB
X-Google-Smtp-Source: ABdhPJxrvWmUxaaHEpN3U0xRaNeFft6vF3BrHqfdifFHWqX0wxzHear1FGxYglnaNoS444EtxzfzJQ==
X-Received: by 2002:a65:6643:: with SMTP id z3mr8659761pgv.16.1635519393503;
        Fri, 29 Oct 2021 07:56:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k22sm7649866pfu.148.2021.10.29.07.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 07:56:33 -0700 (PDT)
Message-ID: <617c0ba1.1c69fb81.be5e1.4ebf@mx.google.com>
Date:   Fri, 29 Oct 2021 07:56:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.15-16-g77738d315c10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 163 runs,
 1 regressions (v5.14.15-16-g77738d315c10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 163 runs, 1 regressions (v5.14.15-16-g77738d=
315c10)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.15-16-g77738d315c10/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.15-16-g77738d315c10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77738d315c10f6f12e48e80af49ee313f59d2456 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617bdb91e55e86cff8335941

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
16-g77738d315c10/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
16-g77738d315c10/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617bdb91e55e86cff8335=
942
        failing since 4 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =20
