Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2583E0DF7
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 08:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhHEGMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 02:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhHEGMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 02:12:42 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C62C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 23:12:28 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k2so5785892plk.13
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 23:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EtaXybmXvDNDRD9eAXwpJ+oUjFD7TDAifxVEHxSKjLw=;
        b=OBg7B9Za8oAXgl1WEdcVv6JWNc+WcGBM8AtX0tznFjNJYiCXW3uLgJ4DvLxNNtSIR0
         a5/2uYdmPzeBntukMk+nKdgiqFoh9rY9c65Dz/7Qro7TGQEahf5Fm28GMiMlKEweauH1
         N2d951osZmWAcxhfyr+6W1je2+5SLOC+FZJFvPcDBxfTNQz9lpJGxLhwcNC8aBn9XJ/W
         /10kEky7EtQ9N7Al2zI2IhEuF8KPcR9ptC+19dWCYLNhjDU82+Juiq7Qet5OTBGZkDHX
         2es3Wrfx/OFufZCD5AkwQaNjMx8mOvDo2H916Wtdp7aJO0KgWNeZcuD5OIWrjU6ESka6
         x4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EtaXybmXvDNDRD9eAXwpJ+oUjFD7TDAifxVEHxSKjLw=;
        b=XMrSg+jcBNVwqrR4DRuIMPaCP0slJjTPYKuCvRppQHbx46eA4xStdaSLd5q+iVXJiZ
         S6byHYlk94JP+92mUrvx5uUzV5shCHcdxnRzfBpSV+OXo/ZMaJWOYxFOVIT1G/qsutkn
         2mbLuuUV1H0QAxHyAMLcokk00MZ/m4UT47dTa5oGhvwf66StrG9tWrPUflAVaCv/C2o0
         OTqQzca02SbhyHxKRIv+gJpksAD4FU+MF2VGH52KrH20VeErIcdnJhW2qKZIZXwyUfrr
         syEvRIqgjJnKl3lgoDC18tXZKbi2DlLQTlEidhU9laylvSbEBoH7vYb8yNOsEwGs7ruD
         GKYg==
X-Gm-Message-State: AOAM530KqS7XuVp8+Jb3Ix2TsVHTK4suF8d5ERbY0z+CwQV4oD9U5pSq
        7dmQsfGgXj9f9TEutVrNmxGFwerebaP97koOH4Y=
X-Google-Smtp-Source: ABdhPJyqKnpIfkdFrR8JtaXgPi1Cb7ik54Z9eedVJhQCHv1I0WXgEqFiwada3fE4dFjvoVNjbY/pow==
X-Received: by 2002:aa7:921a:0:b029:2cf:b55b:9d52 with SMTP id 26-20020aa7921a0000b02902cfb55b9d52mr3442171pfo.35.1628143948168;
        Wed, 04 Aug 2021 23:12:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r18sm6654997pgk.54.2021.08.04.23.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 23:12:27 -0700 (PDT)
Message-ID: <610b814b.1c69fb81.b34b8.3925@mx.google.com>
Date:   Wed, 04 Aug 2021 23:12:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.56
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 115 runs, 1 regressions (v5.10.56)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 115 runs, 1 regressions (v5.10.56)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.56/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.56
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9746c25334cb364ab6651ee6dfd4cab3218d0c06 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b4cb94dfe228550b13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.56/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.56/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b4cb94dfe228550b13=
664
        new failure (last pass: v5.10.54) =

 =20
