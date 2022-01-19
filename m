Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B629E49341B
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 05:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351170AbiASEvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 23:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346654AbiASEvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 23:51:08 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE056C06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 20:51:07 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c9so1023256plg.11
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 20:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6CMY8vI7umhJV1R59GXVKChj+1PgKpp4sIV+3zgrP/4=;
        b=qzXp1SDfb8Gu1EWkk6+NN5EymJ3NMGtx95mTg7acTD8U+XgWCf8NtYG3wi/KV6/Jcy
         IRFqGFKv/yya8l0Jn2SoSZVGG2XBL+bC9loLCo6dPHl6AZjPCN2i9yu4iwZ/1XgAg7Qq
         JjOg3JSBVwPbsS+It0yeaxzlda+xC5NeSWMygQm3BJktZE7QrAUuOV9WBa50kLrySq9l
         vT9VNrtVUJY18pkyskQm3nXmiztHzLIpn3b42EHOAsATeqjWugJNhPHZPzpyl03QpVrS
         5BGWpqgXE/6vApZe+DFTYg7xFw8ek0cIk/w+2HNqVqhjfmOf01m31hemeIJd48av+GFN
         oH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6CMY8vI7umhJV1R59GXVKChj+1PgKpp4sIV+3zgrP/4=;
        b=F+EwP+Isj2btOwBQTF+E7iFXKiPePrPuiWpTniR16niZhcLDGyZbfMxFZDaqu0j7Aj
         8OuqSSXSjiKID9TcCRvvA5guzM1aO308Jao9WF6DUWGhesHq+qkGdBhZ57uMkPM2nZdD
         yglIBp9ceJWYwaf1/bxpJA+0XVX/6QmEebZmIpgYxLOe3FA6ajNnTq9RE8lkVnXdRKFJ
         WLUixNIVfyxXbpjs1IUNIRF7aDtvV61JTfNnxBoM4e3lN4cQUYu1zMs7MWNoCDTKHUKL
         aSPx7fe1aPuGoWOGSU16S63p0HDfSPxFmuq7JIdT4yov2zAyZTcTnQ7pu493jEC4hUXm
         H6Nw==
X-Gm-Message-State: AOAM532x289tw3B02ar28nKThcHyrGXfoMhZCtQmPe+Xzo5N1bhETnmS
        /z7dLHdhwCxtmDZhtXCYKWANGaPTrXW7BcI8
X-Google-Smtp-Source: ABdhPJwMSrvke/hzBp9RncdnC3O/2fIYcv/zSLQ8jimjzTUannb6H4pvfYT3zSbWDLBZ5cOoADPLMA==
X-Received: by 2002:a17:90b:1a84:: with SMTP id ng4mr2190582pjb.237.1642567861858;
        Tue, 18 Jan 2022 20:51:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h5sm18903088pfi.46.2022.01.18.20.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 20:51:01 -0800 (PST)
Message-ID: <61e798b5.1c69fb81.b6339.39d3@mx.google.com>
Date:   Tue, 18 Jan 2022 20:51:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-13-g570864c71522
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 124 runs,
 1 regressions (v4.14.262-13-g570864c71522)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 124 runs, 1 regressions (v4.14.262-13-g57086=
4c71522)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-13-g570864c71522/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-13-g570864c71522
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      570864c71522719ffd68b0f3a49fa9ef2f6ee215 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e7668b49db329435abbd11

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-13-g570864c71522/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-13-g570864c71522/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e7668b49db329=
435abbd17
        failing since 0 day (last pass: v4.14.262-10-g93d10bded874, first f=
ail: v4.14.262-13-g01f6e3343a5a)
        2 lines

    2022-01-19T01:16:41.019950  [   20.074676] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-19T01:16:41.063972  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-19T01:16:41.072921  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
