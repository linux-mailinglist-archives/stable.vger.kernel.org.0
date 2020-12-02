Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD692CC88D
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 22:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgLBVBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 16:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgLBVBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 16:01:50 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A313C0613D6
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 13:01:10 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id f17so5606pge.6
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 13:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UYKAdZkA8QtEexeGjfV6KO6zufgaohDzstQyWKSC/Bo=;
        b=rSu1HjjmrpDRI0OFmo3kvPZzdq/qIx8DGRMWY5o0f/ttjVry+4a1QbAOxA2H2CPvai
         8PL8ftMTmIyGjNgWjVXTGi+FnFi3V5G8GLwNtBUSYvaYQm1UCo6o/bsaAcJK52P50b28
         qbwUhcwc2dPiZIr3x/lkA4eXrdhFWedwNkHutBifFq85XF0gAPTV6C1ulgQ0QybNho76
         fG449a/v7hWHY+/1IwtaQIa9rv/jT6PwfWvP5tJ5cv9CPVsvrZtyz7EM+fQy5PP4ahkF
         wkK9FSSexU+DuvW0Cp0D5/pbuwMkUuvYRYqO+kfzTP14gealRJ+89qdBktGKPW7uyHSe
         +7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UYKAdZkA8QtEexeGjfV6KO6zufgaohDzstQyWKSC/Bo=;
        b=PfN3F3oBhAOoST+oohqiHGqpRiFnDI2zycj3Qg5RRO/9dmVtbHo/Tb3JUZdzsGt3KU
         xnMkrGvAMRt5sOkIusXS1DlRHbz6UVW3MQtEXdQerQ2DZQy93i02dAb9v72Yf8KTxkxA
         00rVKuvB7XG79jgKyMwzrNI17W6uLY9DhVM3xBbVCnpICgItCqUjATgbVIYzNPFq3/So
         FDkF+/ef7UcUOx30kfwaRka/jtQEWC2vnWIduSY0NT2lz71+27MmuqG9UbHd9REzQHl5
         B9Ymt40SZDa68+5wqPrjxPZOZTpHwYjfDffgJiAboCLR+5qo3KzFcvp7qdDh0UMSm5E9
         6zKQ==
X-Gm-Message-State: AOAM533N1L0Rh9nkQvAn7lGA6768xZOiUrNkAKsK0lBzOIvmm39dyxS0
        IiBLYKlBqbh4hRGq8A8ExLN+5fKEcm0wiA==
X-Google-Smtp-Source: ABdhPJwHBbtFCIBgUJ3ROCIXOnRGO/Ph3a3ZkLOH26kqJMOX2yp4nGA6elT+TQn5hlM7cXtsH/hA+g==
X-Received: by 2002:aa7:8a0d:0:b029:19c:2209:7b59 with SMTP id m13-20020aa78a0d0000b029019c22097b59mr4254452pfa.81.1606942869325;
        Wed, 02 Dec 2020 13:01:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j11sm17742pfe.26.2020.12.02.13.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 13:01:08 -0800 (PST)
Message-ID: <5fc80094.1c69fb81.13411.015f@mx.google.com>
Date:   Wed, 02 Dec 2020 13:01:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-4-g64929b2209010
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 86 runs,
 4 regressions (v4.9.247-4-g64929b2209010)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 86 runs, 4 regressions (v4.9.247-4-g64929b220=
9010)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.247-4-g64929b2209010/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.247-4-g64929b2209010
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64929b2209010a92c64674637686261d2f727e71 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7cbb4f6ebd8f02fc94ce7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g64929b2209010/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g64929b2209010/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7cbb4f6ebd8f02fc94=
ce8
        failing since 18 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7ceec404671c699c94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g64929b2209010/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g64929b2209010/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7ceec404671c699c94=
ce1
        failing since 18 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7cd18d033173caec94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g64929b2209010/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g64929b2209010/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7cd18d033173caec94=
cd3
        failing since 18 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7cb8348b6228538c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g64929b2209010/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g64929b2209010/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7cb8348b6228538c94=
cce
        failing since 18 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
