Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468E627967B
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 06:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgIZEC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 00:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbgIZEC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 00:02:26 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2A9C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 21:02:26 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l126so5033200pfd.5
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 21:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0ur4w7Z4sBPa/KZLrb7HiZOguhJUYF/gz9evARQXivQ=;
        b=lkRcH0nxtuRGg6B+2DnaHb6gNbDa9ztAZY191/jNHkUMSQ5RF9sbpMYPX04/DbQDtI
         Dlx4CjUCrz0BvROeBYLACJ17BLGaK41XxlxceFTvaCO6XffX3citC33BfjbGwxQ01yGX
         6cghn/QJWy5mk3sMVqGrrdh7bZ6MfSyoVN7GAala2CfnkqXXB0w4Ws7RAYlVFcVoh8qb
         B5Sfrw5V7u2gmtazJFsRw9VLDXRVQ2Zge0s1DvbfKUyDQB8DnANn4C0ZzQZNMyYUHXYJ
         LtuCYhIJy93jyKs22eb8vVJ7MKDdTpCIdIdyVU/8q0AkomtHwqr2Yz/OvqtVM6rPnoQp
         tdlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0ur4w7Z4sBPa/KZLrb7HiZOguhJUYF/gz9evARQXivQ=;
        b=Hd45lZYKu5kkij3bewrHwBXaUdyn0+IBa1BJFE1zqBGLLg2sd4jytj1w6Qj49yI7PE
         uMoFfzEo207NdxoexoiV8eY0LKUEbQAcLdiGdyBOgDD2LDC7QhhkGwT6J76HoqsSgbJf
         LKxZN/h36BUkxhq4r1B3NNEqGyktdWBk4SCN6IjY/jolkAFmB0tv91+MPJQTHM8XT36l
         L4p1c1e+Zeibc76SCvGUyAGWrpIrciAimGt39imldp1qvS79Jwt90wkNt/5HQWJPX0TZ
         9KAxqTwHwbLyzD9zbJRtKtVWME0GA65K2AdcJY0vmvRJyk/FKs6XlhRwJ/HPBN5mZN6F
         tzpA==
X-Gm-Message-State: AOAM530WW46rrZgvUNDDHnARFk0mNMzJCFpUNyc8gA3iuWbIm3X/Xpuh
        v4spNl2OTnTTubWrt3ee8VvqdojkgsM8Pg==
X-Google-Smtp-Source: ABdhPJzX+Z6DyhrBQBuNCTO+nx/sTsYO5Wl22i6TV6QsOg1YlzvQps3PkYu1WcFLr168UFYnhpPhpg==
X-Received: by 2002:a63:4f10:: with SMTP id d16mr1571337pgb.152.1601092945405;
        Fri, 25 Sep 2020 21:02:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f5sm3572849pfj.212.2020.09.25.21.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 21:02:24 -0700 (PDT)
Message-ID: <5f6ebd50.1c69fb81.885ed.b469@mx.google.com>
Date:   Fri, 25 Sep 2020 21:02:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.147-38-g1e68f3302e6a
Subject: stable-rc/linux-4.19.y baseline: 173 runs,
 1 regressions (v4.19.147-38-g1e68f3302e6a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 173 runs, 1 regressions (v4.19.147-38-g1e6=
8f3302e6a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.147-38-g1e68f3302e6a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.147-38-g1e68f3302e6a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e68f3302e6a25ff4310dbf4f2de747180d01146 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f6e8a6a196bba1291bf9de1

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
47-38-g1e68f3302e6a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
47-38-g1e68f3302e6a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f6e8a6a196bba1=
291bf9de8
      new failure (last pass: v4.19.147)
      2 lines  =20
