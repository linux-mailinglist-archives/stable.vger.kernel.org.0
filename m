Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505F2460AA6
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 23:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhK1W15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 17:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346454AbhK1WZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 17:25:57 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F116C061748
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:21:05 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k4so10507518plx.8
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uNmcXZIHC88oGvo54UggLpH8YQBw9Cok1ho9bKDzUm4=;
        b=m+C+Q2KM3k2icyKUAlAqkoXQHb+hj7ao5xB1c8LQjtdI0wObVcrXGVB0EqLAMdA4u1
         taY5+pd33IF4TQl9pScMPjTWXCq2u5QoQcFblXm0hAL09itXMO7CqWiAyLa7VaKhQAtd
         NmDuvzl0EowrFRW0hCPkc6H9XvLVtYjQVUDybX4g5eIRVXBnOwl1Nn9DJSCL/4LANVt+
         EKwAWj779E5iQ+M8lmZ5FY+87ouIg9f7cjTMc/Kv15EMHosUcuvm+HimQz8crrsQG6GV
         LA10FYPFSwyfX3Gkg5n8UnrdCQy9tlEiQXo3ob4zoTeqiPAZLTUrcaG7bndcEh5gOo7T
         31fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uNmcXZIHC88oGvo54UggLpH8YQBw9Cok1ho9bKDzUm4=;
        b=1fm3cDp3Kj3gz+dey79iLoXpSbbWphlgIu4wjeszMG/gttxuMFpiJELK/eFzofTiql
         ZiqFWfAGFIXMlMU4oKPlXrKNXoNdJ6yZDCUJWTVq5jSZdO77jTi6HvMeB1qgB32KgFSh
         ansiOs6HYBFO3nchoh+7dkhM0MLTzf6rKRtqShlFcqUin92lAbOiaUjjn+V3SgPy9LBo
         AtK0zSoHfbfoY4WKkmfJ0yxSDSR2Iwek8x7Hn5nvGIVQjOcrjvDkx0PmkRIjFYWWednR
         YYGRTW5XOlU7r7x4mtiIwJqUPLc1cGaYikwL5QKmr4JxbtSKcSSMcCsLPNnMjbN1p0bD
         vNxw==
X-Gm-Message-State: AOAM531LT/PgCsz6T/Tkq3c4fQDYUIJOBE6tF3L0YZJTEW6wWqANNIY0
        RUAnBYSG9rYenVac8HwBkpmIYdoa4z6I6KGM
X-Google-Smtp-Source: ABdhPJx1FjJ2w+xf7qJ2/TGLDxjAFnROaWC5vbclDVJklIkuok/x7tUZd9ueaJbTlO0m8PzNiYzUhg==
X-Received: by 2002:a17:90a:bf0b:: with SMTP id c11mr32979757pjs.208.1638138064817;
        Sun, 28 Nov 2021 14:21:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a3sm3449236pgj.2.2021.11.28.14.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 14:21:04 -0800 (PST)
Message-ID: <61a400d0.1c69fb81.2c648.948f@mx.google.com>
Date:   Sun, 28 Nov 2021 14:21:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.82-41-g35674c284fc5a
Subject: stable-rc/linux-5.10.y baseline: 171 runs,
 1 regressions (v5.10.82-41-g35674c284fc5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 171 runs, 1 regressions (v5.10.82-41-g3567=
4c284fc5a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.82-41-g35674c284fc5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.82-41-g35674c284fc5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35674c284fc5a17551d5df7c9af8a9737760dbfe =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a3ca630dc4a5feb418f6eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
2-41-g35674c284fc5a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
2-41-g35674c284fc5a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a3ca630dc4a5feb418f=
6ec
        new failure (last pass: v5.10.82) =

 =20
