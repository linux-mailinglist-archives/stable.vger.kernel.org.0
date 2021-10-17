Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C384309E0
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 16:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbhJQOwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 10:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343923AbhJQOv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 10:51:58 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D149C06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 07:49:49 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c4so6354487pgv.11
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 07:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fwYvpUg+XRhqSsHN8dtcut/KQ8ZR0mTvATXlHM7820Q=;
        b=kvEEVCL2THjdBnqxZccoYK22gsK79hG5ngcRMfGFXzigUkku+dP0aalS/kVkSlfrrc
         9I1TfIpNUPd9K5DWvJSHYnDTrooFUieQ7QhQ0OwzIpKQBbf9FCjy5z7wl7wPQ1cNEMQL
         H7SvaIk6pg1MOCyXR8gLh9v+jJWFQ6vSZwnq5ZWkK8P6HttgJN5oyF/rRB5GqhoPBhj6
         DcEJ4Ps/Z/RXiE3rWE7qK1oZiOAq1892DK9Zq2bqD13VFr3QDWDk5I/piUYLdP0NmwL4
         qobP+0Q3daQB3+ITjK6mxYSj8P1CrbnM0w2DhytUstXL9Bg6+6H9li5vNJO/MoAOS5+Q
         M2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fwYvpUg+XRhqSsHN8dtcut/KQ8ZR0mTvATXlHM7820Q=;
        b=ow8lSgyg/Nq0lhD7lNG0/h7YIPyI6tNnUPrGNXwAWcKSARadbX9ctFuaDe+kt2VhUz
         pdPewcWHH3jm0OZvPjt2QjmKlODQY0gR4EFHqCb/w1Yj/W3dT9S9c5NoN/nQF6/NCxG6
         KBvqMt1RREH/4iGkHRmpG+QYv+GgxQ+sPh4NDB26zjLtvIRYGn1nbkCuqJp3poxMImxM
         I+51fJbt2586FrvmjftubwHwAUfeKo55aU41+j4P0B6hElZRkLAXbd3LSwvgUolOefMM
         2Ni6P8SYyDk6I8v8ejJxAVp90zSA+t+ifDf6qUcr6yHQBlGslngbHTOWRS1PuCYpbk6S
         LL1w==
X-Gm-Message-State: AOAM531JE76vaJjs9ZmE5YJka+s8Qqaw8DeUEIMXOadhrc85p6mT9i6v
        WWeJQ8CccYKBZXWXaxK2BpIt7Gv1j2y6bVHg
X-Google-Smtp-Source: ABdhPJxuPJvNcrerldpvGkvGZV1kU6m1h5LoLGmLYzVtrhabjn2kZ71l8PL+hdaQnt2mVT/tvdztMQ==
X-Received: by 2002:a63:3e84:: with SMTP id l126mr6950802pga.341.1634482188702;
        Sun, 17 Oct 2021 07:49:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o72sm10383078pjo.50.2021.10.17.07.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 07:49:48 -0700 (PDT)
Message-ID: <616c380c.1c69fb81.af298.d6a6@mx.google.com>
Date:   Sun, 17 Oct 2021 07:49:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.14.13
X-Kernelci-Report-Type: test
Subject: stable/linux-5.14.y baseline: 79 runs, 2 regressions (v5.14.13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 79 runs, 2 regressions (v5.14.13)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.13/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b9ed054073957b91d758135fdf277b3f77b5f2f1 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/616c02e8eda368ca973358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.13/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.13/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c02e8eda368ca97335=
8e9
        new failure (last pass: v5.14.12) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/616c0054cffa07cdb63358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.13/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.13/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c0054cffa07cdb6335=
8dd
        failing since 7 days (last pass: v5.14.10, first fail: v5.14.11) =

 =20
