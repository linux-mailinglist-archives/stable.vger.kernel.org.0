Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5592129A1DE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502442AbgJ0Aoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:44:30 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:36298 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438824AbgJ0AdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 20:33:02 -0400
Received: by mail-pg1-f182.google.com with SMTP id z24so970453pgk.3
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 17:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NDpUyHp8Vudeb13AOPankCgnuVRbGRtr5DN3IKjTHpU=;
        b=tt4CzqhGVe560HN587jOjkYJrYmMKQx0p12GyIAVP4+NkwMxpc90e8BxdPnvLQE+u/
         6NrPhri77SxFhZPbK5MBEDTJvliCrKyOQSNmKe24CUAX23tp6J0CWhj9o8cM8uVxGe5N
         RcLQDU7W6zZcgSEgRp7FgE3e+P7X2ZLI+hEMgXCqXmJ5Wv40AObz6yj/hrZVTW86r2oq
         3kt6bsGbkQMGIgl24UdXR2vPtv4BDxPldaAKG7hx5Cwo+8b7SAjIrmEVn+feNvwQo1Z6
         93TcNdCM5scPDXaV00SpWa41sdPcYeufUEjgZRxJvHWMKATS+wPsOzGxarB6SJwa2i6b
         3Bbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NDpUyHp8Vudeb13AOPankCgnuVRbGRtr5DN3IKjTHpU=;
        b=KKop4JpqsO/hTGdv63/jWgrlOBss+nh3OIIEEmNMYsz1hC/l+bWgwvymnofZB1v8Ld
         /GAyxl6Z6TsLRYHtUQdGlNJx1/PONfpGgbe1lNzScRaWfFnwcOXCiHBGLYdjqeZoWZ6w
         emTEAnqpIjP9x1J0ePFa2QiqqOFHtzCKSq9gikewfzOCHhfWvejl/n03/D2XE/WyRxC3
         LHAzjDigxZGB3cZrhtc5M1KnFdP1AcHZP3msYssRjFuJnVyHVEB5a7rNkg3tmyR6SxPh
         Wc6FtYoJtrOUUIRa/ap3Rsd9SIVo0m4eF5CXG6mHOXCtYxHtEl1RGa2dm5ILEw1a2N3y
         +qpg==
X-Gm-Message-State: AOAM530dZUW2/PIv7HkD4vMLAJPBYiIe5dpstPrY5mzBDSoh3ltZ+6ki
        d6MOdVEgY6t6asdfEJmbeFJ2Fr9dg5njnA==
X-Google-Smtp-Source: ABdhPJwqvLExRd4TBIt1AFlY/FwjTGUlW4EQIm9bovGqD8uWdeo8/RVIZAVr/q7hocNC84xwwle/nA==
X-Received: by 2002:a62:8744:0:b029:162:8c76:a8a1 with SMTP id i65-20020a6287440000b02901628c76a8a1mr450337pfe.54.1603758778810;
        Mon, 26 Oct 2020 17:32:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 20sm12693842pfh.219.2020.10.26.17.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 17:32:58 -0700 (PDT)
Message-ID: <5f976aba.1c69fb81.e32c8.bec6@mx.google.com>
Date:   Mon, 26 Oct 2020 17:32:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-110-g42970a6d4724
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 104 runs,
 5 regressions (v4.4.240-110-g42970a6d4724)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 104 runs, 5 regressions (v4.4.240-110-g42970a=
6d4724)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
beagle-xm        | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2          =

qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 1          =

qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-110-g42970a6d4724/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-110-g42970a6d4724
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42970a6d4724b04c95f4a1bab28425f902566058 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
beagle-xm        | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2          =


  Details:     https://kernelci.org/test/plan/id/5f97386cdea890b8ab381023

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g42970a6d4724/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g42970a6d4724/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f97386cdea890b8=
ab381028
        new failure (last pass: v4.4.240-110-gdf2675c594de)
        1 lines

    2020-10-26 20:56:30.289000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-10-26 20:56:30.290000+00:00  (user:) is already connected
    2020-10-26 20:56:30.290000+00:00  (user:) is already connected
    2020-10-26 20:56:30.290000+00:00  (user:) is already connected
    2020-10-26 20:56:30.290000+00:00  (user:) is already connected
    2020-10-26 20:56:30.290000+00:00  (user:) is already connected
    2020-10-26 20:56:30.291000+00:00  (user:) is already connected
    2020-10-26 20:56:30.291000+00:00  (user:) is already connected
    2020-10-26 20:56:30.291000+00:00  (user:) is already connected
    2020-10-26 20:56:30.291000+00:00  (user:) is already connected =

    ... (469 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f97386cdea890b=
8ab38102a
        new failure (last pass: v4.4.240-110-gdf2675c594de)
        28 lines

    2020-10-26 20:58:15.883000+00:00  kern  :emerg : Stack: (0xcb93dd10 to =
0xcb93e000)
    2020-10-26 20:58:15.891000+00:00  kern  :emerg : dd00:                 =
                    bf0388fc bf01db84 cbadd410 bf038988
    2020-10-26 20:58:15.899000+00:00  kern  :emerg : dd20: cbadd410 bf2190a=
8 00000002 cb83a010 cbadd410 bf23fb54 cbce7b10 cbce7b10
    2020-10-26 20:58:15.908000+00:00  kern  :emerg : dd40: 00000000 0000000=
0 ce228930 c01fb3d8 ce228930 ce228930 c0857e88 00000001
    2020-10-26 20:58:15.916000+00:00  kern  :emerg : dd60: ce228930 cbce7b1=
0 cbce7bd0 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-10-26 20:58:15.924000+00:00  kern  :emerg : dd80: ffffffed bf243ff=
4 fffffdfb 00000026 00000001 c00ce2f4 bf244188 c04070c8
    2020-10-26 20:58:15.932000+00:00  kern  :emerg : dda0: c09612c0 c120da3=
0 bf243ff4 00000000 00000026 c040559c c09612c0 c09612f4
    2020-10-26 20:58:15.941000+00:00  kern  :emerg : ddc0: bf243ff4 0000000=
0 00000000 c0405744 00000000 bf243ff4 c04056b8 c0403a68
    2020-10-26 20:58:15.949000+00:00  kern  :emerg : dde0: ce0b08a4 ce22191=
0 bf243ff4 cbcaf840 c09dd3a8 c0404bb4 bf242b6c c095e460
    2020-10-26 20:58:15.957000+00:00  kern  :emerg : de00: cbbfee00 bf243ff=
4 c095e460 cbbfee00 bf247000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9737db7bbaa48cad38103f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g42970a6d4724/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g42970a6d4724/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9737db7bbaa48cad381=
040
        new failure (last pass: v4.4.240-110-gdf2675c594de) =

 =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9737de045f7bac8338101f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g42970a6d4724/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g42970a6d4724/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9737de045f7bac83381=
020
        new failure (last pass: v4.4.240-110-gdf2675c594de) =

 =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9738ea7c330b8ea9381013

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g42970a6d4724/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-g42970a6d4724/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9738ea7c330b8ea9381=
014
        new failure (last pass: v4.4.240-110-gdf2675c594de) =

 =20
