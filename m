Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5783242383
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 02:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgHLAvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 20:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgHLAvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 20:51:03 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D49C06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 17:51:03 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f5so323528plr.9
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 17:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7fVOypavZ0YNvjhPAV9S3Mq8Uz0iJvMkCY/wI4h4PJ8=;
        b=hqRsbIe1VDUiG1coAT49Iab6pKfTYXzSv+oFCpPmGctzxKJ6P+ZzuweWyqr+QNLzfR
         U5AX8udUq4n1yjWmDnUPjJXcRzeSS5NXlagrgizo4P0NbSXZoGm+pN8xLK0mA8XwJcku
         +4AZSFECOSWmn8Ig2E/RFqhG0MmRjzMzgmlrUOKnqioBuyscfH2C8W8ARMxdsx6mOdfW
         qxKaWwzx3U5PZGYK+utKAmwy+NoO4gQKyE9/tBMC9L+ytlrXLAkDGXWTCF3r/+XvZ47V
         7+KozJz7kxayTCuot5xQh6CBht23vRB/vp5KqXbf+zKL2Jc+kRU+xP/ZN64hQ4BAw1l6
         oaBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7fVOypavZ0YNvjhPAV9S3Mq8Uz0iJvMkCY/wI4h4PJ8=;
        b=Fq3zT2/e8EzOTTA2fjCf/jEAmHJkmCR8WmpAJfm7wB0HejK2kU5Z7OQFrTw3HLmc62
         8hGsB9ThNIFgGRKKg0oFWyUhb8ShjyqOtR8u5P8y8dkuccIdsBrw7buFrr+//PJuhglG
         A52ze9W4ZB9CD3k5b1VOShTDFIcFcuKOIWVd3DOAKa5iUtZqtvwUiXjkQWRyxeS3rKsk
         HypWHj+xmd42Iuk3y6nSwT/Vj3/xDz/8EGSuw/MMrrrXcPcaLIA5D6Bfeb6Niinq6ULY
         +zsOC5NrU8vl6zWmEeNBdbMv891zeW+ymGbfXVZj8Xh2rESmcMrpP/H1K7GlMt0stNDf
         tbhw==
X-Gm-Message-State: AOAM531L6K77IUMxf49Zo48m6YAI0BARMlG6sVmiTSGkrRNhBi1C6szg
        RLRaK5i+04uSz27RLd5BzzXl2QECV9Y=
X-Google-Smtp-Source: ABdhPJwszreRg70aFeCUbinmUcexbbfsWgmLFoHIGV48V0UXGsSevohcvLSrHODr9qP4QlsPZh6VwQ==
X-Received: by 2002:a17:90a:414d:: with SMTP id m13mr3545019pjg.163.1597193462947;
        Tue, 11 Aug 2020 17:51:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e29sm277222pfj.92.2020.08.11.17.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 17:51:02 -0700 (PDT)
Message-ID: <5f333cf6.1c69fb81.db03e.14e9@mx.google.com>
Date:   Tue, 11 Aug 2020 17:51:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.193
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 156 runs, 4 regressions (v4.14.193)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 156 runs, 4 regressions (v4.14.193)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =

qemu_i386             | i386  | lab-baylibre | gcc-8    | i386_defconfig  |=
 0/1    =

qemu_i386-uefi        | i386  | lab-baylibre | gcc-8    | i386_defconfig  |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.193/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.193
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      14b58326976de6ef3998eefec1dd7f8b38b97a75 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2dbedb81ed4cd00952c1bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2dbedb81ed4cd00952c=
1be
      failing since 14 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2dbfa669c1545a8852c1ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2dbfa669c1545a8852c=
1ae
      failing since 129 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
qemu_i386             | i386  | lab-baylibre | gcc-8    | i386_defconfig  |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2dc6ce46ede0774352c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2dc6ce46ede0774352c=
1a7
      new failure (last pass: v4.14.193-43-g288931e8c436) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
qemu_i386-uefi        | i386  | lab-baylibre | gcc-8    | i386_defconfig  |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2dc6ba2918e21a7052c1b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2dc6ba2918e21a7052c=
1b2
      new failure (last pass: v4.14.193-43-g288931e8c436) =20
