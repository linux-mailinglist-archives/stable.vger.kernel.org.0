Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F4A20193C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732268AbgFSRTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 13:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFSRTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 13:19:13 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE76FC06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 10:19:13 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id k1so4173088pls.2
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 10:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9gH6zV2ushb8qBqsrurEapbiY/zzD9Eow9lwIUPuCyc=;
        b=vx7NfshYAf5zHhaJPkGcts7okZwqEuOgLTOsxAatwNjcFoFv0x35z7po2nSitVbxaI
         bcqxS4HD2uN3gmhhm2o2Fvm8uDnN1JsDLfzGYbOSh1jDiRzhH1MrWht1gM6Yusu18taF
         wTxxeGSNqaipUncV4qbFz0HcINucXKIudtDdDlCNSIJh6ip7MOgLhhoDOz+x1x6o+qY9
         eXrKkYBVjQCgWvJ0jSijjDWYx2X3Ml1Phi1Wj4qlqbApixru1TajF6r+NhGjvFVJVFj8
         HtPSO6DcYQvhP9yQUQqgb3LMumzSwB3bqobC5JS6OzatsVutIry8Nzlk9CYVKSWl0jhp
         TDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9gH6zV2ushb8qBqsrurEapbiY/zzD9Eow9lwIUPuCyc=;
        b=ixnoy2+68Igs1hQYgasLN1IQjP5DAG3XSm+C0KObxhEjHAPSpL+z8tx/nbUwjVRk9Y
         /+QHD16bMiOEfoucIBj7mSUsxAl44u6bKwCmhR3bCkHqJQzxCZWtPYZCuWRL4NwIcrW/
         DJoaTecQdsZdmM3rNLCb+iFWjpwsG6PgjuQEwAbiuNgnzZtFO7dr67y4awUeFLNlxD3u
         vu9Eqmz2vdQ5OryMueAm9vYURmzI7TmUi0D/oIxsLF+RMMc8tS/4aNvJIVXzT32ri5qw
         t1Ebzs5y4m3h/so92/yqhOtfJWsOkit9XbQIVRrL0qIfld/BRaNTMxHxSNXCcRBSuHKT
         37Ng==
X-Gm-Message-State: AOAM532M3ubdR/jxppUBBhZjhXHPoTSgJETZWGLp9s2TOJss6YJM1Lw7
        Kn4szq1CaiVF2G1UgNrQc0B5NwQMrtg=
X-Google-Smtp-Source: ABdhPJy/OQaEzKJspJZ2A+1z3EfdsiVWtVhwFyZAxKswifFEJlktrRCwgjl8nQ8x9zHbRSTGZJO8DQ==
X-Received: by 2002:a17:90b:18f:: with SMTP id t15mr4382112pjs.60.1592587153075;
        Fri, 19 Jun 2020 10:19:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j2sm5515214pjf.4.2020.06.19.10.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 10:19:12 -0700 (PDT)
Message-ID: <5eecf390.1c69fb81.2d995.124e@mx.google.com>
Date:   Fri, 19 Jun 2020 10:19:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-219-g608685e8f971
Subject: stable-rc/linux-4.14.y baseline: 72 runs,
 1 regressions (v4.14.183-219-g608685e8f971)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 72 runs, 1 regressions (v4.14.183-219-g608=
685e8f971)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-219-g608685e8f971/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-219-g608685e8f971
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      608685e8f971b974a9a45a95422e4a78375aa642 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5eecc1f99882e4a4c597bf1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-219-g608685e8f971/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-219-g608685e8f971/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eecc1f99882e4a4c597b=
f20
      failing since 80 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20
