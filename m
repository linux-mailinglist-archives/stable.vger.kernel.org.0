Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A6B201D4A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 23:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgFSVtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 17:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbgFSVtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 17:49:04 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06A8C06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 14:49:03 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e18so5057063pgn.7
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 14:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YALCtsYE139ghyaPyluLRk7FOtBBURWCaIiaK/xoy+A=;
        b=0WMrFkVj1Pcybb2xnZwnegqhkB6wDm1HtADSqEjqb9SF+xJuDeVxGTaT9C/luBt+kU
         NzBre6hYHJ3Oshl6h7RyTTw1nXbSkRUJuins59yVgAZRXjW9a5SBLEcY/GziISsOqo8K
         BWKZ6JdEhh8x0OmNUtkN4YwrR4JUG6NI6Hes2zlOsgAaGOKC9459asWZ70+BAVRDnsOn
         mD7VMWLsUWZQM9HGIacrdKqP9t4tLgVJneyZjgcffPEasb1EATcpMHxSHKN7IKH/OJNb
         p3CbMQ/6ijUZXjfVKTjoGss8lQjcJHxL3TBne/nVXXWNakONhk0bIhlFbPLLs+gDhWkh
         EkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YALCtsYE139ghyaPyluLRk7FOtBBURWCaIiaK/xoy+A=;
        b=BiepRvh7lj3aSEGvUbG7CHkLRo+uiBZCnb01PmgGKo/g2PSzVGDLtJbDXN0PWfftjH
         2Vtq6wo9Od1HxODeQlqBdMFCrWZe3IHsQe9A1p0OnqO//oL4X1/Kj6uqnmStdU38oRTx
         vzEA406R6Mg1ttRzhEADfaJYdq1qv5xCaLh+KddxN+0pCfkbgQR0tahqXmXPmNBaFJvj
         gjLq2UBFhKFHodRYfHiYqCDQ5Il4KMSIhN+fNPBZa5LvWrhaG88hijkKXUXBmjz3kDrj
         RPNIakpzI4oZ7RT7WIdgF0509moz4THCUaSTq5hIjHaJ7BB1KaCeKjdkdL+dPF1E3rU9
         qTWQ==
X-Gm-Message-State: AOAM531ebK3l71n/s2osgVkDPyX3zoZ/BnHVziBF8aC27GdvuSSPH+Jp
        Eblw/H6jsOWbKliJjIxvHZWsUCmmkHU=
X-Google-Smtp-Source: ABdhPJyUBdL3grW143lEduvOs4Qesvn713h2+BTh8z4dT2jNtqPJcFyTwHaCRdUGU8ENFguXAkjOZA==
X-Received: by 2002:a63:8ec2:: with SMTP id k185mr4420469pge.331.1592603342821;
        Fri, 19 Jun 2020 14:49:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n1sm6137726pjn.24.2020.06.19.14.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 14:49:02 -0700 (PDT)
Message-ID: <5eed32ce.1c69fb81.bd291.33b9@mx.google.com>
Date:   Fri, 19 Jun 2020 14:49:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-468-g1b895c62ebf4
Subject: stable-rc/linux-5.4.y baseline: 98 runs,
 2 regressions (v5.4.44-468-g1b895c62ebf4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 98 runs, 2 regressions (v5.4.44-468-g1b895c=
62ebf4)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =

meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.44-468-g1b895c62ebf4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-468-g1b895c62ebf4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b895c62ebf44a0852908c0f7ce05f53006fddf0 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5eecfcbcc134d45d1e97bf30

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
468-g1b895c62ebf4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
468-g1b895c62ebf4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eecfcbcc134d45d1e97b=
f31
      failing since 69 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5eed00f9c8d4e8f25d97bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
468-g1b895c62ebf4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
468-g1b895c62ebf4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eed00f9c8d4e8f25d97b=
f0a
      new failure (last pass: v5.4.44-415-ge106c2769e2a) =20
