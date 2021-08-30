Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566803FB150
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 08:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhH3Gl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 02:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhH3Gl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 02:41:58 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92326C061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 23:41:05 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e15so7946460plh.8
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 23:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D4L/QsMEHbp+KBxM9t9q4AOtnq2iCtkcwg+I3PCg77M=;
        b=ZIG97+mYBpErO4CDkC0BIuRUNjnfeuRbzD18uGaO8BBmRDicCGlJ0+bqltsYg1NTDe
         A8sqm78MaOY7n98SNOf7v4l0XTZhmCm/wUF6IcGqeY4UiFD82xa6spiE1aQHEHyiSe2w
         4bkGa5HUbSj2EXIRf3e93EoCpJYAxzQbEIXu036kjdEbBzgbF1o6VjkWNXpLVkavU/by
         qWzfESw7IrccbSnVYeoedyVJW7vdAjdnsmPUFPWGe5BrwZUSZ1M59diNXcg9TF+ZP8KH
         VLecvVmoCvvorcqQk/MeVMQTpDZsmDjLjvJgDwC8pNL+GaJTIFD0HnGDPiHenWi6+AtH
         fpkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D4L/QsMEHbp+KBxM9t9q4AOtnq2iCtkcwg+I3PCg77M=;
        b=HWkl+nzicgArKVMghrMQ3s7ktgIMqLHtqJjAg5DhHgktLa9H0wvZvXGjF5zUseajZq
         g+GouZlhnWtnHaBCliQEF7LWudx8OlqJZXWZlBJmp62hpnnYSEO7EWkG3pX4OU64LsG6
         gKb+iqyoGVYbmi5eNlBEM1Eu3yxvE37eG9pD+BjMWiBJ3tYwpLj3zyFJWwj3meqNia35
         DUAx8PNXiCZmpsSNOrdYA7yHVEyvSFB9TgZYlpLaCxPlGDyhdduf3L0Yfmt2JJWt1kJ9
         ZdCBjLw+bCHkKIODVtQ4++ahGq7A5213N8nDVtoklFSicbAF483MiCeDzQ1H8UVDaCAO
         kp/A==
X-Gm-Message-State: AOAM531K9r6N/KmSdKKHSn8PCMIiGima5lq8hwhL946rqtzCAwlrL+l5
        wsCHiLNoTOTeH1Kr2dvB3Ymwx5iJLvLyjInR
X-Google-Smtp-Source: ABdhPJyS8AmIw4Cx1wLtQCqgT4b/UFdsetvFwjSjdhhpjb1PHGLq8KvQGe+XMXUUce9zCVORLK91Ng==
X-Received: by 2002:a17:90a:bd06:: with SMTP id y6mr25532259pjr.6.1630305664954;
        Sun, 29 Aug 2021 23:41:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm13479346pfw.33.2021.08.29.23.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 23:41:04 -0700 (PDT)
Message-ID: <612c7d80.1c69fb81.53c27.2354@mx.google.com>
Date:   Sun, 29 Aug 2021 23:41:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.245-12-gf3c09773d6fe
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 127 runs,
 1 regressions (v4.14.245-12-gf3c09773d6fe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 127 runs, 1 regressions (v4.14.245-12-gf3c09=
773d6fe)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.245-12-gf3c09773d6fe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.245-12-gf3c09773d6fe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f3c09773d6fe07ebcb61fdb868eda8f5c32f2bbf =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c4e4f04a658538d8e2c82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-12-gf3c09773d6fe/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-12-gf3c09773d6fe/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c4e4f04a658538d8e2=
c83
        new failure (last pass: v4.14.245-6-g90f882f2bebc) =

 =20
