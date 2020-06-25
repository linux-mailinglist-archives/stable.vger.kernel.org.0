Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705DD2098CA
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 05:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389239AbgFYDja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 23:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388485AbgFYDja (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 23:39:30 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65ABC061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 20:39:29 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id a127so2364738pfa.12
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 20:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8dp3Zq7gBgHaAOOguV/e641pIrF/UMgy1e6Fjvt5Oh4=;
        b=f1cdhJGQM9Uo7Q7h0qo+ahr3JNgEjX+JH2YYtcR/7cIkPHcxC7Q6lZBAI7AeW7iPuY
         Uy2sdLdSF7OtbK5p/oi4QT5kacNYvr3k7baIQQV0sNcXQhFQnJdwAvtahLxfh2DahNPG
         L0cq/Cw9ANJ7a99ZRqbC3iZ0MQJFV00i8sTztYUwM3rcmXlBZbYGiaquPPIdREOKgWHx
         n5O15B36K5wMW8YikX+YvmCFSOHvUIgW4bPPdvc9cWb2nJJ/N+aUm0aqHrMeCqynVT++
         18iI9oC0G1jQQ5E8hY+TEOrs0QGq4qRcf8zjSyWV0Hj+R6jQLSmf/7hJvqO5yKBkaauk
         5/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8dp3Zq7gBgHaAOOguV/e641pIrF/UMgy1e6Fjvt5Oh4=;
        b=koi3NNy+4Ley78KFXd0wtF5rkqUFga74Fx/5/dgScuhiZHu25mK6nu7TYAil8NyFj1
         LH+UoFGvi/O2wQZD8AITDiUgVoJS9W/HuW/ssKaXLXc9IwcpH9C3lu7xezsL00klP7Yk
         bb2yKeIovIzYHTSCVNgcgtMY4rry4+CJXLdDqdAZLbI2U8Im213Xe1JoYnJCIz9ZutqN
         0uBt4TuMJcMCWD61Rlafe7MJfRlsgshWmCJqaJwVGplaHHEyx2ebvfb+BS5mCGDe9Xv7
         seT/lRTv8NZ5R4giMfYW/OXfomAxTINaU/siMpN/hkZZakvxXK5Eu7PJCVMl5cwsUJd4
         /wrw==
X-Gm-Message-State: AOAM5307ZMyep7ey+socSOsNKCR8sjsJ7uy7++ht3Gj21rkergOiyZMX
        lDiDiRepkq2HFG94BwzzNL9Oi/1GG9c=
X-Google-Smtp-Source: ABdhPJxb6Rr4uLVXo9ubLpqwmzmK8pIADehixitafHJNpYHZg9MmSpVygJ6cO9g7PYyKy+ONG2XJUA==
X-Received: by 2002:a62:ce46:: with SMTP id y67mr7279022pfg.118.1593056368893;
        Wed, 24 Jun 2020 20:39:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b24sm12170120pgn.8.2020.06.24.20.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 20:39:28 -0700 (PDT)
Message-ID: <5ef41c70.1c69fb81.d76c5.41e8@mx.google.com>
Date:   Wed, 24 Jun 2020 20:39:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.19
Subject: stable-rc/linux-5.6.y baseline: 65 runs, 1 regressions (v5.6.19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y baseline: 65 runs, 1 regressions (v5.6.19)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kern=
el/v5.6.19/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.6.y
  Describe: v5.6.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      61aba373f5708f2aebc3f72078e51949a068aa6f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ef3eaf940805f0eec97bf95

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.19/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.19/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ef3eaf940805f0e=
ec97bf98
      new failure (last pass: v5.6.16-245-gb60e06c98873)
      1 lines =20
