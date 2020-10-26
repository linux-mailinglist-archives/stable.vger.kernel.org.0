Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8E52989F1
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 11:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768863AbgJZKCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 06:02:14 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:44777 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1747413AbgJZKBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 06:01:13 -0400
Received: by mail-pl1-f170.google.com with SMTP id h2so4489948pll.11
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 03:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/vJYnYAhnKbdtgvm1Q4x2ixfhigF0TgpXuqMnT/2I28=;
        b=VhebU0TpvkcNO9ZxaxZKQ2APMHPYesKzP49sV9Eg3wxQ3ay+3l85cztXKV5+LoOkqD
         QQ+/u1U8hdoTdFoNG5qMkW8BF4PFRci+AQt9Y5trmppkd6QANH+8+VXOXZXcLJJEM9OM
         WOMV5kvjheFJwSQip6ZIiMLgMpgCmb4slL66kbGLKDr/15lIr5yvxFYRDEDD5Q3JqriV
         6lBX0OtHXrV5Hb/cTDuGDia/vlVoXr/lSGuWtdFNUSwzJBA1Z0847dfnYYSmWGjoW4RS
         5n4NkNlCLHFbzdDB5F2DcfNguzOL2C/pUVk7Yu1GcNhvqMjsUtreJwM4nK0+UQBP9dQk
         QYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/vJYnYAhnKbdtgvm1Q4x2ixfhigF0TgpXuqMnT/2I28=;
        b=FKaWc0W2fmZ8nqiezW+2BZ1mZ7uG0wsf9A9jkjJ0pVWPUBVolKQuIuInBhxA4vCFNF
         AQVD104rMppnoy85Ig1iYY6RS/phMXmJFGw6Oz9WUnecOH+fLcARFHaHhSgO8liRK3P2
         0LRjwfycI4jmbqKMJPcS1Gu7KRq8xkEzMPk/lhMk9HWVePwhJyJ+MbAsiHUtre5eH32h
         rb9DTgnB3n16vUVOqhCf+mgyAb1DvOeRaY6VIJTgMxZ6vGhtDgO9pSPVAYMbcYJ1wVSJ
         /SLPyP4+ryfJZ6DOO3+wPTrK4lTQk/omok9SjRwaeFxh0yfpMue/D+FOuoxdGWGlB9kd
         5yng==
X-Gm-Message-State: AOAM5302bKkmthkFxKVQ8JV56Y1xOQo1LDZgyZPXbEW1HYzUP/DJqX7W
        3Zkh3k5fK589n6aLThMhEDiIrOWzkbN/yw==
X-Google-Smtp-Source: ABdhPJzxlu/rWLLHj8/TW4NpUeB314SD4NgoyMKIrjvqXetQ2ZV/kDvJiF9Uo3e16ng1n/25HbOGkw==
X-Received: by 2002:a17:90a:7188:: with SMTP id i8mr19047792pjk.76.1603706471890;
        Mon, 26 Oct 2020 03:01:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e1sm11698094pfd.198.2020.10.26.03.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:01:11 -0700 (PDT)
Message-ID: <5f969e67.1c69fb81.889b3.992c@mx.google.com>
Date:   Mon, 26 Oct 2020 03:01:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-402-g22eb6f319bc6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 197 runs,
 2 regressions (v5.4.72-402-g22eb6f319bc6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 197 runs, 2 regressions (v5.4.72-402-g22eb6f3=
19bc6)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =

stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-402-g22eb6f319bc6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-402-g22eb6f319bc6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22eb6f319bc6a3304a6aae17d3558561e7b690c1 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f966a8ad762ce988e381014

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g22eb6f319bc6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g22eb6f319bc6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f966a8ad762ce988e381=
015
        failing since 1 day (last pass: v5.4.72-24-g088b4440ff14, first fai=
l: v5.4.72-54-g5ae53d8d80cb) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5f966e553667fb3cd1381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g22eb6f319bc6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g22eb6f319bc6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f966e553667fb3cd1381=
013
        new failure (last pass: v5.4.72-54-gc97bc0eb3ef2) =

 =20
