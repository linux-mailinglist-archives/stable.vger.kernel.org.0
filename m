Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CD23FAB8F
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 15:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhH2NJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 09:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235271AbhH2NJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 09:09:36 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2808FC061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:08:44 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q68so10680403pga.9
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jGxdHTrM2/vljLy5G+xEve1HPt1+ndl6umUadvcJoIo=;
        b=XOoagVyvqTIaMALGZ2Yb4faQGYDpv2Y23KIf3MldiFnxhi6+8cqJmIo1DswOKz+48P
         ZRuyt03CaOq+3Qja+QQakmBKwsbta2EwhH2L2gH7vMLL6X3WljkBxUePPEpnLZrueZUm
         Hb7Z5vG5vm66HMKTfNRyAi9pXzs0fgyc1F3CYUiX5yxEs5/Kgw9+rXsXmvFUukbjRirv
         xaDBmL5cbxoVzTTJ4XOdEh+zyr5wjlS77ak1cPhkiiQ515hmFehodk9o2a8kxtQT8QG5
         wQmiu1srOq9zopVx7fudh2HQBoqi63+JUcjDbOZGVKpq98AB7PWSaUf6/OJ2WuupW7cR
         ZzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jGxdHTrM2/vljLy5G+xEve1HPt1+ndl6umUadvcJoIo=;
        b=uEcGFKofE8SVWMs4O2JWA6ZbeZ6cqbRCFHr0ud2xCKKr6Lc6C/FFCMZcNKUYLC19rQ
         ejN5nnLpQ6BVF0HIXIUrYtLWzcaA8VX+XSgng60V/OuokEDMdgC9mIxW1JPc/CpyaNZc
         pfsiEQwdWWgYo7cYzRbwZ1R24MTwMvgPFF1/uhLid6VcS1Ynva09/Gqd5m06+7OHFPMM
         y4UHlOyyqx8lG1Lqk2iXkzH6f5f8jl5Q8PHkm4j6ySV4xkVZL5vmxMK3WE8DuxmN9Ayh
         asud1Pc42jfeBJNG1z9YSyyLhXqvASp4sU3gT0sCX54ksOMbii8zahI5sCgchIh252oI
         ZW6g==
X-Gm-Message-State: AOAM531ehlBSjbDdBp3e6wCsdh1P0f662XRuA16ZEvKN+01U9Bu8yjLH
        cu45VgyZd/N0+6IT7tITu2CXiyrP9w25Ewli
X-Google-Smtp-Source: ABdhPJwaAA+ZcAI8h1FmuSzxf3U881mTKjDCk3q/DHIPEhMtkLhKFOCQt1x8D8dy/6t+hNbQZ90pJA==
X-Received: by 2002:a62:36c3:0:b0:3fd:52ea:bd70 with SMTP id d186-20020a6236c3000000b003fd52eabd70mr3319823pfa.38.1630242523311;
        Sun, 29 Aug 2021 06:08:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm12021686pfj.153.2021.08.29.06.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 06:08:43 -0700 (PDT)
Message-ID: <612b86db.1c69fb81.ec0c0.e3d3@mx.google.com>
Date:   Sun, 29 Aug 2021 06:08:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.143-13-gb1328792522c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 174 runs,
 1 regressions (v5.4.143-13-gb1328792522c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 174 runs, 1 regressions (v5.4.143-13-gb132879=
2522c)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.143-13-gb1328792522c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.143-13-gb1328792522c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b1328792522ca916b92edd9892a16d0eea203720 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/612b53c66df34c66568e2c87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-1=
3-gb1328792522c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-1=
3-gb1328792522c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b53c66df34c66568e2=
c88
        new failure (last pass: v5.4.143-7-g7f59ee21556d) =

 =20
