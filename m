Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4D146BF31
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 16:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbhLGPZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 10:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238307AbhLGPZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 10:25:09 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C13C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 07:21:38 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id np3so10533250pjb.4
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 07:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cDPKO6tT+coDkWG/BVmkNs3VXXH6aaHnIL2BAxgoanE=;
        b=3mFt9pI3K2ljNONBcrx1j0KkCAgLAGaPjg9B9WDdkUMgg8J8RiYIeJExImwiXmslSa
         92h0ziOcofC4KpLElkgcbLEViB0y3gkuQVeCWKoFrofvANWRZvbCUbAszeNv6obPsxrg
         OhKKxnbR3gWGknAEUwAo8I7GQVlFa8RzNlkaITLy3PRn34L89yEl5ST2d7+k6bJFptrb
         idJ+vYfcfS33DJgETo6qoc9jOOY9HsWCwKjia1vEqF1R6b1udJghpWQjGO0ftyeYVBaz
         7qLzfK5u0KwIwVdHIWBng0HllHQImxtHBed5NmAQzO8H863p4y6jp+ILpPD96zFG9hrD
         MKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cDPKO6tT+coDkWG/BVmkNs3VXXH6aaHnIL2BAxgoanE=;
        b=hyJvJrdxqvrl8hyLQ9P0b9f8MtFzdc6miKo91kwApqy8J8WJFXjJ6dEuZeI/so0B0b
         hGYHvlVoaylR6S5k6bGZEFXLmYfP5vzmpsbE5ubnM1w5tidiCUO82VaTUa1FHQoPG8Vc
         7IgnKfyMzFcGkC6SFaotBNLlFaxFjQenSIdqe0IOSuJ3K2K+Mg+Mry+xHwkBiVqf6lF5
         S5pmQN+yubyGJp/jQTmwadsQaUMLftSgjgWhoO2kGidYXtikT8M+3qpRNZ6C0f6GusJd
         4lrbWN6ywb+2qiYsQx67rhR2Nxrg/TmELlQk21cm/ThpdKnsm2G18ohjdWXqt7g1XyHC
         jwAw==
X-Gm-Message-State: AOAM530OYKYJwbpTNfdXYdFSXPxFzz2rfLlOmX26LAi2tABvG+LyZoWM
        LyfdnLsAPCqD9pO0JiYaN+1uBoWTzo7oQQqh
X-Google-Smtp-Source: ABdhPJxmOm+nIAP8zHTmatYt1650pwwuJFwMy2/EtXhduITi5Grj2cIkRxAh/53N1qNO/aJ7k0BGiA==
X-Received: by 2002:a17:90a:983:: with SMTP id 3mr7361000pjo.70.1638890493153;
        Tue, 07 Dec 2021 07:21:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nn5sm3187177pjb.11.2021.12.07.07.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 07:21:32 -0800 (PST)
Message-ID: <61af7bfc.1c69fb81.37701.8eb1@mx.google.com>
Date:   Tue, 07 Dec 2021 07:21:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.83-126-g05722611cd6f
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 245 runs,
 1 regressions (v5.10.83-126-g05722611cd6f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 245 runs, 1 regressions (v5.10.83-126-g057=
22611cd6f)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.83-126-g05722611cd6f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.83-126-g05722611cd6f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      05722611cd6fddc7f5ed4610f0ac2cca13745edc =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61af49a6d1c1c4b80f1a9482

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
3-126-g05722611cd6f/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
3-126-g05722611cd6f/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61af49a6d1c1c4b80f1a9=
483
        new failure (last pass: v5.10.83-103-gc29f149d13ca) =

 =20
