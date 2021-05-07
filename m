Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886A2376A94
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 21:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhEGTRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 15:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhEGTRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 15:17:19 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5301FC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 12:16:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id p12so7941647pgj.10
        for <stable@vger.kernel.org>; Fri, 07 May 2021 12:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JDz7CPFiDY9mNBRAMwdwT5HAAx8CDxVabVskb+CnaAs=;
        b=cL1SV54m1dvcX7lQhXkJTnT7uN9Q68qySLJ4SqDo+CMFueWycR3Jr/YUX4B3LDjcgz
         RovqyiztyJPuxxA5Sg/KUFPiwdPjZANieKHOasjSEgzHtN3tSS7V2QdZ1SeFsMPQm1OX
         nB57oSJcjY+PGLFR/vf2nTHatMuRl9sXKrlXmKK0/1O2ACP9GAii8IjLFHgN0hEuT63u
         Rcf8+c9gQDyxWp4GwI0aYLFZbjvyRMy+lcNE+EUKPa3KKAhB06qSXpS9qudKYxdGt1zL
         DlZlMDruLVhfFzypsxVzQG2AOutJSinkbZcf+vSzpGZvU+3P40t2O07nQIib5mtuwSp1
         kIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JDz7CPFiDY9mNBRAMwdwT5HAAx8CDxVabVskb+CnaAs=;
        b=oKtMgRn2kPbTvIUmoLtNIfjk7Vkwgw6km6HBKOcfqn70hUK46l/cNGohUfUtbo1mUG
         d4rjen+21ZLtcyE9AzMFyOmiREnKSkWcB0OplRXk4aAgS1W2aX3648lKV1CtQ+Ixc73R
         pYWHAkhTms8GVqWBLF776g1/nYxfE8Pn2v83OBAwPIFYyCXjQPooPqBnSeRLHjQzXV/C
         QofYHy2uxD6rdek+3JjcZKX8ujPG4Rmx9ThvsI/pLubDdnsnQTIeePOr1WcCqPRFJ+0f
         M711e37XuFRy1U47cwf3rt9i6FddB5JI9WTrbTsrSZ2hDZDSltwx7BBKfPIGmnFI4fUM
         8PAw==
X-Gm-Message-State: AOAM533jAaUSj0kUnvn5930w8oKcfxfBMkczDY0Ao3BvJCuo9e1vVAOC
        gzN+GKxu/Fvu+7WrtKIJg6buYZgSD/dE76IX
X-Google-Smtp-Source: ABdhPJw/iAfN/tW4OQorD0lZzp7yLCYwUTZWfB2N0iSpXEPi9BR14Wp2rz57f4WXxVfBKQfafvT2eA==
X-Received: by 2002:a63:bf4e:: with SMTP id i14mr11571613pgo.277.1620414978645;
        Fri, 07 May 2021 12:16:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v15sm5330345pgc.57.2021.05.07.12.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 12:16:18 -0700 (PDT)
Message-ID: <60959202.1c69fb81.e2309.fcc2@mx.google.com>
Date:   Fri, 07 May 2021 12:16:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-48-gd53cc5ac4f922
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 123 runs,
 1 regressions (v5.11.19-48-gd53cc5ac4f922)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 123 runs, 1 regressions (v5.11.19-48-gd53cc5=
ac4f922)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-48-gd53cc5ac4f922/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-48-gd53cc5ac4f922
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d53cc5ac4f9220da3d38d10e8feb8daf3ff4b798 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60956108970de3248e6f5470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
48-gd53cc5ac4f922/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
48-gd53cc5ac4f922/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60956108970de3248e6f5=
471
        failing since 0 day (last pass: v5.11.18-29-g6c2ae64a2a728, first f=
ail: v5.11.18-30-g4232ce7a02cc) =

 =20
