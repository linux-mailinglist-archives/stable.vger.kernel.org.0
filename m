Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5E4E5322
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 14:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244276AbiCWNbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 09:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiCWNbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 09:31:33 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F88475C2C
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 06:30:03 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id w21so1116922pgm.7
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 06:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+ncWgHYZO++jEM1iwy6QkxU15J9FHZOkuQsUU5sSwuc=;
        b=fHpOxMZFOG9Avn2Vrimyg1Xgvwx0pnaF1KKkVK/PV6dotfdOOTJ44Gl2DVaRSd/ceP
         qrUltFL34ViGf7q8fqdcKvere208ELK2pswPn2D9r4OPtSO9UDbmFycUZzFU4CrIrOK2
         Q5m89Nkd+hb0nRAzrZ4d5VT7LRWaYldzwT53E+cTh5MP2v7W0xH8kZn3OqFzz3rDGksA
         BEJSQhJVUp57I0NUIrZQ7t7BTJ+FGweo1eqLuH3HkzH1iTL6QDUqVQq6I8oGlO8+eyHo
         AFjdbVVDG2QVcsapFBndyZjgo61UzJtDwCizr1h3e8T1EUDEr192GmnsDQgiyg0o+Q7h
         zqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+ncWgHYZO++jEM1iwy6QkxU15J9FHZOkuQsUU5sSwuc=;
        b=7BvO9fXB2wxanGlRpO4MCPceS3u4N6AxwKWXMf/5V7DeChCJdbIaVW1vbKvLnNH8On
         Ol+nvqqqlmgfEUZTOBAXH6qHNQvgou1GJx7+E9sRPBezrkxBTeZqYvmv+F9CO/x31PON
         Jl02EP+M+yC6EhrEzuoQNWfKi82taUmn4zflDCeSXTU0i+NwmLBZawuG2X79H1GERA2j
         40o1NNlWx/wxoslR1tgk6+Mdrf+kNkQgVQpARmMN3GxorD2F7W/AseDug0zCmdiB7gPK
         FpndYjnovuBSuXsiHmBj106GfbZ+Lettx0MC0Kd5f2uEKMcUEirPGm57kqg2hKMDAtGi
         WkOg==
X-Gm-Message-State: AOAM533x4K1uKdpQrjMzHF/qHRNMHeUphXx8W2JqR2s6aJIkSO9TMuef
        KiPt18OhTFnaGEQ9S7ivYeqWuLWX1J1V7fv2aG4=
X-Google-Smtp-Source: ABdhPJz/fo8bamrFt1dI3zNbH23LOn4StSOdotp6Y9q19KhnDDcuVABM9Yk1L0rsrO5v8lZFdsY3iw==
X-Received: by 2002:a65:6390:0:b0:376:7f43:e9a1 with SMTP id h16-20020a656390000000b003767f43e9a1mr25742095pgv.480.1648042200881;
        Wed, 23 Mar 2022 06:30:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11-20020a63e00b000000b0037341d979b8sm19979233pgh.94.2022.03.23.06.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 06:30:00 -0700 (PDT)
Message-ID: <623b20d8.1c69fb81.5e4e.6486@mx.google.com>
Date:   Wed, 23 Mar 2022 06:30:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.273
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 49 runs, 1 regressions (v4.14.273)
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

stable/linux-4.14.y baseline: 49 runs, 1 regressions (v4.14.273)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.273/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.273
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      004bfaafc45ccc95366b37c9b9e7844cd5156368 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/623aefe05d6290d0e8bd9199

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.273/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.273/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623aefe05d6290d0e8bd9=
19a
        failing since 34 days (last pass: v4.14.266, first fail: v4.14.267) =

 =20
