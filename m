Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C1C41805F
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhIYIkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 04:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhIYIkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 04:40:11 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACFCC061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 01:38:37 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w19so18016218oik.10
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 01:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mRGe+pvzuWoAW67DIm8u0JSxMrKeXGkdBx/teR9AfS4=;
        b=YB2NzfoJ9CtcWYeAzU9mihL1UJe2gmEJVAGgbdnPJkcbCJXCTgKL1s7uenaqnmaL3z
         AFKe0PYbjqiVLH6fFA81WBNU65HwBQpT2HBZMBnReqigAZjjzswIS66Cz65SVzYHZXbX
         eywtzzxM1MsJFkGmWjJ1IGQmAFZsuWjoihRRpgzSG2YfUO4wXkg6gBJsyFBEPzeUCraV
         9r2nXMdvK4UGnvV5qfKBCpiTzDvYQEixhV4U4yukUpCMi3/lNHQlztVAUUssTAA/d6zI
         Hw8AaX3GcPAiWiZ4x1UF8XVMUSiIYO1E+cfNP6tZotBy+VhrOiTrra3fma21I76FvHe1
         yMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mRGe+pvzuWoAW67DIm8u0JSxMrKeXGkdBx/teR9AfS4=;
        b=FJmYgiMBQR1cWLPDgW6FS5CzpIGNVTt5zJ96TaXQxiQ+OJGJloJ+RekHuR5j9YFV/z
         yrrctzGhKpHLHkv7En9oHU5+Cfrmjg8nu+ehFIUeaSqg4wkB6ebLf2Dql3ymgC5CfZ5E
         hngfhuXHfxMU/Oa5bwfQe4CpmSGDeIkdbi0i63SNHd2pzyhL2j7V9AFLvA+1mH301Uzr
         SRqRLtIbs7O/Xy7BESKfQcTy+xYwcLPpGeajGn4yLSVkGScBgJHGTx0I8sBLZ3f+yRab
         hWHV6JUVQrWyAh5XXmQzpyMQxqGAi9oycpsOFy/BQAtNjQDSoYQZ/F5F4jydLCsQnI5l
         5uWA==
X-Gm-Message-State: AOAM530g0z/ipqzroinvzvsRxzJAqucPWCi63Uimdksdn17D7IkRIdtN
        lLxI3/Gh+9/890ageI2mprBcjCNQt7qztA6A
X-Google-Smtp-Source: ABdhPJyjVWYkljNDXVutYRp9S9XjMqXkXpYW3Qs2YEOrobbcpVIHrxcfF3JalB8HqPwzODYobwwEYA==
X-Received: by 2002:a17:90b:46c4:: with SMTP id jx4mr1347866pjb.218.1632557330073;
        Sat, 25 Sep 2021 01:08:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v26sm11385872pfm.175.2021.09.25.01.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 01:08:49 -0700 (PDT)
Message-ID: <614ed911.1c69fb81.8436d.3dfd@mx.google.com>
Date:   Sat, 25 Sep 2021 01:08:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283-26-gc89f18a8a381
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 78 runs,
 1 regressions (v4.9.283-26-gc89f18a8a381)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 78 runs, 1 regressions (v4.9.283-26-gc89f18a8=
a381)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.283-26-gc89f18a8a381/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.283-26-gc89f18a8a381
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c89f18a8a38169017dfed0c73e80f46c04eed74e =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/614ea338e350735ae699a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
6-gc89f18a8a381/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
6-gc89f18a8a381/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614ea338e350735ae699a=
2e6
        new failure (last pass: v4.9.283-17-g8597a4a2fe64) =

 =20
