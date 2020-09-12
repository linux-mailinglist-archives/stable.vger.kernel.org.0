Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6A8267C98
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 23:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgILVrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 17:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgILVrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 17:47:46 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6362DC061573
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 14:47:46 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id y1so2415794pgk.8
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 14:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k2nOquKaM+3snxsRJg5C8oWtHzUgLNH/DbVWfDVcyV0=;
        b=2JcAg3lsNfjERPyWbbV5qClnnE05BnczIOJOMyf7TmNAL+49F+bju8SH7Qj0xkKNpD
         UjtiZoH/OL+2zSm6tmkq+Uajd/JBFVtVxwBR0EvqukRrHAOJ1hcFI4RKk9cbPSFJ8M/6
         iPAxIvYDFE7AsaV1h5Y/nammL6wUEJPCg3naC3TQWtnVhXG+iAP9EgJ8iW0rhy34q8AB
         1+38ip+yUtqBYv5xalewJAodoKAmwZePGEJYC4HOBeKR6pO28Rnw5UFswvzE9eiitfie
         U438unpitcRfX9OwYuLJAcWijE6OtNGBzZjF90EF8hMAICBSgR8fnQZhkJhxAn2nBSR2
         ASmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k2nOquKaM+3snxsRJg5C8oWtHzUgLNH/DbVWfDVcyV0=;
        b=t7lldPwj1YhjZBMlByG6ZvOv/Jm4UMODPnGrieJWc7hTzs3oeEQaz9p62wZHmTQNoq
         i8uKxgVrzSM16g9I2jLcL/KuEpcC2pOBzlZ9hgu8riLPg+bGB0SEqPtKpfnx1mBGVVNN
         kND3ixLooKqNWTacaLJbTp2IgWyUiFrGRXaUv6aQwE1wocc9t3MfWH19F7MZ+k3wMos/
         GVbPQWTtJV/2v74RrCzurkcORmqAca/fgJHzDvFCZkSQK5lSiz3rdrZPSNAdSwI5augl
         l/N+WWIKXl9kriYNCsDcP2jYR+38zgwijE9SfpdHAkmYVPIJsq2nvNla2a5WPmh6rNoy
         /aug==
X-Gm-Message-State: AOAM530M+U1JpAdhkx9i+HxOlUjVdNr67XZmf479XS4y4aaq0uqywElJ
        bjnIQHLia261cGA0vSOL+PkMDirrlV9KlQ==
X-Google-Smtp-Source: ABdhPJxRJM1hDCNAN0Xwb7RaRCioj4zPeONmYyjXfO/Sa5K+rtbxBh4UrnYK9FIPRn8mGEhJKsHerQ==
X-Received: by 2002:aa7:8756:: with SMTP id g22mr7717074pfo.37.1599947265443;
        Sat, 12 Sep 2020 14:47:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z22sm7444591pjq.2.2020.09.12.14.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 14:47:44 -0700 (PDT)
Message-ID: <5f5d4200.1c69fb81.5234a.ff38@mx.google.com>
Date:   Sat, 12 Sep 2020 14:47:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.198
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 147 runs, 1 regressions (v4.14.198)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 147 runs, 1 regressions (v4.14.198)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.198/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.198
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cbfa1702aaf69b2311ea1b35e04f113c48368c67 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f5d0e2ca93b7e93fba6093b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
98/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f5d0e2ca93b7e93fba60=
93c
      failing since 165 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
