Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AB237750D
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 05:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhEIDqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 23:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhEIDqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 23:46:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45365C061573
        for <stable@vger.kernel.org>; Sat,  8 May 2021 20:45:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id md17so7938809pjb.0
        for <stable@vger.kernel.org>; Sat, 08 May 2021 20:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YHCQ2RjtvQviKUThXZBQpkVWaJY068fN7Ti5rbXBuks=;
        b=0JiJWRvb96HU/pLCyFECXuxpbE6rxaqaJkPWKsJgPJeguWeI7Yw2C2Nw4Os0FbMzHF
         vzcbaYtz1Hb1zn6XPbvVC27FS3m8269UzKJsMLZOdG1CNiVpd1KPEVpl2fkaJM+tlw1Z
         /0S/WVg6xrpaG/Fo7ygtJXszhmPKosVP6VTmgZxdAPgqWvt3rAndtBiVtXAp8sOewLjq
         7rbW51PbV/5rl7XZuoNw2ggsSWTzyQ+Y58hvDAjIs78eaF3GEn8Vmc/2yvsXwuFaFpuR
         CY6uNVS3wFSb6d6uxe4e380Rb60TYJjQfuDMVId3a46K2aKKYOj+Y012XmJ/n0mHJcBk
         tS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YHCQ2RjtvQviKUThXZBQpkVWaJY068fN7Ti5rbXBuks=;
        b=O4YdDHMEHlLvfsinNVclBlUvFhvqO4ib/NACv5cExPz4iHznFI0Hk1xtFT9wIn1b0b
         h+S0KqlhiX8PCLV6z1NNL+EvWAyWzqFy7EmVqeeJ6RrFAGGBvEud0RDxlr6oDmf5VHMB
         QaEzNaEiAdCoYP1MNnQw8olbSSwWGyztBNoqXRBcPN5aqITS0/dlSz1eMUVcCVxjFmyI
         2G5KgQIb+YHugaFVf2QNsnzlustvdfG/BcwKLREeRqHkXwzl5m5JVrGBHILV4gmD74q7
         rCMpr6b15muH9xlYNylWnXkjQ5ag7dKKpooe8JbmNAL579PsvgJ1t6CB5JzHvkkwtKBi
         K6Qg==
X-Gm-Message-State: AOAM533IT80KrNd2dPQli7BthaTzdFlmO1kkTXI40R7uSOmk8MMNR98q
        QEWRZAEKz0Whv5y3r86nZAcWtnncErEdcSry
X-Google-Smtp-Source: ABdhPJzKcZEiaVn3hWSAvIYbAycd7Ug2ja3z9pCm92GM+HHr6HvwFXsSAZkGRx2cVKfqhuvMW5DGmA==
X-Received: by 2002:a17:902:e812:b029:ee:ff2f:da28 with SMTP id u18-20020a170902e812b02900eeff2fda28mr14937627plg.15.1620531915572;
        Sat, 08 May 2021 20:45:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c6sm7871244pfo.192.2021.05.08.20.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 20:45:15 -0700 (PDT)
Message-ID: <60975acb.1c69fb81.5c70a.898b@mx.google.com>
Date:   Sat, 08 May 2021 20:45:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-254-ga88b3f3599f6e
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 161 runs,
 1 regressions (v5.11.19-254-ga88b3f3599f6e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 161 runs, 1 regressions (v5.11.19-254-ga88b3=
f3599f6e)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-254-ga88b3f3599f6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-254-ga88b3f3599f6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a88b3f3599f6edd873f742b857e397ef0a78df44 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6097290c91e45eada26f5476

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
254-ga88b3f3599f6e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
254-ga88b3f3599f6e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6097290c91e45ea=
da26f547b
        new failure (last pass: v5.11.19-254-g3b5ece8b5376f)
        24 lines

    2021-05-09 00:12:35.257000+00:00  kern  :emerg : Process udevd (pid: 99=
, <8>[   12.952709] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D24>   =

 =20
