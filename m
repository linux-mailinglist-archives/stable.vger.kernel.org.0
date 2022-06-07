Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC6F53F54A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 06:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbiFGExA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 00:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbiFGEw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 00:52:58 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125EC64D9
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 21:52:58 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c18so6429505pgh.11
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 21:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=toogEyd8axbG3jB8U09Kd+jQ6HQsPNOtx496MZEH6sM=;
        b=BKWbsDc6QqRRDy2fp8cjg/uOf3q7bqya1S8tqdPWnLZ1sEzkz7WV1EpD1nyIb2VPVJ
         97CBf3ExqivajgPzd0FxK5S2K4ONdacsw+8dl7Ib61SgSM2YuqJODgF3dBVrLbqyireT
         7FfNji6mZzjYkVfhB2L79s6VYNQW0ibZclqhY9AT3iqarB+H2px3OB0FHAziQCISlthL
         iUzPAQRmMrU9hri/GLCng5HUC5IL2d9VeXRG7AwuaNCYCdmAKSFCQKyPB0Oism2BqwNX
         L+sv5ODV3Y3hvdjdjY3c392AnGXbCQdLSxZSQXjfpXebrw9SE5uHF4tilSNcqQVxr9c8
         b6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=toogEyd8axbG3jB8U09Kd+jQ6HQsPNOtx496MZEH6sM=;
        b=EXNEIVHOSCNOMjKbNmD4KPJvUCMML6XYzyVAaNRiT4WW0OoLceKn6nS6bgE1/VbjbE
         iRWvxBvJ3qLe4MWppliAd0LIV5Wp/xychogaUjhiTefnLX3V11wAc/mP4bXDltl4tAbU
         hHo2c5MoMhIEy2iuykseGfKBHh6L6MDQiFkXR+A6R0XL5l+m5ku3R7Dt3br24tTQCvVQ
         8gJaGxRJP97Gnfk1UcACf4PxIq5GF4LUx8kHLEN9L6hghG9zLRUfPzro3DsoFfHd/POy
         GXAxTGtM03c116TvivF8GE66OsQMWBG7wchEugfBlpXNd26a8x0RRSham3100gOaN433
         yM9A==
X-Gm-Message-State: AOAM530fh8psoWMA8wRikEird20lIwL56DkNTtgZ6Dak5FekmzFsjB6R
        BvxbwMNTreug/SAoH/722r8bbrexlhZQ6MIi
X-Google-Smtp-Source: ABdhPJxvOMUp2JbobTOdCen6AseIq9SEYcDyguKN1wW0zqwjTD28Jlod2++ac7lJr0uAbGwTJclWrw==
X-Received: by 2002:a63:7d4a:0:b0:398:dad:6963 with SMTP id m10-20020a637d4a000000b003980dad6963mr23731038pgn.329.1654577577415;
        Mon, 06 Jun 2022 21:52:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8-20020aa78608000000b0051b9d27091bsm11591633pfn.76.2022.06.06.21.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 21:52:57 -0700 (PDT)
Message-ID: <629ed9a9.1c69fb81.8d94c.ab33@mx.google.com>
Date:   Mon, 06 Jun 2022 21:52:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.246-186-g8037ef114274e
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 33 runs,
 1 regressions (v4.19.246-186-g8037ef114274e)
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

stable-rc/queue/4.19 baseline: 33 runs, 1 regressions (v4.19.246-186-g8037e=
f114274e)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.246-186-g8037ef114274e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.246-186-g8037ef114274e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8037ef114274e125cbad4e7a4994c22f169beb20 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/629ec5cd71eb1811f9a39bff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-186-g8037ef114274e/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.246=
-186-g8037ef114274e/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629ec5cd71eb1811f9a39=
c00
        failing since 13 days (last pass: v4.19.243-32-ge0f9fe919ec9e, firs=
t fail: v4.19.244-44-g279b88d9359be) =

 =20
