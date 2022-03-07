Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DDA4D0B90
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 23:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiCGW7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 17:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343885AbiCGW7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 17:59:11 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403D3205FC
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 14:58:16 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o23so14749964pgk.13
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 14:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9dbJI0vjzQOwxOTGVvsQ+YFvjLXFEG5GG9YW/UWfp6Q=;
        b=No+pe/HvqvbX4E78lAY3qusCoaWCnQXmAF9py+zqPzbVHU2946ruwv1dRTHQ9wFruA
         VvA/HzfVArkmVsDHwkIKJrLKQGyrDzrZk00w8YsHc1UH3PZF6udBeZhMy6y/L1H/+Ylp
         S8mV79xmR3d9u9kqHxhDyMsHJHQ8PsK1cEG+1NEdYNNtiobgF8gmRaF0dIls6P7pjSrU
         0Qe9fO7WBU/lRJcAPB+aoc+7bIAFgQaV8o6lNk7lDi0CJ8bY0XTlcNQ4LxOXy9vDF+M2
         V19KrLQI0rQGMQRgKvS5qEmFA3ahcIT8IfoultHaaRnsEs3RegrRKAl/Djo4X0N5U1bW
         D46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9dbJI0vjzQOwxOTGVvsQ+YFvjLXFEG5GG9YW/UWfp6Q=;
        b=up2CnWeBRWs8508zYCkFTnoLZ536bPiDbzrBWbjt9IwZQMno6enJHFVFDUAswresu1
         eX9hmnrXTxNpeJPoKW+X7wiC9br09ls0ez2VgsKKKCmab+4VTpfIeIxn16ECw+Fug5LU
         FMKsyfMDR5FiDw/5nAlbYtj6A+YiiQxTc0aR6lHAuInENphvmtkrm5+pHlktOqpUDuB1
         YGEKtmQN6bwBcEA0pbjFgJ3uYUhHcxzkbdBfDkZCRzMZsUyRQYTn0BXpHBTqa1sQR2/d
         S178jE7SMQwloA/1BZPVRqFSnhnN+P6izjzU+IJqdcA05juh8RRPdML2O9aRQl4gl6G5
         RpPA==
X-Gm-Message-State: AOAM532q9ztJcSvgDqCYfSMvGAYwIBsPTdAxLTWVVyGZ304/4wpQdAGe
        LL9qvnVxBOp0bucr9PGBVVhNrJfutcXvtRzZaAs=
X-Google-Smtp-Source: ABdhPJwTl+2q3sd3x1GEosdm+1/xRjUdhZVhkIgiqLwnTgeFZHlHSfRJ8Q6lcJqHtffC7zZeKXTp7g==
X-Received: by 2002:a62:1d91:0:b0:4f6:f558:6d15 with SMTP id d139-20020a621d91000000b004f6f5586d15mr8629361pfd.79.1646693895566;
        Mon, 07 Mar 2022 14:58:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3-20020a056a00244300b004bc9397d3d0sm17567577pfj.103.2022.03.07.14.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:58:15 -0800 (PST)
Message-ID: <62268e07.1c69fb81.1591d.cdd7@mx.google.com>
Date:   Mon, 07 Mar 2022 14:58:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.269-43-ga6feea1fde8c
Subject: stable-rc/queue/4.14 baseline: 46 runs,
 1 regressions (v4.14.269-43-ga6feea1fde8c)
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

stable-rc/queue/4.14 baseline: 46 runs, 1 regressions (v4.14.269-43-ga6feea=
1fde8c)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.269-43-ga6feea1fde8c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.269-43-ga6feea1fde8c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6feea1fde8cd760db97e5654f1679a8791fd302 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/622657ac0108758325c62a29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-43-ga6feea1fde8c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-43-ga6feea1fde8c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622657ac0108758325c62=
a2a
        failing since 22 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
