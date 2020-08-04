Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07FE23BDCD
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 18:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgHDQKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 12:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbgHDQJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 12:09:53 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B7BC061756
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 09:09:21 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 74so12352319pfx.13
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 09:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9cotI9bL9VbCJytaJmqcK5E9yx194rRRIOppBlIo82c=;
        b=1FNR0vCicQUUuMFElytQDA0MTv8JlQXuZeZuZ6nni/ijSP8oa2pTjPWRf+rdp9iOT2
         mZC0BZFvWD/MRt6JJWSta6jgCm/qhyvT1eJJlpuWzZfMe8iUcMcR7qFhRWqBupn675rQ
         feDCcfV0kEOCs44QQFOWrHsMFE40fllZ+KScL1AREOrQTbV43qAijREbV3bvTSbEiUrO
         YWPK+OsEmYuu2WvINb3sDUed159s0Ps5Z9LzH82PQUG/TvBUylwkhl2TlXpABPDJGwHD
         s5LO6kOP5HCwUHDTpRd+9tqaUIrySNlDxhX/V95UXyS8dW759OEI+8vUVNN7ZAFBjGoN
         kpjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9cotI9bL9VbCJytaJmqcK5E9yx194rRRIOppBlIo82c=;
        b=ABHBO+NzX+WhzNY6X2VowwcoRg9K0RkyIxtyRj9NekaPUhxnSv4QC8wkpRSx7gK4kd
         F8SN/DVwG++C4M6U0h1MOwOp8QOkVNQMnfbEhmcPgmFq7FxsoxUX8X5e/UGB05ls25pm
         w/FzB2ARy0L+wwcc/Cj8Z7dE0WCnGxaSGFaThkAi+ZlSyio4hB10HW5CJphrn0c37zMf
         WkalquinQmpLb41VeDkLW69IHnVAqlXNuCtnJ0jLqK7+dYX2euykpNzDbGy7dr+P5qZ7
         6iAlExrXuN/OD5AlYo448D64ZaIgG6lcfy8G58hGaBv4KYmzLiIHbTJFQBOr/K4w8r2V
         Wbcg==
X-Gm-Message-State: AOAM531tw3xgPiMvKfKBq0aGPKbP5qjFl/XSJWyetvVsUB0WhpSrZXzB
        rsIUAiCN0GqUN5IV7dzI63ucC2MScoU=
X-Google-Smtp-Source: ABdhPJwyW52gO8s9xxBW3jqFkxZO5gCi+jf/ZNA0PiZLzvvQ8mSf3jkzsbtg3URncyjcSlU72vI46A==
X-Received: by 2002:a65:6106:: with SMTP id z6mr20428049pgu.310.1596557359698;
        Tue, 04 Aug 2020 09:09:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id go12sm3011366pjb.2.2020.08.04.09.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 09:09:18 -0700 (PDT)
