Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC1A2C331D
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 22:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbgKXVgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 16:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731366AbgKXVgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 16:36:15 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8151DC0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 13:36:15 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 81so403088pgf.0
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 13:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p6MHyaP/m9hZ3qbCXdkixnN1w1TuaqfFM/qXsflSe+E=;
        b=dLklDdURW6TZX/N7EplpJUGYLQ6huH9D8iiAFf/Qpo1ei1YrpFOwRRWBbnV0VsIJWg
         ic6lez9A2Y4h9YS8nLNmuToGwMxofV0mOyIlFbz56TggORYHJAD7ypOLfDoQeMxMQH0j
         ww+XVZQX9F/T4B6UP4O3koAGqPSifYCNDpFZform/gm50Ezz+A3ZT0pYU8vl00Z0Js+G
         nDX4dBz9/+RxDWDFgbXrYBJN5Gc5aMkRU76EOsohN21SaH0qqluLdvj2Yehmo+cRWWdW
         wJPcu0+97H2OvDblN/MUx3CQ4HqpihApg8psZUYt2o0Y2GkPFmF0UwusZY9/R+8Xzpo6
         y1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p6MHyaP/m9hZ3qbCXdkixnN1w1TuaqfFM/qXsflSe+E=;
        b=TASB3OFlLp/2+7MgPumXj+pJDWh/+8gIyNW8eo+70ZqXcNszHnbGLcbbbwY5ovVLHn
         hfyY4dcqVHbRNTV2FnC+cFkvJ3+qdiyOvZkb0e0PZRVZZWXfijsGIVARrxRMUZNaiHsa
         ACzSuvmXm5JzQnuDvqefAXE2LZjZ50eWS36w9q/+py2Pnh3dZVaxbEFZ7XTndISg+GE0
         u4PoTbmaoLHYZr9o8AT38xKwJteOTeAnypVWTvqjX2mc1WNFO37BHorQnnGixK7xDAVD
         /5ws4iJGgc7oZMr79Op+NTDjEWUNQPsvtfaQDRcUDv+CIpkKDNqFk+twLIPwDGU0Ajrm
         MB5g==
X-Gm-Message-State: AOAM5330wDLttrPmGIL48BtmcU5cUYgQXw3meUNti1UJtRAG37HHacW8
        t1SNsgBWc/DJK9pGsAhc2OxMz5VvaLL6Zg==
X-Google-Smtp-Source: ABdhPJzPBo3EBMW0K3v9AFv2GAWY52lgBwfrPzVMylezaBh3AYq+E12nbT1hS8yp2V4iNRW94B+dBw==
X-Received: by 2002:a63:da58:: with SMTP id l24mr321364pgj.178.1606253774721;
        Tue, 24 Nov 2020 13:36:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q188sm139517pga.63.2020.11.24.13.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 13:36:14 -0800 (PST)
Message-ID: <5fbd7cce.1c69fb81.8ba2d.0800@mx.google.com>
Date:   Tue, 24 Nov 2020 13:36:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.246
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 120 runs, 1 regressions (v4.9.246)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 120 runs, 1 regressions (v4.9.246)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.246/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.246
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d0b08c5f94fa089b72ea8c4130521e5df4b17ef =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fbd4804c797c3aa4bc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd4804c797c3aa4bc94=
cba
        failing since 6 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-79-gd3e70b39d31a) =

 =20
