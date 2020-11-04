Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4828C2A6EEE
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 21:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgKDUhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 15:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730533AbgKDUhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 15:37:50 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5E2C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 12:37:49 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 133so18274624pfx.11
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 12:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G/kZR0sjZKZcvjLAMa4Ifn+UNl57xamocHnKxPLKfpI=;
        b=Q1mFEeQ2FFTfcCqJdbFEknIYUsA2rkhBQrwQOM9QjNTo8rAjEo3qT5JeWZTEv8a5ha
         OMYmJhZkc+SgpvUhcIllCJpDATF/RSZFF5iHo8Nwz30BLggc+TmGAVuGgxnXKcTcUj1B
         ArgJoy62NKGnawOA2mzZOuuUZ3NtyLeJswWVI78LLZtFYpgFbyDKN8XvSOMwXZHq+fxC
         b9OdqiM1Mkccjn3Pz9AITBFAAiL8Wm3dd5CruFWICTnask3zjIXBap4HUi6Uun7Oy2qE
         +zxcTznJvKpOgkgNsbQ/C+zvpLgZYCf+VXmH0QtPFUHxl1/qEx8Rl4h3ndbwLwJEFey0
         TraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G/kZR0sjZKZcvjLAMa4Ifn+UNl57xamocHnKxPLKfpI=;
        b=Rgr6xJ6Ht0iZKXr8F6X9Ldof3XULHAyVW5gePWeApv2FV3DllYzF6tu9M5LNdD91ON
         uSoIkn5B1a4FdhQROqfo0ZyTX6dWbKyw1evrOHg6QT+bGDgRGFKxPIn2hhsCwPSBQEbD
         WxZ2JQadE2qEOf8YZ3gwjUYCQwe65dDVWLPurklYASI4wIvjqjGrfhfH/KJyG/AcxsAd
         S0elY8KevLI5nJIpf5L9yQ/oOzywCiOQHal8GDLhxt3d40uRz+2L/vJ11+qvShZTp4Tj
         UrVfWlu5VmLt+ewS83CF6qKUjcRZAPslI4sOTHcrjnqbRHCYh5DYZDNcwszeXa77bwjW
         Yw1A==
X-Gm-Message-State: AOAM532H7djqvM5rCeoOlH+3ORdkbvoZYvXkwgxFEBXJEOv9Ia2kRGaz
        aP0ymYeChCgonVhV28y1FcDdnQjLPM/RIg==
X-Google-Smtp-Source: ABdhPJw2mdi+cY/7o0Zf+8AKVYeWTqydQRrWWfQ9TwNOhJOeFZp+TR+ICaZgKyvp+GXg+ILpoAMYxw==
X-Received: by 2002:aa7:990b:0:b029:155:d228:8cad with SMTP id z11-20020aa7990b0000b0290155d2288cadmr30923278pff.29.1604522268762;
        Wed, 04 Nov 2020 12:37:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6sm3060073pgq.58.2020.11.04.12.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 12:37:48 -0800 (PST)
Message-ID: <5fa3111c.1c69fb81.a27f1.6bc2@mx.google.com>
Date:   Wed, 04 Nov 2020 12:37:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.74-211-ge5f9d776ac08
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 215 runs,
 2 regressions (v5.4.74-211-ge5f9d776ac08)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 215 runs, 2 regressions (v5.4.74-211-ge5f9d77=
6ac08)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =

stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.74-211-ge5f9d776ac08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.74-211-ge5f9d776ac08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e5f9d776ac082adb069680c22260ae7ff89a1d48 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2dddde2f4fd0109fb5321

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
1-ge5f9d776ac08/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
1-ge5f9d776ac08/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2dddde2f4fd0109fb5=
322
        failing since 6 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2e10c90a8a98324fb5313

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
1-ge5f9d776ac08/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
1-ge5f9d776ac08/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2e10c90a8a98324fb5=
314
        failing since 9 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
