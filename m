Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E604A86AF
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 15:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbiBCOhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 09:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238300AbiBCOgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 09:36:53 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BC1C06173B
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 06:36:52 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m7so2639997pjk.0
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 06:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rWmeCXafU7NpsKIMP+vN0yljn6bfewCVrlgtjoOvZO0=;
        b=5M+No/7gKvzq3Vui+6/WUMC4Okg6ohOQXtyzUeRTIGjyv35RsIQZqzKxnHGrWGhNpI
         dC1pmEeFziS+j1GjtQYqGr3LSbe3s6E63Y86GJzSTMohb4gMVXPYVF1jYXY34uyMoubO
         PkRrtTe4VVJPlkaP6jTQTF/PItG1Re5zv5dJ9tABtuzcKv5XGj5P9HIhjZEV8ekNYm6z
         4G7dKZneNi3my1S52pJYjw1bnqXk+xmK/M9ENJvGItpeL2kAfOOR0/KI295Be1na+dd5
         W0rk+LToCVfqNYDph9G1iBUQ7Eoih3EQElrXoITAwViNMQUX0LtO2ftxUjq4r2iVIjVv
         eaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rWmeCXafU7NpsKIMP+vN0yljn6bfewCVrlgtjoOvZO0=;
        b=ktrrPy63rKUAbiXPHbsaFzBSG8uYwyVXSunqufw1bH71JxsQvahexQjnZ3pqEZhRcz
         Z4w0nU5KsXfr50jqKMkUt4ZoIDZ3/McRKyS1wugj9gzzJiTK3pp5ImpSyCsUuXHm9jl7
         Oq3JUzET1AMy14rJroYgHuYcjIMskjp7g9yYXgLQSwJN0vsAuWO5OihdrbHa7ADKvZ88
         rxGjdC4E7HIZ4RqpjacGuDrK9KTXDsBgRhKi7MWup7xjEp0eyiUdvCD8OWjcnlDV1GKs
         dSXM7hXVKlEq6UAFzMKOOvmo/UCta0lXzlUD+MvfcmHlEDr59onh2DMni8bV8NOGww0J
         0bxg==
X-Gm-Message-State: AOAM5307z3e5HTm+2IY6jvvD9Z25d93W6cY+8r/taDAbe8577VuD27XZ
        bZEoia+jnPdWVCmBMkMcuPCf3GPQxvDkNdYf
X-Google-Smtp-Source: ABdhPJzc3NB//l6FFsCpD5dVNkZ/MK2k7OXdCobNSTDSELUJupFncB+qzF8o/9cONHGzq6sOw5E+5g==
X-Received: by 2002:a17:90a:5509:: with SMTP id b9mr13922598pji.30.1643899012436;
        Thu, 03 Feb 2022 06:36:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17sm30518154pfl.175.2022.02.03.06.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 06:36:52 -0800 (PST)
Message-ID: <61fbe884.1c69fb81.bddd9.f652@mx.google.com>
Date:   Thu, 03 Feb 2022 06:36:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 147 runs, 1 regressions (v5.15.19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 147 runs, 1 regressions (v5.15.19)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.19/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47cccb1eb2fec6c639261847ff4fea1e2c2656aa =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fbb7abf4a05d94de5d6ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fbb7abf4a05d94de5d6=
ee9
        failing since 13 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =20
