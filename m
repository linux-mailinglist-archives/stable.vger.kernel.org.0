Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFE01F1052
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 01:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgFGXJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 19:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgFGXJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 19:09:04 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B353C061A0E
        for <stable@vger.kernel.org>; Sun,  7 Jun 2020 16:09:03 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t7so7914368pgt.3
        for <stable@vger.kernel.org>; Sun, 07 Jun 2020 16:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4/nmS/tTEcjuVS1A1Xwj6lksGRM2X2JWNYVsMAnUDOQ=;
        b=1YYXAVV9rwlpoIo+wYob3GklfZ6SOiHBK73HbYtjOuIukObmC9ymH0qetZkZI1J0Kb
         DPcHBi9r2V5UezDZWyux48x42gBwDFRi5Aj59ihWBXHAfKi/xbeGrAqTS8gTejcsdYl1
         W4AWzw6+FWfnhyyBLgQ9m0oqge96acOPPJtuA5d5vHI73Rb41lSijcWCtMTWk+DEN4/x
         Tt8yiirbb1G/tNiOYXTIyZ8/0ySQPEkBQWN/2EEdAH/6fXsO/3b4NaZomv8/WLwu6PA3
         yZg7pQG2TV2WsQxnM5geldMgeYEpj1bl1mBmTaX/UUXcHS3qFRMbi7Othm0fTOd0uxk8
         V1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4/nmS/tTEcjuVS1A1Xwj6lksGRM2X2JWNYVsMAnUDOQ=;
        b=N0P7knqCrchbC26Pz18tsv5x8Tb2UIK43Ba4kUzVYNQjyTEn5w3IsyHxs2PuXlb2Yf
         bRA0fAsyRDhpG2hHMaR1M8VdHq6/hYKI1sOqPPJWgoC/BcR8JsaiomcpEBbE6UyOCKoh
         Wk8g/3hMWD5C0XzVJ0idBp8YR52cprbrV8kJVSxj9bqpiu4qoG/OgC9e42wCkzeqSalM
         8SmNmFKdTtK8pKTZRTMjBc0oRsLgxa714LHv3rDVu/wG28GtqsB9DosnbLvPwuOdaXmG
         +FGoveISrrW4bvVsJlUeBsaJYBz6J1XWmRmbNSti3m6RJv6F8DXlwkM5n/SV16K/G6Sc
         S7KA==
X-Gm-Message-State: AOAM532qIwNgdwGlb0UwzycKFWLWE5fvKgH+xoMOy7bibUGeBT0EnOdS
        CouLjOpFvtQ24EUjZlX9EECkd7A6AIg=
X-Google-Smtp-Source: ABdhPJz4Am/UUNN5pSM30QLWZfXYsr1dd6gGma2ZowNP6vfb/P1kFzRmT4HoboWieFv17LurcLwsZQ==
X-Received: by 2002:aa7:8ad0:: with SMTP id b16mr18254704pfd.129.1591571341485;
        Sun, 07 Jun 2020 16:09:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d5sm5241564pjo.20.2020.06.07.16.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 16:09:00 -0700 (PDT)
Message-ID: <5edd738c.1c69fb81.b1532.482d@mx.google.com>
Date:   Sun, 07 Jun 2020 16:09:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.226-28-g5c827e437dec
Subject: stable-rc/linux-4.9.y baseline: 48 runs,
 1 regressions (v4.9.226-28-g5c827e437dec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 48 runs, 1 regressions (v4.9.226-28-g5c827e=
437dec)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig      | results
----------+------+--------------+----------+----------------+--------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.226-28-g5c827e437dec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.226-28-g5c827e437dec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c827e437dec37754d5f78bfb6a4acc09b41ca7a =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig      | results
----------+------+--------------+----------+----------------+--------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5edd3bafc51932133497bf24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.226=
-28-g5c827e437dec/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.226=
-28-g5c827e437dec/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5edd3bafc51932133497b=
f25
      new failure (last pass: v4.9.226-22-g086836244f62) =20
