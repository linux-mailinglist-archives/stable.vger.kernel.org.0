Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FE548F263
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 23:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiANWZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 17:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiANWZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 17:25:40 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6C7C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 14:25:40 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id x83so3997971pfc.0
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 14:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DoFtt055M8JET+nGQIUkEX6vi0g431w1uVsr4rjhlBY=;
        b=OFybkKueRToU8tsu8dIPu+5pNOFGiC0Qw/K/iFF9ygNLuPQ+FVLEhi2+okCYLrtDoT
         9bX2HVZU9ashgM40Sdp47mTLItEnYTMhH16NTqVJrh7Ob2k0wBNfbIx9CosFOmo09iJ+
         57lT8XGeVDORCUkIC/0A7AqpMyz0KHEOUV3PSnrXRJaAlheCOUNq8twgRgY5iYjxid/C
         twPPamYWaiIEJXYqdi0YceflPhYVoUb6VxWLKQoSR1Lp7jsbk4SaB2nUkfm3g8iNb8fC
         lzcVW56iaAB+khE1SCSUg7R5cyQEOjUIdpJ0yHcU587nzdZ3vB9irtfYN5yjwQ08D2sk
         /YjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DoFtt055M8JET+nGQIUkEX6vi0g431w1uVsr4rjhlBY=;
        b=5xfIT6p4zt2kPj3ypGAzQOwvQLlBHq2vd86cslYZUXtfVbQpIOseTdtnnYFzriyVTd
         IIZs/T4wlS7HeqV7WHRno5kurF5Q2sgkX6T+i8WrfpSIWKM0QMmwdz7VE6rFN19aIXGS
         gtaQ232qu8R33j4owBBXziOO5WAMTJjg8RktVJ7UoBspdhF8rU6v6Oom5JB4U6QgeITr
         PWcPAwxEKxsfOj6Ef0vfYFdjBqYgyAKDbjfUP2Qkl6UP8Bly7lSOJFuZq4U5VMnR4emk
         ZDuD9bAIkZ4TawBDuGt1SJWGC1h4wn9f+9k2EhXFru+oZO8mJvyUUF6M0hxIGx+ouD19
         GKjg==
X-Gm-Message-State: AOAM531a8w17rUYMqAzL8n9eDPdby5x3g0hzXuu+oJ1/0AIJl14AYlgf
        pJ+v25wALucx024V0krcfrYPyDia+NxDSXGQ
X-Google-Smtp-Source: ABdhPJxiv4RPOZCCRDjB5yReH0rdVL/bcMHlbBozr2Vx4i8T+iQ2YebV1UIJ4v/QXQc650veOt87Gg==
X-Received: by 2002:a63:b812:: with SMTP id p18mr9983607pge.22.1642199139723;
        Fri, 14 Jan 2022 14:25:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm6009968pjk.48.2022.01.14.14.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 14:25:38 -0800 (PST)
Message-ID: <61e1f862.1c69fb81.dd190.175a@mx.google.com>
Date:   Fri, 14 Jan 2022 14:25:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.91-25-g3eccd3159d8f
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 140 runs,
 1 regressions (v5.10.91-25-g3eccd3159d8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 140 runs, 1 regressions (v5.10.91-25-g3eccd3=
159d8f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.91-25-g3eccd3159d8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.91-25-g3eccd3159d8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3eccd3159d8f80879941c0ecf50fa20cabec9ef8 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61e1c3de840dc9e3a4ef6740

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
25-g3eccd3159d8f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
25-g3eccd3159d8f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e1c3de840dc9e3a4ef6=
741
        new failure (last pass: v5.10.91-25-g1763ee9718f9) =

 =20
