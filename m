Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E602A4B02
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgKCQTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgKCQTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:19:04 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB375C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:19:03 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 62so6768234pgg.12
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S9UpUhWWpvXMHcn5An6DZis0wOEL4tvQOFvc2dvko5M=;
        b=n4nieuDiT99TQqPhp5YvKWtElTN4CLdnItl5AAvsV2kYSkSspF2gRKttk/CjRJXDZS
         ujqwkMtBK1Jg0atBVR2/BreucnOOR5UB6JNILREbIfwwT+6x7svc+hyE8h6FtoUxQbrq
         nf1eBc3Zse78+3MGbag/s4DjKFL0JAXfW/Eru8cQ8Qug1J9lQhEqtxjPvfEAQRk4RRqY
         kAz6N6tcJa3qRE5rIG4izPsDtpRl2KetmmP1q7d3kQJQ+OSHSxGofytnnBnMWg/wqE+A
         DhZf/HegceKsaREikB2FrejwySZVYnPFSIs2BHEf8ALTywyIV3V5J8nE/Ia0k1ExOIps
         S+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S9UpUhWWpvXMHcn5An6DZis0wOEL4tvQOFvc2dvko5M=;
        b=uPvZRQDydJtAU62Y3emYtrla3JNqQ1q8b8qTQSvZDt6SOor734dYKAYe4trly0HPL2
         6B/a3hdb+puj7zoJ19qaj+NLB1SrWD7fZMiB8wSxjVVRO4OqhEhSHGBPucPm/ag4G9sZ
         6S1Os53OpE7MrE+RTYcCwvY1jAr5ZdnbXxPRi5rahLBekc6p9jJTdTvxLGUj0LIZqm/f
         TAohq+QS23dBD1/2gpHSJyBJLEI+EHUl4U57c57wmyXuEFsUYqq9bv3PIz6bLk/Gf/XT
         b7PrRRC3r5rObDvV8s7uO4QpLQjJKTZ3U/mWBy8MkTglSYtZsgU0IWv7f/X7/pfic2A4
         XG8A==
X-Gm-Message-State: AOAM532WnuA3dLpw5RYDmo2x7S/IjZkwil+rsM3J1IQAOYF3Ya9Yhwef
        gjuaCUdXCp+uOXwpdlVMcwvAtCtFOzTIqQ==
X-Google-Smtp-Source: ABdhPJwy0EEPdsivPVX2MIZzvbhvOdRjnv13jrmPXKEIdEcmXsTbabH+MeRbAu++6sBTDwHhoBO0kg==
X-Received: by 2002:a17:90a:7bc4:: with SMTP id d4mr610642pjl.48.1604420342831;
        Tue, 03 Nov 2020 08:19:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mg6sm4086329pjb.40.2020.11.03.08.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:19:02 -0800 (PST)
Message-ID: <5fa182f6.1c69fb81.d5e61.9a4d@mx.google.com>
Date:   Tue, 03 Nov 2020 08:19:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-47-gd40a052345b6
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 150 runs,
 3 regressions (v4.9.241-47-gd40a052345b6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 150 runs, 3 regressions (v4.9.241-47-gd40a052=
345b6)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

beagle-xm             | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-47-gd40a052345b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-47-gd40a052345b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d40a052345b6f1081e1e50f3fdd9b46f709e6f32 =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa148a8b7494722c43fe7df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
7-gd40a052345b6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
7-gd40a052345b6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa148a8b7494722c43fe=
7e0
        failing since 5 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
beagle-xm             | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa14b2235c4b87c813fe7d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
7-gd40a052345b6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
7-gd40a052345b6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa14b2235c4b87c813fe=
7d9
        new failure (last pass: v4.9.241-44-g29192a9a3096) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa149c779f169bb913fe7ec

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
7-gd40a052345b6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
7-gd40a052345b6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa149c779f169b=
b913fe7f3
        new failure (last pass: v4.9.241-44-g29192a9a3096)
        2 lines =

 =20
