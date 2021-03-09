Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FD5332CB3
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 17:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCIQ64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 11:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhCIQ6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 11:58:25 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3F3C06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 08:58:25 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id p21so9172663pgl.12
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 08:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PVPFo21D5YycX34STND3Y79x0WoTpz/Yzcv/fEQGmGs=;
        b=MsWUl40hyjdn2vykt/zMZKmzNbVoBLogexCoqXki4JdLYUqo/q12U4sQMTWadrxe80
         63cMng7/W2PbLYX6NSYNimxmNTWHUTLXSc8GzP50oXEkcAZQAtq2NRBtbuESB/lLMP84
         wd8+2rP5JT/15ceEwDDIptmFK97rIsqtdBu+Wg2xGHXr+6Y86SqbyyLZUrlMe05/qmv8
         DWlI883yoQR333gZsRSLff141kHzowrP+bm7fad/ccp92D3F+lyq5FDRApnjHE1PXpTK
         KvorwjwwXAOo2vY8TIY6TN8T67uRGy5WwShE5Kb9+oOS7a8DTvwtBVbROkFfUpc/52vO
         n04A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PVPFo21D5YycX34STND3Y79x0WoTpz/Yzcv/fEQGmGs=;
        b=dQ0XwGSJmJ9Aj27p8V3mWwLdx8Foc7N9jH5AGL8aM/pSBt97kzRtw3W2Bo+42ZijKw
         M1RxHYtKbjy4WHqdycM8DGs77/PG+rZtXHPkWgXVBk4Q4qB/AVy5kRVpnsijQiqyFU5H
         ByfmSeXdBg99ogSVzsMrvDqWMKjp3tEJeIEvH5kR33J2KC4XJRoykHn7o3xy+sYNwZ0z
         6QDTM4+pmRx9Ja+0809771kNsKPt5oZGYSYX29HW16KpLv/w59DRYnbPTXgJktI44ZzS
         VDc3uKGX8QHYXKLeIEKajpdGYFtLt0RXrKEzAQgdT87g0nfy+jcwf600AsstGPIRdiiZ
         ww7Q==
X-Gm-Message-State: AOAM531Xk+ju+he6v/L39jbmTx5Ab0BlnvSay2yf9K7kpIFDQQaut1nR
        jsZXfo/s1xbVui9iWUwy8LLy6jc5M1usTlD1
X-Google-Smtp-Source: ABdhPJw6Leu4eIm2qmP3NWZ2reVe6ZURpUHM5iKe3K+mkUBI3cGvBVdMhB9xqSOCiLCqOYGsNg09YA==
X-Received: by 2002:aa7:9431:0:b029:1f1:52fd:5444 with SMTP id y17-20020aa794310000b02901f152fd5444mr20750663pfo.47.1615309105195;
        Tue, 09 Mar 2021 08:58:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e21sm12683863pgv.74.2021.03.09.08.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 08:58:24 -0800 (PST)
Message-ID: <6047a930.1c69fb81.5c269.01b6@mx.google.com>
Date:   Tue, 09 Mar 2021 08:58:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.260-5-g5418553745479
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 90 runs,
 4 regressions (v4.9.260-5-g5418553745479)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 90 runs, 4 regressions (v4.9.260-5-g541855374=
5479)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.260-5-g5418553745479/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.260-5-g5418553745479
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5418553745479bbafea76bd2a08fbc97637ccc77 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60477d363e2765b8c2addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5418553745479/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5418553745479/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60477d363e2765b8c2add=
ccb
        failing since 115 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6047801fbdbafdd755addcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5418553745479/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5418553745479/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6047801fbdbafdd755add=
cb7
        failing since 115 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6047770949457a477aaddcd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5418553745479/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5418553745479/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6047770949457a477aadd=
cd7
        failing since 115 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6047a23d62f1c85182addcfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5418553745479/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-g5418553745479/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6047a23d62f1c85182add=
cfb
        failing since 115 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
