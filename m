Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA4B312E87
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhBHKFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhBHKAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:00:09 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEF5C06178A
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 01:52:01 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id q72so7954813pjq.2
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 01:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u3Gc2/WwyjFKI8jGnSonWEgmCatpIvXB9FTzuPUMlio=;
        b=u0Vs6LhwBMXyJ+Gfj7DzCt8USl0Y7mUGVn3r/P4BWt+vTX2u8XEre5tgpAGI33RN7d
         M6H0lO9nNScMwbSdciwvczEtaB41EiTu9pwhubUhh91dUh7SdqVeAh3td01yTeW9M2Id
         XLB8TvIVzuo25Atfd1rl0vwlQgFuwEVibIBjANpKEK6MarpHwnm42GH6pxV4imuZ0lgm
         awGxnVmhBfL8Kstb9Q48eTLgs7Czi9Af6PLHPKwlzganFzDhbrexCyqO6U+zfdjfXQ5p
         9YjMXHLEr7wF5q2qzPemcRWiIyY9b3IOAu0SKhuYU6fvh0j/J/1kwhaFwSIZ5wg844UP
         tliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u3Gc2/WwyjFKI8jGnSonWEgmCatpIvXB9FTzuPUMlio=;
        b=pqMHyYlQf8J263lZXvjUGEZSExLq6I2ZmYu7sonfXu4UzcguiSriHbBikSZ+XUtkXR
         nhtxVRi0J3eqd7QxkVrEBESVnzp+uTdV4dtSRR4S42WMOK/w5yBEXAQDoExdM1SaXuOB
         EGkkb6v4Zx46FrI8evJZf6wTN1X+P+30X3X46EDvhf4wozQdKE9l3t+fSt4fzZBtSR1R
         Ctk/4/K+ohP4lAQ7ZZVh0ElliVpYmIKNT+t4GF6blNPtQJKKJdcu3jq7ZY+bAEZEykYI
         xLF4t7a1yikEb1JUd9oiggbqAWjillOXmAY+C3rN8VfOqOqeeHsWG9FoSYJNG4By9rv5
         HFEA==
X-Gm-Message-State: AOAM533RPMAsbSD9Qnj48l/dc/7GNf+IvPnL189JYLYRfR3eNjKm/KwS
        YhEZbzV0S+ROWttdECZb59F2Mbtq3wq7nw==
X-Google-Smtp-Source: ABdhPJyq3xWQ/PbA1XgqR9rwNjlz9mUypVwxmyHWILUBrjhAe+QduOiNidmCuHJn5qn2bAYd78RV7g==
X-Received: by 2002:a17:90b:885:: with SMTP id bj5mr16071570pjb.195.1612777921166;
        Mon, 08 Feb 2021 01:52:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3sm19487242pfm.144.2021.02.08.01.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:52:00 -0800 (PST)
Message-ID: <602109c0.1c69fb81.2e25b.bbe3@mx.google.com>
Date:   Mon, 08 Feb 2021 01:52:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.14-4-ge86cf3211995
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 124 runs,
 2 regressions (v5.10.14-4-ge86cf3211995)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 124 runs, 2 regressions (v5.10.14-4-ge86cf32=
11995)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig      | regressions
-----------+-------+--------------+----------+----------------+------------
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig      | 1          =

qemu_i386  | i386  | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.14-4-ge86cf3211995/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.14-4-ge86cf3211995
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e86cf32119953b4e9311d14d835bbb614f84e7d9 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig      | regressions
-----------+-------+--------------+----------+----------------+------------
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/6020d3ada7f89474f63abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
4-ge86cf3211995/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
4-ge86cf3211995/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020d3ada7f89474f63ab=
e63
        failing since 0 day (last pass: v5.10.13-57-gadb6856092da6, first f=
ail: v5.10.14-4-g5bf21c370d20) =

 =



platform   | arch  | lab          | compiler | defconfig      | regressions
-----------+-------+--------------+----------+----------------+------------
qemu_i386  | i386  | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020cea5006d7192c03abe6a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
4-ge86cf3211995/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
4-ge86cf3211995/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020cea5006d7192c03ab=
e6b
        new failure (last pass: v5.10.14-4-g5bf21c370d20) =

 =20
