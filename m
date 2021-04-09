Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805FA35A584
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 20:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhDISPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 14:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbhDISPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 14:15:14 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A90C061764
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 11:15:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c17so4766083pfn.6
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 11:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tejPCX0X6RPxkV132Sm142VoXAu4xSqb5rzTI4yUYT0=;
        b=BQFlfjxxBmWdWy6bidYO0kPvktEv28w5BZfqfKnKT5plvvdXa8i2Cnk5SfSAIql0GF
         3slVrjGQCaSIYEMjfwb9+RWDn+tyBBTHUPWHn6J7cX/Um60sIUxgiAxwI6EuyVlY7avN
         GHE422UcEnyZttmY6I+wzKBQSBixOjc8YDz6WtV2jYgxS7xSaWrEW29BPvAOF0Jpf/M/
         a/VrsKb5Z3QNen1SszwCSeQqIJnNjnukGpXIcAcPiBbT6Sfv3y0v6JRZGixezHCzWryn
         m+dmCLuTFqLVaMYpE7WJ3Hj0oUJwv1aamm5oNrvRIW/p+r6BEln+rmGTQsbAOI0S1ZyA
         MWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tejPCX0X6RPxkV132Sm142VoXAu4xSqb5rzTI4yUYT0=;
        b=SJMy4ejvTCg2ST/0Xd4P3QECPCOSb7197KZ8odCcPg4zh0jPp8ERjYf8vx12viBDMi
         GrYw8mUWrjIFRE3aF+jY9DWSmdnvvaDCM6MVWea0iqeeBX4iSvqVqXVQJ832+GhZ+K32
         /bnN+mx7GG9T6s5ZDhR4/hgA/dZLpilYoSDvAshM0uAAEcz5Pt+sk1N7A2l97AtyyD/s
         V0+8DM9T3bObqGTgEAezIyuVgBvGe8NKkb+uyVHwz7d4KMU+SWc3oMbew2ZwyKZUo35g
         Wt8rE5I9u+4wncQqcurol8ACNIfFAd8rDsV54DLRO1qiSNExWIf4z5bX61RJXzMMdux0
         MYYQ==
X-Gm-Message-State: AOAM532OFCJ81pv7F4YC16xDU9HR0esAnxQsC90UsVjpIcn+TsMKziw8
        8JPdNJG09/s3Tmy1yqRReWxoByNHIrNOKQ==
X-Google-Smtp-Source: ABdhPJwKxiedTVBYcXneKSRSbDdhlgULznWSili51CPOooyHlb0PjAfKECV+hfm8BcRNFR1XctOqNw==
X-Received: by 2002:aa7:95ae:0:b029:247:b279:9f48 with SMTP id a14-20020aa795ae0000b0290247b2799f48mr3031624pfk.29.1617992101061;
        Fri, 09 Apr 2021 11:15:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm2772551pfd.55.2021.04.09.11.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:15:00 -0700 (PDT)
Message-ID: <607099a4.1c69fb81.9dcc6.7726@mx.google.com>
Date:   Fri, 09 Apr 2021 11:15:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.28-42-g18f507c37f33
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 173 runs,
 1 regressions (v5.10.28-42-g18f507c37f33)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 173 runs, 1 regressions (v5.10.28-42-g18f5=
07c37f33)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.28-42-g18f507c37f33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.28-42-g18f507c37f33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18f507c37f338c5d30f58839060d3af0d8504162 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60706a63123097185adac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
8-42-g18f507c37f33/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
8-42-g18f507c37f33/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60706a63123097185adac=
6c4
        new failure (last pass: v5.10.27-127-g17879c574df0a) =

 =20
