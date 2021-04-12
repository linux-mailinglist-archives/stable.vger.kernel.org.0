Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86A435C56A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 13:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbhDLLiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 07:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237792AbhDLLit (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 07:38:49 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7E8C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 04:38:31 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e2so1900667plh.8
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 04:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Kjf1i5zRslWyinYudYZr2AB4nBOf409JEuB1PaDu52s=;
        b=q7nCqBAsfK4xc6maXnpCqH/uzURuu5oBN1qxPBTdR3pyae5v/nraxKOe1E04cw2gJ6
         RH7Uk5Z1cq7V+NExYDW7bGQ4qKBwpPhvcoC0GSKP+ESXDfA/A3UmXvL49CfARsS/p68U
         hacMn3AF1m202HJWFnstRm/xD1IhA07b9hmhJwGECN0E4WkYU8FeQNHcy51G/At5azWt
         4na6lf/Adqbtkddca83zxr3qTC3sqmqVnB2urd0FyqJWlmpEOBFbODcKdbSNzfBnV/Ud
         IHwaskns1KOTyoNG9HDlCwkL+LDLzrPQN18xecpox+FLo7vPGkd8st9/059y9LMApP18
         sQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Kjf1i5zRslWyinYudYZr2AB4nBOf409JEuB1PaDu52s=;
        b=hMzSu+TnpLxNLvv8W9zv4p2z596IxZFQdHU10bDf4q11C3W0Y/RBy/8CFdrI8kOe1o
         Q87H7+VymEM9fb43LCpL3Vh4gUnDCBpMXIYYIKPHhNX5Vhu1UrReFLagrv9NhXoPIbO4
         q6ac2Mfpi6AMCyd6gehHmMc3p6OQBPrhbRIQX+r7z6unRXFac9082vC+RnwcfY+x9ODy
         zz+DZvD5LsRw0aggMwa0jqoKbAv9AfvKkKneVdUsRaqFaNdqmkZWF8zR7588aXa15NrZ
         Y3QReSaLU/PrwqG3xDTGKmCIdtXOtcEsPIYb2zu8LL5OXHqEF7+khepSc5EctuEvAwq6
         CwKg==
X-Gm-Message-State: AOAM530XuhnbX8aAGsM01COI+tFeXRqgCVlw6weYpwmyYbRf36a+15SE
        +pC9mfYvyy12JrAi0UgAjSrpu+WjEL5HZNMr
X-Google-Smtp-Source: ABdhPJzn9m30FYvMZyP+CHUSDJCpHpof6d2cxX046tw2WGt5+ZInxZh/hacAtfyDe+bjnDhufE2HEw==
X-Received: by 2002:a17:90a:a10c:: with SMTP id s12mr28294908pjp.166.1618227511289;
        Mon, 12 Apr 2021 04:38:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j1sm10732030pjn.26.2021.04.12.04.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 04:38:31 -0700 (PDT)
Message-ID: <60743137.1c69fb81.d71bd.9c93@mx.google.com>
Date:   Mon, 12 Apr 2021 04:38:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.186-52-gf2aee9aaba24e
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 119 runs,
 3 regressions (v4.19.186-52-gf2aee9aaba24e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 119 runs, 3 regressions (v4.19.186-52-gf2aee=
9aaba24e)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.186-52-gf2aee9aaba24e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.186-52-gf2aee9aaba24e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2aee9aaba24e5563a6e399a8c1d53f523b528f6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6073fc5d1316b3bfe2dac6c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-52-gf2aee9aaba24e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-52-gf2aee9aaba24e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073fc5d1316b3bfe2dac=
6c8
        failing since 149 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6073fc591316b3bfe2dac6c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-52-gf2aee9aaba24e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-52-gf2aee9aaba24e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073fc591316b3bfe2dac=
6c5
        failing since 149 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6073fc8f2c560ec621dac6b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-52-gf2aee9aaba24e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-52-gf2aee9aaba24e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073fc8f2c560ec621dac=
6b8
        failing since 149 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
