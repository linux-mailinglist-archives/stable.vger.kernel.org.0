Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D31E3E1D8D
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 22:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhHEUsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 16:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhHEUsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 16:48:55 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18425C061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 13:48:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ca5so11856806pjb.5
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 13:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w/E0cC2DtzKQdjQzHta3Djvz/zZJTWDECX5qFVkC038=;
        b=sidmSMoyztCdTEvzqYo9W6xz/Ykx/M/e4tGWGNbCaKXD3ZkI2J7zdp1SxydWbPusSL
         fqKyKpOqorEpJG8ai6ekHNnCmg89dv+40iGS3atyZm0cVg5Gdx7wlwT8WC5efHQ96BBB
         D1k4O5c8Sv44rH/TkNUdlBehubAmfirNgBaSVBg87d5JXHdXwiynE4OFS/6QIHXhY5li
         DhYJbAqKAJEq46C0tzr3Ufl6OazcRnq96j2N5IF4cOWtJByixjZutIMy3cwh5D8M0cpQ
         qLVuJPfUhuvWITWP8Kq5PN9VJocNpmQrAQq/BY+AJS993NWK2ef9usB62SM/VdV/TsME
         xWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w/E0cC2DtzKQdjQzHta3Djvz/zZJTWDECX5qFVkC038=;
        b=gpMDMwCuTVV7H7fdl3g+ZhfQTrsQvY3Qa4DBMdPvyNls5nmTlyWuv9gMy/C3PDEg4N
         PTMdeTinwUgv5huBc/hDCyhqjnorgdUOzciJi89wPC+Y7/W2Y1t96HjxY200RlTuQiDT
         Fkr6hru++rG6/pZ8kOgrZyBPvNNJ3DELN+JgiIJZxsa4XC7sm0dWY2UOq+USTZLh7+l5
         Ro6YiV54JVRqIPcqHANdDJEHbQPVEAfAiC0BdrvXM27HatoPrD9vNQnERJPf6KvKDDvr
         bQNbzP9QG8HpzDzJ5wPlit3Tj1vxcdyfs23K5E/dfhKaFrSzXFoEYhEhOw422CR5o1+P
         3j8w==
X-Gm-Message-State: AOAM530Q0qDPWTASDrITfdweqfUDTnuYpSBRy6xRY7w/U+J3rSSw3lU0
        HNdyBV2NQUb+r+31rMmOkN+uQst2/w6+eoG6
X-Google-Smtp-Source: ABdhPJxYNufx/crKPpLdfDX4+/4UROtA72uzKCmaX0eLbnrLwWhsXldZzau+wJEBUWHZm/EKc0LQLg==
X-Received: by 2002:a17:902:bd02:b029:12c:c94f:e5e7 with SMTP id p2-20020a170902bd02b029012cc94fe5e7mr5849327pls.29.1628196519462;
        Thu, 05 Aug 2021 13:48:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm9256725pgj.11.2021.08.05.13.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 13:48:39 -0700 (PDT)
Message-ID: <610c4ea7.1c69fb81.3b212.b366@mx.google.com>
Date:   Thu, 05 Aug 2021 13:48:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.278-4-g5e94c22a1983
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 83 runs,
 3 regressions (v4.9.278-4-g5e94c22a1983)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 83 runs, 3 regressions (v4.9.278-4-g5e94c22a1=
983)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.278-4-g5e94c22a1983/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.278-4-g5e94c22a1983
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e94c22a1983596b8354d6c1f346f28c33702dd6 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c1b27ce39503e2fb13690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g5e94c22a1983/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g5e94c22a1983/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c1b27ce39503e2fb13=
691
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c1a47041cae8ea9b1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g5e94c22a1983/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g5e94c22a1983/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c1a47041cae8ea9b13=
670
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c48228f25ddeb5eb13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g5e94c22a1983/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-4=
-g5e94c22a1983/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c48228f25ddeb5eb13=
666
        failing since 264 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
