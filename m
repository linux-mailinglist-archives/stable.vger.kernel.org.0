Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED58433545
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 14:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhJSMCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 08:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhJSMCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 08:02:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B305C06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 05:00:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so2469418pjb.5
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 05:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uNcY53WWUKgjGyj8awc/ui+n2EeFphlsDkBCevv3JXQ=;
        b=2I0EhO2ZAYTo7xOVQuoG0iYQpcVu7BlMlzDBiFwWOSakgE4rB64x52OXY6yy/ZVrPb
         B5hFS9IBbGL0rjJRp8jsx+4H0gR4O3jvUYtGBThTt0hyc0PHtTyDaE+0lAyBsDJ6J2ZX
         XUtH/ne4667pzIt6WTSgh4XrvMh8dPoQtr7NLQLN/w4MYBYYA4dHpufQUwjYoDbzhUHU
         necc81lLQS2Qvw9An7lW3wOCUvixq1eyPvwWoAU7ykM4owsgpmSd58HSpZ/z5L/6b+/A
         e06Nrf6i3YQJH5Jox80j78zWIyxlVV/WHIvSyA5YdV4ZMXk1BkfrO9ZmqvgKYOQCWUCL
         e+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uNcY53WWUKgjGyj8awc/ui+n2EeFphlsDkBCevv3JXQ=;
        b=Bk30/1/toPLBWOa2NT06ZVR5ah9bGweAvYSu/4QXA6mC6ef6do+kviLbS/+PgrGJl7
         2Gr5SBruEaXRfQ65i8gZ+x0k8Fe7LR6qGpLyOg210XXd24ylUZZhSOMoRyGyisgLfGGe
         pGV5GA48IExYGuAJfgCm4oUos8O5OPmNoy2gxk62sd/eLfBWd2ErHS9XVmEn2muslyyz
         3qWsC5+LE0eoVTgY+eqXKpPdI4OkGUuFgYWByPE2JTiUJjEtgAjlj3+WoE2e0XUPs7uE
         3n9Knba6wXgmQwJGPzsDsTRTbPkCHXscwISRA3fUo/32ru7vfEpHATM/xIeuI1uP5/co
         5L0A==
X-Gm-Message-State: AOAM533Z8QDDSExZ8bw8sF6DOk0+5JJpO0hW6javZZaAutLzIcsvHf01
        dQA+YkyCDmh2C7Ak5/Q4ItiX9Sqwh4lP8O0A
X-Google-Smtp-Source: ABdhPJxk5sDXpxociczA9DCrfSXYZcF+cTU+i9K0kU2BWcHBnWhjfpqqGUxJVAaQO90zInjKdx+abQ==
X-Received: by 2002:a17:90a:7e90:: with SMTP id j16mr6048119pjl.139.1634644824717;
        Tue, 19 Oct 2021 05:00:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y2sm2633625pjl.6.2021.10.19.05.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 05:00:24 -0700 (PDT)
Message-ID: <616eb358.1c69fb81.c0cc3.76d3@mx.google.com>
Date:   Tue, 19 Oct 2021 05:00:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.288-41-gb49a3cf35ed8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 103 runs,
 1 regressions (v4.4.288-41-gb49a3cf35ed8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 103 runs, 1 regressions (v4.4.288-41-gb49a3cf=
35ed8)

Regressions Summary
-------------------

platform         | arch   | lab         | compiler | defconfig        | reg=
ressions
-----------------+--------+-------------+----------+------------------+----=
--------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.288-41-gb49a3cf35ed8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.288-41-gb49a3cf35ed8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b49a3cf35ed8a32b2bc726d378c6d52a5eba2873 =



Test Regressions
---------------- =



platform         | arch   | lab         | compiler | defconfig        | reg=
ressions
-----------------+--------+-------------+----------+------------------+----=
--------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/616ea7ab291d3769aa3358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-4=
1-gb49a3cf35ed8/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-4=
1-gb49a3cf35ed8/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616ea7ab291d3769aa335=
8ed
        new failure (last pass: v4.4.288-41-g58d13f3a100c) =

 =20
