Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E594D722D
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 03:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiCMCee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 21:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiCMCed (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 21:34:33 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0F43524F
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 18:33:26 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t187so10789458pgb.1
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 18:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8aUaH7GPFdRHGO84JB1Xegh4huxPDxiATaTCxhtmwOE=;
        b=ZLQDkUjKiMTKag5rLQlvoO1jN0N7RbihR2kcmlm6NfrrhCwAvM20yc5OEY30hIx9yG
         Zo0zqNbG7sSvFjhKifX8YLiPmhwLaQeshuIuCVxkbhR+HjrgHn4ezTmBvkGH7GXmMVJh
         xW3DphJ4Kl5H5ncf9k3YeRMIwcDZAiey8Kirslad5BAqAoFGa6ND6SCCj1dikhtvZ8g+
         PSxs/zekV8JwCQ+Fk5lT2U8bVUcY73di04tNOiqGkYY0lkxiUytSjaq1tU/mpvgEoyTl
         WzZkeS2Ynqw+YR51NsZtPK2Y2NTCNazfoYPi78TVcTLvV5am+llb9OZcTUzy3Wg6cL+s
         m78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8aUaH7GPFdRHGO84JB1Xegh4huxPDxiATaTCxhtmwOE=;
        b=Rn0Lfi10TnI0TxUnyTE9XUQxQZ+Cujs6rtFVIHFJt4FzoH2VCsgBT0yB2ZERFaMuTv
         JSMjWNUjpSZAUaZ7QvAURxVgHRdTmwzCrdhD9qtKNbCGKtCdDozW4EkFglwjJL3+rw5R
         2xh96DU15yk2Gr4SE+R0gN47JrCw6x/aVpGOJg2zLhHENYw9hXQYxqsnTKBTWBCyiIQI
         f0Hrlz7474S4GK81oul22YLLuZZjsyxsJog4jP6DFlmOLDQYiPVXaYRpkTAOV/zx4voC
         EetALV8eOWS2I3yI6XKJAnSTK/Uk2mi14/8IYasinEZCobvMiYwvt7OGB/zyd8jYXKrv
         5BKQ==
X-Gm-Message-State: AOAM530kqtX9EbZfZFyJXADmtty6FyLzYnSir5BWKp3qUbyLWxMqih3g
        /6ECWtWu1kmUjMedsXuAtOu+TKCa4IYXzTXukmw=
X-Google-Smtp-Source: ABdhPJyU+2G7qgo2QsxCND0ucSq1jNZ1A51mqdHPpe8sL991VWqBuv5MjuX3BjsPPU91wcq4ir3CDw==
X-Received: by 2002:a05:6a00:2284:b0:4f7:86a3:6f6 with SMTP id f4-20020a056a00228400b004f786a306f6mr12422826pfe.20.1647138805698;
        Sat, 12 Mar 2022 18:33:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nu4-20020a17090b1b0400b001bf497a9324sm18118790pjb.31.2022.03.12.18.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 18:33:25 -0800 (PST)
Message-ID: <622d57f5.1c69fb81.8140f.f4be@mx.google.com>
Date:   Sat, 12 Mar 2022 18:33:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.184-38-ge007a4391420
Subject: stable-rc/queue/5.4 baseline: 78 runs,
 3 regressions (v5.4.184-38-ge007a4391420)
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

stable-rc/queue/5.4 baseline: 78 runs, 3 regressions (v5.4.184-38-ge007a439=
1420)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.184-38-ge007a4391420/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.184-38-ge007a4391420
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e007a43914200c417613c3b39d593669536e547e =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622d21e795387e2d31c6296e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-3=
8-ge007a4391420/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-3=
8-ge007a4391420/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622d21e795387e2d31c62=
96f
        failing since 87 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622d21d395387e2d31c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-3=
8-ge007a4391420/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-3=
8-ge007a4391420/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622d21d395387e2d31c62=
969
        failing since 87 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622d226963c2b489a4c62968

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-3=
8-ge007a4391420/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-3=
8-ge007a4391420/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622d226963c2b489a4c6298e
        failing since 6 days (last pass: v5.4.182-30-g45ccd59cc16f, first f=
ail: v5.4.182-53-ge31c0b084082)

    2022-03-12T22:44:44.481975  <8>[   31.640086] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-12T22:44:45.492886  /lava-5867574/1/../bin/lava-test-case
    2022-03-12T22:44:45.500686  <8>[   32.661143] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
