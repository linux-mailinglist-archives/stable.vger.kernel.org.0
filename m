Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88036400508
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 20:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349237AbhICSom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 14:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349387AbhICSok (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 14:44:40 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3FCC061764
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 11:43:40 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e7so6366524pgk.2
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 11:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nue8J3RpCxJT44Z5J/eGCkOqzOvouW3VOhRUTOw7tuc=;
        b=UdnSkZ6G9HGTRVIwB62fp/FudmE7D61IbcLuMHLYTXMsHn93OuDZMyJnN9oVy6aBeq
         kbUZeh1gi70Kbp3sgZwNcYuLPvzXC6gPqRfwpsIHz2eqDw7k9t6/LQyQqCtVEN6U0IVC
         yNExlarGB+D/Dw2ENXZyrOK1twFvWbL5Wpo57EDD2ZXYIoLO7F8rioXE0qK3i0ZqD/Yd
         KgKwhJXs/q91mH1LZZNcF3n407/UWkwYPP/xcKHCOVyS/Zks6ZpKLGT9UINbtwjcN6Co
         NiqyiAUZNpOT9VHyRj4ReSNOh4YNewUASQOVxiPax6kYYhqnJd6A+ZYsRKJ/2hctTfuX
         Ublw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nue8J3RpCxJT44Z5J/eGCkOqzOvouW3VOhRUTOw7tuc=;
        b=Wv9SwQP4oqKGqRbDZOLPlNRA2B3noKO0Dy6HIJV41Ov3vLwHiKx5McG+5gXOaD8533
         0JqbeU/A+AludJGxbGoa8IzVG0GklraAofjaFhcxZSrwZuoKaNEdwnOmfjA9USx8Ru4p
         VOFfnFqivOZsT5TgW89OD1BHMY8zw+/PJsH35HTEaBaDN0EjueK6ukKeOpsq20U1GImL
         vdLabffM2lS2+60CiFmBBdm/oPbre+XkJGyEp6wzhKCZzWAw8XiGxoYGpmyKCtW+aeR9
         m+mWS/zpUYCWpjS5Eo0CEgT47t3eQxDLYuP17ISt58gfW0LRYUoO8Ww+y2EhltR647Ii
         J1gQ==
X-Gm-Message-State: AOAM532Bjh6H+bE1xaKbomaOJegP+dDDyaPlQIRm6Z7Qu1whMZQ3AMIr
        V/Jcs/sn83neg94R7QWMTpgVpRKaYNH2tA0d
X-Google-Smtp-Source: ABdhPJwU3S7RlqajXCX+l593x1a92aw10+7wqg/Q/i7AOlrA9qlzBtjXLUrelKdbPRF9NTyaHszHKg==
X-Received: by 2002:a62:e90f:0:b029:307:8154:9ff7 with SMTP id j15-20020a62e90f0000b029030781549ff7mr291445pfh.79.1630694619812;
        Fri, 03 Sep 2021 11:43:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16sm125460pfl.58.2021.09.03.11.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 11:43:39 -0700 (PDT)
Message-ID: <61326cdb.1c69fb81.2d8dc.0895@mx.google.com>
Date:   Fri, 03 Sep 2021 11:43:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-1-gdb634ba118ef
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 3 regressions (v4.9.282-1-gdb634ba118ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 3 regressions (v4.9.282-1-gdb634ba1=
18ef)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-1-gdb634ba118ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-1-gdb634ba118ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db634ba118ef932d1ac044fc3796f70187aaa3ee =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613236380367e8229cd59698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
-gdb634ba118ef/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
-gdb634ba118ef/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613236380367e8229cd59=
699
        failing since 293 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61323db98d33b7252ad5966c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
-gdb634ba118ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
-gdb634ba118ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61323db98d33b7252ad59=
66d
        failing since 293 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6132364c0367e8229cd596b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
-gdb634ba118ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
-gdb634ba118ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132364c0367e8229cd59=
6b2
        failing since 293 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
