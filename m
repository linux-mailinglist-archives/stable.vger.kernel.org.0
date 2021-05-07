Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D294376865
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 18:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236482AbhEGQDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 12:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbhEGQDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 12:03:08 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368CAC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 09:02:08 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m124so7429162pgm.13
        for <stable@vger.kernel.org>; Fri, 07 May 2021 09:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1FyHa12qEYs/yGIhhY8jyts/9jKKEabGs1tfKuAthRU=;
        b=aiXkaYJXdMGCOZrIQoUviu8Ls27Xo9oYUTXGS4w7c/FZ/25tBlVT1vmwZD9MkUqJvr
         nIvicNDCVxiZNQAek3O3ml4W8skYnO3gjMI/xVTrtErb0R3i24shzH0rIRYFq0yCdSDQ
         Xz2JNW/htPNktuHGJ6IGjY0nYhW6LRhRR8l7q8/J9veX98ppnPUrVIpNwisvltH4+/AN
         axXQhVQF+owTt9JsBX8Mue3lNQRnBo7WWYyf/+QRQVKBzIE4Oif9eAWXduZcNCQA5YfX
         gZgOpyaPKOwmf5SpY2bUn1VuJZDbMXSaZlPPGdSJ3Dv1gJ3z/2VUj2IgNerTrwPaz6La
         YJNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1FyHa12qEYs/yGIhhY8jyts/9jKKEabGs1tfKuAthRU=;
        b=gehVDpBPj+2JtFiHqFYP5IhlKe2bZBYUqPE67lJoL7/5LTX4wUTlDLkbA0qw+B5QP9
         8XTBJ5FQdO9J4MrGeNj+IlU5e55rjxdfa/FkGoOIAQOBXWLDOsL7J+iLpLTjlczeQfar
         ZEsINpKaezNkEwjjKdDdC5+d35897+NIh/5qBVbIh/J7t/RYj6LPJ9xq7z53A9Kw7ZLn
         90lL3bDO1nGw1HFe+z/3B3NJqnQ4/1Zm3cK250CI4zFuoLvi56J58/qXM/pIFlDo5TPe
         qX7u37tgOF1uwBKetPKPuFdXammgWSKKzGPrRoVFoIR/xH+7DvzNNMZOGXJcAWcLwGDZ
         nDIg==
X-Gm-Message-State: AOAM533tnACh0S2mM9hhFLBVpcxSDc6qNWxI6JFuWnggVlo2bZpNAD7h
        Nmd8MMbYGCNQSONyJpIwKF5UT8wUPA8N9dSr
X-Google-Smtp-Source: ABdhPJyuWgV10H9upYCXc2L9Ir5JdHA0+YmBoovMLOWmDwaXt16TjYRess7Crp0QWrsHaReaGEBwKw==
X-Received: by 2002:a63:1213:: with SMTP id h19mr3283960pgl.139.1620403327557;
        Fri, 07 May 2021 09:02:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm5184414pfd.66.2021.05.07.09.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:02:07 -0700 (PDT)
Message-ID: <6095647f.1c69fb81.57759.f9e0@mx.google.com>
Date:   Fri, 07 May 2021 09:02:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.1-15-g33676b89fbad
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 104 runs,
 1 regressions (v5.12.1-15-g33676b89fbad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 104 runs, 1 regressions (v5.12.1-15-g33676b8=
9fbad)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.1-15-g33676b89fbad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.1-15-g33676b89fbad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      33676b89fbad74547a2d22e7415d013017f1e521 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095341429f2e6938c6f5486

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.1-1=
5-g33676b89fbad/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.1-1=
5-g33676b89fbad/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095341429f2e6938c6f5=
487
        new failure (last pass: v5.12.1-15-ga774705c7703a) =

 =20
