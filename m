Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2896372F3C
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 19:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhEDRwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 13:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhEDRwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 13:52:05 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC670C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 10:51:10 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y30so8014282pgl.7
        for <stable@vger.kernel.org>; Tue, 04 May 2021 10:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+AkhcNFO+AuvX8sRD1Dy0/EJFl4gceAH/Aofb6jSsGE=;
        b=peknJATrkqbKOPwJFCwDNYPV9NYBcQ37G/xFLIXsQYWmZaC93nNIbAItVWduNcfOJx
         lZo5rAllEXOI8cdGkoK51Og1IlI6mAe9Y6MqAXgoaeOEFObefeFQw5ax+PoIDV8aulxc
         4B8O92TnGnjYw6Rfri+mVj7+Ua/ST6Fk73oKe7e26G3Lp3mXz4iydNHW8kRhgoBb4Qtv
         k2XViUxoCPBTeb61KjpbeiAQ+1p5a6HzT2fQglOx7NIhX0Q+jI5VYIZ2bSQVDRlI/+Pr
         5C9j8KqJutYUxDuERggHOAMVaDQc0gS60YLtKAvDvpAdzJsER295Mb2pwQupYVgSJRe0
         naoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+AkhcNFO+AuvX8sRD1Dy0/EJFl4gceAH/Aofb6jSsGE=;
        b=g1qxGIZAOTRL7dSczn8ZHPM5edQxgR2275VrsJsPSBqNftj0HTwIWDXt6fnpPA9bs3
         XD3HEVUuD/S5LaNPq/cDO2rSPBq6GIBg2qfSCwcfCpcBD1uWvoz367JofCkGsZdtIxp1
         hzQpq0w6rVTpyIXbVcYEzrNFBWTRmnCWKZbK9wZzyGOh0AduhMwnq5gOelTQ0IEKarU2
         kRyNIdqlW6nSX+9SaLdShJvCEmMeWhskv3GPqym3vh6ncjFWAJOwg+jJpd5XAbCpGjIH
         V+sprJyhSvQzvQ04XfxwsF0nsh09H/+OGni5wxU3agQksIutCI8l9nyAtJzKO9c5BpdC
         SwMQ==
X-Gm-Message-State: AOAM533yuVDyoQcvqSgcHoy3pMPa+6NeAvtb2OqHDHDxXhnkJwVrPFJB
        s5SGcWAmTQEDOaFJGlIsM8TYrOo3bDsNSsgj
X-Google-Smtp-Source: ABdhPJy7DwibT7569tXsY3Dds5OXMkb9yqvPbybaBfJ6MYryMJdeXBDxJP0C/96ZXSsRUtWYiOldhA==
X-Received: by 2002:a17:90a:6687:: with SMTP id m7mr29882835pjj.75.1620150670267;
        Tue, 04 May 2021 10:51:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3sm8790554pfr.30.2021.05.04.10.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 10:51:09 -0700 (PDT)
Message-ID: <6091898d.1c69fb81.95dcc.6455@mx.google.com>
Date:   Tue, 04 May 2021 10:51:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.232-11-g5b4ddc83d461
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 38 runs,
 1 regressions (v4.14.232-11-g5b4ddc83d461)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 38 runs, 1 regressions (v4.14.232-11-g5b4ddc=
83d461)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-11-g5b4ddc83d461/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-11-g5b4ddc83d461
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b4ddc83d461324e58983b041a9261d2736efc55 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/609160ad60211036ce843f24

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-11-g5b4ddc83d461/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-11-g5b4ddc83d461/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/609160ad6021103=
6ce843f29
        failing since 3 days (last pass: v4.14.231-51-g09d3b447c34f, first =
fail: v4.14.232-1-gcc63f168dbc1c)
        2 lines

    2021-05-04 14:56:41.559000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
