Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE60447395
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 16:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhKGPrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 10:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbhKGPrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 10:47:46 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82264C061570
        for <stable@vger.kernel.org>; Sun,  7 Nov 2021 07:45:03 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso6909490pjb.2
        for <stable@vger.kernel.org>; Sun, 07 Nov 2021 07:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ST52SZnd3dqNScOOBUBSg1BmWUuMlWJuUBKiOtLoZDI=;
        b=Yy+qJTY02FI/RHVMKz7ka9rYIGEoGJ5ZdFYIwmuIxAbPxBpuHzqRls+4kOgliwZXit
         55qbGkbvfVPPbFAObCF8jpIDzRNGLuFKyUzFqAkf/bWvh0FxPy8tPcE25IdGueSqxRGA
         u+FZ8LfC/sENMIKTocj8xizg7h/iu/s2A4qAoGsLHYHjY7GMICV8aZiNqjEYl+bvIlIm
         0CDBekOFp+dHyFap+gYW4asRw6N6aEsj15WQXmUNzkvwL2+9UWEZcCbGJ/CKw0J/X5Cy
         RP4PnC3jJuBbYn7+pHSS+HuNH5s1ndlFVuBa4yMTRdSUdR4ELbSU166jnP2Q6af2WU6u
         0nhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ST52SZnd3dqNScOOBUBSg1BmWUuMlWJuUBKiOtLoZDI=;
        b=F582zc4SP2lxvnjETAzL1H7g4qzZ1APPULF9g1LPgb2ZFUF82I1f01Adq2CTwG1r8I
         aN1l/o5jCtE/a27Pv48Gt4eKqS9elTQ0xxwvLaYgCwMP5sjXwKH1GRMgKWpvS/Rys9ku
         WXlGerqPdGNPmbQKCPU73BScopOXXo1Bl/V+C2rj5mbeW4lTaJx+bVYLLXZZC8MaJiWJ
         YbRyi1ovMMJsjeaUXMbPhKMTpyNs7ACBSvGNPsMHgrf5AhORoxR4Hq0Mbs+JuEY+Fuy0
         k28NlHS6/2uwMf5HS23i0NK7K6umMxqreX6pCNqHhN+iobdJtdHhXw4UDX+NuOKfdH2R
         2IJw==
X-Gm-Message-State: AOAM5302EasrA2DnOJxRyBcVXg0CTGME9F9rco/e5fZkPD45yhy2TsRj
        oYXthzvL99MRf+ODboALI0OqrNH6L8zQRaWz
X-Google-Smtp-Source: ABdhPJxxL9L+skJC18uNt1hbOP/JPl6FqUX7hx7K73WaCctd+tl789r7qVpR6aYFVa7xnvx0fCOZQw==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr45259236pjg.118.1636299902968;
        Sun, 07 Nov 2021 07:45:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm13183845pfu.189.2021.11.07.07.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 07:45:02 -0800 (PST)
Message-ID: <6187f47e.1c69fb81.a6d68.93c1@mx.google.com>
Date:   Sun, 07 Nov 2021 07:45:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.158
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 154 runs, 1 regressions (v5.4.158)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 154 runs, 1 regressions (v5.4.158)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1043a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.158/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.158
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c65356f0f7268b1260dd64415c2145e73640872e =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1043a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6187bd78157e880f503358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.158=
/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.158=
/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1043a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6187bd78157e880f50335=
8dd
        new failure (last pass: v5.4.157-10-gf4b30ec46603) =

 =20
