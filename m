Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BBB438758
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 10:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhJXI2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 04:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhJXI2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Oct 2021 04:28:16 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9168C061764
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 01:25:55 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s136so7780030pgs.4
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 01:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g2sYHgjOP+jNwg1AltlFaQkFFjGOcz4ovLOtuoTnrxs=;
        b=vOHQkDnr/gNJi15OwbJaF6th+g8fmCFuR9a+UK++R0tJeGcXvbub0z8+6fa16fZEkE
         m50ssTem43hyfZu6Az/WuLJMgEA52uVm6pg7AU9KElqW31cHGbLVqEVl7mWEghDKWP2J
         5cAc2dE5a9iH9bBHZr9Jye2ympW8yuDxPy3GZe6GZoO07NnxHlvj4vORDzdo+MGLh5y2
         88xhUNO7/XWwtmeE24DgDMuytM0mN2kqfp7PVR8TYB35bQz4+ozEGC5UeqJhxUN0HxCZ
         LdFlMAgVPI8SUBDn8+NKPZkWfriRlDae4rwBaZD4lccX9s8q+I8FVYObEUCMYx5DPhbh
         SGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g2sYHgjOP+jNwg1AltlFaQkFFjGOcz4ovLOtuoTnrxs=;
        b=c7jB3PBDnI3rSl5tJQ7isWaZvwvvgtuHDzZ42JKOadY2Rc5DjRux+NsKkZmMQtbuqL
         4BVXEni10847a6TC3OvJSLBtPnfcpYvJF9hoNkJchaMSMhZHxFSqeMZhwCfbJTddL4o3
         oqlUE4bOHEd903qlivvj/e7ol3Ov5yN3MP6+vHgS1wTNQS5c/H4tYsyJYKKoht9fjKyy
         rOfJC9Ek9qf9MkAFjLPYJifjwf2IkxUKXL1yRqTWqK2VJAbltiQJypBNMv/rOlE3Ck6o
         baCD2zKNuIhjIR5xifKTx0z6Ml2U5AIdXUNX8Bm3BiKRRPD7/HZHviDuZXz6nED/H/TF
         vwHg==
X-Gm-Message-State: AOAM531T+OoD+hFitNoaRwOvKhBufHoizJx9RH82S0136lqk91shYS+I
        mYXEDKbciTdl4NqpRz9xLXjWqH7LoTxYTU4W
X-Google-Smtp-Source: ABdhPJyOogyGzWml0nYTz2v0H76cSBQndb7YX8RL4h0emonfXqp790Efg0V5BY4e64z7aA8DrRtC0g==
X-Received: by 2002:a63:be01:: with SMTP id l1mr8095074pgf.445.1635063955103;
        Sun, 24 Oct 2021 01:25:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm17845433pju.34.2021.10.24.01.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 01:25:54 -0700 (PDT)
Message-ID: <61751892.1c69fb81.214b3.15a3@mx.google.com>
Date:   Sun, 24 Oct 2021 01:25:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.75-33-g520e423963d6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 182 runs,
 2 regressions (v5.10.75-33-g520e423963d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 182 runs, 2 regressions (v5.10.75-33-g520e42=
3963d6)

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
nel/v5.10.75-33-g520e423963d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.75-33-g520e423963d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      520e423963d62889e3bf3bf617ae425daa4b649f =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6174e973a9eba191f13358f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
33-g520e423963d6/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
33-g520e423963d6/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6174e973a9eba191f1335=
8f1
        failing since 3 days (last pass: v5.10.73-124-gcadcf306c4d5, first =
fail: v5.10.75-12-gd4f688e84543) =

 =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6174e89cd85c40ee2b3359fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
33-g520e423963d6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.75-=
33-g520e423963d6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6174e89cd85c40ee2b335=
9ff
        failing since 2 days (last pass: v5.10.75-12-gd4f688e84543, first f=
ail: v5.10.75-11-gb603d159032c) =

 =20
