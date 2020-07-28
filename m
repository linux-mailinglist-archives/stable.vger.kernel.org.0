Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0522FE69
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgG1ARh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 20:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgG1ARh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 20:17:37 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEBBC061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 17:17:37 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id l63so10879493pge.12
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 17:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=31945vdAQjYWPNNeBqfStM9L3O38CpXPU984c88jmcQ=;
        b=Uk+fmDaSHRlvWiE+NO5iF7XLXaXCA0ZsYt2FwO+5k1I/csp2evDOIBs5OLnF40Nh95
         Zt2YhUv3QJCPnOTdwHoX2uRBSyWjGZ6J9HTytHZ3ZH/XTOtZQ7x4C+wj60M/C7UepGKH
         oqvTNsenln6luElN42pXKOYZkVteT8ChhnRT4QiuhbIVVhOAuevZAAywuL1qkiBsVJ8u
         tGswIuBlxaviM++sTL5NxWhS8VsxwSPI3Gk70n9h4rnUfbTViSQpDit4tSm8DhDEgEzl
         Q/0VhSEkHCgH42mDysLjwUoJ1E48US0AWCdEWOaoa6/EnujZF4rpGuGgS/Vryx39xEUU
         KsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=31945vdAQjYWPNNeBqfStM9L3O38CpXPU984c88jmcQ=;
        b=fYwbmYe8BpKRZRA0zQ/sSipbehSyOqWUrZerPSmwV7gkZtaEBScrlclmpFmfh5d70t
         sDDLCGVW3r9KdZAtHpprXmDuevnisrB2c3v3MEHt72fNG6G4NsTxlExH/Troh+gPE2KC
         XbrbN0x5SQN6wXOs0S6jMu94fdMSs4EuLL47Tl5WGb/8SNCzY6eQcbW6EI6fgiYug1GB
         0xdDAkQhLyfJohbSZ8uoW7In6bFn/K7wv1EhKWzYlcUSzrpKwNsm0CzTwJguTooEh7Fu
         ytm2LO8bhiv66hy8gLxE2Lg/N8S/da9IsmvJSOAC9qGv9E22vgbauKjfKkFh9E0vfWAo
         mKJA==
X-Gm-Message-State: AOAM532SkFFuFoEDp0Dx4/6QH0pOcq8avwoIToTwK+kkTFYSKwDuadN+
        OFkk9giPvraCRZ1NE4qp3MP1BAnwakI=
X-Google-Smtp-Source: ABdhPJx1MV6toMG8SGXWPOjbblf2FwiOT4scgKrx9QLJbdx0pUYtzDzoLzKlfnc7FTf6MGPedsJw+Q==
X-Received: by 2002:a63:3ec4:: with SMTP id l187mr21709967pga.371.1595895456339;
        Mon, 27 Jul 2020 17:17:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mg17sm725687pjb.55.2020.07.27.17.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 17:17:35 -0700 (PDT)
Message-ID: <5f1f6e9f.1c69fb81.b8881.376f@mx.google.com>
Date:   Mon, 27 Jul 2020 17:17:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.7.10-180-g17edbab45dbf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 180 runs,
 2 regressions (v5.7.10-180-g17edbab45dbf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 180 runs, 2 regressions (v5.7.10-180-g17edb=
ab45dbf)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.10-180-g17edbab45dbf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.10-180-g17edbab45dbf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17edbab45dbfdee306397509538f3f12251f23b3 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1f38cad8d6ed6add85bb18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10-=
180-g17edbab45dbf/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10-=
180-g17edbab45dbf/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1f38cad8d6ed6add85b=
b19
      failing since 11 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f1f17c73aeaa9862485bb4f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10-=
180-g17edbab45dbf/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10-=
180-g17edbab45dbf/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f1f17c73aeaa986=
2485bb52
      new failure (last pass: v5.7.10)
      1 lines =20
