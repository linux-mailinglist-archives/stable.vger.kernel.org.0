Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4412D4931A4
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239681AbiASANX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiASANX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:13:23 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E22C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 16:13:22 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id i129so833974pfe.13
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 16:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eXYgOEXpbjYzZW/uqMr7y14NckUhKJfH2KPKwDfSHcE=;
        b=IXoHKlTontffd1WJPJOq23dbA2JRDODKnT9s92kC/iDht84YteMMgxVg+jpcg8YQZU
         PCGRQfzXVLn6FJTecYPIqAmcFcRbVOBSnNljHIs8aaHnczNi+IvO1VtSD2Q5UpKd0qKA
         5T24TbfKGmC8ZQ8RrZ5l6jjLpdqC+6mqsnrY2NyVcLHJ2GdabOM/OIx7rUoRPBKtVnjD
         eh7ODKTt4aDGaZDuNxzKFB+t8oWq7kPt7nceO3xJPUBi+ZTCwCbYK3IU+kPTiUzsrKPL
         cTJKfaGUjA1uC9qT6GI2Ws0MPxwm4zvUlL1g0PSU22PE1xwJu0u87demQNPA04+w8r5z
         hciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eXYgOEXpbjYzZW/uqMr7y14NckUhKJfH2KPKwDfSHcE=;
        b=jzNkF8p5F0im/MXE6mylQiGVWjB0viBhzn3vxdUy5PmD4g9h64DwMaiZ8eoZG/1t6U
         8mL5HLw+RPqhxiG7nLXS2VYyEBjDWZb1nLTBMSqmv3KiHcZdX3stv1Idf0SqQoqK4Kfr
         heNjc/r/iLEK9BD5elzghR+eqlb8Ot7upjD/wzjtVX1+q98BQnVG7Yi9LqAUynjqfVeE
         8PApI8BYCbM6+eOibXZd1kddGhI2Zle5qLbgTbUUdMfh3xrKEO/Nt+y03wUTKNVWXLv1
         3Brl8we/ZiZsVqMlkvqOfngV3PfpJdoUBZEi8/9M1YPrJbjsiym0pxFHkgunrS3dQSrO
         vFcg==
X-Gm-Message-State: AOAM530Cn5yUWZt+o5v9yHhPoU1AhAJb/RLl6YeCd+kcoKq6RE9/XmFW
        NW09aouXjoQtPYmW5XRSU7/0SADepDrDGUyo
X-Google-Smtp-Source: ABdhPJwn1xEbpFOS6LrI2zQvguegKN15ul2J/qXDIlaIU/sU7yu3zWjO2Gw1JdpW6wj0s/m0D0HILg==
X-Received: by 2002:aa7:804c:0:b0:4bc:6ca6:4bac with SMTP id y12-20020aa7804c000000b004bc6ca64bacmr28459290pfm.52.1642551201884;
        Tue, 18 Jan 2022 16:13:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h7sm18927384pfk.173.2022.01.18.16.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 16:13:21 -0800 (PST)
Message-ID: <61e757a1.1c69fb81.1f448.3bfb@mx.google.com>
Date:   Tue, 18 Jan 2022 16:13:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.91-50-ge0476c04ea89
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 188 runs,
 1 regressions (v5.10.91-50-ge0476c04ea89)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 188 runs, 1 regressions (v5.10.91-50-ge047=
6c04ea89)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.91-50-ge0476c04ea89/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.91-50-ge0476c04ea89
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0476c04ea8991e23850dab84ce56ab557c56986 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61e72428299c0986e8abbd29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
1-50-ge0476c04ea89/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
1-50-ge0476c04ea89/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e72428299c0986e8abb=
d2a
        new failure (last pass: v5.10.91-26-gfe11f2e0d63b) =

 =20
