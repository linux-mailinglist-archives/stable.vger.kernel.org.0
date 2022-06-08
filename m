Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D70542780
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 09:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiFHHFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 03:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354724AbiFHGTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 02:19:45 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E8F1032
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 23:16:32 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b5so16752730plx.10
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 23:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0GkOJYaCBXzCBlsyOneMd8LfwcYju+gEnp6ihxGcLqU=;
        b=ZEM+AYoLWGB38NftvKyW5jwq5m68EAQ1WKB6Cst/eteulMx6kFLpoj5DnDGaXjClFt
         ArVw/0LKIRkClQTnBXaMeVdSkgBbaYWIHZzI+PiLoZLXxRCE2guB78Zs0NxEpaF97lJQ
         q5c4AKn05scOqA6I6//CsUqk3Sz4R2KqckwdS0SFXTjbdzP178Vinr15YubzO6mXB18n
         iBxAKth0ole2fpvmmy/kRasbvkXFQR2fkR0Qi2Zw5kwyfVmtHDUWzjT+lN799sry98Ij
         iadw41eOo10kqcmXn/RzE+rjuMVb1m3YoYouvD5EwZ1PGJ4BE7uQ11YSONaB0JSxbnGS
         JtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0GkOJYaCBXzCBlsyOneMd8LfwcYju+gEnp6ihxGcLqU=;
        b=LWdHX+UiEoH65xEQF0NwRLJWLKDAKrUXRcDPVy74j/CSmiCtRfoKX9oQh4LJkOFA8V
         /gwgvJ1Jgeev+TaMoFW0vPdpQWosfr8vd+n5J2JhZjlMiaK/914SOAIeyVkX4Zq0t0ls
         HEe3TLvJ/xidiZjZ7e/iJOlEv1jmHD/i7otSpVYcLTIdiVRPhYx3Ib0iBObMjAydWvF8
         FT0DoUEsPab59VXLIWCMD1QlEZqOwg7EDEhSOwObxpSLyRKn1UNDJgmW/tfyThHsOHTx
         8oKpoxPvMnGxGBNYeyu9A/+ePWRwNMwK98lZWi6myyjxnn+gyqZH2zCooW1zsniWH5CX
         WeSQ==
X-Gm-Message-State: AOAM530CUKUwAPVjphUltoece2E45FDMC7xT1fWB6/z+v56w8GVBi5xL
        HFkPspnLOxLAfi8cs1HjAyDBtpfXmqXT/SscglU=
X-Google-Smtp-Source: ABdhPJyMr0uyTO6nc9uf4VKrm1CDyBnM3vF2BQFGWNaeJ1ciQw2uJsU/NXGOyJbqDpW1DEh1gca+/g==
X-Received: by 2002:a17:90b:3506:b0:1e8:8449:6acb with SMTP id ls6-20020a17090b350600b001e884496acbmr14839780pjb.27.1654668992002;
        Tue, 07 Jun 2022 23:16:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t3-20020a170902e84300b00161e50e2245sm13771232plg.178.2022.06.07.23.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 23:16:31 -0700 (PDT)
Message-ID: <62a03ebf.1c69fb81.b5c5a.e0f4@mx.google.com>
Date:   Tue, 07 Jun 2022 23:16:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-667-g99a55c4a9ecc0
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 142 runs,
 2 regressions (v5.15.45-667-g99a55c4a9ecc0)
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

stable-rc/queue/5.15 baseline: 142 runs, 2 regressions (v5.15.45-667-g99a55=
c4a9ecc0)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-667-g99a55c4a9ecc0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-667-g99a55c4a9ecc0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99a55c4a9ecc0e88865a30403e66c12673e6ffd3 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62a0291d8b38397597a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
667-g99a55c4a9ecc0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
667-g99a55c4a9ecc0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a0291d8b38397597a39=
bce
        failing since 1 day (last pass: v5.15.43-212-g8b5c4320ffac2, first =
fail: v5.15.45-652-g938d073d082af) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62a009d59744a826f2a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
667-g99a55c4a9ecc0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
667-g99a55c4a9ecc0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a009d59744a826f2a39=
be2
        new failure (last pass: v5.15.45-667-g6f48aa0f6b54d) =

 =20
