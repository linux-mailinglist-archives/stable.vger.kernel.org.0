Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11293273CB
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 19:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhB1SZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 13:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhB1SZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 13:25:18 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C935BC06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 10:24:37 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id ba1so8506367plb.1
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 10:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AuUP7LDBvmUdbWmfGkb1mse3S48tVaQf4ijfje0M3K8=;
        b=pWGwLQOVow0teBLz4NcFpiMxpITaWAokaHGZzyQB8f2Un3qNeTQaqWXXgc022KaW28
         LvAnuhSZmoNkfg85DADIBD/GLdCVkkn4NVA5wKvg7/6T+y4/lWpBItzGO/dKEdaXqUMC
         fdkg2MTF2p/0NFyyJPG319NNTJwr6qFs2TvYjtnHjBVG61WDLlXb92uBWphyQzbVMU8+
         HYUdLNT3lFc9vgsoX08SwWDwXoVm/E+hh/Y+X4bbY8YPbr7XiIOC7b9DnXhCOw4A4YER
         qwzBdXq2Ysh2tVO1RlUly7iLC9A8vHHLTX5QSYLNep0H9jzHa2wOF38yhbfRyd5vXGpt
         hnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AuUP7LDBvmUdbWmfGkb1mse3S48tVaQf4ijfje0M3K8=;
        b=ON5MrFi2U0IvoMv2IoW2ssmv1Hdd/3r7vUDbNoPhMR6dwl2bS6x3HakFHIBjYb/ay7
         9sG/9jONVUpyBY/zA1CpLu2WTaH1HtHzcxrVMs9F41CLkMLlOa2etnbg7BFCPt2l2OT2
         JSARLeQfIXBJx1Efe2+4055aWP0cBOeeq0TNEncuMMAhjfzK/OTS9vjtjl1O0WeEphVg
         kLX2dnylUypP0v9rslooIT4jJpOklVxy9oItYHxvrVQE+qUeNeoRAkM5WPprzQtBWScy
         XhWcznvziF66T5BNtqE3ejtWZI+nY8ABm9DKG0FjiBM/V2C7ZnSor/E5g1zj0ZrOFQuH
         syJg==
X-Gm-Message-State: AOAM530T1CqUd+dpFhYsvguMkUZgBeELyrxA3VMqSChybzPNusypeAsC
        RPvnjGdT2uIEfs2NGgYjCwGJpOxXULuvfA==
X-Google-Smtp-Source: ABdhPJzBscSX7mfc3UqzGoAHeMcSfoI+ygL9EaWCDAv3pOp2WItSzcH6Ep995by7DH3wFVotmIqqSA==
X-Received: by 2002:a17:902:e84e:b029:e3:e730:d907 with SMTP id t14-20020a170902e84eb02900e3e730d907mr12465957plg.38.1614536677230;
        Sun, 28 Feb 2021 10:24:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10sm15161950pjr.27.2021.02.28.10.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 10:24:36 -0800 (PST)
Message-ID: <603bdfe4.1c69fb81.90bb8.275a@mx.google.com>
Date:   Sun, 28 Feb 2021 10:24:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-12-g07130f67e5d76
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 49 runs,
 1 regressions (v4.9.258-12-g07130f67e5d76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 49 runs, 1 regressions (v4.9.258-12-g07130f67=
e5d76)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.258-12-g07130f67e5d76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.258-12-g07130f67e5d76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07130f67e5d760912e28be09a73959122ceb57a3 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603bad393d852f0050addcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
2-g07130f67e5d76/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
2-g07130f67e5d76/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bad393d852f0050add=
cb7
        new failure (last pass: v4.9.258-8-g02b1ce02a115) =

 =20
