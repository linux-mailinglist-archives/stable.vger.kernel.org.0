Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEF945F5F6
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 21:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhKZUoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 15:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbhKZUmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 15:42:08 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CD5C061394
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 12:33:08 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g18so9931088pfk.5
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 12:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PO24pU2ncQJqqfyj6ikV+DD9ItRmuGLNvmjfxHjfAhE=;
        b=5EZoww1Uc3NUu3n7B/d26qt2HRslNH7YlygCU1CrD06vsmsYFkGkM2D4Vq7LRfOr24
         9tJsDwyX8KhjJX0RUbpidmMK8Dp8DZ+AXS62CTu25EBtDSEWTaVjiHBjaZb2OEItRPXg
         ok0JlFR2/qNOtKc3JRwVuakzyXXpCc24OaArO3QTS5pdwXBAVG2kR3rZxGTBU7HQEp0+
         q+acNE/xB6tGnE/krJFAB6jo/Ejy6EpmS6lvYtmVbdTK3kqh6zdy0xFe/aiJzkB9Cpd9
         TqgZb7YK7Bltz/KlrygKo7fMS7coCx03Ujn/Q+GDKc/UTjiTf05VBwRd7WJu51v/FgxY
         JLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PO24pU2ncQJqqfyj6ikV+DD9ItRmuGLNvmjfxHjfAhE=;
        b=PrvMr9PhwOgs6L/z0mUTDmEK6EPRTU9PbLB5ZlwXuOQIBVJTbdZiQ/f/kAtnK0+H9Y
         Y2mbjBU82VpgY4y8HjQq+cEUl9fLQPt7C0Zb+s6X/5aagWwAdHn6rsw8S5ubWgk4u7Ay
         S+ayizQwO5ur3vgSTsOzPpcFoLm95OhTbhlXzq5uqb1VN/Tnh+LkRPvLpgbaiSd/Lg4a
         J/vEtZIAeSPFk9fbytGcuDppbSgK8xowttWCa7mA5LRo40SW/CmQbO+9t4rNrwkQ9Qkh
         GzXNtsX3h4T2BXVMHieG93XmdAEbAKcgXd+xYIRIn8iwIqS2qbi69EgDq/ql8mcyeVvU
         Hjsw==
X-Gm-Message-State: AOAM530QE92Ftb3EI0seLEea3Kd5MwLipBjT0fq65fScYo5/cozLKbYf
        Wb6ddemVmner0PO7ZQeq8oKgZIg+FFA7hOuh
X-Google-Smtp-Source: ABdhPJygIT7MhFpUSdNYnCurXN2QTgBlzAQKI3YUmvpHonq3Oei5zmd55HDHKBh6VF2f2dfMhVa1RQ==
X-Received: by 2002:a63:371d:: with SMTP id e29mr9033853pga.605.1637958788350;
        Fri, 26 Nov 2021 12:33:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm5659386pgg.16.2021.11.26.12.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 12:33:08 -0800 (PST)
Message-ID: <61a14484.1c69fb81.facc7.fc80@mx.google.com>
Date:   Fri, 26 Nov 2021 12:33:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256
Subject: stable/linux-4.14.y baseline: 136 runs, 1 regressions (v4.14.256)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 136 runs, 1 regressions (v4.14.256)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.256/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.256
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      66722c42ec916e92cadda46316f8f6e3fdcaedc6 =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a113358aea49570918f6d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.256/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.256/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a113358aea49570918f=
6d2
        new failure (last pass: v4.14.255) =

 =20
