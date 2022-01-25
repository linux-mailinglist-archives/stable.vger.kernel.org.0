Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C113749AD76
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 08:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444053AbiAYHSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 02:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442916AbiAYHMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 02:12:12 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C57C061375
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 22:17:42 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so1214290pjt.5
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 22:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d7gfla31vm+5t5jJyzx0pB99otoeIVscekd1sRy6/pw=;
        b=38cewBs9nGCB0p9LXRyOG6BIsuLcTmE02Ix5NaLoH8MUXLjmSww95BsK70LANZLKfb
         /Z4ja8tTcfucjsJYPRgVgxmVFzLdZMwM2/1CE8g6FifRQX8PhZsR7SLXG3i78msqKWh+
         b2Pus4WFf7CpIYA2wm7l25Oz1bmF0MRDxD2/ymQwqJmKQyxzVhsPOEOzi+KWhWL0nf3X
         DL75QS5K+U6Mr9VjAXDafO6QlunE2K2Bbk3MBYbU+tkuSX3n3t/w1hSMfhLpP2tAlJTw
         zZLiFgHuriPkyO9ax+rsc74AhpTDpLzGpRabG5u/ptArpzNE64XDyNKLYFA0ntdiPi0M
         0kZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d7gfla31vm+5t5jJyzx0pB99otoeIVscekd1sRy6/pw=;
        b=6OjgekWCnPMUh5TdAl29dM8TZYVcZptZGctwloGTWSA07qJRQFdeqmUEfPFEFGurJp
         mZAp1iRLDDphp2jrpOwU22QTOqu8Yy0o5qc8D8q5aBLAkBuMHZRmtgs74Ehgl3He5CyU
         JCzeQmjbAJzkie+stb1vY4aZOyx2gTr86sv67VxPWBXhrFCzssIRkTxxGrE2i9vw6aA0
         L6yHVxROd9ohraeTLIspFuakU4Hl+qjYInpAWHrSKTuZH9OO2QrmxuTfKtceJxHtabCY
         SJMCRHXjmg1IH+FnYccWK27DHyZ12DoD8mFtcsRIXr0v3EP7JWj2/yukz4jv7KAwfQes
         Hz9g==
X-Gm-Message-State: AOAM530cSJt2PWxks8DDPRgvF4CXPQikccp08/NZxSOTjJNXSgfoyf/I
        oZ7TDVVt1RZakBMXFm9nsMCw5xiJ24FS8L12
X-Google-Smtp-Source: ABdhPJzMnlHwZHIRX1SyOcyOHsh/Tib+RrwGMHAEAze1bFtK1tvN1wRzvnkCo049t0GzjETAazR85w==
X-Received: by 2002:a17:90a:1b0d:: with SMTP id q13mr2018847pjq.14.1643091462195;
        Mon, 24 Jan 2022 22:17:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n22sm17760664pfu.160.2022.01.24.22.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 22:17:41 -0800 (PST)
Message-ID: <61ef9605.1c69fb81.e19d4.22a2@mx.google.com>
Date:   Mon, 24 Jan 2022 22:17:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-1040-gc346931ae40e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
Subject: stable-rc/linux-5.16.y baseline: 158 runs,
 1 regressions (v5.16.2-1040-gc346931ae40e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 158 runs, 1 regressions (v5.16.2-1040-gc34=
6931ae40e)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.2-1040-gc346931ae40e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.2-1040-gc346931ae40e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c346931ae40ee726566101ff8b454309fef22be3 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61ef5dc596c0190064abbd23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
-1040-gc346931ae40e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
-1040-gc346931ae40e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef5dc596c0190064abb=
d24
        failing since 0 day (last pass: v5.16.2, first fail: v5.16.2-1041-g=
bb0f7c24685b) =

 =20
