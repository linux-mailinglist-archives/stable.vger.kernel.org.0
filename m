Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB192AA8E8
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 03:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgKHCVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 21:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgKHCVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 21:21:14 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE81C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 18:21:14 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r10so4011445pgb.10
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 18:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tVALm6zNKAKGVaGnkBzI0bZ2szU2l0knPuVrCvvd0S0=;
        b=1ShyI5/8ws5rpLeAHXunMekIjlvrqSswDal9e9in5N9TL4kO+LcL0rNwR4XFPy/TQa
         pPP3kSxmLj0EpW2Dz6L7qc8lDh6btLuKpG8yu8uWiGyoJi4LLmfvOaewmvqs3mMw7ErH
         ZtFpNkGI38q2dc3SomVa2SaGp5MVBdXoKbt2BWHnpcEKpjALg0+ya1aIG06Swr4mlx5y
         uUna1iSyaGctIgLFv+IaoCo3V/CHtHN1LaRHb1AYJAFySumJzj0gePyPG2v9wkLt8InA
         vyYoW862hVB8HxsWiPCnl/4ZQpXhPIirpQJpGl4hSsrYSbAk5njt3XdO3i03V+H6kCeh
         tSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tVALm6zNKAKGVaGnkBzI0bZ2szU2l0knPuVrCvvd0S0=;
        b=D0joWihkk8K8kgGmmbNVjA8JdDH6fW7+gtkC6XwHRhW/pUdoEOZZzrbMozUOflCb+p
         zbF/PBbKlN/y38Qkte2JpERA2uqSyf3BcUzwbVG4FQz/V+fwc/kwrxjYz46AcPxtcNId
         TolCxdG+e8tRFzjTbCBU56OGgK6n/MDAasnwBX4r7HqbI10UYY/tVzBA+EFYSuyNaX+u
         PgAcDu3lR9SgqAnyZVrLKBJeBOuwnnDnz5RzD5Yzkg4zP3jvcECSrYPAi55zE8lc+Agk
         /ZfplXBEVgF7FUHWk0omGXihc3bLasfiD26O76mIGbIHiusUFNj6iIyVjWpZw6K+srwW
         I/Fw==
X-Gm-Message-State: AOAM532h2P7PA3FUOzl4etgO3Ryyi+8Vyk5z1ujTmN/s9Nxvg9pvRh4W
        alyPp6XEqMKijJ1uWI4OtfR92WE3jMYDzQ==
X-Google-Smtp-Source: ABdhPJy8lstue7dfNFMSi7FeX3I5XGmGknOefm/2OjkXak7l75/j2YCDTb6509O3+FxuncR+1lWsPQ==
X-Received: by 2002:a63:2342:: with SMTP id u2mr7628340pgm.50.1604802073603;
        Sat, 07 Nov 2020 18:21:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2sm6748436pjk.12.2020.11.07.18.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 18:21:12 -0800 (PST)
Message-ID: <5fa75618.1c69fb81.2002c.dbe2@mx.google.com>
Date:   Sat, 07 Nov 2020 18:21:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.75-35-g1ee437936e22
Subject: stable-rc/linux-5.4.y baseline: 205 runs,
 1 regressions (v5.4.75-35-g1ee437936e22)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 205 runs, 1 regressions (v5.4.75-35-g1ee437=
936e22)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.75-35-g1ee437936e22/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.75-35-g1ee437936e22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ee437936e224a0e6b85ee87e14a1dd3b2d92f8b =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/5fa726331af77dc70fdb8864

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.75-=
35-g1ee437936e22/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.75-=
35-g1ee437936e22/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa726331af77dc70fdb8=
865
        new failure (last pass: v5.4.75) =

 =20
