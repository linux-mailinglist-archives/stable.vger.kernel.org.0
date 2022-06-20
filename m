Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A6D55183F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241713AbiFTMIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242085AbiFTMHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:07:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B2919B
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:07:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k12-20020a17090a404c00b001eaabc1fe5dso10587786pjg.1
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xNSAREcN5WRWHEx7wlMcbZAegARnbcLRPndWSR0ONWA=;
        b=0btuCx2BuO8orsxjumWGL30xDOlm85TwyvEVAhU4wE14xjvAnNPfx2xUj2cda30PIb
         ekWTnjZGT6Sd7XTkXVwKkS+HtkljoAMqcCwxCON/EYsxDAOUelqhXNk1egG3FmArZPjw
         CaKS14H6mOvLKRnlBzXG9YqBIshmHp86c8IAU5QWTQSnoBJuj/OGexQsNDUM534bVPsw
         L0iBSicWAn8aD9zfjn0KXgdZMNxJrZOyVGHSndBa604hRV0YNUvqsFzI5lkXFmWCrqLw
         YrE6w5uEsfp4taP/EGw+IEmsre4jF5hbX0TJJuQs3/eW3LIXhrbMsEJiTL+dk8dMiPXc
         u/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xNSAREcN5WRWHEx7wlMcbZAegARnbcLRPndWSR0ONWA=;
        b=UlBA3dLv1xCFwznTQGEZqgvAlRvaQXRkwZZh0p746f0cYhN+CoGcfime48XS8ajUi5
         Pr/AxBJKDPVIojX/MEzGXTwor8PcVDsLpGtbevV/x8cB0oubl+aynh+qpHY+920+1OeD
         jjTjolVBwp670lc9TRJ8NhdzfVV+OWMLTia0FxhQjQ4lXmz2w+t0iWpaAj8EBH7rqdzl
         bmk8gkSxatRtTHUozjJutzMLgegsiZqRqQ3Ay31qZ9qwJOAiTAZeZKPoN3WsTjFwcNuM
         2mhe/PpubFW0ZTgZT9yBXikWavS02n66CZgYmx3edpByNMlmGAAMJeRQguK2PKjTuanm
         iSnQ==
X-Gm-Message-State: AJIora9Rg6RtPImV9gvg68fk8DU5vk9Me+a3LXFVddGCcQv5YENx8dBe
        JjTBHd5Z57wt+tWJZarZkeosHJoDt4PsaP+RJEQ=
X-Google-Smtp-Source: AGRyM1s+MbBMTxpDOYbBeYs9kiSHDIlYuelTtlJN8vWvv2ZkK7ItXliLyb1Hk9459/t72cZ/KRDoZA==
X-Received: by 2002:a17:902:d488:b0:16a:158e:dd19 with SMTP id c8-20020a170902d48800b0016a158edd19mr9824046plg.105.1655726870414;
        Mon, 20 Jun 2022 05:07:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y40-20020a056a001ca800b00522c5e40574sm1764765pfw.129.2022.06.20.05.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 05:07:50 -0700 (PDT)
Message-ID: <62b06316.1c69fb81.3fcec.25c0@mx.google.com>
Date:   Mon, 20 Jun 2022 05:07:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.15-80-gacb56a38ebc02
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 192 runs,
 2 regressions (v5.17.15-80-gacb56a38ebc02)
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

stable-rc/queue/5.17 baseline: 192 runs, 2 regressions (v5.17.15-80-gacb56a=
38ebc02)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig | 1  =
        =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.15-80-gacb56a38ebc02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.15-80-gacb56a38ebc02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      acb56a38ebc02441b21767a680c4ef09853866ee =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/62b031c34db49c48f9a39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.15-=
80-gacb56a38ebc02/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.15-=
80-gacb56a38ebc02/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b031c34db49c48f9a39=
bda
        failing since 9 days (last pass: v5.17.13-907-ga980fa631e355, first=
 fail: v5.17.13-928-gfe5fcee7b41f8) =

 =



platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/62b037c33181b37bd3a39c04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.15-=
80-gacb56a38ebc02/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.15-=
80-gacb56a38ebc02/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b037c33181b37bd3a39=
c05
        failing since 12 days (last pass: v5.17.13-759-gf64e250b75652, firs=
t fail: v5.17.13-771-g1bf589e90ab9c) =

 =20
