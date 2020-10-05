Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1702B28425D
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 00:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgJEWGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 18:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgJEWGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 18:06:23 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4041C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 15:06:23 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id y14so6825953pgf.12
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 15:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hd9ir1l88QYLKdxbcolMOQ5QA4CdcGZ5sRO32Hc2VZc=;
        b=FZzUDFyEebOIYwP4/Xqm7EX8QXbMX2NshOq+XhHlKwv+V0glr7yUWbPmbYQV8UhsGY
         NK3prIy6/p0bhHzFkQCdRjhVMJijU/ncQ9xnnCEXBOaZEmCoZWUqb/x3pH8wqhfSdax9
         NlybGzo5ZUoWdfDlVWXkRuV/eb/B2vIao3T985h6Zt9G75Qt+ExnwyUfAOeG3UuOs07J
         0oVbeXn0qqaCgFCdtCr7o91HmKFiD8hrNwRFMZjcg6CAdqNaBYZmgw3Ed5nm7GJEie89
         vtR45Ucg+lWu4gSkfdApNNCM1P6iYuOq5YjK7YufYJpFsSrS42CLKBLI2j/nYqShbjb0
         jG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hd9ir1l88QYLKdxbcolMOQ5QA4CdcGZ5sRO32Hc2VZc=;
        b=Qf0heXmDqitMyH3+xwk4JCBKLv8Uhesb1oI0VIgJkJGtaw02l9bmcHITHcnFoVCK6z
         y6d0sGRbFIqKZYOri5zozLGYB+HynubOvWa1+F6muVGNOhPhjicwmiIBc4EQq6bEXg8i
         rSgzOue8Wh8ja2kSw1gofZm6WQ/RxQYdPu1M6u5IqUH/KG85zcVpSQLV3CNMl+/GhHT+
         KGawGNUzN21cE8tV9u99/Ev6R5h3U8dIfPUbQ6BFNdPmDJwHK92zyoBgeyB7NmKtsPgJ
         UxWByFo54EGd9Q0B01yX5FN2KZxZAdhpAuVWXlRNlH802ciQZd87hBROp1we19/Qyft7
         m07w==
X-Gm-Message-State: AOAM533/JQD42/vlSgrggU90w2MlZVI1hILue8ViTbPYrC7B3ErIHTjj
        QpvxM/x6Z4uAsamiabqAejZ++XnfXRPfXQ==
X-Google-Smtp-Source: ABdhPJyl3mfV5X8hGlJWIh2+aBzMtZ/6ehXwcJP1nvngI4EtL2R468Hgm5pG/jt5qvNdT7X1Dcio+g==
X-Received: by 2002:a62:75d6:0:b029:152:6ead:63fa with SMTP id q205-20020a6275d60000b02901526ead63famr1923359pfc.38.1601935582632;
        Mon, 05 Oct 2020 15:06:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1sm642529pgm.4.2020.10.05.15.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 15:06:21 -0700 (PDT)
Message-ID: <5f7b98dd.1c69fb81.1df2c.1969@mx.google.com>
Date:   Mon, 05 Oct 2020 15:06:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-57-g99967d9c3f11
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 110 runs,
 4 regressions (v5.4.69-57-g99967d9c3f11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 110 runs, 4 regressions (v5.4.69-57-g99967d9c=
3f11)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-57-g99967d9c3f11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-57-g99967d9c3f11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99967d9c3f115034c7426b2855b0f991bc6fea12 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7b5ce7a7d26b253d4ff3fa

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-g99967d9c3f11/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-g99967d9c3f11/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7b5ce7a7d26b25=
3d4ff3fe
      failing since 1 day (last pass: v5.4.69-3-gf31ade88ddd8, first fail: =
v5.4.69-16-gde6f85667998)
      1 lines

    2020-10-05 17:48:28.858000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-05 17:48:28.858000  (user:khilman) is already connected
    2020-10-05 17:48:43.950000  =00
    2020-10-05 17:48:43.951000  =

    2020-10-05 17:48:43.951000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-05 17:48:43.951000  =

    2020-10-05 17:48:43.966000  DRAM:  948 MiB
    2020-10-05 17:48:43.982000  RPI 3 Model B (0xa02082)
    2020-10-05 17:48:44.069000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-05 17:48:44.101000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (376 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f7b5d62201fe963d74ff427

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-g99967d9c3f11/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-g99967d9c3f11/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f7b5d62201fe963d74ff43b
      failing since 6 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-05 17:52:25.543000  /lava-2691971/1/../bin/lava-test-case
    2020-10-05 17:52:25.552000  <8>[   22.951898] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f7b5d62201fe963d74ff43c
      failing since 6 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-05 17:52:26.574000  <8>[   23.973510] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f7b5d62201fe963d74ff43d
      failing since 6 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)  =20
