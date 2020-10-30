Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D422729FAAC
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 02:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgJ3Bmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 21:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3Bmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 21:42:36 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499A2C0613D2
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:41:48 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id e15so3898416pfh.6
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 18:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wiwfBW7XxzczjkrUrKBBNrVHAFPmeX407T94TmaA3WM=;
        b=MFRHCGebAMilan3+1dHDyxa9EeOV3TUE+eWzH46iy6N37OsgDgGTUfHqwMIEdMTvWr
         fqqAdnz1Mf0mR5XONxcZxPY6sOv8fCkAwJ/eWpXq+bJCAfI8yxhBRRfqrDKi1FnAThCe
         Fk2LzhP9Ig3OrR6d8n/7uV3iVCCsjX2aucmVl9drIrgcXpG26QhiGORPnlfIcVChhFt9
         E77iXaV78rb3mt0iSG3OWrfcgqwX3FiVJhVbShR7kBAEMx5iSFpKD2ptuQQshF+iuESp
         iy/Lsb4rU320oxmnDgc/FXzCPa8/ZN9w6QDwYjTvgQI7dHyG7MDAHhCo0EHWb36E9vuj
         Dz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wiwfBW7XxzczjkrUrKBBNrVHAFPmeX407T94TmaA3WM=;
        b=XdGSkZ0glK79xSbHy43USkRB3t9cuwDLtymxmv5G0Snqg/AXGCcTFsnhcJR130jS+J
         O6AFy85hdOhfhqfc1h9rJ1H86FWw3fjDckWq3tKC1si6OBW8Bj24SfJ6DhjhMHA/Ql+e
         RmMvphB2AGZ/vpVa2BlKW+ZdcJlnXWzP4l0fzV1bvbUBbcqgQ2Vxl5oFcFtJevdtsCic
         fhD1CO0p1z4bcqTsnyla0bK/JixWHanMjNUUnY2/Fbox7B70672p0hlwAfChytbPGpq5
         MbEF+XTMWk+oIsn/kvS9xr/fz1d5H4TSrpqH1dBP7YKZXG+XGH2DFeFRdc8Kk8Z33Fjn
         3Kkw==
X-Gm-Message-State: AOAM532FRc7VNvb7H8dYVRAu1VJMJ4Z7cZcOd8Ii5PQ6QA3s2LW56BH9
        T3V6toPwUrURnJdPgkBTC3tYd9WJAYlj3w==
X-Google-Smtp-Source: ABdhPJy0dehEyR8PgWm6HysHthqxoSnGAXshuDHlSRpvlsEOOLAs7RlxSDYM8Z4u9v/FhjZwHksAcA==
X-Received: by 2002:a17:90a:cb92:: with SMTP id a18mr2726871pju.136.1604022107573;
        Thu, 29 Oct 2020 18:41:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n5sm4183038pfa.156.2020.10.29.18.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 18:41:46 -0700 (PDT)
Message-ID: <5f9b6f5a.1c69fb81.528a.a91a@mx.google.com>
Date:   Thu, 29 Oct 2020 18:41:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-3-g96ad6f5436f2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 168 runs,
 2 regressions (v4.14.203-3-g96ad6f5436f2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 168 runs, 2 regressions (v4.14.203-3-g96ad6f=
5436f2)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =

panda           | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-3-g96ad6f5436f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-3-g96ad6f5436f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96ad6f5436f2812fb04f39ae91141d5a43813b87 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9b3a51aa06265a7438101e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-g96ad6f5436f2/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-g96ad6f5436f2/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b3a51aa06265a74381=
01f
        new failure (last pass: v4.14.203-2-g4eb6bac3af5a) =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
panda           | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9b3e7360424cd34038102e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-g96ad6f5436f2/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-3-g96ad6f5436f2/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b3e7360424cd340381=
02f
        new failure (last pass: v4.14.203-2-g4eb6bac3af5a) =

 =20
