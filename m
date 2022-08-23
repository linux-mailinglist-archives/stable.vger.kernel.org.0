Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B854359CE15
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 03:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239212AbiHWBuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 21:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiHWBt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 21:49:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1415A3CF
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 18:49:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso15773707pjk.0
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 18:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=lf+r5zpafvj6pskfgLNdrU7pzzM5ITQZx+rFn87QtDA=;
        b=bfQd4ROuzCNQu9/mKg8fPPlvr3pgw6spxCVNrGRuHK9PCtqAGV+H8IcH/WWX7i/txv
         0q+PjE1WTx52wfdeLhGkToh3aCCF/jCyHSLakofJhael0NpRkZ6HpJ5zLYsgQdVyqRK7
         PgLoJXU7CwRfCnCeRD7OKC21evCaVNtOYtouF+mwaNAMTJkBHOuS9vLsMA/Ad4WITVTq
         Rkjmd12sf/1TTZPfgI8IpgHVRW7d9PV+LDP60zagJA4Z595dMVyIXxcEN4SIcdvfV3aJ
         fZDwnL8CPXV7N5YDW6gbyiqobjq2CHFsaKLfCBUaLAgQpOreB3NkPzY6N/LqL+gK7fO4
         O9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=lf+r5zpafvj6pskfgLNdrU7pzzM5ITQZx+rFn87QtDA=;
        b=qqeUp4t7CY6v/ImyIGFxGDo0xkcVHw2wmMJ7gHlVUnomWuxtGE8A6qv1oXPS8KZv6i
         LhhBjZ3h+k++ZUqUaLCtKEHBWVqtF6r6kGAa8E6Lnujgs3XdGSxl612LQ3fDrOOjSFWh
         3CtoAGvKM4rhIWDTCuhb0o2b4sEc0lXqtkXo/8h6HxYRgjz0bhZ47M6qFm6l3R9OiF2k
         wJFZUaji60WNpZ4aeC/EZTkp0ujQZ10H/uMAnbDz4Js5FcczgG6/yl+PnkcqGu9+DCdg
         urb52CaFBmfCMBpZd0jBYpbe4/tdjGX1E/ydkhCCnLk9cB/MX9d7j09FPZbDkUR6N51W
         WM8A==
X-Gm-Message-State: ACgBeo0gj/PjITd8CgN0737EhLBt+PHZKZJ1rhEndbQGPSyMEXb9L5Ib
        +pOLWx+PyyJm9ntemx0ZCVZ2JUY16tfwPi4K
X-Google-Smtp-Source: AA6agR6aw4N/apIwC4qYR8Hfb7eOCvS1/ZjXXj9E5NIQHt2uZr98uWP2qlT4c3AKH3fmkE5dpNTCMA==
X-Received: by 2002:a17:90b:4b81:b0:1fa:ef82:c512 with SMTP id lr1-20020a17090b4b8100b001faef82c512mr1076447pjb.78.1661219398556;
        Mon, 22 Aug 2022 18:49:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l9-20020a170902f68900b0017294d80f11sm9057153plg.91.2022.08.22.18.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 18:49:58 -0700 (PDT)
Message-ID: <63043246.170a0220.a115d.077c@mx.google.com>
Date:   Mon, 22 Aug 2022 18:49:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.62
Subject: stable/linux-5.15.y baseline: 147 runs, 2 regressions (v5.15.62)
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

stable/linux-5.15.y baseline: 147 runs, 2 regressions (v5.15.62)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
bcm2836-rpi-2-b  | arm   | lab-collabora | gcc-10   | bcm2835_defconfig    =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.62/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a0a7e0b2b8b22901945ea2aef1b65871d718accf =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
bcm2836-rpi-2-b  | arm   | lab-collabora | gcc-10   | bcm2835_defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/630411b398c827b1ee35568b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.62/a=
rm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.62/a=
rm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630411b398c827b1ee355=
68c
        new failure (last pass: v5.15.60) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63040251265f7ede3c355642

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.62/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.62/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63040252265f7ede3c355668
        failing since 166 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-08-22T22:24:44.578575  /lava-7090956/1/../bin/lava-test-case   =

 =20
