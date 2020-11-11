Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B9C2AE6D6
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 04:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgKKDKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 22:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgKKDKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 22:10:04 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C964CC0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 19:10:03 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id w4so491541pgg.13
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 19:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bIyJwOOJi5slAfZOYrIc8mCBQQKZNSb310Zzmf7E+7E=;
        b=f4ADUyqKqPCwzKaCuI2aaeHUxDkGJU2rmfPOnYotw2GZKsIqV+FheRG+2UllBdGOyg
         lqsakW2yMAoqkm8FIjfPG5T4Blr7Gca9BIcqXG8zmgP519TcB8gpHwVaEimevvNu4dAS
         YDt4Zeeu09nFydyEn8vTtYzsPq9ne05KSPVYw3F7ttE1vGdIMUaC7h1aSB3P6LFX/coP
         xznTVsZ/i8vKycgkTTJYAquVV/LlOVxWrEMpyDq5cceQNjHYZx+12xohQO8yyDCEGEFl
         B00V9qFOLSsc4i7d6cUo+QQDIxXZUM0tquj9ymoB07hIK1S0OVggZyxh0v4qNMVR6JmN
         MtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bIyJwOOJi5slAfZOYrIc8mCBQQKZNSb310Zzmf7E+7E=;
        b=ACiEGoo8JBe/2f/agJ5LLJ9Z1csI6R0wRCl4PDJAnIRBbiH/Z8P2NyddDZaaNpfAF9
         Vd0ntQyox8LyRQQhz0/MCtxJ38K/idQs9/rZYaMdZSg8JwOgR2tzumD98tP5uv+S1gkS
         FT65Mf3pkxVA29m4VpdUyQJeFwsLmDtqRt4a/eSLY7hlN1Nby3b3EvTFVPdnYDosNQr6
         hdJ9QLQWOZapJFRJYWX0CPPBYGd98Ng80Vmzu6F8qeYMx/P4UFcd0ElvAC5UjgVXKF53
         smZ2aqNMOvFu6yk8vuJldV6E0EXxDXgiYB3OXq/7bYfyUNlJgB5NUNXFn5B+f2zcJV4e
         rytg==
X-Gm-Message-State: AOAM532bnAHA6Wve2WEemD5KXnGNbMRvdgkeP7Mbm4OscdqGwypNhsaz
        UkTFR042fmfc4qlsynoq3Hy9oLnQlpq82g==
X-Google-Smtp-Source: ABdhPJybdpj+EJ9ka/fkAJEz0+JguCbzu2HcEw+tGjdO4hfVzxIM/EWcg3YhSYHw4FZOJi+dKv8rFQ==
X-Received: by 2002:a17:90a:62c4:: with SMTP id k4mr1655878pjs.32.1605064203088;
        Tue, 10 Nov 2020 19:10:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm371169pgk.34.2020.11.10.19.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 19:10:02 -0800 (PST)
Message-ID: <5fab560a.1c69fb81.13168.1814@mx.google.com>
Date:   Tue, 10 Nov 2020 19:10:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.243
Subject: stable-rc/linux-4.4.y baseline: 119 runs, 2 regressions (v4.4.243)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 119 runs, 2 regressions (v4.4.243)

Regressions Summary
-------------------

platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1 =
         =

qemu_i386-uefi | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.243/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.243
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04d24799676ec16aef54082a7f826ccee35dade1 =



Test Regressions
---------------- =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fab216efb546036e0db885d

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fab216efb54603=
6e0db8862
        new failure (last pass: v4.4.242)
        2 lines =

 =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
qemu_i386-uefi | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fab213edc4c902a25db8856

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab213edc4c902a25db8=
857
        failing since 0 day (last pass: v4.4.241-87-gcbe5dd8b3604, first fa=
il: v4.4.242) =

 =20
