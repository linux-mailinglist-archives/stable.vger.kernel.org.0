Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758183A85E8
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhFOQDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 12:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhFOQDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 12:03:03 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A35BC08ED8D
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 08:57:22 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id q25so13602849pfh.7
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 08:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WD5J3sc3v6dxK0XaqIoSoHOWpYNoEwLJIrmzHgNx6so=;
        b=j4pJRpqKIHdFIM7TDhyoVDGqM4BlRTslEZYZrmb3AKWmb2tWKzXb1KRngcRv3EfdsS
         a7aU0ZTVs2TnLWzVjQEQxXBzrzJCTLORzqeNik8L/L35tTcyMDxneeRt8AeSUoTATkm0
         yffgEyf8T3QgcB+v0OaiWbjl3lTp0ovfg9IJQ6ToR5Mew/K07kN0Rj1S8X3QiWJh0i7Y
         E/MfsNJ06fsqtmuZ3FzgRB5lG+ZxSTcyH+lEe1+5IkZw+xh5LI5p07MM6guYsLaL53zM
         eknltMMjE4B8IfLm19L519Ao1n/HwVek9phqpX2RPsj1SYOc1BYgGbso1fUb7hTy1DKG
         xWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WD5J3sc3v6dxK0XaqIoSoHOWpYNoEwLJIrmzHgNx6so=;
        b=HI6P8K1jz7jODnnoc1yKFwvb2xOePF9fCEDE6gooKpNT3Tl21m1ZGbE3s+RCvE93Rs
         DIURIfr2W0f5+ObAdpZtVL2bXevh5zPZlMG0gP9+iQD22CNkkwWE8XdeUh7n31f3JkQ7
         CoHXgfNJgxfF5nwChkRXJfRK0/P0iP0kTdNqAdnXezYSSoPbE3iJ7vvu6ozrxunNP8sV
         vUH6UtnfOOWndu4VKynyu39BZel/OwuDwjz9OEIiOREdkpA6IAySN84cLCQjM5geah0b
         DQwJE+7IPtqb/DgNTn/7GB9wx+g3k3JHSvj/dV09AIc1bwUfVYX1OCArOoxS+fnYMlq8
         /axg==
X-Gm-Message-State: AOAM531uvRV4ZLa/o31SHI/GF0v7Rzs7oJBkAVspbmT6nkJm6re3uRRN
        FcvLPy5s2lnWaiTRJCZV/uzKfpYX83MgdQ==
X-Google-Smtp-Source: ABdhPJzl4p/maEXNJ7yvqyafC0dZue3GUIGmVW8GkqADC8kEcHSBCAWiRcKFghyibwizsVl3eF5SFw==
X-Received: by 2002:a63:5760:: with SMTP id h32mr157581pgm.367.1623772641986;
        Tue, 15 Jun 2021 08:57:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e15sm10937685pgu.54.2021.06.15.08.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:57:21 -0700 (PDT)
Message-ID: <60c8cde1.1c69fb81.9490d.ddf9@mx.google.com>
Date:   Tue, 15 Jun 2021 08:57:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.43-129-ga148e2a9c327
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 175 runs,
 1 regressions (v5.10.43-129-ga148e2a9c327)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 175 runs, 1 regressions (v5.10.43-129-ga148e=
2a9c327)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.43-129-ga148e2a9c327/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.43-129-ga148e2a9c327
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a148e2a9c3270ebd47453ff0df2179f88e0156dc =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c89aa84b2b992016413273

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
129-ga148e2a9c327/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
129-ga148e2a9c327/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c89aa84b2b992016413=
274
        new failure (last pass: v5.10.43-44-g71862092cb77) =

 =20
