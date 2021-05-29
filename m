Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2FE394A73
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 06:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhE2E6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 00:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhE2E6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 00:58:18 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F97C061574
        for <stable@vger.kernel.org>; Fri, 28 May 2021 21:56:42 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y202so4780866pfc.6
        for <stable@vger.kernel.org>; Fri, 28 May 2021 21:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vbNSszM7Dmv8I/eNxIIKiub2TMnWlfK8nhaJrqg6iI4=;
        b=zvtXbJmClTyLLnISX3G+MU2GJJgbGbQhRMHZurLFkUbhNZqxlEMimiyvdHmwB3rEig
         fp6xOCXWKqJPkOTRtqQPmFJuE/7pEj+iknUhylzcfU/e24Unxvb0ZuI7tVTu5Zt1cO2J
         zjWolzxUn/jiFSfvj68yvrsn1EMhpKgQ5GMzYUtCrD+9WFbkvQLGR+3zKV7kt6A0ilPR
         BlHzfgpNIGq1Ve5irsDgpR0RrR5fMHNowvuhuJ6xBzaBrsQMfIOVrCfEEHjEIpeoy7Vt
         9m/eNjcZF7jWgPBc8Ht59Y/wmDiZE6YlgQ26wm9wUgoOa0fc8/OdBACdJCMeoEUS6gHw
         bXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vbNSszM7Dmv8I/eNxIIKiub2TMnWlfK8nhaJrqg6iI4=;
        b=QA/o6DTlBAd2KAIImg6ObPB/R1Vw+p1i8BDmykosM86DoV3YYNjKfl0g/0IYGmyLB9
         4kY6jfrFDpo8ldZxImwd2HdrBs9Pjy7QOTl7DNpE87FsL0hdIf1talk/koBRAQ8rcXUb
         zJ5o/dpCipegekC0hwUaAsbUXUrUPqhzZtTXcki7LJfhXZnTNMTpoZNYNWdcphZkZcEH
         Bh+9pBD6VTcuGfeoGqraJYBY1OX/C1tU3GZckhzSDXadNEHWpfI7V00M9SpFhKHo6C0g
         33q0c+KLGfbr8hljbY1pUyT1k3A2yd7xduDh6VLqmVc47A8RTQsgSUvoZGQy0CSk9+uB
         NGpg==
X-Gm-Message-State: AOAM533v+o37/tWTB8CV5QueC/f1iFwsH0VQTkeT5fJtDxrStuQX2khl
        lKRFJUBY9dzsH93ogHDZ7W6yadGbA4l9lu+n
X-Google-Smtp-Source: ABdhPJxeHBroRawOuKJVahkKJCrmJGcrg5j/Mw3L9tpoJ2eAXdNMjcp8IVd3VT/Wa1VFZwwCNDhYzg==
X-Received: by 2002:a65:4d0a:: with SMTP id i10mr12438976pgt.86.1622264201358;
        Fri, 28 May 2021 21:56:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p14sm6207889pgb.2.2021.05.28.21.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 21:56:41 -0700 (PDT)
Message-ID: <60b1c989.1c69fb81.9ee8d.5768@mx.google.com>
Date:   Fri, 28 May 2021 21:56:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.41
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 134 runs, 1 regressions (v5.10.41)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 134 runs, 1 regressions (v5.10.41)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.41/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.41
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      33069919e2dce440d3b8cd101b18f37bb35bdddf =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b191b942da99cf7ab3afc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.41/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.41/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b191b942da99cf7ab3a=
fc4
        new failure (last pass: v5.10.40) =

 =20
