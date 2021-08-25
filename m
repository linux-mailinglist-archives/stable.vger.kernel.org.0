Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193C63F6CAF
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 02:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbhHYAmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 20:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbhHYAmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 20:42:25 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A64C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 17:41:40 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id n18so21458987pgm.12
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 17:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N7cE/Y50QWvbSatGh1zJAOgRzhgWAKWQV3R8YR7+FWo=;
        b=v7pSZPv7XAjW4jpCGpX4siuFcejzwNb07siKcPtAaMufHMyEeWrXozJ3NwydKnaXOU
         SGFeA3jRhF1hnuYUZ8j736dSlOcoxmw1raLqcoeQ1rOwNz90h+Yfr6AfnxP6VO7Wr+YL
         FvoJRMJLIiK6E6K8Ukc3BommWlxcOuSiQpTV2LdHAays9m2Ho88qHQMveJ/WWjRCtpMY
         /wb29fvzLqcCqsMHEDsDS0MsYEEWKSdsvz2aPSGStFmXHjdzuIWZT8wAsKUNhLOCiXPx
         Vtrbf4Fh7/RUf3+IwIE1SlC5Ui8BRP7CS9WV+OUzRneT2B/ddYchbDJ9ikbhbXzhy/LY
         JJDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N7cE/Y50QWvbSatGh1zJAOgRzhgWAKWQV3R8YR7+FWo=;
        b=G94fWPnCp6arNOsSryIrdoESzKTy/YCY/4+E7lhHh4fsqaCIoP0BnLcPFFkW8xxoeK
         wBGLscpCSZCjZUiLJY/ZtSsmUZ470dgROLBrrd7bhkuXRSlGFjNricVbZTwMnc+PAiTo
         lzk931+NrXh9Hhb3lknnwXX2V3WXWwDNejxshLLbjTxkAPM6lv6NFB5rCWm/KAO+RZcY
         sIsGkOJZuOKTCRvrsfmO+k2VtCuR7gnZgFzUexUUHwYdEtpGKGPtxNyam7wFqpti+hXa
         QG7pQ6UA0hHxbxZA2joOIrW86UyIEcVUi3+ycaY1TEqJxT9ARRcsKIPhnq+frFe1pVlu
         yvuw==
X-Gm-Message-State: AOAM532dyJKrsrXKSRZEHuFzMqt1vdNQKpjZpguIuupghIyr7Ea6ACTG
        EfUSE6GLfwDiK2+bCbDb+ZYUKXX98DwlzjOC
X-Google-Smtp-Source: ABdhPJw90DDFKUMUnGLbwYRRbP54Miat1Vdaz1BarKhPgNfrbkMRLGXShKQp5KXBNLypzSjm7nSsow==
X-Received: by 2002:a63:da14:: with SMTP id c20mr39515209pgh.155.1629852099741;
        Tue, 24 Aug 2021 17:41:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n32sm22415014pgl.69.2021.08.24.17.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:41:39 -0700 (PDT)
Message-ID: <612591c3.1c69fb81.34a30.2c89@mx.google.com>
Date:   Tue, 24 Aug 2021 17:41:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.280-42-gf207820d8176
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 140 runs,
 5 regressions (v4.9.280-42-gf207820d8176)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 140 runs, 5 regressions (v4.9.280-42-gf207820=
d8176)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.280-42-gf207820d8176/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.280-42-gf207820d8176
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f207820d8176d59239f1963f544896f24043900d =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/612556ceb3b240f16b8e2c7b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612556ceb3b240f16b8e2=
c7c
        failing since 283 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61255694064f02b32a8e2c9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61255694064f02b32a8e2=
c9e
        failing since 283 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/612556dcb3b240f16b8e2c95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612556dcb3b240f16b8e2=
c96
        failing since 283 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/612557d64f4eb1bd228e2ca8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612557d64f4eb1bd228e2=
ca9
        failing since 283 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/612558a9927a7c4a458e2c85

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gf207820d8176/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612558a9927a7c4a458e2=
c86
        new failure (last pass: v4.9.280-42-g13ad08c714b5) =

 =20
