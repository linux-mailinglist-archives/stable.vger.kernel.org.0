Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1454370FEE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 01:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhEBXss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 19:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhEBXsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 May 2021 19:48:47 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962BBC06174A
        for <stable@vger.kernel.org>; Sun,  2 May 2021 16:47:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id y30so2481206pgl.7
        for <stable@vger.kernel.org>; Sun, 02 May 2021 16:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RbCUc5+mGdRepY1jRN2HFaNIbutxZXNMTE48DQhOdTQ=;
        b=Pn0YKJIS6xzIUQ5nY99uoVxiBMNf/NS3fm+9k0vSjR21EN9Pua5Vj5TItr0TayOgDr
         4l5auSvmkl3h3NY6tnda2IA/6I537EEbO/sm6ocDlIySCgJOypqOLiVKrVskRvINsXF6
         7hOth7J2NOJcFH6P8cFqGXMoBLZVJa2dwM54eZPAkVQnXO2re4elfhrkfH45hTEnd4vX
         AY8PiVnv3juHdSwDB9hOnIl1MoUjsBnw9L+iFzbO07YpdOXqzlvtiljSTtWXdMW3Me5V
         E56uB95LWjeVVSBR9LiWT3Dop8AY/geQPhmCPF8pZEpoUDs94feUQkwAwjAomt/LFLmD
         jvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RbCUc5+mGdRepY1jRN2HFaNIbutxZXNMTE48DQhOdTQ=;
        b=RSf3pSLh9cUhqBs4dmNUhkXUyI9EgwnFsjAnTGdRQVjGYbdTkUKue/rm9+yZDdaTSm
         hBn7+xoMGuthO0efKa/gb9xmo8nxZrvlBH/ZnOM4ynQGqCN1OFU8lbrs4YCDzm66Lmmz
         G2eMMu0+M464TprvoELIeXgtFS/AZQEmq4b301iBBlPczoSwCFca86/hCc65MtLM4SqJ
         FBklSh6OD21/EV//AkDYWLKvTQLLC5PN+Cc41ZTpAZnw60sSygXAxObd9M3nP2nsV9Lb
         zBzLX2uTJWHwTBWk9nPJNIb7mxAFSkIlSKBs+jNgiQgHWP+Abih8xebvYd5NGywCFvU8
         auBA==
X-Gm-Message-State: AOAM531yHBjcmv2B0Fxto9oqFBeVchChjJuEggXmhY6n7zFq5eFOwwwE
        fS6DHxvmUwiDjqSZsh2GrmUHq7dgnCK9myug
X-Google-Smtp-Source: ABdhPJyspuaZz6ezuAMQPixh7ycOW2O/Cx+XYUuMLBGKJDfkhXWLiLCMBtLnA6g9hpB8M8ERyDGPwg==
X-Received: by 2002:a63:ff45:: with SMTP id s5mr7113391pgk.274.1619999275051;
        Sun, 02 May 2021 16:47:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k10sm7103746pff.140.2021.05.02.16.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:47:54 -0700 (PDT)
Message-ID: <608f3a2a.1c69fb81.3d61b.3862@mx.google.com>
Date:   Sun, 02 May 2021 16:47:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.33-6-g4ac359ce4938f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 173 runs,
 1 regressions (v5.10.33-6-g4ac359ce4938f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 173 runs, 1 regressions (v5.10.33-6-g4ac359c=
e4938f)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.33-6-g4ac359ce4938f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.33-6-g4ac359ce4938f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ac359ce4938fa0a3d265b6035bbe27be2ebe438 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/608f043dbbedd3c6da9b77b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.33-=
6-g4ac359ce4938f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.33-=
6-g4ac359ce4938f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608f043dbbedd3c6da9b7=
7b8
        failing since 2 days (last pass: v5.10.33-1-gab3a0ce18e9e0, first f=
ail: v5.10.33-2-g5543059a29e2) =

 =20