Message-ID: <5f29882e.1c69fb81.b8d01.7b17@mx.google.com>
Date:   Tue, 04 Aug 2020 09:09:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.232-30-g52247eb98ebe
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 115 runs,
 21 regressions (v4.4.232-30-g52247eb98ebe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 115 runs, 21 regressions (v4.4.232-30-g5224=
7eb98ebe)

Regressions Summary
-------------------

platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
minnowboard-turbot-E3826 | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config | 0/1    =

qemu_i386                | i386   | lab-baylibre    | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_i386                | i386   | lab-broonie     | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_i386                | i386   | lab-cip         | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_i386                | i386   | lab-collabora   | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_i386                | i386   | lab-linaro-lkft | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_i386-uefi           | i386   | lab-baylibre    | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_i386-uefi           | i386   | lab-broonie     | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_i386-uefi           | i386   | lab-cip         | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_i386-uefi           | i386   | lab-collabora   | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_i386-uefi           | i386   | lab-linaro-lkft | gcc-8    | i386_defco=
nfig   | 0/1    =

qemu_x86_64              | x86_64 | lab-baylibre    | gcc-8    | x86_64_def=
config | 0/1    =

qemu_x86_64              | x86_64 | lab-broonie     | gcc-8    | x86_64_def=
config | 0/1    =

qemu_x86_64              | x86_64 | lab-cip         | gcc-8    | x86_64_def=
config | 0/1    =

qemu_x86_64              | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config | 0/1    =

qemu_x86_64              | x86_64 | lab-linaro-lkft | gcc-8    | x86_64_def=
config | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-baylibre    | gcc-8    | x86_64_def=
config | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-broonie     | gcc-8    | x86_64_def=
config | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-cip         | gcc-8    | x86_64_def=
config | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config | 0/1    =

qemu_x86_64-uefi         | x86_64 | lab-linaro-lkft | gcc-8    | x86_64_def=
config | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.232-30-g52247eb98ebe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.232-30-g52247eb98ebe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      52247eb98ebec43288b5da7033c5b757a6fbd1d0 =



Test Regressions
---------------- =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
minnowboard-turbot-E3826 | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f297f81cf7ae6576952c1a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f297f81cf7ae6576952c=
1a8
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386                | i386   | lab-baylibre    | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29506f94817b704252c1bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29506f94817b704252c=
1c0
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386                | i386   | lab-broonie     | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f295220bbabd1767452c1b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f295220bbabd1767452c=
1b7
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386                | i386   | lab-cip         | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2950933aaa4820d152c1b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2950933aaa4820d152c=
1b7
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386                | i386   | lab-collabora   | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29506f2dc71646c352c1b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29506f2dc71646c352c=
1b9
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386                | i386   | lab-linaro-lkft | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2950602dc71646c352c1af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_i=
386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_i=
386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2950602dc71646c352c=
1b0
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386-uefi           | i386   | lab-baylibre    | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29507194817b704252c1c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29507194817b704252c=
1c5
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386-uefi           | i386   | lab-broonie     | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2953775f7f8496f152c1ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2953775f7f8496f152c=
1ad
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386-uefi           | i386   | lab-cip         | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f295195383426f64d52c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f295195383426f64d52c=
1a7
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386-uefi           | i386   | lab-collabora   | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f295071f8bc2281df52c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f295071f8bc2281df52c=
1a7
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_i386-uefi           | i386   | lab-linaro-lkft | gcc-8    | i386_defco=
nfig   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29506094817b704252c1bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_i=
386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/i386/i386_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_i=
386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29506094817b704252c=
1bc
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64              | x86_64 | lab-baylibre    | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29503123373a1d5552c1af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29503123373a1d5552c=
1b0
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64              | x86_64 | lab-broonie     | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29522108c809892552c1ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29522108c809892552c=
1bb
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64              | x86_64 | lab-cip         | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29506c2dc71646c352c1b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29506c2dc71646c352c=
1b4
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64              | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29502d23373a1d5552c1aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29502d23373a1d5552c=
1ab
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64              | x86_64 | lab-linaro-lkft | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29503423373a1d5552c1b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29503423373a1d5552c=
1b9
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64-uefi         | x86_64 | lab-baylibre    | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2950352dc71646c352c1aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2950352dc71646c352c=
1ab
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64-uefi         | x86_64 | lab-broonie     | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2950cdfef9ec0e2752c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2950cdfef9ec0e2752c=
1a7
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64-uefi         | x86_64 | lab-cip         | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29503035212af82652c1c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29503035212af82652c=
1c2
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64-uefi         | x86_64 | lab-collabora   | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29502c35212af82652c1bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29502c35212af82652c=
1bd
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =



platform                 | arch   | lab             | compiler | defconfig =
       | results
-------------------------+--------+-----------------+----------+-----------=
-------+--------
qemu_x86_64-uefi         | x86_64 | lab-linaro-lkft | gcc-8    | x86_64_def=
config | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f29503235212af82652c1c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-30-g52247eb98ebe/x86_64/x86_64_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f29503235212af82652c=
1c7
      failing since 0 day (last pass: v4.4.232, first fail: v4.4.232-33-g19=
1818eb5a46) =20
