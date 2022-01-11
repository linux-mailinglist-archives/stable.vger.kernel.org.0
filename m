Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE84B48B76E
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 20:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbiAKTiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 14:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbiAKTh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 14:37:59 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA72C06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:37:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so7206108pjf.3
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lz9yN1KPNpuxaGvZEC6t7cmIbR07Yrb1Xst/52aIv8M=;
        b=M5q1TTtJD+R/SFslNwrAp2Mi5u+GjgbktU6b0EYDboYDxxC5PJb6FMH+IaoGbtV1j7
         0KbGs181mpj1VLInV26jQKzm3CZfy6Sm03YuLaaYN5/tYtLWhPaZwjw0VFgCJ8fHNZNF
         BKP4ow1q+rXwy7otD9PPTIjq0LYohdUspee+F05ZoH5Q7OiBNtzg3VeNX08w9JbzBfE+
         8SQgtLACeyOa5n+kZSodmOnYnvoS0i/jWRyshFWimk4MT60K16dvQaobsTGXSr3uHUwX
         KUi+pQVr4Boxve4RI86TJWnShVltCqVGWAiQcNidNq2OJEfr76gkYcPqH87xi+ngcbp6
         F5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lz9yN1KPNpuxaGvZEC6t7cmIbR07Yrb1Xst/52aIv8M=;
        b=WFXd2TgsM3IFYZcGjfTH1VJmTWZGrkzXn144DXPMHuGSJsBbThOMZ5ojUEwCeFcq7l
         4P5wczGeoEkIzekZMZODqGpo0j0fgXHQtJhbAtP2Ak6g6D0Wk3mozFrYF5QQ+WRaMhu2
         cBIHAhFuZyl+jzGk7hgjby9XShSXe1TEq9RRxLiDLlnyHRXLpz42PEIDeX85TYq59MAF
         j2ebZJC8/YYb6jBhI5jS4fucMZhzgRxebJO0wUF0pBFcZ9tyUrLzWUb5Fns7qsbwj29A
         PDc0QqQN3+Z0YqvaVddbEpFWVsKMqC3tZu9wwJbhyBsETXkQgBXw+v+aFCaGoTAtLNYS
         CoFA==
X-Gm-Message-State: AOAM530iNvCK42UQGW5Gvzc+puxFBbVKHLHBo+qPGfE/pYyRchOitJ1o
        XuDJaAC5qMXUDBDx8Q1jE+WSYIiMDEinhhpq
X-Google-Smtp-Source: ABdhPJzjcsD0bhBxVHqzY0egwJ0XLCCDuTThKzY1kk/eQiX+3xot6a81+hSHSCSQix1DQOccnNBCiw==
X-Received: by 2002:a62:5fc4:0:b0:4bb:2472:5147 with SMTP id t187-20020a625fc4000000b004bb24725147mr6085984pfb.74.1641929879281;
        Tue, 11 Jan 2022 11:37:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a1sm11644502pfv.99.2022.01.11.11.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 11:37:59 -0800 (PST)
Message-ID: <61dddc97.1c69fb81.11057.d097@mx.google.com>
Date:   Tue, 11 Jan 2022 11:37:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.13-72-g7fb4d82fc369
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 166 runs,
 1 regressions (v5.15.13-72-g7fb4d82fc369)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 166 runs, 1 regressions (v5.15.13-72-g7fb4d8=
2fc369)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1043a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.13-72-g7fb4d82fc369/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.13-72-g7fb4d82fc369
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7fb4d82fc3691064cde6a2af41bf76ef0ba35678 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1043a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ddadabda47da52bcef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
72-g7fb4d82fc369/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
72-g7fb4d82fc369/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1043a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ddadabda47da52bcef6=
73e
        new failure (last pass: v5.15.11-127-g068f94fff545) =

 =20
