Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99B23FC092
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 03:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbhHaBvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 21:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbhHaBve (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 21:51:34 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948F1C061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 18:50:40 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x16so13710001pfh.2
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 18:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7S0jVt3se1qxKLC2FIef0g7sZhQm434IDHTnnrKPF8o=;
        b=1RU6Tg68tOwPnExcK/iVyhA2chlO4HB5WHFwhb4K6Mi+IX6wSMWCmZJ4mDxoWSvKGy
         eyLukH870P6JeOkrdde8n/IqyhwYZ5yN+Dkf3FYx5FElI74nH1HBV8BTc6KQ43fvYDL1
         9uaPCZLjC5uwPhjBaJxt3qfax8PRZKY9Frq6DK51Ry7MZ4Yhf/CDecF4o110eebzMXK2
         vHlK4Z5wCSX7NlLymnnt0nPllLrwE31/cCKtd6fkLoutXqwbLpv3lKU73Cq9/22OAx7l
         HC3PfqY5CctmLm1SdHvDe/EEy+dwbneMM+6AHN9vovu40Yd1pIIBahbZi3GTq3QRFOxW
         zY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7S0jVt3se1qxKLC2FIef0g7sZhQm434IDHTnnrKPF8o=;
        b=Np6eZxB618qp778dV+35QBqB2tksG+dVSb8NTNyjRYy8/JjgqtEZ9H1GGlQ7pbNI/S
         iP44gqRNY9q3P9EfZ+IYJ+SXv9gOGmHbnMmNoVVemyzs5oCKP6mMXQHzVNnn18+vaLxU
         HFGDtMEuS3UgcAIebIVfohavZ9aQMvshDCBSPcT+yfv5NUvTNrsKeoqHuuZXVa9Pzfmi
         hU4sMiJiezcZ6iIHGtDAfD+ZIXhtzdpgKHXs1MqYKIJ4UdwBCAZnRDnkb0H7Nd3Q+BfC
         mjAVfp67wlD586z0H+/YfdLyjpBM+b6Qx8igUXLvJqG686vNh6IGvRK0hVSqIAtWINSU
         m/Qw==
X-Gm-Message-State: AOAM531L1+MWd0JbtvDW2g73mznT7RB87Vy13hGCs9tQPZxsYYGN+cbW
        eGIgmvDJe+dvgwxGdrypS7iNmrMVtv7eU/am
X-Google-Smtp-Source: ABdhPJxC4Rwr/v1EQ6S9g24I69K8MM+UR104+TiaKkex4DLTob66F6W8Fv/DjFgAxVw6+MHnckGPVw==
X-Received: by 2002:aa7:9504:0:b0:3ef:5437:f035 with SMTP id b4-20020aa79504000000b003ef5437f035mr25970735pfp.32.1630374639881;
        Mon, 30 Aug 2021 18:50:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t23sm696680pjs.16.2021.08.30.18.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 18:50:39 -0700 (PDT)
Message-ID: <612d8aef.1c69fb81.11e84.3223@mx.google.com>
Date:   Mon, 30 Aug 2021 18:50:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.281-12-ga869874fa267
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 104 runs,
 3 regressions (v4.9.281-12-ga869874fa267)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 104 runs, 3 regressions (v4.9.281-12-ga869874=
fa267)

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
el/v4.9.281-12-ga869874fa267/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.281-12-ga869874fa267
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a869874fa267a843385df9e0de4189b8c4c8efc5 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612d571c175d80147b8e2c9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
2-ga869874fa267/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
2-ga869874fa267/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d571c175d80147b8e2=
c9c
        failing since 289 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612d5921781dc997138e2c8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
2-ga869874fa267/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
2-ga869874fa267/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d5921781dc997138e2=
c8d
        failing since 289 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612d57143be247c7648e2c90

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
2-ga869874fa267/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
2-ga869874fa267/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d57143be247c7648e2=
c91
        failing since 289 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
