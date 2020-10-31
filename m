Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784F12A18FC
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 18:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgJaR30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 13:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgJaR30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 13:29:26 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3C1C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 10:29:25 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i7so5579813pgh.6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 10:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F4+Dqq2tsyXw/DmGTkOGupi7zF8dbcDfzuAXPbO0CCY=;
        b=P6Sb3XldCEvsxdAYmL+IkkOgwgh3AUgkI89EeSQD8T/cRC4oDM05Sb2tvfHMUboD9U
         vhN0GjBbpUcrFHgsTb/LXNu4mOeHpP6hsBvjaPmwLq36z+IQZzknvSj+dokwCTfWf/dh
         KcGv5zH8CRKdi8DABHY5gKmV/XIJUOrZO0YouWvDAfvuabHhqPhNzhKoswUvu0K8Q2WM
         p1BCV2uh6PjR6Eg1L0EPzhP2HBdg9uhn4zLKbKxOJmrXghmKdd1oQKTZF/vk4zxJjoTV
         W+TRvxHYjdPD+4saxdDEaAY+1zYOaLY32v+xRpSSkf1kE4ie9QIlRNRYmWyvXoOzRGyW
         rLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F4+Dqq2tsyXw/DmGTkOGupi7zF8dbcDfzuAXPbO0CCY=;
        b=RM2rm1Od6ZGw/bbPPC8ff8wIm7NfOxwPhGIsRnke13tA9xEE4sICohogQ31UOJ9Btq
         LTfK+5vCym5Xj9ZD5DGrgKH6Oy+XYa3B9XNMnifb5rNkhXwvXCvkUm1/hKQiSB3rroOa
         bbI7FxuBhB2tqsxtKG51iCpykbejbDmy7PCzNEhAp8chdQuxlHgeK/3FXoxRS+TOAuab
         umaBKLIMbB+y1dBRn+HM3UU+Kbonv3NVaq+02zuWRxSG8sze0+KmHq4+Xr6UTAxYcLsB
         5QSWyHZvPlYG1+U/d4W4qQkKJo6Dbwia7Orcedrq5RZfc6+tjJhGViaOGHEOKr4+M0a/
         sk/A==
X-Gm-Message-State: AOAM530VW8SDxk0V9xezOwxqIvNVc75i2f9oNJbdetnlpgXmTjt7taSO
        XlPY5nCdrFMZSelE4mEUZ/N7M826FhKtLA==
X-Google-Smtp-Source: ABdhPJz3DyXIAe3DKmxNIb4TqEQQXWeN0OqfZyybFHoat//hBJZIPFDT43trTjHXe/PYz0bF5cUumA==
X-Received: by 2002:a65:5289:: with SMTP id y9mr7095364pgp.386.1604165364696;
        Sat, 31 Oct 2020 10:29:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nk13sm6759896pjb.1.2020.10.31.10.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 10:29:23 -0700 (PDT)
Message-ID: <5f9d9ef3.1c69fb81.9aed.06f7@mx.google.com>
Date:   Sat, 31 Oct 2020 10:29:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-9-gc264933bf666
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 101 runs,
 1 regressions (v4.4.241-9-gc264933bf666)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 101 runs, 1 regressions (v4.4.241-9-gc26493=
3bf666)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.241-9-gc264933bf666/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.241-9-gc264933bf666
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c264933bf66687d730fa9e74b4f32bdd736997a7 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9d6c6b292969821f3fe7e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-9-gc264933bf666/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-9-gc264933bf666/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d6c6b292969821f3fe=
7e8
        new failure (last pass: v4.4.241) =

 =20
