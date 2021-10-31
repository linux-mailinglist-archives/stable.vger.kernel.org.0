Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C3B440C76
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 03:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhJaCJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 22:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbhJaCJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 22:09:27 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD3CC061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 19:06:56 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id n23so3133781pgh.8
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 19:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LvNViKsnH7ZBle068wxNPAuxwmXwe8f3DcplpF8NwXo=;
        b=A9pjmJs1llBWUbZF0N1ahphbjuT7oOFatXPKNssCpSE5V/Z5E0Va9mehxSe7w89gW7
         JJlt+7sl6dhgyMD267NdKATnxGFT4Fv8kjkK3ZrQmzenx90mp/1nKGRCR/Hz6x3baPli
         Cy0n1X5tykfPaZlWHAkZKUftIrlyxB8RDlGjqfXnkmYoeeZ/OCAhmbchDHj/HSgql9S6
         C95jpXZz7+0Cps1cR2MMlszvR2yeufJQmcK/TSTWexSPOjiHUrMAQf8mBXEVJ/w3nKRa
         QB7/b8iAtz17SEzBL3qunDlUZYg/4yMsf1jQ1pD7qbwxwtrrKwu25YdHlA66AJzVmJKD
         bNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LvNViKsnH7ZBle068wxNPAuxwmXwe8f3DcplpF8NwXo=;
        b=MAg5CfRfO+mKQR6XsAOonIff0VEINyJwY90h1WeHsPA+WapRsZGLNfghT29WzLdIV0
         T6/YvAayN5qsvL6oulgPVEFTgDo03bytoSLTFPdlF7IoeEm9bzKyfUJq0gnzliednvoi
         InpPwDMMpBt2c+PQr9kdtiH+7rT50+MAVNwe2/yJ8VIWXG/Iix25AtiVu5CZfbFdwL5k
         AfDFp3FDDesHqA147CF90qUgcqDyhvHoMk72wJMAd3xAOVEdHDgMkTa1mo6ewBcmcbNa
         wskfpTaPhcr6J41IOjWCGGOaOWJ826HYSW36H8BMvhEdcGUo9Wvz7yjCuarKUTVtc5rA
         O5gQ==
X-Gm-Message-State: AOAM531QWRTn58jXu4my9Vq9q6dHIiayWI+0PCH24oln/sfcmLuCZo6O
        CAVdYXBY3mJ5Bsxe271bq83cHXK1tX4QinlZ
X-Google-Smtp-Source: ABdhPJyA/dNYOqdNroZlBxi5FbsogNvM/mUBk4WzkEYVSrVqGUSHr3wP13hj6qreAdx2SSoo/8uKIA==
X-Received: by 2002:a63:6fc9:: with SMTP id k192mr15138256pgc.49.1635646014534;
        Sat, 30 Oct 2021 19:06:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1sm7541176pfu.81.2021.10.30.19.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 19:06:54 -0700 (PDT)
Message-ID: <617dfa3e.1c69fb81.129ad.281a@mx.google.com>
Date:   Sat, 30 Oct 2021 19:06:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.76-72-gb9655403c7a0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 40 runs,
 1 regressions (v5.10.76-72-gb9655403c7a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 40 runs, 1 regressions (v5.10.76-72-gb965540=
3c7a0)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.76-72-gb9655403c7a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.76-72-gb9655403c7a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9655403c7a0aa2814a259ac226acd59a4f8de47 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/617dca322be9f8377a335951

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.76-=
72-gb9655403c7a0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.76-=
72-gb9655403c7a0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617dca322be9f8377a335=
952
        new failure (last pass: v5.10.76-65-gb93d8a23f6d3) =

 =20
