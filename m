Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A56326381
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 14:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBZNrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 08:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBZNrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 08:47:10 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A449BC061574
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 05:46:30 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l18so6123328pji.3
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 05:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z6AWZADoOEBWldzmpcMbcaCPHVJi1yLCO6SjsHXUcF8=;
        b=RQ23o9ECuKJtENnyawRSqNpnozUqRaa6c6C39HQdUv90ajG0Zxx2XugTOcSZddxjaQ
         hv4OxR5+A0pXNLnaJzq4IGAzd17svO/czLRp+X/pQZ8MjihLr3C2QD6KdxIYsGVNRgFn
         v5HOZ+KjvJnm8YQAqVlhXXOSSrg++8fb6O34qc8KVwmZBGAPs8gg7f/Aj7AA4SfySfjk
         +z7gAUX1+dwxkUKNMHWg1zjq5/tfnt2ld6/B7RY18Hi/JmosAftI6isemhA7CGBPUUU7
         xsN/02RDnnHdZUpPi0a2glG8vUqNdlya6W1ErOseuFAZA/uqVCazdKv1IHyn1jbC34k2
         d3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z6AWZADoOEBWldzmpcMbcaCPHVJi1yLCO6SjsHXUcF8=;
        b=Pb8vyps7/CXHP3kdL4j3trjJGs6Gd8W+oDBAH7vhK1XsBItGi1dYXCXP2Q+fdigTiB
         MxRtPutoHJOu3pRFQ/3L5ju5hqjOG5RHJ9KhNjcGC6RdJoafkQooSDEwb/qVBQa3+ebW
         DwNzwrfGet2U4AfH1tf1WZDEYmUscY8IGSQkS52q6ubXIlEinZ9jMguxbgs8I25Ad8Bk
         PcRKS8ZpbEbb2vN0f51je/3OdzUmI/n/qsa/D1ROeU0z5lYgC1hhfCvVPWiSpLucP3N5
         4vvhphe46lXDr/k+JTcn08TINIasgdP6PAgKmMKiVBrSqApJnZrmRaawlraa0Mn+1sNy
         UvEA==
X-Gm-Message-State: AOAM533LopBIBqcuDxzX8xmFVppO/n0KUQzwAUkFfyruCmZq46/ffWhL
        bvAVAwvyu0cYve30sthqPLu/yAevOsuKRQ==
X-Google-Smtp-Source: ABdhPJwZ50p1ooeC9J1+K5bJiV2yAczl/AKjydBbwP3WwFrcxOGm1gBsyBio/QX63Tpg1gFMgK8t6Q==
X-Received: by 2002:a17:90b:1213:: with SMTP id gl19mr3517262pjb.107.1614347190091;
        Fri, 26 Feb 2021 05:46:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y23sm9614345pfo.50.2021.02.26.05.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 05:46:29 -0800 (PST)
Message-ID: <6038fbb5.1c69fb81.3ae1.5759@mx.google.com>
Date:   Fri, 26 Feb 2021 05:46:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 109 runs, 1 regressions (v5.4.101)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 109 runs, 1 regressions (v5.4.101)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.101/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.101
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ef1fcccf6e5fe3aabe7c3590964efac6d5220c43 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6038c75dece216906eaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.101/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.101/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6038c75dece216906eadd=
cb2
        failing since 99 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
