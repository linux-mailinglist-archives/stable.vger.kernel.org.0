Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4AD44815D
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 15:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbhKHOXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 09:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240453AbhKHOX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 09:23:27 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFF0C06120B
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 06:20:43 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gt5so8222156pjb.1
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 06:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HP3SIIPKfpFaFxqwBhw6h8Aj+j271dcyGBVKn0p8VGA=;
        b=IIgaxDSEQXkhQz9QS+x9lYMov8LtUb4xysuc/ypwGDt23GgP1MFxZKGyT7kU8ZttPV
         0mqd16tG/9yaIeEMnXM/8kKOw8ayXK7BuXazqlUfvWCYzVKV/huMyw1vdWkbcE3rmVRv
         ii6zWuozvRz4dZzdf+0u8Vefo2DbgE8b94Td2mAraPVYGFntq2t/qURjyJQMTlitzMo3
         PdzIwEiyb2hIEzwGobl1BXy/sAjXGSDNlBrwcKcwYd7I8oAIZgx1UGS6HTW7C+MhCXFh
         xDLrR/i14s0YN7fIFhoqVGU0FWjfIwm6/9Lu+soG4nKjFADjltnWIRDOuHmOq6WSinye
         9ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HP3SIIPKfpFaFxqwBhw6h8Aj+j271dcyGBVKn0p8VGA=;
        b=Dpghi61h81L6vuLIfo12AcpCZcgChzveo77xpw4lkGoYtbEDF8KaHdosbsdOeUuT0H
         OPQjedlYd7X3W8o8LH76N7AWu0CtR1JI8pHt8U+Xy/V9goBolATZYCM23zINpz2XLAfB
         1lNXyYzYep9SZJzG839rN+7QNtieExw/w4r5RUOWVbxJ+dKHnbidgrs4OxDAYW88tYJP
         hGJZtqfdfNGQlMskTXWivYPsUuKOFff516C7D5v0ekJUGISe6z3PEPMLlNmfp953dgUs
         SfwYTzdXDl4XVSXceqEtIalxSPFrjqp03iTzHEe9AsqTGuHsBkqfv+96gENmmBLZ7S/6
         NPHQ==
X-Gm-Message-State: AOAM530/GexKfblqp8KfyZOA6pCf0K7IO+WMIK3/RwnbmifcmjtWfG3M
        RLvaT1Wb5unME5z0nMpRC1QOUZvKMiU+jSqz
X-Google-Smtp-Source: ABdhPJwGsl/2EQ9Clwzl5GnkSlOqqWh7oV8C40pMWtEa/GHv6oJrmBEOsItBjMFxcUo8L5M1gCMUUQ==
X-Received: by 2002:a17:90b:3b43:: with SMTP id ot3mr32117790pjb.205.1636381242411;
        Mon, 08 Nov 2021 06:20:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f11sm12587382pga.11.2021.11.08.06.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 06:20:38 -0800 (PST)
Message-ID: <61893236.1c69fb81.ee5bb.6307@mx.google.com>
Date:   Mon, 08 Nov 2021 06:20:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.1-3-ge5b4297eb4df
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 169 runs,
 1 regressions (v5.15.1-3-ge5b4297eb4df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 169 runs, 1 regressions (v5.15.1-3-ge5b4297e=
b4df)

Regressions Summary
-------------------

platform    | arch   | lab     | compiler | defconfig        | regressions
------------+--------+---------+----------+------------------+------------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.1-3-ge5b4297eb4df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.1-3-ge5b4297eb4df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e5b4297eb4df7935e1e2963846bea730890faa09 =



Test Regressions
---------------- =



platform    | arch   | lab     | compiler | defconfig        | regressions
------------+--------+---------+----------+------------------+------------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6188f88d30686e6b413358e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.1-3=
-ge5b4297eb4df/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_64.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.1-3=
-ge5b4297eb4df/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_64.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6188f88d30686e6b41335=
8e1
        new failure (last pass: v5.15-13-gb6abb62daa55) =

 =20
