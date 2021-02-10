Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBE63171E2
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 22:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhBJVEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 16:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhBJVEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 16:04:10 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F52C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 13:03:29 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g3so1923873plp.2
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 13:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rUgqG18S0Z3jsLJ3FZPJGxyncZ+NZeRB/9wk8bRiJsc=;
        b=hfsooW+7kG25I/E8Xbtdla9TnWmN0tFIi6N7IKIBlspySAQP0bcbuOgHm7bCreI+Nq
         RLgbPyM+O+Jil8WOo2ItzVXmB29SDt7mlWVPiIlZWSuiAsCV34hLQ3unDGyu8zZkoAKE
         FGXTeHcSuUXDlRiwbYh43Z7lwkKG9tQAW7d1TE5S7EChHYSC2z/dRYIcRI7CpShlLZ8E
         JSB1hpnhmGNOlSeaxiwM1bBIX6IShVreSR9UdJxv1kqpJnsad/pIL+fqbSPfDHMuGN96
         tTPX3EbrU4beUuVc232WRPsN/Tx37lNRb0f+bRRMhB4wJmLHbUe0ALdx8YdeKmzFtRc4
         255Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rUgqG18S0Z3jsLJ3FZPJGxyncZ+NZeRB/9wk8bRiJsc=;
        b=aD1SSj6UEQ5YnhREQSPnHMq/3SNKB89F79PTqZUBOjSM0DblFowJXfpc2ryLTIBZus
         Z2uX1xZQoLXNJRfZo9CY5GiLCK7EN2Pdtc9n71ak6wv1NtGb9wZqD8ZrenuobteWSkHr
         NSrDh74NgmdeNOqaM6CKlGlTEbpZ5qArnSnb7NFQtGbonu/bvIzu7TQ24jBETf/h95u8
         Jwtr9/R1FgImz90To+vtTsn9TKynAGesap8Mm73LpD0E0J5shCMmB85CVNs2EQWqwKGv
         zeZe5rLDxGkXX2J/oQBGLO3zZjjRGbQWdlPsWs55Xg+x8WEo+ye2HQFQYxhy6GTbibpR
         6P7A==
X-Gm-Message-State: AOAM530bVeef3sLGV/YuKcqFU6WJmLaeUO4cQ7mgf4edkh+xcbdgkaoK
        kj72R5zhunuN1JFCCHXWFK16pfG7+OTFfQ==
X-Google-Smtp-Source: ABdhPJwEGNyX24XyQfK51QATu7Wzp2wrm1PbJatNrHV3/+WVL+5oACrE1SGkOaLQMf2iSmHHo8tVcQ==
X-Received: by 2002:a17:90a:474f:: with SMTP id y15mr787580pjg.110.1612991009214;
        Wed, 10 Feb 2021 13:03:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4sm2957019pjt.4.2021.02.10.13.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 13:03:28 -0800 (PST)
Message-ID: <60244a20.1c69fb81.9925f.6d02@mx.google.com>
Date:   Wed, 10 Feb 2021 13:03:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 59 runs, 3 regressions (v4.14.221)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 59 runs, 3 regressions (v4.14.221)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.221/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.221
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      29c52025152bab4c557d8174da58f1a4c8e70438 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/60241b6c71caa3beb73abe9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.221/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.221/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60241b6c71caa3beb73ab=
e9d
        failing since 314 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/60241ab8ab489a7b0b3abe85

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.221/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.221/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60241ab8ab489a7b0b3ab=
e86
        failing since 17 days (last pass: v4.14.216, first fail: v4.14.217) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/602415e7b5c808f5473abe6c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.221/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.221/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602415e7b5c808f=
5473abe73
        failing since 3 days (last pass: v4.14.219, first fail: v4.14.220)
        2 lines

    2021-02-10 17:20:36.105000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
