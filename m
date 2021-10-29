Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C93A440435
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 22:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhJ2Uk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 16:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbhJ2Uk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 16:40:27 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377D4C061570
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 13:37:58 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id a9so413860pgg.7
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 13:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jwXPv5Sc7wekfiNt7GzneF3jObDCw7+oVfomQOWNJFA=;
        b=h3unqjztn/ghpKf/cWn+1ZsQ54h5K3MMqsNKaR84cTWOoSilgsPBrlxNl5h3KhH0Fm
         wWvVt83e6XqebVfs5m8l5jEh2cqILJH86P/Yyfdv+JeOF3COOVFeQy62jujijSEX8c7m
         Q6QFFVuWTX0S6rAtpp/h7MV9f3Zo+nk4Hk0WCW8gaOA699wugL88o5G6oD41Nbv8DHcD
         BrZC2sJulkTLNeNd+kMC+b7X33lFdB/jNjDH7FfGhnHV/uExtC8Ri5EOZ+KIm+glZQX6
         kJxm37MMkGMNox1tZYZrC/k1ekFFT0b6JyF+r5pi1MCWqnoFqJKVkDmNbT98DyP5Z2EV
         yiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jwXPv5Sc7wekfiNt7GzneF3jObDCw7+oVfomQOWNJFA=;
        b=UPJP11h66YDNfzeoneLLhM0m2mfiWnI/lkgUXNMcusyQ+vOdqCkixkc+OkXzIoZ4JA
         saGsNDviVilv7Y8SbFh+jRXf1La/qELzlT7V7HFYDgS7zfuQ1TL9gQogWIZA5RN0quhw
         I5Ol1aRyvBEOdtHjkfO/GZohf/DsvAIYHeZnHwYKL6M7Jkb1m44GhAlDOzR2yPqPM6/T
         58dDIZfqnmv0asOMHsrr6ccmsMoSZSdt3D+cQH62Da2Dnod+YNsm41Su4qREvGXcYB42
         n6BdNKuB7DSr9T9BV1Vz26Nb82R3x/6LsdlOxzisjp7ebemrBr1A96klrEBXsGz07CJT
         mZ0Q==
X-Gm-Message-State: AOAM530gIzkx3VC/yyU3IcYMrMKvwXtRde4nz8JJtb1ZSq3OfQAsJ4Hf
        3Kglx5VXIWsIDWT1d6dKygzF4DW66/IY8iaG
X-Google-Smtp-Source: ABdhPJyttcmhVBNTzwyAvFiSnKGPoIWTKSbg9l9qG4fkrnzIZO8JI5jydi+AsHXKFMX5pB7GNgCzFQ==
X-Received: by 2002:a05:6a00:1906:b0:44c:b35d:71a8 with SMTP id y6-20020a056a00190600b0044cb35d71a8mr13364682pfi.51.1635539877635;
        Fri, 29 Oct 2021 13:37:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7sm113107pjs.45.2021.10.29.13.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 13:37:57 -0700 (PDT)
Message-ID: <617c5ba5.1c69fb81.32576.087c@mx.google.com>
Date:   Fri, 29 Oct 2021 13:37:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.288-10-g8bcb3b51bfa1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 126 runs,
 1 regressions (v4.9.288-10-g8bcb3b51bfa1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 126 runs, 1 regressions (v4.9.288-10-g8bcb3b5=
1bfa1)

Regressions Summary
-------------------

platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chro=
mebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.288-10-g8bcb3b51bfa1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.288-10-g8bcb3b51bfa1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8bcb3b51bfa1390f2a15ec31569f21ef14d34cde =



Test Regressions
---------------- =



platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/617c28b1581d44ac10335935

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-1=
0-g8bcb3b51bfa1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-1=
0-g8bcb3b51bfa1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617c28b1581d44ac10335=
936
        new failure (last pass: v4.9.288-10-gf1357734f92f) =

 =20
