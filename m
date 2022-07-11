Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696575709B9
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 20:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiGKSKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 14:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiGKSKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 14:10:36 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B8313D19
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 11:10:32 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 145so5369596pga.12
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 11:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4pEn/PUkJfFAv5/4QsX403dckTrDjVudzpkmyhHo/QI=;
        b=haxqMrIzi2BGDISmWEaIsVs0ZWbAhWMagoBhgSBrwU8u4TW41NPWaIZEtOfm7OdxTu
         4hzAC6JoRDOoZ4NS/jbCvfcM0s+slNGi1MfxwA9JswDsvdfZUsPe4xZA2v2e93ql9+U4
         PR9RRa22HQBKbGqWeHHtb340b1KLoAonK3V2o/6piRMjFoIjSDa99CTKNB3fjzIl7qLn
         ac6r06xt11IgbZDaZmSdyHpCWKRDUIoP/8mGaZ1EGoBElFOorEOtrEvB6ksu3VWVLfgL
         ZmworlnUm/ld4KbzW4ARuykj724/lE334VMV9AUNnn2ZcsXmHCwuvncdTY2u08yGuDyW
         20Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4pEn/PUkJfFAv5/4QsX403dckTrDjVudzpkmyhHo/QI=;
        b=SSQkaunv2BbN8yrx98cX2RPj+OjxwN7ZO3S+x5p4pvDaoXLa7NIxcs957iET208ugm
         iNFmX31zeHG+kTsX3AoqGTKgIL3V/OPzvtoXO+1Y+GcgVs5r9lJJOymWzB+nJnxJ5gSe
         dEbTWBJb3oPxQItwBKpVicEdKsh+ORgBhE8eDXm+b8M1tU74Enc6+UYB5YlDROB7TuJL
         Jzg8w0eVlKzR2oskzKYAgTX6O8SsnUP0B6SH4xxzDioz5Rw6r5isEwkJHCiyRPWGNGAm
         VLi7umOMV5oWlmiKn9EiqramomQzsNoqmbo/JbGBy7/DRG5kzLFsYoU31P/3ocj8E/Dt
         R35A==
X-Gm-Message-State: AJIora+h9WiubZquukXBxaccO4BBbWB33ukTTAQa7kRbN9dawHcRdCK6
        qJWoSh6BFG0VZBVGlCAfQUjvLAvpVFvIvYpA
X-Google-Smtp-Source: AGRyM1vMHwgiamWF5jWX6vxhyyU7eTt5IG+SXkjIYMA5H7WWIWOP2LYotCaq1yDo9b6/zOZDMWfQHw==
X-Received: by 2002:a63:2cd5:0:b0:411:3eca:da41 with SMTP id s204-20020a632cd5000000b004113ecada41mr16364821pgs.502.1657563031368;
        Mon, 11 Jul 2022 11:10:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o10-20020a17090a3d4a00b001efa35356besm7332909pjf.28.2022.07.11.11.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 11:10:30 -0700 (PDT)
Message-ID: <62cc6796.1c69fb81.37eb.a86c@mx.google.com>
Date:   Mon, 11 Jul 2022 11:10:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.322-5-g292a71a8b92b
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 83 runs,
 2 regressions (v4.9.322-5-g292a71a8b92b)
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

stable-rc/queue/4.9 baseline: 83 runs, 2 regressions (v4.9.322-5-g292a71a8b=
92b)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =

jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.322-5-g292a71a8b92b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.322-5-g292a71a8b92b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      292a71a8b92b1bfb9c29b10686f2ee4006a1d8f8 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62c88db5f34c107b7ea39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.322-5=
-g292a71a8b92b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.322-5=
-g292a71a8b92b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c88db5f34c107b7ea39=
be1
        failing since 45 days (last pass: v4.9.313-7-gbabb34651fcb2, first =
fail: v4.9.315-25-gebb662d6916b) =

 =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62c8899284164ab7eba39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.322-5=
-g292a71a8b92b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.322-5=
-g292a71a8b92b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8899284164ab7eba39=
be6
        failing since 45 days (last pass: v4.9.313-7-gbabb34651fcb2, first =
fail: v4.9.315-25-gebb662d6916b) =

 =20
