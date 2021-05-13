Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC4937F0AD
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 02:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhEMAwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 20:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbhEMAwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 20:52:43 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D67C061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 17:51:32 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h16so7362436pfk.0
        for <stable@vger.kernel.org>; Wed, 12 May 2021 17:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vK4qmFem8x6rHwqeH8QW+cBdfNcSHaemyvU+N5zL4DI=;
        b=f3J/X1AyWqZYOyLeeNXR/7NQS7C7L5K9Swh+HNv6W7r4CUyJ1d/e4spC/Om1CpkNd5
         iLoOEVjt46vLtNfvabAv6aycdMUF7O+P9nqn+sHanvy0zO1IgbXjEDPUPArWWrsRze8Q
         UckC9K0yeSX/3HfecmCWMQKnlg12e9B8mvL636Lz5Y0V0RQh5HDvzYHGYz26X02ENrkQ
         nKpexue/4c/wkdsWd2QR7QbGDZSg5KrjGjae/1g3Ugj/B7LIIviN+oQ7d1rNId+SMtxd
         z9KV/IBzrRM+tGEwU7JWf6hpTshmSXcFpHwwd0YTRdDHr164GXXDuOmR0maO7ki0ig+I
         h6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vK4qmFem8x6rHwqeH8QW+cBdfNcSHaemyvU+N5zL4DI=;
        b=HjqHsj3Nmx4WMpm4J/4FfgTEYZgnNmv1bKDfaKxqbm4wjtxRN4IqRPb32gpmb3Cvvm
         h6xaP96929Pyfp/9yoSxE4vRMBSq9nOmY4unl0oxKyzGK1/eZz21u1LFM2AGgxsofJdx
         uCJxfIeU9i0UhvgpKNU6S/1kPuIu0msJsMtV7ujRDq08Ge7UUyaoRTcSn+jA9YRvD9di
         mwmY382WVsiq6Q/DJDwgy7SSJRakUO70zsxQou7/fTa1B3X7N4B7tJC6AZWCQPDLHDT5
         kVeJHxuEYRdyP8j3cfRmRglAFTbOXC1AqPVm+8dbQK8Fqx+3Y5B9pbggjwpJFwvweJpR
         qMUA==
X-Gm-Message-State: AOAM530tMQZ1LfdF0YeGurqRusSOkZt9zU1rgTVtLpB/jXMrXrxTMezn
        SxdDz76yNjRcRXa1CqnDpHuO5so3SZVS0neI
X-Google-Smtp-Source: ABdhPJysXwq1fzfUUPYpbFxR9TdXyaZWD6GH425nk7bHMOr+KfoRwhoQDwTD1UJOSS2Rb+C0nkmwrA==
X-Received: by 2002:a17:90a:fd88:: with SMTP id cx8mr42642948pjb.190.1620867091642;
        Wed, 12 May 2021 17:51:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j189sm785734pfd.21.2021.05.12.17.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 17:51:31 -0700 (PDT)
Message-ID: <609c7813.1c69fb81.b84fd.3c5b@mx.google.com>
Date:   Wed, 12 May 2021 17:51:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.2-1059-g6591015c57822
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 160 runs,
 2 regressions (v5.12.2-1059-g6591015c57822)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 160 runs, 2 regressions (v5.12.2-1059-g65910=
15c57822)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-1059-g6591015c57822/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-1059-g6591015c57822
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6591015c5782244a97442a7ac3202e075a8114f0 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/609c41bb81c053c7ec1992b5

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
059-g6591015c57822/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
059-g6591015c57822/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/609c41bb81c053c=
7ec1992bb
        new failure (last pass: v5.12.2-1061-gc146f01fc93ed)
        4 lines

    2021-05-12 20:59:16.005000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address aaaaaade
    2021-05-12 20:59:16.006000+00:00  ke<8>[   14.097978] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/609c41bb81c053c=
7ec1992bc
        new failure (last pass: v5.12.2-1061-gc146f01fc93ed)
        45 lines

    2021-05-12 20:59:16.011000+00:00  kern  :alert : [aaaaaade] *pgd=3D0000=
0000
    2021-05-12 20:59:16.058000+00:00  kern  :emerg : Internal error: Oops: =
5 [#1] ARM
    2021-05-12 20:59:16.059000+00:00  kern  :emerg : Process udevd (pid: 99=
, stack limit =3D 0x1bdbc89b)
    2021-05-12 20:59:16.060000+00:00  kern <8>[   14.142307] <LAVA_SIGNAL_T=
ESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D45>
    2021-05-12 20:59:16.061000+00:00   :emerg : Stack: (0xc422<8>[   14.153=
470] <LAVA_SIGNAL_ENDRUN 0_dmesg 319910_1.5.2.4.1>   =

 =20
