Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967AA3128D9
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 03:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhBHCBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 21:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBHCBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 21:01:05 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B56C06174A
        for <stable@vger.kernel.org>; Sun,  7 Feb 2021 18:00:25 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id w18so8708238pfu.9
        for <stable@vger.kernel.org>; Sun, 07 Feb 2021 18:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VLc49TLFt81GMCxNy4rctNeH4C7PqqHomseadQf54KY=;
        b=rBrXjtTDX4CWT5pRIAk2kzpHyuD9XLvS+Ue/giKhku7ScIiR4O/0oAxeCkxmYxUn7u
         CzrN6+0tmaLfhlM6cUac4cspbmmvrl8PHbZPC4aZLwck5e3kfsBNRNW8f+FKPJUnnigY
         Ul5yVYC/ibJOE3kUtBWOiTN/aSndOVsJ4gkvlrrI2JHIAKhVQuk0hO+Xc6L/tCt3cAts
         C8BscAcNuZkZbXcXz7rI+uiyjnjqepFKUINtZz7J6wUR+sRBgXRrRZNPq+cWhA0BWHGS
         xj9k60NAYTo7wgtM/EDHq2Yr10J9aORARIQpRbSugNFRSrPuwJawruYRbC3ytl+GcbQ3
         uxhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VLc49TLFt81GMCxNy4rctNeH4C7PqqHomseadQf54KY=;
        b=Qvs707DOo02ERqdZGcWprncI1D8bpxz4R1zx0O8BNvG41RtZM8sIh5wOPZZamHRa13
         GexbsotUjEsgI8na3UEnwPqNMeM0x364Jnq/bpZHjqSr2nvXAxuM9JP6k3LUqWCYL0UL
         V0jXcGFXpHmcv0HbdefUnP6RALqhVxxeN9D86E5Ragwx7b10vwT+umBvYnUe1dCMGInP
         TwuJwHF+VsimO7xcK3GmzYubwwUHrTJnXjan4oqHucVrzq80sEQhHQSqKqTHdJ8q+Wy9
         0fRYbiyN9xPG/DN0To+2/LnQwYx8iiYimYE6eblYGM81+1iCRFbfA9veEaoxmN1tbdm7
         qE2g==
X-Gm-Message-State: AOAM531YJdGTzuDfqRh05na/Zuc2PPDYvf6YdQXoK4Qc9llJ26IDJbwK
        VYG+NXCyOLEihrsvly3ClzUgAXS8tTqN1Q==
X-Google-Smtp-Source: ABdhPJzXUPrSAjnuRfy/lqvlrw9pohFBu9cxz/IVMHQm/lVYR4wvbzyLasXGvON195qmSzSsUlxJrw==
X-Received: by 2002:a62:1a88:0:b029:1da:e469:54ae with SMTP id a130-20020a621a880000b02901dae46954aemr7076237pfa.14.1612749624340;
        Sun, 07 Feb 2021 18:00:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 123sm17422135pge.88.2021.02.07.18.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 18:00:23 -0800 (PST)
Message-ID: <60209b37.1c69fb81.15ff5.5dff@mx.google.com>
Date:   Sun, 07 Feb 2021 18:00:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 193 runs, 2 regressions (v5.10.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 193 runs, 2 regressions (v5.10.14)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
imx8mp-evk               | arm64 | lab-nxp | gcc-8    | defconfig | 1      =
    =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0c8835fc649454c33371f4617111cb5d60463e1 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
imx8mp-evk               | arm64 | lab-nxp | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6020656c86947dd07a3abed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020656c86947dd07a3ab=
ed5
        failing since 2 days (last pass: v5.10.13-15-g62496af78642, first f=
ail: v5.10.13-58-g58d18d6d116a) =

 =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/602064d1284b45ca103abeb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
4/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
4/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602064d1284b45ca103ab=
eb2
        new failure (last pass: v5.10.13-58-g58d18d6d116a) =

 =20
