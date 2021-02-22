Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2C7321444
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 11:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhBVKj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 05:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhBVKjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 05:39:54 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089B9C061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 02:39:14 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id p21so9948003pgl.12
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 02:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2bKiRJ8jf7Zgig2EZVbOCpe7ewG5eLxz9WG9frLP6LY=;
        b=h2c94LtW32D4xkQTSqXqsj7NkGd+mowck37mJngKKEf3zeYSEKzQ7w8y0Y3KZM0ISi
         qZBlV5faV8M1Qpwqg2lLMyV9+mJe6VOaCATMExY5LjZV8IoytQnWNXBtJFgdGXLZYbgJ
         VrIAVh4M8bWyGfkjqgW5HDYZh68QMnP7+Da6RlGRL2Rjz10f8/o9os5A+n08EzJFchsd
         +z8z8X1iShxJX0y9Vn/9gynGQ14A1azta6ocsNAUVt+kckYipmqBx3NevFaI716wAJ8Q
         WwA/nHr1GbA+8Xkbp/nWHBt+cXvPtNq1GXsJLGMhl+UBLo0boxqm8ofhcx+jT7uslVnT
         XfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2bKiRJ8jf7Zgig2EZVbOCpe7ewG5eLxz9WG9frLP6LY=;
        b=EZcP2tLX5KvjQdhv4FruI/Qfym6ceNR/gvnUBETSmn+PfrgaogoqUSyAawWtaMyJ2d
         FAJ2L8m/MlTcFiF+jUWJk/ImBfJ36VRTcsOaSQ+u+k3vM/K0HmZ2h3LarqtAp4zuPTHG
         CO0ddlumyFI5DWmPlS75NyvJzAzJX1FHPtUJ3RIrXIuJ/10ZuWK+pkWO9MQ6JMcoaBwf
         ured5lPf/v3rKzw8cTT3mnXg6ktKhbJekeIQkNiMo8aEnn+Z24/JTALlRkumJl+Cidvp
         Azwc/uwjvuCQzj56foLG5TwyXpF7CsulPUdEqUAGMo0l3RUnwN+VKPIstrK/aUT7J6zV
         HtLg==
X-Gm-Message-State: AOAM532JBlW6sACaao8SKtZ7X/WYYc07tzEd92KiqdcdQKvmNVKMEYJX
        qDW28v1ztDIhtCAmHdwTD0L/qmtpGE9qdg==
X-Google-Smtp-Source: ABdhPJy9vSMx7DyBs5Wo4FI2O6ZaRKDv951NonLwCD9We3hlGW8x2habW6Zz/PswdmFP0t9tVqC14A==
X-Received: by 2002:aa7:8184:0:b029:1e5:1e7a:bcc0 with SMTP id g4-20020aa781840000b02901e51e7abcc0mr21744503pfi.73.1613990353154;
        Mon, 22 Feb 2021 02:39:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm16512736pfl.52.2021.02.22.02.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 02:39:12 -0800 (PST)
Message-ID: <603389d0.1c69fb81.3fa0d.4014@mx.google.com>
Date:   Mon, 22 Feb 2021 02:39:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.99-3-g59acbf2e564d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 102 runs,
 1 regressions (v5.4.99-3-g59acbf2e564d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 102 runs, 1 regressions (v5.4.99-3-g59acbf2e5=
64d)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.99-3-g59acbf2e564d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.99-3-g59acbf2e564d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      59acbf2e564d570fb2f562f61e8a908c4bdf8442 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60335581614d98da5faddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-3-=
g59acbf2e564d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p=
230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-3-=
g59acbf2e564d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p=
230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60335581614d98da5fadd=
cb2
        new failure (last pass: v5.4.99-1-gd50a4341411a) =

 =20
