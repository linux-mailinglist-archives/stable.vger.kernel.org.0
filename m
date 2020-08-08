Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E7023F5A4
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 02:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgHHAwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 20:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHHAwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 20:52:34 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E6DC061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 17:52:34 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t6so1869861pjr.0
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 17:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aXmh6fQFdHj4VDgTxdLmkR3r1rzUl+YVABrh7GtdcvI=;
        b=1AgzOcubfvZeXGd7yQUKYFU8oj9PKlUOvwu4O9NcZvHrWLau1Pw+m2yHk2OAmPPd7s
         QMfoh/dU+LsOvj9sg1YFrGQaTpqpEIYM3bSG+vVX2abW9xvXNgq8IaSD9tYGVr6Cf9Gt
         2ZAVlBqLNZtBgsAKRN+cOyv0wJxjAQJQ9MH23UMsacczkRdVB1AsmxWg/Coz2CB/00F9
         tAB3Pu0vogSQTiyUER42qT65uQSSuUMa0l3aemzL10TtpyOihQfY7Up16sJM4v3juI+p
         T62NbkdKyQhPnoN2NbPXM6b3r7/wEbQtm5XDSwkZdFSKKOBIqiqilskmb5nGa3xtrWiR
         K4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aXmh6fQFdHj4VDgTxdLmkR3r1rzUl+YVABrh7GtdcvI=;
        b=bQt+SFGP6m52f5D5NF7tGjgen7aA4ZDwpfol9dFY3hIn7IhJzrn6w4Zh9X4yHMK06e
         N0o3p/NqqnHL9EcPebQV+giP3KBLSCiQ2UFSdziv4eYuxhKsBM7qEqRyRha5MAsfhbq0
         gDmcpZwqI+kvjJ2kJcZ5GLTATXrVH4qDGp8NQSlN6K18e9fiePN9XEDxhwHZStfaNnzY
         wkvifqkBJLDTOg1V9iMR93UCGHR7lwIyAGCUnJ+SgMA0ovyVcEzwlYefMALIxKsZXYZ2
         V3D/cA10ZzbaFN8sdzzcivqs4xDPOL/Se7GjiJQOdfSDP6ulwITjgskSqiMWt4njuM3J
         3Tag==
X-Gm-Message-State: AOAM530g9MZEsjHIlE0o3rtB3HY8CLo8dm87TdPyD4jsOB4NuEE2ar34
        /D/RO+pKs+GpjD0/TQcPvlBMrLj/XZY=
X-Google-Smtp-Source: ABdhPJzMR3bgPhwqyBPun4k57/+kcbi9kjrW15ElgMhctQ1cBnFlWU/B5+RKvgKvfKCMwETxBiW+Cg==
X-Received: by 2002:a17:90a:1a02:: with SMTP id 2mr15048561pjk.95.1596847953652;
        Fri, 07 Aug 2020 17:52:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o16sm16231299pfu.188.2020.08.07.17.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 17:52:33 -0700 (PDT)
Message-ID: <5f2df751.1c69fb81.43cfa.52e6@mx.google.com>
Date:   Fri, 07 Aug 2020 17:52:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.193
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 127 runs, 2 regressions (v4.14.193)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 127 runs, 2 regressions (v4.14.193)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.193/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.193
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      14b58326976de6ef3998eefec1dd7f8b38b97a75 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2dbedb81ed4cd00952c1bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2dbedb81ed4cd00952c=
1be
      failing since 14 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2dbfa669c1545a8852c1ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2dbfa669c1545a8852c=
1ae
      failing since 129 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20
