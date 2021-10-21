Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD5D435F10
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 12:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhJUKc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 06:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhJUKc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 06:32:27 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFA0C06161C
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 03:30:12 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e10so80267plh.8
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 03:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i/WJbU+wM8Sypz0MCdrtye9hwplXRkHylIriRQ6/KZ0=;
        b=NW7xhV08nmzJsSRpmFJ9XrRO23kS775a2PJrUowvWiL/HZQRh9vzEf9KHMiVSn8cFQ
         frRTEBoCujrv2CIP5OCGhJ50T9MPrrrEljeF5A+gkNMFgOoJ/ZlYewDzluizNKud4/4T
         egLYKaXEmf43QqFPtauEL9KVfeNNI26tG2NIvmQyhFPPcamspyqkRyNP+Ljg2UlXAaUd
         8uRlYJhnSFF0dtSK6VqXjDvNJZYtDtnraDr0+7Wxs8DUPmqOhte9xJorBAA8PuqlPS6n
         LNYJ3uPz8u1PmkTa418T2cMi6vAOHS0DgGOLSR5oD+RR9vL/mxuNvd+NF7apP8Eel3oT
         QtbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i/WJbU+wM8Sypz0MCdrtye9hwplXRkHylIriRQ6/KZ0=;
        b=WquRNJ8wTW7WegGDKxcbFPQhwRwgu99pnRawRCVLQA++3Vn5zVf3V0t/08yYElfYIx
         wrTAxc3/d6nsT56/Fz2zWs3fsxAoy5Vx4lNjqpqE8dE9OPS5X8t5L2My+1b40QaJOpcs
         XM6TlL9AmpCxnTxrqZo4r0g1zWXeNJzqIRUc8wV5/D42aNbomMn/vPj06nFkbQB4V392
         977FsbDEC5mu/TsQZ6me0zkpOnUT6461z0dWIpuVlj23jF7pobKBWuJUfYRqUfI7qHa+
         gOdpSn0akVJjnX75bP/LAqAc+8db5RDes3ZD4/LvMj5aoiwwtwg+h3qu2O47C+9xdFQf
         7K8A==
X-Gm-Message-State: AOAM531yEpDZuUVIbbwW5+23h18maGhuOgOMMREvnBh2r5lyPBCK4FFI
        HH0pxw2oPUt6Cq0ijIaVBAGJfcYdyCJ8fKTEBv8=
X-Google-Smtp-Source: ABdhPJwB8pqIVgpYAqQ5yDTgvq5o5mlrA7hNY/rOqD1Kk75Hs2UbSujW6Vy7P4KYWirMrLWX5K6plg==
X-Received: by 2002:a17:90a:4fc5:: with SMTP id q63mr5776517pjh.148.1634812211650;
        Thu, 21 Oct 2021 03:30:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19sm6472460pfv.81.2021.10.21.03.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 03:30:11 -0700 (PDT)
Message-ID: <61714133.1c69fb81.1f2b1.0d20@mx.google.com>
Date:   Thu, 21 Oct 2021 03:30:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.75-11-gb603d159032c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 113 runs,
 2 regressions (v5.10.75-11-gb603d159032c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 113 runs, 2 regressions (v5.10.75-11-gb603d1=
59032c)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-10   | defconfig | 1    =
      =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.75-11-gb603d159032c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.75-11-gb603d159032c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b603d159032c178fbad3b5d597deddf1754829c5 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61710c25ad72f7b8c83358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
11-gb603d159032c/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
11-gb603d159032c/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61710c25ad72f7b8c8335=
8e0
        failing since 0 day (last pass: v5.10.73-124-gcadcf306c4d5, first f=
ail: v5.10.75-12-gd4f688e84543) =

 =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61710b16cf5c75814833590b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
11-gb603d159032c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
11-gb603d159032c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61710b16cf5c758148335=
90c
        new failure (last pass: v5.10.75-12-gd4f688e84543) =

 =20
