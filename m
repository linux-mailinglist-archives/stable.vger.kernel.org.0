Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04663CF3D8
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 07:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhGTE2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 00:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235572AbhGTE2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 00:28:11 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8BBC061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 22:08:49 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso1776554pjp.5
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 22:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bqjS4oz4Rj4JmZo9fjwXisiNUyU43dwYBDx8C2Ablac=;
        b=br3Duw3Vhz5hCf/ggdp7H6ZSaTj/I+5SsAicSaZOg8mRHjtj7xvOjKXShkxMmVnBhe
         Z8s8OBJsT3VQR12lzUHBD0oU5Z7RKfMIcgoNjETidbHBUMRhPCXkevb4w9gq79BWK+Ai
         gEspRhy1ulpl5SwqifkjdvjQg31YAYhEEwQZkX9zqHRTSZE9vS9JUNuX+EQYQcZIbYyE
         xMQYfQSjA81rt3y+Y29bW6JxXGZaonV2vugUAAA7ehUXhSpvGqHiBcWPqnnKJ3TOVZdl
         fAYxKM+bxqerYW1LNF5YTdTeN61wBSCCd2t7PtXhS4YyGofEfffEEeNP6Ew4g5F32+Cd
         WRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bqjS4oz4Rj4JmZo9fjwXisiNUyU43dwYBDx8C2Ablac=;
        b=nERp/cZ1osOFt6TfSH6X4z68e8N0LMH7lfa+tzhrHUhowuNzHRnNr+ZwYqjm8lrhLh
         MB4eb278M3TcF+Zopx6YUXiWNLmX7Kl9fM4tPiOwUQEpUUJxuY9R6ezGTbdtS+rQZjmx
         uFbGSRzo7ECzVGIyJHYE9OLwGPYHusLbGDhw0L5bD9wEy+l76eOhi4JGABbTqRPqL7gA
         H4x/9BjssZr0TVjEzMFUYFnRd76BkiIeHI10YA0lv3sxeEt0m9PmhKGXMK9eprXIJPkz
         khG6TPVfzu7usIVwwcSvLoV1Q6Ay1DR1DIhT7M0OcboKkluLsH7qvVoGPP1C5/ajTgrK
         5iBg==
X-Gm-Message-State: AOAM531i2dW5uhejwP+OGwZIx+4lWxxL5Ptjr9k6HtQ1t5vhoqAdj844
        cB98WS3tg8rLpN5k3Rw3SAPukJohUMwXoA==
X-Google-Smtp-Source: ABdhPJwD2/FOFeENqZ04ywV2lOKzPniTPVGl5BIEoassPapfaEDjQTRASK+fLjsgDbdnjZMZ4AOyLg==
X-Received: by 2002:a17:902:b088:b029:12a:fb53:2037 with SMTP id p8-20020a170902b088b029012afb532037mr22240430plr.71.1626757728638;
        Mon, 19 Jul 2021 22:08:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ce15sm18813089pjb.3.2021.07.19.22.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 22:08:48 -0700 (PDT)
Message-ID: <60f65a60.1c69fb81.604e6.822f@mx.google.com>
Date:   Mon, 19 Jul 2021 22:08:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.18-288-g58aca573864e0
X-Kernelci-Branch: queue/5.12
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.12 baseline: 127 runs,
 4 regressions (v5.12.18-288-g58aca573864e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 127 runs, 4 regressions (v5.12.18-288-g58aca=
573864e0)

Regressions Summary
-------------------

platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
beagle-xm | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig          =
 | 1          =

beagle-xm | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig         =
 | 1          =

d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromebook=
 | 1          =

d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig            =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.18-288-g58aca573864e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.18-288-g58aca573864e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      58aca573864e0d161a818b1933c51ff06da1accc =



Test Regressions
---------------- =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
beagle-xm | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6240a99fd431d7c1160a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.18-=
288-g58aca573864e0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.18-=
288-g58aca573864e0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6240a99fd431d7c116=
0a5
        new failure (last pass: v5.12.17-242-g0069cec037fa) =

 =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
beagle-xm | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f622b63e706b5c3d1160c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.18-=
288-g58aca573864e0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.18-=
288-g58aca573864e0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f622b63e706b5c3d116=
0c3
        failing since 4 days (last pass: v5.12.17-229-g894263ece741, first =
fail: v5.12.17-242-g0069cec037fa) =

 =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromebook=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6230726e7c67d491160bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.18-=
288-g58aca573864e0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.18-=
288-g58aca573864e0/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6230726e7c67d49116=
0c0
        failing since 8 days (last pass: v5.12.15-11-g1a88438d15d2, first f=
ail: v5.12.16-682-g36eea3662e2d) =

 =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig            =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6245cf07ff9e6bc11609a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.18-=
288-g58aca573864e0/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.18-=
288-g58aca573864e0/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6245cf07ff9e6bc116=
09b
        failing since 8 days (last pass: v5.12.15-11-g1a88438d15d2, first f=
ail: v5.12.16-682-g36eea3662e2d) =

 =20
