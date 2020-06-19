Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83549201163
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393882AbgFSPlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392008AbgFSPlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 11:41:10 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E2DC06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 08:41:10 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h22so4440112pjf.1
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 08:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rT7EoBIOVlGmh4oZDro6rRwS6/fmZQmP+6KNi604dew=;
        b=gNhIB41h36KJ7Eb1y6CaGJOSNh/eVr1W3tIIseYnjV9uCCTq9ePAj6JeNhpXAjssfu
         aFzR7lBcE718JpjeykiXQ7FiBsrR3TEgYBNTWMCpQmnMaHCulvvC/EbRvP+tbHuyossP
         esEWqP9VAzvhavmhuvHM4OlCaj4nylB8IjExMxWTZDHBoHfVoWeQ7kmTB2hIml9/pEl4
         nY+Ev9IQvhTpG1PIgZqBmyUuz24lq8cvvLtrPhpf5Aojo1f6PjY1nhYJojmfhf6KqbLL
         gyUUEkKHAaH2s6ef27zLi2wQlN2o9axAUQVHYcwcBo9jYZc+KNLMgb4JONbWkhMcDen4
         I68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rT7EoBIOVlGmh4oZDro6rRwS6/fmZQmP+6KNi604dew=;
        b=oEovK9MYSMyMduE4w7uCz3Mu10mRsr1KuocE37xpNZxeeE4qfqJOwfQD83rWVI1JSF
         jVbnP353GnVjx2zTH1y2V3lAXa7IHZU6V1IG2JVOn8w3FJAs29Czil6iTQmwkowy0ff8
         wWsBe35w9L4QOlNZbd44kvOZiH9OXE3FIVu7V8nFDkWA8UFgUDllMhE9qLT/yP837aqf
         HjoVto4OtZ1WuTvd12KwOSMSM+uoUCcKT3nPCt0dswPA69HB1zgumLmspT2E16ZicZOs
         H9aGOENS3kcbs9hfjpWOu6RSeqSWs9DrrifCuz6wFwomGXWF8EOKbxvEUhBSx0Vx4CDe
         i4RA==
X-Gm-Message-State: AOAM531VjLp24fFKyGf+71ZWrltWebRjpgRYo7q26l6chvGaqZFCBnPm
        831qDHPmLMp/B60nat4AXed94TbxRfM=
X-Google-Smtp-Source: ABdhPJw7KjHHL8gnufbQqIU44/BoJ7Lpr5uwDE6Ak2exrltXzsQgYGr2SjV3LxvVfSXW2ku27bqfyQ==
X-Received: by 2002:a17:90a:cb8d:: with SMTP id a13mr4125104pju.175.1592581270164;
        Fri, 19 Jun 2020 08:41:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a5sm6304272pfi.41.2020.06.19.08.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 08:41:09 -0700 (PDT)
Message-ID: <5eecdc95.1c69fb81.89045.3d5a@mx.google.com>
Date:   Fri, 19 Jun 2020 08:41:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.226-127-ga9634103dba4
Subject: stable-rc/linux-4.4.y baseline: 32 runs,
 2 regressions (v4.4.226-127-ga9634103dba4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 32 runs, 2 regressions (v4.4.226-127-ga9634=
103dba4)

Regressions Summary
-------------------

platform        | arch   | lab          | compiler | defconfig          | r=
esults
----------------+--------+--------------+----------+--------------------+--=
------
omap3-beagle-xm | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig | 0=
/1    =

qemu_x86_64     | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig   | 0=
/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.226-127-ga9634103dba4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.226-127-ga9634103dba4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a9634103dba4b9a7c6bcb6021a101e7ac803c870 =



Test Regressions
---------------- =



platform        | arch   | lab          | compiler | defconfig          | r=
esults
----------------+--------+--------------+----------+--------------------+--=
------
omap3-beagle-xm | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig | 0=
/1    =


  Details:     https://kernelci.org/test/plan/id/5eeca854a61eaab77397bf33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-127-ga9634103dba4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-127-ga9634103dba4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eeca854a61eaab77397b=
f34
      new failure (last pass: v4.4.226-83-g43fb0f9d5b32) =



platform        | arch   | lab          | compiler | defconfig          | r=
esults
----------------+--------+--------------+----------+--------------------+--=
------
qemu_x86_64     | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig   | 0=
/1    =


  Details:     https://kernelci.org/test/plan/id/5eeca7eea61eaab77397bf15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-127-ga9634103dba4/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-127-ga9634103dba4/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eeca7eea61eaab77397b=
f16
      failing since 9 days (last pass: v4.4.226-24-gd275a29aa983, first fai=
l: v4.4.226-37-g61ef7e7aaf1d) =20
