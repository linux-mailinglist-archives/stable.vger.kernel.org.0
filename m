Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE6623F5EC
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 04:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHHCTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 22:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgHHCTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 22:19:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26E6C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 19:19:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id c6so1882670pje.1
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 19:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=03PhEeUJfDbXO9qAAxNtT0Z8GrXHWYUH9YA64NlgEbg=;
        b=i4SFtQgiHFxcBGoGgO3LaUbdscP9fKq/4h5M7Id9SXFM38+hc79e3boHFVVDTH9Wjk
         4yZt1gnC6FuGVTlhdg4wp4eZmFwsUFAVl7XhYf8HTaM2Jnmkh4thnkJgARvBF1vIOwjT
         reD8u9NUmwWaZUrBNJb5he2xAUJXjR+1UiE/ZtvozpZUKS2oG5EMybXo+N5PPaeU2e5x
         OVaGDuFXZIla1/IX9pUcdU/YyZToiWZTtNj2TC88f/pDhGX00evP69F+mHsKACyo6VTs
         5kor947Qy7mJAZxmqT3RErLmgoFqqfEk5lwNbqvpFoSUDqPsX2fvIBq8bng1nmeN/MWc
         qghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=03PhEeUJfDbXO9qAAxNtT0Z8GrXHWYUH9YA64NlgEbg=;
        b=ryYLPGWUQbHZiOnzzPTAwSDBFHAqKQOnkQqb4IgIIxEO/lXG04hvqUmgOhDovobiyY
         X5KNzKLd8kipTEe50YwnrQCV8OMxZ3dSFtcwT1LVxLBuOiKqM46eOX9Z3xOa9yq2yQxR
         R6rCt8zLFa6eQcA+bpmWXSlfdu1D6ojldClSPq4IvwZ3AbTaxC5uyU5rdKk3l+Ii/syv
         Tw9OJ1/8i1VNv2QmAFUet+HcimtEyAXWsElGOIYAREO95yiJXAzmGrkGrC/xs+rKOugW
         O2+CgY/YKVsx3W6D3SNox0IQe579rotRm2CCedh0Fwpw4gkDUUJabGvqVn015S0oFVHk
         5h3w==
X-Gm-Message-State: AOAM533VeKosZEFfhqT9G415ndxJuwOao2ZxdpmRiHWklKJQ5MW9Taxc
        jufU0jBr36Mijddj2o5uOyQ88Lxh3+M=
X-Google-Smtp-Source: ABdhPJzu33rFpWbbBgmYZkOJUvPjo8YYiPtIMIHoqM1e6Ba+fct1/wIGAK9DKIM3BixyCjg8ywX1Qw==
X-Received: by 2002:a17:902:6b8c:: with SMTP id p12mr15403743plk.192.1596853142296;
        Fri, 07 Aug 2020 19:19:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cv3sm12902189pjb.45.2020.08.07.19.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 19:19:01 -0700 (PDT)
Message-ID: <5f2e0b95.1c69fb81.f32c1.e600@mx.google.com>
Date:   Fri, 07 Aug 2020 19:19:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.232
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 126 runs, 4 regressions (v4.4.232)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 126 runs, 4 regressions (v4.4.232)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =

qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =

qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.232/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.232
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e164d5f7b274f422f9cd4fa6a6638ea07c4969f1 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f25375230c715ecfd52c1c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f25375230c715ecfd52c=
1c3
      failing since 4 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f25375330c715ecfd52c1cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f25375330c715ecfd52c=
1cc
      failing since 4 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f253767c8a233ca0252c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f253767c8a233ca0252c=
1a7
      failing since 4 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =



platform         | arch   | lab          | compiler | defconfig        | re=
sults
-----------------+--------+--------------+----------+------------------+---=
-----
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5f25376945d323a85352c1ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f25376945d323a85352c=
1ad
      failing since 4 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =20
