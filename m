Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160A73F9420
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 07:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhH0Fpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 01:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhH0Fpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 01:45:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3221BC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 22:44:47 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so8225339pjb.0
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 22:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y2CelGq5OnkrjEY2BEPHNFZ9FkqhFNaioRuBjNXeMm8=;
        b=Ia+FXMI/0dYotKsBRzCLqJJtbkP3Ete/v8ZDWlidgh6zL0x1hnSPwj37km5lVpO/1y
         gd6IuSHnF8Kg7dPQALJtaCsoQQVBW4bsH3UmUp+SN0WzG2nSWU4Qgb1D/jUI2Cc38Cqr
         Iug89umtlIHtV/P8QA0+aAn2fchXCbbMztru7BiCqLpfCWBqLcEqoppbkPqxEm85j+qh
         jjp1Uvg24v+hdTlhlywdAClZkklcZkb/AekvitBZRc0hMI8/ZkxpFCK1944RImPicRrr
         DmVZQxg95O9d7G0CbSev0Ec+kler5+dM90s1X4J8HnR6LNp7dAMiumVJ8kHAItEEFAxl
         bRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y2CelGq5OnkrjEY2BEPHNFZ9FkqhFNaioRuBjNXeMm8=;
        b=NBUNT2AO+bpoU58Aox84aqCJkotfZ0WrGIs2bQoOKNyNnv+7++f7DLp/Oiwvrl0nQi
         nDTwf382Jx7NwhORF9zgqJ6/n/yBWN6DP0eClZ0JgDKI35pnHNB8VbXjL5SryVOt3ndM
         yCOvTig4/AdRyLc2cj4y8b6uLX0CapGUPUNBOuc9UxUteFXvT8cy3WzqBCv2ldJzkSa+
         zF2qmHr3sKTWvMltFe2nh4G9cTACfLLc+uL4HaQxySIwbyeKltVmsUK33lekNP2f9ZVA
         ppH8ZV7uMp9SrN51etDoZlY42TX2jKQ6X0TQFxVVqJpl+0UvhLZ4IHUsAf04pUl5WiFM
         8jEg==
X-Gm-Message-State: AOAM533rFOm/nY7RyT+cQ+oI/afXrJ4i7dmrh4sE2OFX4IEeNbbIZk5y
        jd5JIdlLv6slPCtXpkpIkBaAWjV3oslmERO0
X-Google-Smtp-Source: ABdhPJxCKJLpQjYpPdCKTihe1Doqmqr05CDoPAz3rMQp43+JzZWn+Dn30Ce5fiCNzYcMTUYf6tTmzg==
X-Received: by 2002:a17:90a:fa0b:: with SMTP id cm11mr18730920pjb.63.1630043086490;
        Thu, 26 Aug 2021 22:44:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 202sm4876969pfw.150.2021.08.26.22.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 22:44:46 -0700 (PDT)
Message-ID: <61287bce.1c69fb81.84e9e.df64@mx.google.com>
Date:   Thu, 26 Aug 2021 22:44:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.281
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 79 runs, 2 regressions (v4.9.281)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 79 runs, 2 regressions (v4.9.281)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.281/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.281
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee4959c91711d87bc57c762cd050804c04b08739 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61284ce3f287416e9c8e2c7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61284ce3f287416e9c8e2=
c7d
        failing since 285 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6128479365913ef8b78e2c8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128479365913ef8b78e2=
c8e
        failing since 285 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
