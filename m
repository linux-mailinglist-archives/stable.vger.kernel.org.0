Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8211E405F1C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 23:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhIIV5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 17:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhIIV5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 17:57:41 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68574C061574
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 14:56:31 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id m26so2979603pff.3
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 14:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7rEZxO61P0Vsl0oiJzOlDgJYF5aNXOzI4BXy3Khgmrs=;
        b=Vo9dctyfis8utugTLha+qZaEmb6BfepD74h+vzNXa1NY8TKwEd6DNoMl18UN2liJL4
         /RMIbjZzUQGz8dY9oUml1wz1WtFFXMrzidnzQEcA3ChxU0Eq/qATATbHxbgBpuW6ZbtI
         nrt0C8jRtmAqzUVVheOmi2HjgPWVKOoOQ6KHk+easZzP3V+pwoVREYb7TAkmEhx3rZxZ
         VXft2Qgc7C6Xv2LBMnvK5/BWn8Eez6ubVqgMLRlWVJHoIBEM9dfhBHjfVihyJp8Q8KKp
         qDf2tX+JGyY6/vK5BJAUPtpvSoeVnvrcP6sZBssdOnbymC+RgL0yT+77cBOGXp01bBig
         VjgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7rEZxO61P0Vsl0oiJzOlDgJYF5aNXOzI4BXy3Khgmrs=;
        b=oyarQjCN2hS51lzV91UculICzLYNOoYRmmN9Tvm+veRNrya71dLgw+SpYDadmGxLxb
         zR7RvCF97jEQGtMC8K72452dNAwKOAAgNfndXuAwdPWzZDWnFTfFFjxx8GgC8JvvfozN
         tdywjRzneEy9BNSKh2jOpMzWXTGcknC9gS/3gs8fxHRdtuMzjq1HdHsiO74atd9oFe+T
         ah8Y3vNKxhPuDDLgcUT/b55ovuwmqdGVms/l4g4VuMg6yFFvoEh+e7KBiXrwD8SyD4NB
         zfDCvNGZwp2VzDoj5QoKDhplp4CMlwuSvOyKR/5uyg+50NVOgM1Z9Ca3W2+lSpBo84df
         lKvw==
X-Gm-Message-State: AOAM53150LofTLmdE0xZeIXuopZJAE5zLk9DiblpBNU8K01sJ5QvFxEd
        rmCSgyKo32eHiw1gV8YO4CeWoVS5/za4yQkG
X-Google-Smtp-Source: ABdhPJwK031MDnC80fIuLoFy4UvBtxnnVC3hYm5gglu+X7fe/lJj3RAmRSZcWUPnp8ruA6MvnKle0g==
X-Received: by 2002:a63:30d:: with SMTP id 13mr4580052pgd.289.1631224590500;
        Thu, 09 Sep 2021 14:56:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4sm3255894pji.51.2021.09.09.14.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 14:56:30 -0700 (PDT)
Message-ID: <613a830e.1c69fb81.a5da8.8eb1@mx.google.com>
Date:   Thu, 09 Sep 2021 14:56:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63-15-g4b9a2e2441d5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 207 runs,
 3 regressions (v5.10.63-15-g4b9a2e2441d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 207 runs, 3 regressions (v5.10.63-15-g4b9a2e=
2441d5)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.63-15-g4b9a2e2441d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.63-15-g4b9a2e2441d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b9a2e2441d508dca6bb0be6b16f16285049e8ef =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/613a527b721ff6aca3d59695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
15-g4b9a2e2441d5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
15-g4b9a2e2441d5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a527b721ff6aca3d59=
696
        failing since 70 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/613a53840705f956bcd596d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
15-g4b9a2e2441d5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
15-g4b9a2e2441d5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a53840705f956bcd59=
6d5
        failing since 0 day (last pass: v5.10.63-1-g56ca228bc595, first fai=
l: v5.10.63-12-geb725290fd0a) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/613a5264721ff6aca3d59677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
15-g4b9a2e2441d5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
15-g4b9a2e2441d5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a5264721ff6aca3d59=
678
        failing since 1 day (last pass: v5.10.63, first fail: v5.10.63-1-g5=
6ca228bc595) =

 =20
