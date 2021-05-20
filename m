Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A5C389B47
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 04:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhETCRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 22:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhETCRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 22:17:08 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49ACC061574
        for <stable@vger.kernel.org>; Wed, 19 May 2021 19:15:46 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i6so3298203plt.4
        for <stable@vger.kernel.org>; Wed, 19 May 2021 19:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=daOhz9GAfLErYv/H+9WUtp04Y0rR0cDs+5oI94f8b1M=;
        b=YCSjn6g2HRwA2edk/wdoIAtZHFOxLyIzbDS881kMljX3MuZBGmR3lJwRVo0chQMSyv
         nFzxVm6fYB5dS/gRTeu0g/DBk6LENiXm1Kx+qZeG6PzKgdxs3+vB4Rjn2IOYln9CgAoN
         UR7uB/jDr6iuxU8SDe2Qos1g8pQS8V4Ip62mvW+53d5YaLNvxhNXUttBjhYTVe1PEP0v
         0zHN3xI8Qmp02S43+H5s2CXSzWBDkmjDRa874FMlK7AL0jUzDCGzS6T5nTBd1wQ8n+TW
         FCadIYQhCEoGk3jajLu1PIpAEMfADFkBQ6/gzpVaXFFqtGKkoZ+m8mDgvvoRr0U8sMRn
         nbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=daOhz9GAfLErYv/H+9WUtp04Y0rR0cDs+5oI94f8b1M=;
        b=dlu+IMuEt5nJWu530233szxIbzuyuOohaI4/WZgvB9CahcQTZGbZ93QIoynaAy4ZrF
         xuPbGQpiwNwiNUJCqa5OOKbh0B7fvFB5XBO5qCBxSyIlu86gnCu+UbAoBCWaZgHHaFA4
         V8zriDja+d7R/VP/jxIKc0kRIGGpY0+ZgcgfiziKFWCvp1auSBtP63lGq0KqClkE22nd
         JAjsRv0ZjUvzKjdJ7/dS4ork01kEEPf4WxaSwvZTQVEbCXAp924FUsdw60pj2Y/0GnJG
         9QnHLSKXMKkgUYwqXbv8+xJTD+P2b3pqjtt6vYWuUtfnMf5rOCo0Wu0lPMMbZABCoSmy
         MCtw==
X-Gm-Message-State: AOAM533FoV8K4aAlLZyEEWULX1uP0gr7JcBCKMcadDkE/QZB2QwDQMST
        SJ/Z7ASu1gnHOjYOzPptZOBN79lHd4USOJIn
X-Google-Smtp-Source: ABdhPJyqxhqvxYHFwA5h+JryLEyUz/L2ErC/CWqAUb59rjNlPycKhQFG/8HWTQrAT+lzk9Q97XLpdg==
X-Received: by 2002:a17:90a:c285:: with SMTP id f5mr2521035pjt.221.1621476945230;
        Wed, 19 May 2021 19:15:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a2sm485627pfv.156.2021.05.19.19.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 19:15:44 -0700 (PDT)
Message-ID: <60a5c650.1c69fb81.cbe99.2cf7@mx.google.com>
Date:   Wed, 19 May 2021 19:15:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.22
X-Kernelci-Branch: linux-5.11.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.11.y baseline: 125 runs, 1 regressions (v5.11.22)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.11.y baseline: 125 runs, 1 regressions (v5.11.22)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.11.y/ker=
nel/v5.11.22/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.11.y
  Describe: v5.11.22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef8aed2fffe03c394547dde0cf3590f98555827f =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a592966c25e6bee5b3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
2/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.2=
2/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a592966c25e6bee5b3a=
fb2
        failing since 2 days (last pass: v5.11.21-311-g7cfd36cbe8c6, first =
fail: v5.11.21-330-g6d09fa399bd5) =

 =20
