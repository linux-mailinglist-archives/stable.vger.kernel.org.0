Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1F3F106D
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 04:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhHSCiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 22:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbhHSCiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 22:38:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B176C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 19:37:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id nt11so3976072pjb.2
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 19:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yKsD67VdR5ntkGn8XCtmpaCrc4UYLNvPOdckIn1Xmxk=;
        b=Ds/zZtGgke/MOHWdgniupB2v3CEXvIISfBNw0qdz89v+bNOZLVNPTHcyM54Krkw2ww
         rVe1ORxaa+1l8/PNehB8WDXc/4htVeDEbz6lrvKr3ge7B8IC8yq2wJitYhhVw/GaRHHa
         A939LjRD7nrtEfRxL/mcOypVBop96xhyQ5D4CM2bN81/7PnqXe1B9PwVXO+R6VK8IvH9
         UpPb2lgRyvqQIfdwLsDBNi4RpipRJFO9ANBlmPkKKBrlmp5hiuNWIDyF3V320zXyfT8T
         +1yL5m9MFz7j1NkkShfA0XUVAXsu2BU6QrStd3TQeYzdJvwmMpQGUQJsLoulFwWSptKJ
         D+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yKsD67VdR5ntkGn8XCtmpaCrc4UYLNvPOdckIn1Xmxk=;
        b=FYqYsOAjGVC9cqHrmBJTNwwMsuPpmtgVY3lyhLJJFK6/ZBug8V/Di1ujPQDWU8Pphq
         x9NVzXFrbkkucuHYlqWLjfQC5axZwtU2L+iVjhJ7irHSDI8ICRaDexUqR3Fg+bB/IUWy
         Le9eizoRUXwdJ+DmciuRoOaHztXqoGupkl+dxADYiFC9ZsCY60EVS4j6CxIBxueJ5CWU
         fzs2ZoqWBkAl7wBWdRPyE0s5bvwKkYksOEdQOZaouEg1r++CS5XZS5fV240E7jM4gzbs
         E7fTC2nPBROaB2scO4JE/sfXdKEo/m+7F1n/HE3Op5o94ep/9lC42FKvkFMKwmEAFQES
         KXQA==
X-Gm-Message-State: AOAM53058b3Tc/QJtC1NYjOH58L04DjiCo417LodEUimpMIuojpB+gdY
        PslDYmEzb2LSAbszp0WTI5msA+aC3omyOCtI
X-Google-Smtp-Source: ABdhPJwpz/YETTuTUntMOUvOHI1IDbCUeCPh6alxkhMo8dLGq5TcPB3r+nRkoenUZTu0i3mU9XWyvg==
X-Received: by 2002:a17:902:e891:b0:12d:97bf:b2d8 with SMTP id w17-20020a170902e89100b0012d97bfb2d8mr9707643plg.84.1629340648390;
        Wed, 18 Aug 2021 19:37:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t5sm1162152pfd.133.2021.08.18.19.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 19:37:27 -0700 (PDT)
Message-ID: <611dc3e7.1c69fb81.e84cc.5a44@mx.google.com>
Date:   Wed, 18 Aug 2021 19:37:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.60
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 113 runs, 1 regressions (v5.10.60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 113 runs, 1 regressions (v5.10.60)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1043a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.60/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c5bd949b1df3f9fb109107b3d766e2ebabd7238 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1043a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/611d9561536b895e98b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
0/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d9561536b895e98b13=
66f
        new failure (last pass: v5.10.59-99-gf82f3c334fcc) =

 =20
