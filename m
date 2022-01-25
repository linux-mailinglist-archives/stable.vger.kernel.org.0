Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5157649BA2C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355987AbiAYRTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450461AbiAYRQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:16:59 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFF4C061775
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 09:16:56 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so2488572pjt.5
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 09:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N5us5rLUmj/vtgUD4Lu24obN9NXCm8RoXiG2J4enXLk=;
        b=MimT4yGukmxXxkIEHJZYS54upUwS/JtAnNKmgR8P61uXQXA7KZ1OTqgM3B3JhmibHb
         zvYXCUPzqT+AXW5cXhwd+lu/sqOzIougaLKWU6xHdvB0E9GngmAFroWzcLZdvqDSF/e/
         ziYmAQaN3vaycSqKqDOU6n0g6PU/LznrzKLIGXvSvZtIhBWcD6yafYMNC2VkP5ue44Ey
         zFZZWi5+gSIqEUAndIBcelGs3pG/wL2wZgL4u95U+VDYd+ncEH85JYl+ZtavP7SGoT05
         1xLi5jdRwrLllzlimNNiMDPxVOEI5ln0ojQVHFErqmiLKZ3mIlXyveimpIbcfmG7Ll+S
         Tcag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N5us5rLUmj/vtgUD4Lu24obN9NXCm8RoXiG2J4enXLk=;
        b=3FX8P8N62e6tRAXEAjBeY8MsnvKYzxU2qQU7WzvAUf5/QZXBE789Sn/d62JumcL+bj
         wimog6x4fhTXS/zgdJEhwejHjFa+F6iEtJcYgcm9vwegHIKoqgsva7NdExMX0fdxcHVO
         B5YTHdSi3YGCLLfM9pSL+bKgl9wRdE59QTyWgGGl4UI1jSl6yotOAtw6W2O47Tsx81HL
         jsCRnXleIIxuUoz4LKvgZlDqpCftojDbRB0cMeBJfWkGSEbGeOjpbFOEysNhDEHGR0gd
         3k6tbehpRA8jVWgBNe61i9iOsKA1tXBuMS8xI7tNALR9+h7YMoQmENQiU+Zjaa7Lh7q1
         UE9Q==
X-Gm-Message-State: AOAM531febENuOKPUKlbIcf3zZLTkKATv9Pbrw7LSEEvDbI5b3UxY3vJ
        cONIRuweYtmGnAV/5ZxuTvQcRzdAlmkRAte8
X-Google-Smtp-Source: ABdhPJwDfnbnwC5AYV3y8x0PqBaFUIWApGp5NEUWpi+7M0Yqfi+T0vvxP9QCVpbqqsuscxj5rSIlQA==
X-Received: by 2002:a17:90a:34cc:: with SMTP id m12mr4612742pjf.24.1643131015920;
        Tue, 25 Jan 2022 09:16:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z14sm15312492pgr.34.2022.01.25.09.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 09:16:55 -0800 (PST)
Message-ID: <61f03087.1c69fb81.7a215.996d@mx.google.com>
Date:   Tue, 25 Jan 2022 09:16:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-1035-g1f6012884c09
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
Subject: stable-rc/linux-5.16.y baseline: 160 runs,
 1 regressions (v5.16.2-1035-g1f6012884c09)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 160 runs, 1 regressions (v5.16.2-1035-g1f6=
012884c09)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.2-1035-g1f6012884c09/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.2-1035-g1f6012884c09
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1f6012884c09eddb494a6fd10c42ae1037eaefb0 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61eff9890e46a4073babbd98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
-1035-g1f6012884c09/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
-1035-g1f6012884c09/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eff9890e46a4073babb=
d99
        failing since 0 day (last pass: v5.16.2, first fail: v5.16.2-1041-g=
bb0f7c24685b) =

 =20
