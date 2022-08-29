Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC935A4EBB
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 16:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiH2OCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 10:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiH2OCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 10:02:33 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBFC83BCF
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:02:31 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f12so7913372plb.11
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=NxQr8Afsb9zp3n/Brg2bAXzHCf07CsvzcNpQgJvbwgk=;
        b=Cisp8sIiuZyWiPqxQXq0OKI37GsmTLP+n3CaiFALLbaFGx1Cet9fxEveHSGFsLCQlJ
         mvzMH2iqTKj2S1iRUEGK3qWgspIfC4jwlQpsOw1dX7tdGxYNO04kUOMdhUZMhat39WGF
         9ucUdlAl9SsiE5qsXdTz3IhdNFOBQSxHM4oz04tzc6JVrcZnw2JO5pTPoLSoVdIRPOVR
         3mrLEJBaFho/YbKAUT+r4cAAOeLvbD5vo0J4EIA9is2ZqIxNDJMKYMXezL8jWFe1YAtb
         lRscAj9NQKVWRHe5rcvt6SygdarF7nA6aVy5Q3eXR1ZeAc80TA0gcQluyaiC/8qbc2cg
         sm0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=NxQr8Afsb9zp3n/Brg2bAXzHCf07CsvzcNpQgJvbwgk=;
        b=CVFwyYOtQQbxMozzTG9ESYinAF8/Wc3q48CboUrcU7mJOll1uPOqIFf5WX2yv0dk1c
         uYuDkMS92ENRfezRYo06oCbdHdFeH7Q6RCQA+7xooO51F9yti+zbI1xGZlN/uPHocASi
         QSr8WZZ3xUNU+HG8rwwKZ/FriUxzcJZy/i12cHclv255aBrxb11NYsCXionXrrpw2sEb
         TZyLWjctXaiUbXzkQ3ZK69Ira4B0UuZSTxkQbB4hxamxQoSDOGyymCSBVmnhY5BOJfNf
         C98qV3Pn9yufyQfRqygzlOCsx/AzqjIMJtd8x7++9SrnDSR4MRFCA0RZ5ZHzjK1+tLH/
         5kDQ==
X-Gm-Message-State: ACgBeo1GHZqyKISdG4+/osdQNg6BzxqAQ31JeNwCUVDyQTong6FS1JRp
        Slaue1V1DY/DXoQqyfBcexD0K/mf9vWikPLIpwo=
X-Google-Smtp-Source: AA6agR4Oy1oSTJhlrbNG+pONZ2JuEExzDZImp8aLwWiOlA059hkTgkKOfCL6F5mERfHdjqG/Jykq6A==
X-Received: by 2002:a17:90b:3b8a:b0:1f5:1df2:1fff with SMTP id pc10-20020a17090b3b8a00b001f51df21fffmr18906285pjb.169.1661781751163;
        Mon, 29 Aug 2022 07:02:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d9-20020a17090a498900b001fda71ab2aesm3270566pjh.11.2022.08.29.07.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 07:02:30 -0700 (PDT)
Message-ID: <630cc6f6.170a0220.5f651.4bea@mx.google.com>
Date:   Mon, 29 Aug 2022 07:02:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.63-135-g75ba94c564c1
Subject: stable-rc/queue/5.15 baseline: 181 runs,
 3 regressions (v5.15.63-135-g75ba94c564c1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 181 runs, 3 regressions (v5.15.63-135-g75ba9=
4c564c1)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =

panda     | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1       =
   =

panda     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.63-135-g75ba94c564c1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.63-135-g75ba94c564c1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      75ba94c564c1bfbb998522c1b3aa0d670328390b =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/630c94c587b20b6ef0355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
135-g75ba94c564c1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
135-g75ba94c564c1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c94c587b20b6ef0355=
655
        failing since 151 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
panda     | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/630c9ab62e5351a81a35564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
135-g75ba94c564c1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
135-g75ba94c564c1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c9ab62e5351a81a355=
64d
        failing since 13 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
panda     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/630c98d509a29a83e9355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
135-g75ba94c564c1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
135-g75ba94c564c1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630c98d509a29a83e9355=
663
        failing since 6 days (last pass: v5.15.61-1-geccb923b9eab2, first f=
ail: v5.15.62-232-g7f3b8845612d) =

 =20
