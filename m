Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9A13B395B
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 00:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbhFXWoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 18:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFXWoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 18:44:46 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F49C061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:42:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so4401154pjn.1
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kbI2ZvZRj4FyNEsS5uoEE/hqQoFFg2TO8h1q6EsZOAc=;
        b=Rx2+20atwHQpmgfF0DJ3RtkGzUTBL1526U4sY/bwjJFl6gxciKdhElQvZGAYPAf6f5
         IyPaQzVB4tNxWa1fZ0bJ/h0H1qo53X/srRd46EQmxnSCaB8zEME6wqSy/Jfi1yfP74VU
         4eax9d4lLj6QrDuSn5ajQ4Ik4NJXJoSIbEgrTniZFrk5v8T8FafNq0en5Tp09dk+FiRD
         hsXevS0dhODbkbVhnMiNG7tDQ5Mm6wZMiaTWyveVg3iqrSslSpymfYAWoxpqZyNePZwP
         VRaiQh5fj83vIbdl4GsC4BndihOg6cV4HzqL4+Wf2cDfrc9eXtp1WC8iOuZGufJrmR+Q
         oRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kbI2ZvZRj4FyNEsS5uoEE/hqQoFFg2TO8h1q6EsZOAc=;
        b=WcSSU7PB0L8r4Eyf+vpwmGK4JRjx9BEPbti+lfHHH449yJM3UGpjRABU500zIxERJ9
         Omo/yo6Qt8tX307qznZThBqHoKTjArNaQxixReRXoXIZe4FMZml59/g7bbOlkGI7D6D8
         d1DWUPhYPEjnq7mGaPxTSHzZiwFq5S/91n/h/BherbDU27ZbtY1ShPanPIPpha+/gySo
         2BGdgf0lD9R0HvJOBajzphL6rsB2mxbx1wbwUCZzmKnxPbnMGmSk8+fvaBhi4ed06PDW
         /Mea+NWPTDYyqumMzZqp4XeeojFkHBnBAswGzIuMaiC1l6XWAk0CoaP8Xf4m0PrhDdab
         4KdQ==
X-Gm-Message-State: AOAM5304OkA5GstAZ53vGw40o8gW/DI0AdleAodtVxRF2ct0VBeQQbZL
        A9OHN/uSA/PBQJcGEt/SZfYjplancv3PaNLz
X-Google-Smtp-Source: ABdhPJxnTgUtmkmURWXxrVxa+M9/hPlTmRrIBEFeJ8slFmGzVfYJa/aoLGVU0wu3+gt0XjeYXqrQYw==
X-Received: by 2002:a17:90a:4311:: with SMTP id q17mr17466503pjg.204.1624574546059;
        Thu, 24 Jun 2021 15:42:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i3sm3595195pgc.92.2021.06.24.15.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 15:42:25 -0700 (PDT)
Message-ID: <60d50a51.1c69fb81.d3419.a14f@mx.google.com>
Date:   Thu, 24 Jun 2021 15:42:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.46-1-g645c87a6d947
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 159 runs,
 2 regressions (v5.10.46-1-g645c87a6d947)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 159 runs, 2 regressions (v5.10.46-1-g645c87a=
6d947)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
        | regressions
-----------------------------+-------+--------------+----------+-----------=
--------+------------
bcm2837-rpi-3-b-32           | arm   | lab-baylibre | gcc-8    | bcm2835_de=
fconfig | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-8    | defconfig =
        | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.46-1-g645c87a6d947/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.46-1-g645c87a6d947
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      645c87a6d94734d037e25ed77e10d015d54e4844 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
        | regressions
-----------------------------+-------+--------------+----------+-----------=
--------+------------
bcm2837-rpi-3-b-32           | arm   | lab-baylibre | gcc-8    | bcm2835_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4d290294afb195c413285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
1-g645c87a6d947/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
1-g645c87a6d947/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4d290294afb195c413=
286
        failing since 1 day (last pass: v5.10.45-144-g9affbf10e0b6, first f=
ail: v5.10.45-144-gf00ac70b7013) =

 =



platform                     | arch  | lab          | compiler | defconfig =
        | regressions
-----------------------------+-------+--------------+----------+-----------=
--------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-8    | defconfig =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4e479c253c530714132b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
1-g645c87a6d947/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a311=
d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
1-g645c87a6d947/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a311=
d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4e479c253c53071413=
2b1
        new failure (last pass: v5.10.45-144-gf00ac70b7013) =

 =20
