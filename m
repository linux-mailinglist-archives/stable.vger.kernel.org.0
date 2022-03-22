Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5699B4E3539
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 01:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiCVAHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 20:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiCVAHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 20:07:06 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3D54D24C
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 17:04:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so708663pjf.1
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 17:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Pwg38LoxVmZh+DN7PSzNPLLsmznQbVoXGO604xa4HKg=;
        b=NGml5kthEocDFMHe1qZ6b0Sf2vj+9MuPtoJLGeQaSNBln3Xfa5y+3RdoeEUi8WPUmT
         ny0E7EgGzOMw9Xti8YaZLaLayCA1gsCB46fO8KYYQsCbawLvPBYga2Tp66p2TcVjG99L
         aTCKk7gy25/VYALm9iIT+10UMQWeqLrQOmQOpwVDVXRXvKhXCtr6lu9Ey71gLCbt2tlK
         GtSKsVVZcybT/HpK74xLOFvyg4TjxiKMQA9xo4ExrpDu0yGcJrv/sEVpRf2Skf6l14cS
         o9fgpehG0SOZZJb1NdTgKXYXZ9c7NOQO21ZdkpGd/C+Otdcd00XdJr6HmEe/kGuTT7Jl
         JJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Pwg38LoxVmZh+DN7PSzNPLLsmznQbVoXGO604xa4HKg=;
        b=LnWAm6yJOYSdPINrbvekGB6nW57NOeIn0MzMDTBXf9gZTE/fFjIKgD+YosBwN5aTi/
         mvGeRIuACXPhPQxZLDqEbVdf1WQzVz7j16QY4uEqmsS7srd8lgEfcT3Xy770HRCfmzmt
         as9EsgXf5rZVy8W+uyky4Gi5K2wbWEsQV+a5xiVx6ZlFp73p5QaWvbHybX3seWZFoWsv
         RUTnHtOhQkQ7K1OY+A3z/VXkLJ4zRinE0ItPir+ROwOQTEzsoLYlJ5QAuk+LRSYXYgpW
         5AGo83T33xIHBbqnEXP4IxGtOZuSZ1KaWkBMA9srEgp+ft2/H4h3NudgkHlDS8Psa3Cx
         4wfw==
X-Gm-Message-State: AOAM530HPD+kE1v/YvhkpbJEH2566WIhIaWD0MMgELtw4BczXbibEm0P
        D+7Cbc5tIp8/qc6a3zPwkYNXxZSm+cG25wpbx7U=
X-Google-Smtp-Source: ABdhPJwvWDFT67wSkS/H4Q4MA83gXahXNkigCw8lrzGNoGxPa5aF/2cea4Bbx8peVqB6upmE2kHhSA==
X-Received: by 2002:a17:902:7784:b0:151:a83a:5402 with SMTP id o4-20020a170902778400b00151a83a5402mr15355455pll.21.1647907344378;
        Mon, 21 Mar 2022 17:02:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f31-20020a631f1f000000b003742e45f7d7sm15691254pgf.32.2022.03.21.17.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 17:02:24 -0700 (PDT)
Message-ID: <62391210.1c69fb81.328e1.b042@mx.google.com>
Date:   Mon, 21 Mar 2022 17:02:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.235-58-ga78343b23cae
Subject: stable-rc/linux-4.19.y baseline: 53 runs,
 1 regressions (v4.19.235-58-ga78343b23cae)
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

stable-rc/linux-4.19.y baseline: 53 runs, 1 regressions (v4.19.235-58-ga783=
43b23cae)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.235-58-ga78343b23cae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.235-58-ga78343b23cae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a78343b23caede1f7ef885dce0e97225fb3f19e0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6238e681e85d0bd17b2172c0

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
35-58-ga78343b23cae/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
35-58-ga78343b23cae/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6238e681e85d0bd17b2172e2
        failing since 15 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-03-21T20:56:26.823254  <8>[   35.951548] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-21T20:56:27.835311  /lava-5916817/1/../bin/lava-test-case
    2022-03-21T20:56:27.843752  <8>[   36.972486] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
