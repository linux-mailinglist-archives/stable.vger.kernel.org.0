Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33972AFEC4
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 06:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgKLFiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 00:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728797AbgKLEZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 23:25:49 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF681C0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 20:25:48 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id h6so3100441pgk.4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 20:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wpZH46aMx3ZnKAttpzcJ9sed9nkJAThAdbTF5AAuizM=;
        b=uITsu2KamJbMgybbMoEFAQIaMLa2Xdr3v9DgTsTrtK+c+Rcl+HmRsAZzj1MMAVXze3
         UqD0gEXF/TKcrlTBeSwPFHDmh0ObFQ/qf/JZHVCZXOk+9Y/s1LqwgIaCGwe6F67ZR4rj
         tTakXkcSdd6VNT8eI0GS1cIbgGYYDHvczTV3eSTWqmB65CJTYDBF6VTr9HbES3faU7SJ
         zWKfvy3jj9PVAuR48YtSz/NY9yMx5oZCG77V60/9WHJO80XkyxorWvi/k0rtc/lDU0S1
         rIsQu8ua3/SAfAnvsrcXkV0JP7MvXib/FC+VaIokQV9TKJqADxdlnZS56k4GoepJXvXo
         HrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wpZH46aMx3ZnKAttpzcJ9sed9nkJAThAdbTF5AAuizM=;
        b=nhw0h4aH1ev6FeurXH0VinjUth6l6AK7IEEMW/Ntu60aD+Fjvr+kNDvK3b50vZm0SD
         xlI3/dv3hAzbIFBtXSyw8DXSQAuKRVHNifUBU2qrUE/Bj6Tasi5H0ukk2ZIykblWe8mo
         0rB5Yq5TVG55XLFfg2vo4vAU2FijrjlmRA7a4YN5JJSQUbQ8wFsjpVOUGbxegWbxyVkG
         cdGitaO5GqagPpBVL73zGycLDA8LJklUPhXRJ6gf16y3M/i0fKvR7XVZmZu3awBIIauI
         AydHfgcYLl7OWSEzUr7OdYSwZ0Pzm+YWwQqNaD9Ra0OekhH0FeWe/SwHrw+zw1aj1B86
         RCaw==
X-Gm-Message-State: AOAM532zhwkKluW6xjGl/7bkoSHaiBcBIncYLDX/V+5PpzPRG07LjL7t
        A64eUXTn7jHhVOh2aW6zIyv6jpDcjevc8g==
X-Google-Smtp-Source: ABdhPJxJpFMdA4je1yE2/c3h4i1TAzGXkdlfBe4kuCaZ7EVrtyLELIuKSFkAYwYCc2aA5S/D9DPaSg==
X-Received: by 2002:a17:90b:fca:: with SMTP id gd10mr7179936pjb.157.1605155147719;
        Wed, 11 Nov 2020 20:25:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6sm4567563pfb.22.2020.11.11.20.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:25:46 -0800 (PST)
Message-ID: <5facb94a.1c69fb81.93738.a343@mx.google.com>
Date:   Wed, 11 Nov 2020 20:25:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.206-21-gf1262f26e4d0
Subject: stable-rc/linux-4.14.y baseline: 161 runs,
 2 regressions (v4.14.206-21-gf1262f26e4d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 161 runs, 2 regressions (v4.14.206-21-gf12=
62f26e4d0)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.206-21-gf1262f26e4d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.206-21-gf1262f26e4d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1262f26e4d031fde0503775e18bd6e2e9c8fdb1 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fac856520fdb414b4db890d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-21-gf1262f26e4d0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-21-gf1262f26e4d0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fac856520fdb414b4db8=
90e
        failing since 225 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fac8640f88a6b24fedb8853

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-21-gf1262f26e4d0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-21-gf1262f26e4d0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fac8640f88a6b2=
4fedb8858
        failing since 1 day (last pass: v4.14.205, first fail: v4.14.206)
        2 lines

    2020-11-12 00:47:56.632000+00:00  [   20.468688] smsc95xx v1.0.6
    2020-11-12 00:47:56.641000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/106
    2020-11-12 00:47:56.650000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
