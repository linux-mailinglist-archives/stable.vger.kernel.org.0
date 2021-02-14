Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A085031B06E
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 14:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhBNNFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 08:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNNFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 08:05:37 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE43C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:04:57 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id o7so2720394pgl.1
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oiNZtC6FD3GF4YYz/tlWZ9+ReRG/8vGGC8hk+M0CSa8=;
        b=q458gGLMOiKmbHly6Sze5dobQ607iffN163b+VqqElWiLv4T/Kzn3zBodkqekY12JK
         SCH6XstqFZEpU1NHMoEpo5EAA/NmO/qagDcOKWvlyiAn/HQ1tttCI/YLgMgOw+I1eyOA
         Wpy1iduKORyUZgTZTT/jTyNMpJM9Itjj3tn+ptehPl01XrQsGx41DOQHY8E2bhCD1HwS
         DwyaceqCXIGN3b3KN31YoLh4uixEGWgMupfCbEi/fiC8ABm+45rEZjP3CXq4DlwN1Lj+
         hJJ6cRUvbKZJ+cgL769kF/Pc9BiW6oPQvQj4D7itcJ6rxmR4pM6v4OCY742MxmuRnLAY
         pKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oiNZtC6FD3GF4YYz/tlWZ9+ReRG/8vGGC8hk+M0CSa8=;
        b=V5b02+WHvXri5BhhNqLqJqmuAeaagyGzMttVXTXZCGfEYRS/SscpjIXYR1BalRmB+S
         /LzSJLwU5jBNbLwFkge0ufuslKkptvowIjKN1RAMo2H+EN2j+dDY3bjMaaO3p7TAY5zG
         l+F2bCSW8tm4jn6/xOW7fi+ix6LhSlEB+Bg3H7IIjf41bNmIHLIWF96iGRAYBkbo0RVA
         CH6GiZrR+4NhYY04F76dRuaW1rxgWGyxCT1QYNZKeBMUA2T2O7oyBDxAobfcLhQEGpOi
         kz29Tp41uAmjB/EtfoOJYnJ7KJqdIXAJ0vdeo6yqUIsnbtc8O0POro18bw2/2LrMGeKp
         OYJg==
X-Gm-Message-State: AOAM533w/ttwHn2f22UYo4PcHBhf5SDMCZJUVGql7nVdof11GCI+FvHT
        R04zDYiWzaKjIhiAdLP7C2yo7MghJKbTwA==
X-Google-Smtp-Source: ABdhPJw7l+XTKlp3e4wSw/Yew8TBz/63tSGCmlY/8teOfWcvaV6FUEO8rokkGTwHsZ1me8iSM8pRAg==
X-Received: by 2002:a63:c4a:: with SMTP id 10mr11369654pgm.397.1613307895872;
        Sun, 14 Feb 2021 05:04:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x13sm14558012pfq.34.2021.02.14.05.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 05:04:55 -0800 (PST)
Message-ID: <60291ff7.1c69fb81.34570.e4e0@mx.google.com>
Date:   Sun, 14 Feb 2021 05:04:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.16-16-g8827cf44e1519
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 98 runs,
 1 regressions (v5.10.16-16-g8827cf44e1519)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 98 runs, 1 regressions (v5.10.16-16-g8827cf4=
4e1519)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-8    | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.16-16-g8827cf44e1519/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.16-16-g8827cf44e1519
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8827cf44e15197491fabfa4d9892e608b8d32e06 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-8    | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6028ecba134daa75f33abe70

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
16-g8827cf44e1519/arm64/defconfig/gcc-8/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
16-g8827cf44e1519/arm64/defconfig/gcc-8/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6028ecba134daa75f33ab=
e71
        new failure (last pass: v5.10.16-1-gac3c05f5f0a2) =

 =20
