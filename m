Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55535E8D40
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 16:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiIXOSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 10:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiIXOSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 10:18:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836CBEB131
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 07:18:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fs14so2537445pjb.5
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 07:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=tJ8jazV6Ygv2HBkNqXdGjBzXtPRKk2dpL1GMVl//E00=;
        b=bJ0p1x9YMDZ7kCHxiaGSd9ntVLEnKAmzlfGJYA31I9myhLt8YIZsnHObFvwqbOI4Oo
         wMk5lRiZE0gXIjOZL7oXo2+0TMZK6vhkU667eqK6+XspopEis0OpQ5P9Pjezvhl837qW
         5IUbdq936okFXpQuweGc7Oy0yAWuyulgOh21fl62FiiG8bnedcF18A63UXH6DcHtTET+
         SYgEQLpaNLLfQYTtKE5B4HLEdLU9rJNOZgIJL6Qh3rx8XsXSJSllU0YLWYOBDUUXMYmY
         sLZjPLeYUd+6xmk0v7mr6M7kX2ehWhCML1j2yKInMjz3VnFrBfcqLFu20tahrhKgfPQh
         aZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=tJ8jazV6Ygv2HBkNqXdGjBzXtPRKk2dpL1GMVl//E00=;
        b=tIcP50uc3IT8detQ7Dw35y/W/3JjDM7zaOjywLZfH494yY598/15R6Y5/Os9a027jm
         nisFaQSFPpUNmXxmY6TZztJyHs1G+HdTIgAuw9m10jN516K+9f182yppK0UIyYkclCwS
         MyNrGxebi8JChPxi4ZubNkptIVnaC4XkxCzU/asJxa0cJAKpsNmoCTwDvu0b+baREPU6
         ovo1cUeRLHuWT4hX1oVVsO2vQs0ngZzf6KYazDUo7A957BIYbXQp7C59Th/NErOtahmD
         O+dZyvzZJ2+pk2zRLmCnWjOZM+ItVJQv1/G3j93GmgJXz/hPvYXMgy/ryo/lmbtZkaQB
         rgKA==
X-Gm-Message-State: ACrzQf2K7A+elWntyEDVjNjRNJ3yDJhgAA4HtYDujTtGWk1HTK09hxi3
        n0BoW/gkat3qZ/tv1o5r8u8Vr5LAGLsUpiKl/u4=
X-Google-Smtp-Source: AMsMyM5BKmPeeiPAYTCBfETivc1R74VuLo4DUsPBvsoeyorAWORkwZrJnA6DIbUlxsia4SJ9K6O7Qw==
X-Received: by 2002:a17:903:2c9:b0:172:57d5:d6f0 with SMTP id s9-20020a17090302c900b0017257d5d6f0mr13844667plk.61.1664029127833;
        Sat, 24 Sep 2022 07:18:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b00178b717a143sm7696693pli.126.2022.09.24.07.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 07:18:46 -0700 (PDT)
Message-ID: <632f11c6.170a0220.4a8cf.f492@mx.google.com>
Date:   Sat, 24 Sep 2022 07:18:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-69-ge9d119617721
Subject: stable-rc/queue/5.19 baseline: 153 runs,
 3 regressions (v5.19.11-69-ge9d119617721)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 153 runs, 3 regressions (v5.19.11-69-ge9d119=
617721)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig       |=
 regressions
---------------------+-------+---------------+----------+-----------------+=
------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig       |=
 1          =

imx8mn-ddr4-evk      | arm64 | lab-nxp       | gcc-10   | defconfig       |=
 1          =

qemu_mips-malta      | mips  | lab-collabora | gcc-10   | malta_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.11-69-ge9d119617721/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.11-69-ge9d119617721
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e9d119617721686d9cb51d89e49b6fa0e6054163 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig       |=
 regressions
---------------------+-------+---------------+----------+-----------------+=
------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig       |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632edfcdd8aa0a87803556aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-ge9d119617721/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-ge9d119617721/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632edfcdd8aa0a8780355=
6ab
        failing since 1 day (last pass: v5.19.10-36-g00099e2e5131, first fa=
il: v5.19.10-39-g0c9655cc6e1a) =

 =



platform             | arch  | lab           | compiler | defconfig       |=
 regressions
---------------------+-------+---------------+----------+-----------------+=
------------
imx8mn-ddr4-evk      | arm64 | lab-nxp       | gcc-10   | defconfig       |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632ee195112424393a35566c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-ge9d119617721/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-ge9d119617721/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632ee195112424393a355=
66d
        new failure (last pass: v5.19.10-39-g5c88edb51b10) =

 =



platform             | arch  | lab           | compiler | defconfig       |=
 regressions
---------------------+-------+---------------+----------+-----------------+=
------------
qemu_mips-malta      | mips  | lab-collabora | gcc-10   | malta_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632edf85a8bc6a36a935568a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-ge9d119617721/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-ge9d119617721/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632edf85a8bc6a36a9355=
68b
        failing since 0 day (last pass: v5.19.10-39-g0c9655cc6e1a, first fa=
il: v5.19.11-55-g9888f771c3a9) =

 =20
