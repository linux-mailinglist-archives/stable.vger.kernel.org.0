Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A623324412
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbhBXSuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbhBXStz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 13:49:55 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E640C061786
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 10:49:14 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m6so1922726pfk.1
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 10:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Za9jD7wX8SjunK3OHK5tG/E668+4nQ5MIiwyEcHwxr4=;
        b=WhJaKLWJ5lPmokbJaP1OYg8JbXobn4R7EYeR2DIn1j379yt9jDPpl00Mf3USn65Tls
         VtIM4/aStdJEXWEGyB5BHvIh0t1JU4goFB5z+Hm9D32gJq9PasZpDnJoAiDH6Gy9/CPh
         rDdnI3uPUeB6yv71zzRs+szVAqOpaRzuD2YkehDn9/nB816ThsWMji4Tq16cTZkO9hf3
         n99uYoUvmnQqWjouUUPqCioMr8sKxD+AA3tguzEpZKWBe12i74yRX0avt5jeEIoJTCWT
         noWUXytf0rLx8RHsadNc7W5ECA6RUYpi26MuW+W9HljmzrG5O4SIDZPU36i8keaO8nLO
         ftcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Za9jD7wX8SjunK3OHK5tG/E668+4nQ5MIiwyEcHwxr4=;
        b=daf7qpDte4NIlCFUbwbVO07dUpmNNRkq4W65zng1oWhQ01VDqXl89m5K4d/m15kEBS
         ut6kreLP/GusvBPGRM4V9kVKfhnZvAzKwcdyk0hufYcNqGSCqlxrdFjiAk3kq/W/NCxJ
         I1xnNZWlNgZbXWV7R4o1j1Fuc6P8PojMbVecZlcUFVfS4dksJIwoXFv/Vvxs711deMeZ
         y7zo8rAxQx+5WlAjvmUijRovNVFrc0PBbvH6VkkmV2mcXklaBJ+hOuNovQutqtE0p+oQ
         Onc1zULBdLk2u6ot82JDWtQQbDGRyt35gB2P63oyLLAydmgIKz5K1WPwwANrLIsKOAn1
         tyiA==
X-Gm-Message-State: AOAM532QjnNvjiS4j7v9YXJC7beDlKHvuDJj7qJuAGk7jse7PZFitm8m
        EfCjn8L9axBAoL2QoF202CstK7MKZK7LQQ==
X-Google-Smtp-Source: ABdhPJwj4U57pPQghMNMuwiu2Hm8olyuo4cIEVJwf/xYn5aXyYaY83JleVsT+BohiBDDJR1aFeUwrQ==
X-Received: by 2002:a62:7797:0:b029:1ed:7b10:84c2 with SMTP id s145-20020a6277970000b02901ed7b1084c2mr19616678pfc.47.1614192553629;
        Wed, 24 Feb 2021 10:49:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k69sm3681430pfd.4.2021.02.24.10.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 10:49:13 -0800 (PST)
Message-ID: <60369fa9.1c69fb81.e539b.7f08@mx.google.com>
Date:   Wed, 24 Feb 2021 10:49:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.18-12-gbc43384c353ef
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 116 runs,
 1 regressions (v5.10.18-12-gbc43384c353ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 116 runs, 1 regressions (v5.10.18-12-gbc4338=
4c353ef)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.18-12-gbc43384c353ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.18-12-gbc43384c353ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc43384c353ef751ec8234ca4e7fee95daff11b5 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60366efc3e7b40a0f8addd0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.18-=
12-gbc43384c353ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.18-=
12-gbc43384c353ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60366efc3e7b40a0f8add=
d0f
        new failure (last pass: v5.10.18-6-g7931b7eb2357) =

 =20
