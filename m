Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC5F296514
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 21:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369958AbgJVTNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 15:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369955AbgJVTNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 15:13:07 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94DDC0613CE
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 12:13:07 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id f38so1233338pgm.2
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 12:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rkrCQN3VW78wuOVJhfLAWhE6UYstyf6ODjf2P/DNDlA=;
        b=ebHXIcwBrql7dtWfjVjQlbPDXBz2AJG+9P11raCY3E7ArYJV+X95s1Yc7zjzSP+DYr
         xCrpdDX2xXg0kkSQnj1cJr7A9VIDBLcyDZLZZheZs9W3Pth0D8TN0woVkrFzOE1SXDUl
         ++dIPKG6ioFOuPigHKZvWURGyIIqDF9Xbv+BwW2q0LQvHZYdnsthWM3v5YOz6Ck6j47W
         2rjMkVn/LRP9q7DiSmLNltqugGSeAUvMyKq+V+3AMkf0OHm4ngRP55T95QmJU5HDyGjV
         Fal0H/epdtzS0yGlOv16EoSmuaiOUsRZjNiM+GQ55ily3ly63lZQwR71tQ8Ie3o5RFX3
         y2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rkrCQN3VW78wuOVJhfLAWhE6UYstyf6ODjf2P/DNDlA=;
        b=c1oiLpGIxM4nr2tCoF2jwvxxdskhfJA7OEWQM9fjo1MfpJYV8+lt1lFLscjwsSq/2H
         RASB53Qp0j5rRa5gPNIBGad88ZgBMM/wrTM72KcLN0Kwmvenjv4UKxCebDWKyn/0CmEo
         hK5+SZSLevTWZ/tHZN5ORwy2+7F6NlWdShMl7RAtwaVlgbLX7OX/NdzcsMutnd6tNKsY
         pS7XQsSHmIYcbOhaSdkparuTGjhPZqx9wGMoO9spR4WZFsWKwUys1MHOHSq5XibLvkWM
         pEF0CWvLyoncMpWw4dgPlyATe48i1sIosqU4XXl9Nq3rDqTQEWo6mjEv6pZCLBdR+yLC
         NQ2g==
X-Gm-Message-State: AOAM533ZN5LT+ioemIPdLwT+jKCKZsPPkvlck78HtdpZjRtrST2APBdD
        urhHhNl8Cx8BInZFUSh4lI5FVTlVzkOieQ==
X-Google-Smtp-Source: ABdhPJy7Xgxmf/h1UQ+TMKspFon0LzWvfOmGB2z3ENA9R2LNlChIUdGNhAB4Guk2CK3DwLO/Azs6ZA==
X-Received: by 2002:a05:6a00:802:b029:152:1a5f:1123 with SMTP id m2-20020a056a000802b02901521a5f1123mr4024939pfk.28.1603393986778;
        Thu, 22 Oct 2020 12:13:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w17sm2872500pga.16.2020.10.22.12.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 12:13:06 -0700 (PDT)
Message-ID: <5f91d9c2.1c69fb81.b9344.5d75@mx.google.com>
Date:   Thu, 22 Oct 2020 12:13:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.202-10-g429275e47906
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 148 runs,
 1 regressions (v4.14.202-10-g429275e47906)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 148 runs, 1 regressions (v4.14.202-10-g42927=
5e47906)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.202-10-g429275e47906/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.202-10-g429275e47906
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      429275e4790673e7124526ffcd6382f0b1eff9c1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f91a8fd916d15f5b9110961

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-10-g429275e47906/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-10-g429275e47906/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f91a8fd916d15f=
5b9110968
        new failure (last pass: v4.14.202-10-ged048399782c)
        2 lines

    2020-10-22 15:44:57.694000+00:00  [   20.408294] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 a2:17:83:8c:79:e3
    2020-10-22 15:44:57.701000+00:00  [   20.420715] usbcore: registered ne=
w interface driver smsc95xx   =

 =20
