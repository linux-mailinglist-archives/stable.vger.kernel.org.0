Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEF84E6E3E
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 07:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358470AbiCYGjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 02:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358468AbiCYGjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 02:39:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70116C6ED0
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 23:37:40 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id t5so5721575pfg.4
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 23:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S+Q/Q5Djp1rONEqCOI3HKNHtPiZjnhU01rvHEXloiN4=;
        b=V2X7pgbYCVwpXMTBHUxXAKibBlPHPaDDsAZijwonpuUDvwXpY1aLIgNI/sjEMFTZuD
         txhdGwKeoPBAhxLoxEgsDRHAW93onyPHZ9g2SEJi7sMfn2sPP/30ZEFRjOP4gP1uH4H8
         u7PnGt+hMorhQizzuy/NZ/LibOKi3bllmDEmHPHOr2PiSTICcJKIBibw1vSeT1MTXUrm
         xLuGsTrIB8b+2k+45w+7WNMkX3OkUpzhDg8ypYYZOnP+MWNTNGK6qYaNSMcdyalc8GBS
         tZKkXRchSIA/MA8YtogKVfl4tq43NEL3ADGNEnRKdkLGA6OcvkCFv88Xu3GSft0m+r2Z
         TlUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S+Q/Q5Djp1rONEqCOI3HKNHtPiZjnhU01rvHEXloiN4=;
        b=38A1OOEdGC5SJnYIw34hUUw6sVSg6IzZvktLUTiTU1IRe6votOjrLEsNEijJvjD6uX
         uCmrtL7vFvZLQY7hCxlZC99rfhN+UCL7FsSex/xIO1I/n+cfl5d429+5QBPekA5JuYFi
         qUyLzAF8g58iifbDEm8LnPxxHx05HLRICYy7OfgC/CMtnW2OAkoXEg95rc8NGQJAGo4e
         iUUDELcJ+STSdjsaqeqWeX1Fxx8y32wmsrY7MjXztNhKb4fLgDWh9Lu/NgQe1LkElGXU
         UTCjsAC9shEXL/OhzV0SwE2mWPQZpla6L56nFHcNQOzPAdGxlHWXP6JlepAEMb7Kp9WK
         GGyg==
X-Gm-Message-State: AOAM531TCEDbCJ7mfpHqG+Px8qL62Bjgiu75Y4Gbym8nU5g5i7ykTMG/
        YMp3noUGRG13nKg47hQZQ0D36L9Y3BFNrAkUIq4=
X-Google-Smtp-Source: ABdhPJzk8JAubfrXea13d94PTLOcoxFjHkp+1wdma+qcRbotfTftLIzxp10KQ0QK0Z4xE3hLK1qUdw==
X-Received: by 2002:a05:6a00:1252:b0:4fa:afcc:7d24 with SMTP id u18-20020a056a00125200b004faafcc7d24mr8652382pfi.85.1648190259807;
        Thu, 24 Mar 2022 23:37:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c63-20020a624e42000000b004fa9ee41b7bsm5164404pfb.217.2022.03.24.23.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 23:37:39 -0700 (PDT)
Message-ID: <623d6333.1c69fb81.a4c5d.fd85@mx.google.com>
Date:   Thu, 24 Mar 2022 23:37:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.273-4-g30b6431344d2
Subject: stable-rc/queue/4.14 baseline: 52 runs,
 1 regressions (v4.14.273-4-g30b6431344d2)
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

stable-rc/queue/4.14 baseline: 52 runs, 1 regressions (v4.14.273-4-g30b6431=
344d2)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.273-4-g30b6431344d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.273-4-g30b6431344d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30b6431344d20026bd56904d8cbdcb3a4b8a1cc2 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/623d32ddfa547f9134772524

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.273=
-4-g30b6431344d2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.273=
-4-g30b6431344d2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623d32ddfa547f9134772=
525
        failing since 39 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
