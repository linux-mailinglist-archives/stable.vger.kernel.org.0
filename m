Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287F35F5792
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 17:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJEPba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 11:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiJEPbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 11:31:23 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2D44153F
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 08:31:22 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n7so15710942plp.1
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 08:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=F/HoEXYC1vG4pNtReHpECp3luNIfm26fZBhrAZ6QCio=;
        b=g2EEz6OcUsclGZv75IBlJulCAHL+ANtLSIFkiiWEsXqLnGvJv918D/XL4GL9SZZ4Ax
         l3oyn8z6vMhzSsvGkZPfCpnmvdxel4czkEkujxumbnLFqTsWfmEBYS9y8zr0n1DVzYy9
         avAXstYgKSl+7q8pnvbMVyHPTN1uiBLfKTZ8CRxFxwXs4PdpA926l4dBiqJVM9KuP9pT
         D2qU+5CEjrkd5kwQqocvmj0BvHkPoyLijPQX11mS3wjJYX5/HCq0EpnUW7UufpxvyXav
         GfigcY0N6O5v/27S1XcQvRmuYkbCuLAzomswh1/3CsdRkfZ64GljjNoGBuOdhGAVTgnq
         c1fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=F/HoEXYC1vG4pNtReHpECp3luNIfm26fZBhrAZ6QCio=;
        b=kSLhA1kjk1PLn+dUTiV8AAah6RCQ5xzF84i45QMUCCahv5rgxxcPSOf/QJK6INPHgG
         E2ku1JswYjZd0a/jzgs1hm4Fw/WeAuAqxo58eA7enn9bnt617CdEO97ZBmhn9+QIqOXY
         88g+kQ2cRMDwy1TRfmClEsGEIb3BP4zQ6Dleg/DHuSOHJVG0iYOlIEJxPNVa/hXiaMv1
         UmMgda0tAxXcVzJgnagq3wT+TUZYV9ypLdzlB2YuUz4lywOVnZH+FKTdWK0i0bt3ELvE
         H5lPVGjKtPqx07AMrqybLvWxFX4foxku5KUUcBdnjH9RXWZxKeegDnW3TnI5dML1mu2x
         ThrA==
X-Gm-Message-State: ACrzQf32EFAnBWwZ0lIY8gPO758BXyEXLguGXa6hxhnvFnPXZPOLggdh
        yU+FcCxLRwz3JmgdQqeeEn8oI5LcNx0fXClg46w=
X-Google-Smtp-Source: AMsMyM4aS0nlcl53QM8Yu6msUN6f8W88zfkJKYxrZwZWOLyoahzls3r23YlwB+r99hlZy4ZlmNYiYQ==
X-Received: by 2002:a17:90b:3e83:b0:20a:f3dd:3e2e with SMTP id rj3-20020a17090b3e8300b0020af3dd3e2emr2463976pjb.191.1664983881815;
        Wed, 05 Oct 2022 08:31:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090a890400b0020adab4ab37sm1277111pjn.31.2022.10.05.08.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 08:31:21 -0700 (PDT)
Message-ID: <633da349.170a0220.4da1.2699@mx.google.com>
Date:   Wed, 05 Oct 2022 08:31:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.12-109-g8ff3d122e0c3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 43 runs,
 2 regressions (v5.19.12-109-g8ff3d122e0c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 43 runs, 2 regressions (v5.19.12-109-g8ff3d1=
22e0c3)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8173-elm-hana              | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.12-109-g8ff3d122e0c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.12-109-g8ff3d122e0c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ff3d122e0c3fbc1f67cddb9b3e82c0cd72b668d =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8173-elm-hana              | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633d6d884631993330cab605

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-g8ff3d122e0c3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-g8ff3d122e0c3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d6d884631993330cab=
606
        failing since 2 days (last pass: v5.19.11-208-g633f59cac516, first =
fail: v5.19.12-101-g42662133e9bdb) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633d6c0d87234a2b47cab5ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-g8ff3d122e0c3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
109-g8ff3d122e0c3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d6c0d87234a2b47cab=
5ee
        failing since 8 days (last pass: v5.19.11-206-g444111497b13, first =
fail: v5.19.11-207-g5704e94c78ce) =

 =20
