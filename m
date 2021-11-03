Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABCC44438E
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 15:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhKCOcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 10:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhKCOcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 10:32:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309A8C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 07:29:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h24so356297pjq.2
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 07:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iOVKE18po7hR7bjcqefwEaSBOXB02JJUEp4qUhud9pk=;
        b=FDzb/p0CGp3b8eWj+JiMsLQhbwjNu9ZlBm0jNkoNcVtIDvQq0iLfTK/RIJH/KFyAZ4
         n+7yHm/pB0LNfIPXA8SbTje19SkEoB4ga5efFYlFwJGT/VJPXyjU886Ctq07h3YodDzi
         wKrdeyo5s2OsrHaqp+v7ib1y0XbcVIcRj4X/9rv67fZRlHgqWfFzXBkc4bVLA8amapao
         jjJfxApXAKwBZ2nhReW04LjlLCxrIdIMwHjXLfsj9NZwoYHzHW4wRJhf9wBgiRXiN6F7
         O0HlOo5qd9Q4XgVniHVTd52NorePpVHl6FXKRXwc4U/Yz5mGLrxyLPP7h+PLF/+3i1Az
         rJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iOVKE18po7hR7bjcqefwEaSBOXB02JJUEp4qUhud9pk=;
        b=tDC8pQJ0SKHjm2cHaPiJCYJBJUY3hznnkEKDCPtKiprRF69s5igyhHLgXv99qmBAOf
         v6FBhXdUoMbQdsv1idR4iK/gek7swJu3O6WfMjCfRPazeJA5TgSvZEdYGfcFlHsjk79d
         lCIa+E6uHs6uO+/rhRaL29AzGaODr3nIVKqDny0LTJItvIXpYxh+di8GHAHjweYYoeFF
         clBoYdTCOjT1SHA6tRO11BeJPUSWdw795cUOMWdNcUHBIJQC0HkH/xXxB+POXNV2MSHd
         ehKp/A+uAo6stYmiz32l1xfHNlcq21/CBu8rfVrOumTz00D2DK54mQnJY3OqC8vAmsyS
         8gTA==
X-Gm-Message-State: AOAM531wl0IBEkZJRMD5SRK9sXkdhGWjgItX+RZQ/pcpaAGb8HlYbFYo
        xRRV7BL+NLLPY2OH4H4C3BwxqeX1nCJDR7yg
X-Google-Smtp-Source: ABdhPJwtF1cSXU5skGXTbGDq5YL8p7Fvjim7fVTdoe6W5xwCrwYDDdYW3hwrnfQjb4acWmMeb23Aww==
X-Received: by 2002:a17:90a:9418:: with SMTP id r24mr14910005pjo.238.1635949765624;
        Wed, 03 Nov 2021 07:29:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm2185525pjk.41.2021.11.03.07.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 07:29:25 -0700 (PDT)
Message-ID: <61829cc5.1c69fb81.28473.662a@mx.google.com>
Date:   Wed, 03 Nov 2021 07:29:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16-1-ga1fb46604823
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 157 runs,
 2 regressions (v5.14.16-1-ga1fb46604823)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 157 runs, 2 regressions (v5.14.16-1-ga1fb466=
04823)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.16-1-ga1fb46604823/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.16-1-ga1fb46604823
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1fb466048234b89f0c9eff330e0478ef067aa44 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61826a34d7699f50b4335911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
1-ga1fb46604823/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
1-ga1fb46604823/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61826a34d7699f50b4335=
912
        failing since 9 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6182695fde97bc3b583358f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
1-ga1fb46604823/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
1-ga1fb46604823/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6182695fde97bc3b58335=
8f5
        new failure (last pass: v5.14.15-125-ge59bfc32a9f1) =

 =20
