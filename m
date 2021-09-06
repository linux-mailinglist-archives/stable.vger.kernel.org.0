Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F02140210C
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 23:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhIFVUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 17:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhIFVUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 17:20:21 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15351C061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 14:19:16 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c5so4545088plz.2
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 14:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ex5Zel8RAupaalKLfAZPGSMCpucNqN8kgaJp8tSZ0eY=;
        b=lM3QWV18m15TDGmyA24sW4OLWfcqOnbHsVKhBneGR27ZAPFdi/FxJa6kvmaxxU2Hvm
         Wz6TjaKSsh2nGC1fT97fNR6BUtwRDIv5FhhMXQMmfovOPFI99mKTKEUAwPJ2Vkq6q8BK
         9cEhRwmem9iGhBLjPwIJ2lrdTEkxzTq5xWm9ndE519h3sh48G5GjZaefNpWEz5f1813D
         pAgjPvfPED7DkLmiaAVmFTLvDmAoKkCzng7F7KjjAwMQWnaMQYBtAeAWhRJvckiTYPC+
         QrDjoyTgVULLD95boaVhad5qhDAGI22glNHedDj4MtU1CVpiLmFAnYdsAtUtnwNQwDOG
         d8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ex5Zel8RAupaalKLfAZPGSMCpucNqN8kgaJp8tSZ0eY=;
        b=RS794IfBtIQt5Jt7K6P9uW8k3VTzv1dtNp+UhsHGfnNJ6v+3Jk2Wjk6LmlxYh5dKa9
         dTdV+pP9UtZZwFsIf8N0WX7M/azz/r+5oMVhWZxVl+BgaVerwPhYLvjiW7EkRI6lmRLN
         QG8U4/DtZHe/QPmaurcCQ1sKonX3BR+y1v6A32QNIXqegVCcKdtk7SyGRqn78JodwVIy
         ofBurzlgIXvGo4hgBzp6ZQTV0nZwbPKb6PtC4h/+BrBg61Jjt+ss1z3IGSqw8fPpHeMQ
         NvBAkDlwNN0XUfroV05NeYfAUH1ikz06IttwV+ZKDO6Sm978hhHvBXSD6CKFaP1Eqnq6
         JNKA==
X-Gm-Message-State: AOAM530mpxIAdpIYaGgjdL3bSaGjT6et8tyv0qWo+IXm+kmyN1HOB6tn
        Ny8h6RiB/FJMUOOG1tTolKGMsaPjwVsnwTsu
X-Google-Smtp-Source: ABdhPJy853nH24tLvJ9n1zY2qN55HHJRJu5M1B6HQmksSX1JVx2IPMacoBWP8m/CeSO8eU0OjC3b2A==
X-Received: by 2002:a17:90b:116:: with SMTP id p22mr958379pjz.67.1630963155366;
        Mon, 06 Sep 2021 14:19:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g140sm8220293pfb.100.2021.09.06.14.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 14:19:15 -0700 (PDT)
Message-ID: <613685d3.1c69fb81.c38b3.79e4@mx.google.com>
Date:   Mon, 06 Sep 2021 14:19:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-21-g300ede31d088
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 197 runs,
 3 regressions (v5.4.144-21-g300ede31d088)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 197 runs, 3 regressions (v5.4.144-21-g300ede3=
1d088)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-21-g300ede31d088/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-21-g300ede31d088
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      300ede31d0889fa41cfe78f7ccfd30d139164855 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613663a40adc65c458d59672

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
1-g300ede31d088/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
1-g300ede31d088/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613663a40adc65c458d59686
        failing since 83 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-06T18:53:16.443373  /lava-4460178/1/../bin/lava-test-case
    2021-09-06T18:53:16.461005  <8>[   15.063256] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-06T18:53:16.461500  /lava-4460178/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613663a40adc65c458d5969e
        failing since 83 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-06T18:53:15.019542  /lava-4460178/1/../bin/lava-test-case
    2021-09-06T18:53:15.036337  <8>[   13.638772] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613663a40adc65c458d5969f
        failing since 83 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-06T18:53:13.999395  /lava-4460178/1/../bin/lava-test-case
    2021-09-06T18:53:14.005171  <8>[   12.619162] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
