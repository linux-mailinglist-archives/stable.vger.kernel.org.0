Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88CC32F2F4
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 19:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCESkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 13:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhCESkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 13:40:25 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2979C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 10:40:25 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id j12so2622349pfj.12
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 10:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=awkDMm9fvvaEAbx43FgFI0CboshMMQi1DXXD523wY4I=;
        b=bYFmwkGCvzWZg8Pbf8tAYHduoZwROYYH7NWvtEyWUajZ6vI3l3F/yqm5OOjhgTYsXm
         lhoucjDatqc2VC8SZgcoGVn8v7rOChHKES5WJm7j1cYItcbOzxJ+FJEEeIhlSmWoos8E
         oyMO4m3XNCJjnNKJ/K+nkQRJgk44n8HSYTFeTaDbrVFthvyAGRIEafFch6IXP5XkRVk+
         epTC852DUK4WKIRS3H7OMnGgU4kP0C0r74Rxmmoiyrml3SiDW3A6444jNE9zIqTmAshr
         xnY503SbFSw4l6UrEw9U+XpAsaYVhHey+pMgpI8hCxcqTzB46uWCfnQA6pbxFI1f5Qe2
         tUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=awkDMm9fvvaEAbx43FgFI0CboshMMQi1DXXD523wY4I=;
        b=h4vkeONI+dB2yRymqN+PvZSS5wbu5uAEoCxfGN53GiBx1k45AzDDYT2asz7OBpD8S6
         9OTl/vU0BTfbq7VwSR5P//w3PxTJQcOT00oQLfMLu5hA1JvVEVFjJHsUU1ME5Va4ePry
         l7Gaix6pqNvNyHu3nFeOhlHLLINzW3vev6t++MnSbUJunuMtzF1VkJaSX6nd4O7CsxTD
         Ho8Al/5pv41/zPrK5quZPx9/LNUqiB310iMw3CDdIuSC2Mj0flxClvYnxDTOvNudwv13
         83nxRr3/FlyY1uOvG2fD9PyFGoJztOMxX39qumY6KKosWFcUV6/BrMm83u1Js0t7WhLR
         CABA==
X-Gm-Message-State: AOAM533z7cE+rB5DYewqDhoXMn1Z/UyS/AA0kX1omXL0O2vQyEIjONLs
        ha5MIdOdcFAhzTx+VPlI1yPLhtajHjsgvLMx
X-Google-Smtp-Source: ABdhPJxm4jv8RBsbZIJ75GnLOeq7OS0LPHfhqXZaO60H0WDkrCeQ4Rdms22Y4Gojd7LaaD8+UHNotQ==
X-Received: by 2002:a63:515b:: with SMTP id r27mr9983498pgl.38.1614969625243;
        Fri, 05 Mar 2021 10:40:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m3sm3027415pgk.47.2021.03.05.10.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 10:40:24 -0800 (PST)
Message-ID: <60427b18.1c69fb81.46999.828d@mx.google.com>
Date:   Fri, 05 Mar 2021 10:40:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-102-g5424d9a6593d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 169 runs,
 1 regressions (v5.10.20-102-g5424d9a6593d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 169 runs, 1 regressions (v5.10.20-102-g5424d=
9a6593d)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.20-102-g5424d9a6593d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.20-102-g5424d9a6593d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5424d9a6593d6b15d17767ceb873516be8b57c8a =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60424a294baae503fcaddcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
102-g5424d9a6593d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
102-g5424d9a6593d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60424a294baae503fcadd=
cd1
        new failure (last pass: v5.10.20-99-gd1a9c9965c5f3) =

 =20
