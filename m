Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA1131AD92
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 19:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhBMScJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 13:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMScI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 13:32:08 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD313C061574
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 10:31:28 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d26so1662428pfn.5
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 10:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OghkJK6O1dqfXTdXeawll5Qqv8bgLqtQOk+Ns1n/2BU=;
        b=0L0mf+x33dofF9NBj3o5cwdFZ4vb6VwBHZp7VU4061ebVHtxaDOe+DlWD0zVvTcfYX
         5BaaEas27JaiANU+54oEK/4IcpPHdWf6Yi/RjLQatpfn8xDAeJh/wugP68j1gyhXKX0G
         gb3UeABJxocUwwwqSZmnfzlcgmZh9R1wlKKH1WiHNuvQJhXPeZfkhofvjcwTB1eqRJ62
         W/AKjB4adUmgBgHgsd0y9ymVflumIFKAFxA0gIHaJXMhLDkU1HKEBXDE9ZPC9DCkgife
         Pm2K67c+gQlPowc8MMNH1dLkeK4M+s4lm3ZXLE6GIdpMMW/iw52Ri0nOvYhCHoJYRQ16
         x75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OghkJK6O1dqfXTdXeawll5Qqv8bgLqtQOk+Ns1n/2BU=;
        b=jSmo2AsObCTisDD4ZK1PUJPzRU/LCCnoAQp0XUqEUnqk5HaYnlVSzUrXUeW9n6rSz6
         cYI/ckCCSlyJdsGlhCzOtAGDAyetGdbNVoEgT48rw2O4p7vSLaB5Vd78t+FVoohavxmo
         fNb05UkNuUzQterisGPZnzPxtdoW9itF0D5vwDXw5CRTINcFzXiJjEkRxTgUL2t5KCxJ
         MeRfsuilZbv2e7CJKUNe1EmndRPUUfvxj8jGx82huC2vdHtoiBLWwN0k4mL09WYqocjY
         TqxKMd9c8HyRIoyHZ0OcgDrbO/zYctBznmsZcBlTar2tiCsjUnyHhJzOqnMHWkBkhGfH
         iYew==
X-Gm-Message-State: AOAM532hMBXVh53I/KwGaTbZRA9P5Jah9a3UlFADuM7sQgu3O+Wzfm+3
        0rBbn9NKc9f/b0Cg+48GjxuoUQ3Yja6G+Q==
X-Google-Smtp-Source: ABdhPJzA8wk+47+4bXvb9Q4Vtmj35YjO6h4PJY7S0FF2zuCyHnEvkveT78yUhg8WdNtuCoOCI8+SPQ==
X-Received: by 2002:a62:191:0:b029:1dd:3b65:c91d with SMTP id 139-20020a6201910000b02901dd3b65c91dmr8392725pfb.14.1613241087915;
        Sat, 13 Feb 2021 10:31:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t21sm13851051pfc.92.2021.02.13.10.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 10:31:27 -0800 (PST)
Message-ID: <60281aff.1c69fb81.fd8c3.dc12@mx.google.com>
Date:   Sat, 13 Feb 2021 10:31:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.98
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 94 runs, 1 regressions (v5.4.98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 94 runs, 1 regressions (v5.4.98)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.98/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5b9a4104c902d7dec14c9e3c5652a638194487c6 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6027e7c4852faee2253abe70

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.98/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.98/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6027e7c4852faee2253ab=
e71
        failing since 86 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
