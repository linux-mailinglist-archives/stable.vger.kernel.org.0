Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF34539AF30
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 02:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhFDAsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 20:48:40 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:43716 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFDAsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 20:48:39 -0400
Received: by mail-pj1-f53.google.com with SMTP id l10-20020a17090a150ab0290162974722f2so4913095pja.2
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 17:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5PkDKOJqWvXXCfnEAGsUuumM1BSE7IlresYcf3y1Ajs=;
        b=0oNcEfDMistMae6+5IBkDRbB1Eqy8zWW5v9nAP9yzmNbdKvtcpsnnO5hLuwR3Zs/zy
         0bp1XmwGNDU7FgLv9NkVlDm8Jk35NO6/LfH5evLJlzcv2DrCBwaeiCQLHZUmiogiBBFy
         +ucjf3UFQLqq8aF84/KxrKkVeRoAXrjqgSCF0E6L1vcg4erXWA0P6CfjcmHItc1Xfbm9
         fJHx8iGv5irDZ2hfr49dn6SgDq/9OK9lVVRZjH00hNF+SKBkG/PW7pnUhT1dCmoGfzn1
         O4hNPjwlPuPYN9yh7hSzPoRX4Ka12Epqzhk6sNHXsTENwVnxyRuFr7xHhIn06kH1ZdE4
         mGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5PkDKOJqWvXXCfnEAGsUuumM1BSE7IlresYcf3y1Ajs=;
        b=TyZ/je7g35NUxXa8x8bqgSg02PGCDD+HBe5dvNVsAJRDODbBlZhh5u8GutvhtTiD/E
         qGvFBA2qS4Il8pJHuTb9IxJE3XgaUUBGn3zl0pcBt1cz2YCLmlCcaz1SjzBH/9JA9dy0
         +X5+QSPXtQBkDWNLP66WXpAPInBo4Gbp4Z5C+QGqTqqGNbBIkX5tB6r+ba4rGy9Zkxhi
         dy+fs5AKrqt8rCWFID8x8Riad9rTBIgEEAmh8m1XDSvBwIDXwIJYkCnCwlFrXBiBQQ8l
         vOE1KhD7ln+bL0VEpEgdfAaDCXq+SnruHZf3Y3T5Bkl8vaNrWzbofjUZq0H78a1rr6rx
         Yn9w==
X-Gm-Message-State: AOAM531EyE1kHQ7QB7+H2QZlnpRnekgDXEv12s+zkFlJx0zkevCKaEib
        sp0lMZyHwj9Xo8uXVFyrX4ha8XrMIOKVoQ==
X-Google-Smtp-Source: ABdhPJz7QPGHAnrn33Cq7jVtRJNLx0R1AzXdDm2HCW4VhpQIIm4GGUc2yYFdu4TiTzACFhxl6jIM7w==
X-Received: by 2002:a17:90a:c68a:: with SMTP id n10mr14168441pjt.32.1622767540788;
        Thu, 03 Jun 2021 17:45:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h12sm238516pgn.54.2021.06.03.17.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 17:45:40 -0700 (PDT)
Message-ID: <60b977b4.1c69fb81.ce073.1844@mx.google.com>
Date:   Thu, 03 Jun 2021 17:45:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.193
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 122 runs, 3 regressions (v4.19.193)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 122 runs, 3 regressions (v4.19.193)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.193/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.193
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1722257b8ececec9b3b83a8b14058f8209d78071 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60b9401c994691d66ab3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b9401c994691d66ab3a=
fab
        failing since 197 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60b940c78fab9e5b9fb3afb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b940c78fab9e5b9fb3a=
fb7
        failing since 197 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60b94029994691d66ab3afbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b94029994691d66ab3a=
fbc
        failing since 197 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
