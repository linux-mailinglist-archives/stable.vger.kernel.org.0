Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4337B29515C
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 19:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503382AbgJURMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 13:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503381AbgJURMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 13:12:45 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B43C0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 10:12:45 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t22so1525873plr.9
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 10:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ot75stHS6+kooEr2aGTeb7RnTjaB0BKUMLhu0m1xGSo=;
        b=SCCpojidmMF3hfirZ+tB2uY0Wf9Hczs/8QM2xFDLuM5OjNmDIPV5eiugsjFLzLRboS
         /CHfrm0ec6670nRgXBq//gng7jhScvgcsKvzVm1b1PPqLlD2bJQeGYWoSmPOUMR2Q5DL
         z3K4nlsRr9Tbgag4x8PpvT/4RINmRs2LW6Sc6U0URNly21Um2InKz9Y8nbWY4b77U4mF
         RzR83Rxfq8piXiLX60M2ygMKY2Xr1tMADeuYKTIj60BbSaREjKtM1VHmXeryDKRS6Ju4
         HyBXzcmZpOhfzRBMBzjjKnosSoTKIlIlli641ZiW1erNVVt+M8oB2aZnbYKJcXDC8o62
         QF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ot75stHS6+kooEr2aGTeb7RnTjaB0BKUMLhu0m1xGSo=;
        b=RH/AO2CFDvt4SebBIJ90QsWYceZBCCIW92V/gcxeTeZSRlMoiIhIhaYHusqf7gvFL7
         y+EOFUmWFcg8w7a8ip3rvzZBT7qq86fubCo77q/vTgUbdpOHvg/lEUf6w5zW4JRSAc48
         /HhvdiCO1ATM6HPoXoskCjxDBCHB8733/d5suT4Idae8e8uz/IKDQ+penTOS13+hWKz1
         Kq4XnLAF8TY+kfnhRO0O/SRf+ttkw9iOjNFrCRpfHBBFN9Z7xtP7hMLg08sjibLlZ/p7
         F0Rknkgsb46EWyaG6f/d0bAIEbyj8/0+oNxJ8ppdcWXlSUCWQg+J2NG3b7OW4whUrI9Y
         NNHA==
X-Gm-Message-State: AOAM532yJS1L9cfNT9NRWV0lmObbkgNZQir0VFfDssF68fjOzSnLPn6+
        RVMzxiEowcmg+pZ/1rJTLqqemVVFDx8FDQ==
X-Google-Smtp-Source: ABdhPJwSbsec/EcJZLaJr+xgrvmN0BLPEFVNFQBKhDVkLT74fWpsQwZ51Dl3YXTX3YvETWNYULLtxQ==
X-Received: by 2002:a17:90a:1c4:: with SMTP id 4mr4415546pjd.86.1603300364233;
        Wed, 21 Oct 2020 10:12:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z3sm3003680pgl.73.2020.10.21.10.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 10:12:43 -0700 (PDT)
Message-ID: <5f906c0b.1c69fb81.b6ba.6f69@mx.google.com>
Date:   Wed, 21 Oct 2020 10:12:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.72-24-g7148af6c47cc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 165 runs,
 4 regressions (v5.4.72-24-g7148af6c47cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 165 runs, 4 regressions (v5.4.72-24-g7148af6c=
47cc)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-24-g7148af6c47cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-24-g7148af6c47cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7148af6c47cc42460eef29279d73775c63202162 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f9035966073a63f394ff3e7

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-24=
-g7148af6c47cc/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-24=
-g7148af6c47cc/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9035966073a63f=
394ff3eb
      failing since 0 day (last pass: v5.4.72-23-g71c30c5eec09, first fail:=
 v5.4.72-23-g515f94ebfac5)
      4 lines  =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f90355ce652a8adc84ff424

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-24=
-g7148af6c47cc/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-24=
-g7148af6c47cc/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f90355ce652a8adc84ff438
      failing since 21 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-21 13:19:15.159000  /lava-2738013/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f90355ce652a8adc84ff439
      failing since 21 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-21 13:19:16.181000  /lava-2738013/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f90355ce652a8adc84ff43a
      failing since 21 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-21 13:19:17.202000  /lava-2738013/1/../bin/lava-test-case
      =20
