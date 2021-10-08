Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0AA42716F
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 21:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhJHTdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 15:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhJHTdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 15:33:42 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8CCC061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 12:31:46 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id oa4so7626957pjb.2
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 12:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AkGI6PfG66QDyTlLLZwIuaX6cWUSSeNJAi1qSvZWn2Y=;
        b=NG7c+VeaqqJhnvPnrZfF6vIEvpoURnoXdSM2di5nb+5VCQudlKO0Dt0kEMEMm8OdlA
         moEv145kIi7VKaw/tTGtExEHsFFFAUZiwMer66zc5V+2fRFTnJ6+YKBKdCUt+57pnDdg
         SrIiv7WPCF+S3HR61SjckkZG7WHo7KB/7W0AKffzktnrQTH6RtooZvZELRz5fqxQP+3g
         XUhQ898SszpzFuhvngk5rkgg28hY2d/bSbz25JR6rEd63sq/QGZjSwSVqxPdzTZcGiKN
         bn7oAt1YwrPonzLIFehCyqsgYxQb1KyOnQ0SzqgTq+RJd6aEjfQbfIWWjkt1SJ6FpHZg
         LzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AkGI6PfG66QDyTlLLZwIuaX6cWUSSeNJAi1qSvZWn2Y=;
        b=4eWXWOZkd/iB73o8Wbr/xWRZQufMQP4SGnxXP38Z+1RmKtKZA7u8gD2JjhYMq1gqAH
         JYi0jHNE0HW7/zufoSJ0PYauSA5kFfN1DFqG0KYV0qA5H/unK9VrGXaUbFOETcu0h4tN
         3R3OT6aQWJP2R2417/GDltvPynrBYWSMLg3eZcw7CLAKoyz5Lb6z99HiVvXnfkcw9zzd
         zdp1D5t4+dN9t8WK95n0qomu6A518ESORKXEBLdTjA2zEut1MFFsB6ME5k6uPA3JVuN0
         K1S3mpb83xKtr8R3GMa91DEaTKjXPKMdoFOXt+5TC7m9SINiwrF3hUpul5p2NGwnzoRf
         t2sA==
X-Gm-Message-State: AOAM533LOcnTW0QeSutg97dT7RnLtRz8lD9HZQb7dSO1kukklQbuqVq7
        zM+C3QDVw8vFXf9SJR+eGzPoj7hPlhVI50yf
X-Google-Smtp-Source: ABdhPJwThGuNZ9457BN3PVpD2ty802VHpJt6FPEt9SOG3Ll13Q3T88roFrr2z3F4Iha81/HxRegsUw==
X-Received: by 2002:a17:90a:de16:: with SMTP id m22mr13804666pjv.54.1633721506233;
        Fri, 08 Oct 2021 12:31:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4sm63665pjo.0.2021.10.08.12.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 12:31:45 -0700 (PDT)
Message-ID: <61609ca1.1c69fb81.9e097.04b1@mx.google.com>
Date:   Fri, 08 Oct 2021 12:31:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.71-30-g1164874f979f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 171 runs,
 2 regressions (v5.10.71-30-g1164874f979f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 171 runs, 2 regressions (v5.10.71-30-g1164=
874f979f)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.71-30-g1164874f979f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.71-30-g1164874f979f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1164874f979faefe5369c77fc31721dd66dd8d6b =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/616065f3cf97cdfcf799a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1-30-g1164874f979f/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1-30-g1164874f979f/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616065f3cf97cdfcf799a=
2f5
        failing since 98 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61606479a6e766b32e99a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1-30-g1164874f979f/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1-30-g1164874f979f/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61606479a6e766b32e99a=
2f9
        new failure (last pass: v5.10.71) =

 =20
