Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE833FB197
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 09:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhH3HHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 03:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhH3HHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 03:07:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B28C061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 00:06:26 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id oa17so8826752pjb.1
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 00:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nv3b7NIPW6oPQ3qM8RytmVnGIi1swvf0XSWWnsbsPks=;
        b=oIxC6H8uq/8Ijkut6u5KTVQIEwwnI0Kxdh1wLL8EjO/SSndnL4IH2Ixf3fqghTE4J7
         a4JZYqvviZ7te3rE0+WpEblYPEdNhbEYcEJCH8IwGJ7l4EJVzInHy1UuFOmbibMFYOB+
         IWvAcATAK1LSuKeH7tfYjYX8c+3IwKsCbrCeCTM1u5EIQU/rOEz2v0eqJqPnr9wsmXGA
         QR2lwLzo4ZnRJ3TfdqKoaLRmtC93ct6llHEAQ5EqlMcAxZANRjeuQ/m7IriYrB8QxuRy
         yHDSnQQmeFqIpBm7ZQxE1o8CXI5wsbCn1PMl6IvlUglHJM0tgatpqsakpFi+U9obM1WH
         q9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nv3b7NIPW6oPQ3qM8RytmVnGIi1swvf0XSWWnsbsPks=;
        b=j4sYvZtK3421Zf6p6bniFPdtuwwROINwHLBW4TAuan2kRw4JFIr7kz3KlhAmADhIV4
         WZ+WI3H+ydM/f8XjWpJOXm+t5QTJ2NLFLCilIUvcqi75bLKqf4XdImqrEIcxJ02MKHOX
         ihdQh53vHDWUdLQe0tzqAX7vNdSIomBy6/IaXRf62Chz5MjdiqgprT6l0qxlAq5wmuhQ
         9q/FrXxI+kWU1Gr8DYdwKrwY+1llm3rLWqvm0+D4bme1IelJCzcC46xbNxwuLJh/cP0V
         whzMeVB6HM3UYxOvvsgLg3YFuFMQ6pbGejTtA5uVd5PjpsXiB/sW5NtvunMz0PvzFDyw
         9VmQ==
X-Gm-Message-State: AOAM530OV83yjWgEcBU2nbUhe/Wbsx9tyoIxueAfCSpqWlGZDADMRq8S
        PTJErYGYULpL2ZbmOQgZkADg0+XczHvA3lMY
X-Google-Smtp-Source: ABdhPJw+Lkbkwnwv3Jer3IW8o7Hw/C7GpShloHuvqr7bwxQLMyprffiL6oXQR/7qtg/TYvod8CUpKA==
X-Received: by 2002:a17:90a:df17:: with SMTP id gp23mr12147025pjb.12.1630307185558;
        Mon, 30 Aug 2021 00:06:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j5sm19417953pjv.56.2021.08.30.00.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 00:06:25 -0700 (PDT)
Message-ID: <612c8371.1c69fb81.55ad0.1e7e@mx.google.com>
Date:   Mon, 30 Aug 2021 00:06:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.13-73-g193ded4206f9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 157 runs,
 2 regressions (v5.13.13-73-g193ded4206f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 157 runs, 2 regressions (v5.13.13-73-g193ded=
4206f9)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.13-73-g193ded4206f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.13-73-g193ded4206f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      193ded4206f90a4978529ce01c628422f4568c6b =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/612c4efdbf3ec115f98e2ca4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
73-g193ded4206f9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
73-g193ded4206f9/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c4efdbf3ec115f98e2=
ca5
        failing since 0 day (last pass: v5.13.13-13-gbe4cd3483df8, first fa=
il: v5.13.13-34-gaac007a8336e) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/612c5157300765914e8e2ca0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
73-g193ded4206f9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
73-g193ded4206f9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c5157300765914e8e2=
ca1
        failing since 32 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
