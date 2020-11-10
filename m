Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094E42AE36A
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 23:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732199AbgKJWh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 17:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgKJWh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 17:37:56 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D351FC0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 14:37:55 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id cp9so3782431plb.1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 14:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Tw8IBiPh8kqZq3WudHB4eGzulaf3iJjx8EomEfowrCg=;
        b=tdRm7yPsXnQ0g/8uYTKCpZyjjWBfU41Fu/nyOINMFsOr9EDNx2Ij4u0dZcVjwbmRbo
         P0rvNinwNxxbZFL96Zz1U9UsOBVPJvVRMZOd0c4TQpRvXP17/BbY6Ng9pJWvYieMNS6r
         Vz6Dn49eX+u17AIse9JBVOUnoIs5h3F2RyI12L66A46t9jbPaR/THLzW1tG45qSN74Eo
         g2aa2PBUBKYB78EwlIHR9PfD6lMB1gXU5DwKPzM4879/HDz4pk8A8NZ9bbTLFW8sSxoy
         3sxubtmrAbvGnSwmcbsYdNgsV70DfQwRgzzq/QuncG/Rfh+FRgAsltr3fXKeiZhnSzhe
         DnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Tw8IBiPh8kqZq3WudHB4eGzulaf3iJjx8EomEfowrCg=;
        b=hfOHHntCfXaddKlXMfufa1pklCTAzS0d03iz+PIwjV+gt/xjOoMd40UX4OCpeqJFEH
         MoL5DcHydvkTCfnjN4t5+oh7p19DXDuD03q6ZRXJ5+kA7qWHoAPTjjxK/epmbd+7b6jm
         9NCrM+t5rZGmJGPWK2bahsRjy037WNMqnR3OA6oU/4KqrLB36AAjArlzXB0h9ZJ3Hia3
         Smj2VzMmgVW0/iu9iZlMzLB17aQpdRAqvyyDH7ln5zLyarLlO2GbTqQpDu8cLYi6vIDW
         RkUlZXLc9K56IwztrG0/uOzyjsaqPdDUE/uq+P1+B+zytuXdANkXdUXqde8uAY1/4ZOj
         fVNw==
X-Gm-Message-State: AOAM5325HqZpVjNKeyVEek1mXnEQA02wQ/umMvHhR0uKiV6hW6N7HQFy
        mfTL6Y00NoZ43Ibj3nqdfLIqU73ztdzGFw==
X-Google-Smtp-Source: ABdhPJxjBQswcSEQL2mDnlGcbo2Vf/QqXv6pv6+e0+/ZMOIoWDdhAA6/T2kAjJe8WZlCUFfE0owlxA==
X-Received: by 2002:a17:902:7b91:b029:d4:da66:ef6e with SMTP id w17-20020a1709027b91b02900d4da66ef6emr18810744pll.10.1605047875076;
        Tue, 10 Nov 2020 14:37:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y23sm12282pje.41.2020.11.10.14.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:37:54 -0800 (PST)
Message-ID: <5fab1642.1c69fb81.74e3e.00c2@mx.google.com>
Date:   Tue, 10 Nov 2020 14:37:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.156
Subject: stable-rc/linux-4.19.y baseline: 147 runs, 1 regressions (v4.19.156)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 147 runs, 1 regressions (v4.19.156)

Regressions Summary
-------------------

platform       | arch | lab          | compiler | defconfig      | regressi=
ons
---------------+------+--------------+----------+----------------+---------=
---
qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.156/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.156
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      53fff24aaf01dcb09cbfabbe060f42db8e61ab01 =



Test Regressions
---------------- =



platform       | arch | lab          | compiler | defconfig      | regressi=
ons
---------------+------+--------------+----------+----------------+---------=
---
qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5faae2349f80dd7fc8db8867

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
56/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
56/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faae2349f80dd7fc8db8=
868
        new failure (last pass: v4.19.155-72-g4d10cdd4ac50) =

 =20
