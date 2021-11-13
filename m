Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F96944F4A3
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 19:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhKMSzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 13:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbhKMSzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 13:55:17 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A972EC061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 10:52:24 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id t21so11074783plr.6
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 10:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jrtN5iZMnQPrTvRC71h3PwHajPFW2za+nf9KE7pXKSc=;
        b=qVI++x8/U4+BnGfTCXLyvZ/PYShl/11cC9BXd732dnqxboeFe6E0e8SekgrfC7Zd1x
         CglgK7MN+pgnPq+prCoEdqlRspzyGob6gsyEl66qWEQfI4QvH76b2T2CPCGjq+vGAmn0
         JjIaDp+eOaMcsA4BBrulA7vY7u4+1snuTzr7PVKjhFCeebx7Ixx/QOgeruHzAGsTlojX
         ijKd7w2/8C1jlRGb1LNRhICtdE11YF9pfig/qR7BWBMS2LPXBUvmMNNjIM2jU0dcWaDe
         PziJqhDDX4Rrmk3VKLCiaVh2PLD/6QtnLis5Ed3o9dBMxNvgagnEsqSd1OdlWjbcBEs1
         L4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jrtN5iZMnQPrTvRC71h3PwHajPFW2za+nf9KE7pXKSc=;
        b=t4ikShV4j18txYDGIF+WMTR6SuvRDvIL668cnVXmf2s4Zj1iD0TtPYpOoPyRNbGv4a
         p+uJYxZrxIsh32G/wUsv5bfMKuVVe4OTARlHcVbokAcbFpZbEINfxNM2jjtQFt+GaJNL
         FSy+HN/i5a+pngRtVNaeF9Q3adcQHopO0nxUGiSYD+E1EKlHzZCnXs/dzcpfLsrazDrV
         oFZQq5RRx17SYeb3HKSs+3zwniJr+alxcC8jC6RhsTd2Eq2NJCIbMFqFSPNWH2hbPiN9
         NX8pIeAcIBgi6hUdmLpfDoUnPRHSE8cW3Cc8nKGXREESwMU1xtU77eA+F1eQbP39xBt5
         N58w==
X-Gm-Message-State: AOAM531m7+uPfLKEpVW6Gi6ildbG5V9bIJnBEBCK2YvoH1IJVgM8pFVq
        KfUmV6R60TdsLtpxoTycRu7SwuQKTr0+mfcc
X-Google-Smtp-Source: ABdhPJyjQP0PgOpsqd1JB9h7ckkfl9yNblGkYNG6IxJVyzb870L2OG2pflb4gBlnxx7w0SKydklsDQ==
X-Received: by 2002:a17:902:ab0c:b0:142:343d:4548 with SMTP id ik12-20020a170902ab0c00b00142343d4548mr19379615plb.14.1636829544059;
        Sat, 13 Nov 2021 10:52:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g21sm10275365pfc.95.2021.11.13.10.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 10:52:23 -0800 (PST)
Message-ID: <61900967.1c69fb81.a3b2c.cde7@mx.google.com>
Date:   Sat, 13 Nov 2021 10:52:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-23-g2301bf456508
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 73 runs,
 1 regressions (v4.4.292-23-g2301bf456508)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 73 runs, 1 regressions (v4.4.292-23-g2301bf45=
6508)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-23-g2301bf456508/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-23-g2301bf456508
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2301bf45650805fad02ed6a14b8532893e09fc40 =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618fd097c7c3633bd3335907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-2=
3-g2301bf456508/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-2=
3-g2301bf456508/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618fd097c7c3633bd3335=
908
        new failure (last pass: v4.4.291-23-g317280d595748) =

 =20
