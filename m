Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAE2263A21
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 04:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgIJCVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 22:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730794AbgIJCSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 22:18:35 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28359C06179A
        for <stable@vger.kernel.org>; Wed,  9 Sep 2020 19:18:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v15so3407661pgh.6
        for <stable@vger.kernel.org>; Wed, 09 Sep 2020 19:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5shsgbtB6tFE3KNwQhwlUNFOwNLrfPdHlMYlWXtXxM4=;
        b=kQkp11R3aKCDwX0I6jLxB4Y0tJWq6f8zfVJFhLxh0gRxLiPZyppZvX9JeXqBcS83Rz
         gIa0d/u6wPPAWfzShUvUr0VSOgHmp3UXD8P6eP9+JODm52M9gzcf6dM170vGWe46qSWM
         J88kERQF1DOIhsj5PkVTsgVdkuOxHHCh0JOuiPQdpOTLT8Yp7tvGgSgoijD1tXu/Usvy
         /OxuQPh4CD/SiZ9nWfpCWuEJTMJhRCwyvR5rfr6ecLbr0qql3ejqCZr8AuszV8hD/NON
         bMxTgqSR2CwUNtGM0AAAI/+33tPQ+l/UWXgKcV1RXmjYIGgYeY47Enk6ZLHHE3UrKB8D
         ZfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5shsgbtB6tFE3KNwQhwlUNFOwNLrfPdHlMYlWXtXxM4=;
        b=o0XXIBs7OrB5Nux4HHREvmKFbasLx5sY5NA4hn2i/KW1l2/s7jUzyIgcqhpM5SW7p8
         +kr1KhzhzKKt3cyxnn5PBw8Y09/2Na00cyazldHwEsAaO5nsVjP98izXIP5j20LoU4B+
         B0A1vk2neT5FI48CKa5ju0dDA1KZjwH19c45TbsaluqtnaDdKMIUV1A0H00yYLjt5fEB
         Gal7RQ35ZNvOWgB39X8KMucakJ/hyMnAdvIUmJCOBbDH5YlJ51oVOEau1T3yk3aPQqVF
         ZM8FS2Vjld5sJRIFSbHkWonaXiDj4Nf+aS1w51vREDd29ggVkA0gZw/GXkgnYQ/gP/h+
         FdfA==
X-Gm-Message-State: AOAM533N+/r7GYKaLp/F/qik8pCctDXE2u8OvnWuC5kORkbksEFGd6Vc
        5uGjRwFwwxxPww4DhgMcLmC341iBAQ3ArQ==
X-Google-Smtp-Source: ABdhPJxUUzbgnQnOwWu2VPA9Y4xwc7+OF8GQzCaadlpISbVMrR3oCybLshvMIboV8bCNnU4hhsr6EA==
X-Received: by 2002:aa7:930a:: with SMTP id 10mr3286071pfj.91.1599704310443;
        Wed, 09 Sep 2020 19:18:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k6sm3972320pfh.92.2020.09.09.19.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 19:18:29 -0700 (PDT)
Message-ID: <5f598cf5.1c69fb81.f8cb9.b9ff@mx.google.com>
Date:   Wed, 09 Sep 2020 19:18:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.144
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 169 runs, 1 regressions (v4.19.144)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 169 runs, 1 regressions (v4.19.144)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.144/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.144
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      67957f12548c785d0e0b14fd104d2297f3a71835 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f595a623fbc080f8cd35370

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.144/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.144/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f595a623fbc080f8cd35=
371
      failing since 55 days (last pass: v4.19.124, first fail: v4.19.133)  =
=20
