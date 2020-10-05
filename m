Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B872831DB
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 10:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgJEIZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 04:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEIY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 04:24:59 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E35C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 01:24:59 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id x16so5544223pgj.3
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 01:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AA+VB7ktCHzqojZB+Xb+bmRImzr8BNYeBibVV8hh+uU=;
        b=WOAk9HE7c5x5fnzkHGuzstfl90a0zXdcBEQNpPwrGeiEoOfXKZaHHn5/0kpeHVcv5K
         qf+7bloijK/lXIAdtYch/22R+Aj34ywY2e4pkthqASs0TbdHoRQOsE7Hrl67kEB1h4bW
         V1Z5daR6KlrNyZ5GdGSGtUPLnp7PK7jQmAVqev3SbJ5UbeUBEQmrVCdPussvA7C6iAqa
         Rlq6kMtaeKF5DFE2pCI+AsL1jCOsX9t/p46bPp4rXVvpq/dQJ7iQaYOhZ7nppJwHJt8x
         9hBMbuNqn//s7y6r+ZAdzV3h83gT+ZrCZg0WpJRB5FSvaR3iukrCWWSxD4YwGuXmMtnF
         N/eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AA+VB7ktCHzqojZB+Xb+bmRImzr8BNYeBibVV8hh+uU=;
        b=oUpLIxB5OfqQpyD9d0VFZ7RadJ+EmGbTbg1jKZmwzsq0SN70Y6gCPoUFk2Z+QynHrP
         aQ1eLJBkiC51nfy01n6+llGRCtfD+8Eu87hHJDjqNdy1ctUpxBDqsTkkNQ355/NOu818
         iRr4C3/ANwLpA2Y7pvtN8LEwc+FrAjhTCbjNe86CWfYG2f3awNt9oZbiPHHWUV++rYWU
         kxhk5K7fG/QV3QXB6uhzsFG9SKgOHaXu2DS9S0Q5iF1c3s/OVdfr7/+W0GfBdVYRNPB0
         z3u1I6Ig7SYzeFoXgLxTfW4zawPlOAS6oaY+YQvzxSYfmglOIrhk4eGSPgiOR2XmeX8f
         3r8A==
X-Gm-Message-State: AOAM530Gp/KYA/C+h80qk4qzj4IjCzCcszct0q/iGOQEhAd9uOnxFn2C
        GI1avleC3jwhj6vHFEGopJ/4YRPvBaDO0A==
X-Google-Smtp-Source: ABdhPJxOwVPzJPLaA6QKw8vC7YrBvQrvugUGaaCG2CKT5iLFWNXfIjza1t24CITEmCLzVB65/7Ldng==
X-Received: by 2002:a63:3193:: with SMTP id x141mr13484714pgx.254.1601886298693;
        Mon, 05 Oct 2020 01:24:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm9857820pja.8.2020.10.05.01.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 01:24:57 -0700 (PDT)
Message-ID: <5f7ad859.1c69fb81.576cb.3102@mx.google.com>
Date:   Mon, 05 Oct 2020 01:24:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-11-gdc40d64e7e4d
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 80 runs,
 1 regressions (v4.4.238-11-gdc40d64e7e4d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 80 runs, 1 regressions (v4.4.238-11-gdc40d64e=
7e4d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.238-11-gdc40d64e7e4d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.238-11-gdc40d64e7e4d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc40d64e7e4d7e516cb301173fc600dedc62ff7c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f7a9fe6267e499e614ff3ff

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-1=
1-gdc40d64e7e4d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-1=
1-gdc40d64e7e4d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7a9fe6267e499=
e614ff406
      failing since 0 day (last pass: v4.4.237-85-gcd7b2e899081, first fail=
: v4.4.238-3-g44c1a5097bba)
      2 lines  =20
