Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CB23F9D83
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 19:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbhH0RRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 13:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbhH0RRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 13:17:51 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE13C061757
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 10:17:02 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h1so4994502pjs.2
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 10:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XENFdG3azr5hmKnTvphDVMMAHI5xBhC2ar5s6zxWTIM=;
        b=cEdYmZ5dIK2zm8JO77+rXncGIKQXbmtR7cTEVcdMboZLEAaEiGhP/r1RAB+YJ60LZR
         q6PvLJb8qqnHqZZqmovXZ3UHOxbsQCHp3OkoO3cVPmKntSMUHkEoeJ+CAk6fVQP3o9DY
         TR+sgWb/QwNGHZsIKQG2i36sOekEpsBgatyQ65GnPVMuw8RGJJsPBUm7YkQ+WGexYA9z
         uiC3CmpNImISzMUzNGMFyjVEz5SzHvmKb2U1Mwc25ynkTJJ50TEiGpGsPrTJ2I2B7RpH
         qtEI9yXMyz67U57CMgqm1nz7TlpcRb7k3vk5H7MKYPg6ywLVf/eh9ANiKPxuElQ6CZEC
         Jo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XENFdG3azr5hmKnTvphDVMMAHI5xBhC2ar5s6zxWTIM=;
        b=B7MFjE6p1tRmF/hK7Mie/0KtVKaio2eCtWjSc9wpl+MIfQBYICl089V6om8gqpwKne
         uVZ0TrjxG7I6Ks0EOtvRZzlI1zbiQScCEitHa2aortyJX/LgUewI5rE7AyJHqQNEG7Dm
         vmFrWxMNKSCgM0gTmH7kOqH0yz0n2ogbyDezdmLTD2Hu3CLruHeJYcvErIutG5OKSuIf
         dxzN0Wl+cj0h34HET5jgSy2CpesOs2JlXnbCwoMDClN3SlyegYOsNrk0E/b+NnTfEdx2
         LBhzIyDUYK8SHGMfEaRvoZ91Kj+l1o0D2x9MAgnErbdcNEP+hV3lKx0QwroloTnbfPCv
         ZBCA==
X-Gm-Message-State: AOAM531f+6K1GX1uh1NpmGXericprt1XLDl6l/bCpX8tnOzKuWVXEeJR
        PBAXvqqRW4mNsY3BxAm02Rmjf4wabcnhTy0f
X-Google-Smtp-Source: ABdhPJyF1PVsWgp8W6mvJeuzg1qzKEFV7KrQS48s9P4o9apAUgS45MIYYsuQ5xxRICwr9TBSycsb3g==
X-Received: by 2002:a17:90a:2e88:: with SMTP id r8mr24107120pjd.169.1630084622009;
        Fri, 27 Aug 2021 10:17:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm5572345pjs.2.2021.08.27.10.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 10:17:01 -0700 (PDT)
Message-ID: <61291e0d.1c69fb81.d8fde.f1cb@mx.google.com>
Date:   Fri, 27 Aug 2021 10:17:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.143-1-g6df473a6c1d2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 171 runs,
 1 regressions (v5.4.143-1-g6df473a6c1d2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 171 runs, 1 regressions (v5.4.143-1-g6df473a6=
c1d2)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.143-1-g6df473a6c1d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.143-1-g6df473a6c1d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6df473a6c1d23bfb6aa03dcadf30a9f618f3fce8 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6128ee304735fffa9e8e2c90

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-1=
-g6df473a6c1d2/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-1=
-g6df473a6c1d2/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128ee304735fffa9e8e2=
c91
        new failure (last pass: v5.4.142-60-g61b23c28325a) =

 =20
