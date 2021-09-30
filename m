Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D097641E160
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 20:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344699AbhI3Stb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 14:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344678AbhI3Stb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 14:49:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB40C06176A
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 11:47:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso2335362pjb.0
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 11:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zXeTk4LPfX/WqiVGu0z/Z5ztfMBVuFAePHpT9Y2CLlU=;
        b=HUw0tX+USGGLz8ETX1o7z7aNY7nLRycqKMSjiYkV4/Kw25YXx1RZg2B7vqBt+uO95h
         aLybaLcqwj9fQEBe5Mt0KysbShPKq3R3wDUvUdPKaL3kseQBETG6yl50p0MJbr01WAcv
         6AnRL0x2X3uiuKUGd25BzOpZpZGWdwJk8WviCbwUoyxSW22GW8cDaQVwEfieM4j/uRJo
         CtzaO8PRQqsaWtVE9N/AZt3UqdGVGXOKwWAuRs9VBSh3Mjy1qJKPGxdBvMxk4Xf1mH8M
         P/gkNZxFzhA9SIfJhfkLwBaVigePybS2IOzOosBCALRdmA6dFzks1YrmjsAW+1vV88rO
         Eu9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zXeTk4LPfX/WqiVGu0z/Z5ztfMBVuFAePHpT9Y2CLlU=;
        b=fg0uGBC7IfwlQWsA1k5nlPppO1kG1I5TVLf6rLAA0cRQcNWB08wH8MuDAA1tqynhHB
         u3NZ8ZGoLTnp/xxtoqsBba8to2EKq5qckKf1yp6qjGUVR6fTQ+7B/eanBnxWvx7b7zhm
         CizRVxDxCa4qE/UT/xVikwRf1nh0LUwQ4UdU81KDNuCsHYzR5pRN3O45Bsa2QUgoDGBt
         x9BMy784e6P4fid8+9KeXkfq564wqpfJn7/Upm7mRmjTyNm6mj/yWuwlwaYEne79Ax39
         Lrh7sup1ZoQlx8kFB0qcPMaUDUkQ5nsnifXcG1zpIpnCKoZCaNJ7Ew0a3XRRDIJlBX5P
         mUcw==
X-Gm-Message-State: AOAM533bhPdLLvwD2WAj+rA8Gpt+W2S4JvxyebZ7iPLMjIRap+k1ApHd
        vPZq0tM5qd/CP2slugWwy/jOYXC7PpLFHbx1
X-Google-Smtp-Source: ABdhPJy2C/2eTkDAL+h2FAhdumDa8kVXZsXUloDbCwRWCYLEGtWnmAjxXW1+qaBBn1aeSxKqoPpK4g==
X-Received: by 2002:a17:902:9a91:b0:138:efd5:7302 with SMTP id w17-20020a1709029a9100b00138efd57302mr5684746plp.35.1633027667588;
        Thu, 30 Sep 2021 11:47:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9sm6166932pjg.9.2021.09.30.11.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 11:47:47 -0700 (PDT)
Message-ID: <61560653.1c69fb81.bb8b7.15e0@mx.google.com>
Date:   Thu, 30 Sep 2021 11:47:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.14.y
Subject: stable/linux-5.14.y baseline: 183 runs, 2 regressions (v5.14.9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 183 runs, 2 regressions (v5.14.9)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.9/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      70248e7b378b96f208d5544ee25b808a8ef2ddc2 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6155d21eed52ae27e999a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.9/ar=
m64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.9/ar=
m64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6155d21eed52ae27e999a=
2fb
        new failure (last pass: v5.14.7) =

 =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6155d11b47570e036a99a33e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.9/ar=
m64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.9/ar=
m64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6155d11b47570e036a99a=
33f
        failing since 18 days (last pass: v5.14.2, first fail: v5.14.3) =

 =20
