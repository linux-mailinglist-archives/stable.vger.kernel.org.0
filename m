Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A1F34D3CE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhC2P1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 11:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhC2P0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 11:26:53 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F2BC061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 08:26:53 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so6093341pjv.1
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 08:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MZOhEkK93IvSv8A5Lj0zJyuy1PwqawM0RO04flaUy0E=;
        b=boWaEmlnCbIpB7GkwQEtQ44h9MVKUXFKIUwBwwo3HRW487uic4W6LoIp3yYC7mxPYr
         2FVld5QZ7twts050HQ7JrVdl8dF0wcTnqSuvOPGB8SG0NEEKPFtsin/PYtHUikzncJJL
         eOGqu74dVSsWloc7Wd5RWW+Kl8uyXKArAW4sp7qk2dlyBiZgQuq/KVxWWDD0BjJkT+Ph
         cbtu3AzKpItzRgkfaL+LIeI9wCpA1WV+Y4TQSl6ENLUFkr7DMzfjrArxYjxnR5D+xVd1
         YldvQuwzqnibUa7JkNDDJ6aSkRye1pL7rq1ASbSEudw4A8TLlmz28ya+TBk1OnAAwYul
         C5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MZOhEkK93IvSv8A5Lj0zJyuy1PwqawM0RO04flaUy0E=;
        b=MHHW5C45h7X00ccXYn14Sd0pI/yFGJ7Uao4eU+8d/L0jbfJVTc9y4KmK21RnjtXIsW
         V3aYbeC2kWIEDWmwiWoBOaPGugLOu7t0Iun8FCH5WiamzefvrU0UQ4S3hZeKa/Pu38H8
         vLtnRa9Zo3n0EGufG+6IpcjUMnnJOq7Fi15ZbqOE2HmVbo5qD/IjelA8n1B561MyDO3h
         IQy7osLSqU1L7U24ILk6F4F9DvYKOm/r0Bp0bTH8spZZlFvrcJBLfM8afKENm7/xFg+0
         5yw7MqBuclOkVI/b0Kx9fWwd7GxuMr6Frc7hG4eayd4GDWpq2DomekfayAn4ykruF+uH
         3/3Q==
X-Gm-Message-State: AOAM532Y94aMS6ALIHOI0APzxlQg2zjlW5LxTshVEE4OLky4EoH1k4sL
        3dx7AS9nqCdo1oNQPqFJHhBOxnQf8PceNg==
X-Google-Smtp-Source: ABdhPJyajSdhRr5Ptl5o8SnN7ya+uNYpbgdNiXQlRzFG2RTszDQVcy9mkguFeGc/Kg8QJWCkBpXuqQ==
X-Received: by 2002:a17:90a:d507:: with SMTP id t7mr27574461pju.54.1617031612593;
        Mon, 29 Mar 2021 08:26:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q95sm16001144pjq.20.2021.03.29.08.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 08:26:52 -0700 (PDT)
Message-ID: <6061f1bc.1c69fb81.4ea13.7221@mx.google.com>
Date:   Mon, 29 Mar 2021 08:26:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.263-53-geb8bb9695a00b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 90 runs,
 4 regressions (v4.9.263-53-geb8bb9695a00b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 90 runs, 4 regressions (v4.9.263-53-geb8bb969=
5a00b)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.263-53-geb8bb9695a00b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.263-53-geb8bb9695a00b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb8bb9695a00b134005c1a61d1ec9f1c97d96dd1 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061b546fa032b6018af02db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-geb8bb9695a00b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-geb8bb9695a00b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061b546fa032b6018af0=
2dc
        failing since 135 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061b541fa032b6018af02cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-geb8bb9695a00b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-geb8bb9695a00b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061b541fa032b6018af0=
2d0
        failing since 135 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061b547fa032b6018af02de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-geb8bb9695a00b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-geb8bb9695a00b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061b547fa032b6018af0=
2df
        failing since 135 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061d52f19ed9f63c5af02b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-geb8bb9695a00b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-geb8bb9695a00b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061d52f19ed9f63c5af0=
2b9
        failing since 135 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
