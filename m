Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524143CF1BE
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 03:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbhGTBPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 21:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238675AbhGTA7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 20:59:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3786C0613DB
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 18:39:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id y4so21044648pgl.10
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 18:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gGSxN8iIEkfEv2brn4mnN3WTTFjRrFo96TaJ0FWogBo=;
        b=waU/PEPdeXoNGWKXHIL4WD42EOhwtoZmQAfoaoBq1RxfogLScFy+/wHGtM09BnyC1U
         +64c4i1F0u4iiVnQvkgaBz5+PS5Bhvf8KmAXHr5pHu0yHGPRFjjs34rZKD2MwuqWjlSV
         CRvI7zMKojWuevtK8DRyArXfa9xAE5NmGOEtHkzOhICkXi++PSF/tAPkfo2qqWeWSb2o
         +beIzACNHO8avLVREI9C98ygl/siJE5eEAsNC6YSSozJPjx0Npc2/S2/Aza8SrYZTOWZ
         GLUH/yZE+16VomydiKZpTh6dkw7AQMpNnzO1qw6olollN6e+BiTBfEe+FJnpd3/zmd4C
         WF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gGSxN8iIEkfEv2brn4mnN3WTTFjRrFo96TaJ0FWogBo=;
        b=iXnoynZanRN9ryfpmTc1oXgmX4MpB/fjNpa1GK3QY4gdwNTHuIwifJADc7G0OgZRlF
         VH61LQHuT08PPu+q4agkkOSfGvUdYsmcg0VYwzSvZdkJc77fOyv9bMCbYwSClK/jPyTA
         osGcZgKrNUVKYIssGjjY4pP3uowOadDbUM4VJkXI2QNk51sq+4tHDYDYjpqnJJWwyOYr
         CCn0i6BM8MyUvQrIuYp28rkRMZUKCbTfPor9NAn467MGQGKXP4Qh55IU5ZZQRwceccDm
         +9SMrBK/RbeU8bITQGrpZLnYfWYsZPKn+PkD5tak96GQsYiXgm6GlP+IpQVaZqouAgdZ
         M5Jw==
X-Gm-Message-State: AOAM533t4a48WhNkSaw8QODzf8vFwJJ5ObQub7MIJaRpKpF8mAr4+ne/
        jTfst6pHD/JEvjaXPS39ITwvrWcNSn6fKw==
X-Google-Smtp-Source: ABdhPJyQdgNnEVxU3Cgf7IBDDkd2pVyCAbYOOjJDQx2u1UXhSI4333DwIBThFKW6kgqBfPdDF0pXtQ==
X-Received: by 2002:a63:e947:: with SMTP id q7mr9885015pgj.324.1626745186426;
        Mon, 19 Jul 2021 18:39:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n32sm21058769pfv.59.2021.07.19.18.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 18:39:46 -0700 (PDT)
Message-ID: <60f62962.1c69fb81.c203e.fbf7@mx.google.com>
Date:   Mon, 19 Jul 2021 18:39:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.51-239-g0625d8e48998
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 194 runs,
 2 regressions (v5.10.51-239-g0625d8e48998)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 194 runs, 2 regressions (v5.10.51-239-g0625d=
8e48998)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.51-239-g0625d8e48998/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.51-239-g0625d8e48998
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0625d8e489988dd0bd3a5f5d302172fc64fcf09a =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/60f5ef090b5ef121f21160ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g0625d8e48998/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g0625d8e48998/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5ef090b5ef121f2116=
0ad
        failing since 8 days (last pass: v5.10.48-6-gea5b7eca594d, first fa=
il: v5.10.49-580-g094fb99ca365) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/60f5f1daa37a5872ca1160ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g0625d8e48998/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
239-g0625d8e48998/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5f1daa37a5872ca116=
0af
        failing since 8 days (last pass: v5.10.48-6-gea5b7eca594d, first fa=
il: v5.10.49-580-g094fb99ca365) =

 =20
