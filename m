Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DBD32B26E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343810AbhCCAx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581638AbhCBTBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 14:01:21 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D8AC061A32
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 10:46:19 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c19so2519706pjq.3
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 10:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tVs8cZIDGuERh23FwSwcwh2jaS9MWTMEAi5DihijJDo=;
        b=wAc7/aIrdEzKS+A9d9WSQasbKlH/lwD8rvJW7waAAnbN5iNIRyuc5akNwEBAMPWEOH
         QRO/U1328WFd12QOHNHTXZKurNy+JiHiQPzAn4Ip72pP+M+xpDwR/gLMKolfwpT7UQ/g
         CmEeU2khVlmshIz51MmtDdprS+yA/MzBZRGOGyvSDaixrKDdE297+soH+sjGaxuc2iPQ
         rbVXgdqdQNMP33NCbL7ZgPbIRRjdnHJ/d6byoxIvnP1I/xqarpOD2YwaOVTUWNMIYsK7
         TMX7iEQ9nAFAOF55I65EqVuhjHxwagnA2NpmRN1/BT0uclcWvmCOfjy3iVLF8fZLKFyB
         lGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tVs8cZIDGuERh23FwSwcwh2jaS9MWTMEAi5DihijJDo=;
        b=TiQlSH9Kjs4djYtN4wXUmntuvGexvrmFlaDcFfv/awgcA9FbeTrWXEiDuXc3hRUii2
         TwCffAZ9NOcQri8hjO8UXCeFx1YHsPT2l0A0KRU7bnNf9DeOZHHdZm3+cdQRLrNCkhJX
         N0gI9HK4EW22E9sq0OpLpuPBhMGMuyxNJi9WbZ+axplCdjA8fj3o4+sEV0zrnWTuLN5I
         bHIZsYRsGSrLVh+ipyHQ71U9yGtNsAjoB8L/LVyEZgqQwD0TnbtRQVvZ7jvKY6RyyPX+
         PlVA7E75Gdv1aLk0knK9WMx2HI+mkVDDADjaEo2tJzG58iOtgTIINz5+/0ENEyL9hJBf
         eyzw==
X-Gm-Message-State: AOAM533aFj6TfRfQ81D5EnHmhy5OQeJyrIDomP7Atq8iPSBhEtIk3K4O
        KCqEGqOG+WNZr2IPZBt1BWmgYFzw8w6fYQ==
X-Google-Smtp-Source: ABdhPJxhjnmFd8cn6hGCKH5Djd74D1brC8+Du93naq3Fpm4WwrWRenoNVNoCJcOXHyM0SF6V4OnmuQ==
X-Received: by 2002:a17:902:aa0a:b029:e4:c090:ad76 with SMTP id be10-20020a170902aa0ab02900e4c090ad76mr7434328plb.2.1614710778583;
        Tue, 02 Mar 2021 10:46:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v126sm20606713pfv.163.2021.03.02.10.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 10:46:18 -0800 (PST)
Message-ID: <603e87fa.1c69fb81.c2b5c.fae2@mx.google.com>
Date:   Tue, 02 Mar 2021 10:46:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-658-g156997432be5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 156 runs,
 1 regressions (v5.10.19-658-g156997432be5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 156 runs, 1 regressions (v5.10.19-658-g15699=
7432be5)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.19-658-g156997432be5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.19-658-g156997432be5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      156997432be50f8d278763c8454b1beb4cff8515 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e570e5a9f42995daddcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
658-g156997432be5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
658-g156997432be5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e570e5a9f42995dadd=
cbd
        failing since 0 day (last pass: v5.10.19-20-g26d442e567cc2, first f=
ail: v5.10.19-661-g7350d511d78a8) =

 =20
