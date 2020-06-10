Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FCF1F4BC4
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 05:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgFJDZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 23:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgFJDZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 23:25:21 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30040C05BD1E
        for <stable@vger.kernel.org>; Tue,  9 Jun 2020 20:25:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m7so404731plt.5
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 20:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5OKWrUKrlUC3h5YZj1Eo8LSryuExnSXJnMzE8hlwNuE=;
        b=QIrJi2kFT3tzNOztKd8Bzdhx0I2HmCknQulgmdfdkXeaPJTxx8zY78w0zGVwHy6Vyh
         u2c1vmbb93g+euKo1FkbP5p8EUiJcZe0Dtsylpmb6F98HUIC0lh4w3hZVnoiMCfpcUFP
         Vz4ACnYG756L0zcM7C1f2BxDc4ZBUyGHhVR6awF9s4L+ZNCb34jEL80pQNaQZ3hn4yl0
         EFGLh9WIYagYKGy+d/ZF5FewcgEvw1fETdDGWdnqxiOIs7+bhIEp/w4DPEK3h6j1R62Z
         PafpUCUzpE4zUh5gIVKKpDjPS/+RHsm65qeUK80s4J3YWaa8OcHOICfqzPdEWP1f7iII
         7+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5OKWrUKrlUC3h5YZj1Eo8LSryuExnSXJnMzE8hlwNuE=;
        b=FmdDY0b2A91bFc0BudH8MUT8K/+tZtyU41mrrbBmjlD/YUhPHXcCISoZYUID7Fk6Es
         0ttQT5J6eGO25vpaBd20atcZ1YoZflQgznNzjXI5VOIKca6ZWMgyRk9gvrOMaRzPcbto
         A1q7IMc+57pNDOHFC9p2xuiAKW8ODnkOMHqIwbqeDug+Q4P4I1j8155qgupSs4HWj7kM
         upl/gvkyRfrckdgVjkQzCYg3MuGCDH8H5ze/BrB1SN7bP5XX7zhQ/Caoxv0bQcrtLUX3
         D90L21ylNScHcZyJptgsxwQcSI4fe4auK2jgRuBu1a7L3AH4t6KY+JovJm/QSm6BK81K
         myZw==
X-Gm-Message-State: AOAM531ME3MXryMsjijIQY+3ngMTpjIGc2Z0mbEIoks1x5udcpYZ9lbW
        5ngLhV98ILMvIlya2bNvgVmjv3hKTnY=
X-Google-Smtp-Source: ABdhPJymgAlH/6H2I5Jzkuw2daOlmXlx6WrO/fwVkb4Q71pqhUrwQ9kaPCjFiIwFa2OoBAX6YloTfg==
X-Received: by 2002:a17:902:558f:: with SMTP id g15mr1274308pli.174.1591759520284;
        Tue, 09 Jun 2020 20:25:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z24sm11029115pfk.29.2020.06.09.20.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 20:25:19 -0700 (PDT)
Message-ID: <5ee0529f.1c69fb81.428ac.8690@mx.google.com>
Date:   Tue, 09 Jun 2020 20:25:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-55-gf6c346f2d42d
Subject: stable-rc/linux-4.19.y baseline: 81 runs,
 1 regressions (v4.19.126-55-gf6c346f2d42d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 81 runs, 1 regressions (v4.19.126-55-gf6c3=
46f2d42d)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.126-55-gf6c346f2d42d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.126-55-gf6c346f2d42d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6c346f2d42df9a649df8616aa529f7564b9c0b8 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ee01f0dbb1824030c97bf3d

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-55-gf6c346f2d42d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-55-gf6c346f2d42d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ee01f0dbb182403=
0c97bf40
      new failure (last pass: v4.19.126-29-g65151bf9f715)
      1 lines =20
