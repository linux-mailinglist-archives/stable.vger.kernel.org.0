Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8416E391EE7
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 20:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhEZSVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 14:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbhEZSVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 14:21:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B23C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 11:20:16 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q6so1277143pjj.2
        for <stable@vger.kernel.org>; Wed, 26 May 2021 11:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FaFvZ2EzswRgwA19ARQAfU963lq7CgIzpQXPP0Pj+Vs=;
        b=NvP5jbIFy2Odf4XOF1ojHj91qoa30Be3VM9ufld+Ek6jaesT+fMbEME5Tw3F3sRdaR
         dLmIS43IPdcxeSSM58OCMVlk7PTqVDJntfMWOO0FnKpassCO0YlpxkQDvC4jwiH8/VQ1
         uqNcppTYjVTVCL416Xpi1LBCsdIYLEG8+s9pv9GDhW9Xnf5RE9JPmb4WT84XIjKtY+2y
         v67PZurqdofNrbkbLmG1vJZOp5/WZ9dXude/k0FtuR2M0vy8mGbASTnl6XM58h+cTUf8
         rRYgFMvn/mbGstKMT3zMZkNjM7Y/NaRDEXLYbwjE1Co4WrNYO+h0Zgmfwxa1l0Vf0zLF
         h8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FaFvZ2EzswRgwA19ARQAfU963lq7CgIzpQXPP0Pj+Vs=;
        b=WbVWxScPfe0Z08MIoROuFsv9OwonLqFPxHZpZvMWG9TbdiuI5qUUm2tGIKciwm3rud
         UPWTHKxKd2aOH0mN2ztDjSEjICyGtFtbK1oNvnSSRwK2x3QL0unBEQMFMpu0SsISc5zl
         sp61SI0+qN8B6CuFBNW0tDWSegKyOXFk491Xg4THf/YxarXTzT9MA3U/nbXTgSRCsUsg
         DzO60D8tyEbxbQ7pcqdVdWMxnBclx2cHhqDawNOs+VlayqOPeC42nNRRrTPvcid7CT6G
         jo1EKcxTGJRg3b1knVWOKk3wf1pi/s/e0Bh9xT0vMutgkeBuLj7L4cJKgi1JT+8M8Tn1
         XajA==
X-Gm-Message-State: AOAM530gq2k+r78C5vYEVEE1LB6jTJDO1OL5bqNOYBQf7cr1cFp5NYR/
        Z1C8x+Cz1UhTa57Oi8tP2N+dQssDMjxxbM4B
X-Google-Smtp-Source: ABdhPJwjhP09zgBFLas9JHToZLxE319jwjkbSeyk2l+WD303NPxgj30R92k6isMrb0fwl734rRM0jw==
X-Received: by 2002:a17:90a:6c97:: with SMTP id y23mr38591655pjj.174.1622053215776;
        Wed, 26 May 2021 11:20:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x21sm16682142pfr.124.2021.05.26.11.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 11:20:15 -0700 (PDT)
Message-ID: <60ae915f.1c69fb81.fe383.5ec8@mx.google.com>
Date:   Wed, 26 May 2021 11:20:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.12.7
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.12.y baseline: 81 runs, 1 regressions (v5.12.7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 81 runs, 1 regressions (v5.12.7)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.7/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      55c17a63e51a668438d3d9fa5ff8ef959fe90a4c =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60ae618e27dbe0a74fb3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.7/ar=
m64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.7/ar=
m64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae618e27dbe0a74fb3a=
f98
        new failure (last pass: v5.12.6) =

 =20
