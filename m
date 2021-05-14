Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E45381334
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 23:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhENViB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 17:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbhENViA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 17:38:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638A3C06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 14:36:48 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c17so654718pfn.6
        for <stable@vger.kernel.org>; Fri, 14 May 2021 14:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dOyX68IhO7mRGpKapctuqxmQqNioSUP3/OabA2/+XQ4=;
        b=wJH0ZF7i/Y5dF607P3ibndafmSgZm57liGFHByhwqCTfEuQyaTU1cH7EQ5OgmNTSUY
         PeawBuTPV/qlWh+GHnOMeqDyhkThvDyTBepVR4UkHrCXFJfUzIiK4xuTH8LZkdB9wGb0
         pq9FgIKLkd7jFWF6GzBgTAtMthYPFHWH9MI7FgGaXLtxTCa7fpNcc4KDHwH6vxv6MYAu
         zFerFgL6on7Jy4BOcmXCtGvYBzDh139PjfMf6NpR/E7BF6WKEvmWENwwHM1PJtUDQOtO
         UoO1MVotOA6Wx0vCO/D5qG6lmspz1J7rpHtjfsBEK/8HuzWt31Fygh03uQMQOHTstJ+2
         zu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dOyX68IhO7mRGpKapctuqxmQqNioSUP3/OabA2/+XQ4=;
        b=Ju7rs+0Kg2NC8lSx5i21YfrFkQLI0LoIypepWZzE91O+hug8FvP/qDRoRauSL7dNKb
         JVMnqGQfL5SZI4mXDKbosuSn8nTrtSZV0UpmjzsikEWQZPGdgMQ99BlZg2bcY1kxRPrh
         KUdYLtFrSRSMlxBfbBVV0tzaL8ADmokdbDN0/7Xr7u4RoIh74P2pdrzywSZlF9mThXnN
         iVcsPH1Cc3bSnlLCVnAPtEJPIhvCKizKgYuqwqZeO8uWAuDyg7X+LeTSQsail3db928p
         4z6bxktJG23Mb/eSjVMSAmHghrCDvCSq79vB1xdNYyd/mTVoJ+zGTpuruaVQ3YHRWPvV
         4xDw==
X-Gm-Message-State: AOAM532V1HfxfRyhgTwEyMfLEBX48oVtw41y7FolXoAZ++GHFW1cf1fN
        H54sLAwdRJl4EwaV9nu9mZBtZ4MZ7EMZh36N
X-Google-Smtp-Source: ABdhPJyR1o+HOBLN3Fn4z204zadGOIsfmaQA/E/sB7Ej7a3MaJqBoZuiWjOhddeza3J75igqw1w2Sw==
X-Received: by 2002:a05:6a00:1c56:b029:28e:af66:d720 with SMTP id s22-20020a056a001c56b029028eaf66d720mr47624732pfw.11.1621028207697;
        Fri, 14 May 2021 14:36:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t26sm4527367pfg.12.2021.05.14.14.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:36:47 -0700 (PDT)
Message-ID: <609eed6f.1c69fb81.73652.ff55@mx.google.com>
Date:   Fri, 14 May 2021 14:36:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-169-gaf2769e76210
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 90 runs,
 4 regressions (v4.9.268-169-gaf2769e76210)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 90 runs, 4 regressions (v4.9.268-169-gaf2769e=
76210)

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

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-169-gaf2769e76210/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-169-gaf2769e76210
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af2769e76210c3eac48a979b24d3c61f85ea7bc3 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609eb9d963be783015b3afcc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-gaf2769e76210/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-gaf2769e76210/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609eb9d963be783015b3a=
fcd
        failing since 181 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609eb9e11bd91a7342b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-gaf2769e76210/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-gaf2769e76210/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609eb9e11bd91a7342b3a=
f98
        failing since 181 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609eb9d8ac6cff6704b3afba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-gaf2769e76210/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-gaf2769e76210/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609eb9d8ac6cff6704b3a=
fbb
        failing since 181 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609ed07cbea35dfd32b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-gaf2769e76210/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-gaf2769e76210/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ed07cbea35dfd32b3a=
f98
        failing since 181 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
