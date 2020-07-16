Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4DD222BFD
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 21:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgGPTcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 15:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729703AbgGPTb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 15:31:58 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63101C061755
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 12:31:58 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gc9so5296521pjb.2
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 12:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6IbZERBIlWuYDSMJeYviO2iuEag7hE7HVXx+FrihYhk=;
        b=OWGrM2YKFUARKgky7XK/A6Bsk+hUJBEI2KYyfbOhn04BRgwC42ma/F/jljFWy3RW6P
         OmTchO7H44A0Mx+4Jsz7NyvpwDIT9YrvkRpbV0UE5vwV5CexwR97VEnFHE+5s4ApYKV5
         0FuvxG5TZHPnLNdwjme7aq7Vu4bysGOSoHPVEnDwu7xYq1sDjJ1PJpVitMaVypUqGLlS
         at3iq6qX+R4TSinidB/j/hwtDz2XKDSAxz4uqGO8yBcoWXg0hGSUFHQ77TSlT52rZkKs
         VNjm8+na0DCQKuZZnoedQtNw/1YKqMk20+CwkvJ47snGE0nKK8eMGN8rJP/8Dc26WJo4
         nenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6IbZERBIlWuYDSMJeYviO2iuEag7hE7HVXx+FrihYhk=;
        b=dmEhcoDwyiEUyxMLT6n4QFPWDNGIOkw8mWx48ebk4YImqZ9LIbvhr+qIVjqmRNyrsD
         R0bAtl9ktreCDy3j+ftjuHQNHiG/UdDph3HgpAC7GlLV+OK17S6jrEp6ZOJfiOd0Yp3N
         OGKe+NR4I3NQDQJnmwBfBySn+BpKj/Pfb4KrZSEYQgvcOwU8asU389zHJ8TxZ/iX8xT7
         U6mTPI1wTMhMFtjj2leUG3tjmJCF5aHabAuumu5PnxBwQYpDaexRkPJh3JFb4eyQdqcv
         BBhnLT5ZsQ+eChDx9mCVSz0O/XVk+KXAeHGart2oTP7UIlWf0Ipz853OPT+VJel8wAh3
         2g7A==
X-Gm-Message-State: AOAM533W6o1kMtp8A8b6gejdDNkRU8E/3e5lDCustv+sJtWXaoXF6hww
        NU76oOqAgdxc+8NO6xeH3B0kmqwp7jM=
X-Google-Smtp-Source: ABdhPJxVakQxtOWXCdqCRnplDaQZ4HbDK1IeAyJ7r9Iwwv2wK+FAgzY/cW7ZyBchSqhtoFqm0wjOHw==
X-Received: by 2002:a17:902:6194:: with SMTP id u20mr4866040plj.68.1594927917541;
        Thu, 16 Jul 2020 12:31:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm5575533pfo.123.2020.07.16.12.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 12:31:56 -0700 (PDT)
Message-ID: <5f10ab2c.1c69fb81.7c344.0220@mx.google.com>
Date:   Thu, 16 Jul 2020 12:31:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.188
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 138 runs, 2 regressions (v4.14.188)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 138 runs, 2 regressions (v4.14.188)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.188/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.188
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      56dfe6252c6823c486ce4b1a922d72abc7e3c6b1 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f08f975ae00d04f6785bb1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f08f975ae00d04f6785b=
b20
      failing since 101 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1074d3c0bef8864a85bb19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1074d3c0bef8864a85b=
b1a
      failing since 101 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20
