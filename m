Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22973221F3
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 23:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhBVWJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 17:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhBVWJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 17:09:08 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769EAC06178A
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 14:08:28 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id p21so11087708pgl.12
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 14:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KpqJSflQbsR0fVRbNlRLqsbw/bvHkaEl/O/hX/ENqYA=;
        b=TseQQfvGuEHo/NbB4HIaJq2rF0N1nm16krN1TMB9ZQM1+yInBrXKcM6aIsQ8cf/3O1
         /NrBXAAqMewQ7A+D9ZY/g/yKoABcUOE3oAEP8bYDwdSfDxCLtiuFiZnwZSGbLYeCgqwF
         ub9TrCjEQ4zhB9b+uOaeuNBx1+HMOLbQt1TviAdurJVAo0jUlUhLEaFGug3az/T76i3H
         RM7m+PlY3cCfOKzPu0ICE32VYaho6lKtZmiKNkOKuRbxNxg2C6ZiIRr6WWcCkHfroaLn
         P2Qs+ncqWrj5kfJC6varJL/x2ZqJzxJZ7PniYYdybDRWS0GZ3kT1HsCKRlIiZfpaC6lW
         zkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KpqJSflQbsR0fVRbNlRLqsbw/bvHkaEl/O/hX/ENqYA=;
        b=DU2XLF+WojmAv+HLQwahRe5s0BJLMQEAohlAEOOM/SQ3UsUwO8Moo5gRehb3EW+cdt
         Q8yBZrf/DN23JL+ZEa5C3DaPXPntqIaxx/R2L1VR1FEzBn+bAZ+8MC348BERPyVtDj84
         KjBsPhEw1UOOy6QGYpaSwXuNKEVhcJQfBfJ/+2JM4GL7DEbNKqyCPxnmiP+4JreqdC8b
         5d5LveIPweZIiRhLatL6KORROTvhWcslIaCMQlm49oT13ibVnLjQQlknuDDAsC0yz+HH
         O2SaEMtG6GLviR5mkji9wtpUZdsWPhKU6454upDxN3qOM/I2k2lZxI6V67JZ/4YWoShN
         eWnQ==
X-Gm-Message-State: AOAM533dXIHcTtAHTUiczjPyGWvjr36X+l8MmAedy3bz55llzzB5BVeN
        F2YW5FVHVoaRalqXUCSjg3SgHtlOVrhlXQ==
X-Google-Smtp-Source: ABdhPJzfPcqS5EGDUhKfMAMZETsvr3HC9bojAHBF5dPIE9XTpQ/faTbAFvb4ZGiqj/w8V3bi22VNng==
X-Received: by 2002:a63:4504:: with SMTP id s4mr21379713pga.184.1614031707912;
        Mon, 22 Feb 2021 14:08:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm430130pja.51.2021.02.22.14.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 14:08:27 -0800 (PST)
Message-ID: <60342b5b.1c69fb81.144cb.1646@mx.google.com>
Date:   Mon, 22 Feb 2021 14:08:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-58-g5d849f076141b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 64 runs,
 2 regressions (v4.14.221-58-g5d849f076141b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 64 runs, 2 regressions (v4.14.221-58-g5d84=
9f076141b)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.221-58-g5d849f076141b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.221-58-g5d849f076141b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d849f076141b32ff58f296e2db48960d320954a =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6033fbba1dd7977b52addcc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-58-g5d849f076141b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-58-g5d849f076141b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033fbba1dd7977b52add=
cc9
        failing since 328 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60340b6433c9142415addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-58-g5d849f076141b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-58-g5d849f076141b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60340b6433c9142415add=
cb2
        failing since 11 days (last pass: v4.14.220-31-gc7c1196add208, firs=
t fail: v4.14.221) =

 =20
