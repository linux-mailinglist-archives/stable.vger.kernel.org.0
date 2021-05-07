Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF882376745
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbhEGOxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 10:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbhEGOxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 10:53:30 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE82C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 07:52:30 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h127so7762309pfe.9
        for <stable@vger.kernel.org>; Fri, 07 May 2021 07:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sptBjbJGRtzWzEPPaxat6zR5VmoxyEFs1+fa8slXzCg=;
        b=w5zFfLgM0WHLm+mJ4LvBKccnzlqhnFXtp/bAKvUd0hU0Mn8LUmUDq5IEHiyxT7gkFM
         Iw5998YtTWsbDsjOAdjMa7GYdWNRndNOXoUKedqMZN0HHhPcbSo7Z4f9lgpsMPFhrcwg
         YEdzQ/t9CCXQNqnMxCgLfqWp2Sc9wbh72MYXnqlMPRwxQmP5TExBUsDu4NrGNo3WKTx6
         vRQF/Cg8MzcpiuYCLcnkgeTfIsJanIJsb2mCJMgIQMv2Oka/99NLvAwzIZyCj5CRRBEh
         t6PaYKrwQddI59Rene+P80G3rmurBY7xff4Ju9OO2B2GT9LuY43XidDdDItUqCBKmN8B
         nQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sptBjbJGRtzWzEPPaxat6zR5VmoxyEFs1+fa8slXzCg=;
        b=JVm4X0hUAzu8yCRsWyl+er/uvKhHSuwUP+6LlWgmVSzOPGYk2roPQckjEIKH3EfjL+
         9u/CeDbohWsRPHrVi8XzjyGJcj5zPohYHaBNSfXaDzeTT+KiI3BUhZHcW6Y/miCRQK3x
         Bgdrrgi1MIn+qy4GJtBTrHQOYsYneTFaX/9lwG73TMH5PNNmUsZghtMkL/mogCuj3Gro
         0ey8qxbwCRqZD/X8R1yMgXiCiT4yBoVxjoo2cNLHu4zMWLaVb9cccqiuW8Ph8MkiKGOJ
         nmCvxSG/OC1hgyLplYYkN+GjGK368bcalyB43TPpaJiid832jDmourh5LxCgPMNcEb/V
         qCtQ==
X-Gm-Message-State: AOAM531A+qKgKJrZ6YlV1mQd/jX8c69XyTG5dDRC6wIidxEhp2YOG4UH
        3x/DJAG4mYo2qhZLM9ZNMZk5h2hwF0fGynIo
X-Google-Smtp-Source: ABdhPJzTI/N9ce8FDIZZ/3EZjg9k6gJfawRu011cRWY5nQjLlFf+QmVKP+qzkFt+iIsww0uUOnYb9w==
X-Received: by 2002:a63:1111:: with SMTP id g17mr10385494pgl.267.1620399148769;
        Fri, 07 May 2021 07:52:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f201sm4906383pfa.133.2021.05.07.07.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 07:52:28 -0700 (PDT)
Message-ID: <6095542c.1c69fb81.88828.e622@mx.google.com>
Date:   Fri, 07 May 2021 07:52:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.35
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 124 runs, 1 regressions (v5.10.35)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 124 runs, 1 regressions (v5.10.35)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.35/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f53a3a4808625f876aebc5a0bfb354480bbf0c21 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60951f50e0a73096306f5472

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.35/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.35/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60951f50e0a73096306f5=
473
        failing since 4 days (last pass: v5.10.33, first fail: v5.10.34) =

 =20
