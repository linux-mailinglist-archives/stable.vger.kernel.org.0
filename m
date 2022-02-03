Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F2D4A8875
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 17:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiBCQSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 11:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiBCQSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 11:18:02 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76A9C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 08:18:02 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id g20so2650470pgn.10
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 08:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JygVV4cd5lQJ0Bq47fsC/rpoxDktyiy9naM7mexGXGA=;
        b=XUbXflsSVcxAptdl6ZANg9OqOrhD+dAch+tAiIEhlbvJ8sAFVWj724UeF9YmNlhRU/
         B6xizbaGWOeWUj9AVC8h5lILUwconNb0sVsxFoUdvGvO9hTT7DG6FkVKEawiPLU/6fID
         t6ryVGzc5cm8fQaVKBV6r7wusWEkFNAkWHDLtyAQqw/C850ySIXhIEbHFOPYbaA1KNV5
         +wckfKDZcJfANfjafEgjbROzgrsjCBwLFJ0W4CWM7JabdVvJKqa5aGJWAUXX8bi15h4a
         gaVacVU/DQCuwYjoxIkxZ1R5Xv8lw9BURww5rCcTwZbJpbEmorjo64d9d6CkR9+0bw4K
         WNrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JygVV4cd5lQJ0Bq47fsC/rpoxDktyiy9naM7mexGXGA=;
        b=qLmxsOpQUFCdpHQd8RUxHWivmnQoDHmlam2wD4B3sDKNrnZxQ2sb8ae++1ltBvZDBo
         byy78KjfatKVIH0c/5YTq3w+v1hXOxw7xOXvxUHBUcQKfr9ofWrEA5j4QxiGhia2zMF8
         d9Yf7uAWopT14x7IfZsoOGG0eFUs47BGnGdxiRGW0HJf9vrel+NywDhv5gxYz8tmozFW
         hk736meSrHbMgrteZtOX/peCbaCZeJ6F4X7Av/oP0ubFGnwnjHa8BefJ8pATFkNtrQ5r
         dZXy4um2atZFVKtQJGw7hQm35MHFCAiTbsKeON+06kiJnwAPk+YN4LNxsHGqlrwyXLTx
         Ek4Q==
X-Gm-Message-State: AOAM531vUsejgZ79HvGdhK/+fTkvbMXgQJ9CVjYnZdEjYejya9IKfzUO
        9hb8sOCQb2s+i4FXaBLCcJLSD9Op7Aw181AC
X-Google-Smtp-Source: ABdhPJwXJJ2UUx/6gqju21TOzFBnH4vE/CGYNMMAsHiHyZd/1x9D9Gt4A3M8+E5b1r2Ft9PimMGGKw==
X-Received: by 2002:a63:6888:: with SMTP id d130mr15722566pgc.124.1643905081682;
        Thu, 03 Feb 2022 08:18:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s8sm28214547pfw.22.2022.02.03.08.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:18:01 -0800 (PST)
Message-ID: <61fc0039.1c69fb81.5e267.b2fb@mx.google.com>
Date:   Thu, 03 Feb 2022 08:18:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-37-g326c83886821
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 128 runs,
 2 regressions (v4.14.264-37-g326c83886821)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 128 runs, 2 regressions (v4.14.264-37-g326c8=
3886821)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-37-g326c83886821/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-37-g326c83886821
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      326c83886821d3d89bd22b0f5d7a79b9b1a3330c =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61fbc86322ae851abf5d6f27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-g326c83886821/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-g326c83886821/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fbc86322ae851abf5d6=
f28
        new failure (last pass: v4.14.264-37-gd7a066ea05cf) =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61fbc818c88cdc2fa55d6ef7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-g326c83886821/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-37-g326c83886821/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fbc818c88cdc2=
fa55d6efd
        failing since 2 days (last pass: v4.14.264-38-gda1a5053b8f1b, first=
 fail: v4.14.264-37-g88d20e7b4411)
        2 lines

    2022-02-03T12:18:13.330466  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:1/19
    2022-02-03T12:18:13.335453  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
