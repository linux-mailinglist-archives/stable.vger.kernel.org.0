Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5A23240B6
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 16:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbhBXPWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 10:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237210AbhBXOs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 09:48:57 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B831AC06121E
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 06:43:05 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id l18so1465700pji.3
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 06:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VzBHjcdIAlRhodXxXdO23/Stkk75+An1Hjak/j5/aIs=;
        b=ifInJGpqrm0+y80w2SI3GLG578Q1jBGE9UmYqigfJOMDkwtuegK/zznD18pNfe3AeP
         OaeSEV9Nbt72R3D+A44O31Nu7q7L1GhWpPEVUyL2FVRFABAf+dK7vd5Fl0Ai+N79YIpZ
         louq2IcKheeW6Wpo12dmSC5hKoIpp+R4ZJzGL6kmIudejUKD0PyOiWuucRQouM9Uucgp
         UrjO0xmpCfTZYMbnKQD2VTAeH5rwR31XWKHibg4ebJzGVKWFsY+AvI1FvFOl7BanKsIQ
         lNMFV5hG++BAWU5zT3Ils8ITw8RMF/qrjVrPubzMuAq/XI8F4sGHpbV2+pllh0gXzk3M
         VIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VzBHjcdIAlRhodXxXdO23/Stkk75+An1Hjak/j5/aIs=;
        b=G2rtPk/ovPdEAD/X1hkk+6Bj4ZCFnJd05LDKAZ6fS9u1qdI2x0SEPiEdFn6B6zcgbb
         hfs4nUtgkq/p2Q4sfpj2iKPX5+2xHoHkNI7lBM895uuy8Z7+suBI1SD6ZNmUD/g7hFE5
         ggB6BzNSg3067LZUTMjb/+Tk3mPDe5Hr+bMnUpB2YaTl//LXKvvBcDC8Q1jSg1K7o92J
         GJU3a7PR9wAJkOSz4UfKVT1tiWFfxnut7Ac7c1txgKG8GQd+vY+ajYYQy3/P0L0wl4Iw
         88aTHdupFOBSgZY7ssEmGBje0/Y5EauJQdZM8LzqjxzIypBn8PC7f7QqAGQRTrr1i+f3
         /Dqw==
X-Gm-Message-State: AOAM531ivRRRqtOtd8Ij4ZBzGySMGf9t72fAyknqUPTy7r4DuwjcAoQW
        Z+BXuIwxQWifYyfLo9I45fISsfdXM9Copw==
X-Google-Smtp-Source: ABdhPJxai8JHCMxqp8X4sS31UmBwvEWNtmPjMHP1hin16e93hMDgdBgf569gn3cjaCXUUKrLFNdIVQ==
X-Received: by 2002:a17:90a:9310:: with SMTP id p16mr4875259pjo.211.1614177785047;
        Wed, 24 Feb 2021 06:43:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 25sm3139310pfh.199.2021.02.24.06.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 06:43:04 -0800 (PST)
Message-ID: <603665f8.1c69fb81.6d308.67da@mx.google.com>
Date:   Wed, 24 Feb 2021 06:43:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-2-gaa755e8089ab
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 69 runs,
 1 regressions (v4.14.222-2-gaa755e8089ab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 69 runs, 1 regressions (v4.14.222-2-gaa755e8=
089ab)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-2-gaa755e8089ab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-2-gaa755e8089ab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa755e8089ab8e9e3af90039e42c71cbc4af3a36 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603632064f8f52fa75addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-2-gaa755e8089ab/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-2-gaa755e8089ab/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603632064f8f52fa75add=
cb2
        failing since 77 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
