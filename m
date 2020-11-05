Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5992A88C8
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 22:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgKEVR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 16:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEVR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 16:17:29 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F036EC0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 13:17:27 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u2so1388890pls.10
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 13:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jMhJCog7p7foibdd6sSnCWLp0ub6C73Xy8CVn7LZcgA=;
        b=GvdT4zsPSsMzbyriqHQmu4QNIkfX0+7lku3qQ1ChfyhRmn3R076VwkaKYv2VxAv9JA
         F38SkLaFuPDZcejVcG6pq65nC1kXq1cGNZY1g7KQ7zY8Oe2btiB1rBOj5wR8GRb62DOv
         K4IBDVlDkyrBKC0lnfV2WOX0mBMzSk289G9pGwIt1NGkTcvyfvNt1v6dy8XsOQiFMAMJ
         0xFM4POMwbkrFpQEd4I60PGt9ppIg4VUKO3GL/cLLmTbdozk3mCs5gVIXCAVW+Myu7F8
         zPM48m/ZUAg0CuX1eqUZt9FkzwvlJRBQi/FNLMFwkPPvWpJO41amQ3h9m3dS10WuEAOP
         R3RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jMhJCog7p7foibdd6sSnCWLp0ub6C73Xy8CVn7LZcgA=;
        b=phiwnBNfaAQR6IgmbRQmoyAsAA/iXoETPDIVpcMsN7JwE+p4R2F15Ysi9SNfjH3qGd
         rR8BZ6tHvtkGJUkifpXjERignZbGcq7lTFYecDl/L30B1iYgILG76Kn9eelvj4lUpFnn
         8tvswg9SveUd7Hg9i5hKqb0z+aJUEhreH0V9t0wNhUb/dYC75NP+/mNIVHy452rsEE5k
         naCQNynk/K0B5rlWEOLz2oqGPT8ArnxJ2s+nRoJljvWgsRJHgvuYNb5AwbMmgwFYVY5q
         t+z9DWfdGmewBIwQKeQXPkfq0LAn62v8M1QHX0SNadiPut2UkJrnR2i74IdP1jPab07m
         uLng==
X-Gm-Message-State: AOAM531MDphp//1LQaPEf/NrYAZCmTPkohZMwmgqB1mTcfyPv9L28lWw
        bsKpylHFKtPI7IztMeQeFaaL+eBZg0GCmw==
X-Google-Smtp-Source: ABdhPJwNeEeUTliCE97d0X4SXFfaIHZEO1+yxaIQqpIGU7YpZULvkUX9BabQzf9lIa7mcEycQ8LwHg==
X-Received: by 2002:a17:902:bb81:b029:d5:b437:edb4 with SMTP id m1-20020a170902bb81b02900d5b437edb4mr3798648pls.6.1604611047145;
        Thu, 05 Nov 2020 13:17:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gc17sm3179360pjb.47.2020.11.05.13.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 13:17:26 -0800 (PST)
Message-ID: <5fa46be6.1c69fb81.482cc.5e86@mx.google.com>
Date:   Thu, 05 Nov 2020 13:17:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.204
Subject: stable/linux-4.14.y baseline: 170 runs, 2 regressions (v4.14.204)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 170 runs, 2 regressions (v4.14.204)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.204/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.204
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6b6446efedb27c2766745a04f9b5d4449f51391d =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa43a2318ff69b119db8876

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.204/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.204/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa43a2318ff69b119db8=
877
        failing since 217 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa43b0f490807ea29db8859

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.204/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.204/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa43b0f490807e=
a29db885e
        failing since 21 days (last pass: v4.14.200, first fail: v4.14.201)
        2 lines

    2020-11-05 17:48:59.376000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2020-11-05 17:48:59.385000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
