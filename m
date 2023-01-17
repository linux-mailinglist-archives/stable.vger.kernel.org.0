Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590C5670B76
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 23:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjAQWMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 17:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjAQWKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 17:10:51 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF1143479
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 12:34:08 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r18so22897036pgr.12
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 12:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QyD2T/MLeduB6D5rkcqn0wpou9eWYF9H4ixGMrPkK0Y=;
        b=n9TwMgFk5Mr/CmQ6UeobmDtHa00CT2XhzchgV6V3Zwb6K3+11BTXmb4pHSAnR0vJz2
         VYXh9SsDOUtWcMEhb43lcKN4U+199dC1XbiWIjTnZ6xJetJADdk6IZa+FzrenLhQh63U
         9RamVbKbO3+UmKzpZmYkvg5CR39O6LVJcSR6Yl+SbXB0MRP9vs/G/wQiSIbrs4fKJrr9
         nouj/9ojcI78oWSkwwKPzcuWHDX4ixc/2wlzSqXAXqwJ59Zd/ADftU/2SWoeD0Cdd5Ag
         SFOu9R96DXB7/ZB2ldcAukvtf9rvmVmzvwVG0ZesCpnQKd+HJ4ZjmxQL+LiuvRTYUKCG
         CpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QyD2T/MLeduB6D5rkcqn0wpou9eWYF9H4ixGMrPkK0Y=;
        b=L+g6tFq8zBGZ3Vnwr9Pn4x6+RpI51vDx4h8jpj+qCqX6TNF7Ry9XzJD2aZ0cTpBvH6
         pbN4TZnRGYkhOnkG5DgvwfxjyBdMMFnt1ns9rftb3N8D/9d0s0BNCfG/ZmNw+h2ndgKM
         90KaqiJaxzIaZlUXp0CBtAKR3h0JFqpOrAakKnvJVI+4umoSaFIR7ijsmmInJGZbiMME
         jGcDIzgN9Frk9hLEJxnn2l2eUvvt1C9Qd3KNtle48Ed9PHRXq9RslW0NttNhhqz7uSM0
         EZB3xTFyQJy6DPnbwacfK3OFvls5auK3MtLBuPALcsnlKBbtNFj0AwwV3nWiNUXkf7jQ
         OATQ==
X-Gm-Message-State: AFqh2kpA1sofE+bn+Lh5qbYxDvorUPJ54nkn5DP1NMDGA9qTxcvTjJzH
        34yx/SsimDluM+dwa017nZaTGtwEPDDrqGQ/STQ=
X-Google-Smtp-Source: AMrXdXvlK48O13y788MlQ3Tg32fYyC4lwGSwauIURYcenUNnGp3JK+tK+2OxR1zsibvGfj4YRlUrmg==
X-Received: by 2002:aa7:9151:0:b0:582:998a:bed5 with SMTP id 17-20020aa79151000000b00582998abed5mr3538242pfi.23.1673987648037;
        Tue, 17 Jan 2023 12:34:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 128-20020a621786000000b0058dbd7a5e0esm3023582pfx.89.2023.01.17.12.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 12:34:07 -0800 (PST)
Message-ID: <63c7063f.620a0220.6ca88.56cf@mx.google.com>
Date:   Tue, 17 Jan 2023 12:34:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.162-852-geeaac3cf2eb3
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 120 runs,
 1 regressions (v5.10.162-852-geeaac3cf2eb3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 120 runs, 1 regressions (v5.10.162-852-gee=
aac3cf2eb3)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162-852-geeaac3cf2eb3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162-852-geeaac3cf2eb3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eeaac3cf2eb302f0b8478a43f9d199b1bea51e15 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63c6ccc2e978d6e78d915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-852-geeaac3cf2eb3/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-852-geeaac3cf2eb3/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c6ccc2e978d6e78d915=
ed0
        failing since 19 days (last pass: v5.10.161-561-g6081b6cc6ce7, firs=
t fail: v5.10.161-575-g2bd054a0af64) =

 =20
