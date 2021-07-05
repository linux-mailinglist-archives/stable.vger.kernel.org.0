Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA413BC194
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 18:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbhGEQYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 12:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhGEQYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 12:24:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D507C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 09:22:01 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso170523pjx.1
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 09:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6dIGbTjUjqvbaxu8vcWCAGj8Ohui1McFhcChTITJxWI=;
        b=yZMXnSiQljg3y575EtnpIUTz7bjYvbLY51znBRc9Iqb5DQSERbtr3pLVDPjFk/Z6lp
         rA14v7XZzW5RTPx1V4NQk93ORyUfEsFcmME94mQ0EWXDqIPvOmZoJFOzefS5e5cqeOPK
         ao4wUOnEG4f7MQD+tgbNO6mKH1R00InA/UO2UiTmkGHpQspMI2ML9iF+uBSqAhn1PMQ5
         UVfEs9+tpAMLJYCtvgDHLPygNnJlrkbhipkRhcU1cKkCEaSBTss9Y+UzmyLjt8mMGEH+
         mAXymDB7MX6gVZ0KB9hzwdtCLLV7Iu8a+VaNh0eJvMhryhjhNyrz8H11Kk3lCyi51Jr4
         eOGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6dIGbTjUjqvbaxu8vcWCAGj8Ohui1McFhcChTITJxWI=;
        b=e+2zKH1y8FlkLq0T1SJbVRtuJROKZndtttcmo/C82OuI7AVVH1SV1LhfyCSqMQUKQb
         DR4D8rPm41VwpMjlerL913+MElEWvSY+UK7r0JpBSZ0SJEPHBHmzYuSDjJ68YZWSFQfi
         euAWeNNAKkB3HuGD4ZtBLGJoKhQH1d5hwKVSWHySSqgevWEevWlZVY0cXi6K0ug5ppMX
         mC9aWTyf207+rh0QMkWxa/RkRgRmR5P5H8nvxLNQxsc37jijlmqFD/jC7E9JBnkWgDe9
         cfzWw+vM38wQ3kO5CkEk92wa73qfBMmFxjdyd4YaNTrgS8Ru0umDgJhxsptm0JmIMHDe
         v3pA==
X-Gm-Message-State: AOAM532pGM1nehIxeJkNhdwXzHoiQbPiInGgF/lTXkys32JTG5kPC4kx
        kpxxXx/HmDYYo9+KCGgtbxPUctdeN2HJt0Hm
X-Google-Smtp-Source: ABdhPJzBMjP9LEZpoJWo1PDkhUJbc16IOeN1dWG3xW0VzSJwU+GxPd8RsEoqnGnFPUJaoL5V2IYd4g==
X-Received: by 2002:a17:90b:2352:: with SMTP id ms18mr15938285pjb.43.1625502120646;
        Mon, 05 Jul 2021 09:22:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h14sm9761206pgv.47.2021.07.05.09.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 09:22:00 -0700 (PDT)
Message-ID: <60e331a8.1c69fb81.96cf2.a335@mx.google.com>
Date:   Mon, 05 Jul 2021 09:22:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.11.22-1-gcff6bfc3580fb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 181 runs,
 2 regressions (v5.11.22-1-gcff6bfc3580fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 181 runs, 2 regressions (v5.11.22-1-gcff6bfc=
3580fb)

Regressions Summary
-------------------

platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =

imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.22-1-gcff6bfc3580fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.22-1-gcff6bfc3580fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cff6bfc3580fb27b56630b982285b634987cf298 =



Test Regressions
---------------- =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e306c9778b372d3211798d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.22-=
1-gcff6bfc3580fb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.22-=
1-gcff6bfc3580fb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e306c9778b372d32117=
98e
        new failure (last pass: v5.11.21-329-gc58bf3153f0d) =

 =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2fffdf755f4eecb117974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.22-=
1-gcff6bfc3580fb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.22-=
1-gcff6bfc3580fb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2fffdf755f4eecb117=
975
        new failure (last pass: v5.11.21-329-g144258c90a89) =

 =20
