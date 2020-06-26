Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2878D20AB85
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 06:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbgFZEzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 00:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFZEzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 00:55:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A579C08C5C1
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 21:55:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l6so1399616pjq.1
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 21:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fu70NoWPlASWBrJKXVj4qqIWRB1YvS0afQe7Cyl/OPk=;
        b=l3+A9npzATtfi/xZFCtKgW2wqrG47mftf8A4ZAj+8xvkUq5FNvCPp1dri7lm7XSCcc
         /229PsIGs9O9rc97Ge5O1PqVj2u6xLTjwVbQzcwA/Be/Wf6aafEvcismi8BfHtm3FD/j
         xgjPzLKhZik8HLL5IAL1R5Z0q+fcV+ZSIzBOc6lwUNl3Y4rXASJuyLD8hGmHKFyLpgDT
         Zafl/bk3AQUXpWiaK3Q4VlzK1a45qgDzDL02KoHHTyJYuoPPckkrMTzqi05rChr4RxdO
         rubMiLe/wPsfdXBb1NsdNAC+okYAaKLc6aFGgo7Na5bcbYhfGpg8zheRQSBEueHnvDdT
         x8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fu70NoWPlASWBrJKXVj4qqIWRB1YvS0afQe7Cyl/OPk=;
        b=OqIhTLT27YDMU7/dUc8NdITeOJ8CBIeBooJmXl5fp6dCgEFksRr/3nvINPQVZ2L5vJ
         X66nAcq+VnxwavnXIOrc9nIwxbtYUBMcLqZEf5Mvq8bP8q2XKKSKKS8MP56s2RAjiSoB
         uD5GC4m8uT/bKMq+8qWLk+YTZQHG6FFBqeGlAacJQ05ljQ5JIsxktroMApBmlI+qDJk4
         awChsSbdpSByCtWMoKuGo2ge620DPqR5IHDRnC7KNs1rnXF5nO7sXtwBQtq91BUvUk8Y
         KER8b2Ba5hSVCyVCqItmif3mrHSE8Ppyk2JdSSfG4YcoSc29PjmLNTvlmc/R8P0UFlml
         ePZg==
X-Gm-Message-State: AOAM533/Y3aFbdlpQKW4RYWo2D4sWxCw6Bd6eEYXRIHTXNrLEAABE/6u
        BH+68OMQJ/YlXp3Hx03kvm/VCR0DtCQ=
X-Google-Smtp-Source: ABdhPJzXd3NMGCcdFB9MaJvtTKB6TFJqQGaHjws9ujZ5K6G9vB5ZEauGFTqvwM7+qWF4FMW4Df0DJA==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr1388965pjq.44.1593147300733;
        Thu, 25 Jun 2020 21:55:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z9sm9773108pjr.39.2020.06.25.21.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 21:55:00 -0700 (PDT)
Message-ID: <5ef57fa4.1c69fb81.77411.cacd@mx.google.com>
Date:   Thu, 25 Jun 2020 21:55:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.130
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 76 runs, 1 regressions (v4.19.130)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 76 runs, 1 regressions (v4.19.130)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.130/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.130
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a39e75458e1ceb7fefaa3a0bd9df21558713cf0d =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ef54d7992764ded9485bb1c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
30/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
30/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ef54d7992764ded=
9485bb1f
      new failure (last pass: v4.19.129-208-ge864f43593cc)
      1 lines =20
