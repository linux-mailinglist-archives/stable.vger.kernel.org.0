Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E393FABED
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 15:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbhH2NUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 09:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbhH2NUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 09:20:07 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF183C061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:19:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mq3so7679568pjb.5
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OmMzjZbd1GjCFj0rPrhoAnBTKb5TmOA1DZ7YucpgGzY=;
        b=kgyU2S/wLlXRJ8nvRrjuXb9NMckISdhXVR7+lFmAVaKftLpM5qd4FiLjUDlzxpoaEz
         ZPcovyt+t/KCRoCVDXuehDle6mHQuuF+mHs/Lr4gBlyEhONCUaKZGvtXrXeXhOMCNB7S
         uHO8pnVbNcKhDKPdbPYZ15ah0/DXVWuOUc2sDYyhWWr7tv9Xw0C3EM78zmZdmo05AU2v
         ao6gqMTgqwIqFRSGayDgCVokvC0YnGO6FlPVQSwULbjuZiHA0CjlrwJc82Vt8Q+NImHM
         uAoCJfq1DCtaqYcuKKeTxdbaYxx+dvIwz4JzyJ7Mr0isi2m+m9kbKimD9QGT8l5C0Phn
         GtCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OmMzjZbd1GjCFj0rPrhoAnBTKb5TmOA1DZ7YucpgGzY=;
        b=cVxksFnGr9xdQjbWU+ywbCd4Td5t0b+ccTE0LtGRHXqqnG9IV7LD/6Q0+Bgt6P2gAS
         ZmRf99erc72Rd+eUOyr4Qb6wehIS7hpUeiVx1sA2tSl25Vbn5QRXv6k7FSEgHQE1b5Rx
         1UKYKoMNYY3At0wIfKcZBWzDpDb/I+aJgBW00Op0OA1VFMdOue99xs9iSrYjX+OiEXE8
         2TaP5CUr71zUDTbX/a1JzPZAFlL/bz4O9j6vYk4z9ybnzB8c1uB0FDculuWpgtDZ0Az+
         FL7+X/9RvmmJz46ybDcMwaOWt1MsicuIYenbIpxf18CgizxA49I9PXD2QU0YgXr27ty7
         rmKw==
X-Gm-Message-State: AOAM532oTN5l1KnLYO03E/6yOTC+zk7TErzO7Qr+vP7/N4hUsjXy+rbk
        g2WrSWgkqc/pqHCgOgDgD5bQxtIT9cXNpzWB
X-Google-Smtp-Source: ABdhPJxW1qASdszJnLPeO14N7Vbi/hbCslCzwlO0sf9uG6WMMjvuuVaTZh5MYAmbKJ+vkWSHA3jC6A==
X-Received: by 2002:a17:90a:12ca:: with SMTP id b10mr21290202pjg.180.1630243155209;
        Sun, 29 Aug 2021 06:19:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15sm11754902pfl.181.2021.08.29.06.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 06:19:14 -0700 (PDT)
Message-ID: <612b8952.1c69fb81.d6285.dab1@mx.google.com>
Date:   Sun, 29 Aug 2021 06:19:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.13-34-gaac007a8336e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 169 runs,
 3 regressions (v5.13.13-34-gaac007a8336e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 169 runs, 3 regressions (v5.13.13-34-gaac007=
a8336e)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig   | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.13-34-gaac007a8336e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.13-34-gaac007a8336e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aac007a8336e8698e1ddb238179f2fb3961cf654 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig   | 1          =


  Details:     https://kernelci.org/test/plan/id/612b548e6432bf5b618e2c8b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
34-gaac007a8336e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
34-gaac007a8336e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b548e6432bf5b618e2=
c8c
        new failure (last pass: v5.13.13-13-gbe4cd3483df8) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612b58aa1e60ef262c8e2c8e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
34-gaac007a8336e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
34-gaac007a8336e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b58aa1e60ef262c8e2=
c8f
        failing since 31 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/612b5922ef8c0b6f518e2c9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
34-gaac007a8336e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
34-gaac007a8336e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b5922ef8c0b6f518e2=
c9d
        new failure (last pass: v5.13.13-13-gbe4cd3483df8) =

 =20
