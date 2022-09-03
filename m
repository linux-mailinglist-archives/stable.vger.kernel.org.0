Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D9C5ABC2E
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 03:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiICByt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 21:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiICBys (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 21:54:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5042AE06
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 18:54:46 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 145so3531521pfw.4
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 18:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=hTyOfUVXeV6mRK9d7742yMTsOXpXiHMt/4NaHe2AbTo=;
        b=fL1e04gCLnB/0euyR0dzXg+LByuhqFV2+BcACVC5TiLwuRL1K5wOEDS+Nlp8yD66S2
         m3Ftx5WlkaozejZoHU2Z9/iEzyY0ix4bq8PGpW5IP3gHbGkcqpbPUYTfEGQ3P9L+v+ru
         PnpbQkI5vrphFRD2PeYgasboClslQ/mNIysQwbxlHz4rYnfsPwvFjjKn05zZe5o5ci9W
         1l4aev7ALhvEUbP+fjTy0X6nDvBHtIhRghZ4Z6BlocObt2PrZpsFMhS3YaFmBIg++IU7
         hxqOr3TRHDK40NJWV400+MKqTXRrvmFW8o7RvK7KNkYS1yJXE5IjAy9AqJUh8YAPWZNb
         BLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=hTyOfUVXeV6mRK9d7742yMTsOXpXiHMt/4NaHe2AbTo=;
        b=7SAHY34xi0i9/WvXSK6QJBy/si02N2alTLHcXj8U3XDr5yhUeCbKd7DMA1Z7vSDD9g
         TPRy6Q8q4vhVbVSPx1KQ12KiKZm0BW7ixg/gZ3gfdP/GAFmQhAbsMwTVNeYh8cQFw2kJ
         krzgOlCyMsWap6hDWcth7UbQwQ2SFJn1PD8KlJ/N3VfKzRXwo03cAOBToTHxsR5pblLI
         B91Vmg0fV4SMOnfJqUe5dyaG2L5+IdfECKWxA5F2EwISto0tKE3w27XphkTPyIV0HbUR
         ndLMsiGPxyYUs+xbl78LmP+iSeFKfR/J06P1G0NGFUx3xphnyAgmdhX4e3/7ZCscEhIo
         PGfw==
X-Gm-Message-State: ACgBeo21uWGyYkdrvAu/QbPQ5O8eO1Vy0bKR7vWqGi+EQR1/TyEQUvdh
        Kj9WqQL0Eo55zStidVqdSgGtciPl/TAgPFNx5oI=
X-Google-Smtp-Source: AA6agR5mEItgji8KOV1PVwWOg9M4JFqAKRRYvXySbsJC5xNec+0XFQOuUZZ5OWmQuQJVivhs2p3adg==
X-Received: by 2002:a63:5a61:0:b0:41b:b021:f916 with SMTP id k33-20020a635a61000000b0041bb021f916mr32169960pgm.387.1662170085510;
        Fri, 02 Sep 2022 18:54:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n12-20020a170902d2cc00b00174c1855cd9sm2325961plc.267.2022.09.02.18.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 18:54:45 -0700 (PDT)
Message-ID: <6312b3e5.170a0220.d3fb4.4537@mx.google.com>
Date:   Fri, 02 Sep 2022 18:54:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.63-211-gad2e22e028e72
Subject: stable-rc/linux-5.15.y baseline: 71 runs,
 2 regressions (v5.15.63-211-gad2e22e028e72)
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

stable-rc/linux-5.15.y baseline: 71 runs, 2 regressions (v5.15.63-211-gad2e=
22e028e72)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.63-211-gad2e22e028e72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.63-211-gad2e22e028e72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad2e22e028e72136a55cb6c301a29aa0178fe7d6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/631283f87fc18211a8355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-211-gad2e22e028e72/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-211-gad2e22e028e72/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631283f87fc18211a8355=
643
        failing since 113 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63128035c27ab7b83f355659

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-211-gad2e22e028e72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
3-211-gad2e22e028e72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63128035c27ab7b83f35567b
        failing since 179 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-09-02T22:13:48.527590  /lava-7172104/1/../bin/lava-test-case
    2022-09-02T22:13:48.538591  <8>[   33.443089] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
