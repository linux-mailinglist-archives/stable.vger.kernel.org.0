Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110514519F0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 00:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244111AbhKOXao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 18:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354052AbhKOX2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 18:28:30 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C51EC0432CA
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 14:25:49 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b11so15608956pld.12
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 14:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dzY5Z1UWURSM5a0jajsVu4XPmwaAfj2deYf5hlXjX/c=;
        b=ozgvsrTvEcakblz8Ucd14F2DDEic7bTuUzWl98hQtdwhL1aL9mgM9xn4tPRaRPvZGB
         aCKWqIF2cgKqoXEc/77FpZ8YetwoLQNEbnxRwH9o9WBFpdyP0RIrU8vkIu8BzM75deln
         ScZ8fE8jJu+BPGUjpEGSMSaVrf2NNSv33leBmFzZfA7hNp80UDdapsfmgPTJRhl1tBQv
         chaS41U+N20+L8O/KfgJqV9xn9AJTvmWBvwBF1IsKvcqcVcaLOBD9aM8OfibF6bVO5Rd
         z2sUVYjSqBEP38+BsWAMa291K1OERaAuvO4GZMp4YlQ12au4jk+SNz9yK6Qh4YjXfp3x
         TK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dzY5Z1UWURSM5a0jajsVu4XPmwaAfj2deYf5hlXjX/c=;
        b=KvxqpkNGPSeRasZe1PheqMbIGcWrh55cA0sU7Aj2qMiIwWLjvkPCzoySyBAiXXUDVh
         bAl3UO41ZECC71I+/4j+FlqsPKNhj7X2Qvn79caThybqxlUqrTkS9JUH09FR/Gfhbo+j
         LGbu5BEjFg5b87fl/SDo2yZRSpk9bBf9YDhYJQlNUTnWSOpulD9O0yqeqmKIYFSEYSHd
         Q2n6zCvelDoZaP+Aot8SOqmSmOmYBeJVB8Xe1D0lpKdy/7IiWQuSkAqEGHDuw2yEbo7Z
         /3e9xhBiq89M41oObxSMz9i29LWFV7f7wVLJCwgHeOtql64yua1uizKLXCTTygL39gof
         a0dQ==
X-Gm-Message-State: AOAM533fpdbsAOUFtjiKMVcdFk7Lf1oJKTG54QH+3TLDQSD/N0I12Jce
        MLo6CDsE08Resk9W+ZnETpbm1HdsHYcqWgPj
X-Google-Smtp-Source: ABdhPJzypvHBNuSM7Dh3Dr7oc35zA9J/6j3Jp6Uzf/kZaoy7k5UVkS2fHjprJdvDXESaLisDGw+6jg==
X-Received: by 2002:a17:90b:3511:: with SMTP id ls17mr2513129pjb.81.1637015148966;
        Mon, 15 Nov 2021 14:25:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u6sm16997779pfg.157.2021.11.15.14.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 14:25:48 -0800 (PST)
Message-ID: <6192de6c.1c69fb81.67d7f.0ba8@mx.google.com>
Date:   Mon, 15 Nov 2021 14:25:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-849-gd1986b0aa736
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 152 runs,
 2 regressions (v5.14.18-849-gd1986b0aa736)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 152 runs, 2 regressions (v5.14.18-849-gd1986=
b0aa736)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.18-849-gd1986b0aa736/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.18-849-gd1986b0aa736
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1986b0aa736e7f7e1072589ed19f603f76a407a =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6192a9f409a1b47879335981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
849-gd1986b0aa736/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
849-gd1986b0aa736/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192a9f409a1b47879335=
982
        failing since 22 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6192a9cd7700bd067e3358de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
849-gd1986b0aa736/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
849-gd1986b0aa736/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192a9cd7700bd067e335=
8df
        new failure (last pass: v5.14.17-24-g490e6570185e) =

 =20
