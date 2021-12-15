Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4517F4750FD
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 03:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbhLOCcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 21:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbhLOCcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 21:32:22 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E4AC061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:32:22 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id j11so18871022pgs.2
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=leYDqE/GU58w78A+96/y6cxdltT7pYIf+6J99eIF8qw=;
        b=cbynUA2ewZ67EIVEkegiy8/G+V+N7NiRZTBSuC0Pgon81vs+8RgNHMsyehDh68OfBv
         W7PWuntOfOEWgQAp6iI6/rCWopS9BqGrN1sFNtdNwP++23wa9sGBRipy7sOkE1O0k+yu
         8KrAKyXxY3+xOmdOI9gQ6gHELufKbHXHWpEOxqJF0uDvGhMlImStHzifuxtsaKOjCkGK
         4I63116sO8fZPgF2Jhs0LDxmId6QsAHGJ/W5KqRR0mZdgn18oXOuNWC1AdQM/BgJPgUU
         qgG1BnfHnnsEtVfBPGCCoIdESD/WPQ4r6KtnhujmBZ8NRTVoP8Vzy2YofdBqIoDoesfu
         KE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=leYDqE/GU58w78A+96/y6cxdltT7pYIf+6J99eIF8qw=;
        b=VXXE4BKa3JWnQMmQgP+QSiA3c+AiZZJjC7ne9jqXQVarSVbJscars5mXNVXtN2wkx7
         AOZa6y40oTGcyfOEqw64lGvNMZuQqy7TwtEatCMb0g90EyPQU5PcP2cIf2cSk3MgQd53
         b6L+Hw0licNEM7NuZt8KmmIIoNSl+zZPkooC/79gw+qm9bHbf2c26YNsgakNcdtizifz
         UT4itZL05Fg9PyC3TQi3nQdyRCZaiw7LWo88Siy3zwWsd3h2xiioCj2X9meGS++ENVCx
         BrueS04rM+p4wfsiJDBP8VYX5a1cZI99dgWnqUUx+HsX6BKAhcLlCa0SAZLitgPOTGAf
         zngg==
X-Gm-Message-State: AOAM531MO+UB2lMAUa/khLuD2Kqx5pPf8RvGGOaeDltwX09Y5O3xK7kR
        uSd3nYdI4I21/picKylFKcOQFn6u4Z81vX2n
X-Google-Smtp-Source: ABdhPJyWWc1BQQAoJuJE7ZaNV5DB/PpRvetmeHbrrj7ZrtRzGfxd03/oWXXyoiubNzPNKTcr6vRy8Q==
X-Received: by 2002:a63:b90c:: with SMTP id z12mr6128469pge.584.1639535542214;
        Tue, 14 Dec 2021 18:32:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a1sm402358pfv.99.2021.12.14.18.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 18:32:21 -0800 (PST)
Message-ID: <61b953b5.1c69fb81.41a4c.1fce@mx.google.com>
Date:   Tue, 14 Dec 2021 18:32:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 120 runs, 1 regressions (v4.14.258)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 120 runs, 1 regressions (v4.14.258)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.258/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.258
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9dfbac0e6b8600043de8dc85ed072f5f1342dc15 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b91b42e131330536397133

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
58/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
58/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b91b42e131330536397=
134
        failing since 1 day (last pass: v4.14.257-34-g5ece874a0959, first f=
ail: v4.14.257-54-gcca31a2a7082) =

 =20
