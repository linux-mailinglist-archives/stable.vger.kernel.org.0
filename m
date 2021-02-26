Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6FD32665E
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 18:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBZRfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 12:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhBZRfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 12:35:13 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B3EC06174A
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 09:34:32 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id e9so3737989pjs.2
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 09:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A8rckKKWpPXp12Mrtlj3Qz/4z+4zD2plNEzkGazgX2Q=;
        b=SSuiyzokj2QO1APDRk1cWg5Zh4bptKzK6jw6tg5iLW9xULCYtXrQ7yNhIV/qrO2OKN
         0K/Kyz3I8nctmjNWeEkn63jeuR+WmA7k9sbF54Bfq0cTADqENa9iFLnuyTyda+WEmRqB
         ehRrW1woxqK/kIPf3fpSSsVsWVp0ZY9bTMP5X80HE23MCmNtoW4f7f98Cfrt6osfYvVk
         6542DHiTryL8NC6C9RY5i9lB4NuGxcRiM90L6XOpBAQGRJb5ti+6+ef5pLR9hU0IrauL
         PHqR/Pfw5vdjwZaWGCSItz7wNFUrUyhVGstxVntsalhX72mE8eOG1wgMajlU7bVNdFyE
         mOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A8rckKKWpPXp12Mrtlj3Qz/4z+4zD2plNEzkGazgX2Q=;
        b=eMaUbz3UOE5OUSA1lqGTu0nE2YvshhZZZjb9kr5/4CWby7ClVFjRwRiPUhLL+YmxwH
         hfW3DoKDr52VXvmlEBbAiHsrg5weP/KvCgpy4CTiyGYxE8at1edF1VfpPlGvA2rdv4cO
         re7lpaVB0xj7Jw5toetpkwMAyPLw/49iTcmeJLXdV969yJ4uMPZp5qn6Knkch4yJM32q
         ptoo/CMvc1QfwIv2rbCSHXfKcidC7b5kNN5b0sO9giSLLSht9wcQftjiYV11NPYQzGXx
         ws3/xBz9+Y08JLGmaP7IHvWXOBJVHje25jkUi13nkiYgHgixjOFRSP2e/fjVVaqJrFYr
         ZxZg==
X-Gm-Message-State: AOAM531nXUd8tuufEAvSY40YYmK0yji0tnq9e/5F8YJBSTyQROI+qm+J
        JFT6VrC6C2wCWegECnSG5pZfv3KpFHJhNQ==
X-Google-Smtp-Source: ABdhPJwMClD3o4iwkXphS12rreBtirphbgWOO8nwQHbl48W4vgpmciE4XMiBVB8iT93kKcNOCQaGNw==
X-Received: by 2002:a17:90a:e001:: with SMTP id u1mr4607595pjy.178.1614360872298;
        Fri, 26 Feb 2021 09:34:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11sm10406359pfp.136.2021.02.26.09.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 09:34:31 -0800 (PST)
Message-ID: <60393127.1c69fb81.b8384.7c27@mx.google.com>
Date:   Fri, 26 Feb 2021 09:34:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 82 runs, 3 regressions (v4.14.222)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 82 runs, 3 regressions (v4.14.222)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig          | =
regressions
-----------------+-------+---------------+----------+--------------------+-=
-----------
beaglebone-black | arm   | lab-collabora | gcc-8    | multi_v7_defconfig | =
1          =

meson-gxbb-p200  | arm64 | lab-baylibre  | gcc-8    | defconfig          | =
1          =

meson-gxm-q200   | arm64 | lab-baylibre  | gcc-8    | defconfig          | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.222/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.222
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3242aa3a635c0958671ee1e4b0958dcc7c4e5c79 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig          | =
regressions
-----------------+-------+---------------+----------+--------------------+-=
-----------
beaglebone-black | arm   | lab-collabora | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60375498f07da422a6addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60375498f07da422a6add=
cc4
        new failure (last pass: v4.14.221-58-g5d849f076141b) =

 =



platform         | arch  | lab           | compiler | defconfig          | =
regressions
-----------------+-------+---------------+----------+--------------------+-=
-----------
meson-gxbb-p200  | arm64 | lab-baylibre  | gcc-8    | defconfig          | =
1          =


  Details:     https://kernelci.org/test/plan/id/6035710f7f3024ea5aaddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6035710f7f3024ea5aadd=
cb6
        failing since 329 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform         | arch  | lab           | compiler | defconfig          | =
regressions
-----------------+-------+---------------+----------+--------------------+-=
-----------
meson-gxm-q200   | arm64 | lab-baylibre  | gcc-8    | defconfig          | =
1          =


  Details:     https://kernelci.org/test/plan/id/603577e04eafb825b8addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603577e04eafb825b8add=
cbb
        failing since 12 days (last pass: v4.14.220-31-gc7c1196add208, firs=
t fail: v4.14.221) =

 =20
