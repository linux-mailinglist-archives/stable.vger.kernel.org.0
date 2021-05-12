Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E815437CF2C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343966AbhELRJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237942AbhELRDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 13:03:18 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0EBC061343
        for <stable@vger.kernel.org>; Wed, 12 May 2021 10:02:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m190so18680404pga.2
        for <stable@vger.kernel.org>; Wed, 12 May 2021 10:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kRcaMpJxPwNbrF36kMpnjEdRO/UuEiTCf6P6nzzPXpY=;
        b=z9WpAAzTXci5hneNI7GbF5lDtRf8f8jD8YzEAA+6Z54oskjp05wVPLYX01Pe+hjZys
         Ikw3Vy88GBmakfby1UzorcrWEbMU60n6gT07+6FkpyohRjnSANA2cygUK31xR3uFlFbg
         dzuKZqISvjBK/85zL3gWESebwhDh8PWGwXuO8l55uD8dW/tEr6OOTSwxHTXDT+n5FPvg
         YLShCtR1cZljxP32r5C8MLVGYWpDNiuAubgGqhRU5GzvuVFLdhSiXqmO53J76KM7FpYR
         Bz72owphLw1xyAODDFAgb2skRG0V+Jcf0nLfdVbDDWM4Kscu+VSU9CwmuFzcnrUXR66K
         6XjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kRcaMpJxPwNbrF36kMpnjEdRO/UuEiTCf6P6nzzPXpY=;
        b=iAsYIE0isvYYoKCHgqiSZxq8R9WkYddQx60GK2BBAdLqBpCIgwQ6hM6WHeZW8g/hA4
         MNBykf3fxae0UrmUcMCKieNpsjOJ5C22KX/pxQrBms7mki/1Ewn17xDDAQ3eCIzkJKXt
         MYn9UVb+CUsRi1KC/DCguTeM9UCNeU6Woe/FNrW4ZQV5mJyy/whGfH5+qeKQug/dC0u5
         jiaZGR1f60ASqPknyr4Sridz5bdl/jh4PhOqsCAENKYoV0CyjImsY7yPR8LNOu1aUgVI
         xgW+jA5eZ/3gtr35mp2TIAiRJa9Rj7bMVKkVooVuT9mUtB+ucpEqugrvclCisbxI17KH
         4+tg==
X-Gm-Message-State: AOAM530O+7qXbt69OTozuEMdCrUqqYiglnaG/Ug/T/RiYqMMzaBsAypY
        1re5mZ+NLGUZUZCagA0LpZf1Ylb1h0mP9pJI
X-Google-Smtp-Source: ABdhPJx6jK31IrPNcvlvnr+fMi0kJYhuH1K1O7c5HfTurfJFlwQ7DGAdKucBFuSWZ2o0MAquSvE82g==
X-Received: by 2002:a63:ee53:: with SMTP id n19mr37596000pgk.268.1620838920186;
        Wed, 12 May 2021 10:02:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v14sm343835pgl.86.2021.05.12.10.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 10:01:59 -0700 (PDT)
Message-ID: <609c0a07.1c69fb81.db83e.1442@mx.google.com>
Date:   Wed, 12 May 2021 10:01:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.11.19-939-gb998056942228
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 165 runs,
 1 regressions (v5.11.19-939-gb998056942228)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 165 runs, 1 regressions (v5.11.19-939-gb9980=
56942228)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-939-gb998056942228/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-939-gb998056942228
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b998056942228aaa90a7498b5fd5fa79327b0fdf =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609bd811e8b87422dcd08f2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
939-gb998056942228/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
939-gb998056942228/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bd811e8b87422dcd08=
f2d
        new failure (last pass: v5.11.19-341-gbeb6df0ce94f6) =

 =20
