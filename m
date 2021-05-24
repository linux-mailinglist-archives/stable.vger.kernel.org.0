Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D580538E335
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 11:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhEXJYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 05:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhEXJYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 05:24:24 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE24C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 02:22:55 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so10793480pjv.1
        for <stable@vger.kernel.org>; Mon, 24 May 2021 02:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xj5hIQLkt23AixXJ4XbOTdtrFBzCRLq1s+kT1tQyxrk=;
        b=t2B/Cog9+pJBFD1k7vL17puk5PmzRL62Ka43f6juJ7gPSQoddijqfLZ/ykrB5ttVXC
         Uwc0ewd+TEhSb23/E+uGq3YggfdV7d7OaXAtUgBYny1YQVJcywAqVzv6wlMFreT4zxNr
         pcZks5wH9PFmw6lx9usBdKsfDIweFbZyutqKD+n/gLAbAEM6oinevRg3AUWHU9RFh8M0
         0+OygfL/HwjTsXjsBRmLO1gPRguYUNwqAmcBrG90ROELcCtizp2YZcjufvfl/HJYNqUx
         dVCiUZCSslpYQXE7jZxlVv3KXZvx/SQtSAGL93MYOmD9qHj6qmqlMsWvcoDV1X3Mde2W
         Hy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xj5hIQLkt23AixXJ4XbOTdtrFBzCRLq1s+kT1tQyxrk=;
        b=rwj4qIFrOyelJPGT+W1P+wSzuD6Qcd+SOAEDUKqJnfWGYJP/WdQp/jI1+QdjUjoe4W
         coxfRCUkFPTduXkPwopkA8GhTBdTfaOv3rPXuHBVxkY+x3ZasHrCmO5FmHPSRJssII0/
         TywEiK7rmgZn/ELtsTorMMmWk8Y63q1aZksaNUD1//kO4y/w9Gles4tSB72PidQQRrY0
         b8aEpIOTsYMHa3eaDpb7wJePQZjWJEeMc8JHuvnq/xeruKUI3YyXTZFpa75wOes5lOkN
         0JmgEgYAMapiMoKgKzbSm9whDAcKQ9ECut8T1swUltXnAqQIae21CHhmzWKaxfPA2yDZ
         an2w==
X-Gm-Message-State: AOAM530iAMdTghgWgaJ/wNeLnTXCRdXAFnw5KsYOX8QOe2ImX0oMOrHb
        ZLak7gp5xLh7mTiNkeuYqjq1WYYG+oGqYCyt
X-Google-Smtp-Source: ABdhPJyFAXQaM1suk5PdqNwmyLoo37pPbaGjG662VyCUemRQPb2jOM1Mp9xsE75QVX8b1Ra3PBGxRA==
X-Received: by 2002:a17:902:6a84:b029:f3:f285:7d8 with SMTP id n4-20020a1709026a84b02900f3f28507d8mr24108986plk.57.1621848174674;
        Mon, 24 May 2021 02:22:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j4sm13786282pjv.7.2021.05.24.02.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:22:54 -0700 (PDT)
Message-ID: <60ab706e.1c69fb81.ff4a9.d734@mx.google.com>
Date:   Mon, 24 May 2021 02:22:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.5-79-g3f03da12545f
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 118 runs,
 1 regressions (v5.12.5-79-g3f03da12545f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 118 runs, 1 regressions (v5.12.5-79-g3f03da1=
2545f)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.5-79-g3f03da12545f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.5-79-g3f03da12545f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f03da12545f3c12f748f5d5ba1ccc7fc3af9185 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab3a04bc168297e1b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-7=
9-g3f03da12545f/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-7=
9-g3f03da12545f/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab3a04bc168297e1b3a=
fa6
        new failure (last pass: v5.12.5-75-g1796d4e8f240) =

 =20
