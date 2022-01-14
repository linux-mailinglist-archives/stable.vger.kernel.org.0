Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D048EC32
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 16:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbiANPHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 10:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbiANPHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 10:07:11 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577D8C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 07:07:11 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id f8so2998472pgf.8
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 07:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IqztX1L7zZJzbgZ9N23VK9TVA/rmxLV4pDM8oScroU0=;
        b=kw7YrDRwqSjXeDEnOVYEnTZqUSfk4RfUqhT9s7A2sccgSLQnRcsQm03xiflhyrM87J
         5+XKsYwqvapBWc/hz8n0hec8e9aEPDAcX0uzi9/b4SE20RfkQhn83YNmHlmfkVrSfU99
         T+R30bEIscEQ/tpYa2OR9DDiafy/Gl22da6TpbC95zUGE5rFGDHKbLJQBPsAwTsPEhNR
         47D3n8R8N6LrupT7jj1PXLoZSVPBQZ9FYE1/y79kIGy8GsKFqURTUDUvePDinswdndru
         jQIZc/mG8VLjWA3VcG6QtH9PYiIdByh7v6eHbSdFrIJCKjhhw2qoQEZgKa0hJThaW1+j
         48uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IqztX1L7zZJzbgZ9N23VK9TVA/rmxLV4pDM8oScroU0=;
        b=Unlv6uEmWvbCDVCkiVt0f7KhZlFT1U3xYhRYPgZJBcGa486BWg/9mNShHH2Jl0U0hK
         lZFH9y/Pg6RAnjvm2jAtTfDliscY1Q4nqlg+NMybi3uQ1HXfVnrATIt6Qw58gBQXx70J
         jTfEuuQpeuY27h7+nIzvEK4l+S5G8DS0ypSsXWKdNeAtu1rrngYpGlnqPRqK4/R+HNUN
         wbgMl25SxUCZ3oREaxsr/+ORCybBbnqGlw1sT9Ncpzz9n3kAg4qYqhQG5QanUTLo06cn
         bXXnKj/8TkD6JgKnJL6x6XnqeCPbcF6UVhDxwXaGPuG9x5VTxppE+EOp91CKRdafvkWg
         6YCQ==
X-Gm-Message-State: AOAM531f9hh6iB6e6xy45i1jXDVRHalZybhjIDinCLx7dTM8MNHN+/RA
        51/jYlvwDdaQR8/yiTk6WisnDNJVQPDB88cY
X-Google-Smtp-Source: ABdhPJxTNL7S+PGP2dyo9y4hfKKXFxzCBJLLF6g1B6dGiqQYaocVmRBfZml9tRkesfEdJaQTDPGo5Q==
X-Received: by 2002:a05:6a00:114d:b0:4a2:89e6:659e with SMTP id b13-20020a056a00114d00b004a289e6659emr9292714pfm.38.1642172830113;
        Fri, 14 Jan 2022 07:07:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j8sm4822441pgf.21.2022.01.14.07.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 07:07:09 -0800 (PST)
Message-ID: <61e1919d.1c69fb81.91f04.d07f@mx.google.com>
Date:   Fri, 14 Jan 2022 07:07:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.91-26-gfe11f2e0d63b
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 144 runs,
 2 regressions (v5.10.91-26-gfe11f2e0d63b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 144 runs, 2 regressions (v5.10.91-26-gfe11=
f2e0d63b)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
beaglebone-black        | arm   | lab-cip    | gcc-10   | omap2plus_defconf=
ig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.91-26-gfe11f2e0d63b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.91-26-gfe11f2e0d63b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe11f2e0d63baa47c1e36b02721b4fd7a1157955 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
beaglebone-black        | arm   | lab-cip    | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e1638e8bd8ae914cef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
1-26-gfe11f2e0d63b/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebo=
ne-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
1-26-gfe11f2e0d63b/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebo=
ne-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e1638e8bd8ae914cef6=
753
        new failure (last pass: v5.10.91-23-ga333c5fa75fd) =

 =



platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61e15c69e2b87ca3f6ef6742

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
1-26-gfe11f2e0d63b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
1-26-gfe11f2e0d63b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e15c69e2b87ca3f6ef6=
743
        failing since 2 days (last pass: v5.10.90-44-g83e826769db7, first f=
ail: v5.10.91) =

 =20
