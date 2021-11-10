Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF3744C4C8
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 17:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhKJQHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 11:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhKJQHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 11:07:48 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825F7C061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 08:05:00 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so2240722pjl.2
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 08:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MSV+WW7x9px/ZKjp/OODwStM0iAkINas7/ZFqRC1nms=;
        b=dnUDRPKJltEl4LOcyEVo7sctse7f1F2gOlXtnQyO9xZ+JpOdBcBvYAEOBeIxvZT5KV
         y+diqgGHIhyKxT4KKUz9UfZaOQ1nW/b9scIK7KRKK8EOHaLr9I/TDsEIg+ZefzYJUD84
         ZEE0kQAOmBPhvgSn6GHIpfAMB2jRAAWLcQwz1XdpMsEtgJ+avXkkeKq+/ZQQG8YE078d
         /zjxI4nXCYGYOe0i9rdCFkA+sVJu1T9nXuDbPxJMtsF+r+up62GYYnt2jjjyhy3Dujso
         Zao/6rGd8Xwv2H4oU3xcuWm7dWAx4320D2V2cAeWffDmljnm5dvYjqtSnRNHCblINVth
         VV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MSV+WW7x9px/ZKjp/OODwStM0iAkINas7/ZFqRC1nms=;
        b=hbeBZBchyDFMfPU7SEIRuhPwW3eU6i+IcEbw8sF+v/K7UKlNtk1gToP3m3ci8xfr9O
         Wk5Enij7exchJeqKp3y5wKy3I/qUGJ0FJjHdvKkFvuu8XxxPNhf+u01W+ZZ9J4xdmTUT
         pwpF4EgKE2xTICEltzen7dW0oXC6fB+tTUj0ibPuDbE9EL8PVbybVSNlso7P7/G+4y+K
         4gqvI72k5AoF1DaQsxthdZXDiJt/Jjx29YN/d7XUhWGw3POTbG2/67l54yEHLvIT8VzG
         MSbhMvu6Qjt+qh2Wpj4X9EreGmHk/qpaolbDjE+cwA1YMJHEaPKuQ8rJ7EsjwYoAmOSE
         FiGQ==
X-Gm-Message-State: AOAM530mYatiBUTOmcJvYiGb3+qD/vuChMvbkqCEOxb3MOr78FGL5QL2
        TnQuQ4HY7U/LPcEkZ7GdILOgVMBI0p9W4yASMsc=
X-Google-Smtp-Source: ABdhPJyH+Al1ln4tP0vqB9cXyvKvNBPRJiOMBDzSMLLWkZwIcW7dCJcLU0NRkIQzSpXFBsc0afqTdA==
X-Received: by 2002:a17:902:7246:b0:138:a6ed:66cc with SMTP id c6-20020a170902724600b00138a6ed66ccmr464901pll.22.1636560299802;
        Wed, 10 Nov 2021 08:04:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lt5sm110093pjb.43.2021.11.10.08.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 08:04:59 -0800 (PST)
Message-ID: <618bedab.1c69fb81.a1ec6.062b@mx.google.com>
Date:   Wed, 10 Nov 2021 08:04:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-13-gedccd370d9d7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 152 runs,
 2 regressions (v4.9.289-13-gedccd370d9d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 152 runs, 2 regressions (v4.9.289-13-gedccd37=
0d9d7)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_i386                | i386   | lab-collabora | gcc-10   | i386_defconf=
ig               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-13-gedccd370d9d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-13-gedccd370d9d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      edccd370d9d79baa49bd1d444bfbb8b773f8fa4b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618bb3753c5007a57c33590d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
3-gedccd370d9d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
3-gedccd370d9d7/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618bb3753c5007a57c335=
90e
        new failure (last pass: v4.9.289-12-ga8dbc302bd30) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_i386                | i386   | lab-collabora | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/618bb2adbdd35db6873358f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
3-gedccd370d9d7/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
3-gedccd370d9d7/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618bb2adbdd35db687335=
8f1
        new failure (last pass: v4.9.289-12-ga8dbc302bd30) =

 =20
