Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27895324417
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbhBXSxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbhBXSvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 13:51:44 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4677EC061786
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 10:51:04 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d2so1948209pjs.4
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 10:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oLHQUK2ktSdbxbjT+IZ5q+EavrLRBi1ibJetrKMo19s=;
        b=QU3A+TYOfuXyoC4bs/LPnn2OCa2xDZkeU6OrUyv4ZJG4LHZ01DdWAk0/DKUtgoGFBw
         vN8VvLRgplMSMbHzDMH63tfT7NbUtX7A1W1esv1qpKiSx8DB5TD+eXBaTRkpv/s0UWaL
         I0PwkogFvB9jQSGc4lY9CgaN0IyOc1agI6ZNrx+p+SGZaMgHI3rWwi2/t0jDmfzNg0mm
         9IQSr05kPg3easblXPVo6KI8U0GZebLn7am+Jsp1gXIPKPra053d61kM2snZBTjoLGsa
         6Ftvnpe+L0XcS89dCswycaQeYBHtJb1E2gUyTwaOXTMCzW1N5UpfIredjpeKPFAizbEa
         EaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oLHQUK2ktSdbxbjT+IZ5q+EavrLRBi1ibJetrKMo19s=;
        b=pvXUpKvnO5xdps9xwgXN7vvYj8u/UWIBAicps8gQo9ZP+bSb1Tcuof+HGT7BDlqj8F
         yOHbr1us3pKCae8DPe6WMWnwof9XQTlL+bioSIXUnvh7WBwcJIEJtWlY5xiF1+MKZXDO
         tYO+e/RE0X4cRx4EA2owugaOPZrqzh6Wqz6l8WQlOp6N9NbT0/f8WHa1z3TYHF3hZU3Z
         5jq5VTqQnDtG0DnpzOc5kvRE0EFsD/56aXlLywDILPj15fJKR4100fApWi87ofqOa2Wr
         z1xOpg1/wBqvwMDV8Wa42K5f689/neY94R5M+v2C58s4IkM5dkmepsZIqgw/z4Xg72/l
         pmwA==
X-Gm-Message-State: AOAM532k6XnVbwK0puD3ATg488iNn36kOiGuWdOO6FJcEkut7YLx9hSF
        cFixKhtea3ps/pESv99njhqGzPYlJ5Seaw==
X-Google-Smtp-Source: ABdhPJxqmsGzWJFAGZ0hZIyZh8kdktSYDpsF27AMjm1qKnw7ztDEbs8QRDiZwNZLNYqj8BCD2sOk6Q==
X-Received: by 2002:a17:902:7c11:b029:e1:8692:9137 with SMTP id x17-20020a1709027c11b02900e186929137mr34339659pll.50.1614192663690;
        Wed, 24 Feb 2021 10:51:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h75sm3446294pfe.162.2021.02.24.10.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 10:51:03 -0800 (PST)
Message-ID: <6036a017.1c69fb81.459cb.65cd@mx.google.com>
Date:   Wed, 24 Feb 2021 10:51:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-5-gc78acb198d13
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 73 runs,
 1 regressions (v4.14.222-5-gc78acb198d13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 73 runs, 1 regressions (v4.14.222-5-gc78acb1=
98d13)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-5-gc78acb198d13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-5-gc78acb198d13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c78acb198d13debdef40970f9b55215f60b41939 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60367093f127d44236addce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-5-gc78acb198d13/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-5-gc78acb198d13/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60367093f127d44236add=
ce4
        failing since 78 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
