Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2253E2ECF
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 19:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbhHFRQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 13:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhHFRQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 13:16:57 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2389EC0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 10:16:41 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d17so7910045plr.12
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 10:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l2d0ves+9G1JEzEuTXOOKZ/5gKBDoeqPUGANyJMAvOw=;
        b=QdVUcCoGsRw7/t2Tm2xMlJbxFLnLLlzKZ+LzpTOhJ3yd1bNs+IfovGXkkDign1dpUb
         uaMxs4SBdVwuDL3NNrvf/PRFMO6OPacqEV3h1ZxqAzgMLbXA9OM/TfZ+ypqiCgyGtCvx
         T3zlS7Ns0pjBg9W/7qgtiYELolOPEm5/wn6OzIYE+bMtjYBtBxqeN3b51vc1/dMgwgFn
         2rOINO7kQ0WMEtxfFcsRQA4UEpg+6vx0ZS5HdPRTdkkKt9KKxJxOUSzl6gm4DQp/B0Fl
         g0YbQRoiHeJLqWGJkOD+w/AwRy5RrJAiEaxms7IMb3KciRMhThlvnemE6cGEFq9rMKRQ
         ehgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l2d0ves+9G1JEzEuTXOOKZ/5gKBDoeqPUGANyJMAvOw=;
        b=iZZSJwCW1dtggw947E81O8RtibLFgwHSW/GVmlpslP2Gh5IvZJ7RMuz6XeWHCa802i
         U3ltB742cmYgxcSUw5sOPYP+GuzPAm6xA3GeAUk6xmdhjFRBHawy40TJWZTSgsnrdF3V
         wmbdTAn2YO2/sXr/xPj6vHsWmfseJ6Sr9/0U0RQ/4QwqPzqrdIDENx2hs5xWEQW0uZ0h
         GTJYNGnMMkujK1kUtjwzBjt4nY0yX+I4gSDZCc8LJRTlVOFDzKTR5sVwjbilFWz8q6lw
         r0IVN5hLvs0mN6jQ34ylw54+MaKlGOqi+s58ust3eSpLaXVBZTdkKuU4NICFcCyYkhKc
         PFvg==
X-Gm-Message-State: AOAM531Ya5OUDij1yXDLfpxvS/BuwmPNwuLIPYqSc9/6DwWshunnooRY
        4ZZcTtApkfx1orf3ixsIoEkQgzkfjyxRhQ==
X-Google-Smtp-Source: ABdhPJwe3pDeSChjpskou4Yx6XxnFj+a49e+hjBy2E+ehk/H9l13iYGASsM6rM4N08PygqBVl/oQeA==
X-Received: by 2002:a17:90a:1b22:: with SMTP id q31mr11442073pjq.217.1628270200435;
        Fri, 06 Aug 2021 10:16:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c14sm866759pjv.11.2021.08.06.10.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 10:16:40 -0700 (PDT)
Message-ID: <610d6e78.1c69fb81.dee69.2ead@mx.google.com>
Date:   Fri, 06 Aug 2021 10:16:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201-17-g9c68cf432f4c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 102 runs,
 2 regressions (v4.19.201-17-g9c68cf432f4c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 102 runs, 2 regressions (v4.19.201-17-g9c6=
8cf432f4c)

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
nel/v4.19.201-17-g9c68cf432f4c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.201-17-g9c68cf432f4c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9c68cf432f4cb6091ecc834b0e3a729892247335 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610d34ab938f70c09ab13692

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01-17-g9c68cf432f4c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01-17-g9c68cf432f4c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d34ab938f70c09ab13=
693
        failing since 261 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610d3469309f31cd84b1368a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01-17-g9c68cf432f4c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
01-17-g9c68cf432f4c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d3469309f31cd84b13=
68b
        failing since 261 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
