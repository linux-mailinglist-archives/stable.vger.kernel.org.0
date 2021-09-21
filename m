Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3E7413A21
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 20:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhIUSio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 14:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbhIUSio (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 14:38:44 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A15C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 11:37:15 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id k24so21563125pgh.8
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 11:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UgvrqwXsUZtieUyoyTi0D9KH3DBX9EAQjIWWok2kqC4=;
        b=E1fN/2+y3mANXwNMLN0WHerdBbUUw2yb6rY6ekqFp9VkapbRaf3bQqyjlsRxowk3A6
         P4NkLqVOEhKPIvgo9j01uINKcgiao5ugeo7pADvPG2DNTxnuNy6BiO+YvVxN8AfQZ5Bp
         nE53Zz18tbq7WoLlsvJtVz49SFsF6WW9H52sBZ6y2bpla7mt03PXP3cuQviPiNUhmDIf
         d1q++uWI4AA7yyhQ6tKNsrtjQ8x9lVGAbGCdERP3YQh4cjuzxLBPdwgaME+GJfbkwlJj
         5KkZcsHhqMvG6bB3bOLGKVigO5c/l6l/sNCOrVfi9686AR2tgyBnCGceqQj8+6fFyuqZ
         s+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UgvrqwXsUZtieUyoyTi0D9KH3DBX9EAQjIWWok2kqC4=;
        b=qulMTUVW5yZfSYmE3l82WJhlF5PiECQvd/Gm7MUvOjKgR1DmJK80L7aWTLKB9+7mxw
         yjoYnObUyW/6kTmRMJrLW3EQsMpLwLwEIhFJpa7sFMaWb76C55Tal08VF/YkM73CVYXK
         MZKAuuBCXfyfzBEd/zG7tDcBGdH1Ud0f8vJsHhvQhnp1RO409k6PoB3YewF5MOddycfG
         Vr9Ue3eVG0eRwvJDGfE7+eGecMWTnb+JRGqlNWA5R0pK8JGmvFaoQvLa5mna3Nx/cxup
         P1gjx0UctjWIowX0P1UuibwZykSoTgSX+BA68L7z92gP/5XntSXveP1uM0JijVkwGgOJ
         1+Mg==
X-Gm-Message-State: AOAM5308SbT9bm8WghfClTKeDZPvggpQMPb2I5SBjmgas2PFhBTtTBXH
        fZkWIAdnEQLmsODQt4twQflkcAAxIxpLQWyD
X-Google-Smtp-Source: ABdhPJwI6ZQ4eaw9IA2R8BLH1yb4b+8szIt2RlA8y/fik6x4fI4Qx3l24I/zxgwJNKFHyCuNLMcBjA==
X-Received: by 2002:a62:824a:0:b0:445:2372:86ae with SMTP id w71-20020a62824a000000b00445237286aemr23023731pfd.43.1632249435214;
        Tue, 21 Sep 2021 11:37:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s89sm3417989pjj.43.2021.09.21.11.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:37:14 -0700 (PDT)
Message-ID: <614a265a.1c69fb81.672a8.c666@mx.google.com>
Date:   Tue, 21 Sep 2021 11:37:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-174-gf1a94637ff27
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 68 runs,
 3 regressions (v4.9.282-174-gf1a94637ff27)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 68 runs, 3 regressions (v4.9.282-174-gf1a9463=
7ff27)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-174-gf1a94637ff27/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-174-gf1a94637ff27
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1a94637ff2785eddd9a5edf1d558bbbe5ac774b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6149f92bc293cac86b99a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
74-gf1a94637ff27/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
74-gf1a94637ff27/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149f92bc293cac86b99a=
30c
        failing since 311 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6149ec3649dece226699a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
74-gf1a94637ff27/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
74-gf1a94637ff27/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149ec3649dece226699a=
2e0
        failing since 311 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6149ebdcb827d6aa9899a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
74-gf1a94637ff27/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
74-gf1a94637ff27/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149ebdcb827d6aa9899a=
2e1
        failing since 311 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
