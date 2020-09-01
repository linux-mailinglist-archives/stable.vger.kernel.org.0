Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B641258509
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 03:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgIABMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 21:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgIABMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 21:12:09 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E5EC061757
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 18:12:08 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o20so1694014pfp.11
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 18:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1dNsOai68X840z74WKz8lvHQF65F98eB3E8QZO3TBQw=;
        b=cgVmrbpKR7sXNAyQFj2fIJxKi8SqHoraEBzsrUUaF9qX/0h6CyircwDn+qcQQkWU9e
         IGhoGxxcGLOqxhmxnr0Qc4Y+H1QOwDE23c02Ky/w6gkqNsRvqcwM3Rks9ZOzP0PkKjML
         +0ZeIkcMwPU6yL26Q8/RmnElD+9GYCb/c/WvOlWjfDskIyx1JEfT/p4lsiGPWwAtDI3c
         fhXgfWETUL9UahbcPX67in77f5cfr4JqUeo6umaM4SF+s5F5YInTw8HIKGb8bC7cYTx1
         tG9MbEIMgpmPHR1Qup30pw1P7x20gS9DrfQnC0zTxyITq2NdhVJ32r7YoVU35bKWYCOh
         Wf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1dNsOai68X840z74WKz8lvHQF65F98eB3E8QZO3TBQw=;
        b=udt6+Cmru8Rq1lzz2AseXSIfdc2CVdZN0sQW3gKHlaN5agEAGLjiXO/x7AtfJnqv4y
         8kMPQBDYtPSkQ8MK6rrUjpJogi9lRaAnsvuD+rvrgEHTFkADmcSJwB9kpBI9O8xHYhz/
         bYWn6Pd07R0Vgtt1mAjXZSKd8FGRU0n0ovTvMJqBg9hj1+Vdh9gDWm4uxv9F+pL8zlrv
         RMjjU5e4x2Phe6ZXiuJsmzjVppScETx1SNNiG+ipOcfyMIAxpppjMnQZP3Iv2gmUROZG
         TsoN6OB+RuOKqX8HSa2e+u4j/4SxmaYF+W+sp+hXpsG2XP5ruwbV7xzMSVETdLs+6MoC
         sYdw==
X-Gm-Message-State: AOAM533/AuGKrTznQGzdWnFsaSvvReaIXsRtobgJXb35Bybe88iKOnrn
        8tjyOD/qZrqMtOj25vxNsLDsDmhxOpy/1g==
X-Google-Smtp-Source: ABdhPJzzecUwydczBxWo8gaKUm1W6NALxishZ8x0Zev+bQGYVgY/V3D22otpXv0WIn0TBvPRmJRSNw==
X-Received: by 2002:a65:6282:: with SMTP id f2mr2736420pgv.163.1598922727745;
        Mon, 31 Aug 2020 18:12:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n26sm9381536pff.30.2020.08.31.18.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 18:12:07 -0700 (PDT)
Message-ID: <5f4d9fe7.1c69fb81.c231a.e03e@mx.google.com>
Date:   Mon, 31 Aug 2020 18:12:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.142-119-g4547cc673028
Subject: stable-rc/linux-4.19.y baseline: 156 runs,
 1 regressions (v4.19.142-119-g4547cc673028)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 156 runs, 1 regressions (v4.19.142-119-g45=
47cc673028)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.142-119-g4547cc673028/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.142-119-g4547cc673028
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4547cc673028f0cfe15edcec3f1beb639ab919f2 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4d64b4d5fd34c21708118d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
42-119-g4547cc673028/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
42-119-g4547cc673028/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4d64b4d5fd34c217081=
18e
      failing since 42 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
