Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BD048932A
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 09:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbiAJIUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 03:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiAJIUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 03:20:12 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F18C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 00:20:12 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so15046835pjp.0
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 00:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=98KTbixxqDiDxdD/nL6rA8kWTTh/j3ZzdVCq1m6gghw=;
        b=LXRkkABZkhzb6U1r+l0nivZdEkQ7uYzOoo+eE1r9YqOFbtwjttl1W7G+ta9ZXU14T4
         GyVuI4yTktj6FTZ22EyI+e0NcpxaV5/4vcPkGnCwfTrej7lPl4McZO+uT/nA9rBXFSNr
         5yakUYrdTGax8IzMb5J/T92jnfYkIJoHZfvoWas5ITn5Bp4r0uTxQpo9l/k+TkL+ATlL
         x2aVdj0FQbnYuq1jOGcuX95X6h2t0Z9TgaByZtFJiCBkj+ddTuRg5lzRDGsd2dOq8XTx
         M3L4hOIN6SZCFEMyzSI5lRyYpDgOMqHb1gUb8tBZ6D6cqRgdolJQ1PYIvOVDwdqcaKfK
         j44w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=98KTbixxqDiDxdD/nL6rA8kWTTh/j3ZzdVCq1m6gghw=;
        b=qrM992wY0DsX4u0PnJCl5b8fK16aRk5DrCwi+LFUpGnQv0YHS9JOvfS5r65uUNcW81
         fYL1h3zEwejdxhYeCI3V2Y7h3cRtt/2tWhP9DTqKtrX1nygK8QHMSRJgln/jhg56Yea3
         OqFF04kNlGMQanQZqLpeaWK+b+0C642l3xRaPVZKqHp3AAkCGYIvaOlL7R1YUrCo4KfR
         V8O2zjRsVGuc/259Lo1OB/D1taJoRjIHUBZW+L8EhJjT3TZqhF+TzNZGwJ6shxbDUGFe
         Z0uP2zS2CAYxSDLH8taGdAx9DHnjOPrFA02qPIlELJdrejqTcKNql/JLdIR8Dtn6xrLx
         hngg==
X-Gm-Message-State: AOAM532oav2k9W2xTbz0bfmixkbbVS3OSBLnjgI3bhwU7f6DTPrLbQ7d
        9DpyIavTB3s2DdRmiGm2MmVYL2fYVIgkDkUx
X-Google-Smtp-Source: ABdhPJxpC82NpVWsHAHtbULFE9WeXvkqfo8I8BjNNMvA3z2r5ne8pMqZJgE5HvlfLcFA5uOjATp03A==
X-Received: by 2002:a17:903:32c3:b0:14a:1597:99ff with SMTP id i3-20020a17090332c300b0014a159799ffmr10720810plr.13.1641802812214;
        Mon, 10 Jan 2022 00:20:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12sm5719992pfh.64.2022.01.10.00.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 00:20:11 -0800 (PST)
Message-ID: <61dbec3b.1c69fb81.369bf.e47e@mx.google.com>
Date:   Mon, 10 Jan 2022 00:20:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.224-21-g20bd20474370
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 152 runs,
 1 regressions (v4.19.224-21-g20bd20474370)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 152 runs, 1 regressions (v4.19.224-21-g20bd2=
0474370)

Regressions Summary
-------------------

platform    | arch | lab        | compiler | defconfig      | regressions
------------+------+------------+----------+----------------+------------
i945gsex-qs | i386 | lab-clabbe | gcc-10   | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.224-21-g20bd20474370/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.224-21-g20bd20474370
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20bd2047437091b4b4b37a9651bb72e4921b2cef =



Test Regressions
---------------- =



platform    | arch | lab        | compiler | defconfig      | regressions
------------+------+------------+----------+----------------+------------
i945gsex-qs | i386 | lab-clabbe | gcc-10   | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dbb762a1e58e6418ef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-21-g20bd20474370/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-21-g20bd20474370/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dbb762a1e58e6418ef6=
753
        new failure (last pass: v4.19.224-14-g70dbcce03da4) =

 =20
