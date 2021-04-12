Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7510A35CA05
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 17:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242847AbhDLPgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 11:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240372AbhDLPgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 11:36:50 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFC3C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 08:36:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so9521682pjb.0
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 08:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YR2EHL8Tremh4MWW3TbeAwi8yYfar7JLEpu7k8bOpak=;
        b=0fJrFCCeBLCcATRrLGvtSVy4hox+UbKjdKsTLT5+sMa6UaTDPpwhPwWKajXxlabNSl
         F+KqYCFDkcR2z4rOvz6Jr22SjKiXtUuwX2eRZo9cBcKHPKdgSxVAuV5ol4zdYRE4yUK/
         eN65bXDClSXsYKuuuFDd5B3ylojmhaEeX+MBBV6KWZH+2UwEHFMbxUSJccXSPCkG8Hv3
         RSYqm7VFpVPUZ0DPpHdxbUu1HvJkAZrJTbjsPD3Ym3RkL9A8gZkoXeId9jDLZd2lbYyH
         ggcAVSJL0WUUe3anjG79MPMwcwT0nur0gOD4RbvHAq6Hz3dzmfY7QqJehMYHouZDO6gU
         1KxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YR2EHL8Tremh4MWW3TbeAwi8yYfar7JLEpu7k8bOpak=;
        b=aBG7JFvfFTyGtazGID3KUX7YmX6vpVL2nU9eXYm/kvjVSYY15Oiq+anxR2eSmgqBvR
         dSOlBG+hRA41zidZ+S8jECkbgeGzd85qKcsFLdYg1nJwFUEojUUDnHJunwWYWmcXT24C
         Ors5J46ZBHscuw3AvfAFdA87vtEb56Zr/kTjJL9+SAr6Kv5kFrWdco3aiYRcYAf4qcj3
         grwXaRkZCIaL0AUpNROvhepQ9bfmiwJivTA2pbcUZB9eUJ/cPG7TruA8BzoaTHIzIx+f
         nvx/FtGD84OrhcuwISl2zr9bpXSySJjOkuSRH0gtvTHUzBTGHsYvhXRBITneA1xjaiO7
         bYSw==
X-Gm-Message-State: AOAM532Onlz3YTsypantNhTHGO9jTXNYXzTed+8+ReOadDj2WD3Repmk
        g11ZdlIkeUeK/NmJQnyM9nWRwjxJnXLAIntL
X-Google-Smtp-Source: ABdhPJxyJzUmzMM2AozMqV2Sq/cRIi4sW45JYpCDsLGf2v3SK9kgsai5rL+UtHN5VPTZfYK+2+zPTw==
X-Received: by 2002:a17:902:ec87:b029:e9:8772:6668 with SMTP id x7-20020a170902ec87b02900e987726668mr23638647plg.15.1618241791066;
        Mon, 12 Apr 2021 08:36:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm11822227pgp.47.2021.04.12.08.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 08:36:30 -0700 (PDT)
Message-ID: <607468fe.1c69fb81.7d82b.cc30@mx.google.com>
Date:   Mon, 12 Apr 2021 08:36:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.29-189-g8ac4b1deedaa
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 142 runs,
 1 regressions (v5.10.29-189-g8ac4b1deedaa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 142 runs, 1 regressions (v5.10.29-189-g8ac=
4b1deedaa)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.29-189-g8ac4b1deedaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.29-189-g8ac4b1deedaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ac4b1deedaa507b5d0f46316e7f32004dd99cd1 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607433035c644c10f6dac6b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
9-189-g8ac4b1deedaa/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
9-189-g8ac4b1deedaa/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607433035c644c10f6dac=
6ba
        new failure (last pass: v5.10.29) =

 =20
