Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3353FC0EC
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 04:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhHaC5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 22:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhHaC5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 22:57:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417FEC061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 19:56:45 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so1140253pje.0
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 19:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r90aGKvT1EHoaXdW3SZHWl4NxJFHVS4HrVvs60ghC1w=;
        b=IqBNPlZJV0yoffczGk7tJkRmCnolQ9cPacBi2wRm5pwk2YSQwKrdBTbdEih/0VXAgs
         BREfFqhidU1JksUnX3fJIBb/Q9WCGgzQchBqJEBC/rFL2mmguF/fhzp71i6sbbvH6Ksq
         WEDgu54fRozXs2ShOUHL7rcj2yNC/XnFZSRV5eOLTenwSABJ5SncdulIChxddiFpz3UM
         KuX0br22/dHLrn9kuCpwZibKDSVDOGWJsDwO1qXt43/zBn9nHkzPPXZyYjQLJd1eXLoG
         h4hAMSeHUBtxilV0pSS6U3yXDsYCqIOO+MmTNThcMS0ukF9u7nJFns3fwpDCaKyLZhbD
         EVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r90aGKvT1EHoaXdW3SZHWl4NxJFHVS4HrVvs60ghC1w=;
        b=e51bshxF61EY3342E4ivSs2SHbNTWD3kEe4Ai54/kMmJZsd5AqFRDcP+fjvJ0uhE0B
         omKk4tejsxhmz8llGeL+VneiqA06RyfZWrGnsYRBq9LqGGIRx6+/LfQOCktKqkxErwZR
         /TBWFvIcJ8r3LoiW7QnzTKBgSayRychEcueMhHe39AZ4ASc+SGafkm+xSbEjUDXu6Enf
         5S5L7BtHMYt42AGALuJFAyMUVwFgDOW8KZP8Tli3VSV89WNE3ckamPJNZzZBSX5I9oBR
         OOyXqeH5BZ5zY423YRF+b6Spm+1wCmW0qluRvqfi/zWq+2+b16GWlUJX9J+vIsc5pm/1
         9dng==
X-Gm-Message-State: AOAM532g7zpHtGGS0Ak/adLPxFX0sfip3Izk56cJAT9HWPa3VJG/T0KE
        jfOocE+kkojH+3yDGmNcgmProIJVZ8YH5Akl
X-Google-Smtp-Source: ABdhPJyDdBvU6fybA6Uu+ltDWA9Y2nUc+CDCDyYgiXvmeUYpE0Y8ITaSAj5bvB9x1SxFZZOlm9b24A==
X-Received: by 2002:a17:90a:4549:: with SMTP id r9mr2543823pjm.147.1630378604620;
        Mon, 30 Aug 2021 19:56:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j20sm17589342pgb.2.2021.08.30.19.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 19:56:44 -0700 (PDT)
Message-ID: <612d9a6c.1c69fb81.f2bb3.f2c8@mx.google.com>
Date:   Mon, 30 Aug 2021 19:56:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.13-97-g4abdf2bb4e76
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 157 runs,
 2 regressions (v5.13.13-97-g4abdf2bb4e76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 157 runs, 2 regressions (v5.13.13-97-g4abdf2=
bb4e76)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.13-97-g4abdf2bb4e76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.13-97-g4abdf2bb4e76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4abdf2bb4e76f1f610afee41d427d6cfe2030807 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/612d670863059ce46b8e2c96

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
97-g4abdf2bb4e76/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
97-g4abdf2bb4e76/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d670863059ce46b8e2=
c97
        new failure (last pass: v5.13.13-73-g193ded4206f9) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/612d685d3d85f6d2878e2cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
97-g4abdf2bb4e76/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
97-g4abdf2bb4e76/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d685d3d85f6d2878e2=
cd4
        failing since 33 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
