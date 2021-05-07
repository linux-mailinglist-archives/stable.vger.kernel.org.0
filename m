Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA83376C08
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 00:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhEGWKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 18:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhEGWKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 18:10:00 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116A2C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 15:09:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id h127so8843774pfe.9
        for <stable@vger.kernel.org>; Fri, 07 May 2021 15:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xBjuo0Mib5O+r1thulr8/W4ltAf9qqWKpJsl3mAjNO4=;
        b=IcwefQeUvs4qxSiKt2jHBN9Fp5X4Wb+eiN6GcbEuBSiB38BX/nwPIq80Zr2Q2dFXy0
         PRe/taiv4p85wHvJ+Qz97akaHlGJcr92kMkSLzAEG0Uv9zE4IIQS57Q0skwTCPrnsU8z
         kfoHd/cgYfcf6Mm2WtODkpxVNr+/ogArr2SwwsNGUd2Ltrp77tF59whxuDPb9kiIEDwG
         Jtq8bgcpzJkposrWbpsW92gUyzcbQB1klv0cXa0LpWgl0OQt/9c23RXenlguezdh4N7W
         /Cpe5NM9x4nDTlWUNgcEmUVCNdnIXZVj2MgqAvpg7xhLAto64/Z2JOuPvDZEfe8Dw2Ub
         9E0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xBjuo0Mib5O+r1thulr8/W4ltAf9qqWKpJsl3mAjNO4=;
        b=eVesNJxKJYmonBUhITO2noa4Gng7qPu8TCf6GebZqH0mt7ezdBTmcRWh/ncislHORL
         9VeIt0iNQ/qyASw8ChSu2G3+GFiBdv2hvSX317v+C2W5LDMLvpSuIJahQmdfw/ESAZnC
         7vfD8coG1F7MmJyVgcYWxEEy61NwM2qukDb1eGJVZMZhaLk4TSTs/rWXN/PvBFRnMy1k
         XcPEVNlbxElMm1elAWIrQCR9WPzfDUjSIGjjBo73jbb5dTUN8bZ+/CWLK6MawiX0crgk
         cBz2/LbOTc3eyUu1ZedRXPxap1I2GwwVgbnam0lxvIUxp35lgCfx3vS9cgK8M9M7saHS
         KWJw==
X-Gm-Message-State: AOAM530n0stkA2Df2Fqt68T6h1ca8kpunR1OEFjatoPztcQ8WK/DbChj
        zCG3QIfZdeDsDM8CKJZ/L3WtDMVvQICQ+xAA
X-Google-Smtp-Source: ABdhPJzDJibxrjg5p04nULr3oaYz283su0BhI9HD99DMQ3fyVK9HiHHTD4uDgxTbAG4amCqTUbxlGA==
X-Received: by 2002:a63:f908:: with SMTP id h8mr12739737pgi.153.1620425339448;
        Fri, 07 May 2021 15:08:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l62sm5577813pfl.88.2021.05.07.15.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 15:08:59 -0700 (PDT)
Message-ID: <6095ba7b.1c69fb81.875f2.16c5@mx.google.com>
Date:   Fri, 07 May 2021 15:08:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.268-13-g23948c626e12
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 27 runs,
 1 regressions (v4.4.268-13-g23948c626e12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 27 runs, 1 regressions (v4.4.268-13-g23948c62=
6e12)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.268-13-g23948c626e12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.268-13-g23948c626e12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      23948c626e129c12ccca5001c8d2fe725858864b =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/60958a392f1c9efb576f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
3-g23948c626e12/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
3-g23948c626e12/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60958a392f1c9efb576f5=
468
        new failure (last pass: v4.4.268-7-g5b55e0edeb114) =

 =20
