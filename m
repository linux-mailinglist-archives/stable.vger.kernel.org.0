Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98641FAB08
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 10:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgFPIZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 04:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgFPIZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 04:25:48 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B09CC05BD43
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 01:25:48 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n2so8041510pld.13
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 01:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LliAc46dsB7atg2ER5/PlIvUDL5c/pGAs9D28LWsQzg=;
        b=bymPF9jWuVGsl0jvcvpiLIRT6cb7i1hYqWYMxMj63GqzXyZaI+KwNiY4ctlhrp4Oz4
         5qCanE2Os0q5sRekYsMsZ1CiESs+YB87zhhYTOrOFgq8vqmLHzlrLJKClEmHUFhvxTsH
         +Ryp0FEaGzvjrSurODrgL2k9rGCHJrWWGc4s6piw5kiNF2+PvJ7cYIpaNVx+NGkNoly9
         norGNTU6WxQBbirmv+slyxFFlTH+rWVhmWjb814GV/WPw5wPku/Wnhjd/pEnun2zXikD
         QBM+snjrSO4aekxoRP7o00Rlc1Lxh/0EZ60TuNQBCqWxxpQgOrrh8zCfpAh0QdacElSE
         v1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LliAc46dsB7atg2ER5/PlIvUDL5c/pGAs9D28LWsQzg=;
        b=t8DXyPEvqMBhobu+ywchmntP9q9OovwbAB+acOTVo4bUrMIc9idotQh0F+u+OXj2ME
         rHx6EghpcVtjR35jCq0X0A7Mpz/+1tlodTTF6zcVeRmfAAItTTm6ErRraV3FKWMZPNgA
         lgCDw76N02XoESrexrE5+qfdOox3yfr5F8k0lxjLXFnFaZmwMJs5s3qyOhhDSxaHOkEg
         +n5MkD6f5+amQnAwiyfW3nXOV+I1QGK3EIJto9LlWBZ0XPCCJDW8kAmcXmH6VDUmiMry
         ArtXk8Ty8qS1nEQ5rUJc7tcMBTbn5ythHtHva2WDpJ7+X/iUgdRbPLPkGeo8IAt2d4Zy
         tOEw==
X-Gm-Message-State: AOAM533rUNrvDG+dl33Cc7gvRA5S3Pz6NcIkrBicRku69RMjYeGh6yMQ
        EgfP2K8fBh8k2v53sQtGCXWYIS2Tl0Q=
X-Google-Smtp-Source: ABdhPJwMkXrAiRTA03hEfBp3Jgt4Jq7IyMW5Mm9NaqZYyqSlYhHGKbsahKa4FlllDoFRt6rihwLElw==
X-Received: by 2002:a17:902:6bc5:: with SMTP id m5mr1151416plt.101.1592295946085;
        Tue, 16 Jun 2020 01:25:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o2sm1707035pjp.53.2020.06.16.01.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 01:25:45 -0700 (PDT)
Message-ID: <5ee88209.1c69fb81.f5f33.566d@mx.google.com>
Date:   Tue, 16 Jun 2020 01:25:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-90-g4416c389d63e
Subject: stable-rc/linux-4.14.y baseline: 70 runs,
 3 regressions (v4.14.183-90-g4416c389d63e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 70 runs, 3 regressions (v4.14.183-90-g4416=
c389d63e)

Regressions Summary
-------------------

platform        | arch   | lab          | compiler | defconfig        | res=
ults
----------------+--------+--------------+----------+------------------+----=
----
meson-gxbb-p200 | arm64  | lab-baylibre | gcc-8    | defconfig        | 0/1=
    =

qemu_i386       | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/1=
    =

qemu_x86_64     | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1=
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-90-g4416c389d63e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-90-g4416c389d63e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4416c389d63e76d897a5788f6145f08522cf58b4 =



Test Regressions
---------------- =



platform        | arch   | lab          | compiler | defconfig        | res=
ults
----------------+--------+--------------+----------+------------------+----=
----
meson-gxbb-p200 | arm64  | lab-baylibre | gcc-8    | defconfig        | 0/1=
    =


  Details:     https://kernelci.org/test/plan/id/5ee84ee1a643474df697bf0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-90-g4416c389d63e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-90-g4416c389d63e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee84ee1a643474df697b=
f0e
      failing since 76 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =



platform        | arch   | lab          | compiler | defconfig        | res=
ults
----------------+--------+--------------+----------+------------------+----=
----
qemu_i386       | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/1=
    =


  Details:     https://kernelci.org/test/plan/id/5ee84d45f00504c39f97bf10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-90-g4416c389d63e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-90-g4416c389d63e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee84d45f00504c39f97b=
f11
      new failure (last pass: v4.14.183-47-g9817cdae1b62) =



platform        | arch   | lab          | compiler | defconfig        | res=
ults
----------------+--------+--------------+----------+------------------+----=
----
qemu_x86_64     | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1=
    =


  Details:     https://kernelci.org/test/plan/id/5ee84dc025518073d697bf6f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-90-g4416c389d63e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-90-g4416c389d63e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee84dc025518073d697b=
f70
      new failure (last pass: v4.14.183-23-g6b882ea9cfe0) =20
