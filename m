Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8B62AAEC5
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 02:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgKIBiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 20:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbgKIBiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 20:38:15 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C604C0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 17:38:15 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id h6so5580959pgk.4
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 17:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TBsLRnpLhocBiuytCd6E692+OrDrrLHbHvYnRdFna5s=;
        b=C1cfEhRn2EYEK2M3qMbdW5nspihKOE4H1F3jW/DBRJ/8hLfGgY7dd3NqJm8mmjeMDy
         VL2cvltSWuUbsVVYqpgw7H3VwCKDMXmdfn+wlAeFmiokv8zxNhuSYmEmSFleJP0ZVJ8z
         zxd3mW8XKJMXmA8c6EVSOMQHXzrQ+qLlDMavTNCL96dwQ9iZWb7ubx1NVfUisIUh82wr
         uOh/YBdVFVI//qb+CKzx4vo5bXuDt5Iv+cu7OtVXsL/ezMG8NwQMvj3Fq8W219SO5Swg
         7wBgVYU4/Mt3krgpUa/plCneOVxjx7LR5foJgL+h2wBu3i2o3N70gTW55Sac9g1W6ZGJ
         9DnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TBsLRnpLhocBiuytCd6E692+OrDrrLHbHvYnRdFna5s=;
        b=Rm0WcMoqsNJ8gPT5B7EoqrIGWeiqwRgEwnHibPQo/I9u9Mwvmmy4MI1bbP8vMy7sgJ
         JHkcb3cpnazY9ezMuVQNR7J66G/YN+YczFh1NwbkCDFqZ2Fipa0K10SrvBGodrv8JQk4
         zoo6hMl3QR3PZdvC/o+4Qn3p0tlcfpGAKm1jWyX1EldtnXcPnK0S5bHupyfJ4hANVL9P
         VhK+aw4KDf4erFKetd73m8E/Zb30ws3PujCloVtxaNBqx51uv7JZfObzFPzUQWe1o2np
         R5gmkjqoH544gQtNDFWOqWOFeqpUdIXrxq9Qal4jY2EK5hRKyI+xVXjqd+1a2afUXA83
         YPLw==
X-Gm-Message-State: AOAM532NWYosK1VywWmGtwVa/d63fGCGBWw3bfwpY4mVZxXhP5A5F4JX
        XIF3Z+VWMJsO/BlfflffuzqLI9g8qUPqAQ==
X-Google-Smtp-Source: ABdhPJxXuS8gHTY13ROBS5YVTfXpRUwwrEFF58l1QGw9/8wShxM2t0lRGm2s3n3vIk1U677C7BZP2A==
X-Received: by 2002:a63:3281:: with SMTP id y123mr11244832pgy.164.1604885894031;
        Sun, 08 Nov 2020 17:38:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g16sm9382841pju.5.2020.11.08.17.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 17:38:13 -0800 (PST)
Message-ID: <5fa89d85.1c69fb81.538b7.447d@mx.google.com>
Date:   Sun, 08 Nov 2020 17:38:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.241-72-gc04724dc70f68
Subject: stable-rc/linux-4.4.y baseline: 128 runs,
 2 regressions (v4.4.241-72-gc04724dc70f68)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 128 runs, 2 regressions (v4.4.241-72-gc0472=
4dc70f68)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.241-72-gc04724dc70f68/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.241-72-gc04724dc70f68
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c04724dc70f688b73500642b103422ebd68b7604 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa864a89f56f28b69db8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-72-gc04724dc70f68/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-72-gc04724dc70f68/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa864a89f56f28b69db8=
854
        new failure (last pass: v4.4.241-70-g8925fc6112bf) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa8649091c901ed07db8875

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-72-gc04724dc70f68/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-72-gc04724dc70f68/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa8649091c901ed07db8=
876
        new failure (last pass: v4.4.241-70-g8925fc6112bf) =

 =20
