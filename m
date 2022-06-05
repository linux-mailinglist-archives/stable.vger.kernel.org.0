Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4D153DD31
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242314AbiFEQvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 12:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351323AbiFEQvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 12:51:37 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247214EA09
        for <stable@vger.kernel.org>; Sun,  5 Jun 2022 09:51:36 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 7so10332551pga.12
        for <stable@vger.kernel.org>; Sun, 05 Jun 2022 09:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tDMnBZFm7q0IyGv9qkdCupe0jQYsSjv22tRfe7OH5MI=;
        b=B3n/VaG1hJp85cXmR+m9/hh4hL9jy98bPuOYjd3V827VSBQ5qK5uR5AnK1dBopdUlP
         ZYwaj8Ab1S7JrSK+oNbjoO6fj7lnvFXZ4T4hpzszard3v4Y7qcenAhfv9a36YHr6j504
         qg6PwKPAVADk2IhnxrlLT+wka74+fWxFvtK4oDTkTfes3tc3Scd5Qm9hNKxgJOHXa65H
         /UTc6Y16UPZvUIMfzk1/Zipr08GHRAl031c+jfbISkgxB/ia5VXsoHD/m7cjGt6C2kpc
         /ld++upTN8nTerbYn/+JW+LCMFb71Jch0Amoje/77wxwrg6PyEC2tHn+ruzUoCDZlA1f
         PUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tDMnBZFm7q0IyGv9qkdCupe0jQYsSjv22tRfe7OH5MI=;
        b=eyt2EfPH0x766gZhYZupOXhSmuidzXjJRlcZH2DxTLQL6mvB1OACUXLBufu7pEtn/S
         fLMhMAXm8n0bPN9+DsLV/9TrL/gxKgdckMUYRBe0PkXI5xeP5PoYl2LcO9qUYCZ1RYaM
         uhWsHr5RUk/jT5IdWWhIpIomenelo7ViAQOFIyGIdHMsZ2iFHB/6I0xOvGy0LACIJ0tI
         02G7mLDbQg5gF89ySgEwMT3rH4GErtslLU6nsdn9wo0Opu5/v/f7U651zymNpeRRo32F
         Q4aha35CpWJRM+/1trE52DkGHiIQ76wl0NDBL4zeFx4Ma6ZeC24imao3xnr98i0wSRSY
         4KNw==
X-Gm-Message-State: AOAM533hykKRZYtIJEeedshZAeYx3hCTa8mgr9ksuZuzBnPlwSEC7x9v
        3GQ2MxsxI3+RAep+h3SAemYtboSwi7CK/FrZ
X-Google-Smtp-Source: ABdhPJzzwjXVj62d03nfW5wvyxObhWD/zMpSiHCbp8+Kvnb7/hBjdm6B8xNsVKqT1/J5hHxGiv3zig==
X-Received: by 2002:a62:7b4c:0:b0:51b:9c0e:a03d with SMTP id w73-20020a627b4c000000b0051b9c0ea03dmr20250354pfc.54.1654447895485;
        Sun, 05 Jun 2022 09:51:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w62-20020a626241000000b00518119900e9sm9098174pfb.53.2022.06.05.09.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 09:51:34 -0700 (PDT)
Message-ID: <629cdf16.1c69fb81.1e5df.4640@mx.google.com>
Date:   Sun, 05 Jun 2022 09:51:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43-212-g8b5c4320ffac2
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 86 runs,
 2 regressions (v5.15.43-212-g8b5c4320ffac2)
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

stable-rc/queue/5.15 baseline: 86 runs, 2 regressions (v5.15.43-212-g8b5c43=
20ffac2)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.43-212-g8b5c4320ffac2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.43-212-g8b5c4320ffac2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8b5c4320ffac2786980f7a64a3c66c2eaff9d00d =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/629ca87a7997de8e24a39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
212-g8b5c4320ffac2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
212-g8b5c4320ffac2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629ca87a7997de8e24a39=
be5
        failing since 12 days (last pass: v5.15.40-98-g6e388a6f5046, first =
fail: v5.15.41-132-gede7034a09d1) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/629cb94ce8008bef0aa39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
212-g8b5c4320ffac2/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
212-g8b5c4320ffac2/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629cb94ce8008bef0aa39=
bce
        failing since 8 days (last pass: v5.15.43-3-ga16def6cd632, first fa=
il: v5.15.43-144-g375b1504fe930) =

 =20
