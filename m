Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684763171AF
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 21:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhBJUwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 15:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhBJUwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 15:52:15 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361D0C06174A
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 12:51:35 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id cl8so1835453pjb.0
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 12:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kEFnc9tmZfGajx9t3rWre7bJEjz8NnDVWRyJpJ2DsH4=;
        b=B28E5FZf/gjhQgDJGYcXZnh4RbdUz5sdKhTAVZbbTYXPqdDiiUeZFKYCM7yZAQOyLr
         0fVOVyhz+d0tVOKHlLixKeOlXeK6vziB/rTSAm5WSPfkwpzQot95VUlNZVS/1L09lmVa
         Ia8QJMhXxGk1PwbnTMLnBj5dsufspJlBqzzcjeMp8Tzd6B5Gb+MOebLrpcn5eMUOzrAZ
         bUzgTFEh5ph3NrQN/7wMmV/o58rKJBK5d/TSRd5o2tmNDwZZyyWK1s/P757LsNZip/xd
         bcvRH03lTEPS7OFhMsLWKiFOuJ8zUxoZKz0XljVUYjFWA+FK8cympmpZzWRc258k2a/8
         V2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kEFnc9tmZfGajx9t3rWre7bJEjz8NnDVWRyJpJ2DsH4=;
        b=EGtpRUbVlghrnSyTr8fa1buBTVYmWFNbxBHgkotoDq+m5WttK2RkY0eKSbtFMTNdj4
         wwsxLkTv2xmyeDP3iwtnG+XWnRpWWl+P/e/RhbVp6HOQUyarEphxikRl05z9ZTHNKqMq
         9YWZIzvBz+Y+/BkRGo2Ul1amRJX5i73mJcZ5yEKYwtKNR52KRz8b1QsXQOwvYFttUz21
         IjHSq+pLjTGq469UAb1arpucgMtvwGu6uUWZfIfd/9/cxRaCs9fLNJ8j+FCnAY109P1U
         PnakGIqcJrsOkGQKBWYzNSGf1JeXwCqlfQfhnw8rHxD8hVLk9xP1tssWZCJS4UmSc/8Z
         WGvA==
X-Gm-Message-State: AOAM530m2jfvXiXLtKeS8EGl+CT8zN9+gVIzsQGbk02wqBhp34SEcZXP
        4om1yBTYt36mwlKl8lkFVo0qE/iGbkdjTQ==
X-Google-Smtp-Source: ABdhPJx0orDRU4WIV46Qv9UkGAsDIFgfF1qz7+twsxFR0jP2csktYAomENtzlDcy0aNHL5KqdfWuBw==
X-Received: by 2002:a17:90b:4d07:: with SMTP id mw7mr752955pjb.172.1612990294388;
        Wed, 10 Feb 2021 12:51:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9sm2681190pgq.82.2021.02.10.12.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 12:51:34 -0800 (PST)
Message-ID: <60244756.1c69fb81.38847.5bc4@mx.google.com>
Date:   Wed, 10 Feb 2021 12:51:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.174-54-g7f1a38c09c08
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 82 runs,
 2 regressions (v4.19.174-54-g7f1a38c09c08)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 82 runs, 2 regressions (v4.19.174-54-g7f1a38=
c09c08)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.174-54-g7f1a38c09c08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.174-54-g7f1a38c09c08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f1a38c09c08c84b982803b2f9ce575fb0497ad6 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/602414b0740ace974e3abe7e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.174=
-54-g7f1a38c09c08/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.174=
-54-g7f1a38c09c08/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602414b0740ace974e3ab=
e7f
        new failure (last pass: v4.19.174-38-g601019cf8e3a) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6024146aead7ba4a073abe7a

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.174=
-54-g7f1a38c09c08/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.174=
-54-g7f1a38c09c08/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6024146aead7ba4=
a073abe81
        failing since 2 days (last pass: v4.19.174-3-g9df30fc2980a, first f=
ail: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-10 17:14:13.761000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
