Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B873838C0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243640AbhEQQAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346113AbhEQP6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 11:58:06 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC9EC026CFC
        for <stable@vger.kernel.org>; Mon, 17 May 2021 07:42:43 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id i5so4833192pgm.0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 07:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U75bUVhYagVxW8fIOG6zprU1WAB5lLJXbE1RkUjJ71M=;
        b=o7J+PtwWpgcxlQHb9DHpiK3mIG5WDHAwNcShZ/1B117SZaumE8Rk0ttpdLC6XUa6q7
         rmndhN/lgKdxCaoXiJdJCZ/MiENQRCKvv5Me6USOl9VRZQv1al/4gzYNfmvWgVZxAjXT
         78QnV+jlx34SVSXwEEo/HqSsiNBcM+oK/FdFsxRaFgRmH+prUX1VDW0nZHA4QtQ/cQME
         qJVCBR4CQvw91N6wGrOcicg3rd/DDKpkvSZsbwt/fqymU5n63TRFbgyximpuxhrhdQH8
         j8GTpjjD3y/diqmkpaBWYMibvIuWvJcKiGaGgVxJGmVr5ljZnTOEIYyfi+UbVyPqB51r
         uqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U75bUVhYagVxW8fIOG6zprU1WAB5lLJXbE1RkUjJ71M=;
        b=NmA3OWhAhV9thyrlP1kz+cuzsrRNSnQYMzhvAutaeInWjIU03lvRPwOBIuBbI9r6zL
         15mzVRJNYyX5pYOJBtAQviUarnuPPnp9Fd/Ml83tGgTEbFrjwaTdG9fp3Z+NLjF1z8ho
         5e5q343lprfQkDejn1C/NR+Y50OkBxmMhti2pHVL/4SJjNOmW2mc+wfm4+kZv6n8QZj5
         QlM/Q5vdpm1eyvfNeVYGPkXC0bFHPVFOuVAxvN8FX9sZ/s673O2RscBBCy3ylPEOVDhO
         O7wCoUaWR1WuwyRImvkKZT2oL6ZjCfq/V9xsW4smnoj8ShYtapo1+GBaK3LCcMNRU5M1
         NZXA==
X-Gm-Message-State: AOAM532OVb9Q4aMBRstFHi3vviqVPnIslG/CKMgwediwUKuWSybiFkOu
        9rUS8IDG5eFUZHnotQV41nbkSKz8MPlgY2qm
X-Google-Smtp-Source: ABdhPJzEcXttC9vGjQqgvOqJOVxhrzNzIc8zve0gnNFUkQES5XtgDAHS3Pua5TbarU0aFF7KziZ6sQ==
X-Received: by 2002:a65:6643:: with SMTP id z3mr60567396pgv.387.1621262563157;
        Mon, 17 May 2021 07:42:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o4sm10373637pfk.15.2021.05.17.07.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:42:42 -0700 (PDT)
Message-ID: <60a280e2.1c69fb81.6b9fc.24cb@mx.google.com>
Date:   Mon, 17 May 2021 07:42:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-218-g54ac971d3343
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 86 runs,
 3 regressions (v4.9.268-218-g54ac971d3343)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 86 runs, 3 regressions (v4.9.268-218-g54ac971=
d3343)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-218-g54ac971d3343/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-218-g54ac971d3343
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54ac971d3343cb0b6f8541ecc95503a3027c4cda =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a24d25e4f9fec99cb3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
18-g54ac971d3343/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
18-g54ac971d3343/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a24d25e4f9fec99cb3a=
fa1
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a24d34e688720819b3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
18-g54ac971d3343/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
18-g54ac971d3343/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a24d34e688720819b3a=
fa7
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a24d14b03e2037d1b3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
18-g54ac971d3343/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
18-g54ac971d3343/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a24d14b03e2037d1b3a=
fa1
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
