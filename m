Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E220414EE4
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhIVRS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbhIVRSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:18:18 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48AFC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 10:16:48 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k23so2583210pji.0
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 10:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KoNij1v1HKJwwiRAVhyUN/KIPsTUutS+xgwiB1eoJME=;
        b=OPDQdeRlmSMC8db5qgNCeo7C9feRg5E59nnf5Q2u7Hj9IQB7PQEd3AiXglB0FKbirH
         LDjLUsy1kOMFuWcUDtVag7s8XA3EdMA/G9vz4nHmCb09xprpMdQFKy81IRQxsTiI+gxQ
         RCc6huvOV4Thqk1ywkNtT8Daiel+rYSvKAFOVYhmRcDt/zcv6z8vgwDYqmZS8J7Jq0Ip
         o4h6HeMpJgbq5GUw9IBmJylGQFkNQWbGNVPRCiJPKJMODCJ+Pn1GozkJlVyiY2qNUrLB
         YdT++7v72T5Plhc9phCKipVxixYb8ulMQmWoCyDFftT9WyxIA/sl+D1fiGV2bDOp3d0Y
         WkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KoNij1v1HKJwwiRAVhyUN/KIPsTUutS+xgwiB1eoJME=;
        b=xWvHPbKW1U+RfidsLj0OXtUMgu1/YxAlaVl7x1S8vdIrDonNz299wAgUSBa8WPq2XU
         20Al22K+acX8SkdurnUl3JT6G849eT4R8DQY2+lp9ZiTDKOeobkCH1/guG7i8t0AOcWQ
         EPBMaJCkciuVFnEWH4PR39WAGtbj08B11qpT02LhWXfA/6cZ/5QRK4WMrf/6sgi+6EFl
         IxijBu8nfwwsxdWFSl8/0rO8ryV8Sp3PMs8qCh7TA/ETRoF7wgCaL5aV+BzrflcDAsps
         cEHXuPVPjwh+5I39z+XYl6oFOZ+a8It4fo9lJhVDLEiUYnDJg4t5EmtQxfm7rqfgcF93
         tRgQ==
X-Gm-Message-State: AOAM530ne8PKaZrmTlEfD0QFNYiCr4q1//lad87YIcDmVF1Ot87KHv7k
        nltGUUcyGrjNjc/wyPoMtaBTqu5saksTq5w6
X-Google-Smtp-Source: ABdhPJzsLAMKWFd9811l3wuTMtoqRSNhRfDXGU5UAJ1p4Fz/AOMQUmq9qbgRYVjavtXkAzuofjLfWQ==
X-Received: by 2002:a17:902:7488:b0:13c:9740:3c13 with SMTP id h8-20020a170902748800b0013c97403c13mr482734pll.76.1632331008275;
        Wed, 22 Sep 2021 10:16:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12sm2964907pjv.29.2021.09.22.10.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:16:48 -0700 (PDT)
Message-ID: <614b6500.1c69fb81.4d803.7e55@mx.google.com>
Date:   Wed, 22 Sep 2021 10:16:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.247
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 89 runs, 3 regressions (v4.14.247)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 89 runs, 3 regressions (v4.14.247)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.247/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.247
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8ea4f73cfa7e0555dc03aedde52db54a6587ab43 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b29dd6972e6b57999a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.247/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.247/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b29dd6972e6b57999a=
2e6
        failing since 307 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b2dfb7a0589c5c699a358

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.247/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.247/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b2dfb7a0589c5c699a=
359
        failing since 307 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b2ad0a463838da099a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.247/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.247/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b2ad0a463838da099a=
2df
        failing since 307 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
