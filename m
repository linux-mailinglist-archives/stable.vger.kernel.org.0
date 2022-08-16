Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF85962F3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 21:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiHPTQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 15:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbiHPTQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 15:16:50 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665477F275
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 12:16:48 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a22so9570297pfg.3
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 12:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=fmC4Kjw33kTSUYpR+Zyg3bHC2W84NazL3uqArj6RDnk=;
        b=GGNxW7vlp/OO/SGGm3FndcrZMLXDss17JtlULOP/uOJyJZ8Wa7zhoeoxnzOiaUcH+5
         6DPlxC5XW4zx1Q/lFuVuLBETKXthPskKKwS/uXy+yHaXFhtm6GRvxFIKqAmQxnnc7+d+
         DVLTRtR58WrATK8p5UsZlQP1b2Qu0nTPgMismZuc6/pC/tNmdmv9ICbKh4XJszgDi4wm
         AepRKWjQ9C3pnF0J28tlUlBHzh9n5PjTGIs3x9MDyBc/TnK8JdGY5d8OjbHBX3Tef7Fr
         Q4bArnf/2FbYowzIbluu5zEBFjWB/wkPPLiCTiF30kqM610cnfZFwMWwyzq+T6rw9uoE
         1YuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=fmC4Kjw33kTSUYpR+Zyg3bHC2W84NazL3uqArj6RDnk=;
        b=4Ogo6jGFXEbeKRkk5xkAzbPJVjF59Jyb5bJ0qsQpEiaSxRYarLIeIEtAosLvFkd//n
         mywsketZUSuxrnO/NP/D5NAkt/iP/eHoy/eGUVPWoXBs5vQ+siv32JHh2G2XEUbhGhar
         Y3d1GCHzxdxEbcYp2aE/7IlLxj7OvTPD+K7bo4Ug4BN8t0zsPMpXGVtMUYrGGs1lH0kf
         9i8Rc1AyFOW4BWrV2PgqBg9unZtymaolllLBTEQA9vKQy1NOzM7ayokzcGSj0ngwAHt9
         pnf3TYbxf/EtmZOph4nTke491g+l81QfFvY9JwnnJ5lKJQpviyQquSXh7J3H6hUSVHj7
         EUTQ==
X-Gm-Message-State: ACgBeo3TAXTQg5A4NY5FgFHTJYEriZJdyAms7M1N0X/2a52QVsYBanCT
        xXiXFz7gbmFa7w5opvp6j0w2gNpLLTt5Le0x
X-Google-Smtp-Source: AA6agR4qVFairD5GcWOSXT4rg7mnRqjcgG9lzYCWAtjaFX0JYYUOjW4dAleSBM6XBwLqNBzNrQgKBw==
X-Received: by 2002:a63:9142:0:b0:422:eb76:1965 with SMTP id l63-20020a639142000000b00422eb761965mr15830454pge.160.1660677407751;
        Tue, 16 Aug 2022 12:16:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17-20020a63dc51000000b0042988a04bfdsm2630004pgj.9.2022.08.16.12.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 12:16:47 -0700 (PDT)
Message-ID: <62fbed1f.630a0220.a58b4.4f75@mx.google.com>
Date:   Tue, 16 Aug 2022 12:16:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17-1094-g906dae830019d
Subject: stable-rc/queue/5.18 baseline: 55 runs,
 1 regressions (v5.18.17-1094-g906dae830019d)
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

stable-rc/queue/5.18 baseline: 55 runs, 1 regressions (v5.18.17-1094-g906da=
e830019d)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.17-1094-g906dae830019d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.17-1094-g906dae830019d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      906dae830019dc331c55f27551ae35d12307aea0 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62fbb503e3787e155635565e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g906dae830019d/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm28=
35-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
1094-g906dae830019d/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm28=
35-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbb503e3787e1556355=
65f
        new failure (last pass: v5.18.16-7-g7fc5e6c7e4db1) =

 =20
