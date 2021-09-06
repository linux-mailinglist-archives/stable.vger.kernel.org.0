Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD30402054
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 21:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243143AbhIFTLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 15:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbhIFTLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 15:11:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D990C061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 12:10:11 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k17so4417366pls.0
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 12:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1cA4HzrBAwY70LiR+1bWKO/V1WAf128yCdEE+eO6/jk=;
        b=hLLpqvUhWJobYbRl9CufWX2szJEPjBw/Yjc2oi+uB5ugvBO34rEXrUDeRcpGgIQlVB
         RgjVfiaqXB+05xUmlMyY2oFpuE/A6NVGWiCzSkjH8mBwi/z0AVVTpnVeSM5Q5yeTDSCt
         or73HFtGWpep9zj176ljfocE+jjznMkdP/wB/8ST74RoZkcDV96aVS3VjxWiMaFh+1xS
         hHlF8oliP37tYY58wTJAnEtGOWBV3aedv7dLzC4hrU6bPeGfzRCsOdN7fg2YOeFFfPIo
         398X62nN7MgHt7RZGvUDr+JPCQ58x8B8CB/rDEWHZBv1pP7kKSGfcdp1BG2G5N3XTjMc
         3gbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1cA4HzrBAwY70LiR+1bWKO/V1WAf128yCdEE+eO6/jk=;
        b=EXhriGenSr70uIgOvbHpE84QC61Hfjc/1733jdG41szYS9VTcmklRRHS8AbIqNInRE
         dCagVXCn9TbxOz3bLMYci6oqBk+yEkgxuX6Tc3JduKTceH0UpvdAlC+GCtInQSiU92jb
         fJjC+Si1hzMg53Y280R9S1CezQZJXULRobwQjwPmD+HxPTqJelgUd60UAKyZ6dl2gmBn
         m0Z+Oqlj67GzBwUybxZ853zwNWj3tvDFyjbxeKP7zrNDvsKzMJiSB3NG6+2vi3fBe1IJ
         pGZdWZ2DgcP9ZB+8dH7oy3yMT/Ho8okz/7UcH4R5ws2xKcBT95M3CXVnDZXj4FPcEmd4
         Uopw==
X-Gm-Message-State: AOAM533lZ4wmuVxPOEjXPF6e6AaiuaDT/G6XDmwaQR856Am7GGn4BDE/
        EhddOy8Gnxy2E0Ro/6Rh/pHzNWxkJGUspgoV
X-Google-Smtp-Source: ABdhPJxmsGoK5eRJY1eKVFeiCAcH6dRrb2Cq7c1BVSYTY6FVrF5eLBUChBcet5vqAzZ5N/M8XMRwhg==
X-Received: by 2002:a17:90b:691:: with SMTP id m17mr519018pjz.217.1630955411010;
        Mon, 06 Sep 2021 12:10:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6sm10226309pgq.0.2021.09.06.12.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 12:10:10 -0700 (PDT)
Message-ID: <61366792.1c69fb81.9865a.da7b@mx.google.com>
Date:   Mon, 06 Sep 2021 12:10:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-1-g23e57b36a0ec
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 74 runs,
 1 regressions (v4.14.246-1-g23e57b36a0ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 74 runs, 1 regressions (v4.14.246-1-g23e57b3=
6a0ec)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-1-g23e57b36a0ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-1-g23e57b36a0ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      23e57b36a0ec20f8d612ed3be1ee91dea39a9cbe =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61337aeb7eca2af7fed59670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-1-g23e57b36a0ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-1-g23e57b36a0ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61337aeb7eca2af7fed59=
671
        failing since 187 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
