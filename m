Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC60C295127
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 18:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395380AbgJUQzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 12:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395372AbgJUQzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 12:55:13 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B4CC0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 09:55:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g16so1454956pjv.3
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 09:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t9XEDPxTloQ+ITdlzjb+W+Mi/eCsJYcWJsZKswrfx6g=;
        b=TMYONedN/bSvJKBfDI1H4vZ1sEBjyH2V51SvgjPVLi5dHztv6XrYve3Ln19gBEbhIW
         7xtoqAG4drzGP+uULd/sdRxxAqcXhc6QNdK2Bf+sMrsEuRRSkBREqVbfqJn4f3BryEz4
         91ezP1Derd5BGPU+vlL2ShfakJJ+05MuVhIPm/WRVZ3KX9O2Y+oy/ughJ+K6Zftwhgqu
         pLiK8OrnK/EDzyaenEswjbPIKWvmHxB7G43XK78sNXnOM9CI4+SaIBDb/fLu2CJXXkt/
         B1yfY9SOoPHEW+TDpMf+U0DYd+5TJvhd1ID6La3ki9BruBda59z16VpIqGbeVkoauc4N
         UmZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t9XEDPxTloQ+ITdlzjb+W+Mi/eCsJYcWJsZKswrfx6g=;
        b=E85rpMmm9e2yyu0gqs9K0toR2oZnPxqopxs6yvLVN40EBKMkE7PR1vaqXZKr48lVY0
         AdvqO87VsM77tNTuF/FeHnki5z74fupKQXP6MphYoUMmHVw4gtt2N/obVD6DCOgT536A
         4di7X++wyk8eI2QeF4ZEpTzzk+3LGBPOEcCGKNTGPyKNbHNl0Tom0xnmSknd/5Parz1g
         Pk0Nkfkap1+5fds0nBZb6Z9yPLI2XwqdxKPIX7wlkszd4EkEIFOHj9c7926BnZK33Xud
         Iezjf7+39QyjWywpMNVtXtu4MhNlWcmnRwPv+ZqF5WEOeTlFp03RaFGJnBrUyEraCigW
         dS5A==
X-Gm-Message-State: AOAM530MvE0odxssYE1vP7AYZCrg/PyoPw0hQC0QYAbePMEE0d5Wj7WN
        nLMxoJf7UCtxeSQR37+DViBZMae+dilYIA==
X-Google-Smtp-Source: ABdhPJyuQeuxvnAlDCmYccLufyH7BHiK3SWm7LDPE01+fRNZSJnNvun2Tfo6fqEY3al1IMKiw+jMxA==
X-Received: by 2002:a17:90b:3849:: with SMTP id nl9mr4362789pjb.54.1603299312438;
        Wed, 21 Oct 2020 09:55:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5sm2248076pjj.26.2020.10.21.09.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 09:55:11 -0700 (PDT)
Message-ID: <5f9067ef.1c69fb81.5d38f.42f2@mx.google.com>
Date:   Wed, 21 Oct 2020 09:55:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.202-10-ged048399782c
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 137 runs,
 1 regressions (v4.14.202-10-ged048399782c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 137 runs, 1 regressions (v4.14.202-10-ged048=
399782c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig          | results
---------+------+---------------+----------+--------------------+--------
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.202-10-ged048399782c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.202-10-ged048399782c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ed048399782c0b4d705fd71037b8d4475c6e610c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig          | results
---------+------+---------------+----------+--------------------+--------
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f9035a25fd39287864ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-10-ged048399782c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-10-ged048399782c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f9035a25fd39287864ff=
3e1
      new failure (last pass: v4.14.202-10-gf90acfb8d295)  =20
