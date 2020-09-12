Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CD5267C6C
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 23:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgILVHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 17:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgILVHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 17:07:03 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE32C061573
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 14:07:03 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id o68so9742741pfg.2
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 14:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8EV0M1hBwPZ6Mjch4DyiLGsnH2pkl/2dqAvX/jcuUa8=;
        b=k+xpgchpLFGPzsqTfMLB5ywSG7MGNneGIxm8t00mJ3/G5FTa8ERxPPDG51qMnVHj29
         kwORl65nLaNrzwB35d5EmNbGYFBV/YURATTCgXzmEt4DYY7A6VKkheg8px5vDfs6UT7I
         yg+dCAH4zdul7ri6vqYZu8VEkrXjCMBOWy5JTCuZs7JZMlU2W1da7itZwd5zH+KLS1qm
         itGB0u9wqAz7MufDFf3fwpEJjwEbPNPXiU8H3bk4yJClJBP/osRyHY83XwQjhnz3/Bxk
         HpSUgM2x+PqpnwlTdjqZEQ4UgteILprfeTKlQxc8/pp40bt9n2S7dFMxuqN0aiN2oZfh
         iOqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8EV0M1hBwPZ6Mjch4DyiLGsnH2pkl/2dqAvX/jcuUa8=;
        b=QyzNsAbcqL8UjM7Mrx1hIwWAdx+kurv01ZplKIkI9J2/VJo1eZfYGHgPSiN5LL9ASR
         Qt7Vrph745YoN8YdkxLMLL2eE1/brf19SCO/EjAkCOmr01CH4KM74WYPCyD5UBTGQ9Pm
         tUyv5c3lRvY+zB1prsdeWu7lZX87uzznNbN/cvB8ivnafiV6RyHiAW0tAA/s35WIZfcG
         eOu/PbpG+sR0F8le83ZR5IEpTh826CzlpHP4xteuj5qSxdVIfbYV8ntUu94+dlcw8jzR
         pDoQGe+pcF0JaPaA2i8WjwjXMiM0L46c/St6561bVJc32g4B9yp+xGZA9qkE+yoO6eHB
         RAnQ==
X-Gm-Message-State: AOAM532tAaTPxIUy4kgOoZUrs6FmkzhbHK2BwV63afmepMSsUv620UfX
        szmcNbe789i97RoaeBKS6nwf01CnDsKiWw==
X-Google-Smtp-Source: ABdhPJyVubSU3aMd0Ld5/Y+WfvLHxL9E3hVEfOxV7sB0VQmU5GWfhmqjCpia8HHsMSyTEGyc3nyV8w==
X-Received: by 2002:a63:f09:: with SMTP id e9mr6010687pgl.334.1599944823129;
        Sat, 12 Sep 2020 14:07:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d8sm4733387pgt.19.2020.09.12.14.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 14:07:02 -0700 (PDT)
Message-ID: <5f5d3876.1c69fb81.ed5b1.c1bf@mx.google.com>
Date:   Sat, 12 Sep 2020 14:07:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.198
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 148 runs, 1 regressions (v4.14.198)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 148 runs, 1 regressions (v4.14.198)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.198/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.198
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      cbfa1702aaf69b2311ea1b35e04f113c48368c67 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f5cffdc9e4f3be12ea60934

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.198/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.198/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f5cffdc9e4f3be12ea60=
935
      failing since 162 days (last pass: v4.14.172, first fail: v4.14.175) =
 =20
