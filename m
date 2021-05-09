Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D253777F0
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 20:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhEIS2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 14:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhEIS2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 14:28:38 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF38C061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 11:27:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p17so8013795plf.12
        for <stable@vger.kernel.org>; Sun, 09 May 2021 11:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=alPt/tZeX/dXdzI5XjgXzb9c/8PaDOZ8oUwpObygh0I=;
        b=KAhbBAKTxj7v6FqbCxKjf10uz0y/Wtz5dnEuqKWgYaBNBCfn546nJ4LuKXoXiUT7xQ
         l1tdZvU+xRgdPqE6obJCdVwnwaRFg3+vgq8LXTiTDuEdm6T12zYoNdKVoDvVWEY1L3Pu
         KGHDHAx6yjn00h8wh7Kp5AUbcZcsyr98i62hH2haZXLnYy7F6CbfsgSr9ybLFgVNqF21
         PyoXk2k0VLR6YDH/2jW3fjFsvzj/vvN+qwb6OjwnVrF+7VmdYbuREvMp5My6Z6v0UH+Y
         eNULbH8AWce34fjzySVRARnpKYOfcTCoXSaxcinBwnfcPpN7Ui1iAguxk83oqyjXrbHp
         CbMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=alPt/tZeX/dXdzI5XjgXzb9c/8PaDOZ8oUwpObygh0I=;
        b=OEgv0RKwzmH2BYOdVtaj8eM20gotDpj/DUyt7P5tjNVesQJcNTrPRKmR7zyPoZofZA
         mu9XxyEaXa1FtkOwca6D+lN+HzzV/EGI6vXmQv7HQ/iQ/S84d2W0KQ/yzMAQUO2ROB3J
         T4zvbFJWEXbc10Y2kT820GFCq0b8BeyR4bOBqFVA/QS4M0EQKCFN7870WqSnIFEyrxtK
         8adwdsb8bamVOkNRpBvhRDyaEyfskOG/oObfNZjm0Tq9xDpJKdMYCgia5ccfQXwRM3GE
         Y0Ajn2j/rbTQIjbDDLBUdbxsghLQQxe9HtE+wqfNJS+4lNnGPl5lfTWQ7JydrYsg4idT
         gBag==
X-Gm-Message-State: AOAM533Le1VWPn+p5hswvdn0VzpRijISDa6kvyU+BZ1XGps23jhhL5mz
        LZQWOkxdLZnxUSIwWN6K0TNLSRQUj9VYdx7c
X-Google-Smtp-Source: ABdhPJwx0JT1NOVKVoXPVPt9LywfhwMT1Gg0BkxPJI3f4wCekMLq9m+zyqLxcSjVnceSE8DQKNNb6w==
X-Received: by 2002:a17:90a:7f85:: with SMTP id m5mr17378972pjl.128.1620584854995;
        Sun, 09 May 2021 11:27:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f14sm9670938pjq.50.2021.05.09.11.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 11:27:34 -0700 (PDT)
Message-ID: <60982996.1c69fb81.5d04.d27d@mx.google.com>
Date:   Sun, 09 May 2021 11:27:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.35-249-g83b7e5089f21a
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 1 regressions (v5.10.35-249-g83b7e5089f21a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 161 runs, 1 regressions (v5.10.35-249-g83b7e=
5089f21a)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.35-249-g83b7e5089f21a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.35-249-g83b7e5089f21a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      83b7e5089f21aab0f37fcaf451097f7178c38330 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6097f286b512ffcf346f5487

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
249-g83b7e5089f21a/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
249-g83b7e5089f21a/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097f286b512ffcf346f5=
488
        new failure (last pass: v5.10.35-230-gad87ad7f97f6) =

 =20
