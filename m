Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1564377500
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 04:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEICra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 22:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhEICr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 22:47:29 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE3EC061573
        for <stable@vger.kernel.org>; Sat,  8 May 2021 19:46:26 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a5so4221255pfa.11
        for <stable@vger.kernel.org>; Sat, 08 May 2021 19:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1E4z4PaQ+iiFDjHVf/sJmmiebutCK4Y7W0spjEVIDfo=;
        b=qKHMq9pylWm84B5xzRbPkEEzZ8fmfFhm++auyIRVBYL9fzFR1rU41XgIcOMq+wdbhz
         NA5L+9pprr2Nf95O2HaPUS4QK7CmsdfHsm0ZHWHZtrydoeSYdPJgz6DjtVQoVuk4/O9d
         SGIr09GjwoKEBRyQVzn+vlSCjBCzZp5hcngutOrqzAmnz1Ll2mj0vmqkHNB7X+VXTpab
         EnoM+y0t0VTjztFj/HHziFyd5h4OYWM9nCKhA8DtrKAZz6lBqeigF30/rT6ZoV1ey0m0
         U9VeF53665orjL5HnfpoXHIIejINjY4UKs0zoJw/5tuPbWkR2+wBYGojxUydsuS89Sao
         e1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1E4z4PaQ+iiFDjHVf/sJmmiebutCK4Y7W0spjEVIDfo=;
        b=XsUFVRBLpcs4s/qNpnyyC3JIS3RcjqCKbeZXPUs2/9uYxxv4EENDT0VIanBHJL1R9E
         6RmVGUJlweXPyjH7INyx8Mbl47FR7+qa9ZkAw49iNom1TtCuC7B9KcjUX5ImhAOC6IwH
         ciSHvRIwQROGbzsQm1vdndyPH5/+dn75inYy4omLjEFrvGAgV6skMlftrNK4artk2Ja8
         Og+aiV8SshvKt3iLrYVLE/zu/enRNn+BTa1x3xa88X4Ol4/9Zql5S0VpEy5Vskda8dst
         gCFEb8qaU+GRui1tZVDgAfxE2QhhfDF5NZ7AvbljTU5RMbHswLSO7PjkT4GkuI0Ofhpe
         AC3Q==
X-Gm-Message-State: AOAM530wXQClWUTdeyzUQp6lESD9TPR0S1/jMeX2b4uYHLijh7NAqD6R
        qcT6pLWGtw9CXLF+u74s0L0YdqkrrJGG7oWq
X-Google-Smtp-Source: ABdhPJwxvyULbyEfTKVQc9iEwQ/qmRQVWpztsvaUCZ9OwoxB979wWOTwIhYzaOaz0H7jwLBz+hal1Q==
X-Received: by 2002:a62:f249:0:b029:249:acb4:98b6 with SMTP id y9-20020a62f2490000b0290249acb498b6mr18026865pfl.55.1620528385729;
        Sat, 08 May 2021 19:46:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8sm8059005pfu.111.2021.05.08.19.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 19:46:25 -0700 (PDT)
Message-ID: <60974d01.1c69fb81.54d3b.9587@mx.google.com>
Date:   Sat, 08 May 2021 19:46:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-254-g3b5ece8b5376f
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 161 runs,
 2 regressions (v5.11.19-254-g3b5ece8b5376f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 161 runs, 2 regressions (v5.11.19-254-g3b5ec=
e8b5376f)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig           |=
 regressions
-----------------+-------+---------------+----------+---------------------+=
------------
beaglebone-black | arm   | lab-collabora | gcc-8    | omap2plus_defconfig |=
 1          =

imx8mp-evk       | arm64 | lab-nxp       | gcc-8    | defconfig           |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-254-g3b5ece8b5376f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-254-g3b5ece8b5376f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b5ece8b5376f092fbb09ef2cf643a5b1cb08e5c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig           |=
 regressions
-----------------+-------+---------------+----------+---------------------+=
------------
beaglebone-black | arm   | lab-collabora | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/609740ef48465269ac6f5476

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
254-g3b5ece8b5376f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
254-g3b5ece8b5376f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609740ef48465269ac6f5=
477
        new failure (last pass: v5.11.19-254-gd241c3fb00ee9) =

 =



platform         | arch  | lab           | compiler | defconfig           |=
 regressions
-----------------+-------+---------------+----------+---------------------+=
------------
imx8mp-evk       | arm64 | lab-nxp       | gcc-8    | defconfig           |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60971e237dee0690d56f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
254-g3b5ece8b5376f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
254-g3b5ece8b5376f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60971e237dee0690d56f5=
468
        failing since 1 day (last pass: v5.11.18-29-g6c2ae64a2a728, first f=
ail: v5.11.18-30-g4232ce7a02cc) =

 =20
