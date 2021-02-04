Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB2130EAA7
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 04:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhBDDHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 22:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbhBDDHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 22:07:30 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CF3C061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 19:06:50 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id j2so1169026pgl.0
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 19:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9+SSCWKXAqahigQvvVzYPsSjkOHYY6QiSzBV/ZVAEdo=;
        b=SebWXYDfI19t6qI12N4MvP1nhUlZfJcifb6+qhI3/NhqXJlKIfaNkvc3HSQLYgh9L7
         wLAejapyyROr7xH99M7LFSeBBvX7bXlg7EyotkcmLzSGuWhvr25KM4KXrKYim7irSEt/
         MogQWeQSQpmooFbQiFpQvT7XUkH8GW7aio72hl9TiKPSajviQiH1xkEStwSXgAQDAYR5
         ELTphkJfg+q3nvlpuMqvKIy23yBMWEnpH/dt+2SrnY0adkdBThGLF5tT6JrXPQAO8mnu
         L1Xqrf2luyHoUQ5rEpdY+Ww6b8h6ROc9zIiQ4fqAysH0XqORLwDCL9FMZALrhJByBvoH
         XYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9+SSCWKXAqahigQvvVzYPsSjkOHYY6QiSzBV/ZVAEdo=;
        b=YJaJG+U9kcrzbDU8Bi22bZ2MG+6V9Zvkt8wbtB51GZ0/pJQ4VeIpcVbsaqNdFxZHbV
         OZVPY41Ul1zpv1T0GrOOAjWCPLqha7MTLZd8m4ZV8fGLpHY/lN+Qtx/tkqy+bqs5iE0B
         qvTudul0YPdBaodUk1qXdny0MoqWGcUN9PvZnP/jtztbZFGYu6q7vN9q9PKOf1/w8ca+
         ObpqBry8VTcXojBrrFNjhmk7aI3C+HG63xghe0zyMoNWhSaZEyP7tNW0LpRBcIg7jgst
         IV3xgODq8GqgCZDpPWWjLNMocx/NM8opYUvfVRdoHOJWQEyN8OmEVwtd+bQ8jjIWONw0
         TDyw==
X-Gm-Message-State: AOAM530AfLLqbd4eTU83MCeF06k92K69iEby8oRZ3w1WJHIUJT++rJlY
        U4sQqJkdJJ62qPkZdlGQYLUQpzm/EUQkgw==
X-Google-Smtp-Source: ABdhPJzzRCnuBTqyqfkyOKJxoT8YU8AdXJ/+po5yzsIUZpPawVL9QRIuXystsqd78LtUrnZ9j5lgUw==
X-Received: by 2002:a65:5903:: with SMTP id f3mr7021541pgu.28.1612408009765;
        Wed, 03 Feb 2021 19:06:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4sm3462709pjt.4.2021.02.03.19.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 19:06:49 -0800 (PST)
Message-ID: <601b64c9.1c69fb81.4cd35.88b2@mx.google.com>
Date:   Wed, 03 Feb 2021 19:06:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.255
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 61 runs, 1 regressions (v4.4.255)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 61 runs, 1 regressions (v4.4.255)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig      | regressions
----------+------+--------------+----------+----------------+------------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.255/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.255
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2f9c581dbde4e48aa0c002ddf3892d6bcd89c1a2 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig      | regressions
----------+------+--------------+----------+----------------+------------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601b31f1e8da9aca373abe8f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.255/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.255/i3=
86/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b31f1e8da9aca373ab=
e90
        failing since 8 days (last pass: v4.4.252, first fail: v4.4.253) =

 =20
