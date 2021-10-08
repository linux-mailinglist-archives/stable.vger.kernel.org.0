Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC6E4271B8
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 22:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhJHUEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 16:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhJHUEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 16:04:01 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A003C061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 13:02:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 21so643556plo.13
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 13:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g9chUJ28i5eywEjmHptUtEinldN+RoLA+OeT4kIGAHo=;
        b=PT02VT1BhINEN6CbnPJt7UjZLhAxBfX/LjGCkyyehTKIFW0zETpqKgrQH7PokFKLrx
         iUCwZCzRIktAN9pwCNSsppKIu4v6/Fxlppn+Od7PB/0swelGNMFKOql2rMKw3U/od7m0
         K1QvEEe833j7VTrch8LvLx8d4K0RHRvGbvCxPIHtLgo3TfxYyPg6SI1YSto6O1q+8p1x
         U+cCC7bkL0V5DVbumHC/Fc7AcQzpm/5YBgGV04xfo56xApDXkVtmCTXlvojMs88LNtij
         GNwSCAV+ehaQttPZM7JI1boyP56blYQ1cVGdEKRk95xwXWqS4dLioQ8y76mDLFkb8ITN
         NuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g9chUJ28i5eywEjmHptUtEinldN+RoLA+OeT4kIGAHo=;
        b=dL6tve9OB80qdalpvVujTgsX5sEczFaSlg7UaLiQBML1eHGqzK1hHvB3pHYDGMgXj+
         EYmwe5rrQ1PsThmeur3vbej5xQpF1VRa0NJN2FvCu5ZSo1xIdJhI5O9no63IXPwJzsBd
         9R9EjPEJ4yBoMx+sw55NWLPsbYGEc72VZH1KEzKn4XZ8QjUEk7DR+vo2AbK2loRn9wYp
         6Rle40Hm1fxb0WRh/iNybc3XpNr/Re3/MoqXsx7kAyacyU2iyvFeJRl4TDMWyf53xo9H
         TxYwMnj3pFZZW5oTJtnI/mc5vRrAihpxS6X9y9+wZm96a8xO3Oq0q8phUKUx4D9OFxFs
         makA==
X-Gm-Message-State: AOAM531PuDihHVljcldsxNH0lWXyNpev+D34VGYeieshqhhoSGtf86k6
        cQJrnQMh2BmROBR1YDrG5dr5QVo8OUcl7Hd0
X-Google-Smtp-Source: ABdhPJz/Jc4o1ogFJ03hl1CEKa0WHKxmjjNlQ2C+ewPOXwF45/JrVhOfypNRFev+lYlPLpiKRmO1Ug==
X-Received: by 2002:a17:90a:bb13:: with SMTP id u19mr14536064pjr.42.1633723324539;
        Fri, 08 Oct 2021 13:02:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v2sm86194pje.15.2021.10.08.13.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:02:04 -0700 (PDT)
Message-ID: <6160a3bc.1c69fb81.9ce52.05f2@mx.google.com>
Date:   Fri, 08 Oct 2021 13:02:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.10-49-g24e85a19693f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 119 runs,
 2 regressions (v5.14.10-49-g24e85a19693f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 119 runs, 2 regressions (v5.14.10-49-g24e8=
5a19693f)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.10-49-g24e85a19693f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.10-49-g24e85a19693f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24e85a19693f1f7231d0187f165cb4dcbaa95125 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/616073b15c626bfaa499a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0-49-g24e85a19693f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0-49-g24e85a19693f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616073b15c626bfaa499a=
2db
        new failure (last pass: v5.14.10) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/616070411299d15ea699a312

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0-49-g24e85a19693f/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
0-49-g24e85a19693f/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616070411299d15ea699a=
313
        failing since 1 day (last pass: v5.14.9-173-gd1d4d31a257c, first fa=
il: v5.14.10) =

 =20
