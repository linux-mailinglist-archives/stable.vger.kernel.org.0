Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF35332B76
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 17:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhCIQHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 11:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbhCIQGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 11:06:45 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEEBC06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 08:06:45 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so5448495pjb.2
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 08:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8CjzqRm1ah4RJ+kDbsWCD8EDPO2XPjmt6uoENh+R344=;
        b=eXCaIZcqL3UmD8+LJbkazl0UIdKadtgHC2y3dDuRObx2luCtM2Rk3Jo06GcV1FIBxR
         gN6FiA+nzOQh/Zdc3nE+wBaiDbPuWrTAtMYuX9hBnYhi4ZDt/lfR+uigMoV9WFvG40OH
         kAKq8ogmJ18We6BnEnBTnVV3qZ0fuIQ3iU/hEYA3lfsD7PnTkHRlkYdcKkdBTgMOl1tD
         yzLg5XI8mCvEeAlp1ymLEcHVwkZg9pYysB1jFQa+u3reHqA6BBJAy9JdYiFMhlIWDzoV
         xeWKi94XcSmkreaqfcLzMyTmUSDh9uKbYJckQQv6LcVl9nDOFqUWAv1yJnglNu5XNBcN
         61rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8CjzqRm1ah4RJ+kDbsWCD8EDPO2XPjmt6uoENh+R344=;
        b=tRlWE/zYyzotD2HOCALqcUSXr7TyDRtsaAoY7QKum7dMwiyxlgw0rc2mOdt02v98KH
         e9Xas+TV7y+/yfeRJtPiLgny1KudFja+fWfU25a93pts3hMv7SbPmUn658JYPYtP0CYe
         IpBncl1Ue/8uNhcixry+Jwsszco4RkC0QL22nR3dZGxNbrt6Jp5m9z1eyzMMamDle8CG
         qhFIg6g67F8lEpjSdVe+VOUoPpqx721A2Pr1OKE5d0e70EH38QgNi0nAzzKCr5PXh3T9
         /IwuN1mQS53/sF3xQTAHjc6ROP7pGIcZQhodejoPL2sRTWONZwr+fXWZX0p14l5s6YhS
         JqRg==
X-Gm-Message-State: AOAM532Z93jTc60UTO/qCQKg+Pb+S2UxnpRzS4jAJaHe+B1AEmImskyA
        D92FOty4uP5usMetQp36v0mZw03ZuROQrqpL
X-Google-Smtp-Source: ABdhPJxc0ejjzjGxltywnEzDN7ZrxWqGoUBshnDJXw06F4WUhseqxXRiKprFKaLdFle6YLGSY0zk8g==
X-Received: by 2002:a17:90a:bd90:: with SMTP id z16mr5580644pjr.123.1615306004993;
        Tue, 09 Mar 2021 08:06:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t22sm3559719pjw.54.2021.03.09.08.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 08:06:44 -0800 (PST)
Message-ID: <60479d14.1c69fb81.26b9b.8f4a@mx.google.com>
Date:   Tue, 09 Mar 2021 08:06:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.21-42-gc1deb5ee76b3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 101 runs,
 1 regressions (v5.10.21-42-gc1deb5ee76b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 101 runs, 1 regressions (v5.10.21-42-gc1deb5=
ee76b3)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.21-42-gc1deb5ee76b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.21-42-gc1deb5ee76b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1deb5ee76b3e1e46ea2b791de5d3622441db5cb =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60476d4b0896b19710addcb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.21-=
42-gc1deb5ee76b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.21-=
42-gc1deb5ee76b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60476d4b0896b19710add=
cb8
        new failure (last pass: v5.10.21-42-ge990ccad455df) =

 =20
