Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF0332BC12
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383041AbhCCNj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244759AbhCCCqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 21:46:30 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A2DC06178B
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 18:33:47 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id c16so3724724ply.0
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 18:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iln/ltWff4SCKUqn7xW8l9AAM0eu+Bjf5raHKlWjzQA=;
        b=uokK2fEHFamHs9brbKt2KMfaG/+Ii/Gbc3P9eAjBqW8NDDOTLok1VEM/+dym6ZP2J6
         ap4hLRI/ptKLqVw3Ts0IC9bmvC9sX1yYT6N5bOjU2Hd6CGxuqKcdDDfPCNqrAm2KrNcR
         eIzgQCRSl73MQ3hcQrIOxVYEq2+LOi7G5z7f+hsThinWKHnXIe5HUzomD0Dn0iQURNF5
         Tve+i7v2EhekEb/SurxlU8LTb6lFftLMAm1uV+DTzmoiDZ4cVYhTmmefpFZAAVKZBFEV
         +CYed2sG3xwiiTFMgYDa4O20BK+nC4Ricr6ya7ksqiJZ3jqJ/cx2nc7bV1tqwXPzxknD
         x3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iln/ltWff4SCKUqn7xW8l9AAM0eu+Bjf5raHKlWjzQA=;
        b=IbtSXRBksMncDG1du+0ezI4gT58sgQMWwuR0Z76WaXe7eEgvPc/1AKaqaP6IJClBFh
         6rIwBH5+GorzKTjDw6Fo8n0kkeqU9mNCLtucn1TCMhk7WZ2yxB+O/kAoypidw3vbQq4H
         Rs3q2awRnretoSfsWTu5To5165xVQcIXhOoaVfFTs6ecm6tYiq6PZfk7o0mfQxOqKiE8
         9sRqyxj7sWshZLezTzwvwQlC7gMuuOIf1ATA827ISRx9Jxv0AWAXGDuuOh+HFAg+5Ae1
         HbR4DerE//7pVEqx+NAmwPHF6lzzeBT1VT0aFuFD+12jiDOrWtC1eOx1aD1QWi2XqbFM
         rI9A==
X-Gm-Message-State: AOAM5306NK4DfE/c/kvS/AjKUMRk4sXHHLHF74ncJcAUf8+JkERhE+KV
        cxB8Kl3ESx5u4CmDHePtzBeeh4peCNN3+A==
X-Google-Smtp-Source: ABdhPJxzuUTJrWKCEifEhDWE8yI1/WWJ/2vpd1ayenLEAkQ64q3bXK3Q0JwnKMO51V5Zd/nWWswZVg==
X-Received: by 2002:a17:90b:4a50:: with SMTP id lb16mr7322693pjb.188.1614738825648;
        Tue, 02 Mar 2021 18:33:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b3sm4619232pjh.22.2021.03.02.18.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 18:33:45 -0800 (PST)
Message-ID: <603ef589.1c69fb81.17fdf.ac13@mx.google.com>
Date:   Tue, 02 Mar 2021 18:33:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-655-g196c153de60fe
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 87 runs,
 1 regressions (v5.10.19-655-g196c153de60fe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 87 runs, 1 regressions (v5.10.19-655-g196c15=
3de60fe)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.19-655-g196c153de60fe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.19-655-g196c153de60fe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      196c153de60fe1068903493924bfe02ea38f3835 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603ec60ba64e8ec64daddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
655-g196c153de60fe/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
655-g196c153de60fe/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ec60ba64e8ec64dadd=
cb2
        failing since 0 day (last pass: v5.10.19-658-g156997432be5, first f=
ail: v5.10.19-657-g84fa1f13a46b7) =

 =20
