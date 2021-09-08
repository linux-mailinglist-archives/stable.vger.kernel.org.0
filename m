Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94527403268
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 03:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347136AbhIHByU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 21:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346901AbhIHByQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 21:54:16 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D1BC061575
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 18:53:09 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 18so670930pfh.9
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 18:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zqucBCizfxfobok+0kefp4lz6QiSQoc+uEdOltcdj70=;
        b=LnEPyiHZHkmzChN+T7pVkpTR0PHvWWC0sjcO0vrDrDq1RqF7qrVIeimWN1yImZL7h+
         Ps0OdHx7zF9v3QJshplp/8bvsuIpPX/33oP3GwWUvAhCi7IhFexBPf2HrYD3jVJoB/26
         CIL2ogjyzsj7V+vjuwSn205wB2u/13M/namx6NfG6GE5vikMFIdgnuATKrE2u0/Te2eP
         qSZCSX3Mb66BJdcJQ2F9bp0WCqsArdRxNjik5rbS69Y0M96R7tgUB84+lrczH1wgpYSE
         AVYg8lpeOfF57Tn+JNAT3y7GE+u8LdPFeDJKok9TxIc1WP4rlGi80VjmZlYTPvPj/R/L
         fOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zqucBCizfxfobok+0kefp4lz6QiSQoc+uEdOltcdj70=;
        b=NoeDaqQUEEmgHWcNYrmxXMCZDD6Hb4zwmLRSbgxNP4rOcKxukQP2u1qADs64On1dmc
         h/3pHmdPL0wew6K1ZY7T9fGJdd7BAn7hgsuH42bAV/xz3VeJACkdjZWyUdIahkegecpi
         hFHQ+Y1rgelCRKHbh/GNeMyM1FJXVA//T4Tznv+kEpqXc2arOcd4qYvxMkEKR4/dPhpS
         TLs4kUpHgf9KNi3j6X7O323IS4lAD0XXawCDHzwE8WZ8jjvFLIn2/zeDdpC60V7zr1Zc
         aA+twCZQCR2N+oHCXW7h7TrJJRokBWOFldHL1JuH+tWOoyiAKPyCee0sANklLqXZDc2j
         fdAw==
X-Gm-Message-State: AOAM532D7ISTi36Bifr2HzOAiU5kVtGTiXYI3W69ViJU4r1rUOylcg5c
        1//2/NzzIChh1HvzmFKqvfB+qah+BX2YId80
X-Google-Smtp-Source: ABdhPJy0CZ4sekRIw+xuxmlffFaPdC1rZlbbvATZjnHvDwPFBkUGlGzRVLzIumgcs7SnLyLzCB80ZQ==
X-Received: by 2002:a63:1351:: with SMTP id 17mr1244321pgt.173.1631065988493;
        Tue, 07 Sep 2021 18:53:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g13sm306858pfi.176.2021.09.07.18.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 18:53:08 -0700 (PDT)
Message-ID: <61381784.1c69fb81.c8eed.1f6b@mx.google.com>
Date:   Tue, 07 Sep 2021 18:53:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.14-24-gff358fe92fee
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 229 runs,
 4 regressions (v5.13.14-24-gff358fe92fee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 229 runs, 4 regressions (v5.13.14-24-gff358f=
e92fee)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx6ull-14x14-evk       | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.14-24-gff358fe92fee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.14-24-gff358fe92fee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff358fe92fee068698342fe4f99131a479151f59 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6137e3af8531b77c14d59669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-gff358fe92fee/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-gff358fe92fee/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6137e3af8531b77c14d59=
66a
        failing since 3 days (last pass: v5.13.14-2-g1b53bca7aeb0, first fa=
il: v5.13.14-2-g74aad924bd80) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6137e25d68b3a2fdaed596b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-gff358fe92fee/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-gff358fe92fee/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6137e25d68b3a2fdaed59=
6b9
        failing since 41 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx6ull-14x14-evk       | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138036cc46d93a989d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-gff358fe92fee/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x=
14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-gff358fe92fee/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x=
14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138036cc46d93a989d59=
666
        new failure (last pass: v5.13.14-2-g74aad924bd80) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6137e4d04d966c23fed596a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-gff358fe92fee/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
24-gff358fe92fee/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6137e4d04d966c23fed59=
6a3
        failing since 3 days (last pass: v5.13.14-2-g1b53bca7aeb0, first fa=
il: v5.13.14-2-g74aad924bd80) =

 =20
