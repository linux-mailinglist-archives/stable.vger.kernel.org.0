Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D225A435690
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 01:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJTXpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 19:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJTXpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 19:45:25 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BAEC06161C
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 16:43:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 187so4280556pfc.10
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 16:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=an79q/2EvpiGstvkHINjlLUHbbeH+I3hJ6BeUxgvja0=;
        b=GEYdBCrfRhWbGHoJHQTzfpgnAHA2HqlqJ0Y1eh4oySg+OkSbmZ50nz5pzO757WMZ5v
         9w1WcO8yNPhNaEy7ZbUP4nnXFZUsyPYvYR0iwCKxe31vNeAFRvkfPUQkYHmjEa9gI2U+
         n5HhEGkLQURwPyrtb50tIpzCk+jJurnT/mun39MInr7YdPJFodaOZgB4pH/qoh/VH8RX
         NUSBM1URre4Bko4e3OF+hflhlEkHcnnq/O81/6CA74ZJPuKYVZyfTAsJYqkSajUvrfZl
         6kIpDHnexIUfwTP1C3Fx/exMctQ4RvwUqvJWt6Af5dF7+LcVW6iAhA8Hj6RDEA3/fJEp
         kfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=an79q/2EvpiGstvkHINjlLUHbbeH+I3hJ6BeUxgvja0=;
        b=gHpzULYILK+/tmhhTphW7K0rz1/V9vxcyDC4FWTKRJ0JdD10X1BH3S7NblnbUfb5eI
         IHeVChTkzJYK+liLhHbjPQj4aD4OGKG2kjn783MI/r4okTrcBVaZNSPjhkyW/NKg7UHi
         KvUY7OaYKKbFU6XOkhtH3cYFLcaau8IzHQ5xxpR3XQMNQM0fHSHGr1oWBCjvuFi9OXto
         BggIEs4bww7/G1NWB5kGa1OnYIPjMugdzNIew4jmvEahnJNqhcknPWOxj7+79czzxd7n
         skxHmUl354MKQTixnwnASSZyjGpM0UpKa2yu3saPfnNIT56l5gsM6S8giLGqhkn5D/ib
         GuDA==
X-Gm-Message-State: AOAM533P6lATzgxigYJkjLP7Z06xpuSIXGYINWiRgfVi7SJGetpFxwAr
        iieqbLO95WAiAkKkyOwhMxy/ocCiYYeZ8kuk
X-Google-Smtp-Source: ABdhPJxw7mVkjMBBP7BsirKE7NOEXC9pKdnZO7YeAZKxXqhiwjlFa/dNTFmBHdu15II1MXSgdlm5VA==
X-Received: by 2002:a62:5ec2:0:b0:44d:47e2:4b3b with SMTP id s185-20020a625ec2000000b0044d47e24b3bmr1827171pfb.38.1634773389547;
        Wed, 20 Oct 2021 16:43:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14sm3143976pgo.88.2021.10.20.16.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 16:43:09 -0700 (PDT)
Message-ID: <6170a98d.1c69fb81.5c77.96d0@mx.google.com>
Date:   Wed, 20 Oct 2021 16:43:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.289-22-g983816d12029
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 111 runs,
 1 regressions (v4.4.289-22-g983816d12029)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 111 runs, 1 regressions (v4.4.289-22-g983816d=
12029)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig        | regressio=
ns
-----------+------+---------------+----------+------------------+----------=
--
odroid-xu3 | arm  | lab-collabora | gcc-10   | exynos_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.289-22-g983816d12029/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.289-22-g983816d12029
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      983816d1202951e5098f0d3dfafeb15d69c8f12f =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig        | regressio=
ns
-----------+------+---------------+----------+------------------+----------=
--
odroid-xu3 | arm  | lab-collabora | gcc-10   | exynos_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/61709286b173e0e68a33595f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.289-2=
2-g983816d12029/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.289-2=
2-g983816d12029/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61709286b173e0e68a335=
960
        new failure (last pass: v4.4.288-41-g7cfc0d2f1a45) =

 =20
