Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC1D3F51C6
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 22:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhHWUNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 16:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbhHWUNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 16:13:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA13C061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 13:12:23 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h1so6871405pjs.2
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 13:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fG0k8sw1OieyV4lUmjMvkJSMRSJdmJBeqiAbvPXKm1g=;
        b=0snq7U7pJeuTGtxJHEB9H0ntZlIN1VT/uSx7IrFG9H8c58B0WgqIHLjM1brXZydYVJ
         BAEMItkQGg39xKtt338mka874a1JFOoDjx2CK9ejurVmvY7KH1bZkOTOTq6FaNRF9CW+
         WBZIru5LPQ9MTZGQaI/3R2h1Xovs6DTxQ2lAbLjBE32VFTsxNwy6OkPN9eL3e1LxSIPE
         HgYYqv8M1bnTjSbmyl80G5YKQE13QbfSKLiuvtgQKSgXhtktf9FCxa6jeSQyHuDn3tez
         A/UJU+yzNbH9+34lH6fgfzIg3CQANTDN6Hz+113kKBUNNIMVv9Ad0iS8diDRSRybbJVt
         /l9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fG0k8sw1OieyV4lUmjMvkJSMRSJdmJBeqiAbvPXKm1g=;
        b=AZC9fo383USz47areW3yyUdSbiSmlzE9ySPGSsHGKFQHplfjiah9Oy7/EL6ZNLwWnb
         K3YmJlkYSY01PtibN9jEZFCD6QZDlNdfdBB/JRNTKE4AkqiFptQ6uLPTm9ncA0NiQcnL
         Y1O/uuAtUo5gMDt47IoJVVzKdbwoPIxuXYtnBQr6paGGXZ0VrpNPjs3CLeCmGqiV8OCs
         MJL3twkFlKrhGL+VkECo8pmeoI67IRrsZdc0fUI2quTYgL62Bd1qkdEc42tQSGuIa8Nc
         7T52HXbAN8HVTi2dDuVfPKhir1pA0MtmOkqUtoqyqy5zr8Ahi5zrbIgcd2cBHBrnHL9i
         RQpQ==
X-Gm-Message-State: AOAM530cYG1lKyyIczGeiAK0bUveVkJhgHmQ/qBSoQaSrd3gOuX2Havr
        PtZNenbs1UVddz/qL8AtCCbg27ZR40ZIq8Tm
X-Google-Smtp-Source: ABdhPJzPyKi4T3Bo9Y6qKKce2cjhxCZHgOuF3VtMMbTjwUR7jDuVR8KD4vSvGRClmab47DuI4qxFUA==
X-Received: by 2002:a17:902:a50f:b029:11a:b033:e158 with SMTP id s15-20020a170902a50fb029011ab033e158mr30198859plq.26.1629749542482;
        Mon, 23 Aug 2021 13:12:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f5sm16688087pfn.134.2021.08.23.13.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 13:12:22 -0700 (PDT)
Message-ID: <61240126.1c69fb81.7db96.1039@mx.google.com>
Date:   Mon, 23 Aug 2021 13:12:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.244-55-g3a7e56eceeeb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 171 runs,
 3 regressions (v4.14.244-55-g3a7e56eceeeb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 171 runs, 3 regressions (v4.14.244-55-g3a7e5=
6eceeeb)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.244-55-g3a7e56eceeeb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.244-55-g3a7e56eceeeb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a7e56eceeeb56ad787224818c0bb0f7add7b757 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6123e0852d969307568e2c89

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-55-g3a7e56eceeeb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-55-g3a7e56eceeeb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6123e0862d969307568e2c9d
        failing since 69 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-23T17:52:46.926981  /lava-4400065/1/../bin/lava-test-case
    2021-08-23T17:52:46.943490  [   18.600681] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-23T17:52:46.943860  /lava-4400065/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6123e0862d969307568e2cb3
        failing since 69 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6123e0862d969307568e2cb4
        failing since 69 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-23T17:52:43.474045  /lava-4400065/1/../bin/lava-test-case
    2021-08-23T17:52:43.479241  [   15.148296] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
