Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B5E418509
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 00:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhIYWv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 18:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhIYWv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 18:51:27 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62922C061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 15:49:52 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y8so12134360pfa.7
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 15:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PhnBpY2vSXpH6F6fAN7wQOx5u0lmvk9xJ2S8zJWf6tw=;
        b=l467J9oNyS5YbSJdl7KFo1RAqo3xxI29TLlipS437iZgBIG5q4qPykBwSJQPp9H6pS
         pEy/umN1deCBEcnonNU/nxXyWm7MTsM/uApPef/uFXv1kWfIJMh9hDktzf/cMo8+Ku6F
         sWzRCqFf3FoBtgtXKCOZbI+3waBejWZirGRFGs/CrIimC6qAH+3PbiRyLQNVAcBh9Q6R
         5ztodNpSYPz6hAdLt2bAssphuw4DCZngxlncSNqMztplC3cMyKKR5dOqfVFXJG7E8/9X
         pdCBOwWTxo1DbH3XBflkXU6N4+YyAvRGG/Kx3QVNrY0fSmLX4OZ6LgB2ij7YgEpblg9t
         2BVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PhnBpY2vSXpH6F6fAN7wQOx5u0lmvk9xJ2S8zJWf6tw=;
        b=zU+PG2ILeT4ZZHG3bpb+WiiprCxBcJX8ovFdy7xWFIoyznviSxHFuarZJu+GhDuCVQ
         S77Pv1POEwu1tKyGFKXDwxwc+szIdIMFxRBsxsinvuwKYUVMb8iOTk1RZI7Nb6AWgdoV
         CWEoM7yZcIusO4pX4jy9nICKaEkIK1iftRf56HyKjiC8vsAai3zjHIffsfoakCxxHJdc
         19r9s9FRhkcm9cL0lIUtPmb459Al4EtkKBJR0gugLeF92/IlCrFbJTa7akufaYTGc2ST
         poXjRb2maaM1/8nZnWPfyEZHM27YbepHSPdKMyzhC8ZxVbnab7NR8ZW4iKfXAWv0a8ZC
         9hig==
X-Gm-Message-State: AOAM530CioFLiVXRjg1R2uYB0FyFpGI/rnwA6dw9YlrxLlulG71eqZYj
        EsJxhueILcauvYWlrYwspjcgjIV9m6RX+vvX
X-Google-Smtp-Source: ABdhPJwGZCB5klezYa6dfyl8GRVK011ebNjkgPPRZkhW5bLlhKjEdikIYjbQNV4+I5T/1SoxSNORiQ==
X-Received: by 2002:a05:6a00:22d5:b0:440:3750:f5f4 with SMTP id f21-20020a056a0022d500b004403750f5f4mr16256859pfj.64.1632610191693;
        Sat, 25 Sep 2021 15:49:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s38sm12389848pfw.209.2021.09.25.15.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 15:49:51 -0700 (PDT)
Message-ID: <614fa78f.1c69fb81.44263.6e34@mx.google.com>
Date:   Sat, 25 Sep 2021 15:49:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.68-65-gab0c89ed74e1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 104 runs,
 3 regressions (v5.10.68-65-gab0c89ed74e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 104 runs, 3 regressions (v5.10.68-65-gab0c=
89ed74e1)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.68-65-gab0c89ed74e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.68-65-gab0c89ed74e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab0c89ed74e1e05eac9f5d704db32feee0ab1fd8 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/614f722cd877bf421c99a311

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
8-65-gab0c89ed74e1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
8-65-gab0c89ed74e1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614f722dd877bf421c99a325
        failing since 102 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-09-25T19:01:57.978576  /lava-4583608/1/../bin/lava-test-case
    2021-09-25T19:01:57.995436  <8>[   13.413677] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614f722dd877bf421c99a33d
        failing since 102 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-09-25T19:01:56.552133  /lava-4583608/1/../bin/lava-test-case
    2021-09-25T19:01:56.570514  <8>[   11.987708] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-25T19:01:56.570778  /lava-4583608/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614f722dd877bf421c99a33e
        failing since 102 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-09-25T19:01:55.533250  /lava-4583608/1/../bin/lava-test-case
    2021-09-25T19:01:55.539827  <8>[   10.967987] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
