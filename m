Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388E1373C72
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 15:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhEENeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 09:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbhEENeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 09:34:09 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446DBC061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 06:33:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m124so1765006pgm.13
        for <stable@vger.kernel.org>; Wed, 05 May 2021 06:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lij9/RWjaP2/iTC12ie62pIgia0qHT5R3Kz8gHmVwZ4=;
        b=vUTdMmM9jelxffNDsqjgwETJDB/FEdlbKbXM6I+S+AHMIZd8jtur3ad0Edt31280IB
         4J6r5OdmQJJYMn8qXv+duw+Xn8S9X/MBbh0vpXYxTTn4oxdTzx/xVbwczhZLVRe1j8Gh
         R3qAg+dXZRaswVdEjGkdWvT16cf2TcKWbcWYx9grubRcCp8QQOsuXAJvomHbNiNw8vPS
         KaaAzpeeDtAJUkl9Wy859+BBpp/xkQfUnyP/WsH+RgSiIgRyuOorlXRKwoWGccGNuHsG
         KbonV9WjNDS4wNNdOCdtsA/QaIiTCEIhglkaWn3Bh/v358ESt05dohVUKsusUqFv9hza
         EG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lij9/RWjaP2/iTC12ie62pIgia0qHT5R3Kz8gHmVwZ4=;
        b=fqSHrMVru3v8M1gMWm5LrL7lnlZWybN93eQ3xLhguY24Noo+pNlwED5uZ5kMRSa5wP
         2OSl0jHwMk1wFFuRz0iaZz66YLNFaehEeMiOFaECAq7rWwhrkJZZ9+4opEp/h4IDxv5t
         oTfthig93bUaV0JbzxVY2OeMpkhBmw3EdWtOe94MPMnv7oscKIrfb2KlAgva1dkZA6Xk
         8ZoE2C9prESJsA9wZUh8iOGTUtaTSrM93KipTtgOCZtmlzsckEHsMjk0lY5OD3Xu61zZ
         0hl3XogJy14zeCtv7Zl0A0Tfyj1S7IZ8gW0sdehHolj8+B+h8rLmF9Mlk3yMiYFvNlKI
         9lFA==
X-Gm-Message-State: AOAM530BQNOeUaWDS39PJhnmwoPvRMj2KYw+5jyoQEzCqIP1OKje6BoN
        potwvFXsOmSwugPYQ3l63rezuUO5FxtzbFG9
X-Google-Smtp-Source: ABdhPJxo4w6G1HTq730Yr9natEO5P1OdcBkXVph+VgI+7X1+32/dPZ2bKuZifNFw227MVUFxA2H6TA==
X-Received: by 2002:a63:4559:: with SMTP id u25mr29136805pgk.93.1620221592560;
        Wed, 05 May 2021 06:33:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a20sm15527321pfc.186.2021.05.05.06.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 06:33:12 -0700 (PDT)
Message-ID: <60929e98.1c69fb81.246e3.7915@mx.google.com>
Date:   Wed, 05 May 2021 06:33:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.18-31-g2265d2b2a27f7
X-Kernelci-Branch: linux-5.11.y
Subject: stable-rc/linux-5.11.y baseline: 87 runs,
 1 regressions (v5.11.18-31-g2265d2b2a27f7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.11.y baseline: 87 runs, 1 regressions (v5.11.18-31-g2265d=
2b2a27f7)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.11.y/ker=
nel/v5.11.18-31-g2265d2b2a27f7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.11.y
  Describe: v5.11.18-31-g2265d2b2a27f7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2265d2b2a27f7486673076be9d9bc82d9c5bd0f3 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60926c35cdd29cc2c76f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
8-31-g2265d2b2a27f7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.11.y/v5.11.1=
8-31-g2265d2b2a27f7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60926c35cdd29cc2c76f5=
46b
        new failure (last pass: v5.11.18-9-g7c5623736e0c) =

 =20
