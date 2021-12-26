Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4A147F513
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 05:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhLZEBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 23:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhLZEBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 23:01:17 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F85C061401
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 20:01:17 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id jw3so10610647pjb.4
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 20:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CaXd9tLhwyF4b1Cw2SRJQHcM0u2wRdFuwmiJ05U6qRI=;
        b=KaqKWX2pb2HXd6f+Cr52gu+Q1cEJWGXxr/z/+7lkI/3/zzMokyEln4dDOfvVSbmxNs
         6Lvyz3AhMescOCzNgQU+xX+uaEjsaEMBvEWMuLv4XtGFv3WwE410RaITkUNRU+2oi/ih
         jfOgx1qlGH7V+KeKAUU8XLxIymToAx7hZpswUf8IRHt8rM9NM4g+8zBqacd/QEwxQ84f
         JeyneCsx3VNftf9PfSD7jKafb3ZrHDsVipq0F8zSPvCL/an7y6poLHFXArdwSDEzsatU
         imVT0/mcxFgA1uB8Tg58C0wkzHRe0WNrRIxbog/98N3ufZ7QslLF9j0aPScwigGhG5OM
         h9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CaXd9tLhwyF4b1Cw2SRJQHcM0u2wRdFuwmiJ05U6qRI=;
        b=ZHJZXk/2azWiwFgbQGLE1Am2c/v5aQSfPWOjljpGl85ZIsBSop93jcomUXxm/uYNoh
         6lwLS82PpNmHmGo6+S5WufMOOWvWJX6YW1IdkVbqSog05jgNYSAxa+kHjbGnnA5U2N6i
         GoJpEWO2vCCMRQT/zWrsJRSzmqCLLY/4ymTYng6jdoexyyZ4bIQKc4rQhDV9Qdx8sivt
         KFmHXMkJB25leFzP/FmTv+UhzcBXoRaF5WqVWMRh9nL3rAZ5EkVdhffsfOBzAfFCVb+i
         yMFXvmqF2OYGPJF8wG/rwGJ9lOD5eQg7WsnGpDnB5jaw+UOHUbevjM9o/Vx4zwGHio2d
         leEA==
X-Gm-Message-State: AOAM532qUC5QZd5l3CoeNFPbY/RPcQwRgFlaZj0tt/EuHgrQ7vdTvYe7
        OMmv1Kq8Vlgx/Qw+iWAikDEAi462wqxsQZn8
X-Google-Smtp-Source: ABdhPJwTww5W+UIh4ASsK9gkchAZ+YGP7uQwvN2ZFplkzHrwt+u0rKleZLA282opZxDvwOsxpkxlkg==
X-Received: by 2002:a17:90a:b014:: with SMTP id x20mr14808159pjq.43.1640491276696;
        Sat, 25 Dec 2021 20:01:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e21sm6788632pjr.5.2021.12.25.20.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 20:01:16 -0800 (PST)
Message-ID: <61c7e90c.1c69fb81.47c25.50a3@mx.google.com>
Date:   Sat, 25 Dec 2021 20:01:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.294-8-gdf4b9763cd1e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 143 runs,
 1 regressions (v4.9.294-8-gdf4b9763cd1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 143 runs, 1 regressions (v4.9.294-8-gdf4b9763=
cd1e)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.294-8-gdf4b9763cd1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.294-8-gdf4b9763cd1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df4b9763cd1e19cb238b3ea65d3257f1e10357c3 =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61c7bd35b3b230f37939712f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-8=
-gdf4b9763cd1e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-8=
-gdf4b9763cd1e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c7bd35b3b230f379397=
130
        new failure (last pass: v4.9.294-3-gf62d2edb6c14) =

 =20
