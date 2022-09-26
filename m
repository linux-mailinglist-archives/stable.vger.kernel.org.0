Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522935EAE35
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiIZRaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiIZR3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:29:48 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B16F6B
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 09:47:38 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e129so990808pgc.9
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=/MYZwY/692IdU9BKe+pgwCNooeonftQRpIKR0y+VwrU=;
        b=VFcbjtN2oM9Es6J1vArdid3JmNJdvrcFbQSJb+65Ts6umTNyWcBEJ61MCc8wvKy6q9
         wNQbntHfVVOv3rmNj2y0bTwQrg5A18+1cv1A5/GjUmISt9OKT3/2+31xstvmB8ecfBvU
         ch/FyOBEXIEI8Yq7QQJlguN0reIu5L0S/og745Hkc2npP7gKJm+FjDrkBBeDGtriQ/fp
         iScBS05w2QLPy3tc9bpq+3sXK/ThNZ9nAwAWOswPSYllyci7hMqUdS8f81WbUhaQ10Yo
         KV2rbi8BEnnSoMYrQSnPAM4lfRlKWwlPequaQY3ntJ6Vf49qBbjj8BzO46DthcWHDpa3
         0TWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=/MYZwY/692IdU9BKe+pgwCNooeonftQRpIKR0y+VwrU=;
        b=wugDCZigQYZ5ylsbUEPGBHgePvps9ykrTyHyklAAzt6iFTPMnxua2Scp0/F0+OBq+a
         kyO21eK2oJMXPMa1VBvvEwegYL1MEejWjtdJ7ARfOjkxJISsc03eRm8tv0zOCeq062Rw
         +R/+8k/QlS3SoNst4nwqUHWFsMEYV2uey20MWNXLBEJppipFUI1GZtniN3QbhTFJvj9+
         fYewNIW1IjHKyg3w0vp5Ri2n54mCp30zBxSvMm3fo3FEujOqhafzz01rsj7Y8aE+9Heg
         Tk6iBM+9wozCYPjqhNEi2O829EEfinFxZHjuZI/H7l0G5rJV1TZbPGU7GRDZhBZJsVQJ
         E5bQ==
X-Gm-Message-State: ACrzQf3qS9zGfTvvn2+sUUgbzTtXLh144ZX+DmeS5ectIjyPiaSwKvgP
        i7cKGX9SxYZoxo8R+uge6GkH8BLYMAfBcax0
X-Google-Smtp-Source: AMsMyM6YLxIzy2isfM6XEbB9I/RBF2MpC4JctHWr5kiaxd7SowSfaOIPZ+LemxQpNEkpjFwPx69bYg==
X-Received: by 2002:a63:89c7:0:b0:43c:e4e4:7aa with SMTP id v190-20020a6389c7000000b0043ce4e407aamr808011pgd.33.1664210857144;
        Mon, 26 Sep 2022 09:47:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i64-20020a625443000000b0053e5daf1a25sm12458722pfb.45.2022.09.26.09.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 09:47:36 -0700 (PDT)
Message-ID: <6331d7a8.620a0220.577ac.6e4a@mx.google.com>
Date:   Mon, 26 Sep 2022 09:47:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.145-142-g958deb58efc95
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 117 runs,
 2 regressions (v5.10.145-142-g958deb58efc95)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 117 runs, 2 regressions (v5.10.145-142-g95=
8deb58efc95)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1        =
  =

panda    | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.145-142-g958deb58efc95/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.145-142-g958deb58efc95
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      958deb58efc95bf50ed88022e576486883107baa =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/6331c815b0a2368a4f9d52e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45-142-g958deb58efc95/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45-142-g958deb58efc95/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6331c815b0a2368a4f9d5=
2e2
        failing since 28 days (last pass: v5.10.136, first fail: v5.10.138-=
89-g10c6bbc07890) =

 =



platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/6331c80b93533768d19d52b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45-142-g958deb58efc95/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
45-142-g958deb58efc95/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6331c80b93533768d19d5=
2b1
        failing since 28 days (last pass: v5.10.137, first fail: v5.10.138-=
89-g10c6bbc07890) =

 =20
