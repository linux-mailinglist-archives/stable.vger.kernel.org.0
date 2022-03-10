Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6CE4D3E9D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 02:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiCJBQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 20:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiCJBQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 20:16:17 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE69122228
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 17:15:18 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id bx5so3846863pjb.3
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 17:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FT5eDoWbtsSnOgm+oe7j9fiF4A7SG2OuBwE3WQPQo3w=;
        b=yGz7jeq9HpGYUr1X7Z3eO/CPKm2ZcJsorQGyIhISAKKmQRh1OIrDq8voVWvTavtlz9
         d8Z1H8GBx9YD69D4IzBh82uTvEGtSHVlimt1QEtxnpf895AdxGdFdSMhFQWsjou+Rmlv
         VtgvHq/3AG121gDfblGsH5DPbMrloaK7miYN/bUSeWvLGHtRxLaHjofJCUmBzoi49i62
         8bfWUCc7ubmudMHc5QDCOEYaiPPcarJdF+6mXfxftl4E0x9iDxu5w5ZtPhgvrgmP/kbR
         sRt/by2+tnR0D0lW5QLTYjJOF2+MvxhlDauiFG5z3M9zJmlzRdYw1bN6xoEZyYdzLqEO
         NnoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FT5eDoWbtsSnOgm+oe7j9fiF4A7SG2OuBwE3WQPQo3w=;
        b=grcQCeZmuwcHHVWfwjkvmCWFguLZxCYn7R6slFCXbzpg5SLP2tz4XYudt0Jgz5tgYS
         INqP/Y+sCix7jExtRltcidqvuev440NfPR9lLC8OseId5eUPncNKuUgrbJ8m4jgTJG8R
         Xzi6hDH1M38qreXLA5TtQs98B+uGb83hY+4BSdruF+xmIUKkk842KqAGh6GcebloRAj3
         lmaQJUyyAmbKO6Y33vySb6yv1oOpaLrKf2SGG/nCH5g0Y1JXCdIhrX/0gjJxY7905d8P
         XfOJdLpiDjm8dM+KXupeJowE5Nr04U5FaV7uhS2Ty+sb3PkEZb5pZdTOTEN4+uMkOla3
         nBgw==
X-Gm-Message-State: AOAM533gNuGRAuI3f0e7srad73nS4CEDp9dwiWo2cY3uMHvagjxW8Efs
        kZ63b3FMHFCEsmGjue1wSxHEslYVRsq2XXTIC7w=
X-Google-Smtp-Source: ABdhPJyND6S99zCctnPh3XsSuLF+hnik6Ud1rQQSf8fww4ZcJL6F4qbLJlQIfENMrjRVPFMJeGOtRA==
X-Received: by 2002:a17:902:ec8f:b0:152:939:ac45 with SMTP id x15-20020a170902ec8f00b001520939ac45mr2379265plg.61.1646874917468;
        Wed, 09 Mar 2022 17:15:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15-20020a056a00188f00b004f7675962d5sm1428696pfh.175.2022.03.09.17.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 17:15:17 -0800 (PST)
Message-ID: <62295125.1c69fb81.3e428.5506@mx.google.com>
Date:   Wed, 09 Mar 2022 17:15:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.233-18-gda2f44e1232d
Subject: stable-rc/queue/4.19 baseline: 60 runs,
 2 regressions (v4.19.233-18-gda2f44e1232d)
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

stable-rc/queue/4.19 baseline: 60 runs, 2 regressions (v4.19.233-18-gda2f44=
e1232d)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.233-18-gda2f44e1232d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.233-18-gda2f44e1232d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da2f44e1232df0b91f7232797173d144e8cc9573 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62291ff35fe96f8870c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-18-gda2f44e1232d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-18-gda2f44e1232d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62291ff35fe96f8870c62=
969
        new failure (last pass: v4.19.233-19-geedd1042e0c2) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6229231218c0f658d5c6298a

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-18-gda2f44e1232d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-18-gda2f44e1232d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6229231218c0f658d5c629b0
        failing since 3 days (last pass: v4.19.232-31-g5cf846953aa2, first =
fail: v4.19.232-44-gfd65e02206f4)

    2022-03-09T21:58:35.264028  /lava-5848385/1/../bin/lava-test-case   =

 =20
