Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CC23D714D
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 10:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbhG0IeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 04:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235988AbhG0Idy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 04:33:54 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DF1C061764
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 01:33:54 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f13so4464716plj.2
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 01:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GIZOQvXbF5o8PdZVK4EaWKCkl8gRwt+o5vlxGHWWW6E=;
        b=ot/FX8TN15GkfW5XKhTD7GI9nVJhzFgWB0IpNCahxE+JWdlwsiOT1AM5M1WU2Y7fUu
         YgGmy0vGiY2JFfBfl9qN3n56dGZu0m7FXdiTNAfWvcUBOWzdinzMUE4HvySpC9KaJTbF
         uKk6hWBGwFncASaJTX5uNtKZLgkIrOL0Ln1zMqj+7Y2aGn6sk9iUvFUZohRUaZJZcKu1
         sU6JXodXZ6hIKZjFJ2w2bENvEdSJSAFLjnjtS2vpPtjDdvsOkrv95K6uBr//MzI5+Ryp
         /NC51jiCJmbLq5wvoiLSJNQz+RIRzWJ51PxCvMiTTVEhKBy8E1VWC8gjjqlc1lhJ0JhJ
         GnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GIZOQvXbF5o8PdZVK4EaWKCkl8gRwt+o5vlxGHWWW6E=;
        b=REgsKlR5bESZPNL/c1cSFSWrEcG4b0UGDfPElq2XKNlet+3qcPeGfW8qiEsPoznCtG
         oaHR0k4bMRdJxMDV8dn5lTnLflQyMUP4uZ7tSGsHRTJftF/AGpeQyXqi2/Y8EiwyXkQn
         pKVlv5bA9Fg4euv0ZbpwBE/QhNf0fO0s2eY+c9isr7YqbDnVdqeW3a9epZ+Tp4698k2A
         hqs2yK2Mv+E77mUVCsBKePPyRbZTmZQoSJQjF56//uKN8pGJi5PBy2U+ETjcPNVLtOBa
         aviuXrw6QB6sgxEedwFcAEsF5raQqb4YctCvwYVgWiEHX02RTPjx5upCUiDozRe4r/ak
         dUkw==
X-Gm-Message-State: AOAM531TtOXu5Ct/7ezSYkFO7O3cawF9yemlffflmBM8AmUVzKrEQY7X
        rkpbrH/tYlzmoo6/Z9K32nIrkbBwjaa/qmIH
X-Google-Smtp-Source: ABdhPJwMQq1VdhKKwa52Jis+3Bufc2fzZ+mR5CAqBeGwIDX+gvF+dxAV/s/hzH9AGwGG+kGQns6SpA==
X-Received: by 2002:a63:67c5:: with SMTP id b188mr22337577pgc.333.1627374833305;
        Tue, 27 Jul 2021 01:33:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g3sm2605195pfi.197.2021.07.27.01.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 01:33:53 -0700 (PDT)
Message-ID: <60ffc4f1.1c69fb81.b37a5.88b0@mx.google.com>
Date:   Tue, 27 Jul 2021 01:33:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.53-168-g25be65e302a0
Subject: stable-rc/queue/5.10 baseline: 126 runs,
 2 regressions (v5.10.53-168-g25be65e302a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 126 runs, 2 regressions (v5.10.53-168-g25be6=
5e302a0)

Regressions Summary
-------------------

platform  | arch   | lab           | compiler | defconfig                  =
  | regressions
----------+--------+---------------+----------+----------------------------=
--+------------
d2500cc   | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =

hip07-d05 | arm64  | lab-collabora | gcc-8    | defconfig                  =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.53-168-g25be65e302a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.53-168-g25be65e302a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25be65e302a06c1593f55a1c29aeb74501fd0a7b =



Test Regressions
---------------- =



platform  | arch   | lab           | compiler | defconfig                  =
  | regressions
----------+--------+---------------+----------+----------------------------=
--+------------
d2500cc   | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff93a84a57aef8d93a2f43

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
168-g25be65e302a0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
168-g25be65e302a0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff93a84a57aef8d93a2=
f44
        failing since 15 days (last pass: v5.10.48-6-gea5b7eca594d, first f=
ail: v5.10.49-580-g094fb99ca365) =

 =



platform  | arch   | lab           | compiler | defconfig                  =
  | regressions
----------+--------+---------------+----------+----------------------------=
--+------------
hip07-d05 | arm64  | lab-collabora | gcc-8    | defconfig                  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff9292525080862a3a2f5e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
168-g25be65e302a0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
168-g25be65e302a0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff9292525080862a3a2=
f5f
        failing since 25 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =20
