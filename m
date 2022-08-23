Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13CA59ECF4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 21:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiHWT67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 15:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiHWT6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 15:58:36 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B69B88DF2
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 12:09:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g18so14883045pju.0
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 12:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=in7oA+dpv+ChfICYbXCwSbjPVTBiZFbEh4U0vyhctyA=;
        b=jqg9/XhvJu2WlInt5KQ8aU1lo0Cww3eR41KzGwJS1oZQnWXfN40raW/32dyrcew8tL
         JeWhefaz1GdLgD4vHOY1GyEAO3RaZC2IaX18vkRTkGSUrrE5Kc52drahvPNOd6DXl06q
         kcAYhocfmVmDQzgDml9GD+3xcBcGDYWBe2YZfnuZaiVwIWh2U0wnz+V5NfcmX4hEK9P5
         +yX/uKHVNA8k+GON6LrKmqk+scZLAg1gdQHGFHpP8aKnXuRsd0LHeVYkK+o3i9CKpEv/
         ZcRBJG+15NI2NAXMGguWoUClcLLBIZGNkOSIE4ZK0qI+x4KEH6wc8E/Tf1K8ybAiQsoj
         a/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=in7oA+dpv+ChfICYbXCwSbjPVTBiZFbEh4U0vyhctyA=;
        b=3fdaVUqQzDz4Cf2NspQQyxRUf1cf/SB21Fx1ff59GGOtbBS8yHEVWn6KvJpl+WrHPK
         shGsTDNAEqakMa05B62C0bOC3CbuUn7J/LEXTf27GswqQ6FHhX0nZPutVIRNMRaooGBM
         QWHTRW8YrAY7uIKVrvK6YlzUqQhKmDsRpwZ/xpPi5eREPzye0dgCLdts+bD2wgXfSWRX
         XY7F1bUAkjXzwkeJMM06oZEhHO1TgTimKERcrgVLI4Yhc5eQ0GxGcwW5f+W68rK9tvg2
         wfCccxp6Nt+FeOw3sE2zw+DtDEEzKhTFqPdaUVcvZoyOZw7VEk0HxQEwpGRH4A7DymZI
         bX7w==
X-Gm-Message-State: ACgBeo1YUYBCuKnXhoA5U9T7hV3YaKV4lxrorML8CUCxsiQaZ2aLYiUa
        axk/fpqsZWGdx2OYsCIY482wNfYzFJjjrwi1
X-Google-Smtp-Source: AA6agR5M4HqV6XAoLX7Rd/8tXtq0WRwQHN52NJsczGkM+2jdfFFZ3XUeuOJbFj1Tvmp+pBaBPEIdhQ==
X-Received: by 2002:a17:902:f64a:b0:172:7576:2124 with SMTP id m10-20020a170902f64a00b0017275762124mr24656667plg.155.1661281780707;
        Tue, 23 Aug 2022 12:09:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a6-20020aa78e86000000b00535ca2dce54sm11158835pfr.65.2022.08.23.12.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 12:09:37 -0700 (PDT)
Message-ID: <630525f1.a70a0220.20197.5113@mx.google.com>
Date:   Tue, 23 Aug 2022 12:09:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.62-243-g5448111b4eeb
Subject: stable-rc/queue/5.15 baseline: 102 runs,
 1 regressions (v5.15.62-243-g5448111b4eeb)
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

stable-rc/queue/5.15 baseline: 102 runs, 1 regressions (v5.15.62-243-g54481=
11b4eeb)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig         | reg=
ressions
----------------+------+---------------+----------+-------------------+----=
--------
bcm2836-rpi-2-b | arm  | lab-collabora | gcc-10   | bcm2835_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.62-243-g5448111b4eeb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.62-243-g5448111b4eeb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5448111b4eebd82cb37769c49e62e267c6ad1418 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig         | reg=
ressions
----------------+------+---------------+----------+-------------------+----=
--------
bcm2836-rpi-2-b | arm  | lab-collabora | gcc-10   | bcm2835_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/6304f0da00c3225335355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
243-g5448111b4eeb/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm28=
36-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.62-=
243-g5448111b4eeb/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm28=
36-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304f0da00c3225335355=
646
        failing since 0 day (last pass: v5.15.60-673-g7d1e7d167a411, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
