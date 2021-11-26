Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1D445F609
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 21:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbhKZUrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 15:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240016AbhKZUpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 15:45:24 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CDAC0613E0
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 12:39:19 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso8750875pjo.3
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 12:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=haB4K2pemXHGGE1atbhLVAJ3os5jmsfKp0Nztl9Mwmc=;
        b=thZMWRdcn6kDM4YTpFXBfcIQjIezZ6neAtgwAeU9UvvLwgVJCh2w4pZIcooZgraz+g
         h22oV0fDJ5qMriFJeMnUQdGBaC8l0d1xS2DAtudt8emaNrb6cl1/aWNdT9SZvkYr8Dsg
         lRFUA9FQJOdjAVyQIPv13mShR5nclM9TurA83hv0oY0QqzvpN/fUb3WN9+hbj7iahjA1
         yp+nUjegHgGXGUvAIQq2TjMGh8ruWWh92RSY/xDyMnaIt97H093TwtVTdtsrhyL5WpC/
         b3j+CB/o1AlWTXSDpGfYNKNl1+B8iRYUj3STHYfr3/IcigkwALrr4aho7cJzkdKZAtp4
         YeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=haB4K2pemXHGGE1atbhLVAJ3os5jmsfKp0Nztl9Mwmc=;
        b=4fFYGecsj8zhiD38eVwO5vAWcK8H2ZcBYB5ZT8/2JB/4JYgnQxAbPhB1A/zw9TLPfi
         Lgi6tU+fI6rfRy9fjs0OWPizFwyatWCcSOBEltX8diS6itxBQkR8G1debQ/Eezd0ns55
         1PwFmkQ2Vqzw74hml/DUdoEe3qIYwvPR8q6cMU3QeB+iwwwW7aj9RTMHbhQRJ3riBOtE
         jqx662AEvkgxogUFDQFoSoVt4bE5YjnM29CRskxDCJ7j9ERPpBzL6e/sGwQuFLwHBgMG
         VvlfofMIugUm9Nuuwr73z23Cf9Yr9pBqjlcTe4DtiH6W1Dzvc/xcVBCgNH311CmsmspE
         cKng==
X-Gm-Message-State: AOAM533EcfM9BOIW8SNDm9AfyemZdnpUaGlmENG9GFeJU8slQm6pyHE9
        GJBw+OrVqfO9P7LlqW2IvzNKnturqZkX93P+
X-Google-Smtp-Source: ABdhPJyHkdmfs9JnjePggj0FfdQk+VoDprjLQXcaLNMojGYhGNUj0fe4Ymns3po2tzjyoLk27/6h1A==
X-Received: by 2002:a17:90b:4d0a:: with SMTP id mw10mr18393234pjb.89.1637959159188;
        Fri, 26 Nov 2021 12:39:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o23sm7482986pfp.209.2021.11.26.12.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 12:39:19 -0800 (PST)
Message-ID: <61a145f7.1c69fb81.93b09.550c@mx.google.com>
Date:   Fri, 26 Nov 2021 12:39:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291
Subject: stable/linux-4.9.y baseline: 120 runs, 1 regressions (v4.9.291)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 120 runs, 1 regressions (v4.9.291)

Regressions Summary
-------------------

platform         | arch   | lab     | compiler | defconfig        | regress=
ions
-----------------+--------+---------+----------+------------------+--------=
----
qemu_x86_64-uefi | x86_64 | lab-cip | gcc-10   | x86_64_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.291/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.291
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5fd8594b3cefd966789dfebf8eb4311574fadbb9 =



Test Regressions
---------------- =



platform         | arch   | lab     | compiler | defconfig        | regress=
ions
-----------------+--------+---------+----------+------------------+--------=
----
qemu_x86_64-uefi | x86_64 | lab-cip | gcc-10   | x86_64_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61a10d2244d377fd5118f6d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.291/x8=
6_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.291/x8=
6_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a10d2244d377fd5118f=
6d8
        new failure (last pass: v4.9.290) =

 =20
