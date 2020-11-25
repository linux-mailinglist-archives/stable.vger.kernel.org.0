Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91572C4694
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 18:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbgKYRXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 12:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732292AbgKYRXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 12:23:23 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE770C0613D4
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 09:23:12 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id n137so2977396pfd.3
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 09:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ssPcIBl+qnUD3cED6byvsm/uMS25Wx1fCArA36vkCAg=;
        b=BOBqNJMipWOCQxRZ4Kmpz9CtqFbWWxQdtxYkHDJS1XTIUh5m1knt6zciQRCHiFh/2K
         J4wiADpn/D/9hAFb2834ixcYlXebcybd/nZ4i+4vuekUegJduXxF4SnhIB5qE6VPughb
         /3BJIQmpivZX5+ai2H3csgK0WUP+NmMaJtNatSXnb0HfPumdNVEYjIAoRYpVddL7LVoS
         eemfSDzL4tYxpqAusgsFOMdC38Ee5vc8RS5q8IHBYp4W8dWgg02PkI490WhWUUC26OKf
         HEhLMrR8fObUXZQI1XWoPpS1ZBhyOAVPFZ+Ck6MFYc0HVgGGAv4xUJ/PMaCmXdfsREqU
         gbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ssPcIBl+qnUD3cED6byvsm/uMS25Wx1fCArA36vkCAg=;
        b=kisp9rHDUu2jYEW8bRtiF/ou6AxGR7Tg/s83B9wY0N6TtS69UDLmxTLDtiOq6PSENS
         /iVDjjbb0TdD/4pD6cGg9QGgwxMK9/64fT122TVhXR1+zEwVGFQg+42++rZDFZRLxh0L
         yhxKlhljIrxH2jycBKsPfnhKO0VjImb8xzIt3WODHNiaAU+2Qahjl/m8L66rixLoSuJa
         2JAxiHcea+riVnsTXvMzdJPPO0/l8yHBlf49x/I93Luzvi5F2FaVjpBiuFZeuR/a0x3J
         3vsk7j7xZQI+Ccwg/Si6edt8LCT2XKz8gRJLYDq56EamlxHuoVCVODYMuoV3yYs+tjx8
         FBzA==
X-Gm-Message-State: AOAM530UTILlfIVBkmSLY+dGwRV7YoqwqGiJzNZlCczLHv5e25GUgwCI
        0LUUMsSe9yxVC8TskQeUGWnCbbHmdjfEwg==
X-Google-Smtp-Source: ABdhPJyXVYbhUEd0HKLMZB61qvRTjAsW2U1ag2xx24A6D1vgRafML2NNa9tm9yFFrtkLAFdxNqD7AQ==
X-Received: by 2002:aa7:9462:0:b029:198:1469:3a8f with SMTP id t2-20020aa794620000b029019814693a8fmr4068222pfq.20.1606324991937;
        Wed, 25 Nov 2020 09:23:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5sm2600355pff.36.2020.11.25.09.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 09:23:10 -0800 (PST)
Message-ID: <5fbe92fe.1c69fb81.1d61b.636c@mx.google.com>
Date:   Wed, 25 Nov 2020 09:23:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.246-2-g124a1dbc39c7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 147 runs,
 7 regressions (v4.9.246-2-g124a1dbc39c7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 147 runs, 7 regressions (v4.9.246-2-g124a1dbc=
39c7)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

r8a7795-salvator-x    | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.246-2-g124a1dbc39c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.246-2-g124a1dbc39c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      124a1dbc39c74e748e60b9a42b443a37ec273f4b =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe5f5eae0739ddeac94de3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe5f5eae0739ddeac94=
de4
        failing since 27 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe5da47f927ab0d5c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe5da47f927ab0d5c94=
cc8
        failing since 11 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe5db37f927ab0d5c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe5db37f927ab0d5c94=
cde
        failing since 11 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe5dde430f0bfe3ec94cee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe5dde430f0bfe3ec94=
cef
        failing since 11 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe5dda430f0bfe3ec94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe5dda430f0bfe3ec94=
ce4
        failing since 11 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe7997495fda9a1fc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe7997495fda9a1fc94=
cc3
        failing since 11 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
r8a7795-salvator-x    | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe5d8b4d786c1658c94cf9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator=
-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-2=
-g124a1dbc39c7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator=
-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe5d8b4d786c1658c94=
cfa
        failing since 7 days (last pass: v4.9.243-24-ga8ede488cf7a, first f=
ail: v4.9.243-77-g36ec779d6aa89) =

 =20
