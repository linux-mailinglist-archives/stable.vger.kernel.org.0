Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8F13D70BE
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 10:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhG0IBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 04:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbhG0IBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 04:01:51 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3B1C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 01:01:50 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id t4so6524291qvj.0
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 01:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W8tSc6z3BteqyHJAY2vC13IKZO8184DEIqt3da2TcQM=;
        b=fsw4XPeHNyxVujouPJGLqT5JsYRwJsjZ/CsUelUnGgh2vuD14mSl/1/rEru/idZjJv
         J1sg7yHY9tDBHO/gPAzz1jgBEFpQyYf1kaFcrutGG5ZaRcBi+fOhY1EfIohhtbyZwjV8
         XJGzCC1gfqjngoubGQTLQPFtre3IsJ98ZWjO8TLZAvyVD6ng3NjkrOoWTHscK7Ne3pkv
         toSs+dnfJAnGkoXaCbzicm4lFGw+khkIvkV0LfPooiNQ9FIvIUAXiiN68XkvddCqCIBy
         Q5phCQBvB3js5o1DHTzaIzUAtAe9UfInUk5lMygFoutvN4TUMFjqHReD+VdwG+xOjGlp
         fhaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W8tSc6z3BteqyHJAY2vC13IKZO8184DEIqt3da2TcQM=;
        b=FGU1mJtX8ZiSV4mo5t9kZ5fymDPAOVKWu2x+IZ96XXXVo+oNpzeVrajcN2/WBly2u3
         yrNoMxySrEnpR/5B5UrqeAeaWRe7Srw0xuh3O1HmPniyc+eZcqUplZP4ZHkKZCriIR3G
         TWu4aSi13bo+xzc21q+0D55WqzucwXdeTHno26eWvUR9K/0ZQA8vB6kFNOcA16+NQT9r
         LMmUMbPVrPh9j4e5DtOsmxk4Z2Q5MUCi6qpNDMPkaim9Z5xn0EuhISlFhZJbjF3UT6A6
         eLySr9pgrliFDCZBedTL8RXoAT6cScRytS9BpRmaq+/3ibiC6/Qn6uVxXQYmgzvDcpgP
         Wytg==
X-Gm-Message-State: AOAM532CuHmGvoKwcS9lhbKuOUwCTrvRMtbodN3iDpifFAhjxOwOPRkI
        XSy4kUJTxT6eSTp0kildx2bJ6eC/VgloeE87
X-Google-Smtp-Source: ABdhPJzhsljyaQXNbbAN+48JFEYLvUkftkzXy5mGlA6+RGdex9rOYsB2eGCJZaP/N4AO/7K11iTCZQ==
X-Received: by 2002:a05:6a00:14d5:b029:395:fa70:2525 with SMTP id w21-20020a056a0014d5b0290395fa702525mr10652575pfu.1.1627372899262;
        Tue, 27 Jul 2021 01:01:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c12sm2519889pfl.56.2021.07.27.01.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 01:01:39 -0700 (PDT)
Message-ID: <60ffbd63.1c69fb81.2b9db.85cb@mx.google.com>
Date:   Tue, 27 Jul 2021 01:01:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.198-121-g85cf6e2446d4
Subject: stable-rc/linux-4.19.y baseline: 114 runs,
 2 regressions (v4.19.198-121-g85cf6e2446d4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 114 runs, 2 regressions (v4.19.198-121-g85=
cf6e2446d4)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.198-121-g85cf6e2446d4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.198-121-g85cf6e2446d4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85cf6e2446d4e4ae3ad30707c2f88ed2a437ba2f =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff84279de20d18583a2f25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-121-g85cf6e2446d4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-121-g85cf6e2446d4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff84279de20d18583a2=
f26
        failing since 250 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff840e108a8bf7bc3a2f4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-121-g85cf6e2446d4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-121-g85cf6e2446d4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff840e108a8bf7bc3a2=
f4e
        failing since 250 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
